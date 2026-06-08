import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/recruitment_helper.dart';
import 'package:gitakshmi_hrms_app/core/widgets/dropdown/app_dropdown_field.dart';
import 'package:gitakshmi_hrms_app/core/widgets/textfield/app_text_field.dart';

class RecruitmentPipelineTab extends StatefulWidget {
  final RecruitmentHelper rHelper;
  final Color primaryColor;

  const RecruitmentPipelineTab({
    super.key,
    required this.rHelper,
    required this.primaryColor,
  });

  @override
  State<RecruitmentPipelineTab> createState() => _RecruitmentPipelineTabState();
}

class _RecruitmentPipelineTabState extends State<RecruitmentPipelineTab> {
  final List<String> _selectedCompareIds = [];

  void _showComparisonMatrixDialog() {
    final candsToCompare = widget.rHelper.candidates.where((c) => _selectedCompareIds.contains(c.id)).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Candidate Comparison Matrix', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Metric')),
                DataColumn(label: Text('Candidate 1')),
                DataColumn(label: Text('Candidate 2')),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('Name')),
                  ...candsToCompare.map((c) => DataCell(Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)))),
                  if (candsToCompare.length < 2) const DataCell(Text('—')),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Exp (Yrs)')),
                  ...candsToCompare.map((c) => DataCell(Text(c.experience.toString()))),
                  if (candsToCompare.length < 2) const DataCell(Text('—')),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Skills')),
                  ...candsToCompare.map((c) => DataCell(Text(c.skills.join(", ")))),
                  if (candsToCompare.length < 2) const DataCell(Text('—')),
                ]),
                DataRow(cells: [
                  const DataCell(Text('AI Match Score')),
                  ...candsToCompare.map((c) => DataCell(Text('${c.aiMatchScore}%', style: TextStyle(color: widget.primaryColor, fontWeight: FontWeight.bold)))),
                  if (candsToCompare.length < 2) const DataCell(Text('—')),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Expected CTC')),
                  ...candsToCompare.map((c) => DataCell(Text(c.expectedSalary))),
                  if (candsToCompare.length < 2) const DataCell(Text('—')),
                ]),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final stages = ['Applied', 'Screening', 'Assessment', 'Technical Round', 'Manager Round', 'HR Round', 'Offer', 'Joined'];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.grey.shade50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Visual ATS Kanban Pipeline', style: TextStyle(fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                icon: const Icon(Icons.compare_arrows_rounded, size: 16, color: Colors.white),
                label: Text('Compare Candidates (${_selectedCompareIds.length})'),
                onPressed: () {
                  if (_selectedCompareIds.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select at least 1 candidate to compare.')),
                    );
                    return;
                  }
                  _showComparisonMatrixDialog();
                },
              )
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            itemCount: stages.length,
            itemBuilder: (context, sIdx) {
              final stage = stages[sIdx];
              final stageCands = widget.rHelper.candidates.where((c) => c.status == stage).toList();

              return Container(
                width: 250,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: widget.primaryColor.withValues(alpha: 0.1),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(stage, style: TextStyle(fontWeight: FontWeight.bold, color: widget.primaryColor)),
                          CircleAvatar(radius: 10, backgroundColor: widget.primaryColor, child: Text(stageCands.length.toString(), style: const TextStyle(color: Colors.white, fontSize: 10))),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: stageCands.length,
                        itemBuilder: (context, cIdx) {
                          final cand = stageCands[cIdx];
                          final isSelected = _selectedCompareIds.contains(cand.id);

                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: Text(cand.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                                      Checkbox(
                                        value: isSelected,
                                        onChanged: (val) {
                                          setState(() {
                                            if (val == true) {
                                              _selectedCompareIds.add(cand.id);
                                            } else {
                                              _selectedCompareIds.remove(cand.id);
                                            }
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                  Text('Exp: ${cand.experience} Yrs • AI Fit: ${cand.aiMatchScore}%', style: TextStyle(fontSize: 11, color: widget.primaryColor, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  if (sIdx < stages.length - 1)
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton.icon(
                                        style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                                        icon: const Icon(Icons.arrow_forward, size: 12),
                                        label: const Text('Promote', style: TextStyle(fontSize: 10)),
                                        onPressed: () {
                                          widget.rHelper.updateCandidateStage(cand.id, stages[sIdx + 1]);
                                        },
                                      ),
                                    )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class RecruitmentScreeningTab extends StatefulWidget {
  final RecruitmentHelper rHelper;
  final bool isHR;
  final Color primaryColor;

  const RecruitmentScreeningTab({
    super.key,
    required this.rHelper,
    required this.isHR,
    required this.primaryColor,
  });

  @override
  State<RecruitmentScreeningTab> createState() => _RecruitmentScreeningTabState();
}

class _RecruitmentScreeningTabState extends State<RecruitmentScreeningTab> {
  final _screeningFormKey = GlobalKey<FormState>();

  double _scrComm = 4.0;
  double _scrTech = 4.0;
  double _scrSal = 4.0;
  String _scrNotice = '30 Days';
  String _scrResult = 'Qualified';
  final _scrRemarksController = TextEditingController();

  @override
  void dispose() {
    _scrRemarksController.dispose();
    super.dispose();
  }

  void _openScreeningFormDialog(CandidateModel cand) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text('Screening: ${cand.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Form(
                  key: _screeningFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Communication:'),
                          DropdownButton<double>(
                            value: _scrComm,
                            items: [1.0, 2.0, 3.0, 4.0, 5.0].map((v) => DropdownMenuItem(value: v, child: Text(v.toString()))).toList(),
                            onChanged: (val) {
                              if (val != null) setDialogState(() => _scrComm = val);
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Technical alignment:'),
                          DropdownButton<double>(
                            value: _scrTech,
                            items: [1.0, 2.0, 3.0, 4.0, 5.0].map((v) => DropdownMenuItem(value: v, child: Text(v.toString()))).toList(),
                            onChanged: (val) {
                              if (val != null) setDialogState(() => _scrTech = val);
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Salary Budget Fit:'),
                          DropdownButton<double>(
                            value: _scrSal,
                            items: [1.0, 2.0, 3.0, 4.0, 5.0].map((v) => DropdownMenuItem(value: v, child: Text(v.toString()))).toList(),
                            onChanged: (val) {
                              if (val != null) setDialogState(() => _scrSal = val);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Notice Period (e.g. 15 Days)'),
                        onChanged: (v) => _scrNotice = v,
                      ),
                      const SizedBox(height: 10),
                      AppDropdownField<String>(
                  labelText: 'Recommendation',
                  value: _scrResult,
                  items: ['Qualified', 'Hold', 'Rejected'].map((r) {
                          return DropdownMenuItem(value: r, child: Text(r));
                        }).toList(),
                  onChanged: (val) {
                          if (val != null) setDialogState(() => _scrResult = val);
                        },
                ),
                      const SizedBox(height: 10),
                      AppTextField(
                  controller: _scrRemarksController,
                  labelText: 'HR Screening Remarks',
                ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    final double avg = (_scrComm + _scrTech + _scrSal) / 3.0;
                    widget.rHelper.submitScreeningFeedback(
                      cand.id,
                      ScreeningFormModel(
                        communicationRating: _scrComm,
                        technicalFitRating: _scrTech,
                        salaryFitRating: _scrSal,
                        noticePeriod: _scrNotice,
                        overallRating: avg,
                        result: _scrResult,
                        hrRemarks: _scrRemarksController.text,
                      ),
                    );
                    Navigator.pop(context);
                    _scrRemarksController.clear();
                  },
                  child: const Text('Save Screening'),
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
    final appliedCands = widget.rHelper.candidates.where((c) => c.status == 'Applied' || c.status == 'Screening').toList();

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'HR Screening evaluation queue. Score communication, cultural fit, salary fit and location alignment below.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ),
        const Divider(),
        Expanded(
          child: appliedCands.isEmpty
              ? const Center(child: Text('No candidates pending initial HR screening.'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: appliedCands.length,
                  itemBuilder: (context, index) {
                    final cand = appliedCands[index];
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
                                Text(cand.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: widget.primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                                  child: Text('AI Fit: ${cand.aiMatchScore}%', style: TextStyle(color: widget.primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text('Current Company: ${cand.currentCompany} • Exp: ${cand.experience} Yrs'),
                            Text('Current CTC: ${cand.currentSalary} • Expected: ${cand.expectedSalary}'),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              color: Colors.grey.shade50,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.psychology_rounded, size: 14, color: widget.primaryColor),
                                      const SizedBox(width: 4),
                                      const Text('AI Suggested Screen Questions:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  ...cand.suggestedQuestions.map((q) => Text('• $q', style: const TextStyle(fontSize: 9, color: AppColors.textSecondary))),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.rate_review_rounded, size: 16, color: Colors.white),
                              label: const Text('Evaluate Screening Form', style: TextStyle(color: Colors.white)),
                              onPressed: () => _openScreeningFormDialog(cand),
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
