import 'package:flutter/material.dart';

class SearchHistoryItem extends StatelessWidget {
  const SearchHistoryItem({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.date,
    required this.words,
  });

  final bool isFirst;
  final bool isLast;
  final String date;
  final List<String> words;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Dot
        Container(width: 12, height: 12, decoration: BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle)),
        // Line
        if (!isLast) Container(width: 2, height: 50, color: Colors.deepPurple.withValues(alpha: .5)),
        SizedBox(width: 12),
        // Words and Date
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...words.map(
                (word) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(word, style: TextStyle(fontSize: 16)),
                ),
              ),
              Text(date, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
