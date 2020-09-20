import 'package:CommandAgric/constants/app_constants.dart';
import 'package:CommandAgric/models/distribution.dart';
import 'package:CommandAgric/models/price.dart';
import 'package:CommandAgric/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../home_drawer.dart';


class ViewDistributions extends StatefulWidget {
  SharedPreferences prefs;

  ViewDistributions({this.prefs});

  final String title = 'Distributions';

  @override
  State createState() => _ViewDistributionsState();
}

class _ViewDistributionsState extends State<ViewDistributions> {
  @override
  Widget build(BuildContext context) {
    ListTile makeListTile(Distribution distribution) => ListTile(
      leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.filter_list)),
      title: Text(
        "Date :" + distribution.date,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Container(
                // tag: 'hero',

                child: Text("Status : " + distribution.status.toString()
                    ,
                    style: TextStyle(color: Colors.white)),
              )),
        ],
      ),
    );

    Card makeCard(Distribution distribution) => Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: makeListTile(distribution),
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
              'Distributions',
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
                future: fetchDistributions(http.Client(), widget.prefs),
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
                        return makeCard(new Distribution(
                          id: snapshot.data[index].id,
                          date: snapshot.data[index].date,
                          status: snapshot.data[index].status,
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
      drawer: HomeDrawer(
        prefs: widget.prefs,
      ),
      body: Stack(children: <Widget>[makeBody, header]),
    );
  }
}
