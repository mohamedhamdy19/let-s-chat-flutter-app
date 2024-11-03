import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letschat/components/components.dart';

class Signup extends StatefulWidget {
  const Signup({super.key, required this.toggle});
  final void Function() toggle;
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String emailAddress = '';
  String password = '';
  String passwordRenter = '';
  String name = "";
  bool showPass = false;
  bool showRepass = false;
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passreController = TextEditingController();
  GlobalKey<FormState> keyForm = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: keyForm,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              "Sign up",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          myTextField(
            controller: nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "this field can't be empty";
              }
              return null;
            },
            inputType: TextInputType.emailAddress,
            prefix: const Icon(Icons.person),
            onChanged: (value) {
              name = value;
            },
            label: const Text("Name/Nickname"),
          ),
          const SizedBox(
            height: 12.0,
          ),
          myTextField(
            controller: emailController,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                if (!isEmailAddressValid(email: value)) {
                  return "email address not valid";
                }
              } else {
                return "this field can't be empty";
              }
              return null;
            },
            inputType: TextInputType.emailAddress,
            prefix: const Icon(Icons.email),
            onChanged: (value) {
              emailAddress = value;
            },
            label: const Text("Email"),
          ),
          const SizedBox(
            height: 12.0,
          ),
          Row(
            children: [
              Expanded(
                child: myTextField(
                  controller: passController,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (password != passwordRenter) {
                        return "password doesn't match re-entry";
                      }
                    } else {
                      return "this field can't be empty";
                    }
                    return null;
                  },
                  inputType: TextInputType.visiblePassword,
                  prefix: const Icon(
                    Icons.lock,
                    size: 23,
                  ),
                  suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          showPass = !showPass;
                        });
                      },
                      icon: showPass
                          ? const Icon(
                              Icons.visibility,
                              size: 23,
                            )
                          : const Icon(
                              Icons.visibility_off,
                              size: 23,
                            )),
                  obscureText: !showPass,
                  onChanged: (value) {
                    password = value;
                  },
                  label: const Text(
                    "Password",
                    style: TextStyle(fontSize: 9.7),
                  ),
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              Expanded(
                child: myTextField(
                  controller: passreController,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (password != passwordRenter) {
                        return "re-entry doesn't match password";
                      }
                    } else {
                      return "this field can't be empty";
                    }
                    return null;
                  },
                  inputType: TextInputType.visiblePassword,
                  prefix: const Icon(
                    Icons.lock,
                    size: 23,
                  ),
                  suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          showRepass = !showRepass;
                        });
                      },
                      icon: showRepass
                          ? const Icon(
                              Icons.visibility,
                              size: 23,
                            )
                          : const Icon(
                              Icons.visibility_off,
                              size: 23,
                            )),
                  obscureText: !showRepass,
                  onChanged: (value) {
                    passwordRenter = value;
                  },
                  label: const Text(
                    "Re-enter Password",
                    style: TextStyle(fontSize: 9.7),
                  ),
                ),
              ),
            ],
          ),
          isLoading
              ? myLoadingIndicator()
              : const SizedBox(
                  height: 16,
                ),
          MyButton(
            text: "Sign up",
            function: () async {
              if (keyForm.currentState!.validate()) {
                reloadPage();

                try {
                  await registerUser();
                  showToastMsg(msg: "Welcome to Let's Chat!");
                  passController.clear();
                  passreController.clear();
                  emailController.clear();
                  nameController.clear();
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    showToastMsg(msg: "password is weak, try a stronger one");
                  } else if (e.code == 'email-already-in-use') {
                    showToastMsg(msg: "This email already exists");
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
              const Text("Already have an account?"),
              TextButton(
                onPressed: widget.toggle,
                child: const Text(
                  "Sign in",
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

  void reloadPage() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  Future<void> registerUser() async {
    UserCredential credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    String uid = credential.user!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).set(
      {"username": name, "email": emailAddress},
    );
  }
}
