import 'package:flutter/material.dart';
import 'package:kcc_management_software/widgets/text_widget.dart';

class TextFieldWidget extends StatefulWidget {
  final String label;
  final String? hint;
  bool? isObscure;
  final TextEditingController controller;
  final double? width;
  final double? height;
  final int? maxLine;
  final TextInputType? inputType;
  final bool? isPassword;
  final bool? isEmail;
  final double? padding;

  TextFieldWidget(
      {super.key,
      required this.label,
      this.hint = '',
      required this.controller,
      this.isObscure = false,
      this.width = 300,
      this.height = 40,
      this.maxLine = 1,
      this.isPassword = false,
      this.isEmail = false,
      this.padding = 10,
      this.inputType = TextInputType.text});

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextBold(text: widget.label, fontSize: 12, color: Colors.grey),
        const SizedBox(
          height: 5,
        ),
        Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(0)),
          child: Padding(
            padding:
                EdgeInsets.only(left: widget.padding!, right: widget.padding!),
            child: TextFormField(
              textCapitalization: widget.isEmail! && widget.isPassword!
                  ? TextCapitalization.none
                  : TextCapitalization.words,
              keyboardType: widget.inputType,
              decoration: InputDecoration(
                suffixIcon: widget.isPassword!
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            widget.isObscure = !widget.isObscure!;
                          });
                        },
                        icon: widget.isObscure!
                            ? const Icon(Icons.remove_red_eye)
                            : const Icon(Icons.visibility_off),
                      )
                    : null,
                hintText: widget.hint,
                border: InputBorder.none,
              ),
              maxLines: widget.maxLine,
              obscureText: widget.isObscure!,
              controller: widget.controller,
            ),
          ),
        ),
      ],
    );
  }
}
