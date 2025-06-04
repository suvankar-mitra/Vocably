import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:vocably/models/word_entry_dto.dart';
import 'package:vocably/services/dictionary_api_service.dart';
import 'package:vocably/themes/app_colors.dart';

class WordOfTheDayWidget extends StatefulWidget {
  const WordOfTheDayWidget({super.key});

  @override
  State<WordOfTheDayWidget> createState() => _WordOfTheDayWidgetState();
}

class _WordOfTheDayWidgetState extends State<WordOfTheDayWidget> {
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
    DictionaryApiService service = DictionaryApiService();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16.0),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Word of the day',
              style: GoogleFonts.playfair(fontWeight: FontWeight.bold, color: AppColors.appTitleColor, fontSize: 22.0),
            ),
            const SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: FutureBuilder<WordEntryDTO>(
                    future: service.getWordOfTheDay(),
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
                                Text('Error: ${snapshot.error}', style: GoogleFonts.poppins(color: Colors.red)),
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
                      final entry = snapshot.data;
                      if (entry == null) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Column(
                              children: [
                                Text('No words found', style: GoogleFonts.poppins(color: AppColors.secondaryTextColor)),
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
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.word ?? '',
                              style: GoogleFonts.merriweather(
                                fontWeight: FontWeight.bold,
                                fontSize: 26.0,
                                color: AppColors.primaryTextColor,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                if ((entry.meanings?.first.partOfSpeech ?? '').isNotEmpty)
                                  Row(
                                    children: [
                                      Text(
                                        entry.meanings?.first.partOfSpeech ?? '',
                                        style: GoogleFonts.merriweather(
                                          fontSize: 16.0,
                                          color: AppColors.secondaryTextColor,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                    ],
                                  ),

                                if ((entry.ipa ?? '').isNotEmpty)
                                  Row(
                                    children: [
                                      Text(
                                        (entry.ipa ?? '').trim(),
                                        style: GoogleFonts.merriweather(
                                          fontSize: 16.0,
                                          color: AppColors.secondaryTextColor,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                    ],
                                  ),

                                if ((entry.audioUrl ?? '').isNotEmpty)
                                  InkWell(
                                    onTap: () {
                                      // play the media if available
                                      String mediaUrl = entry.audioUrl ?? '';
                                      _playAudio(mediaUrl);
                                    },
                                    child: Icon(
                                      HugeIcons.strokeRoundedVolumeHigh,
                                      color: AppColors.secondaryAccentColor,
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 5.0),
                            RichText(
                              text: TextSpan(
                                text: entry.meanings?.first.senses?.first.glosses?.first ?? 'No definition found',
                                style: GoogleFonts.merriweather(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            InkWell(
                              onTap: () {},
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: 'Learn more',
                                      style: GoogleFonts.playfair(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: AppColors.secondaryAccentColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Icon(
                                    HugeIcons.strokeRoundedArrowRight02,
                                    color: AppColors.secondaryAccentColor,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
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
