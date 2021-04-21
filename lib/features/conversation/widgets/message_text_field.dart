import 'package:flutter/material.dart';

/// Message Text Field
class MessageTextField extends StatefulWidget {
  // ignore: public_member_api_docs
  MessageTextField({
    required this.deviceWidth,
    required this.controller,
    required this.onChanged,
    required this.onEditingComplete,
    required this.focusNode,
    Key? key,
  }) : super(
          key: key,
        );

  /// Device Width
  final double deviceWidth;

  /// OnChanged Callback
  Function(String)? onChanged;

  /// controller
  final TextEditingController controller;

  /// onEditingComplete
  Function()? onEditingComplete;

  /// Focus Node
  FocusNode focusNode;

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.deviceWidth * 0.55,
      child: TextField(
        focusNode: widget.focusNode,
        onEditingComplete: widget.onEditingComplete,
        controller: widget.controller,
        onChanged: widget.onChanged,
        cursorColor: Colors.white,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Type a Message',
        ),
        autocorrect: false,
      ),
    );
  }
}
