import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/recruitment_helper.dart';
import 'package:gitakshmi_hrms_app/core/widgets/dropdown/app_dropdown_field.dart';
import 'package:gitakshmi_hrms_app/core/widgets/textfield/app_text_field.dart';

class RecruitmentDashboardTab extends StatelessWidget {
  final RecruitmentHelper rHelper;
  final Color primaryColor;

  const RecruitmentDashboardTab({
    super.key,
    required this.rHelper,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final activeJobs = rHelper.openings.where((o) => o.status == 'Open').length;
    final totalCands = rHelper.candidates.length;
    final scheduledInts = rHelper.interviews.where((i) => i.feedback == null).length;
    final joined = rHelper.candidates.where((c) => c.status == 'Joined').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.6,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              _buildStatCard('Positions Open', activeJobs.toString(), Icons.work_outline_rounded, Colors.blue),
              _buildStatCard('Total Candidates', totalCands.toString(), Icons.people_outline_rounded, Colors.purple),
              _buildStatCard('Interviews Scheduled', scheduledInts.toString(), Icons.video_call_outlined, Colors.orange),
              _buildStatCard('Joined Hires', joined.toString(), Icons.check_circle_outline_rounded, Colors.green),
            ],
          ),
          const SizedBox(height: 16),

          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Recruitment Budget Tracking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Budget Allocated:', style: TextStyle(color: AppColors.textSecondary)),
                      Text('₹${(rHelper.budgetAllocated / 100000).toStringAsFixed(1)} Lakh', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Used Budget (Hiring Cost):', style: TextStyle(color: AppColors.textSecondary)),
                      Text('₹${(rHelper.budgetUsed / 100000).toStringAsFixed(1)} Lakh', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.error)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: rHelper.budgetUsed / rHelper.budgetAllocated,
                    color: AppColors.error,
                    backgroundColor: Colors.grey.shade100,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Budget Utilization: ${((rHelper.budgetUsed / rHelper.budgetAllocated) * 100).toInt()}%',
                    style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.textLight),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Text('Recruiter Activity Feeds', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rHelper.notifications.length > 5 ? 5 : rHelper.notifications.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  dense: true,
                  leading: Icon(Icons.circle_notifications_rounded, color: primaryColor),
                  title: Text(rHelper.notifications[index], style: const TextStyle(fontSize: 12)),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade100)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                Icon(icon, color: color, size: 18),
              ],
            ),
            Text(count, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}

class RecruitmentWorkforceTab extends StatefulWidget {
  final RecruitmentHelper rHelper;
  final Color primaryColor;

  const RecruitmentWorkforceTab({
    super.key,
    required this.rHelper,
    required this.primaryColor,
  });

  @override
  State<RecruitmentWorkforceTab> createState() => _RecruitmentWorkforceTabState();
}

class _RecruitmentWorkforceTabState extends State<RecruitmentWorkforceTab> {
  final _workforceFormKey = GlobalKey<FormState>();

  String _wpDept = 'Mobile Development';
  String _wpDesignation = '';
  int _wpReqHc = 5;
  int _wpCurHc = 2;
  final _wpBudgetController = TextEditingController(text: '₹15 Lakh');
  String _wpQuarter = 'Q3';

  @override
  void dispose() {
    _wpBudgetController.dispose();
    super.dispose();
  }

  void _openWorkforcePlanDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Add Manpower Forecast', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Form(
                  key: _workforceFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppDropdownField<String>(
                  labelText: 'Department',
                  value: _wpDept,
                  items: ['Mobile Development', 'Product & Engineering', 'Product & Design', 'Sales', 'HR'].map((d) {
                          return DropdownMenuItem(value: d, child: Text(d));
                        }).toList(),
                  onChanged: (val) {
                          if (val != null) setDialogState(() => _wpDept = val);
                        },
                ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Designation'),
                        onChanged: (v) => _wpDesignation = v,
                        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(labelText: 'Target Headcount'),
                              keyboardType: TextInputType.number,
                              onChanged: (v) => _wpReqHc = int.tryParse(v) ?? 5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(labelText: 'Current Headcount'),
                              keyboardType: TextInputType.number,
                              onChanged: (v) => _wpCurHc = int.tryParse(v) ?? 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      AppTextField(
                  controller: _wpBudgetController,
                  labelText: 'Allocated Budget (e.g. ₹20 Lakh)',
                ),
                      const SizedBox(height: 10),
                      AppDropdownField<String>(
                  labelText: 'Target Quarter',
                  value: _wpQuarter,
                  items: ['Q1', 'Q2', 'Q3', 'Q4'].map((q) => DropdownMenuItem(value: q, child: Text(q))).toList(),
                  onChanged: (val) {
                          if (val != null) setDialogState(() => _wpQuarter = val);
                        },
                ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    if (_workforceFormKey.currentState?.validate() ?? false) {
                      widget.rHelper.addWorkforcePlan(
                        department: _wpDept,
                        designation: _wpDesignation,
                        requiredHc: _wpReqHc,
                        currentHc: _wpCurHc,
                        budget: _wpBudgetController.text,
                        quarter: _wpQuarter,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save Forecast'),
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
            icon: const Icon(Icons.add_chart_rounded, color: Colors.white),
            label: const Text('Add Headcount Forecast', style: TextStyle(color: Colors.white)),
            onPressed: _openWorkforcePlanDialog,
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.rHelper.workforcePlans.length,
            itemBuilder: (context, index) {
              final plan = widget.rHelper.workforcePlans[index];
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
                          Text(plan.designation, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Chip(label: Text('${plan.quarter} - ${plan.financialYear}', style: const TextStyle(fontSize: 9)), visualDensity: VisualDensity.compact),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('Department: ${plan.department} • Allocated Budget: ${plan.budget}'),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Target Headcount: ${plan.requiredHeadcount}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          Text('Current: ${plan.currentHeadcount}', style: const TextStyle(fontSize: 12)),
                          Text('Vacancy: ${plan.vacancy}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: widget.primaryColor)),
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
