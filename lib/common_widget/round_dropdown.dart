import 'package:flutter/material.dart';
import '../common/color_extension.dart';

class RoundDropdownField extends StatefulWidget {
  final String hitText;
  final String icon;
  final List<String> items;
  final String? Function(String?) validator;
  final EdgeInsets? margin;
  final double? height;
  final Function(String?)? onChanged;

  const RoundDropdownField({
    super.key,
    required this.hitText,
    required this.icon,
    required this.items,
    required this.validator,
    this.margin,
    this.height,
    this.onChanged,
  });

  @override
  _RoundDropdownFieldState createState() => _RoundDropdownFieldState();
}

class _RoundDropdownFieldState extends State<RoundDropdownField> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      height: widget.height,
      decoration: BoxDecoration(
        color: TColor.lightGray,
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedValue,
        onChanged: (String? newValue) {
          if (newValue != 'Teacher') {
            setState(() {
              _selectedValue = newValue;
            });
            if (widget.onChanged != null) widget.onChanged!(newValue);
          }
        },
        validator: widget.validator,
        icon: const SizedBox.shrink(),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: widget.hitText,
          hintStyle: TextStyle(color: TColor.gray, fontSize: 12),
          suffixIcon: Icon(Icons.arrow_drop_down, color: TColor.gray),
          prefixIcon: Container(
            alignment: Alignment.center,
            width: 20,
            height: 20,
            child: Image.asset(
              widget.icon,
              width: 20,
              height: 20,
              fit: BoxFit.contain,
              color: TColor.gray,
            ),
          ),
        ),
        items: widget.items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            enabled: value != 'Teacher', // Disable "Teacher"
            child: Text(
              value,
              style: TextStyle(
                color: value == 'Teacher' ? Colors.grey : TColor.black,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
