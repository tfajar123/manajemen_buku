import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLogin) {
        await Provider.of<AuthProvider>(context, listen: false)
            .login(emailController.text, passwordController.text);
      } else {
        await Provider.of<AuthProvider>(context, listen: false)
          .register(nameController.text, emailController.text, passwordController.text, confirmPasswordController.text);
      
      // Show success message if registration is successful
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Register berhasil!'),
        ),
      );
      _isLogin = true;
      emailController.clear();
      passwordController.clear();
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Otentikasi gagal! ${error.toString()}'),
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 43, 43, 43), // Background color
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Icon(
                    Icons.book,
                    size: 100,
                    color: Colors.white, // Icon color
                  ),
                  SizedBox(height: 20),
                  Text(
                    'E-Library',
                    style: TextStyle(
                      color: Colors.white, // Title text color
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  if (!_isLogin)
                    MyTextField(
                      controller: nameController,
                      hintText: 'Name',
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan Nama Anda';
                        }
                        return null;
                      },
                    ),
                  SizedBox(height: 20),
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return 'Masukan email anda';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return 'Masukkan password minimal 6 karakter';
                      }
                      return null;
                    },
                  ),
                  if (!_isLogin) // Add confirm password field only if not logging in
                    Column(
                      children: [
                        SizedBox(height: 20),
                        MyTextField(
                          controller: confirmPasswordController,
                          hintText: 'Confirm Password',
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value != passwordController.text) {
                              return 'Password tidak cocok';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  SizedBox(height: 10),
                  SizedBox(height: 20),
                  if (_isLoading)
                    CircularProgressIndicator()
                  else
                    MyButton(
                      text: _isLogin ? 'Login' : 'Register',
                      onTap: _submit,
                    ),
                  SizedBox(height: 20),
                  TextButton(
                    child: Text(
                      '${_isLogin ? 'Register' : 'Login'}',
                      style: TextStyle(color: Colors.white), // Text color
                    ),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
