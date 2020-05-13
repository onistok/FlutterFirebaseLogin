import 'package:flutter/material.dart';
import 'package:flutterlogin/services/authentication.dart';

class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final _formKey = new GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _mainScaffoldKey = new GlobalKey<ScaffoldState>();

  String _email;
  String _email2;
  String _adsoyad;
  String _password;

    bool _isLoginForm;
    bool _isLoading;
    bool _kayitOldu;
    bool _isPassChangeButton;
    bool _isPassReset;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _isLoading = true;
      _kayitOldu = false;
    });
    if (validateAndSave()) {
      String userId = "";
      String resetPassinfo = "";
      try {
        if (_isLoginForm) {
          if (_password != "" && _email != "") {
            userId = await widget.auth.signIn(_email, _password, _adsoyad);
            //print('Signed in: $userId');
          } else if (_email == "" && _password != "") {
            displaySnackBar("Kayıtlı E-mail Adresinizi Giriniz !", 2, 0);
          } else if (_password == "" && _email != "") {
            displaySnackBar("Şifrenizi giriniz !", 2, 0);
          } else {
            displaySnackBar("Kayıtlı E-mail ve Şifrenizi Giriniz !", 2, 0);
          }
        } else if(_isPassReset == true){

          if(_email != ""){
            if(_email2 != ""){
              if(_email == _email2){

                try{

                  resetPassinfo = await widget.auth.resetPassword(_email);
                  if(resetPassinfo == "ok"){
                    toggleFormMode(); // giriş ekranı moduna döner
                    displaySnackBar("Mail Adresinize Şifre Sıfırlama Linki Gönderildi.", 7, 2);
                  }

                } catch (e) {

                  print(e.code); // release için kapat
                  switch (e.code) {
                    case "ERROR_INVALID_EMAIL":
                      displaySnackBar("Geçersiz E-Mail Adresi !", 3, 0);
                      _formKey.currentState.reset();
                      break;
                    case "ERROR_USER_NOT_FOUND":
                      displaySnackBar("E-Mail adresiniz kayıtlı değil !", 3, 0);
                      _formKey.currentState.reset();
                      break;
                    case "ERROR_TOO_MANY_REQUESTS":
                      displaySnackBar("Kısa bir süre engellendiniz !", 3, 1);
                      _formKey.currentState.reset();
                      break;
                    case "ERROR_NETWORK_REQUEST_FAILED":
                      displaySnackBar("İnternet bağlantınızı kontrol ediniz !", 3, 1);
                      break;
                  }

                }


              } else {
                displaySnackBar("Mail Adresi Eşleşmiyor !", 3, 0);
              }
            } else {
              displaySnackBar("Mail Adresi Tekrarını Giriniz !", 3, 0);
            }
          } else {
            displaySnackBar("Kayıtlı E-mail Adresinizi Giriniz !", 2, 0);
          }

        } else {

          if(_adsoyad != "") {
            if (_email != "") {
              if(_email2 != "") {
                if (_email == _email2) {
                  if(_password != "") {
                    userId = await widget.auth.signUp(_email, _password, _adsoyad);
                    _kayitOldu = true;
                    widget.auth.sendEmailVerification();
                    //print('Signed up user: $userId');
                  } else {
                    displaySnackBar("Güçlü Bir Şifre Belirleyiniz !", 3, 0);
                  }
                } else {
                  displaySnackBar("Mail Adresi Eşleşmiyor !", 3, 0);
                }
              } else {
                displaySnackBar("Mail Adresi Tekrarını Giriniz !", 3, 0);
              }
            } else {
              displaySnackBar("Kayıt Olmak İçin Mail Adresi Giriniz !", 3, 0);
            }
          } else {
            displaySnackBar("Ad Soyad Boş Bırakılamaz !", 2, 0);
          }

        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _isLoginForm || (_kayitOldu && userId.length > 0 && userId != null)) {
          widget.loginCallback(); // kayıt oldugunda yada login oldugunda
        }

      } catch (e) {
        print('Error: $e'); // release için kapat
        setState(() {
          _isLoading = false;
          _formKey.currentState.reset();
          if(e.code == "ERROR_USER_NOT_FOUND"){
            displaySnackBar("Böyle bir kullanıcı yok",3,1);
          } else if(e.code == "ERROR_WRONG_PASSWORD"){
            displaySnackBar("Şifre yanlış girildi",3,0);
          } else if(e.code == "ERROR_INVALID_EMAIL"){
            displaySnackBar("Gerçersiz e posta adresi",3,1);
          } else if(e.code == "ERROR_USER_DISABLED"){
            displaySnackBar("Bu hesap devre dışı",3,1);
          } else if(e.code == "ERROR_TOO_MANY_REQUESTS"){
            displaySnackBar("Kısa bir süre engellendiniz",3,0);
          } else if(e.code == "ERROR_EMAIL_ALREADY_IN_USE"){
            displaySnackBar("Bu mail adresi zaten kayıtlı",3,1);
          } else if(e.code == "ERROR_OPERATION_NOT_ALLOWED"){
            displaySnackBar("E-Mail ve Şifre Etkin Değil",3,1);
          } else if(e.code == "ERROR_NETWORK_REQUEST_FAILED"){
            displaySnackBar("İnternet bağlantınızı kontrol ediniz",3,1);
          } else {
            displaySnackBar(e.message,3,1); // code si belli olmayan ingilizce cevpalar
          }

        });
      }
    } else {
      _isLoading = false;
    }
  }

  @override
  void initState() {
    _isLoading = false;
    _isLoginForm = true;
    _isPassChangeButton = true;
    _isPassReset = false;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
      _isPassChangeButton = !_isPassChangeButton;
      _isPassReset = false;
    });
  }

  void togglePassChange() {
    resetForm();
    setState(() {
      _isLoginForm = false;
      _isPassChangeButton = false;
      _isPassReset = true;
    });
  }


  void displaySnackBar(String value, sny, rnk) {
      _mainScaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white, fontSize: 16.0,
          ),
        ),
        backgroundColor: rnk == 0 ? Colors.orangeAccent : rnk == 1 ? Colors
            .redAccent : Colors.green,
        duration: Duration(seconds: sny),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
        key: _mainScaffoldKey,
      backgroundColor: Color(0xFF236194),
        /*appBar: new AppBar( //app var üst banner
          backgroundColor: Color(0xFF236194),
          title: new Text('Uygulama Adı'),
        ),*/
        body: Center(
          child:
    SingleChildScrollView(
      child: Container(child: Stack(
          children: <Widget>[
            _showForm(),
          ],
        ),
    ),
        ),
            ),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(
          child: CircularProgressIndicator()
      );
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(0.0),
        child: new Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              showCart(),
              showKayitText(),
              showSecondaryButton(),
              //showErrorMessage(),
            ],
          ),
        ));
  }

  Widget showCart() {
    return Card(
        elevation: 2.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0)),child: Padding(
        padding: EdgeInsets.only(
        top: 10.0, bottom: 10.0),
      child:
    Container(
    width: MediaQuery.of(context).size.width * 0.95,
        child: Column(
        children: <Widget>[
          showLogo(),
          showAdSoyad(),
          showEmailInput(),
          showEmailInput2(),
          showPasswordInput(),
          _showCircularProgress(),
          showPrimaryButton(),
          showPassChangeButton(),
        ],
      )
    ),
    ),
    );
  }


  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: new Image(
            width: 100.0,
            height: 100.0,
            fit: BoxFit.cover,
            image: new AssetImage('assets/flutter-icon.png')
        ),
        ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 15.0, 25.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email Adresinizi Girin',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) {
          if (value.isEmpty) {
            //displaySnackBar("E-mail Adresinizi Girin!", 1, 0);
          }
          return null;
        },
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showEmailInput2() {
    if (_isLoginForm == false) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(5.0, 15.0, 25.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: new InputDecoration(
              hintText: 'E-Mail Adresinizi Tekrar Girin',
              icon: new Icon(
                Icons.mail,
                color: Colors.grey,
              )),
          validator: (value) {
            if (value.isEmpty) {
              //displaySnackBar("E-mail Adresi Tekrarını Girin!", 2, 0);
            }
            return null;
          },
          onSaved: (value) => _email2 = value.trim(),
        ),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showAdSoyad() {
    if (_isLoginForm == false && _isPassReset != true) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(5.0, 0.0, 25.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: new InputDecoration(
              hintText: 'Ad Soyad',
              icon: new Icon(
                Icons.people,
                color: Colors.grey,
              )),
          validator: (value) {
            if (value.isEmpty) {
              //displaySnackBar("Lütfen Ad Soyad Girin!", 2, 0);
            }
            return null;
          },
          onSaved: (value) => _adsoyad = value.trim(),
        ),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showPasswordInput() {
    if(_isPassReset != true) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(5.0, 15.0, 25.0, 0.0),
        child: new TextFormField(
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          decoration: new InputDecoration(
              hintText: 'Şifrenizi Girin',
              icon: new Icon(
                Icons.lock,
                color: Colors.grey,
              )),
          validator: (value) {
            if (value.isEmpty) {
              //displaySnackBar("Şifrenizi Girin!", 1, 0);
            }
            return null;
          },
          onSaved: (value) => _password = value.trim(),
        ),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showKayitText() {
    if (_isLoginForm == true){
      return new FlatButton(
        child: new Text('Hesabın yok mu?',
            style: new TextStyle(fontSize: 18.0,
                fontWeight: FontWeight.w300,
                color: Colors.white)),
        onPressed: toggleFormMode, // tıklanma ekle buraya
      );
    } else {
      return new FlatButton(
        child: new Text('Hesabın var ise',
            style: new TextStyle(fontSize: 18.0,
                fontWeight: FontWeight.w300,
                color: Colors.white)),
        onPressed: toggleFormMode, // tıklanma ekle buraya
      );
    }
  }

  Widget showSecondaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 0.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            color: Colors.white,
            child: new Text(_isLoginForm ? 'Hemen Kaydol' : 'Giriş Yap',
                style: new TextStyle(fontSize: 20.0, color: Color(0xFF236194))),
            onPressed: toggleFormMode,
          ),
        ));
  }

  Widget showPassChangeButton() {
    if (_isLoginForm == true) {
      return new FlatButton(
          child: new Text(
              'Şifremi Unuttum?',
              style: new TextStyle(
                  fontSize: 18.0, fontWeight: FontWeight.w300)),
          onPressed: togglePassChange);
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 27.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 10.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)),
            color: Color(0xFF236194),
            child: new Text(_isLoginForm ? 'Giriş Yap' : _isPassReset ? 'Şifremi Sıfırla' : 'Kaydol',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }
}
