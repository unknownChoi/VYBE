import 'package:flutter/material.dart';

class PhotoViewerScreen extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const PhotoViewerScreen({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  State<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.imageUrls.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                return Center(
                  child: Image.asset(
                    widget.imageUrls[index],
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
            if (_showControls)
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 32),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            if (_showControls && _currentIndex > 0)
              Positioned(
                left: 16,
                top: MediaQuery.of(context).size.height / 2 - 24,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 32),
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            if (_showControls && _currentIndex < widget.imageUrls.length - 1)
              Positioned(
                right: 16,
                top: MediaQuery.of(context).size.height / 2 - 24,
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 32),
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
