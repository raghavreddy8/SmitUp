import 'package:flutter/material.dart';
import 'package:smit_up/database/database_helper.dart';
import 'package:smit_up/screens/dashboard_screens.dart';

class JobseekerForm extends StatefulWidget {
  final bool isLogin;
  const JobseekerForm({super.key, required this.isLogin});

  @override
  State<JobseekerForm> createState() => _JobseekerFormState();
}

class _JobseekerFormState extends State<JobseekerForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _skills = TextEditingController();
  final _education = TextEditingController();

  void _submit() async {
  if (!_formKey.currentState!.validate()) return;

  final db = await DatabaseHelper.instance.database;

  if (widget.isLogin) {
    final result = await db.query(
      'jobseekers',
      where: 'phone_number = ?',
      whereArgs: [_phone.text],
    );

    if (!mounted) return;

    if (result.isNotEmpty) {
  if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardScreen(
          role: 'Jobseeker',
          name: result.first['full_name']?.toString() ?? '',
        ),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Phone number not found')),
    );
  }
  } else {
    await db.insert('jobseekers', {
      'full_name': _name.text,
      'phone_number': _phone.text,
      'skills': _skills.text,
      'education': _education.text,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registered Successfully')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          if (!widget.isLogin)
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Full Name'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
          TextFormField(
            controller: _phone,
            decoration: const InputDecoration(labelText: 'Phone'),
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          if (!widget.isLogin)
            TextFormField(
              controller: _skills,
              decoration: const InputDecoration(labelText: 'Skills'),
            ),
          if (!widget.isLogin)
            TextFormField(
              controller: _education,
              decoration: const InputDecoration(labelText: 'Education'),
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submit,
            child: Text(widget.isLogin ? 'LOGIN' : 'REGISTER'),
          )
        ],
      ),
    );
  }
}