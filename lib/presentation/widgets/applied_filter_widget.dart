import 'package:election_mantra/api/models/filter_model.dart';
import 'package:election_mantra/presentation/blocs/login/login_bloc.dart';
import 'package:election_mantra/presentation/blocs/voters_list/voters_list_bloc.dart';
import 'package:election_mantra/presentation/cubit/cubit/filter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppliedFilterWidget extends StatelessWidget {
  const AppliedFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
      child: BlocBuilder<FilterCubit, FilterState>(
        builder: (context, state) {
          final List<Widget> chips = [];
          final appliedFilters = state.appliedFilters;

          void addChip(String label, String? value, FilterType type) {
            if (value != null && value.isNotEmpty) {
              chips.add(
                Chip(
                  label: Text("$label: $value"),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () {
                    _clearFilterAndReload(context, type);
                  },
                ),
              );
            }
          }

          addChip("Status", appliedFilters.status, FilterType.status);
          addChip("Affiliation", appliedFilters.affiliation, FilterType.affiliation);
          addChip("Age Group", appliedFilters.ageGroup, FilterType.ageGroup);
          addChip("Religion", appliedFilters.religion, FilterType.religion);
          addChip("Gender", appliedFilters.gender, FilterType.gender);

          if (chips.isEmpty) {
            return const SizedBox.shrink();
          }

          return Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              ...chips,
              ActionChip(
                label: const Text("Clear All"),
                onPressed: () => _clearAllFiltersAndReload(context),
              ),
            ],
          );
        },
      ),
    );
  }

  void _clearFilterAndReload(BuildContext context, FilterType filterType) {
    context.read<FilterCubit>().clearAppliedFilter(filterType);
    _reloadVoterList(context);
  }

  void _clearAllFiltersAndReload(BuildContext context) {
    context.read<FilterCubit>().clearAllAppliedFilters();
    _reloadVoterList(context);
  }

  void _reloadVoterList(BuildContext context) {
    final appliedFilters = context.read<FilterCubit>().currentAppliedFilters;
    final loginSuccessState =
        BlocProvider.of<LoginBloc>(context).state as LoginSuccessState;
    
    BlocProvider.of<VotersListBloc>(context).add(
      FetchVoterListByFilterEventLocal(
        boothId: loginSuccessState.user.boothNo,
        constituencyId: loginSuccessState.user.constituencyNo,
        wardId: loginSuccessState.user.wardNo,
        filter: appliedFilters,
      ),
    );
  }
}