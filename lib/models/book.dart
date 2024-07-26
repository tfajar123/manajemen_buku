// models/book.dart
class Book {
  int id;
  String title;
  String author;
  String year;
  String category;

  Book({
    required this.id, 
    required this.title, 
    required this.author, 
    required this.year, 
    required this.category
    });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      year: json['year'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'year': year,
      'category': category,
    };
  }
}
