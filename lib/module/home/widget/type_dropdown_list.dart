import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../../presentation/colors.dart';

class ExpandableFormCard extends StatefulWidget {

  const ExpandableFormCard({
    super.key,
    required this.isExpanded,
    required this.titleController,
    required this.descriptionController,
    required this.isDarkMode,
    required this.screenHeight,
    required this.screenWidth,
    required this.onExpandChanged,
  });
  final bool isExpanded;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final bool isDarkMode;
  final double screenHeight;
  final double screenWidth;
  final ValueChanged<bool> onExpandChanged;

  @override
  State<ExpandableFormCard> createState() => _ExpandableFormCardState();
}

class _ExpandableFormCardState extends State<ExpandableFormCard> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      top: widget.isExpanded ? widget.screenHeight * 0.25 : widget.screenHeight * 0.45,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(widget.screenWidth * 0.05),
        decoration: BoxDecoration(
          gradient: widget.isDarkMode ? AppColors.darkBlueGradient : null,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          border: const Border(top: BorderSide()),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        constraints: BoxConstraints(
          minHeight: widget.screenHeight * 0.3,
          maxHeight: widget.isExpanded ? widget.screenHeight * 0.6 : widget.screenHeight * 0.3,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: EdgeInsets.only(bottom: widget.isExpanded ? 0 : 20),
              child: Column(
                children: [
                  TextField(
                    controller: widget.titleController,
                    decoration: InputDecoration(
                      labelText: S.of(context).enterAName,
                      labelStyle: const TextStyle(fontSize: 24),
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(height: widget.screenHeight * 0.02),
                  TextField(
                    controller: widget.descriptionController,
                    decoration: InputDecoration(
                      labelText: S.of(context).description,
                      labelStyle: const TextStyle(fontSize: 14),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 15),
                    maxLines: 4,
                    minLines: 1,
                  ),
                  const SizedBox(height: 10),
                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(5, (index) {
                          final option = index + 1;
                          return InkWell(
                            onTap: () {
                              print('Выбрана опция $option');
                              widget.onExpandChanged(false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text('Опция $option',
                                  style: const TextStyle(fontSize: 16)),
                            ),
                          );
                        }),
                      ),
                    ),
                    crossFadeState: widget.isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                widget.onExpandChanged(!widget.isExpanded);
              },
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Выбрать тип',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    AnimatedRotation(
                      turns: widget.isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(Icons.keyboard_arrow_up, size: 24),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


