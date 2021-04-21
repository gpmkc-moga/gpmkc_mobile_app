import 'package:flutter/material.dart';

import '../constants.dart';

class PageAboutUs extends StatelessWidget {
  const PageAboutUs({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.fromLTRB(48.0, 0, 48.0, 24.0),
        child: AboutUsListWithToggle(),
      ),
    );
  }
}

class AboutUsListWithToggle extends StatefulWidget {
  const AboutUsListWithToggle({
    Key key,
  }) : super(key: key);

  @override
  _AboutUsListWithToggleState createState() => _AboutUsListWithToggleState();
}

class _AboutUsListWithToggleState extends State<AboutUsListWithToggle> {
  bool _showAboutText = false;

  @override
  Widget build(BuildContext context) {
    var contextTheme = Theme.of(context);

    return Scrollbar(
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            kLabelOurMission,
            textAlign: TextAlign.center,
            style: contextTheme.textTheme.headline5
                .copyWith(color: contextTheme.accentColor),
          ),
          SizedBox(
            height: 12.0,
          ),
          Text(
            kLabelOurMissionText,
            textAlign: TextAlign.center,
            style: contextTheme.textTheme.bodyText2,
          ),
          AboutUsDivider(),
          AboutUsPhoto(
            imagePath: 'images/bhai_sahib.png',
          ),
          Text(
            kLabelBhaiSahibName,
            textAlign: TextAlign.center,
            style: contextTheme.textTheme.headline6
                .copyWith(color: contextTheme.accentColor),
          ),
          Text(
            kLabelBhaiSahibTitle,
            textAlign: TextAlign.center,
            style: contextTheme.textTheme.bodyText2
                .copyWith(color: kTitleTextColor),
          ),
          Visibility(
            visible: _showAboutText,
            child: Text(
              kLabelBhaiSahibAboutText,
              textAlign: TextAlign.center,
              style: contextTheme.textTheme.bodyText2,
            ),
          ),
          AboutUsDivider(),
          AboutUsPhoto(
            imagePath: 'images/veerji.png',
          ),
          Text(
            kLabelVeerjiName,
            textAlign: TextAlign.center,
            style: contextTheme.textTheme.headline6
                .copyWith(color: contextTheme.accentColor),
          ),
          Text(
            kLabelVeerjiTitle,
            textAlign: TextAlign.center,
            style: contextTheme.textTheme.bodyText2
                .copyWith(color: kTitleTextColor),
          ),
          Visibility(
            visible: _showAboutText,
            child: Text(
              kLabelVeerjiAboutText,
              textAlign: TextAlign.center,
              style: contextTheme.textTheme.bodyText2,
            ),
          ),
          SizedBox(
            height: 6.0,
          ),
          FractionallySizedBox(
            widthFactor: 0.30,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _showAboutText = !_showAboutText;
                });
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF333333),
                textStyle: contextTheme.textTheme.bodyText2,
              ),
              child: Text(
                _showAboutText ? kLabelLess : kLabelMore,
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AboutUsPhoto extends StatelessWidget {
  const AboutUsPhoto({
    Key key,
    @required this.imagePath,
  }) : super(key: key);

  final String imagePath;
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.42,
      child: ClipOval(
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class AboutUsDivider extends StatelessWidget {
  const AboutUsDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 12.0,
        ),
        Divider(
          thickness: 2.0,
          color: kAboutPageDividerColor,
          indent: 16.0,
          endIndent: 16.0,
        ),
        SizedBox(
          height: 8.0,
        ),
      ],
    );
  }
}
