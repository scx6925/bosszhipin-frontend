import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/favorite_provider.dart';
import '../widgets/job_card.dart';
import 'job_detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavoriteProvider>().loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FavoriteProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('我的收藏')),
      body: provider.favorites.isEmpty
          ? const Center(
              child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_border, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('还没有收藏职位', style: TextStyle(color: Colors.grey)),
              ],
            ))
          : ListView.builder(
              itemCount: provider.favorites.length,
              itemBuilder: (context, index) {
                final job = provider.favorites[index];
                return Dismissible(
                  key: Key('fav_${job.id}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    color: Colors.red,
                    child: const Text('取消收藏',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ),
                  onDismissed: (_) =>
                      provider.removeFavorite(job.id),
                  child: Column(
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
                  ),
                );
              },
            ),
    );
  }
}
