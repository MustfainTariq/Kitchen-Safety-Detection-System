import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/Register/forgot_pass.dart';
import '/services/auth_services.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;

  const LoginPage({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false; // To handle loading state
  String _errorMessage = ''; // To display error messages

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim()
      );
      // Proceed if successful
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        // Handle invalid or malformed credential
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Authentication Error"),
            content: Text("The provided credential is incorrect or has expired. Please check your credentials and try again."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      } else {
        // Handle other types of FirebaseAuth exceptions
        print(e.message);
      }
    } catch (e) {
      // Handle other types of exceptions
      print(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Center(
            child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 70),
                    Image.asset('assets/logo2.png', height: 110),
                    SizedBox(height: 20),
                    Text('Welcome Back', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Theme.of(context).colorScheme.secondary)),
                    SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                    ),
                    if (_errorMessage.isNotEmpty) ...[
                      SizedBox(height: 10),
                      Text(_errorMessage, style: TextStyle(color: Colors.red, fontSize: 14)),
                    ],
                    SizedBox(height: 20),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: signIn,
                      child: Text('Sign In'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                      },
                      child: Text('Forgot Password?'),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account? '),
                        GestureDetector(
                          onTap: widget.showRegisterPage,
                          child: Text('Register here', style: TextStyle(decoration: TextDecoration.underline)),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
