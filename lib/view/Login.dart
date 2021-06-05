import 'package:flutter/material.dart';
import 'package:it_delivery/provider/auth_provider.dart';
import 'package:it_delivery/view/LoginViews/Header.dart';
import 'package:provider/provider.dart';
import '../view/LoginViews/InputField.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoginForm = true;
  final _formKeyId = GlobalKey<FormState>();
  Map loginModel = {'mobile': '', 'password': '', 'device_name': 'android'};
  bool _isLoading = false;
  String errorMessage = '';

  ButtonState stateOnlyText = ButtonState.idle;
  ButtonState stateTextWithIcon = ButtonState.idle;
  ButtonState stateTextWithIconMinWidthState = ButtonState.idle;

  Widget buildTextWithIcon() {
    return ProgressButton.icon(iconedButtons: {
      ButtonState.idle: IconedButton(
          text: this.isLoginForm ? "Login" : "Register",
          icon: Icon(Icons.login, color: Colors.white),
          color: Colors.teal.shade500),
      ButtonState.loading: IconedButton(color: Colors.teal.shade700),
      ButtonState.fail: IconedButton(
          text: "Failed",
          icon: Icon(Icons.cancel, color: Colors.white),
          color: Colors.red.shade300),
      ButtonState.success: IconedButton(
          text: "",
          icon: Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
          color: Colors.green.shade400)
    }, onPressed: _login, state: stateTextWithIcon);
  }

  Future<void> _login() async {
    if (!_formKeyId.currentState.validate()) {
      return;
    }

    _formKeyId.currentState.save();

    setState(() {
      _isLoading = true;
      stateTextWithIcon = ButtonState.loading;
    });

    try {
      if (this.isLoginForm) {
        await Provider.of<AuthProvider>(context, listen: false)
            .login(loginModel)
            .then((value) {
          setState(() {
            _isLoading = true;
            stateTextWithIcon = ButtonState.success;
          });
        }).catchError((error) {
          setState(() {
            errorMessage = error.toString();
            stateTextWithIcon = ButtonState.fail;
          });
        });
      } else {
        await Provider.of<AuthProvider>(context, listen: false)
            .register(loginModel)
            .catchError((error) {
          setState(() {
            errorMessage = error.toString();
            stateTextWithIcon = ButtonState.fail;
          });
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topRight,
          colors: [
            Colors.teal.shade500,
            Colors.teal.shade900,
          ],
        )),
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 40,
            ),
            Header(),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: _formKeyId,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: InputField(
                            isLoginForm: isLoginForm, loginModel: loginModel),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        height: 40,
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: buildTextWithIcon(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(this.isLoginForm
                              ? "Not registered ? "
                              : "Already have account ?"),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                this.isLoginForm = !this.isLoginForm;
                              });
                            },
                            child: Center(
                              child: Text(
                                this.isLoginForm ? 'Register' : 'Login',
                                style: TextStyle(color: Colors.teal[600]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
