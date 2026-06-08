import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/core/widgets/dropdown/app_dropdown_field.dart';
import 'package:gitakshmi_hrms_app/core/widgets/textfield/app_text_field.dart';

class AdminDeskTab extends StatefulWidget {
  final RolePermissionHelper helper;
  final bool isITTeam;
  final Color primaryColor;

  const AdminDeskTab({
    super.key,
    required this.helper,
    required this.isITTeam,
    required this.primaryColor,
  });

  @override
  State<AdminDeskTab> createState() => _AdminDeskTabState();
}

class _AdminDeskTabState extends State<AdminDeskTab> {
  final _registerFormKey = GlobalKey<FormState>();

  final _regNameController = TextEditingController();
  String _regCategory = 'IT';
  final _regCodeController = TextEditingController();
  final _regSerialController = TextEditingController();
  final _regBrandController = TextEditingController();
  final _regModelController = TextEditingController();
  final double _regHealthScore = 95.0;

  @override
  void dispose() {
    _regNameController.dispose();
    _regCodeController.dispose();
    _regSerialController.dispose();
    _regBrandController.dispose();
    _regModelController.dispose();
    super.dispose();
  }

  void _showResolveTicketDialog(AssetTicketModel ticket) {
    final remarksController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Resolve ticket: ${ticket.issueType}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Resolution notes for ticket submitted by ${ticket.employeeName}:', style: const TextStyle(fontSize: 11)),
              const SizedBox(height: 10),
              TextField(
                controller: remarksController,
                decoration: const InputDecoration(
                  labelText: 'Repair / Resolution notes (e.g. Keyboard keys replaced)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              )
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: widget.primaryColor),
              onPressed: () {
                widget.helper.resolveAssetTicket(ticket.id, remarksController.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Support ticket marked as resolved.'), backgroundColor: Colors.green),
                );
              },
              child: const Text('Confirm Resolution', style: TextStyle(color: Colors.white)),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isITTeam) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_rounded, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              const Text(
                'IT / HR Desk Restricted',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              const Text(
                'You must possess IT Admin, HR Manager or Engineering role permissions to access inventory registration and resolve support tickets.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              )
            ],
          ),
        ),
      );
    }

    final pendingRequests = widget.helper.assetRequests.where((r) => r.status == 'Pending').toList();
    final openTickets = widget.helper.assetTickets.where((t) => t.status == 'Open' || t.status == 'In Progress').toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
          bottom: TabBar(
            indicatorColor: widget.primaryColor,
            labelColor: widget.primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Requests (${pendingRequests.length})'),
              Tab(text: 'Tickets (${openTickets.length})'),
              const Tab(text: 'Register Asset'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Admin Requests list
            pendingRequests.isEmpty
                ? const Center(child: Text('No pending asset requests.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: pendingRequests.length,
                    itemBuilder: (context, index) {
                      final req = pendingRequests[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                '${req.employeeName} (${req.category})',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              Text('Request: ${req.type} | Priority: ${req.priority}', style: const TextStyle(fontSize: 11)),
                              Text('Reason: ${req.reason}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                              const Divider(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      widget.helper.rejectAssetRequest(req.id);
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request rejected.')));
                                    },
                                    child: const Text('Reject', style: TextStyle(color: Colors.red)),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                    onPressed: () {
                                      widget.helper.approveAssetRequest(req.id);
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request approved!'), backgroundColor: Colors.green));
                                    },
                                    child: const Text('Approve', style: TextStyle(color: Colors.white)),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),

            // Admin Tickets Resolve
            openTickets.isEmpty
                ? const Center(child: Text('No open support tickets.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: openTickets.length,
                    itemBuilder: (context, index) {
                      final tkt = openTickets[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                '${tkt.employeeName} - ${tkt.assetName}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              Text('Issue: ${tkt.issueType} | Severity: ${tkt.priority}', style: const TextStyle(fontSize: 11)),
                              Text(tkt.description, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                              const Divider(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: widget.primaryColor),
                                    onPressed: () => _showResolveTicketDialog(tkt),
                                    child: const Text('Resolve Ticket', style: TextStyle(color: Colors.white)),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),

            // IT Inventory creation Form
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _registerFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Register Asset in Directory', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _regNameController,
                      decoration: const InputDecoration(labelText: 'Asset Name (e.g. Dell Monitor 24")'),
                      validator: (v) => v!.isEmpty ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 10),
                    AppDropdownField<String>(
                  labelText: 'Category',
                  value: _regCategory,
                  items: ['IT', 'Office', 'Field'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) {
                        if (val != null) {
                          setState(() => _regCategory = val);
                        }
                      },
                ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _regCodeController,
                      decoration: const InputDecoration(labelText: 'Asset Code (e.g. MON-001)'),
                      validator: (v) => v!.isEmpty ? 'Code is required' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _regSerialController,
                      decoration: const InputDecoration(labelText: 'Hardware Serial Number'),
                      validator: (v) => v!.isEmpty ? 'Serial is required' : null,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _regBrandController,
                            decoration: const InputDecoration(labelText: 'Brand'),
                            validator: (v) => v!.isEmpty ? 'Brand is required' : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _regModelController,
                            decoration: const InputDecoration(labelText: 'Model'),
                            validator: (v) => v!.isEmpty ? 'Model is required' : null,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: widget.primaryColor),
                      onPressed: () {
                        if (_registerFormKey.currentState?.validate() ?? false) {
                          widget.helper.createAsset(
                            name: _regNameController.text,
                            category: _regCategory,
                            assetCode: _regCodeController.text,
                            serialNumber: _regSerialController.text,
                            brand: _regBrandController.text,
                            model: _regModelController.text,
                            healthScore: _regHealthScore,
                            specifications: {
                              'Status': 'Unassigned / Available in Stock',
                            },
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Asset registered in company inventory!'), backgroundColor: Colors.green),
                          );
                          _regNameController.clear();
                          _regCodeController.clear();
                          _regSerialController.clear();
                          _regBrandController.clear();
                          _regModelController.clear();
                        }
                      },
                      child: const Text('Add to Inventory', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
