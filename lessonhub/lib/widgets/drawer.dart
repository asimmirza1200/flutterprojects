import 'package:flutter/material.dart';
import 'package:lesson_flutter/router/routes.dart';
import 'package:lesson_flutter/services/auth_service.dart';
import 'package:lesson_flutter/pages/menu_selection.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.75,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 300.0,
            color: Color(0xFF0a6194),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(0.0),
              children: [
                ListTile(
                  onTap: () {
                    AppRoutes.nextScreen(context, AppRoutes.MENU_SELECTION);
                  },
                  leading: Icon(Icons.home),
                  title: Text(
                    "Home",
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    AppRoutes.nextScreen(context, AppRoutes.PROFILE_SCREEN);
                  },
                  leading: Icon(Icons.person),
                  title: Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    AppRoutes.nextScreen(context, AppRoutes.MY_ORDERS);
                  },
                  leading: Icon(Icons.money),
                  title: Text(
                    "My Orders",
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    AuthService.logoutUser(context);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => MenuSelection()),
                            (Route<dynamic> route) => false
                    );
                  },
                  leading: Icon(Icons.exit_to_app),
                  title: Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
