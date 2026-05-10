import '../../core/app_export.dart';
import '../../database/database_helper.dart';
import '../../models/note.dart';
import './widgets/home_search_bar_widget.dart';
import './widgets/note_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> _notes = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    final notes = await DatabaseHelper.instance.getAllNotes();
    if (mounted) {
      setState(() {
        _notes = notes;
        _isLoading = false;
      });
    }
  }

  List<Note> get _filteredNotes {
    if (_searchQuery.isEmpty) return _notes;
    final q = _searchQuery.toLowerCase();
    return _notes
        .where(
          (n) =>
              n.title.toLowerCase().contains(q) ||
              n.content.toLowerCase().contains(q),
        )
        .toList();
  }

  void _openNoteDetails(Note note) {
    Navigator.pushNamed(
      context,
      AppRoutes.noteDetailsScreen,
      arguments: note,
    ).then((_) => _loadNotes());
  }

  void _openAddNote() {
    Navigator.pushNamed(
      context,
      AppRoutes.addNoteScreen,
    ).then((_) => _loadNotes());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        centerTitle: false,
        title: Text(
          'SnapNote',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              '${_notes.length} notes',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: HomeSearchBarWidget(
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredNotes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.sticky_note_2_outlined,
                          size: 48,
                          color: theme.colorScheme.onSurfaceVariant.withAlpha(
                            128,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No notes yet'
                              : 'No results found',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (_searchQuery.isEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Tap + to create your first note',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadNotes,
                    color: AppTheme.primary,
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                      itemCount: _filteredNotes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final note = _filteredNotes[index];
                        return NoteCardWidget(
                          key: ValueKey(note.id),
                          note: note,
                          onTap: () => _openNoteDetails(note),
                          onDelete: () async {
                            await DatabaseHelper.instance.deleteNote(note.id!);
                            _loadNotes();
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddNote,
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: const CircleBorder(),
        child: const Icon(Icons.add_rounded, size: 26),
      ),
    );
  }
}
