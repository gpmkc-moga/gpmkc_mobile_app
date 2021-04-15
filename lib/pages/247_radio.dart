import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:gpmkc_mobile_app/audio/app_audio_player_task.dart';
import 'package:logger/logger.dart';

import '../constants.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

class Page247Radio extends StatelessWidget {
  const Page247Radio({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var contextTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(kLabelGurdwaraNameRadio,
                textAlign: TextAlign.center,
                style: contextTheme.textTheme.headline5.copyWith(
                  fontWeight: FontWeight.normal,
                )),
            SizedBox(
              height: 2.0,
            ),
            Text(
              kLabelRadio,
              textAlign: TextAlign.center,
              style: contextTheme.textTheme.headline4.copyWith(
                fontWeight: FontWeight.w700,
                color: kRadioTitleTextColor,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              kLabel247,
              textAlign: TextAlign.center,
              style: contextTheme.textTheme.headline4.copyWith(
                fontWeight: FontWeight.w700,
                color: kAccentColorYellow,
              ),
            ),
            SizedBox(
              height: 32.0,
            ),
            Flexible(
              flex: 24,
              child: RadioPlayerControlsWidget(),
            ),
            SizedBox(
              height: 24.0,
            ),
            Flexible(
              flex: 24,
              child: Image.asset(
                'images/radio_wave.png',
                fit: BoxFit.fitHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

MediaItem radioMediaItem = MediaItem(
    id: Audio_Radio_Link,
    album: Audio_Album_Name,
    title: Audio_Radio_Title,
    extras: {kKeyAudioType: AppAudioType.RADIO.toString()});

class RadioPlayerControlsWidget extends StatelessWidget {
  const RadioPlayerControlsWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      stream: AudioService.playbackStateStream,
      builder: (context, snapshot) {
        bool isRadio = (AudioService.currentMediaItem?.extras != null &&
                AudioService.currentMediaItem?.extras[kKeyAudioType] ==
                    AppAudioType.RADIO.toString()) ??
            false;

        final playing = snapshot.data?.playing ?? false;
        final buffering =
            snapshot.data?.processingState == AudioProcessingState.buffering ??
                false;
        if (isRadio) {
          if (playing) {
            return RadioPlayPauseButton(
              iconData: Icons.pause,
              onPressed: pause,
            );
          } else if (buffering) {
            return RadioPlayPauseButton(
              iconData: Icons.play_arrow,
              onPressed: () {},
              loading: true,
            );
          } else {
            return RadioPlayPauseButton(
              iconData: Icons.play_arrow,
              onPressed: () {
                play(context);
              },
            );
          }
        } else {
          //Hukumnama is in the current media item
          return RadioPlayPauseButton(
            iconData: Icons.play_arrow,
            onPressed: () {
              play(context);
            },
          );
        }
      },
    );
  }

// AlwaysStoppedAnimation
  play(BuildContext context) async {
    if (AudioService.running) {
      await AudioService.playMediaItem(radioMediaItem);
    } else {
      await AudioService.start(
        backgroundTaskEntrypoint: _backgroundTaskEntrypoint,
        params: {
          kKeyMediaItemMap: {
            kKeyMediaItemId: radioMediaItem.id,
            kKeyMediaItemAlbum: radioMediaItem.album,
            kKeyMediaItemTitle: radioMediaItem.title,
            kKeyAudioType: radioMediaItem.extras[kKeyAudioType]
          }
        },
        androidNotificationChannelName: kChannelNameAudio,
        androidNotificationChannelDescription: kChannelDescriptionAudio,
        androidNotificationColor: Theme.of(context).primaryColor.value,
        androidNotificationIcon: 'drawable/ic_notif_icon',
        androidShowNotificationBadge: true,
      );
    }
  }

  pause() => AudioService.pause();
}

_backgroundTaskEntrypoint() {
  AudioServiceBackground.run(() => AppAudioPlayerTask());
}

class RadioPlayPauseButton extends StatelessWidget {
  const RadioPlayPauseButton({
    @required this.iconData,
    @required this.onPressed,
    Key key,
    this.loading = false,
  }) : super(key: key);

  final IconData iconData;
  final Function() onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.all(12.0),
        child: Container(
          alignment: Alignment.center,
          child: ClipOval(
            child: Material(
              color: kRadioTitleTextColor,
              child: InkWell(
                onTap: onPressed,
                splashColor: kAccentColorYellow.withOpacity(0.5),
                child: LayoutBuilder(
                  builder: (context, constraint) {
                    return loading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Icon(
                            iconData,
                            size: constraint.biggest.height - 16.0,
                          );
                  },
                ),
              ),
            ),
          ),
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: kAccentColorYellow,
      ),
    );
  }
}
