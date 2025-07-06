import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocably/models/translation_dto.dart';

class TranslationsWidget extends StatelessWidget {
  final Future<List<TranslationDTO>> translationFuture;
  final TranslationDTO? selectedTranslation;
  final ValueChanged<TranslationDTO> onSelectTranslation;
  final ThemeData theme;
  final bool isDark;
  final Widget Function(bool isDark, ThemeData theme, String title) getTitleCard;

  const TranslationsWidget({
    super.key,
    required this.translationFuture,
    required this.selectedTranslation,
    required this.onSelectTranslation,
    required this.theme,
    required this.isDark,
    required this.getTitleCard,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TranslationDTO>>(
      future: translationFuture,
      builder: (BuildContext innerContext, AsyncSnapshot<List<TranslationDTO>> snapshot) {
        if (snapshot.hasData) {
          List<TranslationDTO>? translations = snapshot.data;

          if (translations != null && translations.isNotEmpty) {
            translations.sort((a, b) => a.lang!.compareTo(b.lang!));

            return Column(
              children: [
                getTitleCard(isDark, theme, 'Translations (${translations.length})'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                  child: GestureDetector(
                    onTap: () {
                      _showModal(innerContext, translations);
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
                        child:
                            (selectedTranslation == null)
                                ? Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Select a translation',
                                      style: GoogleFonts.poppins(fontSize: 12, color: theme.textTheme.bodyLarge?.color),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.arrow_drop_down_outlined, size: 26.0),
                                      onPressed: () {
                                        _showModal(innerContext, translations);
                                      },
                                    ),
                                  ],
                                )
                                : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${selectedTranslation?.lang ?? ''} (${selectedTranslation?.code ?? ''}) (${selectedTranslation?.translationSenses?.length ?? ''})",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: theme.textTheme.bodyLarge?.color,
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.arrow_drop_down_outlined, size: 26.0),
                                          onPressed: () {
                                            _showModal(innerContext, translations);
                                          },
                                        ),
                                      ],
                                    ),
                                    Divider(color: theme.dividerColor),
                                    if (selectedTranslation != null &&
                                        selectedTranslation?.translationSenses != null &&
                                        selectedTranslation!.translationSenses!.isNotEmpty)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:
                                            selectedTranslation!.translationSenses!.asMap().entries.map((entry) {
                                              int index = entry.key;
                                              final translationSense = entry.value;
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                    Text(
                                                      translationSense.roman ?? '',
                                                      style: GoogleFonts.merriweather(
                                                        fontSize: 10,
                                                        color: theme.textTheme.bodyLarge?.color,
                                                      ),
                                                    ),
                                                  if (translationSense.sense != null)
                                                    Text(
                                                      translationSense.sense ?? '',
                                                      style: GoogleFonts.merriweather(
                                                        fontSize: 10,
                                                        color: theme.textTheme.bodyLarge?.color,
                                                      ),
                                                    ),
                                                ],
                                              );
                                            }).toList(),
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
    );
  }

  Future _showModal(BuildContext innerContext, List<TranslationDTO> translations) {
    return showModalBottomSheet(
      context: innerContext,
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
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
                      'Translation Language',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16.0),
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
                    final isSelected = translation == selectedTranslation;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Material(
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected ? theme.primaryColor.withAlpha(230) : Colors.white,
                        child: ListTile(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          title: Text(
                            "${translation.lang ?? ''} (${translation.code ?? ''}) (${translation.translationSenses?.length ?? ''})",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected ? Colors.white : Theme.of(innerContext2).textTheme.bodyLarge?.color,
                            ),
                          ),
                          trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.white, size: 20) : null,
                          onTap: () {
                            onSelectTranslation(translation);
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
  }
}
