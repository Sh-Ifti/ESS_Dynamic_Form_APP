import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SavedFilesPage extends StatefulWidget {
  @override
  _SavedFilesPageState createState() => _SavedFilesPageState();
}

class _SavedFilesPageState extends State<SavedFilesPage> {
  List<FileSystemEntity> savedFiles = [];

  @override
  void initState() {
    super.initState();
    _loadSavedFiles();
  }

  Future<void> _loadSavedFiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final files =
        dir.listSync().where((f) => f.path.endsWith(".json")).toList();
    setState(() => savedFiles = files);
  }

  Future<String> _readFile(File file) async {
    return await file.readAsString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Saved Submissions')),
      body: savedFiles.isEmpty
          ? Center(child: Text('No saved files found.'))
          : ListView.builder(
              itemCount: savedFiles.length,
              itemBuilder: (context, index) {
                final file = savedFiles[index];
                return ListTile(
                  title: Text(file.uri.pathSegments.last),
                  onTap: () async {
                    final content = await _readFile(File(file.path));
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Submission Data'),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: jsonDecode(content)
                                .entries
                                .map<Widget>((entry) {
                              final key = entry.key;
                              final label = key
                                  .replaceAll('_', ' ')
                                  .replaceAll(RegExp(r'\\d'), '')
                                  .trim()
                                  .split(' ')
                                  .map((word) => word.isNotEmpty
                                      ? word[0].toUpperCase() +
                                          word.substring(1)
                                      : '')
                                  .join(' ');
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text('$label: ${entry.value}'),
                              );
                            }).toList(),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Close'),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back),
        label: Text('Back'),
      ),
    );
  }
}
