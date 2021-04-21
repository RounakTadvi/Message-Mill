// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

// Project imports:
import 'package:message_mill/features/conversation/widgets/message_text_field.dart';
import 'package:message_mill/features/conversation/widgets/user_avatar_widget.dart';
import 'package:message_mill/models/conversation.dart';
import 'package:message_mill/models/message.dart';
import 'package:message_mill/services/cloud_storage_service.dart';
import 'package:message_mill/services/database_service.dart';
import 'package:message_mill/services/firebase_auth_service.dart';
import 'package:message_mill/services/media_service.dart';

/// Conversation Page (Chat Window)
class ConversationPage extends StatefulWidget {
  // ignore: public_member_api_docs
  const ConversationPage({
    required this.chatID,
    required this.receiverID,
    required this.receiverName,
    this.receiverImage,
    Key? key,
  }) : super(
          key: key,
        );

  /// Chat ID
  final String chatID;

  /// Receiver ID
  final String receiverID;

  /// Receiver Image
  final String? receiverImage;

  /// Receiver Name
  final String receiverName;

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  String get name => widget.receiverName;
  String get chatID => widget.chatID;
  String? get image => widget.receiverImage;

  late double _deviceHeight;
  late double _deviceWidth;

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  String get _messageText => _controller.text;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(31, 31, 31, 1.0),
        title: Text(name),
        centerTitle: true,
      ),
      body: _buildConversationPage(),
    );
  }

  Widget _buildConversationPage() {
    return Stack(
      clipBehavior: Clip.antiAlias,
      children: <Widget>[
        _buildMessageBody(),
        Align(
          alignment: Alignment.bottomCenter,
          child: _buildMessageTF(),
        ),
      ],
    );
  }

  Widget _buildMessageBody() {
    final User? user =
        Provider.of<AuthBase>(context, listen: false).currentUser;
    return Container(
      height: _deviceHeight * 0.75,
      width: _deviceWidth,
      child: StreamBuilder<Conversation?>(
        stream: DBService.instance.getConversation(chatID),
        builder: (BuildContext context, AsyncSnapshot<Conversation?> snapshot) {
          Timer(
            const Duration(
              milliseconds: 50,
            ),
            () => <void>{
              _scrollController
                  .jumpTo(_scrollController.position.maxScrollExtent)
            },
          );
          final Conversation? conversation = snapshot.data;
          if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          if (conversation != null) {
            debugPrint(conversation.toString());
            if (conversation.messages!.isNotEmpty) {
              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                itemCount: conversation.messages!.length,
                itemBuilder: (BuildContext context, int i) {
                  final Message? msg = conversation.messages?[i];
                  debugPrint(msg.toString());
                  bool isCurrentUserMessage = msg?.senderID == user?.uid;
                  return _messageListViewChild(isCurrentUserMessage, msg);
                },
              );
            } else {
              return const Center(
                child: Text('Start a conversation by sending a message'),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _messageListViewChild(bool isCurrentUserMessage, Message? msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: isCurrentUserMessage
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: <Widget>[
          !isCurrentUserMessage
              ? UserAvatarWidget(imageUrl: image)
              : Container(),
          SizedBox(
            width: _deviceWidth * 0.02,
          ),
          msg?.type == MessageType.text
              ? _textMessageBubble(
                  isOwner: isCurrentUserMessage,
                  message: msg?.content ?? '',
                  timeStamp: msg?.timestamp,
                )
              : _imageMessageBubble(
                  imageUrl: msg!.content,
                  isOwner: isCurrentUserMessage,
                  timeStamp: msg.timestamp,
                ),
        ],
      ),
    );
  }

  Widget _textMessageBubble({
    required String message,
    required bool isOwner,
    required Timestamp? timeStamp,
  }) {
    List<Color> _colorScheme = isOwner
        ? const <Color>[
            Colors.blue,
            Color.fromRGBO(42, 117, 188, 1.0),
          ]
        : const <Color>[
            Color.fromRGBO(69, 69, 69, 1.0),
            Color.fromRGBO(43, 43, 43, 1.0)
          ];
    return Container(
      height: _deviceHeight * 0.08,
      width: _deviceWidth * 0.75,
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            15.0,
          ),
          gradient: LinearGradient(
            colors: _colorScheme,
            stops: <double>[0.30, 0.70],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          )),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(message),
          if (timeStamp != null)
            Text(
              timeago.format(timeStamp.toDate()),
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
        ],
      ),
    );
  }

  Widget _imageMessageBubble({
    required String imageUrl,
    required bool isOwner,
    required Timestamp? timeStamp,
  }) {
    List<Color> _colorScheme = isOwner
        ? const <Color>[
            Colors.blue,
            Color.fromRGBO(42, 117, 188, 1.0),
          ]
        : const <Color>[
            Color.fromRGBO(69, 69, 69, 1.0),
            Color.fromRGBO(43, 43, 43, 1.0)
          ];
    DecorationImage _image = DecorationImage(
      image: CachedNetworkImageProvider(imageUrl),
      fit: BoxFit.cover,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            15.0,
          ),
          gradient: LinearGradient(
            colors: _colorScheme,
            stops: <double>[0.30, 0.70],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          )),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            height: _deviceHeight * 0.30,
            width: _deviceWidth * 0.40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: _image,
            ),
          ),
          if (timeStamp != null)
            Text(
              timeago.format(timeStamp.toDate()),
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageTF() {
    final User? user =
        Provider.of<AuthBase>(context, listen: false).currentUser;
    return Container(
      height: _deviceHeight * 0.08,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(43, 43, 43, 1.0),
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.04,
        vertical: _deviceHeight * 0.03,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          MessageTextField(
            focusNode: _focusNode,
            onEditingComplete: postEnabled
                ? () {
                    DBService.instance.sendMessage(
                      chatID,
                      Message(
                        content: _messageText,
                        timestamp: Timestamp.now(),
                        senderID: user!.uid,
                        type: MessageType.text,
                      ),
                    );
                  }
                : null,
            controller: _controller,
            deviceWidth: _deviceWidth,
            onChanged: (_) => _updateState(),
          ),
          _sendButton(),
          _imageActionButton(),
        ],
      ),
    );
  }

  Widget _sendButton() {
    final User? user =
        Provider.of<AuthBase>(context, listen: false).currentUser;
    return Container(
      height: _deviceHeight * 0.05,
      width: _deviceHeight * 0.05,
      child: IconButton(
        icon: const Icon(
          Icons.send,
          color: Colors.white,
        ),
        onPressed: postEnabled
            ? () {
                DBService.instance.sendMessage(
                  chatID,
                  Message(
                    content: _messageText,
                    timestamp: Timestamp.now(),
                    senderID: user!.uid,
                    type: MessageType.text,
                  ),
                );
                _controller.clear();
                FocusScope.of(context).unfocus();
              }
            : null,
      ),
    );
  }

  Widget _imageActionButton() {
    final User? user =
        Provider.of<AuthBase>(context, listen: false).currentUser;
    return Container(
      height: _deviceHeight * 0.05,
      width: _deviceHeight * 0.05,
      child: FloatingActionButton(
        onPressed: () async {
          final File? _image =
              await MediaService.instance.getImageFromLibrary();
          if (_image != null) {
            final TaskSnapshot? _result =
                await CloudStorageService.instance.uploadMediaContent(
              user!.uid,
              _image,
            );
            if (_result != null) {
              final String imgUrl = await _result.ref.getDownloadURL();
              await DBService.instance.sendMessage(
                chatID,
                Message(
                  content: imgUrl,
                  senderID: user.uid,
                  timestamp: Timestamp.now(),
                  type: MessageType.image,
                ),
              );
            }
          }
        },
        child: const Icon(
          Icons.camera_enhance,
        ),
      ),
    );
  }

  bool postEnabled = false;
  void _updateState() {
    setState(() {
      if (_controller.text.trim() == '') {
        postEnabled = false;
      } else {
        postEnabled = true;
      }
    });
  }
}
