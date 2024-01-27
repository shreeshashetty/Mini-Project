import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:campus_care/TechnicianApp/TechnicianHomePage.dart';

class TechnicianVerificationPage extends StatelessWidget {
  final String verificationId;
  final TextEditingController _codeController = TextEditingController();

  TechnicianVerificationPage({Key? key, required this.verificationId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/app_logo.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            const Text('Enter the verification code:'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Verification Code',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  String verificationCode = _codeController.text.trim();

                  AuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: verificationId,
                    smsCode: verificationCode,
                  );

                  await FirebaseAuth.instance.signInWithCredential(credential);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TechnicianHomePage(),
                    ),
                  );
                } catch (e) {
                  print('Error verifying code: $e');

                  Navigator.pop(context);
                }
              },
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
