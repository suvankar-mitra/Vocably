import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vocably/models/word_entry_dto.dart';
import 'package:vocably/utils/utilities.dart';

class PartOfSpeechSelector extends StatelessWidget {
  final List<MeaningDTO> meanings;
  final MeaningDTO? selectedMeaning;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Function(MeaningDTO) onSelect;

  const PartOfSpeechSelector({
    super.key,
    required this.meanings,
    required this.selectedMeaning,
    required this.isExpanded,
    required this.onToggle,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.topCenter,
        child: GestureDetector(
          onTap: onToggle,
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 4.0, 8.0, 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Utilities.getFullPartOfSpeech(selectedMeaning?.partOfSpeech ?? ''),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: onToggle,
                        icon: Icon(
                          isExpanded
                              ? Icons.arrow_drop_up_outlined
                              : Icons.arrow_drop_down_outlined,
                          color: theme.colorScheme.secondary,
                          size: 22.0,
                        ),
                      ),
                    ],
                  ),
                ),
                isExpanded
                    ? SizedBox(height: 0.0, child: Divider(color: Colors.grey.withAlpha(128)))
                    : const SizedBox(),
                isExpanded
                    ? Column(
                        children: meanings.map((meaning) {
                          return Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              color: meaning == selectedMeaning
                                  ? theme.colorScheme.primary.withAlpha(230)
                                  : Colors.transparent,
                            ),
                            child: InkWell(
                              onTap: () => onSelect(meaning),
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
                                        color: meaning == selectedMeaning ? Colors.white : Colors.black,
                                      ),
                                    ),
                                    if (meaning == selectedMeaning)
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
    );
  }
}