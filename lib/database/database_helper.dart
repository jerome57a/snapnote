import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  static const String _notesKey = 'snapnote_notes';
  static const String _checklistKey = 'snapnote_checklist';
  static int _nextNoteId = 1;
  static int _nextChecklistId = 1;

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  // ── Notes CRUD ──────────────────────────────────────────────

  Future<int> insertNote(Note note) async {
    final prefs = await _prefs;
    final notes = await _loadAllNoteMaps(prefs);
    final checklist = await _loadAllChecklistMaps(prefs);

    // Determine next note id
    int noteId = _nextNoteId;
    if (notes.isNotEmpty) {
      final maxId = notes
          .map((m) => (m['id'] as int? ?? 0))
          .reduce((a, b) => a > b ? a : b);
      noteId = maxId + 1;
    }
    _nextNoteId = noteId + 1;

    final noteMap = note.toMap();
    noteMap['id'] = noteId;
    notes.add(noteMap);

    // Determine next checklist id
    int clId = _nextChecklistId;
    if (checklist.isNotEmpty) {
      final maxId = checklist
          .map((m) => (m['id'] as int? ?? 0))
          .reduce((a, b) => a > b ? a : b);
      clId = maxId + 1;
    }

    for (final item in note.checklistItems) {
      final itemMap = item.copyWith(noteId: noteId).toMap();
      itemMap['id'] = clId++;
      checklist.add(itemMap);
    }
    _nextChecklistId = clId;

    await prefs.setString(_notesKey, jsonEncode(notes));
    await prefs.setString(_checklistKey, jsonEncode(checklist));
    return noteId;
  }

  Future<List<Note>> getAllNotes() async {
    final prefs = await _prefs;
    final noteMaps = await _loadAllNoteMaps(prefs);
    final checklistMaps = await _loadAllChecklistMaps(prefs);

    // Sort by created_at DESC
    noteMaps.sort((a, b) {
      final aDate =
          DateTime.tryParse(a['created_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      final bDate =
          DateTime.tryParse(b['created_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });

    return noteMaps.map((map) {
      final note = Note.fromMap(map);
      final items = checklistMaps
          .where((c) => c['note_id'] == note.id)
          .map(ChecklistItem.fromMap)
          .toList();
      return note.copyWith(checklistItems: items);
    }).toList();
  }

  Future<Note?> getNoteById(int id) async {
    final prefs = await _prefs;
    final noteMaps = await _loadAllNoteMaps(prefs);
    final checklistMaps = await _loadAllChecklistMaps(prefs);

    final maps = noteMaps.where((m) => m['id'] == id).toList();
    if (maps.isEmpty) return null;
    final items = checklistMaps
        .where((c) => c['note_id'] == id)
        .map(ChecklistItem.fromMap)
        .toList();
    return Note.fromMap(maps.first).copyWith(checklistItems: items);
  }

  Future<int> updateNote(Note note) async {
    final prefs = await _prefs;
    final notes = await _loadAllNoteMaps(prefs);
    final checklist = await _loadAllChecklistMaps(prefs);

    final idx = notes.indexWhere((m) => m['id'] == note.id);
    if (idx == -1) return 0;

    final noteMap = note.toMap();
    noteMap['id'] = note.id;
    notes[idx] = noteMap;

    // Remove old checklist items for this note
    checklist.removeWhere((c) => c['note_id'] == note.id);

    // Determine next checklist id
    int clId = 1;
    if (checklist.isNotEmpty) {
      final maxId = checklist
          .map((m) => (m['id'] as int? ?? 0))
          .reduce((a, b) => a > b ? a : b);
      clId = maxId + 1;
    }

    for (final item in note.checklistItems) {
      final itemMap = item.copyWith(noteId: note.id).toMap();
      itemMap['id'] = clId++;
      checklist.add(itemMap);
    }

    await prefs.setString(_notesKey, jsonEncode(notes));
    await prefs.setString(_checklistKey, jsonEncode(checklist));
    return 1;
  }

  Future<int> deleteNote(int id) async {
    final prefs = await _prefs;
    final notes = await _loadAllNoteMaps(prefs);
    final checklist = await _loadAllChecklistMaps(prefs);

    notes.removeWhere((m) => m['id'] == id);
    checklist.removeWhere((c) => c['note_id'] == id);

    await prefs.setString(_notesKey, jsonEncode(notes));
    await prefs.setString(_checklistKey, jsonEncode(checklist));
    return 1;
  }

  Future<List<Note>> searchNotes(String query) async {
    final all = await getAllNotes();
    final q = query.toLowerCase();
    return all
        .where(
          (n) =>
              n.title.toLowerCase().contains(q) ||
              n.content.toLowerCase().contains(q),
        )
        .toList();
  }

  // ── Checklist CRUD ──────────────────────────────────────────

  Future<List<ChecklistItem>> getChecklistItems(int noteId) async {
    final prefs = await _prefs;
    final checklistMaps = await _loadAllChecklistMaps(prefs);
    return checklistMaps
        .where((c) => c['note_id'] == noteId)
        .map(ChecklistItem.fromMap)
        .toList();
  }

  Future<int> updateChecklistItem(ChecklistItem item) async {
    final prefs = await _prefs;
    final checklist = await _loadAllChecklistMaps(prefs);

    final idx = checklist.indexWhere((c) => c['id'] == item.id);
    if (idx == -1) return 0;
    checklist[idx] = item.toMap();
    await prefs.setString(_checklistKey, jsonEncode(checklist));
    return 1;
  }

  // ── Private helpers ─────────────────────────────────────────

  Future<List<Map<String, dynamic>>> _loadAllNoteMaps(
    SharedPreferences prefs,
  ) async {
    final raw = prefs.getString(_notesKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _loadAllChecklistMaps(
    SharedPreferences prefs,
  ) async {
    final raw = prefs.getString(_checklistKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }
}
