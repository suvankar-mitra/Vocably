import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:vocably/services/dictionary_api_service.dart';

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
  bool _loading = false;
  String? _error;

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      final query = _controller.text.trim();
      if (query.isEmpty) {
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
        final results = await service.getListWordsByFilter(query);
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 36, 0, 8),
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(16.0)),
                  child: Row(
                    children: [
                      IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
                      Expanded(
                        child: Hero(
                          tag: 'searchBar',
                          child: Material(
                            color: Colors.transparent,
                            child: TextField(
                              controller: _controller,
                              autofocus: true,
                              style: GoogleFonts.roboto(
                                fontSize: 16.0,
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                              ),
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                hintText: 'Search a word or phrase',
                                hintStyle: GoogleFonts.roboto(
                                  fontSize: 16.0,
                                  color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
                                ),
                                suffixIcon: Icon(HugeIcons.strokeRoundedBook02, color: Colors.orange),
                                filled: false,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                              onSubmitted: (String searchTerm) {},
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_loading)
                const Center(child: CircularProgressIndicator())
              else if (_error != null)
                Text('Error: $_error', style: const TextStyle(color: Colors.red))
              else if (_suggestions.isEmpty && _controller.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(HugeIcons.strokeRoundedWorry, size: 24.0, color: Colors.grey),
                        const SizedBox(width: 8.0),
                        Text('No suggestions found...', style: GoogleFonts.roboto(fontSize: 16.0, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),

              // generate List of suggestions
              if (_suggestions.isNotEmpty)
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: List.generate(_suggestions.length, (index) {
                      final suggestion = _suggestions[index];
                      return Column(
                        children: [
                          ListTile(
                            title: Text(suggestion),
                            trailing: Icon(HugeIcons.strokeRoundedArrowUpRight01),
                            onTap: () {
                              // Handle suggestion tap
                            },
                          ),
                          if (index != _suggestions.length - 1)
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: Divider(height: 0)),
                        ],
                      );
                    }),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
