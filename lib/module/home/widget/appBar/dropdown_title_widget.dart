import 'package:flutter/material.dart';

import '../type_widget/type_add_screen.dart';

class WidgetDrawer extends StatelessWidget {
  const WidgetDrawer({
    super.key,
    required this.types,
    required this.onTypeSelected,
  });

  final List<String> types;
  final void Function(String) onTypeSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 0,
              child: CustomPaint(
                size: const Size(20, 20),
                painter: _ArrowPainter(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final newType = await Navigator.push<String>(
                                context,
                                MaterialPageRoute(builder: (context) => const AddTypePage()),
                              );

                              if (newType != null && !types.contains(newType)) {
                                onTypeSelected(newType);
                                Navigator.pop(context);
                              }
                            },

                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Add new',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                Icon(Icons.add, color: Colors.blue),
                                SizedBox(width: 8),
                              ],
                            ),
                          ),

                        ],
                      ),
                      const SizedBox(height: 12),
                      Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: types.length,
                          separatorBuilder: (context, index) => const Divider(
                            color: Colors.grey,
                            thickness: 1,
                            height: 1,
                          ),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                onTypeSelected(types[index]);
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Center(
                                  child: Text(
                                    types[index],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = Path()
      ..moveTo(0, size.height)
      ..quadraticBezierTo(
        size.width / 2,
        -7,
        size.width,
        size.height,
      )
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
