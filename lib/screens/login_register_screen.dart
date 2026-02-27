import 'package:flutter/material.dart';
import '../widgets/staff_form.dart';
import '../widgets/jobseeker_form.dart';

class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  bool isLogin = true;
  String selectedRole = 'jobseeker';

  @override
  Widget build(BuildContext context) {
   return Scaffold(
  appBar: AppBar(
    title: const Text('Job Portal'),
      automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField(
              initialValue: selectedRole,
              decoration: const InputDecoration(labelText: 'Role'),
              items: const [
                DropdownMenuItem(value: 'jobseeker', child: Text('Jobseeker')),
                DropdownMenuItem(value: 'staff', child: Text('Staff')),
              ],
              onChanged: (v) => setState(() => selectedRole = v!),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => isLogin = true),
                    child: const Text('LOGIN'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => isLogin = false),
                    child: const Text('REGISTER'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: selectedRole == 'staff'
                  ? StaffForm(isLogin: isLogin)
                  : JobseekerForm(isLogin: isLogin),
            )
          ],
        ),
      ),
    );
  }
}