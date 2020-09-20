import 'package:CommandAgric/constants/app_constants.dart';
import 'package:CommandAgric/models/user.dart';
import 'package:CommandAgric/models/weather.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class ViewWeahterNotifications extends StatefulWidget {
  SharedPreferences prefs;

  ViewWeahterNotifications({this.prefs});

  final String title = 'Weather';

  @override
  State createState() => _ViewWeahterNotificationsState();
}

class _ViewWeahterNotificationsState extends State<ViewWeahterNotifications> {
  @override
  Widget build(BuildContext context) {
    ListTile makeListTile(Weather weather) => ListTile(
      leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.person)),
      title: Text(
        "Title : Weather Notification"  ,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Container(
                // tag: 'hero',

                child: Text("Body : " + weather.notification
                    ,
                    style: TextStyle(color: Colors.white)),
              )),
        ],
      ),
    );

    Card makeCard(Weather weather) => Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: makeListTile(weather),
      ),
    );

    final header = Container(
        height: 100.0,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppConstants.APP_LOGO), fit: BoxFit.cover),
            boxShadow: [new BoxShadow(color: Colors.black, blurRadius: 8.0)],
            color: Colors.blue),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'User',
              style: TextStyle(
                  color: Colors.white, fontSize: 20, fontFamily: 'Roboto'),
            ),
            Icon(
              Icons.list,
              color: Colors.white,
              size: 30,
            )
          ],
        ));

    final makeBody = Padding(
        padding: EdgeInsets.only(top: 100),
        child: Container(
            decoration: BoxDecoration(color: Colors.greenAccent),
            child: FutureBuilder(
                future: fetchWeatherNotifications(http.Client(), widget.prefs),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      child: Center(
                        child: Text('Loading'),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return makeCard(new Weather(
                          id: snapshot.data[index].id,
                          notification: snapshot.data[index].notification,
                          district: snapshot.data[index].district,
                        ));
                      },
                    );
                  }
                })));

    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Colors.greenAccent,
      title: Text(widget.title),
      centerTitle: true,
    );

    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: topAppBar,
      body: Stack(children: <Widget>[makeBody, header]),
    );
  }
}
