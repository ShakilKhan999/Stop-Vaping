import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubeLauncher {
  // Updated method to launch YouTube video in external app or browser
  static Future<void> launchYouTubeVideo(String videoId) async {
    final Uri url = Uri.parse('https://www.youtube.com/watch?v=$videoId');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  // Method to play YouTube video within the app (unchanged)
  static Widget playYouTubeVideo(String videoId) {
    return YoutubePlayer(
      controller: YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      ),
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.blueAccent,
    );
  }
}

// Example usage in a widget:
class YouTubeVideoScreen extends StatelessWidget {
  final String videoId = 'dQw4w9WgXcQ'; // Example video ID

  const YouTubeVideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YouTube Video')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => YouTubeLauncher.launchYouTubeVideo(videoId),
              child: const Text('Open in YouTube App'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
