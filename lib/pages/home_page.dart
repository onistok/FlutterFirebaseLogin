import 'package:flutter/material.dart';
import 'package:flutterlogin/services/authentication.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;


  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _resentVerifyEmail(){
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Hesabınızı doğrulayın"),
          content: new Text("Lütfen Mail adresinize gönderilen bağlantı linkine tıklayarak hesabınızı doğrulayın."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Tekrar Gönder"),
              onPressed: () {
                Navigator.of(context).pop();
                _resentVerifyEmail();
              },
            ),
            new FlatButton(
              child: new Text("Tamam"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Hesabınızı doğrulayın"),
          content: new Text("Mail adresinize bir doğrulama linki daha gönderdik, o linke tıklayarak hesabınızı doğrulayabilirsiniz."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Tamam"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }


  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }

  }

  showAddTodoDialog(BuildContext context) async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Row(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: 'Yeni Kayıt',
                  ),
                ))
              ],
            ),
            actions: <Widget>[

            ],
          );
        });
  }

  Widget ilksayfaverisi() {
      return Center(
          child: Text(
        "Hoşgeldiniz",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30.0),
      ));
  }


  _settingModalBottomSheet(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.people),
                    title: new Text('Profilim'),
                    onTap: () => {}
                ),
                new ListTile(
                    leading: new Icon(Icons.settings),
                    title: new Text('Uygulama Ayarları'),
                    onTap: () => {}
                ),
                new ListTile(
                  leading: new Icon(Icons.exit_to_app),
                  title: new Text('Hesabımdan Çıkış Yap'),
                  onTap: () => {
                    Navigator.pop(context), // geçişten önce menuyü kapatsın diye.
                    signOut(),
                  },
                ),
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
            backgroundColor: Color(0xFF236194),
          title: new Text('Uygulama Adı'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.list), onPressed:(){
              _settingModalBottomSheet(context);
            }
              ),
            /*new FlatButton(
                child: new Text('Çık',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: signOut)*/
          ],
        ),
        body: ilksayfaverisi(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAddTodoDialog(context);
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        )
    );
  }

}
