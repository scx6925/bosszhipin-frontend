import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/education.dart';
import '../models/work_experience.dart';
import '../providers/resume_provider.dart';

class ResumeEditScreen extends StatefulWidget {
  const ResumeEditScreen({super.key});

  @override
  State<ResumeEditScreen> createState() => _ResumeEditScreenState();
}

class _ResumeEditScreenState extends State<ResumeEditScreen> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<ResumeProvider>();
    provider.loadEducations();
    provider.loadWorkExperiences();
  }

  void _editEducation(Education? existing) {
    _showEducationDialog(context, existing);
  }

  void _editWorkExperience(WorkExperience? existing) {
    _showWorkDialog(context, existing);
  }

  Future<void> _showEducationDialog(
      BuildContext context, Education? existing) async {
    final schoolCtrl =
        TextEditingController(text: existing?.school ?? '');
    final majorCtrl =
        TextEditingController(text: existing?.major ?? '');
    final degreeCtrl =
        TextEditingController(text: existing?.degree ?? '');
    final startCtrl =
        TextEditingController(text: existing?.startDate ?? '');
    final endCtrl =
        TextEditingController(text: existing?.endDate ?? '');

    await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing != null ? '编辑教育经历' : '新增教育经历'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: schoolCtrl,
                  decoration: const InputDecoration(labelText: '学校')),
              TextField(
                  controller: majorCtrl,
                  decoration: const InputDecoration(labelText: '专业')),
              TextField(
                  controller: degreeCtrl,
                  decoration: const InputDecoration(labelText: '学历')),
              TextField(
                  controller: startCtrl,
                  decoration: const InputDecoration(
                      labelText: '开始时间', hintText: '2020-09')),
              TextField(
                  controller: endCtrl,
                  decoration: const InputDecoration(
                      labelText: '结束时间', hintText: '2024-06')),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('取消')),
          TextButton(
            onPressed: () {
              final edu = Education(
                id: existing?.id,
                school: schoolCtrl.text,
                major: majorCtrl.text,
                degree: degreeCtrl.text,
                startDate: startCtrl.text,
                endDate: endCtrl.text.isNotEmpty ? endCtrl.text : null,
              );
              final provider = context.read<ResumeProvider>();
              if (existing != null) {
                provider.updateEducation(existing.id!, edu);
              } else {
                provider.addEducation(edu);
              }
              Navigator.pop(ctx, true);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  Future<void> _showWorkDialog(
      BuildContext context, WorkExperience? existing) async {
    final companyCtrl =
        TextEditingController(text: existing?.company ?? '');
    final posCtrl =
        TextEditingController(text: existing?.position ?? '');
    final descCtrl =
        TextEditingController(text: existing?.description ?? '');
    final startCtrl =
        TextEditingController(text: existing?.startDate ?? '');
    final endCtrl =
        TextEditingController(text: existing?.endDate ?? '');

    await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existing != null ? '编辑工作经历' : '新增工作经历'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: companyCtrl,
                  decoration: const InputDecoration(labelText: '公司')),
              TextField(
                  controller: posCtrl,
                  decoration: const InputDecoration(labelText: '职位')),
              TextField(
                  controller: descCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: '工作描述')),
              TextField(
                  controller: startCtrl,
                  decoration: const InputDecoration(
                      labelText: '开始时间', hintText: '2023-07')),
              TextField(
                  controller: endCtrl,
                  decoration: const InputDecoration(
                      labelText: '结束时间', hintText: '至今（留空）')),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('取消')),
          TextButton(
            onPressed: () {
              final we = WorkExperience(
                id: existing?.id,
                company: companyCtrl.text,
                position: posCtrl.text,
                description: descCtrl.text,
                startDate: startCtrl.text,
                endDate: endCtrl.text.isNotEmpty ? endCtrl.text : null,
              );
              final provider = context.read<ResumeProvider>();
              if (existing != null) {
                provider.updateWorkExperience(existing.id!, we);
              } else {
                provider.addWorkExperience(we);
              }
              Navigator.pop(ctx, true);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('在线简历')),
      body: Consumer<ResumeProvider>(
        builder: (context, provider, _) => ListView(
          children: [
            // Education section
            _sectionHeader(
                '教育经历', () => _editEducation(null)),
            ...provider.educations.map((e) => _eduCard(e)),
            const SizedBox(height: 8),
            // Work section
            _sectionHeader(
                '工作经历', () => _editWorkExperience(null)),
            ...provider.workExperiences.map((w) => _workCard(w)),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, VoidCallback onAdd) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600)),
          GestureDetector(
            onTap: onAdd,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                  color: AppTheme.primary, shape: BoxShape.circle),
              child: const Icon(Icons.add, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _eduCard(Education edu) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      margin: const EdgeInsets.only(bottom: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(edu.school,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text('${edu.major} · ${edu.degree}',
                    style: const TextStyle(color: AppTheme.textSecondary)),
                Text('${edu.startDate} - ${edu.endDate ?? "至今"}',
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          TextButton(
              onPressed: () => _editEducation(edu),
              child: const Text('编辑',
                  style: TextStyle(color: AppTheme.primary))),
          TextButton(
              onPressed: () =>
                  context.read<ResumeProvider>().deleteEducation(edu.id!),
              child: const Text('删除',
                  style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  Widget _workCard(WorkExperience we) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      margin: const EdgeInsets.only(bottom: 1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(we.company,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(we.position,
                    style: const TextStyle(color: AppTheme.textSecondary)),
                Text('${we.startDate} - ${we.endDate ?? "至今"}',
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          TextButton(
              onPressed: () => _editWorkExperience(we),
              child: const Text('编辑',
                  style: TextStyle(color: AppTheme.primary))),
          TextButton(
              onPressed: () =>
                  context.read<ResumeProvider>().deleteWorkExperience(we.id!),
              child: const Text('删除',
                  style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}
