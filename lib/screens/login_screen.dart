// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  bool _isPasswordVisible = false;

  // ================= LOGIN FUNCTION =================

  void _login() async {

    String email =
    _emailController.text.trim();

    String password =
    _passwordController.text.trim();

    // EMPTY CHECK

    if (email.isEmpty || password.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill all fields!',
          ),
        ),
      );

      return;
    }

    // LOGIN CHECK

    if (email == 'user@example.com'
        && password == '123456') {

      // SAVE LOGIN STATE

      final box = Hive.box('shoppingBox');

      await box.put('isLoggedIn', true);

      // SUCCESS MESSAGE

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ' Welcome to Shopping App!',
          ),
        ),
      );

      // GO TO HOME

      Navigator.pushReplacementNamed(
        context,
        '/home',
      );

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid email or password!',
          ),
        ),
      );
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        decoration: BoxDecoration(

          gradient: LinearGradient(

            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [
              Colors.deepPurple.shade800,
              Colors.deepPurple.shade400,
            ],
          ),
        ),

        child: Center(

          child: SingleChildScrollView(

            padding: EdgeInsets.all(24),

            child: Card(

              color: Color(0xFF0D0714),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              elevation: 8,

              child: Padding(

                padding: EdgeInsets.all(24),

                child: Column(

                  mainAxisSize: MainAxisSize.min,

                  children: [

                    // ================= LOGO =================

                    CircleAvatar(

                      radius: 50,

                      backgroundColor: Colors.deepPurple,

                      child: Icon(
                        Icons.shopping_cart,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 24),

                    // ================= TITLE =================

                    Text(

                      'Welcome to shopping list app!',

                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(

                      'Login to continue',

                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),

                    SizedBox(height: 32),

                    // ================= EMAIL FIELD =================

                    TextField(

                      controller: _emailController,

                      style: TextStyle(
                        color: Colors.white,
                      ),

                      decoration: InputDecoration(

                        labelText: 'Email',

                        labelStyle: TextStyle(
                          color: Colors.deepPurple,
                        ),

                        hintText: 'user@gmail.com',

                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),

                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.white,
                        ),

                        enabledBorder: OutlineInputBorder(

                          borderRadius:
                          BorderRadius.circular(12),

                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(

                          borderRadius:
                          BorderRadius.circular(12),

                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                            width: 2,
                          ),
                        ),
                      ),

                      keyboardType:
                      TextInputType.emailAddress,
                    ),

                    SizedBox(height: 16),

                    // ================= PASSWORD FIELD =================

                    TextField(

                      controller: _passwordController,

                      obscureText: !_isPasswordVisible,

                      style: TextStyle(
                        color: Colors.white,
                      ),

                      decoration: InputDecoration(

                        labelText: 'Password',

                        labelStyle: TextStyle(
                          color: Colors.white70,
                        ),

                        hintText: 'Enter password',

                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),

                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),

                        suffixIcon: IconButton(

                          icon: Icon(

                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,

                            color: Colors.white,
                          ),

                          onPressed: () {

                            setState(() {

                              _isPasswordVisible =
                              !_isPasswordVisible;
                            });
                          },
                        ),

                        enabledBorder: OutlineInputBorder(

                          borderRadius:
                          BorderRadius.circular(12),

                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(

                          borderRadius:
                          BorderRadius.circular(12),

                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 8),



                    // ================= LOGIN BUTTON =================

                    ElevatedButton(

                      onPressed: _login,

                      style: ElevatedButton.styleFrom(

                        backgroundColor:
                        Colors.deepPurple,

                        minimumSize:
                        Size(double.infinity, 55),

                        shape: RoundedRectangleBorder(

                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                      ),

                      child: Text(

                        'Login',

                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}