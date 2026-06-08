import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/recruitment_helper.dart';
import 'package:gitakshmi_hrms_app/core/widgets/dropdown/app_dropdown_field.dart';
import 'package:gitakshmi_hrms_app/core/widgets/textfield/app_text_field.dart';

class RecruitmentCampusTab extends StatefulWidget {
  final RecruitmentHelper rHelper;
  final Color primaryColor;

  const RecruitmentCampusTab({
    super.key,
    required this.rHelper,
    required this.primaryColor,
  });

  @override
  State<RecruitmentCampusTab> createState() => _RecruitmentCampusTabState();
}

class _RecruitmentCampusTabState extends State<RecruitmentCampusTab> {
  final _campusFormKey = GlobalKey<FormState>();

  final _cCollegeController = TextEditingController();
  final _cPositionController = TextEditingController();
  int _cRegistered = 50;
  final _cContactController = TextEditingController();

  @override
  void dispose() {
    _cCollegeController.dispose();
    _cPositionController.dispose();
    _cContactController.dispose();
    super.dispose();
  }

  void _openCampusEventDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Schedule College Campus Event'),
              content: Form(
                key: _campusFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppTextField(
                  controller: _cCollegeController,
                  labelText: 'College Name',
                ),
                    AppTextField(
                  controller: _cPositionController,
                  labelText: 'Job Title / Internship',
                ),
                    AppTextField(
                  controller: _cContactController,
                  labelText: 'College Placement Lead Contact',
                ),
                    AppDropdownField<int>(
                  labelText: 'Estimated Registrations',
                  value: _cRegistered,
                  items: [50, 100, 200, 300].map((v) => DropdownMenuItem(value: v, child: Text(v.toString()))).toList(),
                  onChanged: (val) {
                        if (val != null) setDialogState(() => _cRegistered = val);
                      },
                )
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    widget.rHelper.addCampusEvent(
                      college: _cCollegeController.text,
                      position: _cPositionController.text,
                      registered: _cRegistered,
                      contact: _cContactController.text,
                    );
                    Navigator.pop(context);
                    _cCollegeController.clear();
                    _cPositionController.clear();
                    _cContactController.clear();
                  },
                  child: const Text('Schedule Event'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            icon: const Icon(Icons.school_rounded, color: Colors.white),
            label: const Text('Schedule Campus Placement Event'),
            onPressed: _openCampusEventDialog,
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.rHelper.campusEvents.length,
            itemBuilder: (context, index) {
              final ev = widget.rHelper.campusEvents[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(ev.collegeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Chip(label: Text(ev.status, style: const TextStyle(fontSize: 9)), visualDensity: VisualDensity.compact),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('Target Position: ${ev.positionTitle}'),
                      Text('Contact: ${ev.contactPerson}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Registered Students: ${ev.registeredCount}', style: const TextStyle(fontSize: 11)),
                          Text('Shortlisted: ${ev.shortListedCount}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          Text('Offers: ${ev.offersReleasedCount}', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: widget.primaryColor)),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

class RecruitmentReferralTab extends StatefulWidget {
  final RecruitmentHelper rHelper;
  final Color primaryColor;

  const RecruitmentReferralTab({
    super.key,
    required this.rHelper,
    required this.primaryColor,
  });

  @override
  State<RecruitmentReferralTab> createState() => _RecruitmentReferralTabState();
}

class _RecruitmentReferralTabState extends State<RecruitmentReferralTab> {
  final _referralFormKey = GlobalKey<FormState>();

  final _refCandNameController = TextEditingController();
  final _refPosController = TextEditingController();
  final _refReferrerController = TextEditingController();

  @override
  void dispose() {
    _refCandNameController.dispose();
    _refPosController.dispose();
    _refReferrerController.dispose();
    super.dispose();
  }

  void _openReferralFormDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Submit Candidate Referral'),
          content: Form(
            key: _referralFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  controller: _refCandNameController,
                  labelText: 'Candidate Full Name',
                ),
                AppTextField(
                  controller: _refPosController,
                  labelText: 'Designation',
                ),
                AppTextField(
                  controller: _refReferrerController,
                  labelText: 'Referred By (Your Name)',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                widget.rHelper.submitReferral(
                  name: _refCandNameController.text,
                  position: _refPosController.text,
                  resume: 'referred_cv.pdf',
                  referrer: _refReferrerController.text,
                );
                Navigator.pop(context);
                _refCandNameController.clear();
                _refPosController.clear();
                _refReferrerController.clear();
              },
              child: const Text('Submit Referral'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            label: const Text('Submit Referral Entry', style: TextStyle(color: Colors.white)),
            onPressed: _openReferralFormDialog,
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.rHelper.referrals.length,
            itemBuilder: (context, index) {
              final ref = widget.rHelper.referrals[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: widget.primaryColor.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12)),
                        child: Icon(Icons.people_rounded, color: widget.primaryColor, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ref.candidateName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text('Position: ${ref.positionTitle}'),
                            Text('Referred by: ${ref.referredBy}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                            child: Text('₹${ref.bonusAmount.toInt()}', style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 4),
                          Text('Status: ${ref.bonusStatus}', style: const TextStyle(fontSize: 9, color: AppColors.textLight)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class RecruitmentTalentPoolTab extends StatelessWidget {
  final RecruitmentHelper rHelper;
  final Color primaryColor;

  const RecruitmentTalentPoolTab({
    super.key,
    required this.rHelper,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final pool = rHelper.talentPool;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.grey.shade50,
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Talent Pool contains candidates archived during screening or loops for future open job vacancies.',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: pool.isEmpty
              ? const Center(child: Text('No archived candidates in Talent Pool.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pool.length,
                  itemBuilder: (context, index) {
                    final cand = pool[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(backgroundColor: Colors.grey.shade200, child: const Icon(Icons.archive_rounded, color: Colors.grey)),
                        title: Text(cand.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Skills: ${cand.skills.join(", ")}'),
                            Text('Source: ${cand.source} • Exp: ${cand.experience} yrs', style: const TextStyle(fontSize: 11)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
