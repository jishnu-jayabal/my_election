import 'package:election_mantra/api/models/filter_model.dart';
import 'package:election_mantra/presentation/cubit/cubit/filter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class AppliedFilterWidget extends StatelessWidget {
  const AppliedFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0,right:20,bottom: 10),
      child: BlocBuilder<FilterCubit, FilterModel>(
        builder: (context, state) {
          final List<Widget> chips = [];
      
          void addChip(String label, String? value, FilterType type) {
            if (value != null && value.isNotEmpty) {
              chips.add(
                Chip(
                  label: Text("$label: $value"),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () {
                    context.read<FilterCubit>().clearFilter(type);
                  },
                ),
              );
            }
          }
      
          addChip("Status", state.status, FilterType.status);
          addChip("Affiliation", state.affiliation, FilterType.affiliation);
          addChip("Age Group", state.ageGroup, FilterType.ageGroup);
          addChip("Religion", state.religion, FilterType.religion);
      
          if (chips.isEmpty) {
            return const SizedBox.shrink(); // nothing if no filters
          }
      
          return Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              ...chips,
              ActionChip(
                label: const Text("Clear All"),
                onPressed: () =>
                    context.read<FilterCubit>().clearAllFilters(),
              ),
            ],
          );
        },
      ),
    );
  }
}
