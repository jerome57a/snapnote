import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('snapnote.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _onConfigure,
    );
  }

  // Ensures that deleting a Note also deletes its connected ChecklistItems
  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textNullableType = 'TEXT';
    const boolType = 'INTEGER NOT NULL';

    // Create the Notes table
    await db.execute('''
CREATE TABLE notes (
  id $idType,
  title $textType,
  content $textType,
  image_path $textNullableType,
  is_important $boolType,
  created_at $textType
  )
''');

    // Create the Checklist table linked to the Notes table
    await db.execute('''
CREATE TABLE checklist_items (
  id $idType,
  note_id INTEGER NOT NULL,
  task_text $textType,
  is_done $boolType,
  FOREIGN KEY (note_id) REFERENCES notes (id) ON DELETE CASCADE
  )
''');
  }

  Future<void> insertNote(Note note) async {
    final db = await instance.database;
    
    // Insert the main note and retrieve the auto-generated ID
    final noteId = await db.insert('notes', note.toMap());

    // Insert any associated checklist items with the new note ID
    if (note.checklistItems.isNotEmpty) {
      for (var item in note.checklistItems) {
        final itemMap = item.toMap();
        itemMap['note_id'] = noteId; 
        await db.insert('checklist_items', itemMap);
      }
    }
  }

  Future<List<Note>> getAllNotes() async {
    final db = await instance.database;

    // Fetch notes ordered by newest first
    final noteMaps = await db.query('notes', orderBy: 'created_at DESC');

    List<Note> notes = [];
    
    for (var map in noteMaps) {
      final noteId = map['id'] as int;
      
      // Fetch checklist items for this specific note
      final checklistMaps = await db.query(
        'checklist_items',
        where: 'note_id = ?',
        whereArgs: [noteId],
      );
      
      final checklistItems = checklistMaps
          .map((cMap) => ChecklistItem.fromMap(cMap))
          .toList();
      
      // Combine the note map with its checklist items
      var note = Note.fromMap(map);
      note = note.copyWith(checklistItems: checklistItems);
      
      notes.add(note);
    }

    return notes;
  }

  // Called by EditNoteScreen
  Future<void> updateNote(Note note) async {
    final db = await instance.database;
    
    // 1. Update the main note details
    await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );

    // 2. Clear old checklist items for this note
    await db.delete(
      'checklist_items',
      where: 'note_id = ?',
      whereArgs: [note.id],
    );

    // 3. Insert the newly updated/reordered checklist items
    if (note.checklistItems.isNotEmpty) {
      for (var item in note.checklistItems) {
        final itemMap = item.toMap();
        itemMap.remove('id'); // Remove old ID so SQLite generates a fresh one
        itemMap['note_id'] = note.id; 
        await db.insert('checklist_items', itemMap);
      }
    }
  }

  // Called by NoteDetailsScreen when crossing off an item
  Future<void> updateChecklistItem(ChecklistItem item) async {
    final db = await instance.database;
    
    await db.update(
      'checklist_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> deleteNote(int id) async {
    final db = await instance.database;
    
    // Deleting the note will cascade and delete the checklist items automatically
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}