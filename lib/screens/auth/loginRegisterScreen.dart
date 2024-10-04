import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/userprovider.dart';
import '../homeScreen.dart';


class LoginRegisterScreen extends StatefulWidget {
  @override
  _LoginRegisterScreenState createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _isLoginMode = true;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).initializeUser().then((_) {
      if (Provider.of<UserProvider>(context, listen: false).isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    });
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.login(_emailController.text, _passwordController.text);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match')));
        return;
      }

      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.register(
          _usernameController.text,
          _emailController.text,
          _passwordController.text,
        );
        setState(() {
          _isLoginMode = true; // Switch to login mode
          // Clear the text fields
          _emailController.clear();
          _passwordController.clear();
          _confirmPasswordController.clear();
          _usernameController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration successful! Please log in.')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isLoginMode ? 'Login' : 'Register',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      if (!_isLoginMode)
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(labelText: 'Username'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a username.';
                            }
                            return null;
                          },
                        ),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email.';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_isPasswordVisible,
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return 'Password must be at least 6 characters.';
                          }
                          return null;
                        },
                      ),
                      if (!_isLoginMode)
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_isConfirmPasswordVisible,
                          validator: (value) {
                            if (value == null || value != _passwordController.text) {
                              return 'Passwords do not match.';
                            }
                            return null;
                          },
                        ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isLoginMode ? _login : _register,
                        child: Text(_isLoginMode ? 'Login' : 'Register'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLoginMode = !_isLoginMode;
                            // Clear the text fields when switching modes
                            _emailController.clear();
                            _passwordController.clear();
                            _confirmPasswordController.clear();
                            _usernameController.clear(); // Clear username field if switching to login
                          });
                        },
                        child: Text(_isLoginMode
                            ? "Don't have an account? Register"
                            : "Already have an account? Login"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
