import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../providers/auth_provider.dart';
import 'book_edit_screen.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<BookProvider>(context, listen: false).fetchBooks();
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final books = bookProvider.books;

    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Buku', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 20, 20, 20),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchBooks,
              child: books.isEmpty
                  ? Center(child: Text('No books added yet.', style: TextStyle(color: Colors.white)))
                  : ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (ctx, i) {
                        final book = books[i];
                        return Card(
                          color: Colors.grey[850],
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            leading: Icon(Icons.book, color: Colors.white),
                            title: Text(book.title, style: TextStyle(color: Colors.white)),
                            subtitle: Text(book.author, style: TextStyle(color: Colors.grey[400])),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BookEditScreen(book: book),
                                ),
                              );
                            },
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                try {
                                  await bookProvider.deleteBook(book.id);
                                } catch (error) {
                                  print(error);
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
      backgroundColor: Color.fromARGB(255, 43, 43, 43), // Set the background color of the screen
    );
  }
}

class BottomNavBarScreen extends StatefulWidget {
  @override
  _BottomNavBarScreenState createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    BookListScreen(),
    BookEditScreen(),
    Text('Logout'),
  ];

  void _onItemTapped(int index) async {
    if (index == 2) {
      // Handle logout
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 43, 43, 43),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Tambah',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
