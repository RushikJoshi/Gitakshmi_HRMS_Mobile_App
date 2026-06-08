import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _mockGpsDetection = true;
  bool _rootDetection = true;
  bool _sessionSecurity = true;
  bool _deviceBinding = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings & Security'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Security settings title
            const Text('Security Features', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildSwitchTile(
                      Icons.gps_fixed_rounded,
                      'Mock GPS Detection',
                      'Restricts login if fake GPS coords are active.',
                      _mockGpsDetection,
                      (val) {
                        setState(() {
                          _mockGpsDetection = val;
                        });
                        _showConfirmationSnackBar('Mock GPS Detection ${_mockGpsDetection ? "Enabled" : "Disabled"}');
                      },
                    ),
                    const Divider(),
                    _buildSwitchTile(
                      Icons.security_rounded,
                      'Root / Jailbreak Detection',
                      'Blocks application on compromised devices.',
                      _rootDetection,
                      (val) {
                        setState(() {
                          _rootDetection = val;
                        });
                        _showConfirmationSnackBar('Root Detection ${_rootDetection ? "Enabled" : "Disabled"}');
                      },
                    ),
                    const Divider(),
                    _buildSwitchTile(
                      Icons.phonelink_lock_rounded,
                      'Device Binding',
                      'Restricts profile logins strictly to registered devices.',
                      _deviceBinding,
                      (val) {
                        setState(() {
                          _deviceBinding = val;
                        });
                        _showConfirmationSnackBar('Device Binding ${_deviceBinding ? "Enabled" : "Disabled"}');
                      },
                    ),
                    const Divider(),
                    _buildSwitchTile(
                      Icons.timer_rounded,
                      'Session Security Timeout',
                      'Auto logs out profile after 30 mins inactive.',
                      _sessionSecurity,
                      (val) {
                        setState(() {
                          _sessionSecurity = val;
                        });
                        _showConfirmationSnackBar('Session Timeout Protection ${_sessionSecurity ? "Enabled" : "Disabled"}');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      secondary: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      activeColor: AppColors.primary,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _showConfirmationSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
