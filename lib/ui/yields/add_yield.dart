import 'package:CommandAgric/constants/app_constants.dart';
import 'package:CommandAgric/constants/pref_constants.dart';
import 'package:CommandAgric/models/user.dart';
import 'package:CommandAgric/models/yield.dart';
import 'package:CommandAgric/ui/home_drawer.dart';
import 'package:CommandAgric/ui/session/login.dart';
import 'package:CommandAgric/ui/yields/view_yields.dart';
import 'package:CommandAgric/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/loading.dart';


class AddYield extends StatefulWidget {
  AddYield({Key key, this.prefs}) : super(key: key);

  final SharedPreferences prefs;
  final String title = 'Add Yield';

  @override
  State createState() => _AddYieldState();
}

class _AddYieldState extends State<AddYield> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  bool _autoValidate = false;
  bool _loadingVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController cropController = new TextEditingController();
  TextEditingController quantityController = new TextEditingController();


  Future _addYield({Yield yield1}) async {
    if (_formKey.currentState.validate()) {
      try {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();

        await saveYield(http.Client(), yield1.toJson(), widget.prefs)
            .then((onValue) {
          if (onValue) {
            AlertDialog alertDialog = AlertDialog(
                title: Text('Response'),
                content: Text(widget.prefs.getString(
                    PrefConstants.SERVER_RESPONSE ?? 'Something is wrong')),
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
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ViewYields(
                                            prefs: widget.prefs,
                                          )));
                            },
                          ),
                        ],
                      ))
                ]);

            showDialog(context: context, builder: (_) => alertDialog);
          } else {
            AlertDialog alertDialog = AlertDialog(
                title: Text('Response'),
                content: Text(widget.prefs.getString(
                    PrefConstants.SERVER_RESPONSE ?? 'Something is wrong')),
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
                              _loadingVisible = false;
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          AddYield(
                                            prefs: widget.prefs
                                          )));
                            },
                          ),
                        ],
                      ))
                ]);

            showDialog(context: context, builder: (_) => alertDialog);
          }
        });
      } catch (e) {
        print("Sign Up Error: $e");
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }

  @override
  Widget build(BuildContext context) {

    final cropField = TextFormField(
      obscureText: false,
      style: style,
      keyboardType: TextInputType.text,
      autofocus: true,
      controller: cropController,
      validator: Validator.validateName,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Crop",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          )),
    );

    final quatityField = TextFormField(
      obscureText: false,
      style: style,
      keyboardType: TextInputType.numberWithOptions(),
      autofocus: true,
      controller: quantityController,
      //validator: Validator.validateNumber,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Quantity (Kgs)",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          )),
    );



    final saveButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff00FF00),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          //update an existing task

          Yield yield1 = new Yield();
          yield1.crop = cropController.text;
          yield1.quantity = quantityController.text;
          yield1.date = new DateTime.now().toString();
          yield1.farmerId=widget.prefs.getString(PrefConstants.LOGGED_EMAIL);


          _addYield(yield1: yield1);
        },
        child: Text("Save",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );


    Form form = new Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              color: Color(0xffF6F6F6),
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 155.0,
                      child: Image.asset(
                        AppConstants.APP_LOGO,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    cropField,
                    SizedBox(height: 20.0),
                    quatityField,
                    SizedBox(
                      height: 35.0,
                    ),
                    saveButton
                  ],
                ),
              ),
            ),
          ),
        ));
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
      body: LoadingScreen(child: form, inAsyncCall: _loadingVisible),
    );
  }

  Future<void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }


}
