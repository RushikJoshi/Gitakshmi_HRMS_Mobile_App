import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/core/widgets/dropdown/app_dropdown_field.dart';
import 'package:gitakshmi_hrms_app/core/widgets/textfield/app_text_field.dart';

class NewClaimTab extends StatefulWidget {
  final RolePermissionHelper helper;
  final Color primaryColor;
  final VoidCallback onSubmitClaimSuccess;

  const NewClaimTab({
    super.key,
    required this.helper,
    required this.primaryColor,
    required this.onSubmitClaimSuccess,
  });

  @override
  State<NewClaimTab> createState() => _NewClaimTabState();
}

class _LineItemEntry {
  String selectedCategory = 'Food';
  final descCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  final dateCtrl = TextEditingController(text: '06 Jun 2026');
  String billAttached = '';

  void dispose() {
    descCtrl.dispose();
    amountCtrl.dispose();
    dateCtrl.dispose();
  }
}

class _NewClaimTabState extends State<NewClaimTab> {
  final _claimTitleController = TextEditingController();
  final List<_LineItemEntry> _lineItems = [];
  String _onBehalfEmpId = '';
  String _onBehalfEmpName = '';

  @override
  void dispose() {
    _claimTitleController.dispose();
    for (var item in _lineItems) {
      item.dispose();
    }
    super.dispose();
  }

