import 'package:flutter/material.dart';
import 'package:vocably/constants/app_constants.dart';
import 'package:vocably/widgets/home_search_bar_widget.dart';
import 'package:vocably/widgets/score_board_widget.dart';
import 'package:vocably/widgets/search_history_card_widget.dart';
import 'package:vocably/widgets/word_of_the_day_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Map<String, List<String>> historyMap = {
      'June 15': ['readable', 'resource', 'make believe', ''],
      // 'June 4': ['audacity', 'redundant', ''],
      // 'June 3': ['remove', 'gracious', ''],
    };

    return Scaffold(
      appBar: AppBar(title: Text(AppConstants.appName)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search bar
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16.0), bottomRight: Radius.circular(16.0)),

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
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 24.0),
                child: HomeSearchBarWidget(),
              ),
            ),

            // Word of the day widget
            Padding(padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0.0), child: WordOfTheDayWidget()),

            // Search history card widget
            if (historyMap.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0.0),
                child: SearchHistoryCardWidget(historyMap: historyMap),
              ),

            // Score board widget
            Padding(padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 24.0), child: ScoreBoardWidget()),
          ],
        ),
      ),
    );
  }
}
