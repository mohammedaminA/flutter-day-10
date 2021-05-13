import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Color color;
  final Function onTap;
  RoundedButton({@required this.text, @required this.color, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: () {
            //Go to login screen.
            onTap();
          },
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}
