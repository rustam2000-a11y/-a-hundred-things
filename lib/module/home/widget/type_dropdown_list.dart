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
    required this.locationController,
    this.priceController,
    this.weightController,
    this.colorController,
    this.importanceController,
    this.quantityController,
  });

  final bool isExpanded;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final bool isDarkMode;
  final double screenHeight;
  final double screenWidth;
  final ValueChanged<bool> onExpandChanged;
  final TextEditingController? locationController;
  final TextEditingController? priceController;
  final TextEditingController? weightController;
  final TextEditingController? colorController;
  final TextEditingController? importanceController;
  final TextEditingController? quantityController;

  @override
  State<ExpandableFormCard> createState() => _ExpandableFormCardState();
}

class _ExpandableFormCardState extends State<ExpandableFormCard> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      top: widget.isExpanded
          ? widget.screenHeight * 0.12
          : widget.screenHeight * 0.40,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
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
        ),
        constraints: BoxConstraints(
          minHeight: widget.screenHeight * 0.3,
          maxHeight: widget.isExpanded
              ? widget.screenHeight * 0.85
              : widget.screenHeight * 0.4,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: widget.titleController,
                      decoration: InputDecoration(
                        labelText: S.of(context).enterAName,
                        labelStyle: const TextStyle(fontSize: 24),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {


                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: widget.screenHeight * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
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
                  ),
                  if (widget.isExpanded)
                    SizedBox(
                      height: widget.screenHeight * 0.35,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildFieldRow(label: 'Location', controller: widget.locationController),
                            const Divider(),
                            _buildFieldRow(label: 'Price', controller: widget.priceController),
                            const Divider(),
                            _buildFieldRow(label: 'Weight', controller: widget.weightController),
                            const Divider(),
                            _buildFieldRow(label: 'Color', controller: widget.colorController),
                            const Divider(),
                            _buildFieldRow(label: 'Importance', controller: widget.importanceController),
                            const Divider(),
                            _buildFieldRow(label: 'Quantity', controller: widget.quantityController),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),

                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                widget.onExpandChanged(!widget.isExpanded);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'More options',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
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

Widget _buildFieldRow({
  required String label,
  TextEditingController? controller,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: label,
              hintStyle: const TextStyle(fontSize: 16),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit,size: 24,),

          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {

          },
        ),

      ],
    ),
  );
}
