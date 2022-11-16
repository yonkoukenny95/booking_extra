import 'package:flutter/material.dart';

class SimpleRoundButton extends StatelessWidget {
  final Color backgroundColor;
  final Text buttonText;
  final Color textColor;
  final Function onPressed;
  final double mt;
  final double radius;

  SimpleRoundButton({this.backgroundColor, this.buttonText, this.onPressed,this.textColor,this.mt,this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: this.mt),
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: new Row(
        children: <Widget>[
          new Expanded(
              child: new RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius),
                      side: BorderSide(color: this.backgroundColor)),
                  onPressed: onPressed,
                  color: this.backgroundColor,
                  textColor: Colors.white,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: buttonText,
                      ),
                    ],
                  )
              )
          ),
        ],
      ),
    );
  }
}
