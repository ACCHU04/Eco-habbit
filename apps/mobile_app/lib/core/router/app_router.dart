import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
import 'package:mobile_app/features/profile/screens/profile_screen.dart';
import 'package:mobile_app/features/profile/screens/settings_screen.dart';
import 'package:mobile_app/features/notifications/screens/notifications_screen.dart';
import 'package:mobile_app/features/rewards/screens/rewards_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
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
        builder: (context, state) => ListingDetailsScreen(
          listingId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/create-listing',
        builder: (context, state) {
          final extra = state.extra as Listing?;
          return CreateListingScreen(existingListing: extra);
        },
      ),
      GoRoute(
        path: '/my-listings',
        builder: (context, state) => const MyListingsScreen(),
      ),
      GoRoute(
        path: '/scan-result',
        builder: (context, state) {
          final data = state.extra as ScanResultData;
          return ScanResultScreen(data: data);
        },
      ),
      GoRoute(
        path: '/diy',
        builder: (context, state) => const DiyBrowseScreen(),
      ),
      GoRoute(
        path: '/diy/:id',
        builder: (context, state) => ProjectDetailsScreen(
          projectId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/create-post',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return CreatePostScreen(extra: extra);
        },
      ),
      GoRoute(
        path: '/community/post/:id',
        builder: (context, state) => PostDetailScreen(
          postId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/rewards',
        builder: (context, state) => const RewardsScreen(),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            activeIcon: Icon(Icons.storefront),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined),
            activeIcon: Icon(Icons.camera_alt),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum_outlined),
            activeIcon: Icon(Icons.forum),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
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
