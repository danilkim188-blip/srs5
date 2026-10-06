import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'user_info_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _storyController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _storyFocus = FocusNode();
  final _passFocus = FocusNode();
  final _confirmPassFocus = FocusNode();

  bool _hidePass = true;
  bool _hideConfirmPass = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _storyController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();

    _nameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    _storyFocus.dispose();
    _passFocus.dispose();
    _confirmPassFocus.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Введите имя';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Введите номер телефона';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Номер должен содержать только цифры';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Введите адрес электронной почты';
    }
    final emailRegExp = RegExp(r'^[\w.+\-]+@[A-Za-z0-9\-]+(\.[A-Za-z0-9\-]+)*\.[A-Za-z]{2,}$');
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'Неверный формат email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите пароль';
    }
    if (value.length < 6) {
      return 'Пароль должен быть не менее 6 символов';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Подтвердите пароль';
    }
    if (value != _passController.text) {
      return 'Пароли не совпадают';
    }
    return null;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', _nameController.text.trim());
      await prefs.setString('phone', _phoneController.text.trim());
      await prefs.setString('email', _emailController.text.trim());
      await prefs.setString('story', _storyController.text.trim());
      await prefs.setString('password', _passController.text);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const UserInfoPage()),
      );
    } else {
      if (_validateName(_nameController.text) != null) {
        _nameFocus.requestFocus();
      } else if (_validatePhone(_phoneController.text) != null) {
        _phoneFocus.requestFocus();
      } else if (_validateEmail(_emailController.text) != null) {
        _emailFocus.requestFocus();
      } else if (_validatePassword(_passController.text) != null) {
        _passFocus.requestFocus();
      } else {
        _confirmPassFocus.requestFocus();
      }
    }
  }

  OutlineInputBorder get _roundedBorder => OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.black, width: 2),
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Register Form',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_phoneFocus),
                  validator: _validateName,
                  decoration: InputDecoration(
                    labelText: 'Full Name *',
                    hintText: 'What do people call you?',
                    prefixIcon: const Icon(Icons.person),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _nameController.clear(),
                    ),
                    enabledBorder: _roundedBorder,
                    focusedBorder: _roundedBorder,
                    border: _roundedBorder,
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_emailFocus),
                  validator: _validatePhone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number *',
                    helperText: 'Phone format: (XXX)XXX-XXXX',
                    prefixIcon: const Icon(Icons.call),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _phoneController.clear(),
                    ),
                    enabledBorder: _roundedBorder,
                    focusedBorder: _roundedBorder,
                    border: _roundedBorder,
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_storyFocus),
                  validator: _validateEmail,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.mail),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _storyController,
                  focusNode: _storyFocus,
                  maxLines: 3,
                  inputFormatters: [LengthLimitingTextInputFormatter(100)],
                  decoration: const InputDecoration(
                    labelText: 'Life Story',
                    helperText: 'Keep it short, this is just a demo',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _passController,
                  focusNode: _passFocus,
                  obscureText: _hidePass,
                  maxLength: 8,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_confirmPassFocus),
                  validator: _validatePassword,
                  decoration: InputDecoration(
                    labelText: 'Password *',
                    prefixIcon: const Icon(Icons.security),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hidePass ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => setState(() => _hidePass = !_hidePass),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                TextFormField(
                  controller: _confirmPassController,
                  focusNode: _confirmPassFocus,
                  obscureText: _hideConfirmPass,
                  maxLength: 8,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submitForm(),
                  validator: _validateConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password *',
                    prefixIcon: const Icon(Icons.border_color),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hideConfirmPass
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => _hideConfirmPass = !_hideConfirmPass),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _submitForm,
                  child: const Text(
                    'Submit Form',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
