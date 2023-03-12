import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/bank_registration_controller.dart';

class BankRegistrationView extends GetView<BankRegistrationController> {
  const BankRegistrationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BankRegistrationView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'BankRegistrationView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
