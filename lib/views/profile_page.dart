import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Me'),
        backgroundColor: const Color(0xFF516CF5),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.person, size: 32),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Guest Player',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Sign in with Google to sync progress',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: null,
                child: Text('Google Sign-In'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _ProfileTile(
            icon: Icons.settings,
            title: 'Settings',
          ),
          _ProfileTile(
            icon: Icons.help_outline,
            title: 'Help',
          ),
          _ProfileTile(
            icon: Icons.info_outline,
            title: 'About',
          ),
          _ProfileTile(
            icon: Icons.lock_outline,
            title: 'Privacy',
          ),
          _ProfileTile(
            icon: Icons.block,
            title: 'Remove Ads',
            subtitle: 'Coming soon',
          ),
          _ProfileTile(
            icon: Icons.restore,
            title: 'Restore Purchases',
            subtitle: 'Coming soon',
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9ECFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.people_alt,
                    color: Color(0xFF516CF5),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Multiplayer with friends is coming soon.',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFE9ECFF),
        child: Icon(icon, color: const Color(0xFF516CF5)),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
