import 'package:election_mantra/api/models/voter.dart';
import 'package:election_mantra/core/util.dart';
import 'package:election_mantra/presentation/blocs/party_list/party_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum FilterStatus { pending, completed }

enum FilterAge { age18_25, age26_40, age40_60, age60_plus }

enum FilterReligion { hindu, muslim, christian, noReligion }

class FilterWidget extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onFiltersChanged;
  final Map<String, dynamic> initialFilters;

  const FilterWidget({
    super.key,
    required this.onFiltersChanged,
    this.initialFilters = const {},
  });

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  late Map<String, dynamic> _currentFilters;

  @override
  void initState() {
    super.initState();
    _currentFilters = Map<String, dynamic>.from(widget.initialFilters);

    // Ensure party list is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PartyListBloc>().add(FetchPartyListEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Status Filter
              _buildFilterSection(
                title: 'Voting Status',
                filters: [
                  _buildFilterChip(
                    label: 'Pending',
                    value: FilterStatus.pending,
                    selected: _currentFilters['status'] == FilterStatus.pending,
                    onSelected:
                        (selected) => _updateFilter(
                          'status',
                          selected ? FilterStatus.pending : null,
                        ),
                  ),
                  _buildFilterChip(
                    label: 'Completed',
                    value: FilterStatus.completed,
                    selected:
                        _currentFilters['status'] == FilterStatus.completed,
                    onSelected:
                        (selected) => _updateFilter(
                          'status',
                          selected ? FilterStatus.completed : null,
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Dynamic Affiliation Filter from PartyListBloc
              _buildDynamicAffiliationFilter(),

              const SizedBox(height: 20),

              // Age Group Filter
              _buildAgeFilter(),

              const SizedBox(height: 20),

              // Religion Filter
              _buildReligionFilter(),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _clearAllFilters,
                    child: const Text(
                      'Clear All',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      widget.onFiltersChanged(_currentFilters);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Apply Filters'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReligionFilter() {
    return _buildFilterSection(
      title: 'Religion',
      filters: [
        _buildFilterChip(
          label: 'Hindu',
          value: FilterReligion.hindu,
          selected: _currentFilters['religion'] == FilterReligion.hindu,
          onSelected:
              (selected) => _updateFilter(
                'religion',
                selected ? FilterReligion.hindu : null,
              ),
        ),
        _buildFilterChip(
          label: 'Muslim',
          value: FilterReligion.muslim,
          selected: _currentFilters['religion'] == FilterReligion.muslim,
          onSelected:
              (selected) => _updateFilter(
                'religion',
                selected ? FilterReligion.muslim : null,
              ),
        ),
        _buildFilterChip(
          label: 'Christian',
          value: FilterReligion.christian,
          selected: _currentFilters['religion'] == FilterReligion.christian,
          onSelected:
              (selected) => _updateFilter(
                'religion',
                selected ? FilterReligion.christian : null,
              ),
        ),
        _buildFilterChip(
          label: 'No Religion',
          value: FilterReligion.noReligion,
          selected: _currentFilters['religion'] == FilterReligion.noReligion,
          onSelected:
              (selected) => _updateFilter(
                'religion',
                selected ? FilterReligion.noReligion : null,
              ),
        ),
      ],
    );
  }

  Widget _buildAgeFilter() {
    return _buildFilterSection(
      title: 'Age Group',
      filters: [
        _buildFilterChip(
          label: '18-25',
          value: FilterAge.age18_25,
          selected: _currentFilters['age'] == FilterAge.age18_25,
          onSelected:
              (selected) =>
                  _updateFilter('age', selected ? FilterAge.age18_25 : null),
        ),
        _buildFilterChip(
          label: '26-40',
          value: FilterAge.age26_40,
          selected: _currentFilters['age'] == FilterAge.age26_40,
          onSelected:
              (selected) =>
                  _updateFilter('age', selected ? FilterAge.age26_40 : null),
        ),
        _buildFilterChip(
          label: '40-60',
          value: FilterAge.age40_60,
          selected: _currentFilters['age'] == FilterAge.age40_60,
          onSelected:
              (selected) =>
                  _updateFilter('age', selected ? FilterAge.age40_60 : null),
        ),
        _buildFilterChip(
          label: '60+',
          value: FilterAge.age60_plus,
          selected: _currentFilters['age'] == FilterAge.age60_plus,
          onSelected:
              (selected) =>
                  _updateFilter('age', selected ? FilterAge.age60_plus : null),
        ),
      ],
    );
  }

  // Build dynamic affiliation filter from PartyListBloc
  Widget _buildDynamicAffiliationFilter() {
    return BlocBuilder<PartyListBloc, PartyListState>(
      builder: (context, state) {
        if (state is PartyListSuccess) {
          // Create filter chips for each political group
          final affiliationFilters =
              state.politicalGroups.map((politicalGroup) {
                return _buildFilterChip(
                  label: politicalGroup.name,
                  value: politicalGroup.name, // Use the code as value
                  selected:
                      _currentFilters['affiliation'] == politicalGroup.name,
                  onSelected:
                      (selected) => _updateFilter(
                        'affiliation',
                        selected ? politicalGroup.name : null,
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

  void _updateFilter(String key, dynamic value) {
    setState(() {
      if (value == null) {
        _currentFilters.remove(key);
      } else {
        _currentFilters[key] = value;
      }
      widget.onFiltersChanged(_currentFilters);
    });
  }

  void _clearAllFilters() {
    setState(() {
      _currentFilters.clear();
      widget.onFiltersChanged(_currentFilters);
    });
  }
}
