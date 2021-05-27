import 'package:flutter/material.dart';
import 'package:it_delivery/provider/auth_provider.dart';
import 'package:it_delivery/view/LoginViews/Header.dart';
import 'package:it_delivery/view/LoginViews/InputWrapper.dart';
import 'package:provider/provider.dart';
import '../view/LoginViews/Button.dart';
import '../view/LoginViews/InputField.dart';

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
  Future<void> _login() async {
    if (!_formKeyId.currentState.validate()) {
      return;
    }

    _formKeyId.currentState.save();

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .login(loginModel)
          .catchError((error) {
        setState(() {
          errorMessage = error.toString();
        });
      });
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
                        height: 40,
                      ),
                      Container(
                        width: double.infinity,
                        height: 50,
                        // margin: EdgeInsets.symmetric(horizontal: 5),

                        child: Center(
                          child: Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.teal[600]),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white)),
                              child: Text(
                                this.isLoginForm ? "Login" : "Register",
                              ),
                            ),
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
