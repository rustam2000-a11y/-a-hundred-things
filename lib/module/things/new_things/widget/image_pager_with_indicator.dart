import 'dart:io';
import 'package:flutter/material.dart';
import 'thing_image_placeholder.dart';

class ImagePagerWithIndicator extends StatefulWidget {
  const ImagePagerWithIndicator({
    super.key,
    required this.files,
    required this.urls,
    required this.screenHeight,
    this.onRemove,
  });

  final List<File> files;
  final List<String>? urls;
  final double screenHeight;
  final void Function(int index)? onRemove;

  @override
  State<ImagePagerWithIndicator> createState() =>
      _ImagePagerWithIndicatorState();
}

class _ImagePagerWithIndicatorState extends State<ImagePagerWithIndicator> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isFileMode = widget.files.isNotEmpty;
    final int itemCount =
    isFileMode ? widget.files.length : widget.urls?.length ?? 0;

    if (itemCount == 0) {
      return ThingImagePlaceholder(
        screenWidth: MediaQuery.of(context).size.width,
      );
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: itemCount,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          itemBuilder: (context, index) {
            final imageWidget = isFileMode
                ? Image.file(widget.files[index], fit: BoxFit.cover, width: double.infinity, height: double.infinity)
                : Image.network(widget.urls![index], fit: BoxFit.cover, width: double.infinity, height: double.infinity);

            return Stack(
              children: [
                Positioned.fill(child: imageWidget),

                // Показываем крестик только если это локальное изображение и есть обработчик onRemove
                if (isFileMode && widget.onRemove != null)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: () => widget.onRemove!(_currentIndex),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),

        // Индикаторы
        Positioned(
          bottom: widget.screenHeight * 0.015,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(itemCount, (index) {
              final isActive = index == _currentIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 12 : 8,
                height: isActive ? 12 : 8,
                decoration: BoxDecoration(
                  color: isActive ? Colors.black : Colors.grey.shade400,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ),
      ],
    );

  }
}
