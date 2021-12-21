import 'package:flutter/material.dart';

class DefinedError extends StatelessWidget {
  String errMessage;

  DefinedError(this.errMessage);

  @override
  Widget build(BuildContext context) {
    print(errMessage);

    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                errMessage,
                style: TextStyle(color: Colors.white, fontSize: 30),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
