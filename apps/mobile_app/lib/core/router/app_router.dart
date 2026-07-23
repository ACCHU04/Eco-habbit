import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/features/auth/screens/login_screen.dart';
import 'package:mobile_app/features/auth/screens/register_screen.dart';
import 'package:mobile_app/features/auth/screens/role_selection_screen.dart';
import 'package:mobile_app/features/auth/screens/profile_setup_screen.dart';
import 'package:mobile_app/features/home/screens/home_screen.dart';
import 'package:mobile_app/features/marketplace/screens/marketplace_browse_screen.dart';
import 'package:mobile_app/features/marketplace/screens/listing_details_screen.dart';
import 'package:mobile_app/features/marketplace/screens/create_listing_screen.dart';
import 'package:mobile_app/features/marketplace/screens/my_listings_screen.dart';
import 'package:mobile_app/features/scanner/screens/scanner_screen.dart';
import 'package:mobile_app/features/scanner/screens/scan_result_screen.dart';
import 'package:mobile_app/features/diy/screens/diy_browse_screen.dart';
import 'package:mobile_app/features/diy/screens/project_details_screen.dart';
import 'package:mobile_app/features/community/screens/community_feed_screen.dart';
import 'package:mobile_app/features/community/screens/create_post_screen.dart';
import 'package:mobile_app/features/profile/screens/profile_screen.dart';
import 'package:mobile_app/features/profile/screens/settings_screen.dart';
import 'package:mobile_app/features/rewards/screens/notifications_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      // Auth routes
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

      // Main shell with bottom navigation
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

      // Detail routes
      GoRoute(
        path: '/marketplace/:id',
        builder: (context, state) => const ListingDetailsScreen(),
      ),
      GoRoute(
        path: '/create-listing',
        builder: (context, state) => const CreateListingScreen(),
      ),
      GoRoute(
        path: '/my-listings',
        builder: (context, state) => const MyListingsScreen(),
      ),
      GoRoute(
        path: '/scan-result',
        builder: (context, state) => const ScanResultScreen(),
      ),
      GoRoute(
        path: '/diy',
        builder: (context, state) => const DiyBrowseScreen(),
      ),
      GoRoute(
        path: '/diy/:id',
        builder: (context, state) => const ProjectDetailsScreen(),
      ),
      GoRoute(
        path: '/create-post',
        builder: (context, state) => const CreatePostScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
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
