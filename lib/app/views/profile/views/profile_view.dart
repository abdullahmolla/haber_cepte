import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:haber_cepte/app/routes/route_names.dart';
import 'package:haber_cepte/core/cache/hive_service.dart';
import 'package:haber_cepte/core/localization/locale_cubit.dart';
import 'package:haber_cepte/core/localization/locale_state.dart';
import 'package:haber_cepte/core/theme/app_colors.dart';
import 'package:haber_cepte/core/theme/theme_cubit.dart';
import 'package:haber_cepte/core/theme/theme_state.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool notificationsEnabled = HiveService.getNotificationEnabled();

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    if (context.mounted) {
      context.go(RouteNames.login);
    }
  }

  Future<void> _toggleNotification(bool value) async {
    await HiveService.setNotificationEnabled(value);

    setState(() {
      notificationsEnabled = value;
    });
  }

  void _showLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (bottomSheetContext) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Dil Seçimi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Text('🇹🇷'),
                title: const Text('Türkçe'),
                onTap: () {
                  context.read<LocaleCubit>().changeLanguage('tr');
                  Navigator.pop(bottomSheetContext);
                },
              ),
              ListTile(
                leading: const Text('🇬🇧'),
                title: const Text('English'),
                onTap: () {
                  context.read<LocaleCubit>().changeLanguage('en');
                  Navigator.pop(bottomSheetContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: AppColors.accent.withValues(alpha: 0.12),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 48,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Haber Cepte Kullanıcısı',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  user?.email ?? 'E-posta bulunamadı',
                  style: const TextStyle(
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _ProfileMenuItem(
            icon: Icons.bookmark_rounded,
            title: 'Kaydedilen Haberler',
            subtitle: 'Daha sonra okumak için kaydettiğin haberler',
            onTap: () {
              context.push(RouteNames.savedNews);
            },
          ),

          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return _ProfileSwitchItem(
                icon: Icons.dark_mode_rounded,
                title: 'Karanlık Tema',
                subtitle: 'Uygulama temasını değiştir',
                value: state.isDark,
                onChanged: (value) {
                  context.read<ThemeCubit>().toggleTheme(value);
                },
              );
            },
          ),

          _ProfileSwitchItem(
            icon: Icons.notifications_rounded,
            title: 'Bildirimler',
            subtitle: 'Kaydedilen haberler için bildirim tercihi',
            value: notificationsEnabled,
            onChanged: _toggleNotification,
          ),

          BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, state) {
              return _ProfileMenuItem(
                icon: Icons.language_rounded,
                title: 'Dil Seçimi',
                subtitle: state.languageCode == 'tr' ? 'Türkçe' : 'English',
                onTap: () {
                  _showLanguageSheet(context);
                },
              );
            },
          ),

          const SizedBox(height: 16),

          _ProfileMenuItem(
            icon: Icons.logout_rounded,
            title: 'Çıkış Yap',
            subtitle: 'Hesabından güvenli şekilde çık',
            iconColor: Colors.red,
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? AppColors.accent;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}

class _ProfileSwitchItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ProfileSwitchItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        secondary: CircleAvatar(
          backgroundColor: AppColors.accent.withValues(alpha: 0.12),
          child: Icon(
            icon,
            color: AppColors.accent,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        subtitle: Text(subtitle),
        activeThumbColor: AppColors.accent,
      ),
    );
  }
}