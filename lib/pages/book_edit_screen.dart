import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../models/book.dart';

class BookEditScreen extends StatefulWidget {
  final Book? book;

  BookEditScreen({this.book});

  @override
  _BookEditScreenState createState() => _BookEditScreenState();
}

class _BookEditScreenState extends State<BookEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _yearController;
  late TextEditingController _categoryController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book?.title ?? '');
    _authorController = TextEditingController(text: widget.book?.author ?? '');
    _yearController = TextEditingController(text: widget.book?.year ?? '');
    _categoryController = TextEditingController(text: widget.book?.category ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _yearController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _saveForm() async {
  if (_formKey.currentState!.validate()) {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);

    try {
      if (widget.book == null) {
        await bookProvider.addBook(
          _titleController.text,
          _authorController.text,
          _yearController.text,
          _categoryController.text,
        );
        _titleController.clear();
        _authorController.clear();
        _yearController.clear();
        _categoryController.clear();
      } else {
        await bookProvider.updateBook(
          widget.book!.id,
          _titleController.text,
          _authorController.text,
          _yearController.text,
          _categoryController.text,
        );
      }

      // Show success dialog
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Success'),
          content: Text('Buku ${widget.book == null ? 'ditambahkan' : 'diedit'}'),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      );
    } catch (error) {
      // Show error dialog
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text('Failed to save the book. Please try again.' + error.toString()),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
    }
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book == null ? 'Buku Baru' : 'Edit Buku',style: TextStyle(fontSize: 20),),
        backgroundColor: Color.fromARGB(255, 20, 20, 20), // Matching color from BookListScreen
        titleTextStyle: TextStyle(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Judul',
                  labelStyle: TextStyle(color: Colors.white), // Label color
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white), // Text color
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukan Judul Buku!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: 'Penulis',
                  labelStyle: TextStyle(color: Colors.white), // Label color
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white), // Text color
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukan Penulis Buku!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(
                  labelText: 'Tahun Terbit',
                  labelStyle: TextStyle(color: Colors.white), // Label color
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white), // Text color
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukan tahun terbit buku!';
                  }
                  final int? year = int.tryParse(value);
                  if (year == null || year <= 0) {
                    return 'Tahun terbit tidak valid!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  labelStyle: TextStyle(color: Colors.white), // Label color
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[700]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white), // Text color
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan kategori buku!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 20, 20, 20), // Button color
                  onPrimary: Colors.white, // Text color on button
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 43, 43, 43), // Background color
    );
  }
}
