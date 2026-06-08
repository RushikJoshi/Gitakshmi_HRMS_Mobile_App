import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/widgets/textfield/app_text_field.dart';

class ApprovalsPage extends StatefulWidget {
  const ApprovalsPage({super.key});

  @override
  State<ApprovalsPage> createState() => _ApprovalsPageState();
}

class _ApprovalsPageState extends State<ApprovalsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  String _activeCategory = 'All';

  // Mock requests data
  final List<Map<String, dynamic>> _pendingRequests = [
    {
      "id": 1,
      "name": "Akash Patel",
      "dept": "Marketing",
      "type": "Casual Leave Request",
      "details": "Family emergency travel (3 Days)",
      "priority": "High",
      "date": "06 Jun 2026",
      "category": "HR & Leaves",
      "steps": ["Manager Approved", "HR Pending", "Director Pending"],
      "attachments": ["Leave_Medical_Proof.pdf"]
    },
    {
      "id": 2,
      "name": "Riya Sharma",
      "dept": "Product & Engineering",
      "type": "Recruitment Approval",
      "details": "Senior Flutter Developer hire request (Budget Approved)",
      "priority": "Medium",
      "date": "05 Jun 2026",
      "category": "HR & Leaves",
      "steps": ["HR Approved", "Director Pending"],
      "attachments": ["Flutter_JD_v2.pdf", "Budget_Approval.xlsx"]
    },
    {
      "id": 3,
      "name": "Nikhil Varma",
      "dept": "Finance",
      "type": "Expense Approval",
      "details": "Client travel expenses reimbursement (INR 12,500)",
      "priority": "Low",
      "date": "04 Jun 2026",
      "category": "Finance & Expenses",
      "steps": ["Manager Pending"],
      "attachments": ["Travel_Receipts_Mumbai.pdf"]
    },
    {
      "id": 6,
      "name": "Rohan Deshmukh",
      "dept": "Product & Design",
      "type": "Offer Letter Approval",
      "details": "Lead Product Designer: INR 18,00,000 LPA, Joining: 15 July 2026",
      "priority": "Medium",
      "date": "06 Jun 2026",
      "category": "HR & Leaves",
      "steps": ["HR Approved", "Director Pending"],
      "attachments": ["Draft_Offer_Rohan.pdf", "Salary_Breakup.xlsx"]
    },
    {
      "id": 7,
      "name": "Suresh Naik",
      "dept": "Administration",
      "type": "Resignation Approval",
      "details": "Resignation request submitted. LWD: 30th June 2026.",
      "priority": "High",
      "date": "05 Jun 2026",
      "category": "HR & Leaves",
      "steps": ["Manager Approved", "HR Pending"],
      "attachments": ["Suresh_Resignation_Letter.pdf"]
    },
    {
      "id": 8,
      "name": "Q3 Campaign",
      "dept": "Marketing",
      "type": "Budget Approval",
      "details": "Q3 campaign promotion budget (INR 5,50,000)",
      "priority": "High",
      "date": "05 Jun 2026",
      "category": "Finance & Expenses",
      "steps": ["Manager Approved", "Finance Pending"],
      "attachments": ["Q3_Campaign_Plan.pdf"]
    },
    {
      "id": 9,
      "name": "Amit Shah",
      "dept": "Sales & Business",
      "type": "Travel Approval",
      "details": "Singapore business development visit (5 Days package)",
      "priority": "High",
      "date": "04 Jun 2026",
      "category": "Finance & Expenses",
      "steps": ["Manager Approved", "Finance Approved", "Director Pending"],
      "attachments": ["Flight_Hotel_Itinerary.pdf"]
    },
    {
      "id": 10,
      "name": "Karan Malhotra",
      "dept": "Operations",
      "type": "Asset Request Approval",
      "details": "MacBook Pro 16\" (M3 Max, 32GB RAM) IT supply for lead developer",
      "priority": "Medium",
      "date": "03 Jun 2026",
      "category": "Operations & Assets",
      "steps": ["Manager Approved", "IT Admin Pending"],
      "attachments": ["MacBook_M3_Quote.pdf"]
    },
    {
      "id": 11,
      "name": "Simran Kaur",
      "dept": "Sales",
      "type": "Attendance Correction",
      "details": "Punch-in mismatch correction request due to Out of Range geo-fence",
      "priority": "Low",
      "date": "02 Jun 2026",
      "category": "Operations & Assets",
      "steps": ["Manager Pending"],
      "attachments": ["Out_Of_Office_Log.png"]
    }
  ];

  final List<Map<String, dynamic>> _historyRequests = [
    {
      "id": 4,
      "name": "Karan Malhotra",
      "dept": "Operations",
      "type": "Resignation Approval",
      "details": "LWD - 30th June 2026",
      "priority": "High",
      "date": "28 May 2026",
      "status": "Approved",
      "comments": "Approved after exit interview.",
      "attachments": ["Resignation_Letter.pdf"]
    },
    {
      "id": 5,
      "name": "Simran Kaur",
      "dept": "Sales",
      "type": "Travel Approval",
      "details": "Client meet visits in Pune (2 Days)",
      "priority": "Medium",
      "date": "25 May 2026",
      "status": "Rejected",
      "comments": "Reschedule visits to next month.",
      "attachments": ["Pune_Client_Agenda.pdf"]
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColors.error;
      case 'medium':
        return AppColors.warning;
      default:
        return AppColors.info;
    }
  }

  void _showDecisionDialog(int id, bool isApprove) {
    final commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isApprove ? 'Approve Request' : 'Reject Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Enter optional feedback comments for the applicant:'),
            const SizedBox(height: 12),
            TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: 'Add comments...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _pendingRequests.removeWhere((item) => item["id"] == id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isApprove ? 'Request approved.' : 'Request rejected.'),
                  backgroundColor: isApprove ? AppColors.success : AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isApprove ? AppColors.success : AppColors.error,
            ),
            child: const Text('Confirm'),
          )
        ],
      ),
    );
  }

  void _showRequestDetailsSheet(Map<String, dynamic> req) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        final attachments = req["attachments"] as List<String>? ?? [];
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(req["priority"]).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${req["priority"]} Priority',
                      style: TextStyle(color: _getPriorityColor(req["priority"]), fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
                ],
              ),
              Text(
                req["type"],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Applicant Details
                      const Text('APPLICANT DETAILS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textLight)),
                      const SizedBox(height: 6),
                      Text('Name: ${req["name"]}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      Text('Department: ${req["dept"]}'),
                      Text('Requested Date: ${req["date"]}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(height: 16),

                      // Description
                      const Text('REQUEST DETAILS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textLight)),
                      const SizedBox(height: 6),
                      Text(req["details"], style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 20),

                      // Attachments Section
                      const Text('ATTACHED DOCUMENTS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textLight)),
                      const SizedBox(height: 8),
                      if (attachments.isEmpty)
                        const Text('No documents attached to this request.', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.textSecondary))
                      else
                        ...attachments.map((file) => Card(
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey.shade200)),
                          child: ListTile(
                            dense: true,
                            leading: Icon(
                              file.endsWith('.xlsx') || file.endsWith('.xls')
                                  ? Icons.table_chart_rounded
                                  : file.endsWith('.png') || file.endsWith('.jpg')
                                      ? Icons.image_rounded
                                      : Icons.picture_as_pdf_rounded,
                              color: AppColors.primary,
                            ),
                            title: Text(file, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            trailing: IconButton(
                              icon: const Icon(Icons.download_rounded, color: AppColors.primary, size: 18),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Downloading: $file')),
                                );
                              },
                            ),
                          ),
                        )),
                      const SizedBox(height: 20),

                      // Approval Steps Timeline
                      const Text('APPROVAL ENGINE LOGS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textLight)),
                      const SizedBox(height: 10),
                      ...List.generate((req["steps"] as List<String>).length, (idx) {
                        final step = req["steps"][idx];
                        final isApproved = step.contains('Approved');
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Icon(
                                isApproved ? Icons.check_circle_rounded : Icons.pending_rounded,
                                color: isApproved ? AppColors.success : AppColors.warning,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                step,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isApproved ? AppColors.success : AppColors.warning,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showDecisionDialog(req["id"], false);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error),
                      foregroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Reject'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showDecisionDialog(req["id"], true);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Approve'),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab Headers
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'Pending Inbox', icon: Icon(Icons.mark_as_unread_rounded)),
              Tab(text: 'Approval History', icon: Icon(Icons.history_rounded)),
            ],
          ),
        ),
        
        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildPendingList(),
              _buildHistoryList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPendingList() {
    final filtered = _activeCategory == 'All'
        ? _pendingRequests
        : _pendingRequests.where((r) => r["category"] == _activeCategory).toList();

    return Column(
      children: [
        // Categories ChoiceChips
        Container(
          height: 54,
          color: Colors.white,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            children: ['All', 'HR & Leaves', 'Finance & Expenses', 'Operations & Assets'].map((cat) {
              final isSelected = cat == _activeCategory;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _activeCategory = cat;
                      });
                    }
                  },
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        
        // List View
        Expanded(
          child: filtered.isEmpty
              ? const Center(
                  child: Text(
                    'No pending requests in this category!',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final req = filtered[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        onTap: () => _showRequestDetailsSheet(req),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    req["type"],
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Chip(
                                  label: Text(
                                    req["priority"],
                                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: _getPriorityColor(req["priority"]),
                                  side: BorderSide.none,
                                  visualDensity: VisualDensity.compact,
                                )
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Applicant: ${req["name"]} (${req["dept"]})',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              req["details"],
                              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 16),

                            // Multi level steps indicator
                            const Text('APPROVAL ENGINE LOGS:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textLight)),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: (req["steps"] as List<String>).map((step) {
                                final isApproved = step.contains('Approved');
                                return Chip(
                                  avatar: Icon(
                                    isApproved ? Icons.check_circle_rounded : Icons.pending_rounded,
                                    size: 14,
                                    color: isApproved ? AppColors.success : AppColors.warning,
                                  ),
                                  label: Text(
                                    step,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isApproved ? AppColors.success : AppColors.warning,
                                    ),
                                  ),
                                  backgroundColor: (isApproved ? AppColors.success : AppColors.warning).withValues(alpha: 0.08),
                                  side: BorderSide.none,
                                  visualDensity: VisualDensity.compact,
                                );
                              }).toList(),
                            ),
                            const Divider(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton(
                                  onPressed: () => _showDecisionDialog(req["id"], false),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppColors.error),
                                    foregroundColor: AppColors.error,
                                  ),
                                  child: const Text('Reject'),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: () => _showDecisionDialog(req["id"], true),
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                                  child: const Text('Approve'),
                                )
                              ],
                            )
                          ],
                        ),
                      ),),);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _historyRequests.length,
      itemBuilder: (context, index) {
        final req = _historyRequests[index];
        final isApproved = req["status"] == 'Approved';
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () => _showRequestDetailsSheet(req),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      req["type"],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    Chip(
                      label: Text(
                        req["status"],
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: isApproved ? AppColors.success : AppColors.error,
                      side: BorderSide.none,
                      visualDensity: VisualDensity.compact,
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Applicant: ${req["name"]} (${req["dept"]})',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  req["details"],
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                if (req["comments"] != null) ...[
                  const Divider(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.comment_rounded, size: 16, color: AppColors.textLight),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Feedback: "${req["comments"]}"',
                          style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'Reviewed on: ${req["date"]}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                  ),
                )
              ],
            ),
          ),
        ),);
      },
    );
  }
}
