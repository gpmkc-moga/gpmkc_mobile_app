import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gpmkc_mobile_app/audio/app_audio_player_task.dart';
import 'package:photo_view/photo_view.dart';
import 'package:logger/logger.dart';
import 'package:audio_service/audio_service.dart';
import 'package:rxdart/rxdart.dart';

import '../constants.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

const String Hukumnama_img_tag = "Hukumnama_img_tag";

class PageDailyHukumnama extends StatelessWidget {
  const PageDailyHukumnama({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.all(4.0),
        alignment: Alignment.center,
        child: Column(
          children: [
            Expanded(
              flex: 13,
              child: NetworkImageWithLoading(
                imageUrl: sample_hukumnama_photo_link,
              ),
            ),
            Expanded(
              flex: 3,
              child: AudioPlayerControlsWidget(),
            )
          ],
        ),
      ),
    );
  }
}

class MediaState {
  final MediaItem mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}

//https://github.com/ryanheise/audio_service/tree/master/example
class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final ValueChanged<Duration> onChanged;
  final ValueChanged<Duration> onChangeEnd;

  SeekBar({
    @required this.duration,
    @required this.position,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double _dragValue;
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    final value = min(_dragValue ?? widget.position?.inMilliseconds?.toDouble(),
        widget.duration.inMilliseconds.toDouble());
    if (_dragValue != null && !_dragging) {
      _dragValue = null;
    }
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 2),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 10.0,
              activeTrackColor: Colors.white,
              inactiveTrackColor: Color(kColorHukumnamaAudioControls),
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 6,
                elevation: 0,
              ),
              thumbColor: Colors.white,
              trackShape: RoundedRectSliderTrackShape(),
            ),
            child: Slider(
              min: 0.0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: value,
              onChanged: (value) {
                if (!_dragging) {
                  _dragging = true;
                }
                setState(() {
                  _dragValue = value;
                });
                if (widget.onChanged != null) {
                  widget.onChanged(Duration(milliseconds: value.round()));
                }
              },
              onChangeEnd: (value) {
                if (widget.onChangeEnd != null) {
                  widget.onChangeEnd(Duration(milliseconds: value.round()));
                }
                _dragging = false;
              },
            ),
          ),
        ),
        Positioned(
          left: 22.0,
          bottom: 0.0,
          child: Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                      .firstMatch("${widget.position}")
                      ?.group(1) ??
                  '${widget.position}',
              style: Theme.of(context).textTheme.bodyText1),
        ),
        Positioned(
          right: 22.0,
          bottom: 0.0,
          child: Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                      .firstMatch("${widget.duration}")
                      ?.group(1) ??
                  '${widget.duration}',
              style: Theme.of(context).textTheme.bodyText1),
        ),
      ],
    );
  }

  // Duration get _remaining => widget.duration - widget.position;
}

/// A stream reporting the combined state of the current media item and its
/// current position.
Stream<MediaState> get _mediaStateStream =>
    Rx.combineLatest2<MediaItem, Duration, MediaState>(
        AudioService.currentMediaItemStream,
        AudioService.positionStream,
        (mediaItem, position) => MediaState(mediaItem, position));

class AudioPlayerControlsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Column(
        children: [
          // A seek bar.
          StreamBuilder<MediaState>(
            stream: _mediaStateStream,
            builder: (context, snapshot) {
              final mediaState = snapshot.data;
              return SeekBar(
                duration: mediaState?.mediaItem?.duration ?? Duration.zero,
                position: mediaState?.position ?? Duration.zero,
                onChangeEnd: (newPosition) {
                  AudioService.seekTo(newPosition);
                },
              );
            },
          ),
          StreamBuilder<PlaybackState>(
            stream: AudioService.playbackStateStream,
            builder: (context, snapshot) {
              final playing = snapshot.data?.playing ?? false;
              // final processingState = snapshot.data?.processingState ??
              //     AudioProcessingState.stopped;
              return playing
                  ? HukumnamaAudioPlayPauseButton(
                      iconData: Icons.pause,
                      onPressed: pause,
                    )
                  : HukumnamaAudioPlayPauseButton(
                      iconData: Icons.play_arrow,
                      onPressed: play,
                    );
            },
          ),
        ],
      ),
    );
  }

  play() async {
    if (AudioService.running) {
      AudioService.play();
    } else {
      AudioService.start(backgroundTaskEntrypoint: _backgroundTaskEntrypoint);
    }
  }

  pause() => AudioService.pause();

  stop() => AudioService.stop();
}

