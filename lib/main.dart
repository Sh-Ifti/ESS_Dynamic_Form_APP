import 'package:flutter/material.dart';
import 'ui/form_list_page.dart';
import 'ui/saved_files_page.dart';

void main() {
  runApp(DynamicFormApp());
}

class DynamicFormApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Forms',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFE3F2FD),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: FormListPage(),
      routes: {
        '/saved': (_) => SavedFilesPage(),
      },
    );
  }
}
