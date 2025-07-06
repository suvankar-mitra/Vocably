import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vocably/models/translation_dto.dart';
import 'package:vocably/models/word_entry_dto.dart';
import 'package:vocably/services/dictionary_api_service.dart';
import 'package:vocably/utils/utilities.dart';

class DefinitionScreen extends StatefulWidget {
  final String word;
  const DefinitionScreen({super.key, required this.word});

  @override
  State<DefinitionScreen> createState() => _DefinitionScreenState();
}

class _DefinitionScreenState extends State<DefinitionScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPosMenuExpanded = false;
  final DictionaryApiService _service = DictionaryApiService();
  late Future<WordEntryDTO> _wordDTOFuture;
  late Future<List<TranslationDTO>> _translationDTOFuture;

  // To hold the resolved WordEntryDTO and selected meaning once the Future completes
  WordEntryDTO? _wordEntry;
  MeaningDTO? _selectedMeaning;
  List<SenseDTO>? _currentSenses;

  TranslationDTO? _selectedTranslation;

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
    // sort meanings
    wordEntry.meanings?.sort((a, b) {
      final posA = Utilities.getFullPartOfSpeech(a.partOfSpeech ?? '');
      final posB = Utilities.getFullPartOfSpeech(b.partOfSpeech ?? '');
      return posA.compareTo(posB);
    });
    if (wordEntry.meanings != null && wordEntry.meanings!.isNotEmpty) {
      _selectedMeaning = wordEntry.meanings!.first;
      _updateSenses();
      _updateTranslation();
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

  void _initializeTranslation(List<TranslationDTO> translations) {
    _selectedTranslation = translations.first;
  }

  void _updateTranslation() {
    // Get the translations
    _translationDTOFuture = _service.getTranslations(widget.word, _selectedMeaning?.partOfSpeech ?? '');
    _selectedTranslation = null;
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
      body: FutureBuilder<WordEntryDTO>(
        future: _wordDTOFuture,
        builder: (BuildContext context, AsyncSnapshot<WordEntryDTO> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Future is still loading
            return Center(
              child: SizedBox(
                height: 150,
                width: 150,
                child: Lottie.asset('assets/lottie/lottie_wait_animation_blue.json'),
              ),
            );
          } else if (snapshot.hasError) {
            // Future completed with an error
            final error = snapshot.error;
            String errorMessage = 'An unknown error occurred.';
            int? statusCode;

            if (error is DioException) {
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
              child: Container(
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
                child: Row(
                  children: [
                    Expanded(
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
                          if (statusCode != 404)
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
              ),
            );
          } else if (snapshot.hasData) {
            // Future completed successfully with data
            final WordEntryDTO wordEntry = snapshot.data!;

            if (_wordEntry == null) {
              _initializeMeaningAndSenses(wordEntry);
            }

            final List<MeaningDTO> meanings = wordEntry.meanings ?? []; // Get meanings from resolved data
            final List<SoundDTO> soundDTOs = wordEntry.sounds ?? [];

            final List<String> gayWords = [
              'gay',
              'lesbian',
              'bisexual',
              'transgender',
              'trans',
              'transsexual',
              'nonbinary',
              'non-binary',
              'genderqueer',
              'genderfluid',
              'agender',
              'asexual',
              'queer',
              'intersex',
              'pansexual',
              'demisexual',
              'pride',
              'rainbow',
            ];
            bool isGayThemeOn =
                gayWords.contains(wordEntry.word?.toLowerCase()) || wordEntry.word!.toLowerCase().startsWith('lgbt');

            final defaultExampleStyle = GoogleFonts.merriweather(
              fontSize: 11,
              color: theme.textTheme.bodyLarge?.color?.withAlpha((0.8 * 255).round()), // Using withAlpha for clarity
            );

            final highlightExampleStyle = GoogleFonts.merriweather(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodyLarge?.color?.withAlpha((0.8 * 255).round()),
            );

            final List<Widget> soundTextWidgets =
                soundDTOs
                    .where((sound) => (sound.ipa ?? '').isNotEmpty)
                    .map<Widget>(
                      (sound) => Padding(
                        // map to Widget
                        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                        child: Text(
                          sound.ipa!,
                          style: GoogleFonts.merriweather(
                            fontSize: 12.0,
                            color: isGayThemeOn ? Colors.white : Colors.black54,
                          ),
                        ),
                      ),
                    )
                    .toList();

            final List<SoundDTO> filteredSoundDTOs =
                soundDTOs.where((sound) => (sound.mp3Url ?? '').isNotEmpty).toList();

            final List<Widget> audioWidgets =
                filteredSoundDTOs.asMap().entries.map<Widget>((entry) {
                  final int index = entry.key;
                  final SoundDTO sound = entry.value;
                  return GestureDetector(
                    onTap: () {
                      // play the media if available
                      String mediaUrl = sound.mp3Url ?? '';
                      _playAudio(mediaUrl);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            HugeIcons.strokeRoundedVolumeHigh,
                            color: isGayThemeOn ? Colors.white : theme.colorScheme.secondary, // Highlight color
                            size: 18.0,
                          ),
                          Text(
                            '${index + 1}',
                            style: GoogleFonts.poppins(
                              fontSize: 8.0,
                              color: isGayThemeOn ? Colors.white54 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Word, IPA, POS card
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // word, IPA, audio
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                        child: Container(
                          decoration:
                              isGayThemeOn
                                  ? BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.red.shade800,
                                        Colors.orange.shade800,
                                        Colors.yellow.shade800,
                                        Colors.green.shade800,
                                        Colors.blue.shade800,
                                        Colors.indigo.shade800,
                                        Colors.purple.shade800,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(width: 1.2, color: Colors.transparent),
                                  )
                                  : BoxDecoration(
                                    color: theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(width: 1.2, color: theme.primaryColor),
                                  ),
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // word
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              wordEntry.word ?? '',
                                              style: GoogleFonts.merriweather(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0,
                                                color: isGayThemeOn ? Colors.white : theme.textTheme.bodyLarge?.color,
                                              ),
                                            ),
                                          ),
                                          // if (audioWidgets.isNotEmpty)
                                          //   Row(mainAxisAlignment: MainAxisAlignment.center, children: audioWidgets),
                                        ],
                                      ),
                                      if (audioWidgets.isNotEmpty)
                                        Row(mainAxisAlignment: MainAxisAlignment.center, children: audioWidgets),
                                      // const SizedBox(height: 8.0),
                                      if (soundTextWidgets.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                          child: Wrap(
                                            spacing: 8.0,
                                            runSpacing: 4.0,
                                            alignment: WrapAlignment.start,
                                            children: soundTextWidgets,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // POS title card
                      _getTitleCard(isDark, theme, 'Part of speech  (${wordEntry.meanings?.length})'),

                      // part of speech
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          clipBehavior: Clip.antiAlias,
                          alignment: Alignment.topCenter,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isPosMenuExpanded = !_isPosMenuExpanded;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                border: Border.all(width: 1.2, color: theme.primaryColor),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // selected item
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(16.0, 4.0, 8.0, 4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          Utilities.getFullPartOfSpeech(_selectedMeaning?.partOfSpeech ?? ''),
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _isPosMenuExpanded = !_isPosMenuExpanded;
                                            });
                                          },
                                          icon: Icon(
                                            _isPosMenuExpanded
                                                ? Icons.arrow_drop_up_outlined
                                                : Icons.arrow_drop_down_outlined,
                                            color: theme.colorScheme.secondary,
                                            size: 22.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  _isPosMenuExpanded
                                      ? SizedBox(height: 0.0, child: Divider(color: Colors.grey.withValues(alpha: 0.5)))
                                      : const SizedBox(),
                                  // other items
                                  _isPosMenuExpanded
                                      ? Column(
                                        children:
                                            meanings.map((meaning) {
                                              return Container(
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                  color:
                                                      meaning == _selectedMeaning
                                                          ? theme.colorScheme.primary.withValues(alpha: 0.9)
                                                          : Colors.transparent,
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      _selectedMeaning = meaning;
                                                      _isPosMenuExpanded = false;
                                                      _updateSensesSetState();
                                                      _updateTranslation();
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          Utilities.getFullPartOfSpeech(meaning.partOfSpeech ?? ''),
                                                          style: GoogleFonts.poppins(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.w600,
                                                            color:
                                                                meaning == _selectedMeaning
                                                                    ? Colors.white
                                                                    : Colors.black,
                                                          ),
                                                        ),
                                                        if (meaning == _selectedMeaning)
                                                          Padding(
                                                            padding: const EdgeInsets.only(right: 8.0),
                                                            child: Icon(
                                                              Icons.check_circle,
                                                              color: Colors.white,
                                                              size: 20,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                      )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Senses
                  Column(
                    children: [
                      // title card
                      _getTitleCard(isDark, theme, 'Glosses  (${_currentSenses!.length})'),

                      // const SizedBox(height: 8.0),
                      // glosses
                      Column(
                        children: [
                          if (_currentSenses != null && _currentSenses!.isNotEmpty)
                            ...?_currentSenses?.asMap().entries.map((wordEntry) {
                              final index = wordEntry.key;
                              final sense = wordEntry.value;

                              return Padding(
                                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(width: 1.2, color: theme.primaryColor),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // glosses
                                      ...sense.glosses!.asMap().entries.map((wordEntry) {
                                        // final index = wordEntry.key;
                                        final gloss = wordEntry.value;
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: '${index + 1}. ',
                                                        style: GoogleFonts.merriweather(
                                                          fontSize: 16,
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
                                                      'Examples:',
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
                                                                        color: theme.textTheme.bodyLarge?.color
                                                                            ?.withValues(alpha: 0.8),
                                                                      ),
                                                                    ),

                                                                    ..._highlightWordsContainingQuery(
                                                                      ' $example',
                                                                      _wordEntry?.word ?? '',
                                                                      defaultExampleStyle,
                                                                      highlightExampleStyle,
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
                                                      'Synonyms:',
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
                                                            color: Color(0xFF597445),
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
                                                      'Antonyms:',
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
                                                            color: Color(0xFFB06161),
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

                                      if (sense.related != null && sense.related!.isNotEmpty)
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
                                                      'Related:',
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
                                                    sense.related!.map((related) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                              builder: (context) => DefinitionScreen(word: related),
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          padding: const EdgeInsets.symmetric(
                                                            horizontal: 8.0,
                                                            vertical: 4.0,
                                                          ),
                                                          decoration: BoxDecoration(
                                                            color: Color(0xFFDE8F5F),
                                                            borderRadius: BorderRadius.circular(8.0),
                                                          ),
                                                          child: Text(
                                                            related,
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

                                      const SizedBox(height: 16.0),
                                    ],
                                  ),
                                ),
                              );
                            }),

                          // const SizedBox(height: 16.0),
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
                                  _getTitleCard(isDark, theme, 'Etymology'),

                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.surface,
                                        borderRadius: BorderRadius.circular(8.0),
                                        border: Border.all(width: 1.2, color: theme.primaryColor),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
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
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        ],
                      ),
                      const SizedBox(height: 16.0),

                      // translations
                      FutureBuilder<List<TranslationDTO>>(
                        future: _translationDTOFuture,
                        builder: (BuildContext innerContext, AsyncSnapshot<List<TranslationDTO>> snapshot) {
                          if (snapshot.hasData) {
                            List<TranslationDTO>? translations = snapshot.data;

                            if (translations != null && translations.isNotEmpty) {
                              // sort translations by lang
                              translations.sort((a, b) => a.lang!.compareTo(b.lang!));

                              if (_selectedTranslation == null) {
                                _initializeTranslation(translations);
                              }

                              return Column(
                                children: [
                                  // title card
                                  _getTitleCard(isDark, theme, 'Translations (${translations.length})'),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                                    child: GestureDetector(
                                      onTap: () {
                                        // open bottom sheet
                                        showModalBottomSheet(
                                          context: innerContext,
                                          builder: (BuildContext context) {
                                            return Container(
                                              constraints: BoxConstraints(
                                                maxHeight: MediaQuery.of(context).size.height * 0.7,
                                              ),
                                              decoration: BoxDecoration(
                                                color: theme.scaffoldBackgroundColor,
                                                borderRadius: const BorderRadius.vertical(
                                                  top: Radius.circular(16.0),
                                                ), // Matches shape
                                              ),
                                              clipBehavior: Clip.antiAlias,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Translation Language', // Your Title
                                                          style: GoogleFonts.poppins(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 16.0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  Expanded(
                                                    child: ListView.builder(
                                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                                      shrinkWrap: true,
                                                      itemCount: translations.length,
                                                      itemBuilder: (BuildContext innerContext2, int index) {
                                                        final translation = translations[index];
                                                        final isSelected = translation == _selectedTranslation;

                                                        return Padding(
                                                          padding: const EdgeInsets.symmetric(
                                                            horizontal: 16,
                                                            vertical: 4,
                                                          ),
                                                          child: Material(
                                                            borderRadius: BorderRadius.circular(8),
                                                            color:
                                                                isSelected
                                                                    ? theme.primaryColor.withValues(alpha: 0.9)
                                                                    : Colors.white,
                                                            child: ListTile(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                              title: Text(
                                                                "${translation.lang ?? ''} (${translation.code ?? ''}) (${translation.translationSenses?.length ?? ''})",
                                                                style: GoogleFonts.poppins(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      isSelected ? FontWeight.w600 : FontWeight.w400,
                                                                  color:
                                                                      isSelected
                                                                          ? Colors.white
                                                                          : Theme.of(
                                                                            innerContext2,
                                                                          ).textTheme.bodyLarge?.color,
                                                                ),
                                                              ),
                                                              trailing:
                                                                  isSelected
                                                                      ? const Icon(
                                                                        Icons.check_circle,
                                                                        color: Colors.white,
                                                                        size: 20,
                                                                      )
                                                                      : null,
                                                              onTap: () {
                                                                setState(() {
                                                                  _selectedTranslation = translation;
                                                                });
                                                                Navigator.of(innerContext2).pop();
                                                              },
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.surface,
                                          borderRadius: BorderRadius.circular(8.0),
                                          border: Border.all(width: 1.2, color: theme.primaryColor),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "${_selectedTranslation?.lang ?? ''} (${_selectedTranslation?.code ?? ''}) (${_selectedTranslation?.translationSenses?.length ?? ''})",
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 12,
                                                          color: theme.textTheme.bodyLarge?.color,
                                                        ),
                                                      ),
                                                      Icon(Icons.arrow_drop_down_outlined, size: 18.0),
                                                    ],
                                                  ),
                                                  Divider(color: theme.dividerColor),
                                                  if (_selectedTranslation != null &&
                                                      _selectedTranslation?.translationSenses != null &&
                                                      _selectedTranslation!.translationSenses!.isNotEmpty)
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children:
                                                          _selectedTranslation!.translationSenses!.asMap().entries.map((
                                                            translationSenseMapObject,
                                                          ) {
                                                            int index = translationSenseMapObject.key;
                                                            final translationSense = translationSenseMapObject.value;
                                                            return Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                const SizedBox(height: 4),
                                                                Text(
                                                                  "${index + 1}. ${translationSense.word ?? ''}",
                                                                  style: GoogleFonts.merriweather(
                                                                    fontSize: 14,
                                                                    color: theme.textTheme.bodyLarge?.color,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                                if (translationSense.roman != null)
                                                                  Column(
                                                                    children: [
                                                                      Text(
                                                                        translationSense.roman ?? '',
                                                                        style: GoogleFonts.merriweather(
                                                                          fontSize: 10,
                                                                          color: theme.textTheme.bodyLarge?.color,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                if (translationSense.sense != null)
                                                                  Column(
                                                                    children: [
                                                                      Text(
                                                                        translationSense.sense ?? '',
                                                                        style: GoogleFonts.merriweather(
                                                                          fontSize: 10,
                                                                          color: theme.textTheme.bodyLarge?.color,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                              ],
                                                            );
                                                          }).toList(),
                                                    ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                          }
                          return const SizedBox();
                        },
                      ),

                      const SizedBox(height: 16.0),

                      // attribute text
                      Column(
                        children: [
                          if (_wordEntry?.attribute != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                                  child: Text(
                                    // Prepend the number (index + 1) to the gloss
                                    _wordEntry?.attribute?.api?.attributionText ?? 'No attribute found',
                                    style: GoogleFonts.poppins(fontSize: 9, color: Colors.grey),
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

  List<TextSpan> _highlightWordsContainingQuery(
    String source,
    String query,
    TextStyle defaultStyle,
    TextStyle highlightStyle,
  ) {
    if (query.isEmpty || source.isEmpty) {
      return [TextSpan(text: source, style: defaultStyle)];
    }

    // Find whole words that contain the query
    // \w* matches zero or more word characters
    // This looks for a word that has:
    // - optional word characters before the query
    // - the query itself
    // - optional word characters after the query
    final String escapedQuery = RegExp.escape(query);
    final RegExp pattern = RegExp(
      r'\b\w*' + escapedQuery + r'\w*\b', // Match a word containing the query
      caseSensitive: false,
    );

    final List<TextSpan> spans = [];
    int currentPosition = 0;

    for (final Match match in pattern.allMatches(source)) {
      // Add text before the match
      if (match.start > currentPosition) {
        spans.add(TextSpan(text: source.substring(currentPosition, match.start), style: defaultStyle));
      }
      // Add the highlighted match (the whole word that contained the query)
      spans.add(TextSpan(text: source.substring(match.start, match.end), style: highlightStyle));
      currentPosition = match.end;
    }

    // Add remaining text
    if (currentPosition < source.length) {
      spans.add(TextSpan(text: source.substring(currentPosition), style: defaultStyle));
    }
    return spans.isEmpty ? [TextSpan(text: source, style: defaultStyle)] : spans;
  }

  Widget _getTitleCard(bool isDark, ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? theme.colorScheme.surface : theme.primaryColor.withValues(alpha: 0.9),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: isDark ? theme.colorScheme.onSurface : theme.colorScheme.onPrimary,
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> launchGoogleSearch(String searchTerm) async {
    if (searchTerm.isEmpty) {
      // Optional: Show a message if the search term is empty, or just do nothing
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Search term is empty.')));
      return;
    }

    // Construct the Google search URL
    // We need to properly encode the search term to handle spaces and special characters.
    final Uri googleSearchUrl = Uri.parse('https://www.google.com/search?q=${Uri.encodeComponent(searchTerm)}');

    try {
      if (await canLaunchUrl(googleSearchUrl)) {
        await launchUrl(
          googleSearchUrl,
          mode: LaunchMode.inAppBrowserView, // Opens in the default browser
        );
      } else {
        // Could not launch the URL (e.g., no browser installed, though unlikely on mobile)
        // Show an error message to the user
        if (mounted) {
          // Check if the widget is still in the tree
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Could not open Google search for "$searchTerm"')));
        }
        // print('Could not launch $googleSearchUrl');
      }
    } catch (e) {
      // Handle any other exceptions during launch
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error opening link: $e')));
      }
      // print('Error launching URL: $e');
    }
  }
}
