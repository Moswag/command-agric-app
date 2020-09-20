import 'package:CommandAgric/constants/app_constants.dart';
import 'package:CommandAgric/constants/pref_constants.dart';
import 'package:CommandAgric/constants/pref_constants.dart';
import 'package:CommandAgric/ui/chat/chat.dart';
import 'package:CommandAgric/ui/duistributions/view_distributions.dart';
import 'package:CommandAgric/ui/prices/view_prices.dart';
import 'package:CommandAgric/ui/weather/weather_updates.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'session/login.dart';
import 'yields/view_yields.dart';


class HomeDrawer extends StatelessWidget {
  HomeDrawer({this.prefs});

  final SharedPreferences prefs;

  bool _loadingVisible = false;

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = prefs.getBool(PrefConstants.ISLOGGEDIN) ?? false;
    if (!isLoggedIn) {
      return LoginPage(prefs: prefs);
    } else {
      final phonenumber = prefs.getString(PrefConstants.LOGGED_EMAIL) ?? '07';
      final name = prefs.getString(PrefConstants.LOGGED_NAME) ?? 'Web';

      void _signOut() async {
        try {
          prefs.setBool(PrefConstants.ISLOGGEDIN, false);
          Navigator.of(context).pop();
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                      new LoginPage(prefs: prefs)));
        } catch (e) {
          print(e);
        }
      }

      void showAlertDialog() {
        AlertDialog alertDialog = AlertDialog(
            title: Text('Status'),
            content:
                Text('Are you sure you want to logout from Command Agriculture App'),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
                      new FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text('Ok', textScaleFactor: 1.5),
                        onPressed: () {
                          _signOut(); //signout
                        },
                      ),
                      Container(
                        width: 5.0,
                      ),
                      new FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        color: Colors.red,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Cancel',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ))
            ]);

        showDialog(context: context, builder: (_) => alertDialog);
      }

      return new Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text(name),
              accountEmail: Text(phonenumber),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: new AssetImage(AppConstants.APP_LOGO),
                backgroundColor: Colors.yellow,
              ),
            ),
//            new ListTile(
//              leading: Icon(Icons.assignment),
//              title: new Text('Farm Details'),
//              onTap: () {
//                Navigator.of(context).pop();
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (BuildContext contex) =>
//                            ViewDistributions(prefs: prefs)));
//              },
//            ),
            new ListTile(
              leading: Icon(Icons.monetization_on),
              title: new Text('GMB Prices'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext contex) =>
                            ViewPrices(prefs: prefs)));
              },
            ),
            new ListTile(
              leading: Icon(Icons.list),
              title: new Text('Distributions'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext contex) =>
                            ViewDistributions(prefs: prefs)));
              },
            ),
            new ListTile(
              leading: Icon(Icons.line_style),
              title: new Text('Yields'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext contex) =>
                            ViewYields(prefs: prefs)));

              },
            ),
//            new ListTile(
//              leading: Icon(Icons.account_balance_wallet),
//              title: new Text('Awards'),
//              onTap: () {
//                Navigator.of(context).pop();
////                Navigator.push(
////                    context,
////                    MaterialPageRoute(
////                        builder: (BuildContext contex) =>
////                            ViewReceipts(prefs: prefs)));
//
//                //  Navigator.of(context).pushNamed(MyRoutes.VIEW_STUDENTS);
//              },
//            ),
            new ListTile(
              leading: Icon(Icons.cloud),
              title: new Text('Weather'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext contex) =>
                            ViewWeahterNotifications(prefs: prefs)));

                //  Navigator.of(context).pushNamed(MyRoutes.VIEW_STUDENTS);
              },
            ),

            new ListTile(
              leading: Icon(Icons.chat),
              title: new Text('Chat with Expert'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext contex) =>
                            Chat(prefs: prefs, userId: "123",peerId: "123",peerAvatar: "",name: "Farmer Expert",)));

                //  Navigator.of(context).pushNamed(MyRoutes.VIEW_STUDENTS);
              },
            ),

            new ListTile(
              leading: Icon(Icons.all_out),
              title: new Text('Logout'),
              onTap: () {
                //Navigator.pop(context);
                showAlertDialog(); // _signOut();
              },
            )
          ],
        ),
      );
    }
  }
}
