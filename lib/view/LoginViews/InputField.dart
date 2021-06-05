import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final isLoginForm;
  final Map loginModel;

  const InputField({Key key, this.isLoginForm, this.loginModel})
      : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  TextEditingController nameTC = TextEditingController();
  TextEditingController passwordTC = TextEditingController();
  TextEditingController mobileTC = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    mobileTC.text = '0563238328';
    nameTC.text = 'Omar Garana';
    passwordTC.text = 'password';
  }

  @override
  Widget build(BuildContext context) {
    // var provider = Provider.of<RequestProvider>(context).
    return Column(
      children: [
        if (!this.widget.isLoginForm)
          TextFormField(
            controller: nameTC,
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
          controller: mobileTC,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Mobile (05x)',
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

            if (value.length != 10) {
              return 'Mobile number length is not correct';
            }

            return null;
          },
          onSaved: (value) {
            this.widget.loginModel['mobile'] = value;
          },
        ),
        // if (!this.widget.isLoginForm)
        TextFormField(
          controller: passwordTC,
          obscureText: true,
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
