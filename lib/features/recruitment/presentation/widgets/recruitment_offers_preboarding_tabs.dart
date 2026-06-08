import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/core/helpers/recruitment_helper.dart';
import 'package:gitakshmi_hrms_app/core/widgets/dropdown/app_dropdown_field.dart';
import 'package:gitakshmi_hrms_app/core/widgets/textfield/app_text_field.dart';

class RecruitmentOffersTab extends StatefulWidget {
  final RecruitmentHelper rHelper;
  final EmployeeModel activeEmp;
  final Color primaryColor;

  const RecruitmentOffersTab({
    super.key,
    required this.rHelper,
    required this.activeEmp,
    required this.primaryColor,
  });

  @override
  State<RecruitmentOffersTab> createState() => _RecruitmentOffersTabState();
}

class _RecruitmentOffersTabState extends State<RecruitmentOffersTab> {
  final _offerFormKey = GlobalKey<FormState>();
  final _negotiateFormKey = GlobalKey<FormState>();

  String? _offCandId;
  String _offDesignation = 'Flutter Developer';
  final String _offDept = 'Mobile Development';
  final String _offLocation = 'Ahmedabad HQ';
  String _offJoiningDate = '20-Jun-2026';
  final _offSalaryController = TextEditingController(text: '11 LPA');
  final _offBenefitsController = TextEditingController(text: 'Medical, Bonus');
  final String _offProbation = '6 Months';

  final _negSalaryController = TextEditingController();
  final _negDateController = TextEditingController();
  final _negRemarksController = TextEditingController();

  @override
  void dispose() {
    _offSalaryController.dispose();
    _offBenefitsController.dispose();
    _negSalaryController.dispose();
    _negDateController.dispose();
    _negRemarksController.dispose();
    super.dispose();
  }

