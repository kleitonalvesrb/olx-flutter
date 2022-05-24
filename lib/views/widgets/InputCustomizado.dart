import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validadores/Validador.dart';

class InputCustomizado extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final bool? obscure;
  final bool? autofocus;
  final TextInputType? type;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatter;
  final Function(dynamic)? validator;
    final Function(dynamic)? onSaved;


  const InputCustomizado(
      {Key? key,
      @required this.controller,
      @required this.hint,
      this.obscure = false,
      this.autofocus = false,
      this.maxLines,
      this.type = TextInputType.text,
      this.validator,
      this.onSaved,
      this.inputFormatter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure!,
      autofocus: autofocus!,
      keyboardType: type,
      inputFormatters: inputFormatter,
      maxLines: maxLines,
      onSaved: onSaved,
      validator: (String? valor) {
        return validator!(valor);
      },
      style: const TextStyle(fontSize: 20),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(32, 16, 32, 15),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
