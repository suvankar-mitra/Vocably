import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:vocably/models/word_entry_dto.dart';
import 'package:vocably/services/dictionary_api_service.dart';

class DefinitionScreen extends StatefulWidget {
  final String word;
  const DefinitionScreen({super.key, required this.word});

  @override
  State<DefinitionScreen> createState() => _DefinitionScreenState();
}

class _DefinitionScreenState extends State<DefinitionScreen> {
  bool _isAudioPlaying = false;
  late AudioPlayer _audioPlayer;
  // bool _isPosMenuExpanded = false;
  final DictionaryApiService _service = DictionaryApiService();
  late Future<WordEntryDTO> _wordDTOFuture;

  // To hold the resolved WordEntryDTO and selected meaning once the Future completes
  WordEntryDTO? _wordEntry;
  MeaningDTO? _selectedMeaning;
  List<SenseDTO>? _currentSenses;

  @override
  void initState() {
    super.initState();
    _wordDTOFuture = _service.getDefinition(widget.word);
    _audioPlayer = AudioPlayer(); // Initialize in initState
    _audioPlayer.setReleaseMode(ReleaseMode.stop); // Stop audio when widget is disposed
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Method to initialize/update selectedMeaning and senses once WordEntryDTO is available
  void _initializeMeaningAndSenses(WordEntryDTO wordEntry) {
    _wordEntry = wordEntry; // Store the resolved DTO
    if (wordEntry.meanings != null && wordEntry.meanings!.isNotEmpty) {
      _selectedMeaning = wordEntry.meanings!.first;
      _updateSenses();
    } else {
      _selectedMeaning = MeaningDTO(); // Fallback if no meanings
      _currentSenses = [];
    }
  }

  void _updateSenses() {
    if (_selectedMeaning != null && _selectedMeaning!.senses != null && _selectedMeaning!.senses!.isNotEmpty) {
      _currentSenses = _selectedMeaning!.senses!;
    } else {
      _currentSenses = [];
    }
  }

  void _updateSensesSetState() {
    setState(() {
      _updateSenses();
    });
  }

  void _retry() {
    setState(() {
      _wordDTOFuture = _service.getDefinition(widget.word);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          clipBehavior: Clip.antiAlias,
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16.0), bottomRight: Radius.circular(16.0)),
          child: AppBar(
            clipBehavior: Clip.antiAlias,
            title: Hero(
              tag: 'definitions',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  'Definitions',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: isDark ? theme.colorScheme.onSurface : theme.colorScheme.onPrimary,
                  ),
                ),
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
      body: FutureBuilder<WordEntryDTO>(
        future: _wordDTOFuture,
        builder: (BuildContext context, AsyncSnapshot<WordEntryDTO> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Future is still loading
            return Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: Lottie.asset('assets/lottie/lottie_wait_animation_blue.json'),
              ),
            );
          } else if (snapshot.hasError) {
            // Future completed with an error
            final error = snapshot.error;
            String errorMessage = 'An unknown error occurred.';
            int? statusCode;

            if (error is DioException) {
              // If you chose Option A (rethrowing DioException)
              errorMessage = 'API Error: ${error.message}';
              if (error.response != null) {
                statusCode = error.response?.statusCode;
                errorMessage += '\nStatus Code: $statusCode';
                if (statusCode == 404) {
                  errorMessage = 'Definition not found for "${widget.word}".';
                } else if (statusCode == 500) {
                  errorMessage = 'Server error. Please try again later.';
                }
              } else {
                // Network error or other Dio error without a response from server
                errorMessage = 'Network Error: Failed to connect. Please check your internet connection.';
              }
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            errorMessage,
                            style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Lottie.asset('assets/lottie/lottie_nothing_found_blue.json'),
                        ),
                        FilledButton(
                          onPressed: _retry,
                          style: ButtonStyle(backgroundColor: WidgetStateProperty.all(theme.colorScheme.primary)),
                          child: Text('Retry', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            // Future completed successfully with data
            final WordEntryDTO wordEntry = snapshot.data!;

            if (_wordEntry == null) {
              _initializeMeaningAndSenses(wordEntry);
            }

            final List<MeaningDTO> meanings = wordEntry.meanings ?? []; // Get meanings from resolved data

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Word, IPA, POS card
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // word, IPA, audio
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // word
                                  Text(
                                    wordEntry.word ?? '',
                                    style: GoogleFonts.merriweather(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26.0,
                                      color: theme.textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  // ipa
                                  if ((wordEntry.ipa ?? '').isNotEmpty)
                                    Text(
                                      wordEntry.ipa ?? '',
                                      style: GoogleFonts.merriweather(
                                        fontSize: 14.0,
                                        color: theme.textTheme.bodyMedium?.color,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // audio
                      if (wordEntry.audioUrl != null && wordEntry.audioUrl!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                          child: GestureDetector(
                            onTap: () {
                              // play the media if available
                              String mediaUrl = wordEntry.audioUrl ?? '';
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
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.surface,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  isDark
                                                      ? Colors.black.withValues(alpha: 0.25)
                                                      : Colors.grey.withValues(alpha: 0.25),
                                              spreadRadius: 1,
                                              blurRadius: 5,
                                              blurStyle: BlurStyle.normal,
                                              offset: const Offset(1, 1),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            HugeIcons.strokeRoundedVolumeHigh,
                                            color: theme.colorScheme.secondary, // Highlight color
                                            size: 22.0,
                                          ),
                                        ),
                                      ),
                                    )
                                    : Container(
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.surface,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                isDark
                                                    ? Colors.black.withValues(alpha: 0.25)
                                                    : Colors.grey.withValues(alpha: 0.25),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            blurStyle: BlurStyle.normal,
                                            offset: const Offset(1, 1),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          HugeIcons.strokeRoundedVolumeHigh,
                                          color: theme.colorScheme.secondary, // Highlight color
                                          size: 22.0,
                                        ),
                                      ),
                                    ),
                          ),
                        ),

                      // POS title card
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    isDark
                                        ? theme.colorScheme.surface
                                        : theme.colorScheme.primary.withValues(alpha: 0.9),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                                child: Text(
                                  'Part of speech  (${wordEntry.meanings?.length})',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? theme.colorScheme.onSurface : theme.colorScheme.onPrimary,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // part of speech
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                      //   child: AnimatedSize(
                      //     duration: const Duration(milliseconds: 250),
                      //     clipBehavior: Clip.antiAlias,
                      //     alignment: Alignment.topCenter,
                      //     child: GestureDetector(
                      //       onTap: () {
                      //         setState(() {
                      //           _isPosMenuExpanded = !_isPosMenuExpanded;
                      //         });
                      //       },
                      //       child: Container(
                      //         decoration: BoxDecoration(
                      //           color: theme.colorScheme.surface,
                      //           borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color:
                      //                   isDark
                      //                       ? Colors.black.withValues(alpha: 0.25)
                      //                       : Colors.grey.withValues(alpha: 0.25),
                      //               spreadRadius: 2,
                      //               blurRadius: 5,
                      //               blurStyle: BlurStyle.normal,
                      //               offset: const Offset(1, 1),
                      //             ),
                      //           ],
                      //         ),
                      //         clipBehavior: Clip.antiAlias,
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           mainAxisAlignment: MainAxisAlignment.start,
                      //           children: [
                      //             // selected item
                      //             Padding(
                      //               padding: const EdgeInsets.fromLTRB(16.0, 4.0, 8.0, 4.0),
                      //               child: Row(
                      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                 children: [
                      //                   Text(
                      //                     _selectedMeaning?.partOfSpeech ?? '',
                      //                     style: GoogleFonts.poppins(
                      //                       fontSize: 16,
                      //                       fontWeight: FontWeight.w600,
                      //                       color: Colors.black,
                      //                     ),
                      //                   ),
                      //                   IconButton(
                      //                     onPressed: () {
                      //                       setState(() {
                      //                         _isPosMenuExpanded = !_isPosMenuExpanded;
                      //                       });
                      //                     },
                      //                     icon: Icon(
                      //                       _isPosMenuExpanded
                      //                           ? Icons.arrow_drop_up_outlined
                      //                           : Icons.arrow_drop_down_outlined,
                      //                       color: Colors.black,
                      //                       size: 22.0,
                      //                     ),
                      //                   ),
                      //                 ],
                      //               ),
                      //             ),
                      //
                      //             _isPosMenuExpanded
                      //                 ? SizedBox(height: 0.0, child: Divider(color: Colors.grey.withValues(alpha: 0.5)))
                      //                 : const SizedBox(),
                      //             // other items
                      //             _isPosMenuExpanded
                      //                 ? Column(
                      //                   children:
                      //                       meanings.map((meaning) {
                      //                         return Container(
                      //                           clipBehavior: Clip.antiAlias,
                      //                           decoration: BoxDecoration(
                      //                             color:
                      //                                 meaning == _selectedMeaning
                      //                                     ? theme.colorScheme.primary.withValues(alpha: 0.9)
                      //                                     : Colors.transparent,
                      //                           ),
                      //                           child: InkWell(
                      //                             onTap: () {
                      //                               setState(() {
                      //                                 _selectedMeaning = meaning;
                      //                                 _isPosMenuExpanded = false;
                      //                                 _updateSensesSetState();
                      //                               });
                      //                             },
                      //                             child: Padding(
                      //                               padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                      //                               child: Row(
                      //                                 children: [
                      //                                   Text(
                      //                                     meaning.partOfSpeech ?? '',
                      //                                     style: GoogleFonts.poppins(
                      //                                       fontSize: 16,
                      //                                       fontWeight: FontWeight.w600,
                      //                                       color:
                      //                                           meaning == _selectedMeaning
                      //                                               ? Colors.white
                      //                                               : Colors.black,
                      //                                     ),
                      //                                   ),
                      //                                 ],
                      //                               ),
                      //                             ),
                      //                           ),
                      //                         );
                      //                       }).toList(),
                      //                 )
                      //                 : Container(),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          spacing: 4.0,
                          runSpacing: 4.0,
                          children:
                              meanings.map((meaning) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedMeaning = meaning;
                                      _updateSensesSetState();
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                                    decoration: BoxDecoration(
                                      color:
                                          meaning == _selectedMeaning
                                              ? theme.colorScheme.secondary
                                              : Colors.grey.shade600,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Text(
                                      meaning.partOfSpeech ?? '',
                                      style: GoogleFonts.merriweather(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ],
                  ),

                  // Senses
                  Column(
                    children: [
                      // title card
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color:
                                    isDark
                                        ? theme.colorScheme.surface
                                        : theme.colorScheme.primary.withValues(alpha: 0.9),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                                child: Text(
                                  'Glosses  (${_currentSenses!.length})',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? theme.colorScheme.onSurface : theme.colorScheme.onPrimary,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      // glosses
                      Column(
                        children: [
                          if (_currentSenses != null && _currentSenses!.isNotEmpty)
                            ...?_currentSenses?.asMap().entries.map((wordEntry) {
                              final index = wordEntry.key;
                              final sense = wordEntry.value;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // glosses
                                  ...sense.glosses!.asMap().entries.map((wordEntry) {
                                    // final index = wordEntry.key;
                                    final gloss = wordEntry.value;
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: '${index + 1}. ',
                                                    style: GoogleFonts.merriweather(
                                                      fontSize: 18,
                                                      height: 1.5,
                                                      fontWeight: FontWeight.w600,
                                                      color: theme.textTheme.bodyLarge?.color,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: gloss,
                                                    style: GoogleFonts.merriweather(
                                                      fontSize: 14,
                                                      height: 1.5,
                                                      color: theme.textTheme.bodyLarge?.color,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),

                                  // examples
                                  if (sense.examples != null && sense.examples!.isNotEmpty)
                                    Column(
                                      children: [
                                        const SizedBox(height: 8.0),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Examples',
                                                  style: GoogleFonts.merriweather(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 32.0, right: 16.0),
                                          child: Column(
                                            children: [
                                              ...sense.examples!.asMap().entries.map((wordEntry) {
                                                final index = wordEntry.key;
                                                final example = wordEntry.value;
                                                return Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: RichText(
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text: '${_toRoman(index + 1)}.',
                                                                  style: GoogleFonts.merriweather(
                                                                    fontSize: 11,
                                                                    fontWeight: FontWeight.w600,
                                                                    color: theme.textTheme.bodyLarge?.color?.withValues(
                                                                      alpha: 0.8,
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextSpan(
                                                                  text: ' $example',
                                                                  style: GoogleFonts.merriweather(
                                                                    fontSize: 11,
                                                                    color: theme.textTheme.bodyLarge?.color?.withValues(
                                                                      alpha: 0.8,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    const SizedBox(height: 4.0),
                                                  ],
                                                );
                                              }),

                                              // const SizedBox(height: 16.0),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                  // synonyms
                                  if (sense.synonyms != null && sense.synonyms!.isNotEmpty)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8.0),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Synonyms',
                                                  style: GoogleFonts.merriweather(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                          child: Wrap(
                                            alignment: WrapAlignment.start,
                                            spacing: 4.0,
                                            runSpacing: 4.0,
                                            children:
                                                sense.synonyms!.map((synonym) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                          builder: (context) => DefinitionScreen(word: synonym),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 4.0,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.green.shade400,
                                                        borderRadius: BorderRadius.circular(8.0),
                                                      ),
                                                      child: Text(
                                                        synonym,
                                                        style: GoogleFonts.merriweather(
                                                          fontSize: 12,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  // antonyms
                                  if (sense.antonyms != null && sense.antonyms!.isNotEmpty)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8.0),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Antonyms',
                                                  style: GoogleFonts.merriweather(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                          child: Wrap(
                                            alignment: WrapAlignment.start,
                                            spacing: 4.0,
                                            runSpacing: 4.0,
                                            children:
                                                sense.antonyms!.map((antonym) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                          builder: (context) => DefinitionScreen(word: antonym),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 4.0,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.red.shade300,
                                                        borderRadius: BorderRadius.circular(8.0),
                                                      ),
                                                      child: Text(
                                                        antonym,
                                                        style: GoogleFonts.merriweather(
                                                          fontSize: 12,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),

                                  const SizedBox(height: 24.0),
                                ],
                              );
                            }),

                          const SizedBox(height: 16.0),
                        ],
                      ),

                      const SizedBox(height: 16.0),

                      // etymology text
                      Column(
                        children: [
                          if (_selectedMeaning?.etymologyText != null)
                            if (_selectedMeaning?.etymologyText?.isNotEmpty ?? false)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // title card
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                isDark
                                                    ? theme.colorScheme.surface
                                                    : theme.colorScheme.primary.withValues(alpha: 0.9),
                                          ),
                                          clipBehavior: Clip.antiAlias,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                                            child: Text(
                                              'Etymology',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    isDark ? theme.colorScheme.onSurface : theme.colorScheme.onPrimary,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                                    child: Text(
                                      // Prepend the number (index + 1) to the gloss
                                      _selectedMeaning?.etymologyText ?? 'No etymology found',
                                      style: GoogleFonts.merriweather(
                                        fontSize: 14,
                                        height: 1.5,
                                        color: theme.textTheme.bodyLarge?.color,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            );
          } else {
            // Should not happen if ConnectionState is done and no error/data
            return const Center(child: Text('Something went wrong.'));
          }
        },
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

  String _toRoman(int number) {
    final List<Map<int, String>> romanSymbols = [
      {1000: "M"},
      {900: "CM"},
      {500: "D"},
      {400: "CD"},
      {100: "C"},
      {90: "XC"},
      {50: "L"},
      {40: "XL"},
      {10: "X"},
      {9: "IX"},
      {5: "V"},
      {4: "IV"},
      {1: "I"},
    ];

    String result = "";
    for (var symbol in romanSymbols) {
      int value = symbol.keys.first;
      String numeral = symbol.values.first;
      while (number >= value) {
        result += numeral;
        number -= value;
      }
    }
    return result;
  }
}
