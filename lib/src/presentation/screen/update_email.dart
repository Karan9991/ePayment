import 'package:e_payment/src/presentation/screen/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateEmailScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  void updateEmail(BuildContext context) async {
    final auth = FirebaseAuth.instance;

    String newEmail = emailController.text.trim();
    if (newEmail.isNotEmpty) {
      try {
        await auth.currentUser!.updateEmail(newEmail);

        // Send verification email to the new email address
        await auth.currentUser!.sendEmailVerification();

        // Show a success message or navigate back to the previous screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Email updated successfully. Please check your email for verify.")),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
        // Navigator.pop(context); // Navigate back
      } catch (e) {
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred. Please try again. $e")),
        );
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Edit Email",
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Enter New Email"),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => updateEmail(context),
              child: Text("Update Email"),
            ),
          ],
        ),
      ),
    );
  }
}
