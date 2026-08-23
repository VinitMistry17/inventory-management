import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/core/errors/app_exception.dart';
import 'package:inventory_management/features/auth/presentation/screens/login_screen.dart';
import '../providers/profile_providers.dart';
import '../providers/update_notifications_controller.dart';
import '../providers/update_reminder_timing_controller.dart';
import '../providers/logout_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _refresh(WidgetRef ref) {
    return ref.refresh(profileProvider.future).then<void>((_) {});
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Logout?"),
        content: const Text("You'll need to sign in again."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(logoutControllerProvider.notifier).logout();
    }
  }

  Future<void> _showReminderPicker(
    BuildContext context,
    WidgetRef ref,
    int currentDays,
  ) async {
    final controller = TextEditingController(text: currentDays.toString());

    final result = await showDialog<int>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Remind me before expiry"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(suffixText: "days"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              Navigator.of(dialogContext).pop(value);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );

    if (result != null) {
      await ref
          .read(updateReminderTimingControllerProvider.notifier)
          .updateReminderTiming(result);
      ref.invalidate(profileProvider);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    ref.listen(logoutControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          if (previous is AsyncLoading) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          }
        },
      );
    });

    return profileAsync.when(
      data: (profile) {
        final colorScheme = Theme.of(context).colorScheme;

        return RefreshIndicator(
          onRefresh: () => _refresh(ref),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 36, 20, 28),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  border: Border(
                    bottom: BorderSide(color: colorScheme.outlineVariant),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 38,
                        backgroundColor: colorScheme.primary.withValues(
                          alpha: 0.12,
                        ),
                        child: Text(
                          profile.name.isNotEmpty
                              ? profile.name[0].toUpperCase()
                              : "?",
                          style: TextStyle(
                            fontSize: 28,
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      profile.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.mail_outline,
                          size: 15,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          profile.email,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 13,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Member since ${profile.memberSince}",
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stat card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            color: colorScheme.primary,
                            size: 26,
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${profile.totalItems}",
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                    ),
                              ),
                              Text(
                                "Items tracked",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      "SETTINGS",
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Card(
                      elevation: 0,
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.4,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          SwitchListTile(
                            secondary: Icon(
                              Icons.notifications_outlined,
                              color: colorScheme.primary,
                            ),
                            title: const Text("Notifications"),
                            value: profile.notificationsEnabled,
                            onChanged: (value) async {
                              await ref
                                  .read(
                                    updateNotificationsControllerProvider
                                        .notifier,
                                  )
                                  .updateNotifications(value);
                              ref.invalidate(profileProvider);
                            },
                          ),
                          Divider(
                            height: 1,
                            color: colorScheme.outlineVariant,
                            indent: 16,
                            endIndent: 16,
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.timer_outlined,
                              color: colorScheme.primary,
                            ),
                            title: const Text("Reminder timing"),
                            subtitle: Text(
                              "${profile.reminderDaysBefore} days before expiry",
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => _showReminderPicker(
                              context,
                              ref,
                              profile.reminderDaysBefore,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    OutlinedButton.icon(
                      onPressed: () => _confirmLogout(context, ref),
                      icon: Icon(Icons.logout, color: colorScheme.error),
                      label: Text(
                        "Logout",
                        style: TextStyle(
                          color: colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        side: BorderSide(
                          color: colorScheme.error.withValues(alpha: 0.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) {
        final message = err is AppException
            ? err.message
            : "Failed to load profile";
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => ref.invalidate(profileProvider),
                child: const Text("Retry"),
              ),
            ],
          ),
        );
      },
    );
  }
}
