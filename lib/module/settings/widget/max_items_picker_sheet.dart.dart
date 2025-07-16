import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../login/widget/button_basic.dart';
import '../bloc/max_items_bloc/max_items_bloc.dart';

class MaxItemsPickerSheet extends StatefulWidget {
  const MaxItemsPickerSheet({
    super.key,
    required this.onSelected,
    required this.onHideNavChanged,
    required this.onValueChanged,
  });

  final ValueChanged<int> onSelected;
  final ValueChanged<bool> onHideNavChanged;
  final ValueChanged<int> onValueChanged;
  @override
  State<MaxItemsPickerSheet> createState() => _MaxItemsPickerSheetState();
}

class _MaxItemsPickerSheetState extends State<MaxItemsPickerSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    final bloc = context.read<MaxItemsBloc>();
    _controller = TextEditingController();


    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = bloc.state;
      _controller.text = state.maxItems.toString();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MaxItemsBloc, MaxItemsState>(
      listener: (context, state) {
        widget.onHideNavChanged(state.isSpecial);
        widget.onValueChanged(state.maxItems);
        if (state.done) {
          widget.onSelected(state.maxItems);
          Navigator.of(context).pop();
        }

        if (_controller.text != state.maxItems.toString()) {
          _controller.text = state.maxItems.toString();
        }
      },
      child:BlocBuilder<MaxItemsBloc, MaxItemsState>(
        buildWhen: (previous, current) =>
        previous.maxItems != current.maxItems ||
            previous.errorText != current.errorText,
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final parsed = int.tryParse(value.trim()) ?? 0;
                      context.read<MaxItemsBloc>().add(MaxItemsChangedEvent(parsed));
                    },
                    decoration: InputDecoration(
                      errorText: state.errorText,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),


                BlocBuilder<MaxItemsBloc, MaxItemsState>(
                  buildWhen: (previous, current) =>
                  previous.isSpecial != current.isSpecial,
                  builder: (context, state) {
                    return CheckboxListTile(
                      title: const Text('hide item count indicator'),
                      value: state.isSpecial,
                      onChanged: (bool? value) {
                        context.read<MaxItemsBloc>().add(
                          MaxItemsSpecialChangedEvent(value ?? false),
                        );
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                    );
                  },
                ),

                const SizedBox(height: 10),
                SizedBox(
                  width: 150,
                  child: CustomMainButton(
                    text: 'Select',
                    onPressed: () {
                      context.read<MaxItemsBloc>().add(const MaxItemsSubmittedEvent());
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}

