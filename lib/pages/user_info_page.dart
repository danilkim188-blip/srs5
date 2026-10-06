import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  String _name = '';
  String _phone = '';
  String _email = '';
  String _story = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _phone = prefs.getString('phone') ?? '';
      _email = prefs.getString('email') ?? '';
      _story = prefs.getString('story') ?? '';
    });
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value.isEmpty ? '—' : value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Info',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _infoTile(Icons.person, 'Full Name', _name),
          _infoTile(Icons.call, 'Phone Number', _phone),
          _infoTile(Icons.mail, 'Email Address', _email),
          _infoTile(Icons.notes, 'Life Story', _story),
        ],
      ),
    );
  }
}
