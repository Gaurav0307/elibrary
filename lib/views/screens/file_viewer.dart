import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:elibrary/common/global/global.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:video_player/video_player.dart';

import '../widgets/my_audio_player.dart';

class FileViewer extends StatefulWidget {
  final String filePath;

  const FileViewer({super.key, required this.filePath});

  @override
  State<FileViewer> createState() => _FileViewerState();
}

class _FileViewerState extends State<FileViewer> {
  VideoPlayerController? videoPlayerController;
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    debugPrint("-> ${widget.filePath}");

    if ((widget.filePath.toLowerCase().endsWith("mp4") ||
        widget.filePath.toLowerCase().endsWith("mpeg4"))) {
      videoPlayerController = widget.filePath.toLowerCase().startsWith("http")
          ? VideoPlayerController.networkUrl(
              Uri.parse(widget.filePath),
              videoPlayerOptions: VideoPlayerOptions(),
            )
          : VideoPlayerController.file(
              File(widget.filePath),
              videoPlayerOptions: VideoPlayerOptions(),
            );
      videoPlayerController!.initialize();
    }

    _timer = Timer(
      const Duration(seconds: 5),
      () => addToHistory(widget.filePath),
    );
  }

  Future<void> addToHistory(String filePath) async {
    var key = "history";
    if (filePath.toLowerCase().startsWith("http")) {
      List<String> history = [];

      if (sharedPreferences!.containsKey(key)) {
        history = sharedPreferences!.getStringList(key) ?? [];
      }

      if (!history.contains(filePath)) {
        history.add(filePath);
        await sharedPreferences!.setStringList(key, history);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var key = "likedVideos";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          ((widget.filePath.toLowerCase().endsWith("mp4") ||
                      widget.filePath.toLowerCase().endsWith("mpeg4")) &&
                  widget.filePath.toLowerCase().startsWith("http"))
              ? IconButton(
                  onPressed: () async {
                    List<String> likedVideos = [];

                    if (sharedPreferences!.containsKey(key)) {
                      likedVideos = sharedPreferences!.getStringList(key) ?? [];
                    }

                    if (likedVideos.contains(widget.filePath)) {
                      likedVideos.remove(widget.filePath);
                    } else {
                      likedVideos.add(widget.filePath);
                    }

                    await sharedPreferences!.setStringList(key, likedVideos);
                    setState(() {});
                  },
                  icon: sharedPreferences!.containsKey(key) &&
                          sharedPreferences!
                              .getStringList(key)!
                              .contains(widget.filePath)
                      ? Icon(Icons.thumb_up)
                      : Icon(Icons.thumb_up_outlined),
                )
              : SizedBox.shrink(),
          SizedBox(width: 20.0),
        ],
      ),
      backgroundColor: Colors.black87,
      body: Center(
        child: (widget.filePath.toLowerCase().endsWith("jpg") ||
                widget.filePath.toLowerCase().endsWith("jpe") ||
                widget.filePath.toLowerCase().endsWith("jpeg") ||
                widget.filePath.toLowerCase().endsWith("png"))
            ? imageView(context)
            : (widget.filePath.toLowerCase().endsWith("mp4") ||
                    widget.filePath.toLowerCase().endsWith("mpeg4"))
                ? videoView(context)
                : (widget.filePath.toLowerCase().endsWith("mp3") ||
                        widget.filePath.toLowerCase().endsWith("wav") ||
                        widget.filePath.toLowerCase().endsWith("aac"))
                    ? audioView()
                    : (widget.filePath.toLowerCase().endsWith("pdf"))
                        ? pdfView()
                        : const SizedBox.shrink(),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (videoPlayerController != null) {
      videoPlayerController!.dispose();
    }
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  Widget pdfView() {
    /// pdfrx
    return Container(
      child: widget.filePath.toLowerCase().startsWith("http")
          ? PdfViewer.uri(
              Uri.parse(widget.filePath),
            )
          : PdfViewer.file(
              widget.filePath,
            ),
    );
  }

  Widget audioView() {
    return SizedBox(
      height: 150,
      child: MyAudioPlayer(audioPath: widget.filePath),
    );
  }

  Widget videoView(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Chewie(
        controller: ChewieController(
          aspectRatio: 16 / 9,
          autoPlay: true,
          // fullScreenByDefault: true,
          videoPlayerController: videoPlayerController!,
        ),
      ),
    );
  }

  Widget imageView(BuildContext context) {
    return widget.filePath.toLowerCase().startsWith("http")
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: AspectRatio(
              aspectRatio: 1,
              child: PhotoViewGallery.builder(
                backgroundDecoration:
                    const BoxDecoration(color: Colors.black87),
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    // maxScale: PhotoViewComputedScale.contained,
                    minScale: PhotoViewComputedScale.contained,
                    imageProvider: CachedNetworkImageProvider(widget.filePath),
                    initialScale: PhotoViewComputedScale.contained,
                  );
                },
                itemCount: 1,
              ),
            ),
          )
        : SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: AspectRatio(
              aspectRatio: 1,
              child: PhotoViewGallery.builder(
                backgroundDecoration:
                    const BoxDecoration(color: Colors.black87),
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    // maxScale: PhotoViewComputedScale.contained,
                    minScale: PhotoViewComputedScale.contained,
                    imageProvider: FileImage(File(widget.filePath)),
                    initialScale: PhotoViewComputedScale.contained,
                  );
                },
                itemCount: 1,
              ),
            ),
          );
  }
}
