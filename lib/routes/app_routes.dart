import 'package:flutter/material.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/add_note_screen/add_note_screen.dart';
import '../presentation/note_details_screen/note_details_screen.dart';
import '../presentation/edit_note_screen/edit_note_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String homeScreen = '/home-screen';
  static const String addNoteScreen = '/add-note-screen';
  static const String noteDetailsScreen = '/note-details-screen';
  static const String editNoteScreen = '/edit-note-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const HomeScreen(),
    homeScreen: (context) => const HomeScreen(),
    addNoteScreen: (context) => const AddNoteScreen(),
    noteDetailsScreen: (context) => const NoteDetailsScreen(),
    editNoteScreen: (context) => const EditNoteScreen(),
  };
}
