import 'package:CommandAgric/constants/app_constants.dart';
import 'package:CommandAgric/models/yield.dart';
import 'package:CommandAgric/ui/yields/add_yield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../home_drawer.dart';


class ViewYields extends StatefulWidget {
  SharedPreferences prefs;

  ViewYields({this.prefs});

  final String title = 'Yields';

  @override
  State createState() => _VViewYieldsState();
}

class _VViewYieldsState extends State<ViewYields> {
  @override
  Widget build(BuildContext context) {
    ListTile makeListTile(Yield yield) => ListTile(
      leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.filter_list)),
      title: Text(
        "Crop :" + yield.crop,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Container(
                // tag: 'hero',

                child: Text("Quantity : " + yield.quantity.toString()
                    ,
                    style: TextStyle(color: Colors.white)),
              )),
        ],
      ),
    );

    Card makeCard(Yield yield) => Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: makeListTile(yield),
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
              'Yields',
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
                future: fetchYields(http.Client(), widget.prefs),
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
                        return makeCard(new Yield(
                          farmerId: snapshot.data[index].farmerId,
                          date: snapshot.data[index].date,
                          crop: snapshot.data[index].crop,
                          quantity: snapshot.data[index].quantity,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext contex) =>
                      AddYield(prefs: widget.prefs)));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      body: Stack(children: <Widget>[makeBody, header]),
    );
  }
}
