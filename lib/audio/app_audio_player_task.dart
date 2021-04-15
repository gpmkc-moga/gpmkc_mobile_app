import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import '../constants.dart';
import 'package:audio_session/audio_session.dart';

enum AppAudioType { HUKUMNAMA, RADIO }

class AppAudioPlayerTask extends BackgroundAudioTask {
  final _audioPlayer = AudioPlayer();
  // final _completer = Completer();
  StreamSubscription<PlaybackEvent> _eventSubscription;
  StreamSubscription<Duration> _durationSubscription;

  /// Broadcasts the current state to all clients.
  Future<void> _broadcastState() async {
    await AudioServiceBackground.setState(
      controls: [
        if (_audioPlayer.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
      ],
      processingState: _getProcessingState(),
      playing: _audioPlayer.playing,
      position: _audioPlayer.position,
      bufferedPosition: _audioPlayer.bufferedPosition,
      speed: _audioPlayer.speed,
    );
  }

  /// Maps just_audio's processing state into into audio_service's playing
  /// state. If we are in the middle of a skip, we use [_skipState] instead.
  AudioProcessingState _getProcessingState() {
    switch (_audioPlayer.processingState) {
      case ProcessingState.idle:
        return AudioProcessingState.stopped;
      case ProcessingState.loading:
        return AudioProcessingState.connecting;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
      default:
        throw Exception("Invalid state: ${_audioPlayer.processingState}");
    }
  }

  @override
  Future<void> onStart(Map<String, dynamic> params) async {
    //get hukumnama link and title from web
    //todo need refresh button
    // final mediaItem = MediaItem(
    //   id: sample_hukumnama_audio_link,
    //   album: Hukumnama_Album_Name,
    //   title: sample_hukumnama_title,
    //   extras: {kKeyAudioType: AppAudioType.HUKUMNAMA.toString()},
    // );
    //
    //
    //kKeyMediaItemMap: {
    //   kKeyMediaItemId: radio_media_item.id,
    //   kKeyMediaItemAlbum: radio_media_item.album,
    //   kKeyMediaItemTitle: radio_media_item.title,
    //   kKeyAudioType: radio_media_item.extras[kKeyAudioType]
    // }

    //

    final MediaItem mediaItem = MediaItem(
        id: params[kKeyMediaItemMap][kKeyMediaItemId],
        album: params[kKeyMediaItemMap][kKeyMediaItemAlbum],
        title: params[kKeyMediaItemMap][kKeyMediaItemTitle],
        extras: {kKeyAudioType: params[kKeyMediaItemMap][kKeyAudioType]});
    await playAndSubscribeMediItem(mediaItem);
  }

  Future playAndSubscribeMediItem(MediaItem mediaItem) async {
    if (mediaItem.extras[kKeyAudioType] == AppAudioType.RADIO.toString()) {
      final session = await AudioSession.instance;
      await session.configure(AudioSessionConfiguration.music());
    } else {
      final session = await AudioSession.instance;
      await session.configure(AudioSessionConfiguration.speech());
    }

    _eventSubscription = _audioPlayer.playbackEventStream.listen((event) {
      _broadcastState();
    });

    // Tell the UI and media notification what we're playing.
    await AudioServiceBackground.setMediaItem(mediaItem);

    // Connect to the URL
    await _audioPlayer.setUrl(mediaItem.id);
    // Now we're ready to play
    await _audioPlayer.play();
    // _completer.complete();

    _durationSubscription = _audioPlayer.durationStream.listen((duration) {
      // final songIndex = _audioPlayer.playbackEvent.currentIndex;
      // print('current index: $songIndex, duration: $duration');
      final modifiedMediaItem = mediaItem.copyWith(duration: duration);
      AudioServiceBackground.setMediaItem(modifiedMediaItem);
    });
  }

  @override
  Future<void> onPlayMediaItem(MediaItem mediaItem) async {
    super.onPlayMediaItem(mediaItem);
    playAndSubscribeMediItem(mediaItem);
  }

  @override
  Future<void> onStop() async {
    // // Wait for `onStart` to complete
    // await _completer.future;
    // Stop and dispose of the player.
    // await AudioServiceBackground.setMediaItem(null);
    await _audioPlayer.dispose();
    // Broadcast that we've stopped.
    await AudioServiceBackground.setState(
        controls: [],
        playing: false,
        processingState: AudioProcessingState.stopped);
    // Shut down this background task
    _eventSubscription.cancel();
    _durationSubscription.cancel();
    await super.onStop();
  }

  @override
  Future<void> onPlay() => _audioPlayer.play();

  @override
  Future<void> onPause() => _audioPlayer.pause();

  @override
  Future<void> onSeekTo(Duration position) => _audioPlayer.seek(position);
}
