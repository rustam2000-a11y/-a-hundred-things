import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../login/widget/custom_text.dart';
import '../bloc/home_bloc/home_bloc.dart';

class FilterAndListToggleRow extends StatelessWidget {
  const FilterAndListToggleRow({super.key, required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            bloc.add(const ToggleFiltersVisibilityEvent(true));
          },
          child: const Row(
            children: [
              Icon(Icons.import_export, size: 24),
              SizedBox(width: 4),
              CustomText5(text: 'FILTER', fontSize: 20),
            ],
          ),
        ),
        Container(
          width: 74,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  bloc.add(const ToggleListModeEvent(true));
                },
                child: Icon(
                  Icons.view_list,
                  size: 20,
                  color: state.isListMode ? Colors.black : Colors.black26,
                ),
              ),
              Container(
                width: 1,
                height: 20,
                color: Colors.black26,
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),
              GestureDetector(
                onTap: () {
                  bloc.add(const ToggleListModeEvent(false));
                },
                child: Icon(
                  Icons.view_list_outlined,
                  size: 20,
                  color: !state.isListMode ? Colors.black : Colors.black26,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
