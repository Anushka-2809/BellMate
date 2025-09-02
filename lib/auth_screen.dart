import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'auth_service.dart';
import 'gradient_button.dart';

enum AuthMode { SignUp, Login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      if (_authMode == AuthMode.Login) {
        await authService.signInWithEmailAndPassword(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        await authService.createUserWithEmailAndPassword(
          _authData['email']!,
          _authData['password']!,
        );
      }
      if (mounted) {
        context.go('/home');
      }
    } catch (error) {
      _showErrorDialog('An unexpected error occurred. Please try again.');
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _switchAuthMode() {
    setState(() {
      _authMode =
          _authMode == AuthMode.Login ? AuthMode.SignUp : AuthMode.Login;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 12,
              color: Colors.white.withOpacity(0.9), // Fixed opacity
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(
                        Icons.lock_outline,
                        size: 72,
                        color: Colors.black87,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _authMode == AuthMode.Login
                            ? "Welcome Back"
                            : "Create Account",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'E-Mail',
                          prefixIcon: const Icon(Icons.email_outlined),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || !value.contains('@')) {
                            return 'Invalid email!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _authData['email'] = value ?? '';
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        obscureText: true,
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.length < 5) {
                            return 'Password is too short!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _authData['password'] = value ?? '';
                        },
                      ),
                      if (_authMode == AuthMode.SignUp) ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          enabled: _authMode == AuthMode.SignUp,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                            return null;
                          },
                        ),
                      ],
                      const SizedBox(height: 24),
                      if (_isLoading)
                        const CircularProgressIndicator()
                      else
                        GradientButton(
                          onPressed: _submit,
                          text: _authMode == AuthMode.Login
                              ? 'LOGIN'
                              : 'SIGN UP',
                        ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _switchAuthMode,
                        child: Text(
                          _authMode == AuthMode.Login
                              ? "Don't have an account? Sign Up"
                              : "Already have an account? Login",
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
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
