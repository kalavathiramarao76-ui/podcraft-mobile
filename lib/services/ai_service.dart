import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _baseUrl = 'https://sai.sharedllm.com/v1/chat/completions';
  static const String _model = 'gpt-oss:120b';

  static Future<String> generate(String systemPrompt, String userPrompt) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': userPrompt},
          ],
          'temperature': 0.7,
          'max_tokens': 4096,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] ?? 'No response generated.';
      } else {
        return 'Error: Server returned status ${response.statusCode}. Please try again.';
      }
    } catch (e) {
      return 'Error: Could not connect to AI service. Please check your connection and try again.';
    }
  }

  static Future<String> summarizeEpisode(String details) async {
    return generate(
      'You are an expert podcast content summarizer. Create comprehensive, engaging episode summaries with key takeaways, timestamps, and highlights. Format with clear sections.',
      'Summarize this podcast episode:\n\n$details',
    );
  }

  static Future<String> generateClips(String details) async {
    return generate(
      'You are an expert at identifying viral podcast clips. Suggest the best clip-worthy moments with timestamps, suggested titles, platform-specific captions for TikTok/Reels/Shorts, and hooks.',
      'Identify the best clip moments from this podcast:\n\n$details',
    );
  }

  static Future<String> generatePosts(String details) async {
    return generate(
      'You are a social media expert for podcast creators. Generate engaging social media posts for multiple platforms (Twitter/X, LinkedIn, Instagram, Facebook) with relevant hashtags, hooks, and CTAs.',
      'Create social media posts for this podcast episode:\n\n$details',
    );
  }

  static Future<String> generateNewsletter(String details) async {
    return generate(
      'You are an expert newsletter writer for podcasters. Create engaging email newsletters that recap episodes, share insights, and drive listener engagement. Include subject line, preview text, and formatted body.',
      'Write a newsletter for this podcast episode:\n\n$details',
    );
  }

  static Future<String> generateShowNotes(String details) async {
    return generate(
      'You are an expert at writing podcast show notes. Create detailed, SEO-optimized show notes with episode description, key topics, timestamps, guest bio, resources mentioned, and relevant links format.',
      'Generate show notes for this podcast episode:\n\n$details',
    );
  }
}
