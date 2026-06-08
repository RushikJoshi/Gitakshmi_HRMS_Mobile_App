import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_face_liveness/flutter_face_liveness.dart';

import 'package:gitakshmi_hrms_app/features/attendance/presentation/widgets/attendance_stats_grid.dart';
import 'package:gitakshmi_hrms_app/features/attendance/presentation/widgets/aws_offline_sync_card.dart';
import 'package:gitakshmi_hrms_app/features/attendance/presentation/widgets/attendance_permission_card.dart';
import 'package:gitakshmi_hrms_app/features/attendance/presentation/widgets/face_liveness_scanner.dart';
import 'package:gitakshmi_hrms_app/features/attendance/presentation/widgets/out_of_range_form.dart';
import 'package:gitakshmi_hrms_app/features/attendance/presentation/widgets/break_timer_console.dart';
import 'package:gitakshmi_hrms_app/features/attendance/presentation/widgets/supervisor_attendance_list.dart';
import 'package:gitakshmi_hrms_app/core/widgets/dropdown/app_dropdown_field.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> with WidgetsBindingObserver {
  int _punchStep =
      0; // 0 = Not punched, 1 = Location permission prompt, 2 = Camera permission prompt, 3 = Geo-fence verification, 4 = Face scan liveness check, 5 = Punched In (Working), 6 = Out of Range flow
  int _activeActivity = 2; // 2 = Working (Blue), 3 = Lunch Break (Yellow), 4 = Short Break (Orange), 5 = Overtime (Purple)
  bool _isInRange = true; // Switch location range simulation
  bool _isManagerMode = false;
  final TextEditingController _reasonController = TextEditingController();

  bool _isLocationPermanentlyDenied = false;
  bool _isCameraPermanentlyDenied = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAndRequestPermissionsOnResume();
    }
  }

  String _selectedLocation = 'HQ Mumbai Office (Geo-fence: 100m Radius)';
  final List<String> _locations = [
    'HQ Mumbai Office (Geo-fence: 100m Radius)',
    'Pune Branch Office (Geo-fence: 150m Radius)',
    'Remote / Work From Home (WFH)',
  ];

  // Liveness check simulator steps
  int _livenessStep = 1; // 1 = Blink Detection, 2 = Head Movement check, 3 = Spoof Detection progress
  bool _livenessSuccess = false;

  // Break limits simulation
  bool _simulateOverBreakLimit = false;

  // Mock employee stats
  final int _presentDays = 18;
  final int _absentDays = 1;
  final int _leaveDays = 2;
  final int _lateDays = 3;
  final int _earlyOutDays = 1;
  final String _workingHours = '168.5 Hrs';
  final String _overtimeHours = '12.0 Hrs';

  final List<Map<String, String>> _breaksHistory = [
    {"type": "Lunch Break", "duration": "40 Mins", "time": "01:05 PM"},
    {"type": "Tea Break", "duration": "10 Mins", "time": "04:15 PM"},
  ];

  final List<Map<String, dynamic>> _teamAttendance = [
    {
      "name": "Mayur Sonowane",
      "role": "Employee",
      "status": "Working",
      "time": "In: 09:05 AM",
      "color": AppColors.success,
    },
    {
      "name": "Riya Sharma",
      "role": "Sales TL",
      "status": "Late Check-in",
      "time": "In: 09:18 AM (+18m)",
      "color": AppColors.warning,
    },
    {
      "name": "Amit Shah",
      "role": "Sales Rep",
      "status": "Lunch Break",
      "time": "Since: 01:10 PM",
      "color": AppColors.timerLunch,
    },
    {"name": "Akash Patel", "role": "HR Manager", "status": "On Leave", "time": "Casual Leave", "color": AppColors.calLeave},
    {"name": "Karan Malhotra", "role": "Developer", "status": "Absent", "time": "No Punch", "color": AppColors.error},
  ];

  // Edge AI & Real Coordinates properties
  double? _fetchedLatitude;
  double? _fetchedLongitude;
  double? _fetchedAccuracy;
  String? _fetchedTimestamp;
  double? _calculatedDistance;
  bool _mockGpsDetected = false;

  // Sync Queue / Offline Storage properties
  int _syncQueueCount = 0;
  final List<String> _syncLogs = ["AWS Sync: Ready to synchronize with Lambda/DynamoDB when online."];

  bool get _effectiveInRange => _selectedLocation == 'Remote / Work From Home (WFH)' || _isInRange;

  Future<void> _updatePermissionStatuses() async {
    var locStatus = await Permission.locationWhenInUse.status;
    var camStatus = await Permission.camera.status;
    if (mounted) {
      setState(() {
        _isLocationPermanentlyDenied = locStatus.isPermanentlyDenied;
        _isCameraPermanentlyDenied = camStatus.isPermanentlyDenied;
      });
    }
  }

  Future<void> _checkAndRequestPermissionsOnResume() async {
    await _updatePermissionStatuses();
    if (_punchStep == 1) {
      var locStatus = await Permission.locationWhenInUse.status;
      if (locStatus.isGranted) {
        setState(() {
          _punchStep = 2;
        });
        var camStatus = await Permission.camera.status;
        if (camStatus.isGranted) {
          _startGeofenceCheck();
        }
      }
    } else if (_punchStep == 2) {
      var camStatus = await Permission.camera.status;
      if (camStatus.isGranted) {
        _startGeofenceCheck();
      }
    }
  }

  Future<void> _checkAndRequestPermissions() async {
    var locStatus = await Permission.locationWhenInUse.status;
    if (!locStatus.isGranted) {
      if (mounted) {
        setState(() {
          _isLocationPermanentlyDenied = locStatus.isPermanentlyDenied;
          _punchStep = 1;
        });
      }
      return;
    }

    var camStatus = await Permission.camera.status;
    if (!camStatus.isGranted) {
      if (mounted) {
        setState(() {
          _isCameraPermanentlyDenied = camStatus.isPermanentlyDenied;
          _punchStep = 2;
        });
      }
      return;
    }

    _startGeofenceCheck();
  }

  void _triggerPunchInSequence() async {
    await _updatePermissionStatuses();
    _checkAndRequestPermissions();
  }

  Future<void> _startGeofenceCheck() async {
    setState(() {
      _punchStep = 3;
      _mockGpsDetected = false;
    });

    try {
      // Get current position (time limit 8 seconds)
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 8)),
      );

      // Security Feature: Check for mock GPS (Mock location provider)
      if (position.isMocked) {
        setState(() {
          _mockGpsDetected = true;
          _punchStep = 0;
        });
        _showMockGpsAlert();
        return;
      }

      _fetchedLatitude = position.latitude;
      _fetchedLongitude = position.longitude;
      _fetchedAccuracy = position.accuracy;
      _fetchedTimestamp = position.timestamp.toIso8601String();

      // Office coordinates matching solutions overview
      double officeLat = 19.0760; // HQ Mumbai Office
      double officeLng = 72.8777;
      double allowedRadius = 100.0; // Allowed Radius

      if (_selectedLocation.contains('Pune Branch')) {
        officeLat = 18.5204; // Pune
        officeLng = 73.8567;
        allowedRadius = 150.0;
      }

      double distance = Geolocator.distanceBetween(position.latitude, position.longitude, officeLat, officeLng);
      _calculatedDistance = distance;

      bool insideRange = distance <= allowedRadius;

      // Remote override or simulation override
      if (_selectedLocation == 'Remote / Work From Home (WFH)') {
        insideRange = true;
      } else if (_isInRange) {
        insideRange = true;
      }

      if (mounted) {
        if (insideRange) {
          setState(() {
            _punchStep = 4; // Move to Face Verification Liveness
            _livenessStep = 1;
          });
        } else {
          setState(() => _punchStep = 6); // Move to Out of Range Flow
        }
      }
    } catch (e) {
      // Fallback if location service is disabled/timeout or running on emulator
      if (mounted) {
        if (_effectiveInRange) {
          setState(() {
            _punchStep = 4;
            _livenessStep = 1;
          });
        } else {
          setState(() => _punchStep = 6);
        }
      }
    }
  }

  void _showMockGpsAlert() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Row(
              children: const [
                Icon(Icons.gpp_bad_rounded, color: AppColors.error),
                SizedBox(width: 8),
                Text('Security Alert', style: TextStyle(color: AppColors.error)),
              ],
            ),
            content: const Text(
              'SECURITY ALERT: Mock GPS app coordinates detected! Live tracking and attendance checking is restricted.',
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Dismiss')),
            ],
          ),
    );
  }

  void _startRealLivenessSDK() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (dialogContext) => Scaffold(
              appBar: AppBar(title: const Text("Biometric Face Liveness SDK")),
              body: FlutterFaceLiveness(
                actions: const [LivenessAction.blink, LivenessAction.turnLeft, LivenessAction.turnRight],
                config: LivenessConfig(randomizeActions: true),
                onSuccess: (LivenessResult result) {
                  Navigator.pop(dialogContext);
                  final String sessId = result.sessionId ?? "SDK_SESSION";
                  final String sessShort = sessId.length >= 8 ? sessId.substring(0, 8) : sessId;
                  if (mounted) {
                    setState(() {
                      _livenessSuccess = true;
                      _punchStep = 5; // Success Punch In screen
                      _activeActivity = 2; // Working state
                      _syncQueueCount++;
                      _syncLogs.add("Face Liveness SDK Verification cleared. Session ID: $sessShort...");
                      _syncLogs.add(
                        "Local SQLite: 128-D Biometric template signature saved in SQLite (Encrypted AES-256)",
                      );
                      _syncLogs.add("Sync Engine: Attendance punch-in added to local DB queue buffer");
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Liveness verified successfully via SDK!'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                },
                onFailed: (reason) {
                  Navigator.pop(dialogContext);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Biometric verification failed: $reason'), backgroundColor: AppColors.error),
                    );
                  }
                },
              ),
            ),
      ),
    );
  }

  void _simulateLivenessBlink() {
    setState(() => _livenessStep = 2);
  }

  void _simulateLivenessHead() {
    setState(() => _livenessStep = 3);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _livenessSuccess = true;
          _punchStep = 5; // Punch In Success (Active working screen)
          _activeActivity = 2; // Working (Blue)
          _syncQueueCount++;
          _syncLogs.add("Simulated Face Liveness Verification cleared.");
          _syncLogs.add("Local SQLite: 128-D MobileFaceNet embedding saved in SQLite (Encrypted AES-256)");
          _syncLogs.add("Sync Queue: Offline record added. Ready for AWS sync.");
        });
      }
    });
  }

  void _submitOutOfRangeRequest() {
    if (_reasonController.text.isNotEmpty) {
      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('WFH / Out of Range Request'),
              content: const Text(
                'Your out-of-range attendance request has been generated and sent to the Workflow Engine for Manager approval.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _punchStep = 5; // Simulating punched in after request generated
                      _activeActivity = 2;
                    });
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a reason for out of range check-in.')),
      );
    }
  }

  Color _getTimerColor() {
    if (_simulateOverBreakLimit && (_activeActivity == 3 || _activeActivity == 4)) {
      return AppColors.timerExtraBreak; // Red (Limit Exceeded!)
    }
    switch (_activeActivity) {
      case 2:
        return AppColors.timerWorking; // Blue
      case 3:
        return AppColors.timerLunch; // Yellow
      case 4:
        return AppColors.timerShortBreak; // Orange
      case 5:
        return AppColors.timerOvertime; // Purple
      default:
        return AppColors.timerWorking;
    }
  }

  String _getTimerStatusText() {
    if (_simulateOverBreakLimit && (_activeActivity == 3 || _activeActivity == 4)) {
      return 'OVERLIMIT BREAK 🚨';
    }
    switch (_activeActivity) {
      case 2:
        return 'WORKING';
      case 3:
        return 'LUNCH BREAK';
      case 4:
        return 'SHORT BREAK';
      case 5:
        return 'OVERTIME ACTIVATED';
      default:
        return 'WORKING';
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Attendance Board'),
        actions: [
          Row(
            children: [
              Text(
                _isManagerMode ? 'Supervisor' : 'Employee',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
              Switch(
                value: _isManagerMode,
                onChanged: (val) {
                  setState(() {
                    _isManagerMode = val;
                  });
                },
                activeThumbColor: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_isManagerMode) ...[
              // EMPLOYEE VIEWPORT
              // Personal Attendance Dashboard Stats
              AttendanceStatsGrid(
                presentDays: _presentDays,
                lateDays: _lateDays,
                earlyOutDays: _earlyOutDays,
                absentDays: _absentDays,
                leaveDays: _leaveDays,
                workingHours: _workingHours,
                overtimeHours: _overtimeHours,
                mockGpsDetected: _mockGpsDetected,
              ),
              const SizedBox(height: 16),

              // AWS synchronization and Offline Storage Status Indicator
              AwsOfflineSyncCard(
                syncQueueCount: _syncQueueCount,
                onForceSync: () {
                  if (_syncQueueCount > 0) {
                    setState(() {
                      _syncLogs.add("AWS Sync: Uploaded $_syncQueueCount local records to DynamoDB.");
                      _syncLogs.add("AWS Sync: Synchronized image vectors to S3 Bucket.");
                      _syncQueueCount = 0;
                    });
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('AWS Hybrid Sync Completed!'), backgroundColor: AppColors.success));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No offline records to sync.')));
                  }
                },
                onShowSQLiteLogs: _showSQLiteLogsDialog,
              ),
              const SizedBox(height: 12),

              if (_punchStep == 0) ...[
                // Branch location selector dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedLocation,
                  decoration: InputDecoration(
                    labelText: 'Current Office / Branch Location',
                    prefixIcon: const Icon(Icons.business_rounded, color: AppColors.primary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items:
                      _locations.map((loc) {
                        return DropdownMenuItem(value: loc, child: Text(loc, style: const TextStyle(fontSize: 13)));
                      }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedLocation = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),

                // Simulated Geo-fence switch (Only when not WFH)
                if (_selectedLocation != 'Remote / Work From Home (WFH)') ...[
                  Card(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Simulate Location Range',
                            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          Switch(
                            value: _isInRange,
                            onChanged: (val) {
                              setState(() {
                                _isInRange = val;
                              });
                            },
                            activeThumbColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                // Status Geofencing Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              _effectiveInRange ? Icons.location_on_rounded : Icons.location_off_rounded,
                              color: _effectiveInRange ? AppColors.success : AppColors.error,
                              size: 32,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _effectiveInRange ? 'Inside Office Radius' : 'Outside Office Radius',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: _effectiveInRange ? AppColors.success : AppColors.error,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _selectedLocation == 'Remote / Work From Home (WFH)'
                                        ? 'WFH Active (Bypassing geo-fence coordinates)'
                                        : _effectiveInRange
                                            ? 'HQ Geo-fence Verified (Range: 100m)'
                                            : 'Located Outside Allowed Office Geo-fence',
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (_fetchedLatitude != null && _fetchedLongitude != null) ...[
                          const Divider(height: 24),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'GPS Coordinates Verified:',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Lat: ${_fetchedLatitude!.toStringAsFixed(6)} • Lng: ${_fetchedLongitude!.toStringAsFixed(6)} • Accuracy: ${_fetchedAccuracy!.toStringAsFixed(1)}m',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textLight,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                if (_fetchedTimestamp != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      'Verified GPS Time: $_fetchedTimestamp',
                                      style: const TextStyle(fontSize: 9, color: AppColors.textLight),
                                    ),
                                  ),
                                if (_calculatedDistance != null)
                                  Text(
                                    'Distance from office center: ${_calculatedDistance!.toStringAsFixed(1)} meters',
                                    style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                                  ),
                              ],
                            ),
                          ),
                        ],
                        const Divider(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Shift Timing:',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textLight),
                            ),
                            Text(
                              'General Shift (09:00 AM - 06:00 PM)',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _triggerPunchInSequence,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _effectiveInRange ? AppColors.primary : AppColors.warning,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: Text(_effectiveInRange ? 'Start Smart Punch In' : 'Punch In Out Of Range'),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else if (_punchStep == 1) ...[
                // Location Permission Simulator Dialog / Card
                AttendancePermissionCard(
                  isLocationStep: true,
                  isPermanentlyDenied: _isLocationPermanentlyDenied,
                  onCancel: () => setState(() => _punchStep = 0),
                  onOpenSettings: () async {
                    await openAppSettings();
                    await _updatePermissionStatuses();
                  },
                  onAllowAccess: () async {
                    final status = await Permission.locationWhenInUse.request();
                    if (status.isGranted) {
                      setState(() {
                        _punchStep = 2; // Next Step: Camera Permission
                      });
                      var camStatus = await Permission.camera.status;
                      setState(() {
                        _isCameraPermanentlyDenied = camStatus.isPermanentlyDenied;
                      });
                    } else {
                      if (status.isPermanentlyDenied) {
                        setState(() {
                          _isLocationPermanentlyDenied = true;
                        });
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permission denied.')));
                        }
                        setState(() => _punchStep = 0);
                      }
                    }
                  },
                ),
              ] else if (_punchStep == 2) ...[
                // Camera Permission Simulator Dialog / Card
                AttendancePermissionCard(
                  isLocationStep: false,
                  isPermanentlyDenied: _isCameraPermanentlyDenied,
                  onCancel: () => setState(() => _punchStep = 0),
                  onOpenSettings: () async {
                    await openAppSettings();
                    await _updatePermissionStatuses();
                  },
                  onAllowAccess: () async {
                    final status = await Permission.camera.request();
                    if (status.isGranted) {
                      _startGeofenceCheck();
                    } else {
                      if (status.isPermanentlyDenied) {
                        setState(() {
                          _isCameraPermanentlyDenied = true;
                        });
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Camera permission denied.')));
                        }
                        setState(() => _punchStep = 0);
                      }
                    }
                  },
                ),
              ] else if (_punchStep == 3) ...[
                // Geofence Coordinate loading
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        const CircularProgressIndicator(color: AppColors.primary),
                        const SizedBox(height: 20),
                        const Text('Geo-fencing verification in progress...', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          'Fetching coordinates for $_selectedLocation',
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else if (_punchStep == 4) ...[
                // Face scanner liveness check
                FaceLivenessScanner(
                  livenessStep: _livenessStep,
                  onStartRealLivenessSDK: _startRealLivenessSDK,
                  onSimulateBlink: _simulateLivenessBlink,
                  onSimulateHead: _simulateLivenessHead,
                ),
              ] else if (_punchStep == 6) ...[
                // Out of range check-in form
                OutOfRangeForm(
                  reasonController: _reasonController,
                  onSubmit: _submitOutOfRangeRequest,
                  onCancel: () => setState(() => _punchStep = 0),
                ),
              ] else ...[
                // PUNCHED IN - CIRCULAR TIMER & BREAKS VIEW
                BreakTimerConsole(
                  activeActivity: _activeActivity,
                  livenessSuccess: _livenessSuccess,
                  simulateOverBreakLimit: _simulateOverBreakLimit,
                  onSimulateOverBreakLimitChanged: (val) {
                    setState(() {
                      _simulateOverBreakLimit = val ?? false;
                    });
                  },
                  timerColor: _getTimerColor(),
                  timerStatusText: _getTimerStatusText(),
                  timerValue:
                      _activeActivity == 3
                          ? (_simulateOverBreakLimit ? '00:50:00' : '00:40:00')
                          : _activeActivity == 4
                              ? (_simulateOverBreakLimit ? '00:20:00' : '00:10:00')
                              : '05:42:18',
                  timerLimitText:
                      _activeActivity == 3
                          ? 'Lunch Limit: 45m'
                          : _activeActivity == 4
                              ? 'Tea Limit: 15m'
                              : 'Shift Target: 09:00',
                  breaksHistory: _breaksHistory,
                  onBreakButtonPressed: (activityCode) {
                    setState(() {
                      _activeActivity = _activeActivity == activityCode ? 2 : activityCode;
                    });
                  },
                  onPunchOut: () {
                    setState(() {
                      _punchStep = 0; // Punch Out resets to default
                      _livenessSuccess = false;
                      _fetchedLatitude = null;
                      _fetchedLongitude = null;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Punch Out complete. Bio-verification cleared.'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                ),
              ],
            ] else ...[
              // SUPERVISOR / TEAM BOARD VIEWPORT
              SupervisorAttendanceList(teamAttendance: _teamAttendance),
            ],
          ],
        ),
      ),
    );
  }

  void _showSQLiteLogsDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Row(
              children: const [
                Icon(Icons.storage_rounded, color: AppColors.primary),
                SizedBox(width: 8),
                Text('SQLite Encrypted DB Logs'),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _syncLogs.length,
                itemBuilder:
                    (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(_syncLogs[index], style: const TextStyle(fontSize: 11, fontFamily: 'monospace')),
                    ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
            ],
          ),
    );
  }
}
