import 'package:flutter/material.dart';

// Model for User
class User {
  final String name;
  final String address;
  final String password;

  User({required this.name, required this.address, required this.password});
}

// Model for Location Note
class LocationNote {
  String name;
  String description;
  String pictureUrl; // Simulating picture with a URL or placeholder
  LocationNote(
      {required this.name, required this.description, required this.pictureUrl});
}

// Main App
void main() {
  runApp(RememberTheLocationApp());
}

class RememberTheLocationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remember the Location',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RegistrationScreen(),
    );
  }
}

// Registration Screen (Q1)
class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();

  void _register() {
    if (_nameController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      User user = User(
        name: _nameController.text,
        address: _addressController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NotesScreen(user: user),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

// Notes Screen (Q2 & Q3)
class NotesScreen extends StatefulWidget {
  final User user;
  NotesScreen({required this.user});

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<LocationNote> notes = [];
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pictureController = TextEditingController();
  int? _editingIndex;

  void _addOrUpdateNote() {
    if (_nameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      setState(() {
        if (_editingIndex != null) {
          // Update existing note
          notes[_editingIndex!] = LocationNote(
            name: _nameController.text,
            description: _descriptionController.text,
            pictureUrl: _pictureController.text.isEmpty
                ? 'No Picture'
                : _pictureController.text,
          );
          _editingIndex = null;
        } else {
          // Add new note
          notes.add(LocationNote(
            name: _nameController.text,
            description: _descriptionController.text,
            pictureUrl: _pictureController.text.isEmpty
                ? 'No Picture'
                : _pictureController.text,
          ));
        }
        _nameController.clear();
        _descriptionController.clear();
        _pictureController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill name and description')),
      );
    }
  }

  void _editNote(int index) {
    setState(() {
      _editingIndex = index;
      _nameController.text = notes[index].name;
      _descriptionController.text = notes[index].description;
      _pictureController.text = notes[index].pictureUrl == 'No Picture'
          ? ''
          : notes[index].pictureUrl;
    });
  }

  void _deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Show profile but no edit option (Q3)
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Profile'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Name: ${widget.user.name}'),
                      Text('Address: ${widget.user.address}'),
                      Text('Password: ${widget.user.password}'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Location Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _pictureController,
              decoration: InputDecoration(labelText: 'Picture URL (Optional)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addOrUpdateNote,
              child: Text(_editingIndex != null ? 'Update Note' : 'Add Note'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(notes[index].name),
                    subtitle: Text(notes[index].description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editNote(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteNote(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}