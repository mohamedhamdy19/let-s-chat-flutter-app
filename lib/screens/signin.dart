import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letschat/components/components.dart';
import 'package:letschat/views/chat_screen.dart';

class Signin extends StatefulWidget {
  const Signin({
    super.key,
    required this.toggle,
  });
  final void Function() toggle;
  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  late String emailAddress;

  late String password;
  bool showPass = false;
  bool isLoading = false;
  GlobalKey<FormState> keyForm = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: keyForm,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              "Sign in",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          myTextField(
            controller: emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "this field can't be empty";
              }
              return null;
            },
            inputType: TextInputType.visiblePassword,
            prefix: const Icon(Icons.email),
            onChanged: (value) {
              emailAddress = value;
            },
            label: const Text("Email"),
          ),
          const SizedBox(
            height: 12.0,
          ),
          myTextField(
            controller: passController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "this field can't be empty";
              }
              return null;
            },
            inputType: TextInputType.visiblePassword,
            prefix: const Icon(Icons.lock),
            suffix: IconButton(
                onPressed: () {
                  setState(() {
                    showPass = !showPass;
                  });
                },
                icon: showPass
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off)),
            obscureText: !showPass,
            onChanged: (value) {
              password = value;
            },
            label: const Text("Password"),
          ),
          isLoading
              ? myLoadingIndicator()
              : const SizedBox(
                  height: 16,
                ),
          MyButton(
            text: "Sign in",
            function: () async {
              if (keyForm.currentState!.validate()) {
                reloadPage();
                try {
                  await signInUser();
                  showToastMsg(msg: "you are logged in!");
                  passController.clear();
                  emailController.clear();

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatScreen(
                                currentEmail: emailAddress,
                              )));
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'invalid-credential') {
                    showToastMsg(msg: "wrong email or password");
                  }
                } catch (e) {
                  showToastMsg(msg: e.toString());
                }
                reloadPage();
              }
            },
          ),
          Row(
            children: [
              const Text("Don't have an account?"),
              TextButton(
                onPressed: widget.toggle,
                child: const Text(
                  "Sign up now!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 25, 103, 168),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> signInUser() async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
  }

  void reloadPage() {
    setState(() {
      isLoading = !isLoading;
    });
  }
}
