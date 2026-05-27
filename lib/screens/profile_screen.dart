import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';
import 'resume_edit_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _editing = false;
  late TextEditingController _nameCtrl;
  late TextEditingController _positionCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _salaryMinCtrl;
  late TextEditingController _salaryMaxCtrl;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _nameCtrl = TextEditingController(text: user?.name ?? '');
    _positionCtrl = TextEditingController(text: user?.desiredPosition ?? '');
    _cityCtrl = TextEditingController(text: user?.city ?? '');
    _salaryMinCtrl =
        TextEditingController(text: user?.salaryMin?.toString() ?? '');
    _salaryMaxCtrl =
        TextEditingController(text: user?.salaryMax?.toString() ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _positionCtrl.dispose();
    _cityCtrl.dispose();
    _salaryMinCtrl.dispose();
    _salaryMaxCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final auth = context.read<AuthProvider>();
    final error = await auth.updateProfile({
      'name': _nameCtrl.text,
      'desiredPosition': _positionCtrl.text,
      'city': _cityCtrl.text,
      'salaryMin': int.tryParse(_salaryMinCtrl.text) ?? 0,
      'salaryMax': int.tryParse(_salaryMaxCtrl.text) ?? 0,
    });
    if (error != null && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    } else {
      setState(() => _editing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    if (user == null) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('个人资料'),
        actions: [
          TextButton(
            onPressed: () {
              if (_editing) {
                _save();
              } else {
                setState(() => _editing = true);
              }
            },
            child: Text(_editing ? '保存' : '编辑',
                style: const TextStyle(color: AppTheme.primary, fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Avatar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    child: const Icon(Icons.person,
                        size: 40, color: Colors.grey),
                  ),
                  Positioned(
                    bottom: 0,
                    right: MediaQuery.of(context).size.width / 2 - 46,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt,
                          size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Form fields
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildField('姓名', _nameCtrl, user.name, _editing),
                  _divider(),
                  _buildField('期望职位', _positionCtrl,
                      user.desiredPosition, _editing),
                  _divider(),
                  _buildField('工作城市', _cityCtrl, user.city, _editing),
                  _divider(),
                  _buildField('手机号', null, _maskPhone(user.phone), false),
                  _divider(),
                  _editing
                      ? Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    20, 12, 8, 12),
                                child: TextField(
                                  controller: _salaryMinCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: '最低薪资(K)',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8, 12, 20, 12),
                                child: TextField(
                                  controller: _salaryMaxCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: '最高薪资(K)',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : _buildField(
                          '薪资要求',
                          null,
                          user.salaryMin != null
                              ? '${user.salaryMin}K-${user.salaryMax}K'
                              : null,
                          false),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Resume link
            Container(
              color: Colors.white,
              child: ListTile(
                title: const Text('在线简历',
                    style: TextStyle(fontSize: 16)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(
                        builder: (_) => const ResumeEditScreen())),
              ),
            ),
            const SizedBox(height: 8),
            // Logout
            Container(
              color: Colors.white,
              child: ListTile(
                title: const Text('退出登录',
                    style: TextStyle(color: Colors.red, fontSize: 16)),
                onTap: () {
                  context.read<AuthProvider>().logout();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
      String label, TextEditingController? ctrl, String? value, bool editing) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label,
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 14)),
          ),
          Expanded(
            child: editing && ctrl != null
                ? TextField(
                    controller: ctrl,
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                        border: InputBorder.none, isDense: true),
                  )
                : Text(value ?? '未填写',
                    style: TextStyle(
                        fontSize: 16,
                        color: value != null
                            ? AppTheme.textPrimary
                            : AppTheme.textSecondary)),
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, indent: 20);

  String _maskPhone(String phone) {
    if (phone.length >= 11) {
      return '${phone.substring(0, 3)}****${phone.substring(7)}';
    }
    return phone;
  }
}
