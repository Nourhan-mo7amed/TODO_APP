import 'package:flutter/material.dart';
import 'form_decorations.dart';

class AuthInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final bool obscure;
  final TextInputType keyboardType;
  final bool showVisibilityToggle;
  final ValueChanged<bool>? onVisibilityToggled;

  const AuthInputField({
    Key? key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.validator,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.showVisibilityToggle = false,
    this.onVisibilityToggled,
  }) : super(key: key);

  @override
  State<AuthInputField> createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _isObscured,
      textCapitalization: widget.hint.contains('Name')
          ? TextCapitalization.words
          : TextCapitalization.none,
      decoration: buildInputDecoration(
        hint: widget.hint,
        icon: widget.icon,
        suffixIcon: widget.showVisibilityToggle
            ? IconButton(
                icon: Icon(
                  _isObscured
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.black45,
                ),
                onPressed: () {
                  setState(() => _isObscured = !_isObscured);
                  widget.onVisibilityToggled?.call(_isObscured);
                },
              )
            : null,
      ),
      validator: widget.validator,
    );
  }
}
