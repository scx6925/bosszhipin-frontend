import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/application_provider.dart';

class ApplicationScreen extends StatefulWidget {
  const ApplicationScreen({super.key});

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ApplicationProvider>().loadRecords();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'INTERVIEW':
        return AppTheme.success;
      case 'REJECTED':
        return AppTheme.textSecondary;
      default:
        return AppTheme.info;
    }
  }

  String _statusText(String status) {
    switch (status) {
      case 'APPLIED':
        return '已投递';
      case 'VIEWED':
        return '已查看';
      case 'INTERVIEW':
        return '邀请面试';
      case 'REJECTED':
        return '不合适';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ApplicationProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('投递记录')),
      body: provider.records.isEmpty
          ? const Center(
              child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.description_outlined,
                    size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('还没有投递记录', style: TextStyle(color: Colors.grey)),
              ],
            ))
          : ListView.separated(
              itemCount: provider.records.length,
              separatorBuilder: (_, _) => const SizedBox(height: 1),
              itemBuilder: (context, index) {
                final record = provider.records[index];
                final job = record.job;
                final status = record.status;
                final color = _statusColor(status);

                return Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(job['title'] ?? '',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.12),
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                            child: Text(_statusText(status),
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: color)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(job['companyName'] ?? '',
                          style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 14)),
                      const SizedBox(height: 4),
                      Text('投递时间：${record.appliedAt}',
                          style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12)),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
