import 'package:flutter/material.dart';
import 'package:kcc_management_software/screens/playerlist_screen.dart';
import 'package:kcc_management_software/widgets/button_widget.dart';
import 'package:kcc_management_software/widgets/text_widget.dart';
import 'package:kcc_management_software/widgets/textfield_widget.dart';
import 'package:kcc_management_software/widgets/toast_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 75, right: 75),
              child: Container(
                width: double.infinity,
                height: 250,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/Asset 8@4x.png')),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextBold(
              text: 'Membership Software',
              fontSize: 32,
              color: Colors.black,
            ),
            const SizedBox(
              height: 30,
            ),
            TextFieldWidget(label: 'USERNAME', controller: usernameController),
            const SizedBox(
              height: 10,
            ),
            TextFieldWidget(
                isObscure: true,
                isPassword: true,
                label: 'PASSWORD',
                controller: passwordController),
            const SizedBox(
              height: 30,
            ),
            ButtonWidget(
              color: Colors.black,
              fontColor: Colors.white,
              label: 'LOGIN',
              onPressed: () {
                if (usernameController.text == 'kcc-username' &&
                    passwordController.text == 'kcc-password') {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const PlayerListScreen()));
                } else {
                  showToast('Cannot Proceed! Invalid login credentials.');
                }
              },
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
