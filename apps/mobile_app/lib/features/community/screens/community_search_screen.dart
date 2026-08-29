import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/theme/app_theme.dart';
import 'package:mobile_app/core/utils/time_ago.dart';
import 'package:mobile_app/core/widgets/eco_post_card.dart';
import 'package:mobile_app/core/widgets/empty_state.dart';
import 'package:mobile_app/features/community/data/community_repository.dart';
import 'package:mobile_app/features/community/models/post.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider.autoDispose<PaginatedPosts>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().length < 2) {
    return const PaginatedPosts(posts: [], page: 1, limit: 20, total: 0, totalPages: 0);
  }
  return ref.read(communityRepositoryProvider).searchPosts(query: query);
});

final trendingProvider = FutureProvider<List<Post>>((ref) async {
  return ref.read(communityRepositoryProvider).getTrending();
});

class CommunitySearchScreen extends ConsumerStatefulWidget {
  const CommunitySearchScreen({super.key});

  @override
  ConsumerState<CommunitySearchScreen> createState() => _CommunitySearchScreenState();
}

class _CommunitySearchScreenState extends ConsumerState<CommunitySearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchAsync = ref.watch(searchResultsProvider);
    final trendingAsync = ref.watch(trendingProvider);
    final query = ref.watch(searchQueryProvider);
    final isSearching = query.trim().length >= 2;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search posts...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
          },
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                ref.read(searchQueryProvider.notifier).state = '';
              },
            ),
        ],
      ),
      body: isSearching
          ? _buildSearchResults(searchAsync)
          : _buildTrending(trendingAsync),
    );
  }

  Widget _buildSearchResults(AsyncValue<PaginatedPosts> searchAsync) {
    return searchAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (paginated) {
        if (paginated.posts.isEmpty) {
          return const EmptyState(
            icon: Icons.search_off,
            title: 'No results found',
            subtitle: 'Try different keywords',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: paginated.posts.length,
          itemBuilder: (context, index) {
            final post = paginated.posts[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: EcoPostCard(
                authorName: post.author.fullName,
                authorAvatarUrl: post.author.profilePhoto,
                content: post.content,
                postType: post.postType,
                likes: post.likesCount,
                comments: post.commentsCount,
                timeAgo: timeAgo(post.createdAt),
                isLiked: post.isLiked,
                imageUrls: post.imageUrls,
                onTap: () => context.push('/community/post/${post.id}'),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTrending(AsyncValue<List<Post>> trendingAsync) {
    return trendingAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (posts) {
        if (posts.isEmpty) {
          return const EmptyState(
            icon: Icons.trending_up,
            title: 'No trending posts yet',
            subtitle: 'Engage with posts to see them here',
          );
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                const Icon(Icons.trending_up, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text('Trending', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            ...posts.map((post) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: EcoPostCard(
                authorName: post.author.fullName,
                authorAvatarUrl: post.author.profilePhoto,
                content: post.content,
                postType: post.postType,
                likes: post.likesCount,
                comments: post.commentsCount,
                timeAgo: timeAgo(post.createdAt),
                isLiked: post.isLiked,
                imageUrls: post.imageUrls,
                onTap: () => context.push('/community/post/${post.id}'),
              ),
            )),
          ],
        );
      },
    );
  }
}
