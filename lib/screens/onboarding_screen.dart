import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.podcasts_rounded,
      'title': 'Summarize\nEpisodes',
      'subtitle': 'Transform long podcast episodes into concise, shareable summaries with key takeaways and timestamps.',
      'color': const Color(0xFF8b5cf6),
    },
    {
      'icon': Icons.content_cut_rounded,
      'title': 'Create Viral\nClips',
      'subtitle': 'AI identifies the most clip-worthy moments. Get titles, hooks, and platform-specific captions instantly.',
      'color': const Color(0xFF7c3aed),
    },
    {
      'icon': Icons.campaign_rounded,
      'title': 'Grow Your\nAudience',
      'subtitle': 'Generate social posts, newsletters, and show notes that drive engagement and attract new listeners.',
      'color': const Color(0xFF6d28d9),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0c0a14),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140, height: 140,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [page['color'], page['color'].withOpacity(0.6)]),
                            borderRadius: BorderRadius.circular(35),
                            boxShadow: [BoxShadow(color: (page['color'] as Color).withOpacity(0.3), blurRadius: 30, spreadRadius: 5)],
                          ),
                          child: Icon(page['icon'], size: 70, color: Colors.white),
                        ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                        const SizedBox(height: 48),
                        Text(page['title'], textAlign: TextAlign.center,
                          style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white, height: 1.2, letterSpacing: -1),
                        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                        const SizedBox(height: 16),
                        Text(page['subtitle'], textAlign: TextAlign.center,
                          style: GoogleFonts.inter(fontSize: 16, color: Colors.white60, height: 1.5),
                        ).animate().fadeIn(delay: 400.ms),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == i ? 32 : 8, height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == i ? const Color(0xFF8b5cf6) : const Color(0xFF8b5cf6).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(width: double.infinity, height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage < 2) {
                          _controller.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                        } else {
                          context.read<AppProvider>().completeOnboarding();
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
                        }
                      },
                      child: Text(_currentPage < 2 ? 'Next' : 'Get Started'),
                    ),
                  ),
                  if (_currentPage < 2)
                    TextButton(
                      onPressed: () {
                        context.read<AppProvider>().completeOnboarding();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
                      },
                      child: Text('Skip', style: TextStyle(color: Colors.white38)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
