import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/job_provider.dart';
import '../widgets/job_card.dart';
import 'search_screen.dart';
import 'job_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollCtrl = ScrollController();
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<JobProvider>().loadJobs(refresh: true);
    _scrollCtrl.addListener(() {
      if (_scrollCtrl.position.pixels >=
          _scrollCtrl.position.maxScrollExtent - 200) {
        final provider = context.read<JobProvider>();
        if (!provider.isLoading && provider.hasMore) {
          provider.loadJobs();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(103),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            decoration: const BoxDecoration(color: AppTheme.primary),
            child: Column(
              children: [
                // City + Search
                Row(
                  children: [
                    const Text('北京 ▼',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SearchScreen())),
                        child: Container(
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search,
                                  color: Colors.white, size: 18),
                              SizedBox(width: 6),
                              Text('搜索职位/公司',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Category chips
                SizedBox(
                  height: 28,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _chip('推荐', true),
                      _chip('最新', false),
                      _chip('附近', false),
                      _chip('高薪', false),
                      _chip('实习', false),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<JobProvider>(
        builder: (context, provider, _) => RefreshIndicator(
          onRefresh: () => provider.loadJobs(refresh: true),
          child: ListView.builder(
            controller: _scrollCtrl,
            itemCount: provider.jobs.length + (provider.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= provider.jobs.length) {
                return const Center(
                    child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(color: AppTheme.primary),
                ));
              }
              final job = provider.jobs[index];
              return Column(
                children: [
                  JobCard(
                    job: job,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                JobDetailScreen(jobId: job.id))),
                  ),
                  const Divider(height: 1, indent: 88),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _chip(String label, bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: active ? Colors.white.withValues(alpha: 0.3) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: active ? null : Border.all(color: Colors.white.withValues(alpha: 0.5)),
      ),
      child: Center(
        child: Text(label,
            style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
      ),
    );
  }
}
