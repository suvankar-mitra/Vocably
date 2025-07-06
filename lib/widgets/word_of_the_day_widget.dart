import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:vocably/models/word_entry_dto.dart';
import 'package:vocably/services/dictionary_api_service.dart';
import 'package:vocably/themes/app_colors.dart';
import 'package:vocably/utils/utilities.dart';
import 'package:vocably/views/screens/home_screen/definition_screen.dart';

class WordOfTheDayWidget extends StatefulWidget {
  const WordOfTheDayWidget({super.key});

  @override
  State<WordOfTheDayWidget> createState() => _WordOfTheDayWidgetState();
}

class _WordOfTheDayWidgetState extends State<WordOfTheDayWidget> {
  late AudioPlayer _audioPlayer;
  late Future<WordEntryDTO> _wordOfTheDayFuture;
  final DictionaryApiService _service = DictionaryApiService();
  bool _isDefCollapsed = true;
  bool _isAudioPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(); // Initialize in initState
    _audioPlayer.setReleaseMode(ReleaseMode.stop); // Stop audio when widget is disposed
    _wordOfTheDayFuture = _service.getWordOfTheDay();
  }

  void _retry() {
    setState(() {
      _wordOfTheDayFuture = _service.getWordOfTheDay();
    });
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

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(width: 1.2, color: theme.primaryColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // card title
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? theme.colorScheme.surface : theme.colorScheme.primary.withValues(alpha: 0.9),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Word of the day 💡',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: isDark ? theme.colorScheme.onSurface : theme.colorScheme.onPrimary,
                            fontSize: 16.0,
                          ),
                        ),

                        FutureBuilder<WordEntryDTO>(
                          future: _wordOfTheDayFuture,
                          builder: (context, snapshot) {
                            final entry = snapshot.data;
                            if (entry != null) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => DefinitionScreen(word: entry.word ?? '')),
                                  );
                                },
                                child: Hero(
                                  tag: 'definitions',
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Icon(
                                      HugeIcons.strokeRoundedArrowRight01,
                                      color: isDark ? theme.colorScheme.onSurface : theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 0.0, child: Divider(color: isDark ? Colors.grey : Colors.transparent)),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: FutureBuilder<WordEntryDTO>(
                    future: _wordOfTheDayFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Lottie.asset('assets/lottie/lottie_wait_animation_blue.json'),
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        // return Center(child: Text('Error: ${snapshot.error}'));
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  'Oops! something went wrong while fetching word of the day.',
                                  style: GoogleFonts.poppins(color: Colors.red),
                                ),
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Lottie.asset('assets/lottie/lottie_nothing_found_blue.json'),
                                ),
                                FilledButton(
                                  onPressed: _retry,
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(AppColors.secondaryAccentColor),
                                  ),
                                  child: Text('Retry', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      final entry = snapshot.data;
                      if (entry == null) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  'No words found',
                                  style: GoogleFonts.poppins(color: theme.textTheme.bodyMedium?.color),
                                ),
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Lottie.asset('assets/lottie/lottie_nothing_found_blue.json'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // word
                          Text(
                            entry.word ?? '',
                            style: GoogleFonts.merriweather(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          // phonetic details
                          Row(
                            children: [
                              if ((entry.meanings?.first.partOfSpeech ?? '').isNotEmpty)
                                Row(
                                  children: [
                                    Text(
                                      Utilities.getFullPartOfSpeech(entry.meanings?.first.partOfSpeech ?? ''),
                                      style: GoogleFonts.merriweather(
                                        fontSize: 14.0,
                                        color: theme.textTheme.bodyMedium?.color,
                                      ),
                                    ),
                                  ],
                                ),

                              if ((entry.ipa ?? '').isNotEmpty)
                                Row(
                                  children: [
                                    const SizedBox(width: 4.0),
                                    Text('•'),
                                    const SizedBox(width: 4.0),
                                    Text(
                                      (entry.ipa ?? '').trim(),
                                      style: GoogleFonts.merriweather(
                                        fontSize: 14.0,
                                        color: theme.textTheme.bodyMedium?.color,
                                      ),
                                    ),
                                  ],
                                ),

                              if ((entry.audioUrl ?? '').isNotEmpty)
                                Row(
                                  children: [
                                    const SizedBox(width: 4.0),
                                    Text('•'),
                                    const SizedBox(width: 4.0),
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
                                                  size: 18.0,
                                                ),
                                              )
                                              : Icon(
                                                // Static icon when not playing
                                                HugeIcons.strokeRoundedVolumeHigh,
                                                color: theme.colorScheme.secondary,
                                                size: 18.0,
                                              ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          // Definition
                          const SizedBox(height: 8.0),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isDefCollapsed = !_isDefCollapsed;
                              });
                            },
                            child: AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              curve: Easing.standard,
                              alignment: Alignment.topCenter,
                              child: RichText(
                                text: TextSpan(
                                  text: entry.meanings?.first.senses?.first.glosses?.first ?? 'No definition found',
                                  style: GoogleFonts.merriweather(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: theme.textTheme.bodyLarge?.color,
                                  ),
                                ),
                                maxLines: _isDefCollapsed ? 2 : null,
                                overflow: _isDefCollapsed ? TextOverflow.ellipsis : TextOverflow.visible,
                                // overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
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
