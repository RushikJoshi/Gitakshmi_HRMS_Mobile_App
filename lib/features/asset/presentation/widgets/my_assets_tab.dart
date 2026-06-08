import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

class MyAssetsTab extends StatelessWidget {
  final List<CompanyAssetModel> assets;
  final Color primaryColor;
  final Function(CompanyAssetModel) onReturnInitiated;

  const MyAssetsTab({
    super.key,
    required this.assets,
    required this.primaryColor,
    required this.onReturnInitiated,
  });

  @override
  Widget build(BuildContext context) {
    if (assets.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.devices_other_rounded, size: 60, color: AppColors.textLight),
              SizedBox(height: 16),
              Text(
                'No Assets Assigned',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
              ),
              SizedBox(height: 8),
              Text(
                'You do not have any corporate hardware or credentials assigned to your profile in this context.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: assets.length,
      itemBuilder: (context, index) {
        final asset = assets[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _openAssetDetailSheet(context, asset),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      asset.category == 'IT'
                          ? Icons.laptop_mac_rounded
                          : asset.category == 'Office'
                              ? Icons.badge_rounded
                              : Icons.directions_car_rounded,
                      color: primaryColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          asset.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Code: ${asset.assetCode} • Serial: ${asset.serialNumber}',
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Issued on: ${asset.issueDate}',
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Assigned',
                          style: TextStyle(color: Colors.green, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.healing_rounded, size: 12, color: primaryColor),
                          const SizedBox(width: 4),
                          Text(
                            'Health: ${asset.healthScore.toInt()}%',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: primaryColor),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openAssetDetailSheet(BuildContext context, CompanyAssetModel asset) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: SingleChildScrollView(
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
                    Text(
                      asset.category == 'IT' ? 'IT Hardware Asset' : asset.category == 'Office' ? 'Office Access Credentials' : 'Field Equipment',
                      style: TextStyle(fontSize: 12, color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                    IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
                  ],
                ),
                Text(
                  asset.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade100),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Diagnostic Score', style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.green.withValues(alpha: 0.1),
                                  child: const Icon(Icons.health_and_safety_rounded, color: Colors.green, size: 20),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${asset.healthScore.toInt()}% Score',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text('Condition Checklist:', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textLight)),
                            const SizedBox(height: 4),
                            _buildHealthCheckItem('Hardware diagnostics scan clean', true),
                            _buildHealthCheckItem('Firmware is up-to-date', true),
                            _buildHealthCheckItem('Physical condition: ${asset.condition}', asset.condition != 'Poor'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.qr_code_2_rounded, size: 70, color: Colors.black),
                            const SizedBox(height: 4),
                            Text(
                              asset.assetCode,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),

                const Text('Asset Specifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                _buildInfoTile('Brand', asset.brand),
                _buildInfoTile('Model', asset.model),
                _buildInfoTile('Serial Number', asset.serialNumber),
                _buildInfoTile('Warranty Start', asset.warrantyStart),
                _buildInfoTile('Warranty Expiration', asset.warrantyEnd),
                _buildInfoTile('Purchase Date', asset.purchaseDate),
                ...asset.specifications.entries.map((e) => _buildInfoTile(e.key, e.value)),

                const SizedBox(height: 20),
                const Text('Assigned Documents', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                _buildDocItemTile(context, asset.documentManual, 'User Manual Guide'),
                _buildDocItemTile(context, asset.documentInvoice, 'Purchase Invoice Receipt'),

                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.assignment_return_rounded, color: Colors.white),
                  label: const Text('Initiate Return / Exit Release', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.pop(context);
                    onReturnInitiated(asset);
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHealthCheckItem(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Row(
        children: [
          Icon(
            value ? Icons.check_circle_outline_rounded : Icons.warning_amber_rounded,
            color: value ? Colors.green : Colors.amber,
            size: 10,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 8, color: Colors.grey.shade600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildDocItemTile(BuildContext context, String name, String type) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.grey.shade100)),
      child: ListTile(
        dense: true,
        leading: Icon(Icons.picture_as_pdf_rounded, color: primaryColor, size: 20),
        title: Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        subtitle: Text(type, style: const TextStyle(fontSize: 10)),
        trailing: IconButton(
          icon: Icon(Icons.download_rounded, color: primaryColor, size: 18),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Downloading document: $name')),
            );
          },
        ),
      ),
    );
  }
}
