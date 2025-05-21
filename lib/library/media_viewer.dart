// lib/media_viewer.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaViewer extends StatefulWidget {
  final String? videoUrl;
  final List<String> images;

  const MediaViewer({super.key, this.videoUrl, required this.images});

  @override
  _MediaViewerState createState() => _MediaViewerState();
}

class _MediaViewerState extends State<MediaViewer> {
  VideoPlayerController? _videoController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.videoUrl != null) {
      _videoController = VideoPlayerController.network(widget.videoUrl!)
        ..initialize().then((_) {
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    _videoController?.pause(); // إيقاف الفيديو قبل التخلص من المتحكم
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = [
      if (widget.videoUrl != null) widget.videoUrl!,
      ...widget.images,
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _videoController?.pause(); // إيقاف الفيديو عند الخروج
            Navigator.pop(context);
          },
        ),
      ),
      body: PageView.builder(
        itemCount: media.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (_currentIndex == 0 && _videoController != null) {
            // لا نشغل الفيديو تلقائيًا
            _videoController!.pause();
          } else {
            _videoController?.pause();
          }
        },
        itemBuilder: (context, index) {
          if (index == 0 &&
              widget.videoUrl != null &&
              _videoController != null) {
            return Center(
              child: _videoController!.value.isInitialized
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: VideoPlayer(_videoController!),
                        ),
                        if (!_videoController!.value.isPlaying)
                          IconButton(
                            icon: Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 60,
                            ),
                            onPressed: () {
                              setState(() {
                                _videoController!.play();
                              });
                            },
                          ),
                      ],
                    )
                  : CircularProgressIndicator(),
            );
          } else {
            final imageIndex = widget.videoUrl != null ? index - 1 : index;
            return Center(
              child: Image.network(
                widget.images[imageIndex],
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  "assets/PlaceholderFull.jpg",
                  fit: BoxFit.contain,
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_currentIndex == 0 &&
                _videoController != null &&
                _videoController!.value.isInitialized)
              IconButton(
                icon: Icon(
                  _videoController!.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _videoController!.value.isPlaying
                        ? _videoController!.pause()
                        : _videoController!.play();
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}
