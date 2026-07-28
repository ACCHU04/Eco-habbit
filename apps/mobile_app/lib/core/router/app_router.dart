import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/services/analytics_service.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';
import 'package:mobile_app/features/auth/screens/login_screen.dart';
import 'package:mobile_app/features/auth/screens/register_screen.dart';
import 'package:mobile_app/features/auth/screens/role_selection_screen.dart';
import 'package:mobile_app/features/auth/screens/profile_setup_screen.dart';
import 'package:mobile_app/features/home/screens/home_screen.dart';
import 'package:mobile_app/features/marketplace/screens/marketplace_browse_screen.dart';
import 'package:mobile_app/features/marketplace/screens/listing_details_screen.dart';
import 'package:mobile_app/features/marketplace/screens/create_listing_screen.dart';
import 'package:mobile_app/features/marketplace/screens/my_listings_screen.dart';
import 'package:mobile_app/features/marketplace/models/listing.dart';
import 'package:mobile_app/features/scanner/screens/scanner_screen.dart';
import 'package:mobile_app/features/scanner/screens/scan_result_screen.dart';
import 'package:mobile_app/features/scanner/models/scan_result_data.dart';
import 'package:mobile_app/features/diy/screens/diy_browse_screen.dart';
import 'package:mobile_app/features/diy/screens/project_details_screen.dart';
import 'package:mobile_app/features/community/screens/community_feed_screen.dart';
import 'package:mobile_app/features/community/screens/create_post_screen.dart';
import 'package:mobile_app/features/community/screens/post_detail_screen.dart';
import 'package:mobile_app/features/community/screens/bookmarks_screen.dart';
import 'package:mobile_app/features/community/screens/community_search_screen.dart';
import 'package:mobile_app/features/profile/screens/profile_screen.dart';
import 'package:mobile_app/features/profile/screens/settings_screen.dart';
import 'package:mobile_app/features/notifications/screens/notifications_screen.dart';
import 'package:mobile_app/features/rewards/screens/rewards_screen.dart';
import 'package:mobile_app/features/quests/screens/quests_screen.dart';
import 'package:mobile_app/features/coins/screens/wallet_screen.dart';
import 'package:mobile_app/features/passport/screens/passport_screen.dart';
import 'package:mobile_app/features/passport/screens/activity_timeline_screen.dart';
import 'package:mobile_app/features/engagement/screens/engagement_hub_screen.dart';
import 'package:mobile_app/features/admin/screens/admin_dashboard_screen.dart';
import 'package:mobile_app/features/admin/screens/admin_users_screen.dart';
import 'package:mobile_app/features/admin/screens/admin_user_detail_screen.dart';
import 'package:mobile_app/features/admin/screens/admin_reports_screen.dart';
import 'package:mobile_app/features/admin/screens/admin_audit_screen.dart';
import 'package:mobile_app/core/widgets/eco_bottom_nav.dart';
import 'package:mobile_app/core/router/transitions.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);
  final analytics = AnalyticsService();

  return GoRouter(
    initialLocation: '/login',
    observers: [analytics.createObserver()],
    redirect: (context, state) {
      final authState = auth.hasValue ? auth.value! : null;
      final loc = state.matchedLocation;
      final isAuthRoute = loc.startsWith('/login') ||
          loc.startsWith('/register') ||
          loc.startsWith('/role-selection') ||
          loc.startsWith('/profile-setup');

      // Still checking token at startup — hold on splash
      if (auth is AsyncLoading) return null;

      // User action in progress — stay where they are
      if (authState != null && auth.hasValue == false) return null;

      // Check the actual auth state from the notifier
      final notifier = ref.read(authProvider.notifier);
      final currentAuthState = notifier.authState;

      if (currentAuthState == AuthState.initial ||
          currentAuthState == AuthState.loading) {
        return null;
      }

      if (currentAuthState == AuthState.authenticated && isAuthRoute) {
        return '/home';
      }

      if (currentAuthState == AuthState.unauthenticated && !isAuthRoute) {
        return '/login';
      }

      // Role-based redirect for admin routes
      if (loc.startsWith('/admin')) {
        final user = authState?.user;
        final isAdmin = user?.role == 'admin' || user?.role == 'super_admin';
        if (!isAdmin) return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/role-selection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) => ScaffoldWithNavBar(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/marketplace',
            builder: (context, state) => const MarketplaceBrowseScreen(),
          ),
          GoRoute(
            path: '/scanner',
            builder: (context, state) => const ScannerScreen(),
          ),
          GoRoute(
            path: '/community',
            builder: (context, state) => const CommunityFeedScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      GoRoute(
        path: '/marketplace/:id',
        pageBuilder: (context, state) => slideUpTransition(
          context,
          state,
          ListingDetailsScreen(listingId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/create-listing',
        pageBuilder: (context, state) {
          final extra = state.extra as Listing?;
          return sharedAxisTransition(
            context,
            state,
            CreateListingScreen(existingListing: extra),
          );
        },
      ),
      GoRoute(
        path: '/my-listings',
        pageBuilder: (context, state) => sharedAxisTransition(
          context,
          state,
          const MyListingsScreen(),
        ),
      ),
      GoRoute(
        path: '/scan-result',
        pageBuilder: (context, state) {
          final data = state.extra as ScanResultData;
          return slideUpTransition(context, state, ScanResultScreen(data: data));
        },
      ),
      GoRoute(
        path: '/diy',
        pageBuilder: (context, state) => sharedAxisTransition(
          context,
          state,
          const DiyBrowseScreen(),
        ),
      ),
      GoRoute(
        path: '/diy/:id',
        pageBuilder: (context, state) => slideUpTransition(
          context,
          state,
          ProjectDetailsScreen(projectId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/create-post',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return sharedAxisTransition(
            context,
            state,
            CreatePostScreen(extra: extra),
          );
        },
      ),
      GoRoute(
        path: '/community/post/:id',
        pageBuilder: (context, state) => slideUpTransition(
          context,
          state,
          PostDetailScreen(postId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/bookmarks',
        pageBuilder: (context, state) => sharedAxisTransition(
          context,
          state,
          const BookmarksScreen(),
        ),
      ),
      GoRoute(
        path: '/community/search',
        pageBuilder: (context, state) => sharedAxisTransition(
          context,
          state,
          const CommunitySearchScreen(),
        ),
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => sharedAxisTransition(
          context,
          state,
          const SettingsScreen(),
        ),
      ),
      GoRoute(
        path: '/notifications',
        pageBuilder: (context, state) => slideUpTransition(
          context,
          state,
          const NotificationsScreen(),
        ),
      ),
      GoRoute(
        path: '/rewards',
        pageBuilder: (context, state) => fadeThroughTransition(
          context,
          state,
          const RewardsScreen(),
        ),
      ),
      GoRoute(
        path: '/quests',
        pageBuilder: (context, state) => fadeThroughTransition(
          context,
          state,
          const QuestsScreen(),
        ),
      ),
      GoRoute(
        path: '/wallet',
        pageBuilder: (context, state) => fadeThroughTransition(
          context,
          state,
          const WalletScreen(),
        ),
      ),
      GoRoute(
        path: '/passport',
        pageBuilder: (context, state) => fadeThroughTransition(
          context,
          state,
          const PassportScreen(),
        ),
      ),
      GoRoute(
        path: '/passport/timeline',
        pageBuilder: (context, state) => slideUpTransition(
          context,
          state,
          const ActivityTimelineScreen(),
        ),
      ),
      GoRoute(
        path: '/engage',
        pageBuilder: (context, state) => fadeThroughTransition(
          context,
          state,
          const EngagementHubScreen(),
        ),
      ),

      // Admin routes
      GoRoute(
        path: '/admin',
        pageBuilder: (context, state) => fadeThroughTransition(
          context,
          state,
          const AdminDashboardScreen(),
        ),
      ),
      GoRoute(
        path: '/admin/users',
        pageBuilder: (context, state) => sharedAxisTransition(
          context,
          state,
          const AdminUsersScreen(),
        ),
      ),
      GoRoute(
        path: '/admin/users/:id',
        pageBuilder: (context, state) => slideUpTransition(
          context,
          state,
          AdminUserDetailScreen(userId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/admin/reports',
        pageBuilder: (context, state) => sharedAxisTransition(
          context,
          state,
          const AdminReportsScreen(),
        ),
      ),
      GoRoute(
        path: '/admin/audit',
        pageBuilder: (context, state) => sharedAxisTransition(
          context,
          state,
          const AdminAuditScreen(),
        ),
      ),
    ],
  );
});

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: EcoBottomNav(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        onScanTap: () => context.go('/scanner'),
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/marketplace')) return 1;
    if (location.startsWith('/scanner')) return 2;
    if (location.startsWith('/community')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/marketplace');
        break;
      case 2:
        context.go('/scanner');
        break;
      case 3:
        context.go('/community');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }
}
