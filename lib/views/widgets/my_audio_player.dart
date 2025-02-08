import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MyAudioPlayer extends StatefulWidget {
  final String audioPath;

  const MyAudioPlayer({super.key, required this.audioPath});

  @override
  State<MyAudioPlayer> createState() => _MyAudioPlayerState();
}

class _MyAudioPlayerState extends State<MyAudioPlayer> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    initialization();
    super.initState();
  }

  Future<void> initialization() async {
    if (widget.audioPath.toLowerCase().startsWith("http")) {
      await audioPlayer.setSourceUrl(widget.audioPath);
    } else {
      await audioPlayer.setSourceDeviceFile(widget.audioPath);
    }

    audioPlayer.onPlayerStateChanged.listen((state) {
      try {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      } catch (_) {}
    });

    audioPlayer.onDurationChanged.listen((cDuration) {
      setState(() {
        duration = cDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((cPosition) {
      setState(() {
        position = cPosition;
      });
    });

    audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        position = Duration.zero;
        isPlaying = false;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Slider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    onChanged: (newValue) async {
                      final position = Duration(seconds: newValue.toInt());
                      await audioPlayer.seek(position);
                      await audioPlayer.resume();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatTime(position)),
                        Text(formatTime(duration)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          child: Center(
                            child: IconButton(
                              icon: const Icon(
                                Icons.replay_10,
                                size: 18.0,
                              ),
                              onPressed: () async {
                                if ((position.inSeconds - 10) >= 0) {
                                  await audioPlayer.seek(Duration(
                                      seconds: position.inSeconds - 10));
                                  await audioPlayer.resume();
                                } else {
                                  await audioPlayer
                                      .seek(const Duration(seconds: 0));
                                  await audioPlayer.resume();
                                }
                              },
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 25,
                          child: Center(
                            child: IconButton(
                              icon: isPlaying
                                  ? const Icon(
                                      Icons.pause,
                                      size: 22.0,
                                    )
                                  : const Icon(
                                      Icons.play_arrow,
                                      size: 22.0,
                                    ),
                              onPressed: () async {
                                if (isPlaying) {
                                  await audioPlayer.pause();
                                } else {
                                  await audioPlayer.play(
                                    UrlSource(widget.audioPath),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 18,
                          child: Center(
                            child: IconButton(
                              icon: const Icon(
                                Icons.forward_10,
                                size: 18.0,
                              ),
                              onPressed: () async {
                                if ((position.inSeconds + 10) <=
                                    duration.inSeconds) {
                                  await audioPlayer.seek(Duration(
                                      seconds: position.inSeconds + 10));
                                  await audioPlayer.resume();
                                } else {
                                  await audioPlayer.seek(
                                      Duration(seconds: duration.inSeconds));
                                  await audioPlayer.resume();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(":");
  }
}
