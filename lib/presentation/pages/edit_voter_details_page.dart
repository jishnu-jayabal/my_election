import 'package:election_mantra/api/models/staying_status.dart';
import 'package:election_mantra/api/models/voter_details.dart';
import 'package:election_mantra/core/local_data.dart';
import 'package:election_mantra/core/util.dart';
import 'package:election_mantra/presentation/blocs/login/login_bloc.dart';
import 'package:election_mantra/presentation/blocs/party_list/party_list_bloc.dart';
import 'package:election_mantra/presentation/blocs/religion/religion_bloc.dart';
import 'package:election_mantra/presentation/blocs/startup/startup_bloc.dart';
import 'package:election_mantra/presentation/blocs/update_voter/update_voter_bloc.dart';
import 'package:election_mantra/presentation/blocs/voters_list/voters_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/countries.dart';

class EditVoterDetailsPage extends StatefulWidget {
  final VoterDetails voter;

  const EditVoterDetailsPage({super.key, required this.voter});

  @override
  // ignore: library_private_types_in_public_api
  _EditVoterDetailsPageState createState() => _EditVoterDetailsPageState();
}

class _EditVoterDetailsPageState extends State<EditVoterDetailsPage> {
  late VoterDetails _editedVoter;
  final _formKey = GlobalKey<FormState>();
  late LoginSuccessState loginSuccessState;

  @override
  void initState() {
    super.initState();
    _editedVoter = widget.voter;
    loginSuccessState =
        BlocProvider.of<LoginBloc>(context).state as LoginSuccessState;
  }

