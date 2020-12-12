import 'package:flutter/material.dart';
import 'package:lesson_flutter/clips/bezier_bottom.dart';
import 'package:lesson_flutter/utils/constants.dart';

class SubjectSelectionSecond extends StatelessWidget {
  final Color themeColor;
  final Color leftPatternColor;
  final Color leftTextColor;
  SubjectSelectionSecond(
      {this.themeColor, this.leftPatternColor, this.leftTextColor});

  double getMarginLeft(index) {
    switch (index) {
      case 0:
        return 70.0;
      case 1:
        return 140.0;
      case 2:
        return 130.0;
      case 3:
        return 120.0;
      case 4:
        return 70.0;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            left: -70.0,
            top: 50.0,
            bottom: 0.0,
            child: Container(
              width: 230.0,
              height: 230.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: leftPatternColor,
              ),
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(
                  left: 20.0,
                ),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "9 \n",
                        style: TextStyle(
                          fontSize: 70.0,
                          fontWeight: FontWeight.w900,
                          color: leftTextColor,
                        ),
                      ),
                      TextSpan(
                        text: "CLASS",
                        style: TextStyle(
                          fontSize: 25.0,
                          color: leftTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.menu,
                      size: 30.0,
                      color: AppConstants.blackColor,
                    ),
                    onPressed: () {},
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 150.0,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 150.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 35.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: Text(
                            "Choose Subject",
                            style: TextStyle(
                              color: leftTextColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        Flexible(
                          child: Column(
                            children: List.generate(
                              5,
                              (index) {
                                return Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                    bottom: 10.0,
                                    left: getMarginLeft(index),
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: themeColor,
                                    borderRadius: BorderRadius.circular(
                                      30.0,
                                    ),
                                  ),
                                  child: Text(
                                    "English",
                                    style: TextStyle(
                                      color: leftTextColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: ClipPath(
              clipper: MyClipper(),
              child: Container(
                color: themeColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, size.height - 200.0);
    path.lineTo(size.width - 200.0, size.height);
    var endPoints = Offset(size.width, size.height - 200.0);
    var controlPoints = Offset(size.width - 50.0, size.height - 100.0);

    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
