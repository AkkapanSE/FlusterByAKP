import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'user_form_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    super.initState();
    // โหลดข้อมูลครั้งแรกเมื่อเปิดหน้าจอ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<UserProvider>().loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users (FakeStoreAPI)'),
        actions: [
          IconButton(
            onPressed: provider.isLoading ? null : () => provider.loadUsers(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UserFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Builder(
        builder: (_) {
          if (provider.isLoading && provider.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null && provider.users.isEmpty) {
            return Center(child: Text('Error: ${provider.error}'));
          }

          return ListView.separated(
            itemCount: provider.users.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final u = provider.users[i];
              final name = '${u.name.firstname} ${u.name.lastname}'.trim();
              return ListTile(
                title: Text(name.isEmpty ? '(no name)' : name),
                subtitle: Text('${u.username} • ${u.email}'),
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        if (u.id == null) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => UserFormScreen(editUser: u)),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        if (u.id == null) return;
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Confirm delete'),
                            content: Text('Delete user id=${u.id}?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                              FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                            ],
                          ),
                        );
                        if (ok == true) {
                          await context.read<UserProvider>().removeUser(u.id!);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}