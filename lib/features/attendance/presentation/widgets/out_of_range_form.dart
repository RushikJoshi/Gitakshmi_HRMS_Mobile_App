import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/widgets/textfield/app_text_field.dart';

class OutOfRangeForm extends StatelessWidget {
  final TextEditingController reasonController;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const OutOfRangeForm({
    super.key,
    required this.reasonController,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: const [
                Icon(Icons.warning_amber_rounded, color: AppColors.warning),
                SizedBox(width: 8),
                Text('Outside Geo-fence Request', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'You are outside the office coordinates range. Provide a reason to submit a manual check-in request.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
                        AppTextField(
              controller: reasonController,
              labelText: 'Reason for Out-of-Range check-in',
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Selfie uploaded successfully.')),
                );
              },
              icon: const Icon(Icons.add_a_photo_rounded),
              label: const Text('Upload Proof Photo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: onSubmit, child: const Text('Submit Attendance Request')),
            TextButton(onPressed: onCancel, child: const Text('Cancel')),
          ],
        ),
      ),
    );
  }
}
