import 'package:flutter/material.dart';

class CommonInputRow extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final String? hintText;
  final Widget? suffix;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  const CommonInputRow({
     super.key,
    required this.title,
    required this.controller,
    this.hintText,
    this.suffix,
    this.suffixIcon,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(flex: 1, child: Text(title, style: TextStyle(color: Colors.grey[700]))),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: TextFormField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.deepPurple[50],
              border: InputBorder.none,
              hintText: hintText,
              suffix: suffix,
              suffixIcon: suffixIcon,
            ),
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            onTap: onTap,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}