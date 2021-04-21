// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

// Project imports:
import 'package:message_mill/features/conversation/pages/conversation_page.dart';
import 'package:message_mill/features/conversation/widgets/user_avatar_widget.dart';
import 'package:message_mill/models/contact.dart';
import 'package:message_mill/services/database_service.dart';
import 'package:message_mill/services/firebase_auth_service.dart';

/// Search Page
class SearchPage extends StatefulWidget {
  // ignore: public_member_api_docs
  const SearchPage({
    required this.deviceHeight,
    required this.deviceWidth,
    Key? key,
  }) : super(
          key: key,
        );

  /// Device Height
  final double deviceHeight;

  /// Device Widgth
  final double deviceWidth;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: _buildSearchPage(),
    );
  }

  double get deviceHeight => widget.deviceHeight;
  double get deviceWidth => widget.deviceWidth;

  String query = '';

  List<Widget> _buildSearchPage() {
    return <Widget>[
      Flexible(
        child: _buildSearchField(),
      ),
      Expanded(
        flex: 2,
        child: _searchBody(),
      ),
    ];
  }

  Widget _buildSearchField() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: deviceHeight * 0.02),
      child: TextField(
        autocorrect: false,
        style: const TextStyle(color: Colors.white),
        onSubmitted: (String _query) {
          setState(() {
            query = _query;
          });
        },
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          labelText: 'Search',
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _searchBody() {
    final User? user =
        Provider.of<AuthBase>(context, listen: false).currentUser;
    return StreamBuilder<List<Contact>?>(
      stream: DBService.instance.searchUsers(query),
      builder: (BuildContext context, AsyncSnapshot<List<Contact>?> snapshot) {
        final List<Contact>? searchedUsers = snapshot.data;

        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong '),
          );
        }
        if (snapshot.connectionState == ConnectionState.active) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (searchedUsers != null) {
          searchedUsers.removeWhere(
            (Contact c) => c.id == user?.uid,
          );
          return searchedUsers.isNotEmpty
              ? Container(
                  child: ListView.builder(
                    itemCount: searchedUsers.length,
                    itemBuilder: (BuildContext context, int i) {
                      final Contact userData = searchedUsers[i];

                      final DateTime currentTime = DateTime.now();
                      bool isUserActive = !userData.lastseen!.toDate().isBefore(
                            currentTime.subtract(
                              const Duration(seconds: 1),
                            ),
                          );

                      final String? recepientID = userData.id;

                      return ListTile(
                        onTap: () {
                          final User? user =
                              Provider.of<AuthBase>(context, listen: false)
                                  .currentUser;
                          DBService.instance.createOrGetConversartion(
                            user!.uid,
                            recepientID!,
                            (String _conversationID) async {
                              await Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => ConversationPage(
                                    chatID: _conversationID,
                                    receiverID: recepientID,
                                    receiverName: userData.name!,
                                    receiverImage: userData.image,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        title: Text(userData.name ?? ''),
                        leading: UserAvatarWidget(
                          imageUrl: userData.image,
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            isUserActive
                                ? const Text(
                                    'Active Now',
                                    style: TextStyle(fontSize: 15.0),
                                  )
                                : const Text(
                                    'Last Seen',
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                            isUserActive
                                ? Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  )
                                : userData.lastseen != null
                                    ? Text(
                                        timeago.format(
                                          userData.lastseen!.toDate().toLocal(),
                                        ),
                                        style: const TextStyle(fontSize: 15.0),
                                      )
                                    : const Text(''),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : const Text('No Users Found');
        } else {
          debugPrint('null ');
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