  IconData _categoryIcon(String cat) {
    switch (cat) {
      case 'Travel': return Icons.flight_rounded;
      case 'Fuel': return Icons.local_gas_station_rounded;
      case 'Food': return Icons.restaurant_rounded;
      case 'Hotel': return Icons.hotel_rounded;
      case 'Client Meeting': return Icons.handshake_rounded;
      case 'Entertainment': return Icons.theater_comedy_rounded;
      case 'Office Supplies': return Icons.inventory_2_rounded;
      case 'Internet': return Icons.wifi_rounded;
      case 'Mobile Recharge': return Icons.smartphone_rounded;
      case 'Training': return Icons.school_rounded;
      case 'Medical': return Icons.local_hospital_rounded;
      default: return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final canOnBehalf = widget.helper.getFinalPermissions(widget.helper.activeEmployeeId).contains('approve_expense') ||
        widget.helper.getFinalPermissions(widget.helper.activeEmployeeId).contains('manage_team_documents');
    final policies = { for (var p in widget.helper.expensePolicies) p.category: p.limitPerClaim };
    final totalAmount = _lineItems.fold<double>(0, (s, i) => s + (double.tryParse(i.amountCtrl.text) ?? 0));
    final violations = _lineItems.where((i) {
      final limit = policies[i.selectedCategory] ?? 0;
      final amt = double.tryParse(i.amountCtrl.text) ?? 0;
      return limit > 0 && amt > limit;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // On Behalf selector
          if (canOnBehalf) ...[
            const Text('Expense On Behalf Of', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            AppDropdownField<String>(
                  labelText: 'Select Employee (leave blank for yourself)',
                  value: _onBehalfEmpId.isEmpty ? null : _onBehalfEmpId,
                  items: [
                const DropdownMenuItem(value: '', child: Text('Myself')),
                ...widget.helper.employees.where((e) => e.id != widget.helper.activeEmployeeId).map((e) =>
                    DropdownMenuItem(value: e.id, child: Text(e.name))),
              ],
                  onChanged: (val) => setState(() {
                _onBehalfEmpId = val ?? '';
                _onBehalfEmpName = val == null || val.isEmpty ? '' :
                    widget.helper.employees.firstWhere((e) => e.id == val).name;
              }),
                ),
            const SizedBox(height: 16),
          ],

          // Claim title
          AppTextField(
                  controller: _claimTitleController,
                  labelText: 'Claim Title (e.g. Mumbai Client Visit)',
                ),
          const SizedBox(height: 16),

          // Policy violation alerts
          if (violations.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 16),
                      SizedBox(width: 6),
                      Text('Policy Limit Exceeded', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ...violations.map((v) {
                    final limit = policies[v.selectedCategory] ?? 0;
                    final amt = double.tryParse(v.amountCtrl.text) ?? 0;
                    return Text(
                      '• ${v.selectedCategory}: ₹${amt.toStringAsFixed(0)} > limit ₹${limit.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 11, color: Colors.orange),
                    );
                  }),
                ],
              ),
            ),

          // Mileage Calculator
          _buildMileageCalculator(widget.primaryColor, policies),
          const SizedBox(height: 16),

          // Line Items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Expense Items', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
              TextButton.icon(
                icon: Icon(Icons.add_rounded, color: widget.primaryColor),
                label: Text('Add Item', style: TextStyle(color: widget.primaryColor, fontWeight: FontWeight.bold)),
                onPressed: () => setState(() => _lineItems.add(_LineItemEntry())),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (_lineItems.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(12)),
              child: const Center(
                child: Text(
                  'No expense items added yet.\nTap "Add Item" to start.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ),

          ..._lineItems.asMap().entries.map((entry) => _buildLineItemForm(entry.key, entry.value, widget.primaryColor, policies)),

          if (_lineItems.isNotEmpty) ...[
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Amount:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text('₹${totalAmount.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: widget.primaryColor)),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: widget.primaryColor, padding: const EdgeInsets.symmetric(vertical: 14)),
              icon: const Icon(Icons.send_rounded, color: Colors.white),
              label: const Text('Submit Expense Claim', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () {
                if (_claimTitleController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a claim title.')));
                  return;
                }
                if (_lineItems.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add at least one expense item.')));
                  return;
                }
                final items = _lineItems.map((e) {
                  final limit = policies[e.selectedCategory] ?? 0;
                  return ExpenseLineItem(
                    id: 'li_${DateTime.now().millisecondsSinceEpoch}_${_lineItems.indexOf(e)}',
                    category: e.selectedCategory,
                    description: e.descCtrl.text,
                    amount: double.tryParse(e.amountCtrl.text) ?? 0,
                    date: e.dateCtrl.text,
                    billAttached: e.billAttached,
                    policyLimit: limit,
                  );
                }).toList();
                widget.helper.createExpenseClaim(
                  title: _claimTitleController.text.trim(),
                  lineItems: items,
                  onBehalfOfId: _onBehalfEmpId,
                  onBehalfOfName: _onBehalfEmpName,
                );
                setState(() {
                  _lineItems.clear();
                  _claimTitleController.clear();
                  _onBehalfEmpId = '';
                  _onBehalfEmpName = '';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Expense claim submitted successfully!'), backgroundColor: Colors.green),
                );
                widget.onSubmitClaimSuccess();
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMileageCalculator(Color primary, Map<String, double> policies) {
    final ratePerKm = policies['Fuel'] ?? 5.0;
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Row(
        children: [
          Icon(Icons.calculate_rounded, color: primary, size: 20),
          const SizedBox(width: 8),
          Text('Mileage / Fuel Calculator (₹$ratePerKm per km)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: primary)),
        ],
      ),
      children: [
        _MileageCalcWidget(
          ratePerKm: ratePerKm,
          primaryColor: primary,
          onUse: (km, amt) => setState(() {
            final entry = _LineItemEntry();
            entry.selectedCategory = 'Fuel';
            entry.descCtrl.text = 'Vehicle travel — ${km.toStringAsFixed(0)} km';
            entry.amountCtrl.text = amt.toStringAsFixed(0);
            _lineItems.add(entry);
          }),
        ),
      ],
    );
  }

  Widget _buildLineItemForm(int idx, _LineItemEntry entry, Color primary, Map<String, double> policies) {
    final limit = policies[entry.selectedCategory] ?? 0;
    final amt = double.tryParse(entry.amountCtrl.text) ?? 0;
    final exceeds = limit > 0 && amt > limit;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: exceeds ? Colors.red.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: exceeds ? Colors.red.shade200 : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Item ${idx + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
                onPressed: () => setState(() => _lineItems.removeAt(idx)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Category
                    AppDropdownField<String>(
            value: entry.selectedCategory,
            labelText: 'Category',
            items: ['Travel','Fuel','Food','Hotel','Client Meeting','Entertainment','Office Supplies','Internet','Mobile Recharge','Training','Medical','Other']
                .map((c) => DropdownMenuItem(value: c, child: Row(children: [
                  Icon(_categoryIcon(c), size: 14, color: primary), const SizedBox(width: 8), Text(c),
                ]))).toList(),
            onChanged: (val) => setState(() => entry.selectedCategory = val ?? entry.selectedCategory),
          ),
          const SizedBox(height: 8),
          // Description
          AppTextField(
            controller: entry.descCtrl,
            labelText: 'Description',
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: entry.amountCtrl,
                  keyboardType: TextInputType.number,
                  labelText: 'Amount (₹)',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppTextField(
                  controller: entry.dateCtrl,
                  labelText: 'Date',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Bill attachment simulated
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(side: BorderSide(color: entry.billAttached.isNotEmpty ? Colors.green : primary)),
            icon: Icon(
              entry.billAttached.isNotEmpty ? Icons.check_circle_rounded : Icons.attach_file_rounded,
              color: entry.billAttached.isNotEmpty ? Colors.green : primary,
              size: 16,
            ),
            label: Text(
              entry.billAttached.isNotEmpty ? 'AppCard: ${entry.billAttached}' : 'Attach Bill / Receipt',
              style: TextStyle(fontSize: 11, color: entry.billAttached.isNotEmpty ? Colors.green : primary),
            ),
            onPressed: () => setState(() => entry.billAttached = 'Receipt_${entry.selectedCategory}_${idx + 1}.jpg'),
          ),
          if (exceeds) ...[
            const SizedBox(height: 6),
            Text(
              '⚠ Exceeds policy limit of ₹$limit for ${entry.selectedCategory}',
              style: const TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ],
      ),
    );
  }
}

class _MileageCalcWidget extends StatefulWidget {
  final double ratePerKm;
  final Color primaryColor;
  final void Function(double km, double amt) onUse;
  const _MileageCalcWidget({required this.ratePerKm, required this.primaryColor, required this.onUse});

  @override
  State<_MileageCalcWidget> createState() => _MileageCalcWidgetState();
}

class _MileageCalcWidgetState extends State<_MileageCalcWidget> {
  final _kmCtrl = TextEditingController();
  double _calcAmt = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _kmCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Distance (km)', border: OutlineInputBorder(), isDense: true),
              onChanged: (v) => setState(() => _calcAmt = (double.tryParse(v) ?? 0) * widget.ratePerKm),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: widget.primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Text('₹${_calcAmt.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.bold, color: widget.primaryColor, fontSize: 15)),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            ),
            onPressed: _calcAmt > 0 ? () => widget.onUse(double.tryParse(_kmCtrl.text) ?? 0, _calcAmt) : null,
            child: const Text('Add', style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _kmCtrl.dispose();
    super.dispose();
  }
}