  // Create a new VoterDetails instance with updated values
  VoterDetails _updateVoter({
    String? party,
    bool? isSureVote,
    String? voteType,
    String? religion,
    String? caste,
    String? education,
    String? occupation,
    String? mobileNo,
    String? influencer,
    String? stayingStatus,
    String? stayingLocation,
    String? voterConcern,
  }) {
    return VoterDetails(
      id: _editedVoter.id,
      serialNo: _editedVoter.serialNo,
      name: _editedVoter.name,
      guardianName: _editedVoter.guardianName,
      houseName: _editedVoter.houseName,
      gender: _editedVoter.gender,
      age: _editedVoter.age,
      voterId: _editedVoter.voterId,
      pollingStation: _editedVoter.pollingStation,
      religion: religion ?? _editedVoter.religion,
      caste: caste ?? _editedVoter.caste,
      voteType: voteType ?? _editedVoter.voteType,
      isSureVote: isSureVote ?? _editedVoter.isSureVote,
      isStayingOutside: _editedVoter.isStayingOutside,
      stayingLocation: stayingLocation ?? _editedVoter.stayingLocation,
      stayingStatus: stayingStatus ?? _editedVoter.stayingStatus,
      influencer: influencer ?? _editedVoter.influencer,
      education: education ?? _editedVoter.education,
      occupation: occupation ?? _editedVoter.occupation,
      mobileNo: mobileNo ?? _editedVoter.mobileNo,
      state: _editedVoter.state,
      district: _editedVoter.district,
      block: _editedVoter.block,
      panchayath: _editedVoter.panchayath,
      assembly: _editedVoter.assembly,
      locBodyType: _editedVoter.locBodyType,
      party: party ?? _editedVoter.party,
      voterConcern: voterConcern ?? _editedVoter.voterConcern,
      voted: _editedVoter.voted,
      bhagNo: _editedVoter.bhagNo,
      createdAt: _editedVoter.createdAt,
      updatedAt: DateTime.now(),
      updatedBy:
          '${loginSuccessState.user.name}:${loginSuccessState.user.id}', // Replace with actual user ID
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Voter Record'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveVoterDetails,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildBasicInfoSection(),
              const SizedBox(height: 20),
              const Divider(),
              _buildVoterInfoSection(),
              const SizedBox(height: 20),
              const Divider(),
              _buildCulturalInfoSection(),
              const SizedBox(height: 20),
              const Divider(),
              _buildProfessionalInfoSection(),
              const SizedBox(height: 20),
              const Divider(),
              _buildResidenceInfoSection(),
              const SizedBox(height: 30),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Basic Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Row(
              children: [_buildInfoItem('name', _editedVoter.name.toString())],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoItem('Serial No', _editedVoter.serialNo.toString()),
                const SizedBox(width: 20),
                _buildInfoItem('Guardian', _editedVoter.guardianName),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoItem('Voter ID', _editedVoter.voterId),
                const SizedBox(width: 20),
                _buildInfoItem('House No', _editedVoter.houseName),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoItem('Age', '${_editedVoter.age} years'),
                const SizedBox(width: 20),
                _buildInfoItem('Gender', _editedVoter.gender),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoterInfoSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Voter Information ★',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Party', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            BlocBuilder<PartyListBloc, PartyListState>(
              builder: (context, partyState) {
                if (partyState is PartyListSuccess) {
                  return ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 50),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          partyState.politicalGroups.map((party) {
                            return _buildPartyChip(party.name);
                          }).toList(),
                    ),
                  );
                }
                return Util.shimmerBox(height: 10);
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Sure Vote',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 50),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildSureVoteChip('Yes'),
                  _buildSureVoteChip('Doubtful'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Vote Type',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            BlocBuilder<StartupBloc, StartupState>(
              builder: (context, startupState) {
                if (startupState is StartupSuccess) {
                  return ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 50),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          startupState.voterType.map((vtype) {
                            return _buildVoteTypeChip(vtype.name);
                          }).toList(),
                    ),
                  );
                }
                return Util.shimmerBox(height: 10);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCulturalInfoSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cultural Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Religion',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            BlocBuilder<ReligionBloc, ReligionState>(
              builder: (context, religionState) {
                if (religionState is ReligionSuccess) {
                  return ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 50),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          religionState.religions.map((r) {
                            return _buildReligionChip(r.name, r.value);
                          }).toList(),
                    ),
                  );
                }
                return Util.shimmerBox(height: 10);
              },
            ),
            const SizedBox(height: 16),
            const Text('Caste', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            BlocBuilder<ReligionBloc, ReligionState>(
              builder: (context, religionState) {
                if (religionState is ReligionSuccess) {
                  // Find the selected religion
                  final selectedReligion = religionState.religions.firstWhere(
                    (r) => r.value == _editedVoter.religion,
                    orElse: () => religionState.religions.first,
                  );

                  // Get castes for the selected religion
                  final casteOptions = selectedReligion.castes;

                  // If no castes available, show message or hide the field
                  if (casteOptions.isEmpty) {
                    return const Text(
                      'No caste options available for this religion',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    );
                  }

                  return DropdownButtonFormField<String>(
                    value:
                        _editedVoter.caste != null &&
                                _editedVoter.caste!.isNotEmpty &&
                                casteOptions.contains(_editedVoter.caste)
                            ? _editedVoter.caste
                            : null,
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('Select Caste (Optional)'),
                      ),
                      ...casteOptions.map(
                        (caste) =>
                            DropdownMenuItem(value: caste, child: Text(caste)),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _editedVoter = _updateVoter(caste: value);
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  );
                }
                return Util.shimmerBox(height: 10);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalInfoSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Professional Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Education',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            BlocBuilder<StartupBloc, StartupState>(
              builder: (context, startupState) {
                if (startupState is StartupSuccess) {
                  final educationOptions =
                      startupState.education.map((e) => e.name).toList();

                  return DropdownButtonFormField<String>(
                    value:
                        _editedVoter.education != null &&
                                _editedVoter.education!.isNotEmpty &&
                                educationOptions.contains(
                                  _editedVoter.education,
                                )
                            ? _editedVoter.education
                            : null,
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('Select Education'),
                      ),
                      ...startupState.education.map(
                        (education) => DropdownMenuItem(
                          value: education.name,
                          child: Text(education.name),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _editedVoter = _updateVoter(education: value);
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Select One',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  );
                }
                return Util.shimmerBox(height: 10);
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Occupation',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 50),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildOccupationChip('Un Employed'),
                  _buildOccupationChip('Employed'),
                  _buildOccupationChip('Business'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _editedVoter.mobileNo,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                setState(() {
                  _editedVoter = _updateVoter(mobileNo: value);
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _editedVoter.influencer,
              decoration: const InputDecoration(
                labelText: 'Influencer',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _editedVoter = _updateVoter(influencer: value);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResidenceInfoSection() {
    return BlocBuilder<StartupBloc, StartupState>(
      builder: (context, state) {
        if (state is StartupSuccess) {
          return Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Residence Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'STAYING STATUS',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 50),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          state.stayingStatus.map((st) {
                            return _buildStayingStatusChip(st.name, st.type);
                          }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Conditionally show either dropdown or textfield based on staying status type
                  _buildStayingLocationField(),

                  const SizedBox(height: 16),
                  const Text(
                    'Voter Concern',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 50),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          state.voterConcern.map((vc) {
                            return _buildVoterConcernChip(vc.name);
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Util.shimmerBox(height: 10);
      },
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildPartyChip(String party) {
    return ChoiceChip(
      label: SizedBox(
        width: 80, // Fixed width to prevent jumping
        child: Text(
          party,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      selected: _editedVoter.party == party,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _editedVoter = _updateVoter(party: party);
          });
        }
      },
      labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildSureVoteChip(String label) {
    final isSelected =
        (label == 'Yes') ? _editedVoter.isSureVote : !_editedVoter.isSureVote;

    return ChoiceChip(
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(label),
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _editedVoter = _updateVoter(isSureVote: label == 'Yes');
          });
        }
      },
      labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildVoteTypeChip(String voteType) {
    return ChoiceChip(
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(voteType),
      ),
      selected: _editedVoter.voteType == voteType,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _editedVoter = _updateVoter(voteType: voteType);
          });
        }
      },
      labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildReligionChip(String religion, String value) {
    return BlocBuilder<ReligionBloc, ReligionState>(
      builder: (context, religionState) {
        if (religionState is ReligionSuccess) {
          final selectedReligion = religionState.religions.firstWhere(
            (r) => r.value == value,
            orElse: () => religionState.religions.first,
          );

          final hasCastes = selectedReligion.castes.isNotEmpty;

          return ChoiceChip(
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(religion),
            ),
            selected: _editedVoter.religion == value,
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  // Reset caste when religion changes, but only if the new religion has castes
                  if (hasCastes) {
                    _editedVoter = _updateVoter(religion: value, caste: null);
                  } else {
                    _editedVoter = _updateVoter(religion: value, caste: '');
                  }
                });
              }
            },
            labelPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          );
        }
        return ChoiceChip(
          label: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(religion),
          ),
          selected: _editedVoter.religion == value,
          onSelected: (_) {},
          labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        );
      },
    );
  }

  Widget _buildOccupationChip(String occupation) {
    return ChoiceChip(
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(occupation),
      ),
      selected: _editedVoter.occupation == occupation,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _editedVoter = _updateVoter(occupation: occupation);
          });
        }
      },
      labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildStayingStatusChip(String status, String type) {
    return ChoiceChip(
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(status),
      ),
      selected: _editedVoter.stayingStatus == status,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            // Reset staying location when status changes
            _editedVoter = _updateVoter(
              stayingStatus: status,
              stayingLocation: null, // Reset location
            );
          });
        }
      },
      labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildVoterConcernChip(String concern) {
    return ChoiceChip(
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(concern),
      ),
      selected: _editedVoter.voterConcern == concern,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _editedVoter = _updateVoter(voterConcern: concern);
          });
        }
      },
      labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildStayingLocationField() {
    final stayingStatus = _editedVoter.stayingStatus;

    // Find the staying status type from the bloc state
    final stayingStatusType = _getStayingStatusType(stayingStatus);

    if (stayingStatusType == 'none') {
      return const SizedBox.shrink(); // Hide if no valid status selected
    }

    if (stayingStatusType == 'state' || stayingStatusType == 'country') {
      // Show dropdown for state or country selection
      final isStateDropdown = stayingStatusType == 'state';
      final options =
          isStateDropdown ? LocalData.indianStates : LocalData.countries;
      final label = isStateDropdown ? 'Select State' : 'Select Country';
      final hint = isStateDropdown ? 'Select Indian State' : 'Select Country';

      return DropdownButtonFormField<String>(
        value:
            _editedVoter.stayingLocation != null &&
                    _editedVoter.stayingLocation!.isNotEmpty &&
                    options.contains(_editedVoter.stayingLocation)
                ? _editedVoter.stayingLocation
                : null,
        items: [
          DropdownMenuItem<String>(value: null, child: Text(label)),
          ...options.map(
            (location) =>
                DropdownMenuItem(value: location, child: Text(location)),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _editedVoter = _updateVoter(stayingLocation: value);
          });
        },
        decoration: InputDecoration(
          labelText: isStateDropdown ? 'State' : 'Country',
          hintText: hint,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
      );
    } else {
      // For other types (like 'inside'), show textfield or hide
      return const SizedBox.shrink(); // Hide for 'inside' types
    }
  }

  String _getStayingStatusType(String? stayingStatus) {
    if (stayingStatus == null) return 'none';

    // You need to get the actual type from your bloc state
    // This is a placeholder - you'll need to adjust based on your actual data structure
    final context = this.context;
    final startupState = context.read<StartupBloc>().state;

    if (startupState is StartupSuccess) {
      final statusInfo = startupState.stayingStatus.firstWhere(
        (st) => st.name == stayingStatus,
        orElse:
            () => StayingStatus(
              name: '',
              type: 'none',
            ), // Adjust based on your actual model
      );

      return statusInfo.type;
    }

    // Fallback based on name if type is not available
    if (stayingStatus == 'INSIDE KERALA' ||
        stayingStatus == 'Inside Constituency') {
      return 'inside';
    } else if (stayingStatus == 'OUTSIDE KERALA') {
      return 'state';
    } else if (stayingStatus == 'ABROAD') {
      return 'country';
    }

    return 'none';
  }

  Widget _buildSaveButton() {
    return BlocConsumer<UpdateVoterBloc, UpdateVoterState>(
      listener: (context, state) {
        if (state is UpdateVoterSuccess) {
          BlocProvider.of<VotersListBloc>(
            context,
          ).add(ReplcaeVoterDetailsevent(voterDetails: _editedVoter));
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is UpdateVoterLoading) {
          return Util.shimmerCircle(size: 30);
        }
        return Center(
          child: ElevatedButton(
            onPressed: _saveVoterDetails,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            ),
            child: const Text('Save Changes', style: TextStyle(fontSize: 16)),
          ),
        );
      },
    );
  }

  void _saveVoterDetails() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      BlocProvider.of<UpdateVoterBloc>(
        context,
      ).add(UpdateVoterDetailsEvent(voterDetails: _editedVoter));
    }
  }
}
