import 'package:election_mantra/api/models/filter_model.dart';
import 'package:election_mantra/core/constant/palette.dart';
import 'package:election_mantra/core/util.dart';
import 'package:election_mantra/presentation/blocs/age_group_stats/age_group_stats_bloc.dart';
import 'package:election_mantra/presentation/blocs/party_list/party_list_bloc.dart';
import 'package:election_mantra/presentation/blocs/religion/religion_bloc.dart';
import 'package:election_mantra/presentation/blocs/startup/startup_bloc.dart';
import 'package:election_mantra/presentation/cubit/cubit/filter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterWidget extends StatefulWidget {
  final ValueChanged<FilterModel> onFiltersChanged;

  const FilterWidget({super.key, required this.onFiltersChanged});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  @override
  void initState() {
    super.initState();
    // Always initialize temporary filters with current applied filters
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentApplied = context.read<FilterCubit>().currentAppliedFilters;
      context.read<FilterCubit>().emit(
        FilterState(
          temporaryFilters: currentApplied,
          appliedFilters: currentApplied,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
        return _buildFilterMode(state.temporaryFilters);
      },
    );
  }

  Widget _buildFilterMode(FilterModel currentFilters) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(5),
          color: Colors.grey[200],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: _clearAllFilters,
                child: const Text(
                  'Clear All',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => _applyFilters(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        leadingWidth: 1,
        backgroundColor: Palette.primary,
        title:  Text("Filters",
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Palette.white
          ,fontSize: 20
        ),
        ),
        actions: [
          IconButton(
            color: Palette.white,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildDetailsFilter(currentFilters),
                const SizedBox(height: 20),
                _buildVotingStatusFilter(currentFilters),
                const SizedBox(height: 20),
                _buildGenderFilter(currentFilters),
                const SizedBox(height: 20),
                _buildPoliticalAffiliationFilter(currentFilters),
                const SizedBox(height: 20),
                _buildAgeFilter(currentFilters),
                const SizedBox(height: 20),
                _buildReligionFilter(currentFilters),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ---------------- FILTER SECTIONS ----------------
  Widget _buildDetailsFilter(FilterModel currentFilters) {
    return _buildFilterSection(
      title: 'Details Status',
      filters: [
        _buildFilterChip(
          label: 'Pending',
          value: 'pending',
          selected: currentFilters.status == 'pending',
          onSelected:
              (selected) => _updateFilter(status: selected ? 'pending' : null),
        ),
        _buildFilterChip(
          label: 'Completed',
          value: 'completed',
          selected: currentFilters.status == 'completed',
          onSelected:
              (selected) =>
                  _updateFilter(status: selected ? 'completed' : null),
        ),
      ],
    );
  }

  Widget _buildVotingStatusFilter(FilterModel currentFilters) {
    return _buildFilterSection(
      title: 'Voting Status',
      filters: [
        _buildFilterChip(
          label: 'Voted',
          value: 'voted',
          selected: currentFilters.voted == 'voted',
          onSelected:
              (selected) => _updateFilter(voted: selected ? 'voted' : null),
        ),
        _buildFilterChip(
          label: 'Not Voted',
          value: 'not voted',
          selected: currentFilters.voted == 'not voted',
          onSelected:
              (selected) => _updateFilter(voted: selected ? 'not voted' : null),
        ),
      ],
    );
  }

  Widget _buildAgeFilter(FilterModel currentFilters) {
    return BlocBuilder<AgeGroupStatsBloc, AgeGroupStatsState>(
      builder: (context, state) {
        if (state is AgeGroupStatsSuccess) {
          return _buildFilterSection(
            title: 'Age Group',
            filters:
                state.ageGroupStats.map((e) {
                  return _buildFilterChip(
                    label: e.label,
                    value: e.label,
                    selected: currentFilters.ageGroup == e.label,
                    onSelected:
                        (selected) =>
                            _updateFilter(ageGroup: selected ? e.label : null),
                  );
                }).toList(),
          );
        }
        return SizedBox(height: 50, child: Util.shimmerBox(height: 5));
      },
    );
  }

  Widget _buildReligionFilter(FilterModel currentFilters) {
    return BlocBuilder<ReligionBloc, ReligionState>(
      builder: (context, state) {
        if (state is ReligionSuccess) {
          return _buildFilterSection(
            title: 'Religion',
            filters:
                state.religions.map((religion) {
                  return _buildFilterChip(
                    color: Util.hexToColor(religion.color),
                    label: religion.name,
                    value: religion.value,
                    selected: currentFilters.religion == religion.value,
                    onSelected:
                        (selected) => _updateFilter(
                          religion: selected ? religion.value : null,
                        ),
                  );
                }).toList(),
          );
        } else if (state is ReligionLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildPoliticalAffiliationFilter(FilterModel currentFilters) {
    return BlocBuilder<PartyListBloc, PartyListState>(
      builder: (context, state) {
        if (state is PartyListSuccess) {
          final affiliationFilters =
              state.politicalGroups.map((politicalGroup) {
                return _buildFilterChip(
                  label: politicalGroup.name,
                  value: politicalGroup.name,
                  selected: currentFilters.affiliation == politicalGroup.name,
                  onSelected:
                      (selected) => _updateFilter(
                        affiliation: selected ? politicalGroup.name : null,
                      ),
                  color: Util.hexToColor(politicalGroup.color),
                );
              }).toList();

          return _buildFilterSection(
            title: 'Political Affiliation',
            filters: affiliationFilters,
          );
        } else if (state is PartyListLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is PartyListFailed) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Error loading parties: ${state.msg}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildGenderFilter(FilterModel currentFilters) {
    return BlocBuilder<StartupBloc, StartupState>(
      builder: (context, state) {
        if (state is StartupSuccess) {
          return _buildFilterSection(
            title: 'Gender',
            filters:
                state.genders.map((e) {
                  return _buildFilterChip(
                    label: e.name,
                    value: e.name,
                    selected: currentFilters.gender == e.name,
                    onSelected:
                        (selected) =>
                            _updateFilter(gender: selected ? e.name : null),
                  );
                }).toList(),
          );
        }
        return SizedBox(height: 50, child: Util.shimmerBox(height: 5));
      },
    );
  }

  /// ---------------- HELPER WIDGETS ----------------
  Widget _buildFilterSection({
    required String title,
    required List<Widget> filters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: filters),
      ],
    );
  }

  Widget _buildFilterChip<T>({
    required String label,
    required T value,
    required bool selected,
    required ValueChanged<bool> onSelected,
    Color? color,
  }) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black87,
          fontSize: 14,
        ),
      ),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: selected ? color ?? Colors.blueAccent : Colors.grey[200],
      selectedColor: color ?? Colors.blueAccent,
      checkmarkColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected ? color ?? Colors.blueAccent : Colors.grey[300]!,
          width: 1,
        ),
      ),
    );
  }

  void _updateFilter({
    String? status,
    String? voted,
    String? affiliation,
    String? ageGroup,
    String? religion,
    String? gender,
  }) {
    context.read<FilterCubit>().updateTemporaryFilter(
      status: status,
      voted: voted,
      affiliation: affiliation,
      ageGroup: ageGroup,
      religion: religion,
      gender: gender,
    );
  }

  void _clearAllFilters() {
    context.read<FilterCubit>().resetTemporaryFilters();
  }

  void _applyFilters() {
    context.read<FilterCubit>().applyTemporaryFilters();
    final appliedFilters = context.read<FilterCubit>().currentAppliedFilters;
    widget.onFiltersChanged(appliedFilters);
    Navigator.pop(context);
  }
}
