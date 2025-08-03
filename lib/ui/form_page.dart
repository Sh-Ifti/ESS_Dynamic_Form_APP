import 'package:flutter/material.dart';
import '../models/form_model.dart';
import 'submission_view_page.dart';
import 'dart:convert';

class FormPage extends StatefulWidget {
  final FormModel form;
  FormPage({required this.form});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final Map<String, dynamic> _responses = {};
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.form.formName)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(12),
          children: widget.form.sections
              .expand((section) => [
                    Text(section.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    ...section.fields.map((field) => buildField(field)),
                    SizedBox(height: 16),
                  ])
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubmissionViewPage(responses: _responses),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildField(FieldModel field) {
    final props = field.properties;
    switch (field.id) {
      case 1:
        return TextFormField(
          decoration: InputDecoration(
              labelText: props['label'], hintText: props['hintText']),
          initialValue: props['defaultValue'],
          minLines: 1,
          maxLines: 3,
          validator: (val) {
            if (val == null || val.isEmpty) return 'Required';
            if (val.length < props['minLength']) return 'Too short';
            if (val.length > props['maxLength']) return 'Too long';
            return null;
          },
          onSaved: (val) => _responses[field.key] = val,
        );
      case 2:
        final List items = List<Map<String, dynamic>>.from(
          jsonDecode(props['listItems']),
        );
        if (props['multiSelect'] == true) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(props['label'],
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...items.map((item) {
                final key = '${field.key}_${item['value']}';
                return CheckboxListTile(
                  title: Text(item['name']),
                  value: _responses[key] ?? false,
                  onChanged: (val) => setState(() => _responses[key] = val),
                );
              }),
            ],
          );
        } else {
          return DropdownButtonFormField(
            decoration: InputDecoration(labelText: props['label']),
            items: items
                .map((item) => DropdownMenuItem(
                      value: item['value'],
                      child: Text(item['name']),
                    ))
                .toList(),
            onChanged: (val) => _responses[field.key] = val,
          );
        }
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(props['label']),
            Row(
              children: ['Yes', 'No', 'N/A']
                  .map((e) => Expanded(
                        child: RadioListTile(
                          title: Text(e),
                          value: e,
                          groupValue: _responses[field.key],
                          onChanged: (val) =>
                              setState(() => _responses[field.key] = val),
                        ),
                      ))
                  .toList(),
            ),
          ],
        );
      case 4:
        return ListTile(
          title: Text(props['label']),
          subtitle: Text('Image input not implemented'),
        );
      default:
        return Container();
    }
  }
}
