import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:letschat/models/message.dart';
import 'package:letschat/views/homepage.dart';

class MainThemeContainer extends StatelessWidget {
  const MainThemeContainer({super.key, required this.child});
  final Widget child;

  final Color startColor = const Color.fromARGB(255, 43, 111, 206);

  final Color endColor = const Color.fromARGB(255, 113, 184, 150);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [startColor, endColor],
          )),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: child,
        ),
      ],
    );
  }
}

// class MyTextField extends StatelessWidget {
//    MyTextField(
//       {
//       required this.label,
//          required Widget prefix,
//         required TextInputType inputType,

//       required this.onChanged,
//        this.obscureText = false});
//   final Widget label;
//   final Function(String) onChanged;
//    bool obscureText;

//   @override

//   }
// }
Widget myTextField(
    {required Widget label,
    required TextInputType inputType,
    required Function(String) onChanged,
    bool obscureText = false,
    required TextEditingController controller,
    required Widget prefix,
    Widget? suffix,
    String? Function(String?)? validator}) {
  return TextFormField(
    controller: controller,
    onChanged: onChanged,
    validator: validator,
    obscureText: obscureText,
    decoration: InputDecoration(
      suffixIcon: suffix,
      prefixIcon: prefix,
      label: label,
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 65, 65, 65))),
      labelStyle: const TextStyle(color: Color.fromARGB(255, 65, 65, 65)),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.cyanAccent, width: 1.5)),
      border: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1.5)),
    ),
  );
}

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          child: Image.asset(
            "assets/msg.png",
            width: 150,
            height: 150,
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        Text(
          "Let's Chat!",
          style: GoogleFonts.kalam(fontSize: 35, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.text,
    required this.function,
  });
  final String text;
  final void Function() function;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color with opacity
              spreadRadius: 2, // How much the shadow spreads
              blurRadius: 5, // How soft the shadow is
              offset: const Offset(0, 3), // Shadow position: (x, y)
            ),
          ],
          color: const Color(0xff00bcd4),
          borderRadius: BorderRadius.circular(5)),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          text,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

void showSnackbar(BuildContext context, {required String msg}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    padding: const EdgeInsets.all(16),
    content: Text(
      msg,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    backgroundColor: const Color.fromARGB(255, 43, 111, 206),
  ));
}

bool isEmailAddressValid({required String email}) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
  if (!emailRegex.hasMatch(email)) {
    return false;
  }
  return true;
}

Widget myLoadingIndicator() {
  return const Padding(
    padding: EdgeInsets.all(8.0),
    child: SizedBox(
      height: 25,
      width: 25,
      child: CircularProgressIndicator(),
    ),
  );
}

void showToastMsg({required String msg}) => Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: const Color.fromARGB(224, 41, 41, 41),
      textColor: Colors.white,
      fontSize: 14,
    );

class MyChatContainer extends StatelessWidget {
  const MyChatContainer(
      {super.key,
      required this.isSender,
      required this.message,
      required this.username});

  final bool isSender;
  final Message message;
  final String username;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerLeft : Alignment.centerRight,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: isSender
                  ? const Radius.circular(15.0)
                  : const Radius.circular(15.0),
              topRight: isSender
                  ? const Radius.circular(15.0)
                  : const Radius.circular(15.0),
              bottomLeft: isSender
                  ? const Radius.circular(0)
                  : const Radius.circular(15.0),
              bottomRight: isSender
                  ? const Radius.circular(15.0)
                  : const Radius.circular(0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
            color: isSender
                ? const Color.fromARGB(255, 21, 116, 25)
                : const Color.fromARGB(255, 84, 84, 84),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "~ $username",
                style: TextStyle(
                    color: isSender
                        ? const Color.fromARGB(255, 53, 71, 145)
                        : Colors.amber,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                message.message,
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                message.time,
                style:
                    const TextStyle(color: Color.fromARGB(255, 175, 175, 175)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text("let's chat!", style: GoogleFonts.kalam(color: Colors.white)),
      const SizedBox(width: 8),
      Image.asset(
        "assets/msg.png",
        height: 30,
        width: 30,
      )
    ]);
  }
}

class ChatThemeContainer extends StatelessWidget {
  const ChatThemeContainer({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/chatback3.jpg"),
            fit: BoxFit.cover,
          ),
        )),
        child
      ],
    );
  }
}

Future<String?> getCurrentUsername({required String email}) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: email)
      .limit(1)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    DocumentSnapshot document = querySnapshot.docs.first;
    return document['username'];
  }

  return null;
}

void signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  showToastMsg(msg: "Signed Out!");
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const Scaffold(body: MainThemeContainer(child: HomePage()))));
}
