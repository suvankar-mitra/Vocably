import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:vocably/services/dictionary_api_service.dart';
import 'package:vocably/themes/app_colors.dart';
import 'package:vocably/views/screens/home_screen/definition_screen.dart';

class HomeSearchBarWidget extends StatefulWidget {
  const HomeSearchBarWidget({super.key});

  @override
  State<HomeSearchBarWidget> createState() => _HomeSearchBarWidgetState();
}

class _HomeSearchBarWidgetState extends State<HomeSearchBarWidget> {
  late bool _isFocused = false;
  final TextEditingController _controller = TextEditingController();

  final DictionaryApiService _service = DictionaryApiService();
  List<String> _suggestions = []; // suggestions provided by the API
  Timer? _debounce; // how long we wait before sending the request
  bool _loading = false;
  // String? _error;
  late String _query;

  // Define a consistent vertical padding value
  static const double _searchBarVerticalPadding = 14.0;
  static const double _searchBarIconSize = 20.0;
  static const double _searchBarFontSize = 16.0;

  // Define a consistent height for the interactive area
  static const double _searchBarHeight = 50.0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    // cancel the previous request
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // wait for 400ms before sending the request
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      _query = _controller.text.trim();

      if (_query.isEmpty || _query.length < 2) {
        setState(() {
          _suggestions = [];
          // _error = null;
        });
        return;
      }

      // waiting for the response
      setState(() {
        _loading = true;
        // _error = null;
      });
      try {
        final results = await _service.getListWordsByFilter(_query);
        setState(() {
          _suggestions = results;
          _loading = false;
        });
      } catch (e) {
        setState(() {
          // _error = e.toString();
          _loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(width: 1.2, color: theme.primaryColor),
      ),
      clipBehavior: Clip.antiAlias,
      child:
          _isFocused
              ? Column(
                children: [
                  SizedBox(
                    height: _searchBarHeight,
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      style: GoogleFonts.poppins(fontSize: _searchBarFontSize, color: AppColors.primaryTextColor),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          HugeIcons.strokeRoundedSearch01,
                          color: theme.inputDecorationTheme.hintStyle!.color,
                          size: _searchBarIconSize,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _controller.clear();
                              // loose focus
                              FocusScope.of(context).unfocus();
                              _isFocused = false;
                            });
                          },
                          child: Icon(
                            HugeIcons.strokeRoundedCancel02,
                            color: theme.colorScheme.secondary,
                            size: _searchBarIconSize,
                          ),
                        ),
                        filled: false,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide: BorderSide.none,
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: _searchBarVerticalPadding, // Use the defined padding
                          // horizontal padding is less critical for height but good for consistency
                        ),
                      ),
                      onSubmitted: (String searchTerm) {
                        if (_controller.text.isEmpty) {
                          return;
                        }
                        final String wordToSearch = _controller.text.trim();
                        // open definition screen and pop this screen
                        Navigator.of(
                          context,
                        ).push(MaterialPageRoute(builder: (context) => DefinitionScreen(word: wordToSearch)));
                      },
                    ),
                  ),

                  if (_loading)
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0, left: 12.0),
                      child: Row(
                        children: [
                          // Expanded(child: Divider(thickness: 1)),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              'Search Suggestions',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (_loading)
                    Center(
                      child: SizedBox(
                        height: 70,
                        width: 70,
                        child: Lottie.asset('assets/lottie/lottie_wait_animation_blue.json'),
                      ),
                    ),

                  if (!_loading && _suggestions.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Column(
                        children: List.generate(_suggestions.length, (index) {
                          final suggestion = _suggestions[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (index == 0)
                                Padding(
                                  padding: const EdgeInsets.only(right: 12.0, left: 12.0),
                                  child: Row(
                                    children: [
                                      // Expanded(child: Divider(thickness: 1)),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          'Search Suggestions',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          thickness: 1,
                                          color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              InkWell(
                                onTap: () {
                                  // open definition screen
                                  Navigator.of(
                                    context,
                                  ).push(MaterialPageRoute(builder: (context) => DefinitionScreen(word: suggestion)));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            text: suggestion,
                                            style: GoogleFonts.poppins(
                                              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.9),
                                            ),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Icon(HugeIcons.strokeRoundedArrowUpRight02),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                ],
              )
              : SizedBox(
                height: _searchBarHeight,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isFocused = true;
                    });
                  },
                  borderRadius: BorderRadius.circular(16.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          HugeIcons.strokeRoundedSearch01,
                          color: theme.inputDecorationTheme.hintStyle!.color,
                          size: _searchBarIconSize,
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: IgnorePointer(
                            ignoring: true,
                            child: AnimatedTextKit(
                              animatedTexts: [
                                TyperAnimatedText(
                                  'Search a word or phrase',
                                  textStyle: GoogleFonts.poppins(
                                    fontSize: _searchBarFontSize - 2,
                                    color: theme.inputDecorationTheme.hintStyle!.color,
                                  ),
                                  speed: const Duration(milliseconds: 100),
                                ),
                              ],
                              repeatForever: true,
                              isRepeatingAnimation: true,
                              pause: const Duration(milliseconds: 2000),
                              displayFullTextOnTap: true,
                              stopPauseOnTap: true,
                            ),
                          ),
                        ),
                        // Icon(HugeIcons.strokeRoundedBook02, color: theme.colorScheme.secondary),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}
