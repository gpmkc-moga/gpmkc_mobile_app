import 'package:flutter/material.dart';
import 'package:gpmkc_mobile_app/pages/247_radio.dart';

import '../constants.dart';
import '../utils.dart';
import 'about_us.dart';
import 'contact_us.dart';

class PageHome extends StatelessWidget {
  const PageHome({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyHome(),
    );
  }
}

class BodyHome extends StatelessWidget {
  const BodyHome({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            child: FractionallySizedBox(
              widthFactor: 0.40,
              child: Image.asset(
                kAssetPathGPMKCGoldenLogo,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                MenuItem(
                  imagePath: kAssetPathDailyHukum,
                  titleText: kLabelDailyHukum,
                  tapCallback: () {
                    // openPage(context, PageDailyHukumnama());
                    Utils.launchCustomTab(
                        context, kWaheguruLiveTodayHukumnamaLink);
                  },
                ),
                MenuItem(
                  imagePath: kAssetPathWatchLive,
                  titleText: kLabelWatchLive,
                  tapCallback: () {
                    Utils.launchUniversalLinkIos(kWaheguruLiveYTLiveLink);
                  },
                ),
                MenuItem(
                  imagePath: kAssetPath247Radio,
                  titleText: kLabel247Radio,
                  tapCallback: () {
                    openPage(context, Page247Radio());
                  },
                ),
                MenuItem(
                  imagePath: kAssetPathStore,
                  titleText: kLabelStore,
                  tapCallback: () {
                    Utils.launchCustomTab(context, kWaheguruLiveStoreLink);
                  },
                ),
                MenuItem(
                  imagePath: kAssetPathUpcomingEvents,
                  titleText: kLabelUpcomingEvents,
                  tapCallback: () {
                    Utils.launchCustomTab(context, kWaheguruLiveProgramsLink);
                  },
                ),
                MenuItem(
                  imagePath: kAssetPathGurmatClass,
                  titleText: kLabelGurmatClass,
                  tapCallback: () {
                    Utils.launchUniversalLinkIos(kGurmatClassAppLink);
                  },
                ),
                MenuItem(
                  imagePath: kAssetPathAboutUs,
                  titleText: kLabelAboutUs,
                  tapCallback: () {
                    openPage(context, PageAboutUs());
                  },
                ),
                MenuItem(
                  imagePath: kAssetPathContactUs,
                  titleText: kLabelContactUs,
                  tapCallback: () {
                    openPage(context, PageContactUs());
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void openPage(BuildContext context, Widget pageWidget) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => pageWidget),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem(
      {Key key,
      @required this.imagePath,
      @required this.titleText,
      @required this.tapCallback})
      : super(key: key);

  final String imagePath, titleText;
  final GestureTapCallback tapCallback;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15.0),
      child: InkWell(
        onTap: tapCallback,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FractionallySizedBox(
              widthFactor: 0.4,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: FractionallySizedBox(
                widthFactor: 0.6,
                child: Text(
                  titleText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}