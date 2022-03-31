// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:veggieseasons/data/app_state.dart';
import 'package:veggieseasons/data/preferences.dart';
import 'package:veggieseasons/data/veggie.dart';
import 'package:veggieseasons/styles.dart';
import 'package:veggieseasons/widgets/veggie_card.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({this.restorationId, Key? key}) : super(key: key);

  final String? restorationId;

  Widget _generateVeggieRow(Veggie veggie, Preferences prefs,
      [bool inSeason = true]) {
    return Padding(
      // Creates insets with only the given values non-zero
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
      child: FutureBuilder<Set<VeggieCategory>>(
          future: prefs.preferredCategories,
          builder: (context, snapshot) {
            final data = snapshot.data ?? <VeggieCategory>{}; // snapshot.data不为空则返回，否则返回后者
            return VeggieCard(veggie, inSeason, data.contains(veggie.category));
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabView(
      restorationScopeId: restorationId,
      builder: (context) {
        var dateString = DateFormat('MMMM y').format(DateTime.now());
        print("dateString: ${dateString}");
        final appState = Provider.of<AppState>(context);
        final prefs = Provider.of<Preferences>(context);
        final themeData = CupertinoTheme.of(context);
        final valueTest = Provider.of<int>(context);
        print("valueTest: ${valueTest}");
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
              statusBarBrightness: MediaQuery.platformBrightnessOf(context)),
          child: SafeArea(
            bottom: false,
            child: ListView.builder(
              restorationId: 'list',
              itemCount: appState.allVeggies.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    // Creates insets from offsets from the left, top, right, and bottom
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(dateString.toUpperCase(),
                            style: Styles.minorText(themeData)),
                        Text('In season today',
                            style: Styles.headlineText(themeData)),
                      ],
                    ),
                  );
                } else if (index <= appState.availableVeggies.length) {
                  return _generateVeggieRow(
                    appState.availableVeggies[index - 1],
                    prefs,
                  );
                } else if (index <= appState.availableVeggies.length + 1) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: Text('Not in season',
                        style: Styles.headlineText(themeData)),
                  );
                } else {
                  var relativeIndex =
                      index - (appState.availableVeggies.length + 2);
                  return _generateVeggieRow(
                      appState.unavailableVeggies[relativeIndex], prefs, false);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
