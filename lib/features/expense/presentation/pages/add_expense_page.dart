import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'expense_management_page.dart';

enum UploadState { idle, uploading, completed }

class ApplyExpenseScreen extends StatefulWidget {
  const ApplyExpenseScreen({super.key});

  @override
  State<ApplyExpenseScreen> createState() => _ApplyExpenseScreenState();
}

class _ApplyExpenseScreenState extends State<ApplyExpenseScreen> {
  // Upload state management
  UploadState _uploadState = UploadState.idle;
  int _uploadProgress = 0;
  Timer? _uploadTimer;

  // Selected image tracking
  String? _selectedImagePath;
  bool _isUsingMockImage = false;

  // Form controllers
  String? _selectedCategory;
  DateTime? _selectedDate;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> _categories = [
    'Business Trip',
    'Office Supplies',
    'Meals and Entertainment',
    'Professional Development',
    'Home Office Expenses',
    'Mileage Reimbursement',
    'Miscellaneous Expenses',
  ];

  @override
  void dispose() {
    _uploadTimer?.cancel();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Opens choice modal for Image selection
  void _showImageSourceBottomSheet() {
    const Color brandPurple = Color(0xFF7A5AF8);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  "Select Receipt Source",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF101828),
                  ),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded, color: brandPurple),
                title: const Text('Take Photo', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded, color: brandPurple),
                title: const Text('Upload from Gallery', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.receipt_rounded, color: brandPurple),
                title: const Text('Use Mock Receipt', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context);
                  _useMockReceipt();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // Pick image via ImagePicker
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: source);
      if (image == null) return; // cancelled

      setState(() {
        _uploadState = UploadState.uploading;
        _uploadProgress = 0;
        _selectedImagePath = image.path;
        _isUsingMockImage = false;
      });

      _startSimulatedUpload();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  // Fallback / standard mock receipt
  void _useMockReceipt() {
    setState(() {
      _uploadState = UploadState.uploading;
      _uploadProgress = 0;
      _isUsingMockImage = true;
      _selectedImagePath = null;
    });

    _startSimulatedUpload();
  }

  // Simulated upload progress animation
  void _startSimulatedUpload() {
    _uploadTimer?.cancel();
    _uploadTimer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      setState(() {
        if (_uploadProgress < 100) {
          _uploadProgress += 5;
        } else {
          _uploadTimer?.cancel();
          _uploadState = UploadState.completed;
        }
      });
    });
  }

  void _cancelUpload() {
    _uploadTimer?.cancel();
    setState(() {
      _uploadState = UploadState.idle;
      _uploadProgress = 0;
      _selectedImagePath = null;
      _isUsingMockImage = false;
    });
  }

  // Helper to format date: e.g. "27 September 2024"
  String _formatDate(DateTime date) {
    final orderedMonths = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return "${date.day} ${orderedMonths[date.month - 1]} ${date.year}";
  }

  // Helper to open calendar date picker
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6938EF),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Form Submission Flow
  void _submitExpense() {
    if (_uploadState != UploadState.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload a claim document receipt.')),
      );
      return;
    }
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an expense category.')),
      );
      return;
    }
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a transaction date.')),
      );
      return;
    }
    final double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid expense amount.')),
      );
      return;
    }
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an expense description.')),
      );
      return;
    }

    final newItem = ExpenseSummaryItem(
      date: _formatDate(_selectedDate!),
      type: _selectedCategory!,
      amount: amount,
      status: ExpenseStatus.review,
    );

    _showConfirmationBottomSheet(newItem);
  }

  // 1. "Ready to Submit?" Confirmation Bottom Sheet
  void _showConfirmationBottomSheet(ExpenseSummaryItem newItem) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
              ),
              padding: const EdgeInsets.only(top: 48, left: 24, right: 24, bottom: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Ready to Submit?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF101828),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Double-check your expense details to ensure\neverything is correct. Do you want to proceed?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF475467),
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6938EF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Close Ready to Submit sheet
                        _showSuccessBottomSheet(newItem); // Show success sheet
                      },
                      child: const Text(
                        "Yes, Submit",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF7A5AF8),
                        side: const BorderSide(color: Color(0xFFB396FF)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "No, Let me check",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Overlapping Icon
            Positioned(
              top: -30,
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF7A5AF8),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7A5AF8).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // 2. "Expense Submitted!" Success Bottom Sheet
  void _showSuccessBottomSheet(ExpenseSummaryItem newItem) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
              ),
              padding: const EdgeInsets.only(top: 48, left: 24, right: 24, bottom: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Expense Submitted!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF101828),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Your expense report is in! You'll receive your\nreimbursement with your payroll.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF475467),
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6938EF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Close Success sheet
                        Navigator.pop(this.context, newItem); // Pop ApplyExpenseScreen returning new item
                      },
                      child: const Text(
                        "View Expense History",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Overlapping Icon
            Positioned(
              top: -30,
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF7A5AF8),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7A5AF8).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color brandPurple = Color(0xFF6938EF);
    const Color brandLightPurple = Color(0xFFF4F3FF);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header / AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                          color: brandLightPurple,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.chevron_left_rounded,
                          color: brandPurple,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    "Submit Expense",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1D2939),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Banner Illustration
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        "assets/images/submit_expense_banner.png",
                        width: double.infinity,
                        height: 155,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 155,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF8C5CF8), Color(0xFF6A36EF)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Text(
                                "Ensure All Document Well Prepared\n1000+ Expenses already approved",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Fill Claim Section card container
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Fill Claim Information",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF101828),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Information about claim details",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF667085),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // 1. Image Upload Container
                          _buildUploadContainer(brandPurple),
                          const SizedBox(height: 20),

                          // 2. Expense Category Label & Dropdown
                          _buildFormLabel("Expense Category"),
                          const SizedBox(height: 6),
                          _buildCategoryDropdown(brandPurple),
                          const SizedBox(height: 18),

                          // 3. Transaction Date Label & DatePicker trigger
                          _buildFormLabel("Transaction Date"),
                          const SizedBox(height: 6),
                          _buildDatePickerField(brandPurple),
                          const SizedBox(height: 18),

                          // 4. Expense Amount Label & Textfield
                          _buildFormLabel("Expense Amount (\$USD)"),
                          const SizedBox(height: 6),
                          _buildAmountField(brandPurple),
                          const SizedBox(height: 18),

                          // 5. Expense Description Label & Multiline Textfield
                          _buildFormLabel("Expense Description"),
                          const SizedBox(height: 6),
                          _buildDescriptionField(brandPurple),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Bottom Submit Button - Styled in Solid Brand Purple matching the latest user active button mockup
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandPurple, // Solid brand purple (0xFF6938EF)
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                  onPressed: _submitExpense,
                  child: const Text(
                    "Submit Expense",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Color(0xFF344054),
      ),
    );
  }

  // Upload Box Widget switcher based on State
  Widget _buildUploadContainer(Color brandPurple) {
    const double containerHeight = 220.0; // Responsive container height suited for showing receipts properly
    if (_uploadState == UploadState.idle) {
      return GestureDetector(
        onTap: _showImageSourceBottomSheet,
        child: CustomPaint(
          painter: DashedRectPainter(
            color: const Color(0xFFC7B8FF),
            strokeWidth: 1.2,
            gap: 4,
            dashLength: 6,
            borderRadius: 12,
          ),
          child: Container(
            height: 110.0, // Keeping idle container height compact
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Inner circle cloud icon
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEBE9FE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.cloud_upload_outlined,
                    color: Color(0xFF7A5AF8),
                    size: 18,
                  ),
                ),
                const SizedBox(height: 8),
                 Text(
                  "Upload Claim Document",
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: brandPurple,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Format should be in .pdf .jpeg .png less than 5MB",
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF98A2B3),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (_uploadState == UploadState.uploading) {
      return CustomPaint(
        painter: DashedRectPainter(
          color: const Color(0xFF3F81FF),
          strokeWidth: 1.2,
          gap: 4,
          dashLength: 6,
          borderRadius: 12,
        ),
        child: Container(
          height: 110.0, // Keeping upload container height compact
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F8FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              // Red delete/close button top right
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: _cancelUpload,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF04438),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ),
              // Progress indicator & description
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(
                            value: _uploadProgress / 100.0,
                            strokeWidth: 4.5,
                            backgroundColor: const Color(0xFFEBE9FE),
                            color: brandPurple,
                          ),
                        ),
                        Text(
                          "$_uploadProgress%",
                          style:  TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: brandPurple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                     Text(
                      "Uploading File...",
                      style: TextStyle(
                        fontSize: 12,
                        color: brandPurple,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // Completed Preview state - rendering selected image or mock receipt
      return Container(
        height: containerHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFEAECF0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD0D5DD)),
        ),
        child: Stack(
          children: [
            // Preview image fitting inside container
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _isUsingMockImage || _selectedImagePath == null
                  ? Image.asset(
                      "assets/images/mock_receipt.png",
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Icon(Icons.receipt, size: 48, color: Colors.grey));
                      },
                    )
                  : Image.file(
                      File(_selectedImagePath!),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
            // Red delete/close button top right
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: _cancelUpload,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF04438),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  // Custom Category Selector that opens Bottom Sheet matching mockup
  Widget _buildCategoryDropdown(Color brandPurple) {
    final String displayText = _selectedCategory ?? "Select Category";

    return InkWell(
      onTap: () => _showCategoryBottomSheet(brandPurple),
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: const Color(0xFFD0D5DD)),
        ),
        child: Row(
          children: [
            const Icon(Icons.assignment_rounded, color: Color(0xFF7A5AF8), size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                displayText,
                style: TextStyle(
                  color: _selectedCategory == null ? const Color(0xFF98A2B3) : const Color(0xFF344054),
                  fontSize: 14,
                  fontWeight: _selectedCategory == null ? FontWeight.w500 : FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.expand_more_rounded, color: Color(0xFF9B8AFB), size: 24),
          ],
        ),
      ),
    );
  }

  // Bottom Sheet Modal for selecting Category
  void _showCategoryBottomSheet(Color brandPurple) {
    String tempSelected = _selectedCategory ?? "Business Trip"; // Pre-select Business Trip as default in mockup

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 24.0, bottom: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Expense Category",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF101828),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Select Expense Category",
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF667085),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Scrollable category options list
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.45,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      children: _categories.map((category) {
                        final bool isSelected = tempSelected == category;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              tempSelected = category;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFF4F3FF) : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF9E77F1) : const Color(0xFFEAECF0),
                                width: isSelected ? 1.5 : 1.0,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  category,
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                                    color: const Color(0xFF344054),
                                  ),
                                ),
                                isSelected
                                    ? const Icon(
                                        Icons.check_circle_rounded,
                                        color: Color(0xFF7A5AF8),
                                        size: 20,
                                      )
                                    : Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color(0xFFD0D5DD),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  const Divider(color: Color(0xFFF2F4F7), height: 1),
                  const SizedBox(height: 16),
                  
                  // Bottom Buttons
                  Row(
                    children: [
                      // Outlined Close Message button
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF7A5AF8),
                              side: const BorderSide(color: Color(0xFFB396FF)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "Close Message",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Solid Submit Date button
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6938EF),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedCategory = tempSelected;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Submit Date",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Custom Date Picker Field
  Widget _buildDatePickerField(Color brandPurple) {
    final String labelText = _selectedDate == null
        ? "Enter Transaction Date"
        : _formatDate(_selectedDate!);

    return InkWell(
      onTap: _pickDate,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: const Color(0xFFD0D5DD)),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded, color: Color(0xFF7A5AF8), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                labelText,
                style: TextStyle(
                  color: _selectedDate == null ? const Color(0xFF98A2B3) : const Color(0xFF344054),
                  fontSize: 14,
                  fontWeight: _selectedDate == null ? FontWeight.w500 : FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.expand_more_rounded, color: Color(0xFF9B8AFB), size: 24),
          ],
        ),
      ),
    );
  }

  // Custom Amount input field
  Widget _buildAmountField(Color brandPurple) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: const Color(0xFFD0D5DD)),
      ),
      child: TextField(
        controller: _amountController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF344054),
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF7A5AF8), size: 18),
          hintText: "Enter Amount",
          hintStyle: TextStyle(
            color: Color(0xFF98A2B3),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12.0),
        ),
      ),
    );
  }

  // Custom Description field
  Widget _buildDescriptionField(Color brandPurple) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: const Color(0xFFD0D5DD)),
      ),
      child: TextField(
        controller: _descriptionController,
        maxLines: 4,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF344054),
          fontWeight: FontWeight.w500,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Enter Expense Description",
          hintStyle: TextStyle(
            color: Color(0xFF98A2B3),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12.0),
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// CUSTOM PAINTER FOR DASHED BORDERS
// ----------------------------------------------------
class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashLength;
  final double borderRadius;

  DashedRectPainter({
    this.color = Colors.grey,
    this.strokeWidth = 1.0,
    this.gap = 3.0,
    this.dashLength = 5.0,
    this.borderRadius = 8.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ));

    final dashPath = _buildDashedPath(path, dashLength, gap);
    canvas.drawPath(dashPath, paint);
  }

  Path _buildDashedPath(Path source, double dashWidth, double dashGap) {
    final Path dest = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      while (distance < metric.length) {
        final double len = draw ? dashWidth : dashGap;
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant DashedRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gap != gap ||
        oldDelegate.dashLength != dashLength ||
        oldDelegate.borderRadius != borderRadius;
  }
}
