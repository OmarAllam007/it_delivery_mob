import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it_delivery/model/Request.dart';
import 'package:it_delivery/provider/request_provider.dart';
import 'package:provider/provider.dart';

class InputField extends StatefulWidget {
  final isLoginForm;
  final Map loginModel;

  const InputField({Key key, this.isLoginForm, this.loginModel})
      : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    // var provider = Provider.of<RequestProvider>(context).

    return Column(
      children: [
        if (!this.widget.isLoginForm)
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(color: Colors.teal.shade900),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.teal.shade600),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.teal.shade600),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Name is required';
              }
              return null;
            },
            onSaved: (value) {
              this.widget.loginModel['name'] = value;
            },
          ),

        TextFormField(
          initialValue: '966563238328',
          decoration: InputDecoration(
            labelText: 'Mobile',
            labelStyle: TextStyle(color: Colors.teal.shade900),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.teal.shade600),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.teal.shade600),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Mobile is required';
            }
            return null;
          },
          onSaved: (value) {
            this.widget.loginModel['mobile'] = value;
          },
        ),
        // if (!this.widget.isLoginForm)
        TextFormField(
          obscureText: true,
          initialValue: 'password',
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(color: Colors.teal.shade900),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.teal.shade600),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.teal.shade600),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            }
            return null;
          },
          onSaved: (value) {
            this.widget.loginModel['password'] = value;
          },
        ),
      ],
    );
  }
}
