class Note {
  final int? id;
  final String title;
  final String content;
  final String? imagePath;
  final bool isImportant;
  final DateTime createdAt;
  final List<ChecklistItem> checklistItems;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.imagePath,
    this.isImportant = false,
    required this.createdAt,
    this.checklistItems = const [],
  });

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      imagePath: map['image_path'] as String?,
      isImportant: (map['is_important'] as int? ?? 0) == 1,
      createdAt:
          DateTime.tryParse(map['created_at'] as String? ?? '') ??
          DateTime.now(),
      checklistItems: [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'content': content,
      'image_path': imagePath,
      'is_important': isImportant ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Note copyWith({
    int? id,
    String? title,
    String? content,
    String? imagePath,
    bool? isImportant,
    DateTime? createdAt,
    List<ChecklistItem>? checklistItems,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      imagePath: imagePath ?? this.imagePath,
      isImportant: isImportant ?? this.isImportant,
      createdAt: createdAt ?? this.createdAt,
      checklistItems: checklistItems ?? this.checklistItems,
    );
  }
}

class ChecklistItem {
  final int? id;
  final int? noteId;
  final String taskText;
  final bool isDone;

  ChecklistItem({
    this.id,
    this.noteId,
    required this.taskText,
    this.isDone = false,
  });

  factory ChecklistItem.fromMap(Map<String, dynamic> map) {
    return ChecklistItem(
      id: map['id'] as int?,
      noteId: map['note_id'] as int?,
      taskText: map['task_text'] as String? ?? '',
      isDone: (map['is_done'] as int? ?? 0) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (noteId != null) 'note_id': noteId,
      'task_text': taskText,
      'is_done': isDone ? 1 : 0,
    };
  }

  ChecklistItem copyWith({
    int? id,
    int? noteId,
    String? taskText,
    bool? isDone,
  }) {
    return ChecklistItem(
      id: id ?? this.id,
      noteId: noteId ?? this.noteId,
      taskText: taskText ?? this.taskText,
      isDone: isDone ?? this.isDone,
    );
  }
}