  void _openReleaseOfferDialog() {
    final selectedCands = widget.rHelper.candidates.where((c) => c.status == 'Offer' || c.status == 'HR Round').toList();
    if (selectedCands.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No selected candidates pending offer letter release.')),
      );
      return;
    }
    _offCandId = selectedCands.first.id;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Draft Candidate Offer', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Form(
                  key: _offerFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppDropdownField<String>(
                  labelText: 'Select Selected Candidate',
                  value: _offCandId,
                  items: selectedCands.map((c) {
                          return DropdownMenuItem(value: c.id, child: Text(c.name));
                        }).toList(),
                  onChanged: (val) {
                          if (val != null) setDialogState(() => _offCandId = val);
                        },
                ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Offered Designation'),
                        onChanged: (v) => _offDesignation = v,
                      ),
                      const SizedBox(height: 10),
                      AppTextField(
                  controller: _offSalaryController,
                  labelText: 'Salary (e.g. 12 LPA)',
                ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Joining Date'),
                        onChanged: (v) => _offJoiningDate = v,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    widget.rHelper.releaseOffer(
                      candidateId: _offCandId!,
                      designation: _offDesignation,
                      department: _offDept,
                      location: _offLocation,
                      joiningDate: _offJoiningDate,
                      salary: _offSalaryController.text,
                      benefits: _offBenefitsController.text,
                      probation: _offProbation,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Create Offer Draft'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _openNegotiateFormDialog(OfferLetterModel offer) {
    _negSalaryController.text = offer.salary;
    _negDateController.text = offer.joiningDate;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Negotiate Offer parameters'),
          content: Form(
            key: _negotiateFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  controller: _negSalaryController,
                  labelText: 'Proposed Salary (CTC)',
                ),
                AppTextField(
                  controller: _negDateController,
                  labelText: 'Proposed Joining Date',
                ),
                AppTextField(
                  controller: _negRemarksController,
                  labelText: 'Candidate Reason / Justification',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                widget.rHelper.submitNegotiationRequest(
                  offerId: offer.id,
                  proposedSalary: _negSalaryController.text,
                  proposedDate: _negDateController.text,
                  remarks: _negRemarksController.text,
                );
                Navigator.pop(context);
              },
              child: const Text('Submit Negotiation'),
            ),
          ],
        );
      },
    );
  }

  void _showNegotiationLogsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Offer Negotiation Requests', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: double.maxFinite,
            child: widget.rHelper.negotiations.isEmpty
                ? const Center(child: Text('No negotiations requested.'))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.rHelper.negotiations.length,
                    itemBuilder: (context, idx) {
                      final neg = widget.rHelper.negotiations[idx];
                      final isPending = neg.status == 'Pending Review';
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(neg.candidateName, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('Original CTC: ${neg.originalCtc} → Proposed: ${neg.proposedCtc}', style: TextStyle(color: widget.primaryColor, fontWeight: FontWeight.bold)),
                              Text('Original Date: ${neg.originalJoiningDate} → Proposed: ${neg.proposedJoiningDate}'),
                              Text('Reason: "${neg.remarks}"', style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic)),
                              if (isPending) ...[
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.error), foregroundColor: AppColors.error),
                                      onPressed: () {
                                        widget.rHelper.respondNegotiation(neg.id, false);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Reject'),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                                      onPressed: () {
                                        widget.rHelper.respondNegotiation(neg.id, true);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Approve Revision'),
                                    ),
                                  ],
                                )
                              ] else ...[
                                const SizedBox(height: 4),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Chip(label: Text(neg.status, style: const TextStyle(fontSize: 9))),
                                )
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          ],
        );
      },
    );
  }

  void _showEsignatureAcceptDialog(OfferLetterModel offer) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('E-Signature Offer Acceptance', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please type your full name in the box below to sign the offer letter digitally:'),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Digital Signature Input'),
                initialValue: offer.candidateName,
              ),
              const SizedBox(height: 16),
              Container(
                height: 80,
                width: double.maxFinite,
                decoration: BoxDecoration(color: Colors.grey.shade50, border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid)),
                child: Center(
                  child: Text(
                    offer.candidateName,
                    style: const TextStyle(fontFamily: 'cursive', fontSize: 28, fontStyle: FontStyle.italic, color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                widget.rHelper.signOfferDigitally(offer.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Offer Accepted and E-Signed successfully!')),
                );
              },
              child: const Text('Confirm Acceptance'),
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
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.mail_rounded, color: Colors.white),
                  label: const Text('Generate Offer Letter', style: TextStyle(color: Colors.white)),
                  onPressed: _openReleaseOfferDialog,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(side: BorderSide(color: widget.primaryColor)),
                  icon: Icon(Icons.handshake_rounded, color: widget.primaryColor),
                  label: Text('Negotiation Logs (${widget.rHelper.negotiations.length})', style: TextStyle(color: widget.primaryColor)),
                  onPressed: _showNegotiationLogsDialog,
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.rHelper.offers.length,
            itemBuilder: (context, index) {
              final offer = widget.rHelper.offers[index];
              final isPending = offer.approvalStatus == 'Pending Approval';
              final currentApprover = offer.approvalFlow[offer.currentApprovalStep < offer.approvalFlow.length ? offer.currentApprovalStep : offer.approvalFlow.length - 1];

              bool canApproveOffer = false;
              if (isPending) {
                if (offer.currentApprovalStep == 0 && widget.activeEmp.roleId == 'r_manager') canApproveOffer = true;
                if (offer.currentApprovalStep == 1 && widget.activeEmp.roleId == 'r_hr') canApproveOffer = true;
                if (offer.currentApprovalStep == 2 && widget.activeEmp.roleId == 'r_finance') canApproveOffer = true;
                if (offer.currentApprovalStep == 3 && widget.activeEmp.roleId == 'r_admin') canApproveOffer = true;
                if (widget.activeEmp.roleId == 'r_admin') canApproveOffer = true;
              }

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
                          Text(offer.candidateName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Chip(label: Text(offer.approvalStatus, style: const TextStyle(fontSize: 10)), visualDensity: VisualDensity.compact),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('Designation: ${offer.designation} • Dept: ${offer.department}'),
                      Text('Offered CTC: ${offer.salary} • Location: ${offer.location}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      Text('Target Join Date: ${offer.joiningDate}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      const Divider(height: 20),
                      const Text('OFFER APPROVAL WORKFLOW:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textLight)),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(offer.approvalFlow.length, (idx) {
                          final step = offer.approvalFlow[idx];
                          final isDone = idx < offer.currentApprovalStep;
                          final isCurr = idx == offer.currentApprovalStep && isPending;
                          return Expanded(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: isDone ? Colors.green : isCurr ? Colors.amber : Colors.grey.shade200,
                                  child: isDone ? const Icon(Icons.check, size: 8, color: Colors.white) : Text((idx + 1).toString(), style: const TextStyle(fontSize: 8)),
                                ),
                                const SizedBox(width: 4),
                                Expanded(child: Text(step, style: TextStyle(fontSize: 8, fontWeight: isCurr ? FontWeight.bold : FontWeight.normal), maxLines: 1, overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          );
                        }),
                      ),
                      if (canApproveOffer) ...[
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                          onPressed: () => widget.rHelper.approveOffer(offer.id),
                          child: Text('Approve Offer Draft as $currentApprover'),
                        )
                      ],
                      if (offer.approvalStatus == 'Sent') ...[
                        const Divider(height: 20),
                        const Text('SIMULATE CANDIDATE PORTAL ACTION:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textLight)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(side: BorderSide(color: widget.primaryColor)),
                                onPressed: () => _openNegotiateFormDialog(offer),
                                child: const Text('Negotiate CTC'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.draw_rounded, size: 16, color: Colors.white),
                                label: const Text('E-Sign & Accept'),
                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                                onPressed: () => _showEsignatureAcceptDialog(offer),
                              ),
                            )
                          ],
                        )
                      ]
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