_backgroundTaskEntrypoint() {
  AudioServiceBackground.run(() => AppAudioPlayerTask());
}

class NetworkImageWithLoading extends StatelessWidget {
  const NetworkImageWithLoading({
    Key key,
    @required this.imageUrl,
  }) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    // return Image.network(
    //   imageUrl,
    //   fit: BoxFit.contain,
    //   loadingBuilder: (_, child, chunk) =>
    //       chunk != null ? ImageLoadingIndicator() : child,
    // );
    // return
    // Center(
    //   child: GestureDetector(
    //     onTap: () {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => HeroPhotoViewRouteWrapper(
    //             tag: Hukumnama_img_tag,
    //             imageProvider: NetworkImage(imageUrl),
    //             minScale: PhotoViewComputedScale.contained,
    //           ),
    //         ),
    //       );
    //     },
    //     child: Container(
    //       child: Hero(
    //         tag: Hukumnama_img_tag,
    //         child: Image.network(
    //           imageUrl,
    //           loadingBuilder: (_, child, chunk) =>
    //               chunk != null ? ImageLoadingIndicator() : child,
    //           errorBuilder: (_c, _o, _s) {
    //             return ImageErrorIndicator();
    //           },
    //         ),
    //       ),
    //     ),
    //   ),
    // );

    return PhotoView(
      imageProvider: NetworkImage(imageUrl),
      loadingBuilder: (_, chunk) {
        return chunk != null ? ImageLoadingIndicator() : Container();
      },
      errorBuilder: (_c, _o, _s) {
        return ImageErrorIndicator();
      },
      minScale: PhotoViewComputedScale.contained,
    );
  }
}

class ImageLoadingIndicator extends StatelessWidget {
  const ImageLoadingIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(
          height: 10.0,
        ),
        Text(kLabelLoadingHukumnamaImage),
      ],
    );
  }
}

class ImageErrorIndicator extends StatelessWidget {
  const ImageErrorIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error,
          size: kDefaultIconProgressSize,
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(kLabelErrorLoadingHukumnamaImage),
      ],
    );
  }
}

class HukumnamaAudioPlayPauseButton extends StatelessWidget {
  const HukumnamaAudioPlayPauseButton({
    this.iconData,
    this.onPressed,
    Key key,
  }) : super(key: key);

  final IconData iconData;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      transform: Matrix4.translationValues(0.0, -10.0, 0.0),
      child: Center(
        child: Ink(
          decoration: const ShapeDecoration(
            color: Color(kColorHukumnamaAudioControls),
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(
              this.iconData,
            ),
            iconSize: 60,
            padding: EdgeInsets.all(0),
            color: Colors.white,
            onPressed: this.onPressed,
          ),
        ),
      ),
    );
  }
}

//src: https://github.com/fireslime/photo_view/blob/master/example/lib/screens/examples/hero_example.dart
// class HeroPhotoViewRouteWrapper extends StatelessWidget {
//   const HeroPhotoViewRouteWrapper(
//       {@required this.imageProvider,
//       this.backgroundDecoration,
//       this.minScale,
//       this.maxScale,
//       @required this.tag});

//   final ImageProvider imageProvider;
//   final Decoration backgroundDecoration;
//   final dynamic minScale;
//   final dynamic maxScale;
//   final String tag;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       constraints: BoxConstraints.expand(
//         height: MediaQuery.of(context).size.height,
//       ),
//       child: Scaffold(
//         appBar: AppBar(
//           leading: IconButton(
//             icon: Icon(Icons.close),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ),
//         body: PhotoView(
//           imageProvider: imageProvider,
//           backgroundDecoration: backgroundDecoration,
//           minScale: minScale,
//           maxScale: maxScale,
//           heroAttributes: PhotoViewHeroAttributes(tag: tag),
//         ),
//       ),
//     );
//   }
// }
