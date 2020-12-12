import 'package:flutter/material.dart';
import 'package:lesson_flutter/clips/bezier_bottom.dart';
import 'package:lesson_flutter/utils/constants.dart';

class SubjectSelectionThird extends StatelessWidget {
  final Color themeColor;
  final Color leftPatternColor;
  final Color leftTextColor;
  SubjectSelectionThird(
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
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(
                    8.0,
                  ),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 30.0,
                      ),
                      Container(
                        width: 120.0,
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              left: 30.0,
                              top: 10.0,
                              child: Container(
                                alignment: Alignment(-0.5, 0),
                                color: Color(0xFF5da740),
                                height: 60.0,
                                width: 120.0,
                                child: Text(
                                  "CLASS",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "4",
                                      style: TextStyle(
                                        fontSize: 70.0,
                                        shadows: [
                                          Shadow(
                                            color: Color(0xFF9daeb1),
                                            blurRadius: 5.0,
                                          ),
                                        ],
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFFa2ec70),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
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
                    ],
                  ),
                ),
                Container(
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
                              color: Color(0xFF224b1b),
                              fontSize: 20.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 250.0,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          alignment: Alignment.center,
                          width: 250.0,
                          height: 90.0,
                          child: Text(
                            "English",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: AssetImage(
                                "assets/class4bg.png",
                              ),
                            ),
                          ),
                        );
                      },
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
