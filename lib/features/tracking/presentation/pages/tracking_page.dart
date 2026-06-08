import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/widgets/buttons/app_button.dart';
import 'package:gitakshmi_hrms_app/core/widgets/textfield/app_text_field.dart';
import 'package:gitakshmi_hrms_app/core/widgets/dropdown/app_dropdown_field.dart';
import 'package:gitakshmi_hrms_app/core/widgets/bottomsheet/app_date_picker.dart';
import 'package:gitakshmi_hrms_app/features/tracking/presentation/widgets/tracking_live_map.dart';
import 'package:gitakshmi_hrms_app/features/tracking/presentation/widgets/tracking_geofence_setup.dart';
import 'package:gitakshmi_hrms_app/features/tracking/presentation/widgets/tracking_location_logs.dart';
import 'package:gitakshmi_hrms_app/features/tracking/presentation/widgets/tracking_dashboard_view.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  bool _isTracking = false;
  bool _isManagerMode = false;
  bool _fakeGpsWarning = false;
  bool _offlineMode = false;
  
  late List<Map<String, dynamic>> _visits;

  final List<Map<String, String>> _stoppages = [
    {
      "location": "BPCL Petrol Pump",
      "duration": "10 Mins",
      "reason": "Fuel Refill",
      "time": "02:10 PM"
    },
    {
      "location": "Starbucks Coffee",
      "duration": "20 Mins",
      "reason": "Client Meeting Prep",
      "time": "01:30 PM"
    }
  ];

  final List<Map<String, String>> _timeline = [
    {"time": "09:00 AM", "event": "Left HQ Office (Tracking Auto Started)"},
    {"time": "09:32 AM", "event": "Reached Tata Motors HQ (18 km travel)"},
    {"time": "10:15 AM", "event": "Checked-out Tata Motors HQ (Completed)"},
    {"time": "11:00 AM", "event": "Starbucks Coffee Stoppage (Stopped: 20 mins)"},
    {"time": "12:15 PM", "event": "Lunch Break (Idle state: 45 mins)"},
    {"time": "03:15 PM", "event": "Checked-out Reliance Corporate Park (Completed)"},
    {"time": "05:30 PM", "event": "Wipro Tech Park Visit Missed (Marked by scheduler)"}
  ];

  final List<Map<String, dynamic>> _managerTeam = [
    {
      "name": "Mayur Sonowane",
      "status": "Active Travel",
      "speed": "32 km/h",
      "distance": "14.2 km",
      "visits": "2 / 3 Completed",
      "idle": "0 Mins",
      "color": AppColors.success
    },
    {
      "name": "Amit Shah",
      "status": "Idle Alert (Starbucks)",
      "speed": "0 km/h",
      "distance": "8.5 km",
      "visits": "1 / 3 Completed",
      "idle": "15 Mins",
      "color": AppColors.warning
    },
    {
      "name": "Akash Patel",
      "status": "Lunch Break",
      "speed": "0 km/h",
      "distance": "6.0 km",
      "visits": "1 / 2 Completed",
      "idle": "30 Mins",
      "color": AppColors.info
    }
  ];

  @override
  void initState() {
    super.initState();
    _visits = [
      {
        "id": "1",
        "client": "Tata Motors HQ",
        "company": "Tata Group Ltd",
        "contact": "Akash Deshmukh",
        "phone": "+91 9876543210",
        "address": "Worli, Mumbai",
        "purpose": "Sales Presentation & Pitch",
        "priority": "High",
        "duration": "60 Mins",
        "status": "Completed",
        "time": "11:30 AM",
        "estDistance": "18 KM",
        "estTime": "32 Mins"
      },
      {
        "id": "2",
        "client": "Reliance Corporate Park",
        "company": "Reliance Industries Ltd",
        "contact": "Rajiv Mehta",
        "phone": "+91 9898989898",
        "address": "Ghansoli, Navi Mumbai",
        "purpose": "Contract Renewal Discussion",
        "priority": "Medium",
        "duration": "45 Mins",
        "status": "Completed",
        "time": "03:15 PM",
        "estDistance": "28 KM",
        "estTime": "50 Mins"
      },
      {
        "id": "3",
        "client": "Wipro Tech Park",
        "company": "Wipro Technologies",
        "contact": "Neha Sen",
        "phone": "+91 9900990099",
        "address": "Airoli, Navi Mumbai",
        "purpose": "Requirements Gathering",
        "priority": "Low",
        "duration": "30 Mins",
        "status": "Planned",
        "time": "05:30 PM",
        "estDistance": "12 KM",
        "estTime": "22 Mins"
      }
    ];
  }

  void _showAddVisitDialog() {
    final clientController = TextEditingController();
    final companyController = TextEditingController();
    final contactController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final purposeController = TextEditingController();
    String priority = 'Medium';
    String duration = '45 Mins';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Assign & Plan New Visit'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  controller: clientController,
                  labelText: 'Client Name',
                ),
                const SizedBox(height: 8),
                AppTextField(
                  controller: companyController,
                  labelText: 'Company / Organization',
                ),
                const SizedBox(height: 8),
                AppTextField(
                  controller: contactController,
                  labelText: 'Contact Person Name',
                ),
                const SizedBox(height: 8),
                AppTextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  labelText: 'Mobile Number',
                ),
                const SizedBox(height: 8),
                AppTextField(
                  controller: purposeController,
                  labelText: 'Purpose of Visit',
                ),
                const SizedBox(height: 8),
                AppTextField(
                  controller: addressController,
                  labelText: 'Address',
                ),
                const SizedBox(height: 12),
                AppDropdownField<String>(
                  labelText: 'Priority Tier',
                  value: priority,
                  items: ['High', 'Medium', 'Low'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                  onChanged: (val) {
                    if (val != null) setDialogState(() => priority = val);
                  },
                ),
                const SizedBox(height: 12),
                AppDropdownField<String>(
                  labelText: 'Expected Meeting Duration',
                  value: duration,
                  items: ['30 Mins', '45 Mins', '60 Mins', '90 Mins'].map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                  onChanged: (val) {
                    if (val != null) setDialogState(() => duration = val);
                  },
                ),
              ],
            ),
          ),
          actions: [
            AppButton.text(
              text: 'Cancel',
              onPressed: () => Navigator.pop(context),
            ),
            AppButton.primary(
              onPressed: () {
                if (clientController.text.isNotEmpty && addressController.text.isNotEmpty) {
                  setState(() {
                    _visits.add({
                      "id": DateTime.now().millisecondsSinceEpoch.toString(),
                      "client": clientController.text,
                      "company": companyController.text.isNotEmpty ? companyController.text : "N/A",
                      "contact": contactController.text.isNotEmpty ? contactController.text : "N/A",
                      "phone": phoneController.text.isNotEmpty ? phoneController.text : "N/A",
                      "address": addressController.text,
                      "purpose": purposeController.text.isNotEmpty ? purposeController.text : "N/A",
                      "priority": priority,
                      "duration": duration,
                      "status": "Planned",
                      "time": "06:00 PM",
                      "estDistance": "15 KM",
                      "estTime": "25 Mins"
                    });
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Visit at ${clientController.text} assigned successfully! Route Distance: 15 KM, Est Time: 25 Mins.'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter Client Name and Address.')),
                  );
                }
              },
              text: 'Assign Visit',
            )
          ],
        ),
      ),
    );
  }

  void _openCheckInDialog(Map<String, dynamic> visit) {
    final notesController = TextEditingController();
    List<Offset?> signaturePoints = [];
    bool isRecording = false;
    bool hasPhoto = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Check-In: ${visit["client"]}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Attach Photo & Info', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 8),
                    AppButton.outlined(
                      onPressed: () {
                        setDialogState(() {
                          hasPhoto = true;
                        });
                      },
                      icon: hasPhoto ? Icons.check_circle_rounded : Icons.photo_camera_rounded,
                      text: hasPhoto ? 'Photo Attached ✅' : 'Capture Client Photo',
                    ),
                    const SizedBox(height: 16),
                    const Text('Voice Notes Log', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 8),
                    AppButton.primary(
                      onPressed: () {
                        setDialogState(() {
                          isRecording = !isRecording;
                        });
                      },
                      icon: isRecording ? Icons.stop_circle_rounded : Icons.mic_rounded,
                      text: isRecording ? 'Recording Voice Log...' : 'Record Voice Note',
                      backgroundColor: isRecording ? AppColors.error : AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: notesController,
                      labelText: 'Check-In Notes',
                    ),
                    const SizedBox(height: 16),
                    const Text('Draw Signature Below', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onPanUpdate: (details) {
                        setDialogState(() {
                          signaturePoints.add(details.localPosition);
                        });
                      },
                      onPanEnd: (details) {
                        setDialogState(() {
                          signaturePoints.add(null);
                        });
                      },
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: CustomPaint(
                          painter: SignaturePainter(points: signaturePoints),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AppButton.text(
                        onPressed: () {
                          setDialogState(() {
                            signaturePoints.clear();
                          });
                        },
                        text: 'Clear Signature',
                        textColor: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                AppButton.text(
                  onPressed: () => Navigator.pop(context),
                  text: 'Cancel',
                ),
                AppButton.primary(
                  onPressed: () {
                    if (signaturePoints.isNotEmpty) {
                      Navigator.pop(context);
                      setState(() {
                        visit["status"] = 'In Progress';
                      });
                      _openCheckOutDialog(visit);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please capture a client signature to verify check-in.')),
                      );
                    }
                  },
                  text: 'Submit Check-In',
                )
              ],
            );
          },
        );
      },
    );
  }

  void _openCheckOutDialog(Map<String, dynamic> visit) {
    final remarksController = TextEditingController();
    String outcome = 'Meeting Successful';
    final followUpController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Check-Out: ${visit["client"]}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppDropdownField<String>(
                      labelText: 'Meeting Outcome',
                      value: outcome,
                      items: ['Meeting Successful', 'Follow-up Needed', 'Quotation Requested', 'Deal Closed', 'Postponed']
                          .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => outcome = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: remarksController,
                      maxLines: 2,
                      labelText: 'Meeting Remarks',
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: followUpController,
                      readOnly: true,
                      labelText: 'Next Follow Up Date',
                      onTap: () async {
                        final date = await AppDatePicker.showSingle(
                          context: context,
                          title: 'Select Follow Up Date',
                          subtitle: 'Plan your next visit follow-up',
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 90)),
                        );
                        if (date != null) {
                          setDialogState(() {
                            followUpController.text = "${date.day}/${date.month}/${date.year}";
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                AppButton.text(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: 'Cancel',
                ),
                AppButton.primary(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      visit["status"] = 'Completed';
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Checked-Out from ${visit["client"]} successfully! Status: Completed.'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                  text: 'Complete Visit',
                )
              ],
            );
          },
        );
      },
    );
  }

  void _showVisitDetailsDialog(Map<String, dynamic> visit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(visit["client"]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Company: ${visit["company"]}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Contact Person: ${visit["contact"]} (${visit["phone"]})'),
            const SizedBox(height: 4),
            Text('Purpose: ${visit["purpose"]}'),
            const SizedBox(height: 4),
            Text('Address: ${visit["address"]}'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text('Priority: ${visit["priority"]}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                  backgroundColor: visit["priority"] == 'High' ? AppColors.error : AppColors.warning,
                  side: BorderSide.none,
                ),
                Chip(
                  label: Text(visit["status"], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                  backgroundColor: visit["status"] == 'Completed' ? AppColors.success : AppColors.info,
                  side: BorderSide.none,
                ),
              ],
            ),
            const Divider(height: 24),
            Text('Estimated Distance: ${visit["estDistance"]}'),
            Text('Expected Travel Time: ${visit["estTime"]}'),
          ],
        ),
        actions: [
          if (visit["status"] == 'Planned') ...[
            AppButton.text(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  visit["status"] = 'In Progress';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Travel started for visit. Tracking auto-activated.')),
                );
              },
              text: 'Start Travel',
              textColor: AppColors.success,
            ),
            AppButton.text(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reschedule request sent to Manager for approval.')),
                );
              },
              text: 'Reschedule',
              textColor: AppColors.warning,
            ),
          ],
          if (visit["status"] == 'In Progress')
            AppButton.primary(
              onPressed: () {
                Navigator.pop(context);
                _openCheckInDialog(visit);
              },
              text: 'Check In',
            ),
          AppButton.text(
            onPressed: () => Navigator.pop(context),
            text: 'Close',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _visits.where((v) => v["status"] == 'Completed').length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Tracking Dashboard'),
        actions: [
          Row(
            children: [
              Text(_isManagerMode ? 'Manager' : 'Employee', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
              Switch(
                value: _isManagerMode,
                onChanged: (val) {
                  setState(() {
                    _isManagerMode = val;
                  });
                },
                activeColor: AppColors.primary,
              ),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: _showAddVisitDialog,
        child: const Icon(Icons.add_location_alt_rounded, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Simulation Controls Card
            TrackingGeofenceSetup(
              fakeGpsWarning: _fakeGpsWarning,
              offlineMode: _offlineMode,
              onFakeGpsChanged: (val) {
                setState(() {
                  _fakeGpsWarning = val ?? false;
                });
              },
              onOfflineModeChanged: (val) {
                setState(() {
                  _offlineMode = val ?? false;
                });
              },
            ),
            const SizedBox(height: 12),

            TrackingDashboardView(
              isManagerMode: _isManagerMode,
              isTracking: _isTracking,
              fakeGpsWarning: _fakeGpsWarning,
              offlineMode: _offlineMode,
              totalVisitsCount: _visits.length,
              completedCount: completedCount,
              onTrackingChanged: (val) {
                setState(() {
                  _isTracking = val;
                });
              },
              managerTeam: _managerTeam,
            ),
            const SizedBox(height: 16),

            if (!_isManagerMode) ...[
              const Text('Assigned Visits Map Path', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
            ],

            TrackingLiveMap(
              isTracking: _isTracking,
              isManagerMode: _isManagerMode,
            ),
            const SizedBox(height: 20),

            if (!_isManagerMode)
              TrackingLocationLogs(
                visits: _visits,
                stoppages: _stoppages,
                timeline: _timeline,
                onVisitTap: _showVisitDetailsDialog,
              ),
          ],
        ),
      ),
    );
  }
}
