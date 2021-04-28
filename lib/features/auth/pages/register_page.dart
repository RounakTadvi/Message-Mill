// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:message_mill/features/home/home_page.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:message_mill/core/constants/constants.dart';
import 'package:message_mill/features/auth/widgets/register/register_header.dart';
import 'package:message_mill/features/shared/spacers.dart';
import 'package:message_mill/services/cloud_storage_service.dart';
import 'package:message_mill/services/database_service.dart';
import 'package:message_mill/services/firebase_auth_service.dart';
import 'package:message_mill/services/media_service.dart';
import 'package:message_mill/services/snack_bar_service.dart';

/// Registeration Page
class RegisterPage extends StatefulWidget {
  // ignore: public_member_api_docs
  RegisterPage({Key? key})
      : super(
          key: key,
        );

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  File? _image;

  late String _name;
  late String _email;
  late String _pass;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        alignment: Alignment.center,
        child: _buildRegisterPage(),
      ),
    );
  }

  Widget _buildRegisterPage() {
    return Container(
      height: _deviceHeight * 0.75,
      child: Form(
        key: _formkey,
        onChanged: () {
          _formkey.currentState!.save();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Align(
              alignment: Alignment.center,
              child: RegisterHeader(),
            ),
            MMSpacers.height16,
            _buildRegisterForm(),
            MMSpacers.height16,
            _registerButton(),
            _backToLoginPageButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Container(
      //height: _deviceHeight * 0.75,
      padding: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.10,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildAvatarWidget(),
            MMSpacers.height16,
            _buildNameTF(),
            MMSpacers.height16,
            _buildEmailTF(),
            MMSpacers.height16,
            _buildPassTF(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarWidget() {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () async {
          File? imageFile = await MediaService.instance.getImageFromLibrary();
          setState(() {
            _image = imageFile;
          });
        },
        child: Container(
          height: _deviceHeight * 0.10,
          width: _deviceHeight * 0.10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: _image != null
                ? Image.file(
                    File(_image!.path),
                    fit: BoxFit.cover,
                  )
                : SvgPicture.asset('assets/user.svg'),
          ),
        ),
      ),
    );
  }

  Widget _buildNameTF() {
    return TextFormField(
      controller: _nameController,
      autocorrect: false,
      style: const TextStyle(
        color: Colors.white,
      ),
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        hintText: Constants.nameHintText,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      validator: (String? name) {
        return name!.isNotEmpty ? null : 'Enter your name';
      },
      onSaved: (String? name) {
        setState(() {
          _name = name!;
        });
      },
    );
  }

  Widget _buildEmailTF() {
    final RegExp _emailRegExp = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    );
    return TextFormField(
      controller: _emailController,
      autocorrect: false,
      style: const TextStyle(
        color: Colors.white,
      ),
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        hintText: Constants.emailHintText,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      validator: (String? email) {
        return _emailRegExp.hasMatch(email!)
            ? null
            : 'Enter a valid email address';
      },
      onSaved: (String? email) {
        setState(() {
          _email = email!;
        });
      },
    );
  }

  Widget _buildPassTF() {
    return TextFormField(
      controller: _passController,
      autocorrect: false,
      obscureText: true,
      style: const TextStyle(
        color: Colors.white,
      ),
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        hintText: Constants.passwordHintText,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      validator: (String? pass) {
        return pass!.length >= 6
            ? null
            : 'Password should be at least 6 characters';
      },
      onSaved: (String? pass) {
        setState(() {
          _pass = pass!;
        });
      },
    );
  }

  Widget _registerButton() {
    final AuthBase _auth = Provider.of<AuthBase>(context, listen: false);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      height: _deviceHeight * 0.06,
      width: _deviceWidth,
      child: MaterialButton(
        onPressed: () async {
          try {
            if (_formkey.currentState!.validate() && _image != null) {
              final User? user = await _auth.createAccountWithEmailAndPassword(
                _email,
                _pass,
              );

              if (user != null) {
                final TaskSnapshot? _result =
                    await CloudStorageService.instance.uploadUserImage(
                  user.uid,
                  _image!,
                );
                if (_result != null) {
                  String imgUrl = await _result.ref.getDownloadURL();
                  await DBService.instance.createUserInDb(
                    uid: user.uid,
                    name: _name,
                    email: _email,
                    imageUrl: imgUrl,
                  );
                  await DBService.instance.updateUserLastSeen(user.uid);
                  await Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute<void>(
                        builder: (_) => const HomePage(),
                      ),
                      (Route<dynamic> route) => false);
                }
              }
            } else {
              SnackBarService.instance.showSnackBarError(
                context,
                'Kindly select an image',
              );
            }
          } on SocketException {
            SnackBarService.instance.showSnackBarError(
              context,
              'Network unreachable. Check your connection',
            );
          } on FirebaseAuthException catch (e) {
            if (e.code == 'network-request-failed') {
              SnackBarService.instance.showSnackBarError(
                context,
                'Network unreachable. Check your connection',
              );
            }
            if (e.code == 'email-already-in-use') {
              SnackBarService.instance.showSnackBarError(
                context,
                'An account with the given email already exists',
              );
            }
            if (e.code == 'invalid-email') {
              SnackBarService.instance.showSnackBarError(
                context,
                'Invalid Email',
              );
            }
            if (e.code == 'weak-password') {
              SnackBarService.instance.showSnackBarError(
                context,
                'Password should be at least 6 characters',
              );
            }
          } catch (e) {
            SnackBarService.instance.showSnackBarError(
              context,
              e.toString(),
            );
            debugPrint(
              e.toString(),
            );
          }
        },
        color: Colors.blue,
        child: const Text(
          'Register',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _backToLoginPageButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        height: _deviceHeight * 0.06,
        width: _deviceWidth,
        child: const Icon(
          Icons.arrow_back,
          size: 40,
        ),
      ),
    );
  }
}
