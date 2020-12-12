import 'package:flutter/material.dart';
import 'package:lesson_flutter/utils/constants.dart';
import 'package:lesson_flutter/widgets/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final String initialValue;
  final IconData icon;
  final Function validator;
  final Function onSaved;
  final ValueChanged<String> onChanged;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.validator,
    this.onChanged,
    this.onSaved,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        validator: validator,
        onChanged: onChanged,
        initialValue: initialValue,
        onSaved: (value) => onSaved(value),
        cursorColor: AppConstants.kPrimaryColor,
        decoration: InputDecoration(
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          icon: Icon(
            icon,
            color: Colors.white,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
