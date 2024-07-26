import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:intl/date_symbol_data_local.dart';

import 'providers/auth_provider.dart';
import 'providers/book_provider.dart';
import 'pages/book_list_screen.dart';
import 'pages/auth_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // initializeDateFormatting('id_ID', null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, BookProvider>(
          create: (ctx) => BookProvider(),
          update: (ctx, auth, previousBooks) {
            final bookProvider = previousBooks ?? BookProvider();
            bookProvider.updateToken(auth.token);
            return bookProvider;
          },
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Event CRUD App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: auth.isAuth ? BottomNavBarScreen() : AuthScreen(),
        ),
      ),
    );
  }
}
