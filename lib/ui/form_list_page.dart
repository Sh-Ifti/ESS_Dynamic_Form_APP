import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/form_model.dart';
import 'form_page.dart';
import 'package:flutter/services.dart' show rootBundle;

class FormListPage extends StatefulWidget {
  @override
  _FormListPageState createState() => _FormListPageState();
}

class _FormListPageState extends State<FormListPage> {
  List<FormModel> forms = [];

  @override
  void initState() {
    super.initState();
    loadForms();
  }

  Future<void> loadForms() async {
    final assets = [
      'assets/form_1.json',
      'assets/form_2.json',
      'assets/form_3.json'
    ];
    final loaded = await Future.wait(
      assets.map((file) async =>
          FormModel.fromJson(json.decode(await rootBundle.loadString(file)))),
    );
    setState(() => forms = loaded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dynamic Forms')),
      body: Container(
        color: Color(0xFFE3F2FD),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/saved'),
                child: Text('View Saved Submissions'),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                itemCount: forms.length,
                itemBuilder: (context, index) {
                  final form = forms[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.0),
                    child: Card(
                      elevation: 2,
                      child: ListTile(
                        tileColor: Colors.white,
                        title: Text(form.formName),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FormPage(form: form),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
