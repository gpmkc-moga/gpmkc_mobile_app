// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

import 'constants.dart';
import 'pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final darkThemeData = ThemeData.dark();

    return MaterialApp(
      theme: darkThemeData.copyWith(
        scaffoldBackgroundColor: Colors.black,
        accentColor: kAccentColorYellow,
        textSelectionTheme: darkThemeData.textSelectionTheme.copyWith(
          cursorColor: kAccentColorYellow,
          selectionColor: kAccentColorYellow,
          selectionHandleColor: kAccentColorYellow,
        ),
        // useTextSelectionTheme: true,
        splashColor: kAccentColorYellow.withOpacity(0.32),
        cardTheme: darkThemeData.cardTheme.copyWith(
          color: kCardColorGray,
          shape: RoundedRectangleBorder(),
        ),
        appBarTheme: darkThemeData.appBarTheme.copyWith(
          color: Colors.transparent,
          iconTheme: ThemeData().primaryIconTheme.copyWith(opacity: 0.4),
          actionsIconTheme: ThemeData().primaryIconTheme.copyWith(opacity: 0.4),
        ),
        buttonTheme:
            darkThemeData.buttonTheme.copyWith(splashColor: kAccentColorYellow),
        textTheme:
            GoogleFonts.ptSansTextTheme(darkThemeData.textTheme).copyWith(
          headline5: darkThemeData.textTheme.headline5.copyWith(
            fontWeight: FontWeight.w500,
          ),
          subtitle2: GoogleFonts.quicksand(
            textStyle: darkThemeData.textTheme.subtitle2.copyWith(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          caption: darkThemeData.textTheme.headline5.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        inputDecorationTheme: darkThemeData.inputDecorationTheme.copyWith(
          fillColor: kCardColorGray,
          filled: true,
          border: InputBorder.none,
        ),
      ),
      home: AudioServiceWidget(
        child: PageHome(),
      ),
    );
  }
}
