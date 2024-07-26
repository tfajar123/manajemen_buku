import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  String? _token;

  List<Book> get books => _books;

  BookProvider() {
    _retrieveToken();
  }
  void updateToken(String? token) {
    _token = token;
  }

  Future<void> _retrieveToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  Future<void> fetchBooks() async {
    final url = Uri.parse('http://memoapptedc.c1.is/api/books');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _books = data.map((json) => Book.fromJson(json)).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<void> addBook(String title, String author, String year, String category) async {
    final url = Uri.parse('http://memoapptedc.c1.is/api/books');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'title': title,
        'author': author,
        'year': year,
        'category': category,
      }),
    );

    if (response.statusCode == 201) {
      final newBook = Book.fromJson(json.decode(response.body));
      _books.add(newBook);
      notifyListeners();
    } else {
      throw Exception('Failed to add Book' + response.body);
    }
  }

  Future<void> updateBook(int id, String title, String author, String year, String category) async {
    final url = Uri.parse('http://memoapptedc.c1.is/api/books/$id');
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'title': title,
        'author': author,
        'year': year,
        'category': category,
      }),
    );

    if (response.statusCode == 200) {
      final updatedBook = Book.fromJson(json.decode(response.body));
      final index = _books.indexWhere((n) => n.id == id);
      if (index != -1) {
        _books[index] = updatedBook;
        notifyListeners();
      }
    } else {
      throw Exception('Failed to update book');
    }
  }

  Future<void> deleteBook(int id) async {
    final url = Uri.parse('http://memoapptedc.c1.is/api/books/$id');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 204) {
      _books.removeWhere((book) => book.id == id);
      notifyListeners();
    } else {
      throw Exception('Failed to delete book');
    }
  }
}
