import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:twitterclone/modules/home/home_view.dart';
import 'package:twitterclone/modules/login/login_view.dart';
import 'package:twitterclone/modules/register/register_view.dart';


class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  Future<void> checkAlreadyLoggedIn() async {
    if (FirebaseAuth.instance.currentUser != null) {
      if (mounted) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomeView(),
        ));
      }
    } else {
      debugPrint('User Not Logged In');
    }
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      checkAlreadyLoggedIn();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                'assets/images/logo.png',
                cacheHeight: 60,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginView(),
                  ));
                },
                child: const Text('Login'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RegisterView(),
                  ));
                },
                child: const Text('Signup'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
