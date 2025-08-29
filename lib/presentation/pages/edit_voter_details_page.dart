import 'package:election_mantra/api/models/staying_status.dart';
import 'package:election_mantra/api/models/voter_cocern.dart';
import 'package:election_mantra/api/models/voter_details.dart';
import 'package:election_mantra/core/constant/palette.dart';
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

class EditVoterDetailsPage extends StatefulWidget {
  final VoterDetails voter;

  const EditVoterDetailsPage({super.key, required this.voter});

  @override
  State<EditVoterDetailsPage> createState() => _EditVoterDetailsPageState();
}

class _EditVoterDetailsPageState extends State<EditVoterDetailsPage> {
  late VoterDetails _editedVoter;
  final _formKey = GlobalKey<FormState>();
  late LoginSuccessState _loginSuccessState;

  @override
  void initState() {
    super.initState();
    _editedVoter = widget.voter;
    _loginSuccessState = context.read<LoginBloc>().state as LoginSuccessState;
  }

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
          '${_loginSuccessState.user.name}:${_loginSuccessState.user.id}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildSaveButton(),
      ),
      appBar: AppBar(
        foregroundColor: Palette.textPrimary,
        backgroundColor: Palette.primary,
        title:  Text('Edit Voter Record',
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(

          color: Palette.textPrimary
        ),
        ),
      
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Party',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            BlocBuilder<PartyListBloc, PartyListState>(
              builder: (context, partyState) {
                if (partyState is PartyListSuccess) {
                  return ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 50),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          partyState.politicalGroups
                              .map(
                                (party) =>
                                    _buildPartyChip(party.name, party.color),
                              )
                              .toList(),
                    ),
                  );
                }
                return Util.shimmerBox(height: 10);
              },
            ),
            const SizedBox(height: 25),
            const Text(
              'Sure Vote',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 50),
              child: Row(
                children: [
                  _buildSureVoteButton('Yes'),
                  const SizedBox(width: 8.0),
                  _buildSureVoteButton('Doubtful'),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Vote Type',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            BlocBuilder<StartupBloc, StartupState>(
              builder: (context, startupState) {
                if (startupState is StartupSuccess) {
                  return ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 50),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          startupState.voterType
                              .map((vtype) => _buildVoteTypeBox(vtype.name))
                              .toList(),
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            const Text(
              'Religion',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            BlocBuilder<ReligionBloc, ReligionState>(
              builder: (context, religionState) {
                if (religionState is ReligionSuccess) {
                  return ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 50),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          religionState.religions
                              .map(
                                (r) => _buildReligionChip(
                                  r.name,
                                  r.value,
                                  r.color,
                                ),
                              )
                              .toList(),
                    ),
                  );
                }
                return Util.shimmerBox(height: 10);
              },
            ),
            const SizedBox(height: 25),
            const Text(
              'Caste',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            BlocBuilder<ReligionBloc, ReligionState>(
              builder: (context, religionState) {
                if (religionState is ReligionSuccess) {
                  final selectedReligion = religionState.religions.firstWhere(
                    (r) => r.value == _editedVoter.religion,
                    orElse: () => religionState.religions.first,
                  );

                  final casteOptions = selectedReligion.castes;

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
                    isExpanded: true,
                    hint: const Text(
                      'Select Caste (Optional)',
                      style: TextStyle(color: Colors.grey),
                    ),
                    items:
                        casteOptions
                            .map(
                              (caste) => DropdownMenuItem(
                                value: caste,
                                child: Text(
                                  caste.toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        _editedVoter = _updateVoter(caste: value);
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Select Caste (Optional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    dropdownColor: Colors.white,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            const Text(
              'Education',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
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
                    decoration: InputDecoration(
                      hintText: 'Select One',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  );
                }
                return Util.shimmerBox(height: 10);
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Occupation',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
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
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
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
              decoration: InputDecoration(
                labelText: 'Influencer',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Staying Status',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 100),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 2.5,
                          ),
                      itemCount: state.stayingStatus.length,
                      itemBuilder: (context, index) {
                        final st = state.stayingStatus[index];
                        final isSelected =
                            _editedVoter.stayingStatus == st.name;

                        return _buildStayingStatusBox(st, isSelected);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStayingLocationField(),
                  const SizedBox(height: 20),
                  const Text(
                    'Voter Concern',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 100),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 2.5,
                          ),
                      itemCount: state.voterConcern.length,
                      itemBuilder: (context, index) {
                        final vc = state.voterConcern[index];
                        final isSelected = _editedVoter.voterConcern == vc.name;

                        return _buildVoterConcernBox(vc, isSelected);
                      },
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

  Widget _buildVoterConcernBox(VoterConcern vc, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _editedVoter = _updateVoter(voterConcern: vc.name);
        });
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: 1.5,
          ),
        ),
        child: Text(
          vc.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildStayingStatusBox(StayingStatus st, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _editedVoter = _updateVoter(
            stayingStatus: st.name,
            stayingLocation: null,
          );
        });
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: 1.5,
          ),
        ),
        child: Text(
          st.name,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
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

  Widget _buildPartyChip(String party, String color) {
    final isSelected = _editedVoter.party == party;

    return ChoiceChip(
      checkmarkColor: Palette.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      label: Text(
        party,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.white : Colors.black87,
        ),
      ),
      selectedColor: Util.hexToColor(color),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _editedVoter = _updateVoter(party: party);
          });
        }
      },
      labelPadding: const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
    );
  }

  Widget _buildSureVoteButton(String label) {
    final isSelected =
        (label == 'Yes') ? _editedVoter.isSureVote : !_editedVoter.isSureVote;

    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Palette.accentTeal : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () {
          setState(() {
            _editedVoter = _updateVoter(isSureVote: label == 'Yes');
          });
        },
        child: Text(label, textAlign: TextAlign.center),
      ),
    );
  }

  Widget _buildVoteTypeBox(String voteType) {
    final isSelected = _editedVoter.voteType == voteType;

    return InkWell(
      onTap: () {
        setState(() {
          _editedVoter = _updateVoter(voteType: voteType);
        });
      },
      child: Container(
        width: 100,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? Palette.accentTeal : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              voteType.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReligionChip(String religion, String value, String color) {
    return BlocBuilder<ReligionBloc, ReligionState>(
      builder: (context, religionState) {
        if (religionState is ReligionSuccess) {
          final selectedReligion = religionState.religions.firstWhere(
            (r) => r.value == value,
            orElse: () => religionState.religions.first,
          );

          final hasCastes = selectedReligion.castes.isNotEmpty;

          return ChoiceChip(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: Text(
                religion.toUpperCase(),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color:
                      _editedVoter.religion == value
                          ? Colors.white
                          : Colors.black,
                ),
              ),
            ),
            selectedColor: Util.hexToColor(color),
            selected: _editedVoter.religion == value,
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  if (hasCastes) {
                    _editedVoter = _updateVoter(religion: value, caste: null);
                  } else {
                    _editedVoter = _updateVoter(religion: value, caste: '');
                  }
                });
              }
            },
            labelPadding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 0,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      label: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          occupation,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color:
                _editedVoter.occupation == occupation
                    ? Colors.white
                    : Colors.black,
          ),
        ),
      ),
      selectedColor: Colors.deepPurpleAccent,
      selected: _editedVoter.occupation == occupation,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _editedVoter = _updateVoter(occupation: occupation);
          });
        }
      },
      labelPadding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    );
  }

  Widget _buildStayingLocationField() {
    final stayingStatus = _editedVoter.stayingStatus;
    final stayingStatusType = _getStayingStatusType(stayingStatus);

    if (stayingStatusType == 'none') {
      return const SizedBox.shrink();
    }

    if (stayingStatusType == 'state' || stayingStatusType == 'country') {
      final isStateDropdown = stayingStatusType == 'state';
      final options =
          isStateDropdown ? LocalData.indianStates : LocalData.countries;
      final label = isStateDropdown ? 'Select State' : 'Select Country';

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
          hintText: isStateDropdown ? 'Select Indian State' : 'Select Country',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  String _getStayingStatusType(String? stayingStatus) {
    if (stayingStatus == null) return 'none';

    final startupState = context.read<StartupBloc>().state;

    if (startupState is StartupSuccess) {
      final statusInfo = startupState.stayingStatus.firstWhere(
        (st) => st.name == stayingStatus,
        orElse: () => StayingStatus(name: '', type: 'none'),
      );

      return statusInfo.type;
    }

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
          context.read<VotersListBloc>().add(
            ReplcaeVoterDetailsevent(voterDetails: _editedVoter),
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        if (state is UpdateVoterLoading) {
          return Util.shimmerCircle(size: 30);
        }
        return ElevatedButton(
          onPressed: _saveVoterDetails,
          style: ElevatedButton.styleFrom(
            backgroundColor: Palette.accentTeal,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          ),
          child: const Text(
            'Save Changes',
            style: TextStyle(fontSize: 16, color: Palette.white),
          ),
        );
      },
    );
  }

  void _saveVoterDetails() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.read<UpdateVoterBloc>().add(
        UpdateVoterDetailsEvent(voterDetails: _editedVoter),
      );
    }
  }
}
