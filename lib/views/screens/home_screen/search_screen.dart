import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lottie/lottie.dart';
import 'package:vocably/services/dictionary_api_service.dart';
import 'package:vocably/themes/app_colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final DictionaryApiService service = DictionaryApiService();
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  List<String> _suggestions = [];
  final List<String> _recents = [];
  bool _loading = false;
  String? _error;
  late String _query;

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      _query = _controller.text.trim();
      if (_query.isEmpty) {
        setState(() {
          _suggestions = [];
          _error = null;
        });
        return;
      }
      if (_query.length < 2) {
        setState(() {
          _suggestions = [];
          _error = null;
        });
        return;
      }
      setState(() {
        _loading = true;
        _error = null;
      });
      try {
        final results = await service.getListWordsByFilter(_query);
        setState(() {
          _suggestions = results;
          _loading = false;
        });
      } catch (e) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);

    //dummy
    _recents.add('read');
    _recents.add('current');
    _recents.add('example');
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          if (_controller.text.isEmpty)
            Align(
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: 0.6,
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: Lottie.asset('assets/lottie/lottie_book_flying_bw.json'),
                ),
              ),
            ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 64, 24, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.searchBarBackground,
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.2),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // search bar
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                HugeIcons.strokeRoundedArrowLeft02,
                                color: AppColors.secondaryAccentColor,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            Expanded(
                              child: Hero(
                                tag: 'searchBar',
                                child: Material(
                                  color: Colors.transparent,
                                  child: TextField(
                                    controller: _controller,
                                    // autofocus: true,
                                    style: GoogleFonts.poppins(fontSize: 16.0, color: AppColors.primaryTextColor),
                                    textInputAction: TextInputAction.search,
                                    decoration: InputDecoration(
                                      hintText: 'Search a word or phrase',
                                      hintStyle: GoogleFonts.poppins(
                                        fontSize: 14.0,
                                        // color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
                                        color: AppColors.searchBarHintColor,
                                      ),
                                      suffixIcon:
                                          _controller.text.isNotEmpty
                                              ? GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _controller.clear();
                                                  });
                                                },
                                                child: Icon(
                                                  HugeIcons.strokeRoundedCancel01,
                                                  color: AppColors.secondaryAccentColor,
                                                ),
                                              )
                                              : Icon(
                                                HugeIcons.strokeRoundedBook02,
                                                color: AppColors.searchBarHintColor,
                                              ),
                                      filled: false,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16.0),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    onSubmitted: (String searchTerm) {},
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // generate List of suggestions
                        if (_suggestions.isNotEmpty)
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
                                                  color: AppColors.secondaryTextColor.withValues(alpha: 0.5),
                                                ),
                                              ),
                                            ),
                                            Expanded(child: Divider(thickness: 1)),
                                          ],
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                HugeIcons.strokeRoundedSearch01,
                                                color: AppColors.secondaryTextColor.withValues(alpha: 0.5),
                                                size: 14.0,
                                              ),
                                              const SizedBox(width: 12.0),
                                              RichText(
                                                text: TextSpan(
                                                  text: suggestion,
                                                  style: GoogleFonts.poppins(color: AppColors.primaryTextColor),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            HugeIcons.strokeRoundedArrowUpRight01,
                                            color: AppColors.secondaryAccentColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (index != _suggestions.length - 1)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        child: Divider(height: 0),
                                      ),
                                  ],
                                );
                              }),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (_loading)
                  Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Lottie.asset('assets/lottie/lottie_wait_animation_blue.json'),
                    ),
                  )
                else if (_error != null)
                  // Text('Error: $_error', style: const TextStyle(color: Colors.red))
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text('Error: $_error', style: GoogleFonts.poppins(color: Colors.red)),
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: Lottie.asset('assets/lottie/lottie_nothing_found_blue.json'),
                          ),
                        ],
                      ),
                    ),
                  )
                // suggestions empty
                else if (_suggestions.isEmpty && _controller.text.isNotEmpty && _controller.text.length >= 2)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'Oops! No results found for "${_controller.text}"',
                            style: GoogleFonts.poppins(color: AppColors.secondaryTextColor),
                          ),
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: Lottie.asset('assets/lottie/lottie_nothing_found_blue.json'),
                          ),
                        ],
                      ),
                    ),
                  ),

                // generate List of recent searches
                if (_recents.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 48.0, 24.0, 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent searches',
                              style: GoogleFonts.poppins(
                                color: AppColors.primaryTextColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: RichText(
                                text: TextSpan(
                                  text: 'Clear',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: AppColors.secondaryAccentColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.searchBarBackground,
                            borderRadius: BorderRadius.all(Radius.circular(16.0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.2),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),

                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: List.generate(_recents.length, (index) {
                              final recent = _recents[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              HugeIcons.strokeRoundedClock04,
                                              color: AppColors.secondaryTextColor.withValues(alpha: 0.5),
                                              size: 14.0,
                                            ),
                                            const SizedBox(width: 12.0),
                                            RichText(
                                              text: TextSpan(
                                                text: recent,
                                                style: GoogleFonts.poppins(color: AppColors.primaryTextColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Icon(
                                          HugeIcons.strokeRoundedArrowUpRight01,
                                          color: AppColors.secondaryAccentColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (index != _recents.length - 1)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: Divider(height: 0),
                                    ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
