import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart'
    as FlutterCustomTabs;

import 'package:url_launcher/url_launcher.dart';

import 'constants.dart';

class Utils {
  static Future<void> launchUniversalLinkIos(String url) async {
    if (await canLaunch(url)) {
      final bool nativeAppLaunchSucceeded = await launch(
        url,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(
          url,
          forceSafariVC: true,
        );
      }
    }
  }

  static Future<void> launchCustomTab(BuildContext context, String url) async {
    try {
      await FlutterCustomTabs.launch(
        url,
        option: FlutterCustomTabs.CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: FlutterCustomTabs.CustomTabsAnimation.slideIn(),
          extraCustomTabs: <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }

  static String getMailTextFooter({@required String appVersion}) {
    String textContent = "$kMailFooterStarter\n";
    textContent += "$kLabelPlatform\t";
    textContent += Platform.isIOS ? kLabelIOS : kLabelAndroid;
    textContent += "\n$kLabelAppVersion\t$appVersion";
    return textContent;
  }
}
