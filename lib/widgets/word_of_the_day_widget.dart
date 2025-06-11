import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:vocably/models/word_entry_dto.dart';
import 'package:vocably/services/dictionary_api_service.dart';
import 'package:vocably/themes/app_colors.dart';
import 'package:vocably/widgets/bouncable_wrapper_widget.dart';

class WordOfTheDayWidget extends StatefulWidget {
  const WordOfTheDayWidget({super.key});

  @override
  State<WordOfTheDayWidget> createState() => _WordOfTheDayWidgetState();
}

class _WordOfTheDayWidgetState extends State<WordOfTheDayWidget> {
  late AudioPlayer _audioPlayer;
  late Future<WordEntryDTO> _wordOfTheDayFuture;
  final DictionaryApiService _service = DictionaryApiService();

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
        borderRadius: BorderRadius.circular(16.0),

        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.25) : Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // card title
            Text(
              'Word of the day',
              style: GoogleFonts.playfair(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.titleLarge?.color,
                fontSize: 20.0,
              ),
            ),

            const SizedBox(height: 8.0),
            Row(
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

                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // word
                            Text(
                              entry.word ?? '',
                              style: GoogleFonts.merriweather(
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0,
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
                                        entry.meanings?.first.partOfSpeech ?? '',
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
                                        },
                                        child: Icon(
                                          HugeIcons.strokeRoundedVolumeHigh,
                                          color: theme.colorScheme.secondary,
                                          size: 14.0,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            // Definition
                            const SizedBox(height: 5.0),
                            RichText(
                              text: TextSpan(
                                text: entry.meanings?.first.senses?.first.glosses?.first ?? 'No definition found',
                                style: GoogleFonts.merriweather(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                            ),
                            // Learn more button
                            const SizedBox(height: 10.0),
                            InkWell(
                              onTap: () {
                                // Navigate to the details page or perform any action
                                // For now, just show a snackbar
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text('View more details about $entry')));
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'Learn more',
                                    style: GoogleFonts.poppins(
                                      color: theme.colorScheme.secondary,
                                      fontSize: 14.0,
                                      decoration: TextDecoration.underline,
                                      decorationColor: theme.colorScheme.secondary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  BouncableWrapperWidget(
                                    leftToRight: true,
                                    child: Icon(
                                      HugeIcons.strokeRoundedArrowRight02,
                                      color: theme.colorScheme.secondary,
                                      size: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 4.0),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _playAudio(String mediaUrl) async {
    if (mediaUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No audio URL available.')));
      return;
    }
    try {
      // For remote URLs
      await _audioPlayer.play(UrlSource(mediaUrl));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error playing audio: ${e.toString()}')));
    }
  }
}
