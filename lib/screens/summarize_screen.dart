import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/app_provider.dart';
import '../services/ai_service.dart';

class SummarizeScreen extends StatefulWidget {
  const SummarizeScreen({super.key});

  @override
  State<SummarizeScreen> createState() => _SummarizeScreenState();
}

class _SummarizeScreenState extends State<SummarizeScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _guestController = TextEditingController();
  String _result = '';
  bool _loading = false;

  Future<void> _generate() async {
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please describe the episode content')));
      return;
    }
    setState(() { _loading = true; _result = ''; });
    final details = '''
Episode Title: ${_titleController.text}
Guest: ${_guestController.text}
Episode Content/Transcript: ${_contentController.text}
''';
    final response = await AIService.summarizeEpisode(details);
    setState(() { _result = response; _loading = false; });
    if (mounted) context.read<AppProvider>().addContent('summary', 'Summary - ${_titleController.text}', response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0c0a14),
      appBar: AppBar(
        title: Text('Summarize', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF8b5cf6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF8b5cf6).withOpacity(0.2)),
            ),
            child: Row(children: [
              Icon(Icons.summarize_rounded, color: const Color(0xFF8b5cf6)),
              const SizedBox(width: 12),
              Expanded(child: Text('Paste your episode transcript or describe the content for an AI summary.',
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white70))),
            ]),
          ).animate().fadeIn().slideY(begin: 0.1),
          const SizedBox(height: 24),
          _label('Episode Title'),
          const SizedBox(height: 8),
          TextField(controller: _titleController, style: GoogleFonts.inter(color: Colors.white),
            decoration: const InputDecoration(hintText: 'e.g., The Future of AI')),
          const SizedBox(height: 20),
          _label('Guest Name'),
          const SizedBox(height: 8),
          TextField(controller: _guestController, style: GoogleFonts.inter(color: Colors.white),
            decoration: const InputDecoration(hintText: 'e.g., Dr. Sarah Chen')),
          const SizedBox(height: 20),
          _label('Episode Content / Transcript *'),
          const SizedBox(height: 8),
          TextField(controller: _contentController, style: GoogleFonts.inter(color: Colors.white), maxLines: 6,
            decoration: const InputDecoration(hintText: 'Paste transcript or describe key topics discussed...')),
          const SizedBox(height: 24),
          SizedBox(width: double.infinity, height: 56,
            child: ElevatedButton.icon(
              onPressed: _loading ? null : _generate,
              icon: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.auto_awesome),
              label: Text(_loading ? 'Summarizing...' : 'Summarize Episode'),
            ),
          ),
          if (_result.isNotEmpty) ...[
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _label('Episode Summary'),
              IconButton(onPressed: () => Share.share(_result), icon: const Icon(Icons.share_rounded, color: Color(0xFF8b5cf6), size: 20)),
            ]),
            const SizedBox(height: 8),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF161228), borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF8b5cf6).withOpacity(0.2)),
              ),
              child: SelectableText(_result, style: GoogleFonts.inter(fontSize: 14, color: Colors.white.withOpacity(0.9), height: 1.6)),
            ).animate().fadeIn().slideY(begin: 0.05),
          ],
        ]),
      ),
    );
  }

  Widget _label(String t) => Text(t, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70));
}
