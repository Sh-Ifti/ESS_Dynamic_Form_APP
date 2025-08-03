import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SubmissionViewPage extends StatelessWidget {
  final Map<String, dynamic> responses;
  SubmissionViewPage({required this.responses});

  Future<void> _saveToFile(BuildContext context) async {
    final directory = await getApplicationDocumentsDirectory();
    final path =
        '${directory.path}/form_submission_${DateTime.now().millisecondsSinceEpoch}.json';
    final file = File(path);
    await file.writeAsString(jsonEncode(responses));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Form saved to $path')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Submission Summary')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: responses.entries
            .map((e) => ListTile(
                  title: Text(e.key),
                  subtitle: Text(e.value.toString()),
                ))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _saveToFile(context),
        icon: Icon(Icons.save),
        label: Text('Save'),
      ),
    );
  }
}
