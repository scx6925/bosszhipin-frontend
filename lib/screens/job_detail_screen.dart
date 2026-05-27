import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/job_provider.dart';
import '../providers/application_provider.dart';

class JobDetailScreen extends StatefulWidget {
  final int jobId;
  const JobDetailScreen({super.key, required this.jobId});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<JobProvider>().loadJobDetail(widget.jobId);
  }

  Future<void> _handleApply() async {
    final appProvider = context.read<ApplicationProvider>();
    final error = await appProvider.apply(widget.jobId);
    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('投递成功！')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JobProvider>();
    final job = provider.currentJob;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('职位详情'), actions: [
        IconButton(
            icon: const Icon(Icons.share, color: AppTheme.textSecondary),
            onPressed: () {}),
      ]),
      body: job == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Company header
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor:
                                        const Color(0xFFE8F0FE),
                                    child: Text(job.companyInitial,
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF3366CC))),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(job.companyName,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: AppTheme
                                                .textSecondary)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(job.title,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight:
                                                FontWeight.w600)),
                                  ),
                                  Text(job.salaryDisplay,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.salary)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text('${job.companyName} · ${job.city}',
                                  style: const TextStyle(
                                      color: AppTheme.textSecondary)),
                            ],
                          ),
                        ),
                        // Tags
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.fromLTRB(
                              16, 0, 16, 12),
                          child: Wrap(
                            spacing: 8,
                            children: [
                              _tag(job.experience ?? ''),
                              _tag(job.education ?? ''),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Description
                        Container(
                          color: Colors.white,
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text('职位描述',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 12),
                              Text(job.description ?? '暂无描述',
                                  style: const TextStyle(
                                      color: AppTheme.textSecondary,
                                      height: 1.8)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Company info
                        Container(
                          color: Colors.white,
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text('公司信息',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 12),
                              Text(job.companyDesc ?? '暂无介绍',
                                  style: const TextStyle(
                                      color: AppTheme.textSecondary,
                                      height: 1.6)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Bottom bar
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            provider.toggleFavorite(widget.jobId),
                        child: Container(
                          width: 56,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppTheme.background,
                            borderRadius:
                                BorderRadius.circular(24),
                          ),
                          child: Icon(
                            provider.isFavorited
                                ? Icons.star
                                : Icons.star_border,
                            color: provider.isFavorited
                                ? Colors.amber
                                : AppTheme.textSecondary,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _handleApply,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text('立即投递',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text,
          style: const TextStyle(
              fontSize: 12, color: Color(0xFF6699CC))),
    );
  }
}
