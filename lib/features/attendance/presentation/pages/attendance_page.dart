import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_face_liveness/flutter_face_liveness.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/responsive_helper.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Public entry-point
// ─────────────────────────────────────────────────────────────────────────────
Future<void> showPunchInSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    enableDrag: true,
    builder: (_) => const _PunchInBottomSheet(),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// AttendancePage stub
// ─────────────────────────────────────────────────────────────────────────────
class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text('Attendance'),
        backgroundColor: AppColors.blue600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: ResponsiveCenteredView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.fingerprint, size: 72.w, color: AppColors.blue500),
              SizedBox(height: 20.h),
              Text(
                'Use Punch In from Dashboard',
                style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step enum
// ─────────────────────────────────────────────────────────────────────────────
enum _Step { verifyingLocation, inRange, outOfRange }

const double _officeLat = 23.0225;
const double _officeLng = 72.5714;
const double _allowedRadiusMeters = 300;

// ─────────────────────────────────────────────────────────────────────────────
// Bottom Sheet — handles location only, then pushes face scanner route
// ─────────────────────────────────────────────────────────────────────────────
class _PunchInBottomSheet extends StatefulWidget {
  const _PunchInBottomSheet();
  @override
  State<_PunchInBottomSheet> createState() => _PunchInBottomSheetState();
}

class _PunchInBottomSheetState extends State<_PunchInBottomSheet> {
  _Step _step = _Step.verifyingLocation;

  // Location
  double _distanceMeters = 0;
  String _locationAddress = '';
  String _locationCoordinates = '';
  double? _lastLat;
  double? _lastLng;
  String _gpsAccuracy = 'Medium';
  bool _locationError = false;
  DateTime? _locationTime;

  // Out-of-range form
  final _reasonController = TextEditingController();
  String? _selectedDayType;
  final _formKey = GlobalKey<FormState>();

  // Auto-close
  Timer? _autoCloseTimer;
  int _countdown = 120;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    _reasonController.dispose();
    super.dispose();
  }

  // ── Real GPS + Geocoding ─────────────────────────────────────────────────
  Future<void> _fetchLocation() async {
    try {
      bool svcEnabled = await Geolocator.isLocationServiceEnabled();
      if (!svcEnabled) {
        _setError('Location services are disabled. Please enable GPS.');
        return;
      }

      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        _setError('Location permission denied. Please allow it in Settings.');
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
          timeLimit: Duration(seconds: 20),
        ),
      );

      final coordinates =
          'Lat: ${pos.latitude.toStringAsFixed(6)}, Lng: ${pos.longitude.toStringAsFixed(6)}';

      if (mounted) {
        setState(() {
          _locationCoordinates = coordinates;
          _lastLat = pos.latitude;
          _lastLng = pos.longitude;
          _locationAddress = 'Resolving current location...';
          _locationTime = DateTime.now();
          _gpsAccuracy = pos.accuracy < 10
              ? 'High'
              : pos.accuracy < 35
              ? 'Medium'
              : 'Low';
          _distanceMeters = Geolocator.distanceBetween(
            pos.latitude,
            pos.longitude,
            _officeLat,
            _officeLng,
          );
          _step = _distanceMeters <= _allowedRadiusMeters
              ? _Step.inRange
              : _Step.outOfRange;
          _locationError = false;
        });
        _startAutoClose();
        if (_step == _Step.inRange) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'You are within office premises — launching face scan',
                ),
                backgroundColor: Color(0xFF0FBE7C),
                duration: Duration(milliseconds: 800),
              ),
            );
          }
          // Small delay to let UI and SnackBar show, then launch face scanner
          Future.delayed(const Duration(milliseconds: 900), () {
            if (mounted) _goToFaceScanner();
          });
        }
      }

      // Reverse-geocode in background and update address
      try {
        final marks = await placemarkFromCoordinates(
          pos.latitude,
          pos.longitude,
        );
        if (marks.isNotEmpty && mounted) {
          setState(() => _locationAddress = _formatPlacemark(marks.first));
        }
      } catch (_) {
        if (mounted) {
          setState(() => _locationAddress = 'Unable to resolve address');
        }
      }
    } catch (e) {
      _setError('Could not fetch location. Please try again.');
    }
  }

  void _setError(String msg) {
    if (!mounted) return;
    setState(() {
      _locationError = true;
      _locationAddress = msg;
      _locationCoordinates = '';
      _lastLat = null;
      _lastLng = null;
      _locationTime = DateTime.now();
      _step = _Step.outOfRange;
      _distanceMeters = 0;
    });
    _startAutoClose();
  }

  // ── Timer ────────────────────────────────────────────────────────────────
  void _startAutoClose() {
    _countdown = 120;
    _autoCloseTimer?.cancel();
    _autoCloseTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _countdown--);
      if (_countdown <= 0) {
        t.cancel();
        if (mounted) Navigator.of(context).pop();
      }
    });
  }

  // ── Navigate to face scanner (full-screen route) ──────────────────────────
  Future<void> _goToFaceScanner() async {
    _autoCloseTimer?.cancel();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const FaceScannerPage(),
      ),
    );
    if (!mounted) return;
    if (result == true) {
      // Success — show success state briefly then close sheet
      Navigator.of(context).pop();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'Punched In Successfully!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            backgroundColor: Color(0xFF0FBE7C),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      // Failed / cancelled — restart auto-close
      _startAutoClose();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return switch (_step) {
      _Step.verifyingLocation => _sheetWrap(_buildVerifying()),
      _Step.inRange => _sheetWrap(_buildInRange()),
      _Step.outOfRange => _buildOutOfRange(), // full DraggableSheet
    };
  }

  Widget _sheetWrap(Widget child) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(top: false, child: child),
    );
  }

  // ─── Verifying ──────────────────────────────────────────────────────────
  Widget _buildVerifying() {
    return SizedBox(
      height: 370.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _dragHandle(),
          const Spacer(),
          Container(
            width: 88.w,
            height: 88.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3F81FF), Color(0xFF2667E0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.blue500.withValues(alpha: 0.28),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Icon(Icons.gps_fixed, color: Colors.white, size: 40.sp),
          ),
          SizedBox(height: 24.h),
          Text(
            'Verifying Location',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Fetching your real-time GPS location…',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
          ),
          SizedBox(height: 28.h),
          const SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation(AppColors.blue500),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  // ─── In Range ───────────────────────────────────────────────────────────
  Widget _buildInRange() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.62,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _dragHandle(),
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Location Verified ✓',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0FBE7C),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${_distanceMeters.toStringAsFixed(1)} m from office',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          // Time + Accuracy
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 13,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: 4.w),
                Text(
                  _formatDT(_locationTime ?? DateTime.now()),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                const Text(
                  'GPS Accuracy : ',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                _gpsBadge(_gpsAccuracy),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: _locationCard(),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFF6EE7B7)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF0FBE7C),
                    size: 20.sp,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      'You are within office premises!',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF065F46),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          _autoCloseRow(),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
            child: _gradientBtn(
              label: 'Proceed to Face Scan',
              onTap: _goToFaceScanner,
              colors: const [Color(0xFF0FBE7C), Color(0xFF0AAD6F)],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Out of Range ────────────────────────────────────────────────────────
  Widget _buildOutOfRange() {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.55,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollCtrl) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              controller: scrollCtrl,
              padding: EdgeInsets.zero,
              children: [
                // ── Drag handle ───────────────────────────────────────────
                _dragHandle(),

                // ── UFO illustration ─────────────────────────────────────
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 200.h,
                      child: Image.asset(
                        'assets/images/ufo_abduction.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Fade to white at the bottom of the image
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 70.h,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.white],
                          ),
                        ),
                      ),
                    ),
                    // Close button
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // ── Content ──────────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        _locationError
                            ? 'Location Unavailable'
                            : 'You are Out of Range',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _locationError
                            ? 'Unable to fetch location'
                            : '${_distanceMeters.toStringAsFixed(2)} Meter Away (Air Distance)',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 10.h),

                      // Time + Accuracy
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 13,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDT(_locationTime ?? DateTime.now()),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            'GPS Accuracy : ',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          _gpsBadge(_gpsAccuracy),
                        ],
                      ),
                      SizedBox(height: 14.h),

                      // Current Location label
                      const Text(
                        'Current Location',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _locationCard(),
                      SizedBox(height: 20.h),

                      // ── Day Type ────────────────────────────────────────
                      const Text(
                        'Day Type',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      DropdownButtonFormField<String>(
                        value: _selectedDayType,
                        decoration: _inputDeco('Select'),
                        items:
                            ['Work From Home', 'Field Work', 'On Duty', 'Other']
                                .map(
                                  (o) => DropdownMenuItem(
                                    value: o,
                                    child: Text(o),
                                  ),
                                )
                                .toList(),
                        validator: (v) =>
                            v == null ? 'Please select a day type' : null,
                        onChanged: (v) => setState(() => _selectedDayType = v),
                      ),
                      SizedBox(height: 16.h),

                      // ── Out of range reason ─────────────────────────────
                      const Text(
                        'Out of range Reason',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _reasonController,
                        maxLines: 2,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                        decoration: _inputDeco('Write here'),
                      ),
                      SizedBox(height: 24.h),

                      // Auto-close countdown
                      _autoCloseRow(),
                      SizedBox(height: 14.h),

                      // Prev / Next
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                side: const BorderSide(
                                  color: AppColors.blue600,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: const Text(
                                'Prev',
                                style: TextStyle(
                                  color: AppColors.blue600,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: _gradientBtn(
                              label: 'Next',
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  _goToFaceScanner();
                                }
                              },
                              colors: const [
                                AppColors.blue500,
                                AppColors.blue600,
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Shared helpers
  // ─────────────────────────────────────────────────────────────────────────
  Widget _dragHandle() => Center(
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      width: 40.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: AppColors.gray200,
        borderRadius: BorderRadius.circular(4.r),
      ),
    ),
  );

  Widget _autoCloseRow() {
    final m = _countdown ~/ 60;
    final s = _countdown % 60;
    return Center(
      child: Text(
        'Auto Close In  ${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}',
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.blue500,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _gpsBadge(String label) {
    final color = label == 'High'
        ? const Color(0xFF0FBE7C)
        : label == 'Medium'
        ? const Color(0xFFF59E0B)
        : const Color(0xFFEF4444);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _locationCard() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFFFCDD2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: const Icon(Icons.location_on, color: Color(0xFFEF5350), size: 20),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _locationAddress.isEmpty
                      ? 'Fetching address…'
                      : _locationAddress,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8B1A1A),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (_locationCoordinates.isNotEmpty && !_locationError) ...[
                  SizedBox(height: 4.h),
                  Text(
                    _locationCoordinates,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFFB35A5A),
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (_step != _Step.inRange) ...[
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: () async {
                await _openMap();
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: _lastLat != null && _lastLng != null
                    ? Image.network(
                        'https://staticmap.openstreetmap.de/staticmap.php?center=${_lastLat},${_lastLng}&zoom=15&size=120x120&markers=${_lastLat},${_lastLng},red-pushpin',
                        width: 40.w,
                        height: 40.w,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/mock_map_thumbnail.png',
                            width: 40.w,
                            height: 40.w,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/images/mock_map_thumbnail.png',
                        width: 40.w,
                        height: 40.w,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  InputDecoration _inputDeco(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: AppColors.textLight, fontSize: 13.sp),
    prefixIcon: const Icon(Icons.edit_note_rounded, color: AppColors.textLight),
    contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
    filled: true,
    fillColor: AppColors.surfacePrimary,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: const BorderSide(color: AppColors.textfieldBorder),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: const BorderSide(color: AppColors.textfieldBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: const BorderSide(color: AppColors.blue500, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: const BorderSide(color: AppColors.error),
    ),
  );

  String _formatPlacemark(Placemark placeMark) {
    final parts = <String>[
      if (placeMark.subThoroughfare?.isNotEmpty == true)
        placeMark.subThoroughfare!,
      if (placeMark.thoroughfare?.isNotEmpty == true) placeMark.thoroughfare!,
      if (placeMark.street?.isNotEmpty == true) placeMark.street!,
    ];
    final uniqueParts = <String>[];
    for (final part in parts) {
      if (!uniqueParts.contains(part)) {
        uniqueParts.add(part);
      }
    }
    return uniqueParts.isEmpty ? 'Current location found' : uniqueParts.join(', ');
  }

  Future<void> _openMap() async {
    if (_lastLat == null || _lastLng == null) return;
    final lat = _lastLat!;
    final lng = _lastLng!;
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // ignore
    }
  }

  Widget _gradientBtn({
    required String label,
    required VoidCallback onTap,
    required List<Color> colors,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: colors.last.withValues(alpha: 0.3),
              blurRadius: 14.r,
              offset: Offset(0, 5.h),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }

  String _formatDT(DateTime dt) {
    String p(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}-${p(dt.month)}-${p(dt.day)}  ${p(dt.hour)}:${p(dt.minute)}:${p(dt.second)}';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FaceScannerPage — full-screen, hosts FlutterFaceLiveness properly
// ─────────────────────────────────────────────────────────────────────────────
class FaceScannerPage extends StatelessWidget {
  const FaceScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── Real liveness scanner ───────────────────────────────────────
          FlutterFaceLiveness(
            actions: const [
              LivenessAction.blink,
              LivenessAction.smile,
              LivenessAction.turnLeft,
            ],
            config: const LivenessConfig(
              randomizeActions: true,
              enableAntiSpoof: true,
              sessionTimeoutMs: 90000,
              themeMode: ThemeMode.dark,
            ),
            onSuccess: (result) {
              // Pop back with true = success
              Navigator.of(context).pop(true);
            },
            onFailed: (reason) {
              // Show a bottom dialog and allow retry or exit
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (ctx) => _FailedSheet(
                  reason: reason,
                  onRetry: () {
                    Navigator.pop(ctx); // close sheet
                    // Rebuild the FaceScannerPage by popping and pushing again
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (_) => const FaceScannerPage(),
                      ),
                    );
                  },
                  onCancel: () {
                    Navigator.pop(ctx); // close sheet
                    Navigator.of(context).pop(false); // back to bottom sheet
                  },
                ),
              );
            },
          ),

          // ── Tips card at bottom ─────────────────────────────────────────
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 24.h,
            left: 16.w,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                   Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFFBBF24),
                        size: 15,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Remove before scanning',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  _Tip('Sunglasses'),
                  _Tip('Masks'),
                  _Tip('Cap / Hat'),
                ],
              ),
            ),
          ),

          // ── Back / close button ─────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 8.h,
            left: 12.w,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: Container(
                padding: EdgeInsets.all(9.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Failure bottom sheet inside face scanner
// ─────────────────────────────────────────────────────────────────────────────
class _FailedSheet extends StatelessWidget {
  final String reason;
  final VoidCallback onRetry;
  final VoidCallback onCancel;
  const _FailedSheet({
    required this.reason,
    required this.onRetry,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4.w,
            height: 4.w,
            decoration: BoxDecoration(
              color: AppColors.gray200,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.error.withValues(alpha: 0.35),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.face_retouching_off,
              color: AppColors.error,
              size: 36,
            ),
          ),
          SizedBox(height: 16.h),
          const Text(
            'Verification Failed',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            reason.isNotEmpty
                ? reason
                : 'Face liveness check failed. Please try again.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    side: const BorderSide(color: AppColors.gray400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: GestureDetector(
                  onTap: onRetry,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.blue500, AppColors.blue600],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Center(
                      child: Text(
                        'Try Again',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8.h),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tip row
// ─────────────────────────────────────────────────────────────────────────────
class _Tip extends StatelessWidget {
  final String text;
  const _Tip(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3.h),
      child: Row(
        children: [
          const Text(
            '• ',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