class RecruitmentPreboardingTab extends StatelessWidget {
  final RecruitmentHelper rHelper;
  final Color primaryColor;

  const RecruitmentPreboardingTab({
    super.key,
    required this.rHelper,
    required this.primaryColor,
  });

  Widget _buildBgvStatusTile(String candidateId, String title, String status, String field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 12)),
          DropdownButton<String>(
            value: status,
            items: ['Pending', 'Verified', 'Rejected'].map((s) => DropdownMenuItem(value: s, child: Text(s, style: TextStyle(fontSize: 11, color: s == 'Verified' ? Colors.green : s == 'Rejected' ? Colors.red : Colors.orange)))).toList(),
            onChanged: (val) {
              if (val != null) {
                rHelper.updateBGVCheck(candidateId, field, val);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'Monitor preboarding documents, emergency contacts and Background Verification (BGV) status of candidates.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rHelper.preJoiningPortals.length,
            itemBuilder: (context, index) {
              final portal = rHelper.preJoiningPortals[index];
              final cand = rHelper.candidates.firstWhere((c) => c.id == portal.candidateId, orElse: () => rHelper.candidates.first);
              final bgv = rHelper.bgvChecks.firstWhere((b) => b.candidateId == cand.id, orElse: () => BGVTrackerModel(candidateId: cand.id, candidateName: cand.name));

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(cand.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('Portal Code: ${portal.portalAccessCode}', style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text('BACKGROUND VERIFICATION (BGV)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.textLight)),
                      const SizedBox(height: 6),
                      _buildBgvStatusTile(cand.id, 'Employment History', bgv.employmentStatus, 'Employment'),
                      _buildBgvStatusTile(cand.id, 'Educational Credentials', bgv.educationStatus, 'Education'),
                      _buildBgvStatusTile(cand.id, 'Identity (Aadhar/PAN)', bgv.identityStatus, 'Identity'),
                      const SizedBox(height: 12),

                      const Text('CANDIDATE DOCUMENTS CHECKLIST', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.textLight)),
                      const SizedBox(height: 6),
                      ...portal.uploadedDocuments.entries.map((doc) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(doc.key, style: const TextStyle(fontSize: 12)),
                          Switch(
                            value: doc.value,
                            activeColor: primaryColor,
                            onChanged: (val) {
                              rHelper.updatePreJoiningDoc(cand.id, doc.key, val);
                            },
                          ),
                        ],
                      )),
                      const Divider(),
                      const Text('JOINING READY PROCESS CHECK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.textLight)),
                      ...portal.joiningChecklist.entries.map((chk) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(chk.key, style: const TextStyle(fontSize: 12)),
                          Switch(
                            value: chk.value,
                            activeColor: primaryColor,
                            onChanged: (val) {
                              rHelper.verifyPreJoiningChecklist(cand.id, chk.key, val);
                            },
                          ),
                        ],
                      )),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                        icon: const Icon(Icons.person_add_rounded, color: Colors.white),
                        label: const Text('Confirm Joining & Create Employee'),
                        onPressed: () {
                          rHelper.completeJoiningAndOnboard(cand.id, 'Engineering', 'r_employee', 'Riya Sharma');
                        },
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
