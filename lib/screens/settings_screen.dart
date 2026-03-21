import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/app_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _podcastController;
  late TextEditingController _hostController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<AppProvider>();
    _podcastController = TextEditingController(text: provider.podcastName);
    _hostController = TextEditingController(text: provider.hostName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0c0a14),
      appBar: AppBar(
        title: Text('Settings', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
            child: Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF8b5cf6), Color(0xFF7c3aed)]),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.podcasts_rounded, size: 40, color: Colors.white),
            ),
          ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 32),
          Text('PODCAST PROFILE', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white38, letterSpacing: 2)),
          const SizedBox(height: 16),
          _label('Podcast Name'),
          const SizedBox(height: 8),
          TextField(controller: _podcastController, style: GoogleFonts.inter(color: Colors.white),
            decoration: const InputDecoration(hintText: 'Your podcast name')),
          const SizedBox(height: 16),
          _label('Host Name'),
          const SizedBox(height: 8),
          TextField(controller: _hostController, style: GoogleFonts.inter(color: Colors.white),
            decoration: const InputDecoration(hintText: 'Your name')),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, height: 48,
            child: ElevatedButton(
              onPressed: () {
                context.read<AppProvider>().updateProfile(_podcastController.text, _hostController.text);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
              },
              child: const Text('Save Profile'),
            ),
          ),
          const SizedBox(height: 32),
          Text('APP', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white38, letterSpacing: 2)),
          const SizedBox(height: 16),
          _settingsTile(Icons.share_rounded, 'Share App', 'Tell others about PodCraft',
            () => Share.share('Check out PodCraft - AI podcast content toolkit!')),
          _settingsTile(Icons.star_rounded, 'Rate App', 'Leave a review', () {}),
          _settingsTile(Icons.info_rounded, 'About', 'Version 1.0.0', () {
            showAboutDialog(context: context, applicationName: 'PodCraft', applicationVersion: '1.0.0', applicationLegalese: 'AI Podcast Content Toolkit');
          }),
          const SizedBox(height: 32),
          Center(child: Text('PodCraft v1.0.0', style: GoogleFonts.inter(fontSize: 12, color: Colors.white24))),
        ]),
      ),
    );
  }

  Widget _label(String t) => Text(t, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70));

  Widget _settingsTile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: Container(width: 42, height: 42,
          decoration: BoxDecoration(color: const Color(0xFF8b5cf6).withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: const Color(0xFF8b5cf6), size: 20)),
        title: Text(title, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Text(subtitle, style: GoogleFonts.inter(color: Colors.white38, fontSize: 12)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white24),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: const Color(0xFF161228),
      ),
    );
  }
}
