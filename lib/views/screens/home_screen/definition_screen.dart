import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocably/models/word_entry_dto.dart';

class DefinitionScreen extends StatefulWidget {
  final WordEntryDTO wordEntry;
  const DefinitionScreen({super.key, required this.wordEntry});

  @override
  State<DefinitionScreen> createState() => _DefinitionScreenState();
}

class _DefinitionScreenState extends State<DefinitionScreen> {
  bool _isAudioPlaying = false;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(); // Initialize in initState
    _audioPlayer.setReleaseMode(ReleaseMode.stop); // Stop audio when widget is disposed
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final entry = widget.wordEntry;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16.0), bottomRight: Radius.circular(16.0)),
          child: AppBar(
            title: Text(
              'Definitions',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: isDark ? theme.colorScheme.onSurface : theme.colorScheme.onPrimary,
              ),
            ),
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(HugeIcons.strokeRoundedArrowLeft01, color: theme.colorScheme.secondary),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(HugeIcons.strokeRoundedShare08, color: theme.colorScheme.secondary),
              ),
            ],
          ),
        ),
      ),
      body: Hero(
        tag: 'wordOfTheDay',
        child: Material(
          color: Colors.transparent,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 24.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16.0),

                      boxShadow: [
                        BoxShadow(
                          color: isDark ? Colors.black.withValues(alpha: 0.25) : Colors.grey.withValues(alpha: 0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          blurStyle: BlurStyle.normal,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.word ?? '',
                                    style: GoogleFonts.merriweather(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0,
                                      color: theme.textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                  if ((entry.ipa ?? '').isNotEmpty)
                                    Text(
                                      entry.ipa ?? '',
                                      style: GoogleFonts.merriweather(
                                        fontSize: 14.0,
                                        color: theme.textTheme.bodyMedium?.color,
                                      ),
                                    ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  // play the media if available
                                  String mediaUrl = entry.audioUrl ?? '';
                                  _playAudio(mediaUrl);
                                  setState(() {
                                    _isAudioPlaying = true;
                                  });
                                },
                                child:
                                    _isAudioPlaying
                                        ? TweenAnimationBuilder<double>(
                                          // Animate when playing
                                          tween: Tween<double>(begin: 1.5, end: 1.0), // Example: scale tween
                                          duration: const Duration(milliseconds: 500),
                                          builder: (context, scale, child) {
                                            return Transform.scale(scale: scale, child: child);
                                          },
                                          child: Icon(
                                            HugeIcons.strokeRoundedVolumeHigh,
                                            color: theme.colorScheme.secondary, // Highlight color
                                            size: 22.0,
                                          ),
                                        )
                                        : Icon(
                                          // Static icon when not playing
                                          HugeIcons.strokeRoundedVolumeHigh,
                                          color: theme.colorScheme.secondary,
                                          size: 22.0,
                                        ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _playAudio(String mediaUrl) async {
    if (mediaUrl.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No audio URL available.')));
        return;
      }
    }
    try {
      // For remote URLs
      await _audioPlayer.play(UrlSource(mediaUrl));

      _audioPlayer.onPlayerStateChanged.listen((state) {
        if (mounted) {
          setState(() {
            _isAudioPlaying = state == PlayerState.playing;
          });
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error playing audio: ${e.toString()}')));
      }
    }
  }
}
