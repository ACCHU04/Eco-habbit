import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/theme/colors.dart';
import '../../../core/widgets/eco_error_view.dart';
import '../models/admin_user.dart';
import '../providers/admin_dashboard_provider.dart';
import '../widgets/admin_role_chip.dart';
import 'package:intl/intl.dart';

class AdminUserDetailScreen extends ConsumerStatefulWidget {
  final String userId;
  const AdminUserDetailScreen({super.key, required this.userId});

  @override
  ConsumerState<AdminUserDetailScreen> createState() =>
      _AdminUserDetailScreenState();
}

class _AdminUserDetailScreenState
    extends ConsumerState<AdminUserDetailScreen> {
  AdminUser? _user;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(adminRepositoryProvider);
      final user = await repo.getUserDetail(widget.userId);
      setState(() {
        _user = user;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _changeRole(String newRole) async {
    try {
      final repo = ref.read(adminRepositoryProvider);
      await repo.changeRole(widget.userId, newRole);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Role updated')),
        );
        _loadUser();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _changeStatus(String newStatus) async {
    try {
      final repo = ref.read(adminRepositoryProvider);
      await repo.changeStatus(widget.userId, newStatus);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Status updated')),
        );
        _loadUser();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_user?.fullName ?? 'User Detail'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? EcoErrorView(
                  message: _error!,
                  onRetry: _loadUser,
                )
              : _buildContent(theme),
    );
  }

  Widget _buildContent(ThemeData theme) {
    final user = _user!;
    return SingleChildScrollView(
      padding: EcoTokens.paddingPage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                user.fullName.isNotEmpty
                    ? user.fullName[0].toUpperCase()
                    : '?',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: EcoTokens.spacing4),
          Center(
            child: Text(
              user.fullName,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Center(
            child: Text(
              user.email,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: EcoTokens.spacing3),
          Center(child: AdminRoleChip(role: user.role)),
          const SizedBox(height: EcoTokens.spacing5),
          Text(
            'Actions',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: EcoTokens.spacing3),
          if (user.role != 'super_admin')
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Promote to Admin'),
              onTap: () => _showRoleDialog('admin'),
            ),
          if (user.role == 'admin')
            ListTile(
              leading: const Icon(Icons.upgrade),
              title: const Text('Promote to Super Admin'),
              onTap: () => _showRoleDialog('super_admin'),
            ),
          if (user.role == 'admin')
            ListTile(
              leading: const Icon(Icons.arrow_downward),
              title: const Text('Demote to Moderator'),
              onTap: () => _showRoleDialog('moderator'),
            ),
          if (user.role != 'student' && user.role != 'super_admin')
            ListTile(
              leading: const Icon(Icons.person_remove),
              title: const Text('Demote to Student'),
              onTap: () => _showRoleDialog('student'),
            ),
          const Divider(),
          if (user.status == 'active')
            ListTile(
              leading: const Icon(Icons.pause_circle, color: AppColors.warning),
              title: const Text('Suspend User'),
              onTap: () => _changeStatus('suspended'),
            ),
          if (user.status == 'suspended')
            ListTile(
              leading: const Icon(Icons.play_circle, color: AppColors.success),
              title: const Text('Reactivate User'),
              onTap: () => _changeStatus('active'),
            ),
          if (user.status == 'active')
            ListTile(
              leading: const Icon(Icons.block, color: AppColors.error),
              title: const Text('Deactivate User'),
              subtitle: const Text('This action is permanent'),
              onTap: () => _changeStatus('deactivated'),
            ),
          const SizedBox(height: EcoTokens.spacing5),
          Text(
            'Details',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: EcoTokens.spacing3),
          _DetailRow(label: 'College', value: user.college ?? '—'),
          _DetailRow(label: 'Hostel', value: user.hostel ?? '—'),
          _DetailRow(label: 'Department', value: user.department ?? '—'),
          _DetailRow(
            label: 'Joined',
            value: DateFormat.yMMMd().format(user.createdAt),
          ),
          _DetailRow(label: 'Status', value: user.status),
        ],
      ),
    );
  }

  void _showRoleDialog(String newRole) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Change Role to $newRole?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _changeRole(newRole);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: EcoTokens.spacing2),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
