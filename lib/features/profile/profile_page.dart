// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:message_mill/core/platform_widgets/platform_alert_dialog.dart';
import 'package:message_mill/models/contact.dart';
import 'package:message_mill/services/database_service.dart';
import 'package:message_mill/services/firebase_auth_service.dart';

/// Profile Page
class ProfilePage extends StatefulWidget {
  // ignore: public_member_api_docs
  const ProfilePage({
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
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return _buildProfilePage();
  }

  Widget _buildProfilePage() {
    final User? user =
        Provider.of<AuthBase>(context, listen: false).currentUser;
    return StreamBuilder<Contact?>(
      stream: DBService.instance.getUserData(user?.uid),
      builder: (BuildContext context, AsyncSnapshot<Contact?> snapshot) {
        final Contact? contact = snapshot.data;
        if (contact != null) {
          debugPrint(contact.image);
        }
        if (snapshot.hasError) {
          if (snapshot.error is SocketException)
            return const Center(
              child: Text('Something went wrong'),
            );

          return const Center(
            child: Text('Something went wrong'),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return Align(
            child: SizedBox(
              height: widget.deviceHeight * 0.50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _buildProfileAvatar(contact?.image),
                  _buildNameWidget(contact?.name ?? ''),
                  _buildEmailWidget(contact?.email ?? ''),
                  _buildLogoutButton(),
                ],
              ),
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildProfileAvatar(String? imageUrl) {
    double imgRadius = widget.deviceHeight * 0.20;
    if (imageUrl == null) {
      return Container(
        height: imgRadius,
        width: imgRadius,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(60),
          child: SvgPicture.asset('assets/user.svg'),
        ),
      );
    }

    return Container(
      height: imgRadius,
      width: imgRadius,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(imgRadius),
        image: DecorationImage(
          fit: BoxFit.fill,
          image: CachedNetworkImageProvider(
            imageUrl,
          ),
        ),
      ),
    );
  }

  Widget _buildNameWidget(String name) {
    return Container(
      height: widget.deviceHeight * 0.05,
      width: widget.deviceWidth,
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 30,
        ),
      ),
    );
  }

  Widget _buildEmailWidget(String email) {
    return Container(
      height: widget.deviceHeight * 0.03,
      width: widget.deviceWidth,
      child: Text(
        email,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white24,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      height: widget.deviceHeight * 0.06,
      width: widget.deviceWidth * 0.80,
      child: MaterialButton(
        onPressed: () => _confirmSignOut(context),
        color: Colors.red,
        child: const Text(
          'Log out',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final AuthBase _auth = Provider.of<AuthBase>(context, listen: false);
      return await _auth.signOut();
    } catch (e) {
      debugPrint(
        e.toString(),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'No Internet Connection',
            ),
            backgroundColor: Colors.red,
          ),
        );
    }
  }

  /// sign out function
  Future<void> _confirmSignOut(BuildContext context) async {
    final bool? didRequestLogOut = await showPlatformAlertDialog(
      context,
      title: 'Log Out',
      content: 'Are you sure you want to log out?',
      defaultActionText: 'Logout',
      cancelActionText: 'Cancel',
      isDestructiveActionIOS: true,
    );
    if (didRequestLogOut == true) {
      await _signOut(context);
    }
  }
}
