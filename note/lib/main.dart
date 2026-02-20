import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'screens/notes_list.dart';
import 'models/note.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

  final prefs = await SharedPreferences.getInstance();
  final notesJson = prefs.getStringList('notes') ?? [];
  final notes = notesJson.map((json) => Note.fromJson(jsonDecode(json))).toList();
  
  runApp(MyApp(initialNotes: notes));
}

class MyApp extends StatelessWidget {
  final List<Note> initialNotes;
  
  const MyApp({super.key, required this.initialNotes});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CurrencyNotes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: NotesListScreen(initialNotes: initialNotes),
    );
  }
}