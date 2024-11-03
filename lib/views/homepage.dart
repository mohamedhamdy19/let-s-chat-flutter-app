import 'package:flutter/material.dart';
import 'package:letschat/components/components.dart';
import 'package:letschat/screens/signin.dart';
import 'package:letschat/screens/signup.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLogin = true;

  void toggleFrom() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          const AppLogo(),
          const SizedBox(
            height: 80,
          ),
          isLogin
              ? Signin(
                  toggle: toggleFrom,
                )
              : Signup(toggle: toggleFrom),
        ],
      ),
    );
  }
}
