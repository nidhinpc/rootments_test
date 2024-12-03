import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rootments_test/view/home_screen/home_screen.dart';
import 'package:rootments_test/controller/home_screen_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final HomeScreenController _controller = HomeScreenController();

  // Handle Login
  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final employeeId = _employeeIdController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      try {
        // Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        // Validate if employeeId and email match with the API response
        await _controller.getData(employeeId: employeeId, email: email);

        final isValidEmployee = _controller.dataList.any(
          (data) =>
              data?.data?.employeeId == employeeId &&
              data?.data?.emailId == email,
        );

        if (!isValidEmployee) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid Employee ID or Email')),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // Fetch user data from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;

          // Check if Employee ID matches the Firebase data
          if (userData['employeeId'] == employeeId &&
              userData['emailId'] == email) {
            // Navigate to HomeScreen and pass employeeId as a parameter
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  employeeId: employeeId,
                  email: email,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Employee ID does not match.')),
            );
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                employeeId: employeeId,
                email: email,
              ),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        String message = 'An error occurred. Please try again.';
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred.')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Employee ID
                      TextFormField(
                        controller: _employeeIdController,
                        decoration: const InputDecoration(
                          labelText: 'Employee ID',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Email ID
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email ID',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      // Password
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_isPasswordVisible,
                      ),
                      const SizedBox(height: 24),
                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleLogin,
                          child: const Text('Login'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
