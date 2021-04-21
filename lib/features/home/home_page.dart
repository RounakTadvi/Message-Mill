// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:message_mill/features/conversation/pages/recent_conversation_page.dart';
import 'package:message_mill/features/profile/profile_page.dart';
import 'package:message_mill/features/search/pages/search_page.dart';

/// Home Page (Entry Point For Authenticated Users)
class HomePage extends StatefulWidget {
  // ignore: public_member_api_docs
  const HomePage({Key? key})
      : super(
          key: key,
        );

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late double _deviceHeight;
  late double _deviceWidth;
  late TabController _tabController;

  final List<Tab> _tabs = <Tab>[
    const Tab(
      icon: Icon(
        Icons.people_outline,
        size: 25,
      ),
    ),
    const Tab(
      icon: Icon(
        Icons.chat_bubble_outline,
        size: 25,
      ),
    ),
    const Tab(
      icon: Icon(
        Icons.person_outline,
        size: 25,
      ),
    ),
  ];

  @override
  void initState() {
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: 1,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: true,
        title: const Text(
          'Message Mill',
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          tabs: _tabs,
        ),
      ),
      body: _tabBarPages(),
    );
  }

  Widget _tabBarPages() {
    return TabBarView(
      controller: _tabController,
      children: <Widget>[
        SearchPage(
          deviceHeight: _deviceHeight,
          deviceWidth: _deviceWidth,
        ),
        RecentConversationPage(
          deviceHeight: _deviceHeight,
          deviceWidth: _deviceWidth,
        ),
        ProfilePage(
          deviceHeight: _deviceHeight,
          deviceWidth: _deviceWidth,
        ),
      ],
    );
  }
}
