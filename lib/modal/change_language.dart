import 'package:flutter/material.dart';
import '../localization/translate.dart';
import '../main.dart';
import '../model/language.dart';

class ChangeLanguageModal extends StatefulWidget {
  final BuildContext alertContext;
  ChangeLanguageModal(this.alertContext);

  @override
  _ChangeLanguageModalState createState() => _ChangeLanguageModalState();
}

class _ChangeLanguageModalState extends State<ChangeLanguageModal> {
  bool isLoading = false;
  int selectedChoice = 0;
  Language language;
  @override
  Widget build(BuildContext context) {
    Widget cancelButton = FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      // color: Theme.of(context).primaryColor,
      child: Text(T(context, "Cancel")),
      onPressed: () {
        Navigator.of(widget.alertContext).pop();
      },
    );
    Widget submitButton = RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.teal.shade600,
      child: isLoading
          ? CircularProgressIndicator(backgroundColor: Colors.teal)
          : Text(
              T(context, "Change"),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
      onPressed: () async {
        setState(() {
          isLoading = true;
        });

        Locale _temp = await setLocal(language.languageCode);
        MyApp.setLocale(context, _temp);
        Navigator.of(widget.alertContext).pop();
      },
    );
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(T(context, "Change Language")),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        child: SingleChildScrollView(
          child: Column(
            children: Language.languageList().map((e) {
              return RadioListTile<int>(
                title: Row(
                  children: <Widget>[
                    Text(e.flag),
                    SizedBox(),
                    Text(e.name),
                  ],
                ),
                value: e.id,
                groupValue: selectedChoice,
                onChanged: (value) {
                  setState(() {
                    selectedChoice = value;
                    language = Language.languageList()[selectedChoice - 1];
                  });
                },
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        submitButton,
        cancelButton,
      ],
    );
  }
}
