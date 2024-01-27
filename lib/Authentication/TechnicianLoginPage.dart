import 'package:flutter/material.dart';
import 'package:campus_care/Authentication/TechnicianVerificationPage.dart';
import 'package:campus_care/controllers/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TechnicianLoginPage extends StatelessWidget {
  final AuthService _authService = AuthService();

  TechnicianLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String phoneNumber = '';

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
            const Text('Enter your phone number:'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  phoneNumber = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_authService.isValidPhoneNumber(phoneNumber)) {
                  _authService.signInWithPhoneNumber(
                    phoneNumber: phoneNumber,
                    context: context,
                    verificationCompleted: (AuthCredential credential) async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TechnicianVerificationPage(verificationId: ''),
                        ),
                      );
                    },
                    verificationFailed: (FirebaseAuthException e) {
                      print('Verification failed: ${e.message}');
                      _authService.showValidationErrorDialog(
                        context,
                        'Error during phone verification. Please try again.',
                      );
                    },
                    codeSent: (String verificationId, int? resendToken) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TechnicianVerificationPage(
                              verificationId: verificationId),
                        ),
                      );
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
                  );
                } else {
                  _authService.showValidationErrorDialog(
                    context,
                    'Invalid phone number. Please enter a valid +91XXXXXXXXXX format.',
                  );
                }
              },
              child: const Text('Send OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
