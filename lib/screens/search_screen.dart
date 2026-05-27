import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/job_provider.dart';
import '../widgets/job_card.dart';
import 'job_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchCtrl = TextEditingController();
  String? _selectedCity;

  void _doSearch() {
    context.read<JobProvider>().searchJobs(
          keyword: _searchCtrl.text.isNotEmpty ? _searchCtrl.text : null,
          city: _selectedCity,
        );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36, height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              const Text('筛选条件',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              const Text('工作城市',
                  style: TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['北京', '上海', '广州', '深圳', '杭州'].map((city) {
                  final active = _selectedCity == city;
                  return ChoiceChip(
                    label: Text(city),
                    selected: active,
                    selectedColor: AppTheme.primary,
                    labelStyle: TextStyle(
                        color: active ? Colors.white : null),
                    onSelected: (selected) {
                      setSheetState(() {
                        _selectedCity = selected ? city : null;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setSheetState(() => _selectedCity = null);
                        setState(() {});
                        Navigator.pop(ctx);
                        _doSearch();
                      },
                      child: const Text('重置'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(ctx);
                        _doSearch();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary),
                      child: const Text('确定',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: TextField(
          controller: _searchCtrl,
          autofocus: true,
          decoration: InputDecoration(
            hintText: '搜索职位/公司关键词',
            filled: true,
            fillColor: AppTheme.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
          onSubmitted: (_) => _doSearch(),
        ),
        actions: [
          TextButton(
            onPressed: _doSearch,
            child: const Text('搜索',
                style: TextStyle(color: AppTheme.primary)),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _filterChip('城市 ▾', _selectedCity != null),
                const SizedBox(width: 8),
                _filterChip('薪资范围 ▾', false),
                const SizedBox(width: 8),
                _filterChip('学历要求 ▾', false),
                GestureDetector(
                    onTap: _showFilterSheet,
                    child: _filterChip('更多筛选', false)),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Consumer<JobProvider>(
              builder: (context, provider, _) => ListView.separated(
                itemCount: provider.jobs.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1, indent: 88),
                itemBuilder: (context, index) {
                  final job = provider.jobs[index];
                  return JobCard(
                    job: job,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                JobDetailScreen(jobId: job.id))),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active ? AppTheme.primary.withValues(alpha: 0.1) : AppTheme.background,
        borderRadius: BorderRadius.circular(15),
        border: active
            ? Border.all(color: AppTheme.primary.withValues(alpha: 0.5))
            : null,
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 13,
              color: active ? AppTheme.primary : AppTheme.textSecondary)),
    );
  }
}
