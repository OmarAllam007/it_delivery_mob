import 'package:flutter/material.dart';
import 'package:it_delivery/view/LoginViews/Header.dart';
import 'package:it_delivery/view/LoginViews/InputWrapper.dart';
import '../view/LoginViews/Button.dart';
import '../view/LoginViews/InputField.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoginForm = true;

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
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: InputField(isLoginForm: isLoginForm),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      // margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.teal[600],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          this.isLoginForm ? "Login" : "Register",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
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
                            child:
                                Text(this.isLoginForm ? 'Register' : 'Login' , style: TextStyle(color: Colors.teal[600]),),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
