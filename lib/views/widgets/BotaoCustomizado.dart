import 'package:flutter/material.dart';

class BotaoCustomizado extends StatelessWidget {
  final String? texto;
  final Color? corTexto;
  final VoidCallback? onPressed;

  const BotaoCustomizado(
      {Key? key,
      @required this.texto,
      this.corTexto = Colors.white,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      onPressed: onPressed,
      child: Text(
        texto!,
        style: TextStyle(color: corTexto, fontSize: 20),
      ),
      color: const Color(0xff9c27b0),
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
    );
  }
}
