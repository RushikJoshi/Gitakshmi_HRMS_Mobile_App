import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/features/expense/presentation/widgets/expense_status_chip.dart';
import 'package:gitakshmi_hrms_app/core/widgets/dropdown/app_dropdown_field.dart';
import 'package:gitakshmi_hrms_app/core/widgets/textfield/app_text_field.dart';

class AdvanceTab extends StatefulWidget {
  final RolePermissionHelper helper;
  final Color primaryColor;

  const AdvanceTab({
    super.key,
    required this.helper,
    required this.primaryColor,
  });

  @override
  State<AdvanceTab> createState() => _AdvanceTabState();
}

class _AdvanceTabState extends State<AdvanceTab> {
  String _advType = 'Business Trip';
  final _advPurposeCtrl = TextEditingController();
  final _advAmountCtrl = TextEditingController();
  final _advDateCtrl = TextEditingController(text: '20 Jun 2026');
  final _settleAmountCtrl = TextEditingController();

  @override
  void dispose() {
    _advPurposeCtrl.dispose();
    _advAmountCtrl.dispose();
    _advDateCtrl.dispose();
    _settleAmountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myAdvances = widget.helper.advanceRequests
        .where((a) => a.employeeId == widget.helper.activeEmployeeId)
        .toList();
    final approvedAdvances = widget.helper.advanceRequests
        .where((a) => a.employeeId == widget.helper.activeEmployeeId && a.status == 'Approved')
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Request Form
          const Text('New Advance Request', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          AppDropdownField<String>(
                  labelText: 'Advance Type',
                  value: _advType,
                  items: ['Business Trip', 'Conference', 'Client Visit', 'Field Travel', 'Training', 'Other']
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
                  onChanged: (v) => setState(() => _advType = v ?? _advType),
                ),
          const SizedBox(height: 10),
                    AppTextField(
            controller: _advPurposeCtrl,
            labelText: 'Purpose / Description',
            maxLines: 2,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _advAmountCtrl,
                  keyboardType: TextInputType.number,
                  labelText: 'Requested Amount (₹)',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppTextField(
                  controller: _advDateCtrl,
                  labelText: 'Expected Trip Date',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: widget.primaryColor, padding: const EdgeInsets.symmetric(vertical: 13)),
            icon: const Icon(Icons.send_rounded, color: Colors.white),
            label: const Text('Submit Advance Request', style: TextStyle(color: Colors.white)),
            onPressed: () {
              final amt = double.tryParse(_advAmountCtrl.text.trim());
              if (amt == null || amt <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid amount.')));
                return;
              }
              widget.helper.createAdvanceRequest(
                type: _advType,
                purpose: _advPurposeCtrl.text.trim(),
                amount: amt,
                expectedDate: _advDateCtrl.text.trim(),
              );
              _advPurposeCtrl.clear();
              _advAmountCtrl.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Advance request submitted!'), backgroundColor: Colors.green),
              );
            },
          ),

          // Settlement section
          if (approvedAdvances.isNotEmpty) ...[
            const SizedBox(height: 24),
            const Text('Settle Advance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            ...approvedAdvances.map(
              (adv) => Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${adv.type} — ${adv.purpose}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text('Disbursed: ₹${adv.disbursedAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, color: Colors.green)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _settleAmountCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Actual Expense Amount (₹)',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                        onPressed: () {
                          final actual = double.tryParse(_settleAmountCtrl.text.trim());
                          if (actual == null) return;
                          widget.helper.settleAdvance(adv.id, actual);
                          _settleAmountCtrl.clear();
                          final surplus = adv.disbursedAmount - actual;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                surplus > 0 ? 'Settled! Return ₹${surplus.toStringAsFixed(0)} to finance.' : 'Settled! No surplus.',
                              ),
                              backgroundColor: Colors.teal,
                            ),
                          );
                        },
                        child: const Text('Submit Settlement', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],

          // All advances list
          const SizedBox(height: 24),
          const Text('My Advance History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          if (myAdvances.isEmpty)
            const Text('No advance requests found.', style: TextStyle(color: AppColors.textSecondary))
          else
            ...myAdvances.map(
              (adv) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text(adv.type, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
                          ExpenseStatusChip(label: adv.status, status: adv.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(adv.purpose, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      const Divider(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Requested: ₹${adv.requestedAmount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 11)),
                              if (adv.disbursedAmount > 0)
                                Text(
                                  'Disbursed: ₹${adv.disbursedAmount.toStringAsFixed(0)}',
                                  style: const TextStyle(fontSize: 11, color: Colors.green),
                                ),
                              if (adv.status == 'Settled')
                                Text(
                                  'Return: ₹${adv.settlementAmount.toStringAsFixed(0)}',
                                  style: const TextStyle(fontSize: 11, color: Colors.teal),
                                ),
                            ],
                          ),
                          Text(adv.requestDate, style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
