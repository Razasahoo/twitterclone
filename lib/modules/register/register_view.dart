import 'package:flutter/material.dart';
import 'package:twitterclone/modules/home/home_view.dart';
import 'package:twitterclone/service/auth_service.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  var isPasswordObscure = false;
  var isConfirmPasswordObscure = false;
  final authService = AuthService();
  bool isValidEmail(String value) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value);
  }

  Widget getObscurePassword() {
    if (!isPasswordObscure) {
      return IconButton(
        onPressed: () {
          setState(() {
            isPasswordObscure = true;
          });
        },
        icon: const Icon(Icons.visibility_off_outlined),
      );
    } else {
      return IconButton(
        onPressed: () {
          setState(() {
            isPasswordObscure = false;
          });
        },
        icon: const Icon(Icons.visibility_outlined),
      );
    }
  }

  Widget getObscureConfirmPassword() {
    if (!isConfirmPasswordObscure) {
      return IconButton(
        onPressed: () {
          setState(() {
            isConfirmPasswordObscure = true;
          });
        },
        icon: const Icon(Icons.visibility_off_outlined),
      );
    } else {
      return IconButton(
        onPressed: () {
          setState(() {
            isConfirmPasswordObscure = false;
          });
        },
        icon: const Icon(Icons.visibility_outlined),
      );
    }
  }

  Future<void> signup() async {
    if (_formkey.currentState!.validate()) {
      try {
        final user = await authService.signupUser(
            email: emailController.text, password: passwordController.text);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('User ${user.user?.email} Signed up successfully')));
          Future.delayed(
            const Duration(seconds: 2),
            () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const HomeView(),
              ));
            },
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } else {
      debugPrint('Invalid Form');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    cacheHeight: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Enter Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value != null) {
                          if (!isValidEmail(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: isPasswordObscure,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Enter Passwords',
                        border: const OutlineInputBorder(),
                        suffixIcon: getObscurePassword(),
                      ),
                      validator: (value) {
                        if (value != null) {
                          if (value.length < 8) {
                            return 'Password length must be 8 letters';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: confirmpasswordController,
                      obscureText: isConfirmPasswordObscure,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Enter Password Again',
                          border: const OutlineInputBorder(),
                          suffixIcon: getObscureConfirmPassword()),
                      validator: (value) {
                        if (value != null) {
                          if (value.length < 8) {
                            return 'Password length must be 8 letters';
                          } else if (value != passwordController.text) {
                            return 'Password Mismatch';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => signup(),
                    child: const Text('Signup'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
