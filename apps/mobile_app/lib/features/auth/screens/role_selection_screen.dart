import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/features/auth/providers/auth_provider.dart';

class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() =>
      _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  String? _selectedRole;

  final _roles = [
    {
      'id': 'student',
      'title': 'Student',
      'description': 'Buy, sell, and learn about sustainability',
      'icon': Icons.school_outlined,
    },
    {
      'id': 'ngo',
      'title': 'NGO',
      'description': 'Manage recycling drives and campaigns',
      'icon': Icons.volunteer_activism_outlined,
    },
    {
      'id': 'organization',
      'title': 'Organization',
      'description': 'Campus sustainability programs',
      'icon': Icons.business_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Role')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'What best describes you?',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'This helps us personalize your experience',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 32),
            ..._roles.map((role) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: _selectedRole == role['id']
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withValues(alpha: 0.3),
                        width: _selectedRole == role['id'] ? 2 : 1,
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () =>
                          setState(() => _selectedRole = role['id'] as String?),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              role['icon'] as IconData,
                              size: 32,
                              color: _selectedRole == role['id']
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    role['title'] as String,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    role['description'] as String,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_selectedRole == role['id'])
                              Icon(Icons.check_circle,
                                  color: theme.colorScheme.primary),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
            const Spacer(),
            ElevatedButton(
              onPressed: _selectedRole == null
                  ? null
                  : () {
                      ref
                          .read(authProvider.notifier)
                          .updateRole(_selectedRole!);
                      context.go('/profile-setup');
                    },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
