import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';

class UserFormScreen extends StatefulWidget {
  final UserModel? editUser;
  const UserFormScreen({super.key, this.editUser});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailCtrl, usernameCtrl, passwordCtrl, phoneCtrl;
  late TextEditingController firstCtrl, lastCtrl, cityCtrl, streetCtrl, numberCtrl, zipCtrl, latCtrl, longCtrl;

  @override
  void initState() {
    super.initState();
    final u = widget.editUser;
    emailCtrl = TextEditingController(text: u?.email ?? '');
    usernameCtrl = TextEditingController(text: u?.username ?? '');
    passwordCtrl = TextEditingController(text: u?.password ?? '');
    phoneCtrl = TextEditingController(text: u?.phone ?? '');
    firstCtrl = TextEditingController(text: u?.name.firstname ?? '');
    lastCtrl = TextEditingController(text: u?.name.lastname ?? '');
    cityCtrl = TextEditingController(text: u?.address.city ?? '');
    streetCtrl = TextEditingController(text: u?.address.street ?? '');
    numberCtrl = TextEditingController(text: (u?.address.number ?? 0).toString());
    zipCtrl = TextEditingController(text: u?.address.zipcode ?? '');
    latCtrl = TextEditingController(text: u?.address.geolocation.lat ?? '');
    longCtrl = TextEditingController(text: u?.address.geolocation.long ?? '');
  }

  UserModel _buildUser() {
    return UserModel(
      id: widget.editUser?.id,
      email: emailCtrl.text.trim(),
      username: usernameCtrl.text.trim(),
      password: passwordCtrl.text,
      phone: phoneCtrl.text.trim(),
      name: NameModel(firstname: firstCtrl.text.trim(), lastname: lastCtrl.text.trim()),
      address: AddressModel(
        city: cityCtrl.text.trim(),
        street: streetCtrl.text.trim(),
        number: int.tryParse(numberCtrl.text.trim()) ?? 0,
        zipcode: zipCtrl.text.trim(),
        geolocation: GeoLocationModel(lat: latCtrl.text.trim(), long: longCtrl.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editUser != null;
    final provider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit User' : 'Add User')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _sectionTitle('Account'),
              _textField(emailCtrl, 'Email'),
              _textField(usernameCtrl, 'Username'),
              _textField(passwordCtrl, 'Password', obscure: true),
              _textField(phoneCtrl, 'Phone'),
              const SizedBox(height: 16),
              _sectionTitle('Name'),
              _textField(firstCtrl, 'First name'),
              _textField(lastCtrl, 'Last name'),
              const SizedBox(height: 24),
              if (provider.error != null) Text(provider.error!, style: const TextStyle(color: Colors.red)),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: provider.isLoading ? null : () async {
                    if (!_formKey.currentState!.validate()) return;
                    final user = _buildUser();
                    if (isEdit) {
                      await context.read<UserProvider>().editUser(user.id!, user);
                    } else {
                      await context.read<UserProvider>().addUser(user);
                    }
                    if (mounted && context.read<UserProvider>().error == null) Navigator.pop(context);
                  },
                  icon: provider.isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save),
                  label: Text(isEdit ? 'Save changes' : 'Create user'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Align(alignment: Alignment.centerLeft, child: Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(t, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))));
  Widget _textField(TextEditingController c, String label, {bool obscure = false}) => Padding(padding: const EdgeInsets.only(bottom: 12), child: TextFormField(controller: c, obscureText: obscure, decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()), validator: (v) => (v == null || v.isEmpty) ? 'Required' : null));
}