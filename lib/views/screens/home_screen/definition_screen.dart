import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:vocably/models/translation_dto.dart';
import 'package:vocably/models/word_entry_dto.dart';
import 'package:vocably/services/dictionary_api_service.dart';
import 'package:vocably/utils/utilities.dart';
import 'package:vocably/views/screens/home_screen/home_screen_widgets/etymology_card.dart';

import 'home_screen_widgets/part_of_speech_selector.dart';
import 'home_screen_widgets/senses_list.dart';
import 'home_screen_widgets/title_card.dart';
import 'home_screen_widgets/translations_widget.dart';
import 'home_screen_widgets/word_header_card.dart';

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

  WordEntryDTO? _wordEntry;
  MeaningDTO? _selectedMeaning;
  List<SenseDTO>? _currentSenses;
  TranslationDTO? _selectedTranslation;

  @override
  void initState() {
    super.initState();
    _wordDTOFuture = _service.getDefinition(widget.word);
    _audioPlayer = AudioPlayer();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _initializeMeaningAndSenses(WordEntryDTO wordEntry) {
    _wordEntry = wordEntry;
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
      _selectedMeaning = MeaningDTO();
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

  void _updateTranslation() {
    _translationDTOFuture = _service.getTranslations(widget.word, _selectedMeaning?.partOfSpeech ?? '');
    _selectedTranslation = null;
  }

  void _retry() {
    setState(() {
      _wordDTOFuture = _service.getDefinition(widget.word);
    });
  }

  Future<void> _playAudio(String mediaUrl) async {
    if (mediaUrl.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No audio URL available.')));
        return;
      }
    }
    try {
      await _audioPlayer.play(UrlSource(mediaUrl));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error playing audio: ${e.toString()}')));
      }
    }
  }

  String _toRoman(int number) => Utilities.toRoman(number);

  List<TextSpan> _highlightWordsContainingQuery(
    String source,
    String query,
    TextStyle defaultStyle,
    TextStyle highlightStyle,
  ) => Utilities.highlightWordsContainingQuery(source, query, defaultStyle, highlightStyle);

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
              onPressed: () => Navigator.of(context).pop(),
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
            return Center(
              child: SizedBox(
                height: 150,
                width: 150,
                child: Lottie.asset('assets/lottie/lottie_wait_animation_blue.json'),
              ),
            );
          } else if (snapshot.hasError) {
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
                      color: isDark ? Colors.black.withAlpha(64) : Colors.grey.withAlpha(51),
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
            final WordEntryDTO wordEntry = snapshot.data!;

            if (_wordEntry == null) {
              _initializeMeaningAndSenses(wordEntry);
            }

            final List<MeaningDTO> meanings = wordEntry.meanings ?? [];
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
              color: theme.textTheme.bodyLarge?.color?.withAlpha((0.8 * 255).round()),
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
                    onTap: () => _playAudio(sound.mp3Url ?? ''),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            HugeIcons.strokeRoundedVolumeHigh,
                            color: isGayThemeOn ? Colors.white : theme.colorScheme.secondary,
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
                  // Word, IPA, audio
                  WordHeaderCard(
                    wordEntry: wordEntry,
                    isGayThemeOn: isGayThemeOn,
                    audioWidgets: audioWidgets,
                    soundTextWidgets: soundTextWidgets,
                  ),

                  // POS title card
                  TitleCard(isDark: isDark, theme: theme, title: 'Part of speech  (${meanings.length})'),

                  // Part of speech selector
                  PartOfSpeechSelector(
                    meanings: meanings,
                    selectedMeaning: _selectedMeaning,
                    isExpanded: _isPosMenuExpanded,
                    onToggle: () => setState(() => _isPosMenuExpanded = !_isPosMenuExpanded),
                    onSelect: (meaning) {
                      setState(() {
                        _selectedMeaning = meaning;
                        _isPosMenuExpanded = false;
                        _updateSenses();
                        _updateTranslation();
                      });
                    },
                  ),

                  // Senses
                  TitleCard(isDark: isDark, theme: theme, title: 'Glosses  (${_currentSenses?.length ?? 0})'),
                  SensesList(
                    senses: _currentSenses ?? [],
                    wordEntry: wordEntry,
                    toRoman: _toRoman,
                    highlightWordsContainingQuery: _highlightWordsContainingQuery,
                    defaultExampleStyle: defaultExampleStyle,
                    highlightExampleStyle: highlightExampleStyle,
                  ),

                  // Etymology
                  if (_selectedMeaning != null &&
                      _selectedMeaning?.etymologyText != null &&
                      _selectedMeaning!.etymologyText!.isNotEmpty)
                    EtymologyCard(isDark: isDark, theme: theme, selectedMeaning: _selectedMeaning!),

                  // Translations
                  const SizedBox(height: 16.0),
                  TranslationsWidget(
                    translationFuture: _translationDTOFuture,
                    selectedTranslation: _selectedTranslation,
                    onSelectTranslation: (translation) {
                      setState(() {
                        _selectedTranslation = translation;
                      });
                    },
                    theme: theme,
                    isDark: isDark,
                    getTitleCard: (isDark, theme, title) => TitleCard(isDark: isDark, theme: theme, title: title),
                  ),

                  // Attribute text
                  if (_wordEntry?.attribute != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                      child: Text(
                        _wordEntry?.attribute?.api?.attributionText ?? 'No attribute found',
                        style: GoogleFonts.poppins(fontSize: 9, color: Colors.grey),
                      ),
                    ),
                  const SizedBox(height: 16.0),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Something went wrong.'));
          }
        },
      ),
    );
  }
}
