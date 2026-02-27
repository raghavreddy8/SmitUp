import 'package:flutter/material.dart';
import 'package:smit_up/database/database_helper.dart';
import 'package:smit_up/screens/dashboard_screens.dart';

class StaffForm extends StatefulWidget {
  final bool isLogin;
  const StaffForm({super.key, required this.isLogin});

  @override
  State<StaffForm> createState() => _StaffFormState();
}

class _StaffFormState extends State<StaffForm> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final db = await DatabaseHelper.instance.database;

    if (widget.isLogin) {
      final result = await db.query(
        'staff',
        where: 'username = ? AND password_hash = ?',
        whereArgs: [_username.text, _password.text],
      );

      if (!mounted) return;

      if (result.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DashboardScreen(
              role: 'Staff',
              name: result.first['full_name'] as String,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid Credentials')),
        );
      }
    } else {
      await db.insert('staff', {
        'full_name': _name.text,
        'username': _username.text,
        'password_hash': _password.text,
        'role': 'volunteer',
        'is_active': 1,
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
            controller: _username,
            decoration: const InputDecoration(labelText: 'Username'),
            validator: (v) => v!.isEmpty ? 'Required' : null,
          ),
          TextFormField(
            controller: _password,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (v) => v!.isEmpty ? 'Required' : null,
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