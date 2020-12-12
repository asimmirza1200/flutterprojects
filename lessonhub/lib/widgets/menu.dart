import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 150.0,
          width: 150.0,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  width: 130.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage(
                        "assets/school-ic.png",
                      ),
                    ),
                    borderRadius: BorderRadius.circular(
                      30.0,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Text(
                  "School",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 150.0,
          height: 150.0,
          decoration: BoxDecoration(
            color: Color.fromRGBO(75, 31, 179, 0.6),
            borderRadius: BorderRadius.circular(
              30.0,
            ),
          ),
        )
      ],
    );
  }
}
