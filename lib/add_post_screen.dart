import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';

// Mimics the functionality of the provided React PostEditor component.
class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  // Editor state
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  final _codeController = TextEditingController();

  // For simplicity, we'll manage a list of file names.
  // A full implementation would require a file picker and managing File objects.
  final List<String> _files = [];

  String _codeLang = 'javascript';
  bool _isLoading = false;

  // Simple markdown-style toolbar actions
  void _wrapSelection(String prefix, [String? suffix]) {
    final text = _descriptionController.text;
    final selection = _descriptionController.selection;
    if (!selection.isValid) return;

    final start = selection.start;
    final end = selection.end;
    final selectedText = selection.textInside(text);
    
    final newText = text.substring(0, start) +
        prefix +
        selectedText +
        (suffix ?? prefix) +
        text.substring(end);

    _descriptionController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: end + prefix.length + (suffix?.length ?? prefix.length)),
    );
  }

  void _insertAtCursor(String content) {
      final text = _descriptionController.text;
      final selection = _descriptionController.selection;
      if (!selection.isValid) return;

      final start = selection.start;
      final newText = text.substring(0, start) + content + text.substring(start);
      _descriptionController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: start + content.length),
      );
  }


  Future<void> _submitPost() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a title')),
      );
      return;
    }

    setState(() { _isLoading = true; });

    final authService = Provider.of<AuthService>(context, listen: false);
    
    final postData = {
      'titles': _titleController.text,
      'caption': _descriptionController.text,
      'tags': _tagsController.text.split(',').map((s) => s.trim()).toList(),
      'location': '', // Placeholder
      'code_snippet': {
        'language': _codeLang,
        'content': _codeController.text,
      },
    };

    try {
      await authService.createPost(postData); 
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created!')),
        );
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create post: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitPost,
              child: _isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2,))
                  : const Text('Publish'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Post Title',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Toolbar and Description
            _buildDescriptionEditor(),
            const SizedBox(height: 16),

            // Code Editor
            _buildCodeEditor(),
            const SizedBox(height: 16),

            // Attachments - simplified
            _buildAttachments(),
            const SizedBox(height: 16),

            // Tags
            TextField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: 'Tags (comma separated)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        // Toolbar
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              IconButton(icon: const Icon(Icons.format_bold), onPressed: () => _wrapSelection('**')),
              IconButton(icon: const Icon(Icons.format_italic), onPressed: () => _wrapSelection('*')),
              IconButton(icon: const Icon(Icons.looks_one), onPressed: () => _insertAtCursor('# ')),
              IconButton(icon: const Icon(Icons.looks_two), onPressed: () => _insertAtCursor('## ')),
              IconButton(icon: const Icon(Icons.format_list_bulleted), onPressed: () => _insertAtCursor('\n- ')),
              IconButton(icon: const Icon(Icons.format_list_numbered), onPressed: () => _insertAtCursor('\n1. ')),
              IconButton(icon: const Icon(Icons.code), onPressed: () => _wrapSelection('`')),
              IconButton(icon: const Icon(Icons.insert_link), onPressed: () {
                  // Simplified link insertion
                  _wrapSelection('[', '](url)');
              }),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Editor
        TextField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Write your post content...',
          ),
          maxLines: 10,
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }

  Widget _buildCodeEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Code Snippet', style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            DropdownButton<String>(
              value: _codeLang,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _codeLang = newValue;
                  });
                }
              },
              items: <String>['javascript', 'typescript', 'python', 'java', 'csharp', 'sql', 'json', 'dart']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _codeController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Paste your code here...',
          ),
          maxLines: 8,
          style: const TextStyle(fontFamily: 'monospace'),
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }

  Widget _buildAttachments() {
    // File picking is a complex operation that requires a dependency
    // like file_picker. As I cannot add dependencies, I will just
    // show a placeholder button.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Attachments', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('File picking is not implemented in this version.')),
            );
          },
          icon: const Icon(Icons.attach_file),
          label: const Text('Add Files'),
        ),
        // Display selected files (mock)
        ..._files.map((fileName) => Text(fileName)),
      ],
    );
  }
}
