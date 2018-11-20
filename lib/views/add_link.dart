import 'package:flutter/material.dart';
import 'package:linki/models/main_model.dart';
import 'package:linki/values/status_code.dart';
import 'package:linki/values/strings.dart';
import 'dart:math' as math;
import 'package:scoped_model/scoped_model.dart';

const _tag = 'AddLinkDialog:';

class AddLinkDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _mController = TextEditingController();
    final _textField = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
          controller: _mController,
          cursorColor: Colors.deepOrange,
          autofocus: true,
          maxLines: null,
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          decoration: InputDecoration(
              hintText: enterLinkLabelText,
              hintStyle: TextStyle(
                decoration: TextDecoration.none,
              ),
              prefixIcon: Transform.rotate(
                  angle: -math.pi / 4, child: Icon(Icons.link)))),
    );

    _handleSubmit(MainModel model) async {
      final url = _mController.text.trim();
      if (url.isEmpty) return null;

      StatusCode submitStatus = await model.submitLink(url, model.currentUser);
      switch (submitStatus) {
        case StatusCode.success:
          Navigator.pop(context);
          break;
        default:
          print('$_tag unexpected submit status code : $submitStatus');
      }
    }

    Widget _buildSubmitButton(MainModel model) => FlatButton(
          child: Text(
            submitText.toUpperCase(),
            style: TextStyle(color: Colors.deepOrange),
          ),
          onPressed: () => _handleSubmit(model),
        );

    final _cancelButton = FlatButton(
      child: Text(
        cancelText.toUpperCase(),
      ),
      onPressed: () => Navigator.pop(context),
    );

    Widget _buildActions(MainModel model) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              _buildSubmitButton(model),
              _cancelButton,
            ],
          ),
        );

    return ScopedModelDescendant<MainModel>(
      builder: (_, __, model) => SimpleDialog(
            title: Text(addLinkText),
            children: model.submittingLinkStatus == StatusCode.waiting
                ? 
                <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  ]
                : <Widget>[
                    _textField,
                    _buildActions(model),
                  ],
          ),
    );
  }
}
