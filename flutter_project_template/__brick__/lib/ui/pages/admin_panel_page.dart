import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../core/services/cloud_functions/cloud_functions_dao.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'Moderator',
                    decoration:
                        InputDecoration(hintText: 'enter moderator email'),
                  )
                ],
              )),
        ),
        ElevatedButton(
            onPressed: () {
              _formKey.currentState!.save();
              if (_formKey.currentState!.validate()) {
                print(_formKey.currentState!.value['Moderator']);
                String modEmail = _formKey.currentState!.value['Moderator'];
                Provider.of<CloudFunctionsDAO>(context, listen: false)
                    .addModerator(modEmail);
                _formKey.currentState!.reset();
              } else {
                print("validation failed");
              }
            },
            child: Text('Submit Moderator'))
      ],
    );
  }
}
