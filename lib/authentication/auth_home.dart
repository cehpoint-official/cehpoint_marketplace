// ignore_for_file: use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cehpoint_marketplace/authentication/Views/loginView/login_view.dart';
import 'package:cehpoint_marketplace/common/utils.dart';
import 'package:cehpoint_marketplace/home/home_screen.dart';

class AuthHome extends StatelessWidget {
  const AuthHome({Key? key});

  @override
  Widget build(BuildContext context) {
    final stream = FirebaseAuth.instance.authStateChanges();

    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (ConnectionState.waiting == snapshot.connectionState) {
          return Utils.customLoadingSpinner();
        } else if (snapshot.hasError) {
          // Handle error scenario
          return const Center(
            child: Text('An error occurred!'),
          );
        } else if (snapshot.hasData) {
          return const HomeScreen();
        }
        return const LoginView();
      },
    );
  }
}
