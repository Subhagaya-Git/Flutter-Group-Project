import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
       // title: const Text("Registration"),
     // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
         Container(
         
         child: Column(
          
          children: [
            Text("Register"),
          ],
         ),

         )
        ],
      ),
    );
  }
}
