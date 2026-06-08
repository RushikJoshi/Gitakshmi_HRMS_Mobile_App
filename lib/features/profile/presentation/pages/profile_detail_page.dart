import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/widgets/profile_personal_tab.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/widgets/profile_employment_tab.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/widgets/profile_documents_tab.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/widgets/profile_assets_tab.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/widgets/profile_leaves_tab.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/widgets/profile_payroll_tab.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/widgets/profile_attendance_tab.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/widgets/profile_settings_tab.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/widgets/profile_education_tab.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/widgets/profile_experience_tab.dart';
import 'package:gitakshmi_hrms_app/features/profile/presentation/widgets/profile_timeline_tab.dart';

class ProfileDetailPage extends StatefulWidget {
  final String category;
  final EmployeeProfileModel profile;
  final bool isSelf;
  final bool isHR;
  final bool canViewPayroll;
  final Color primaryColor;
  final VoidCallback onSaved;

  const ProfileDetailPage({
    super.key,
    required this.category,
    required this.profile,
    required this.isSelf,
    required this.isHR,
    required this.canViewPayroll,
    required this.primaryColor,
    required this.onSaved,
  });

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _mobileController;
  late TextEditingController _personalEmailController;
  late TextEditingController _positionController;
  late TextEditingController _dobController;
  
  late TextEditingController _currentLine1Controller;
  late TextEditingController _currentCityController;
  late TextEditingController _currentPincodeController;
  late TextEditingController _countryController;
  late TextEditingController _stateController;
  
  late TextEditingController _bankNameController;
  late TextEditingController _accountNumberController;
  late TextEditingController _ifscCodeController;
  late TextEditingController _upiIdController;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _firstNameController = TextEditingController(text: widget.profile.firstName);
    _lastNameController = TextEditingController(text: widget.profile.lastName);
    _mobileController = TextEditingController(text: widget.profile.mobileNumber);
    _personalEmailController = TextEditingController(text: widget.profile.personalEmail);
    _positionController = TextEditingController(text: 'Junior Full Stack Developer');
    _dobController = TextEditingController(text: widget.profile.dob.isNotEmpty ? widget.profile.dob : '10 December 1997');
    
    _currentLine1Controller = TextEditingController(text: widget.profile.addressDetails.currentLine1);
    _currentCityController = TextEditingController(text: widget.profile.addressDetails.currentCity);
    _currentPincodeController = TextEditingController(text: widget.profile.addressDetails.currentPincode);
    _countryController = TextEditingController(text: widget.profile.addressDetails.currentCountry.isNotEmpty ? widget.profile.addressDetails.currentCountry : 'Indonesia');
    _stateController = TextEditingController(text: widget.profile.addressDetails.currentState.isNotEmpty ? widget.profile.addressDetails.currentState : 'DKI Jakarta');
    
    _bankNameController = TextEditingController(text: widget.profile.bankDetails.bankName);
    _accountNumberController = TextEditingController(text: widget.profile.bankDetails.accountNumber);
    _ifscCodeController = TextEditingController(text: widget.profile.bankDetails.ifscCode);
    _upiIdController = TextEditingController(text: widget.profile.bankDetails.upiId);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _personalEmailController.dispose();
    _positionController.dispose();
    _dobController.dispose();
    _currentLine1Controller.dispose();
    _currentCityController.dispose();
    _currentPincodeController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _ifscCodeController.dispose();
    _upiIdController.dispose();
    super.dispose();
  }

  bool _canUserEdit(String category, bool isSelf, bool isHR) {
    if (isHR) return true;
    if (!isSelf) return false;
    if (category == 'Personal Details') return true;
    if (category == 'Bank Details') return true;
    return false;
  }

  Widget _buildCategoryBody(String category, StateSetter setModalState) {
    switch (category) {
      case 'Personal Details':
        return ProfilePersonalTab(
          profile: widget.profile,
          isEditing: _isEditing,
          isHR: widget.isHR,
          primaryColor: widget.primaryColor,
          firstNameController: _firstNameController,
          lastNameController: _lastNameController,
          mobileController: _mobileController,
          personalEmailController: _personalEmailController,
          positionController: _positionController,
          dobController: _dobController,
          currentLine1Controller: _currentLine1Controller,
          currentCityController: _currentCityController,
          currentPincodeController: _currentPincodeController,
          countryController: _countryController,
          stateController: _stateController,
        );
      case 'Professional Details':
        return ProfileEmploymentTab(
          profile: widget.profile,
          isHR: widget.isHR,
          canViewPayroll: widget.canViewPayroll,
        );
      case 'Education Details':
        return ProfileEducationTab(
          profile: widget.profile,
          isHR: widget.isHR,
          primaryColor: widget.primaryColor,
          setModalState: setModalState,
          openMockDocViewer: _openMockDocViewer,
        );
      case 'Experience Details':
        return ProfileExperienceTab(
          profile: widget.profile,
          isHR: widget.isHR,
          primaryColor: widget.primaryColor,
          setModalState: setModalState,
          openMockDocViewer: _openMockDocViewer,
        );
      case 'Document Vault':
        return ProfileDocumentsTab(
          profile: widget.profile,
          isHR: widget.isHR,
          primaryColor: widget.primaryColor,
          setModalState: setModalState,
          openMockDocViewer: _openMockDocViewer,
        );
      case 'Asset Inventory':
        return ProfileAssetsTab(
          profile: widget.profile,
          isHR: widget.isHR,
          primaryColor: widget.primaryColor,
          setModalState: setModalState,
        );
      case 'Stats Summary':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileAttendanceTab(
              profile: widget.profile,
              primaryColor: widget.primaryColor,
            ),
            const SizedBox(height: 16),
            ProfileLeavesTab(
              profile: widget.profile,
            ),
            const SizedBox(height: 16),
            ProfilePayrollTab(
              profile: widget.profile,
            ),
          ],
        );
      case 'Activity Timeline & Audits':
        return ProfileTimelineTab(
          profile: widget.profile,
        );
      case 'Settings & Configuration':
        return ProfileSettingsTab(
          profile: widget.profile,
          primaryColor: widget.primaryColor,
          setModalState: setModalState,
        );
      default:
        return const Center(child: Text('Section details loaded successfully.'));
    }
  }

  void _showUpdateDialogs(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialog1Context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Update Profile',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Are you sure you want to update your profile? This will help us improve your experience and provide personalized features.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF667085),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7544FC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          _executeSave(dialog1Context);
                        },
                        child: const Text(
                          'Yes, Update Profile',
                          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF7544FC)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: () => Navigator.pop(dialog1Context),
                        child: const Text(
                          'No, Let me check',
                          style: TextStyle(color: Color(0xFF7544FC), fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7544FC),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7544FC).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 44,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _executeSave(BuildContext dialog1Context) {
    final helper = RolePermissionHelper.instance;
    final newMobile = _mobileController.text;
    final newEmail = _personalEmailController.text;

    if (widget.isHR) {
      final updated = widget.profile.copyWith(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        mobileNumber: newMobile,
        personalEmail: newEmail,
        dob: _dobController.text,
        addressDetails: widget.profile.addressDetails.copyWith(
          currentLine1: _currentLine1Controller.text,
          currentCity: _currentCityController.text,
          currentPincode: _currentPincodeController.text,
          currentCountry: _countryController.text,
          currentState: _stateController.text,
        )
      );
      helper.updateProfile(widget.profile.employeeId, updated);
      
      helper.logAudit(
        helper.activeEmployee.name,
        '${widget.profile.firstName} ${widget.profile.lastName}',
        'Profile Details Updated',
        'HR updated personal profile details directly.',
      );
    } else {
      final updated = widget.profile.copyWith(
        mobileNumber: newMobile,
        personalEmail: newEmail,
        dob: _dobController.text,
        addressDetails: widget.profile.addressDetails.copyWith(
          currentLine1: _currentLine1Controller.text,
          currentCity: _currentCityController.text,
          currentPincode: _currentPincodeController.text,
          currentCountry: _countryController.text,
          currentState: _stateController.text,
        )
      );
      helper.updateProfile(widget.profile.employeeId, updated);
      
      helper.logAudit(
        helper.activeEmployee.name,
        '${widget.profile.firstName} ${widget.profile.lastName}',
        'Profile Details Updated',
        'Employee updated their contact numbers and address directly.',
      );
    }

    widget.onSaved();

    // Close Dialog 1
    Navigator.pop(dialog1Context);

    // Show Dialog 2
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialog2Context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Profile Updated!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Your profile has been successfully updated. We\'re excited to see you take this step!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF667085),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7544FC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.pop(dialog2Context);
                          setState(() {
                            _isEditing = false;
                          });
                        },
                        child: const Text(
                          'View My Profile',
                          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7544FC),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7544FC).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 44,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveProfileChanges(BuildContext context, String category, StateSetter setModalState) {
    if (_formKey.currentState?.validate() ?? false) {
      if (category == 'Personal Details') {
        _showUpdateDialogs(context);
        return;
      }

      final helper = RolePermissionHelper.instance;
      if (category == 'Bank Details') {
        if (!widget.isHR) {
          helper.requestProfileChange(
            employeeId: widget.profile.employeeId,
            category: 'Bank Details',
            fieldName: 'Account Number',
            oldValue: widget.profile.bankDetails.accountNumber,
            newValue: _accountNumberController.text,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bank Details update submitted to HR for approval!'), backgroundColor: Colors.amber),
          );
        } else {
          final updated = widget.profile.copyWith(
            bankDetails: BankDetails(
              bankName: _bankNameController.text,
              accountHolderName: widget.profile.bankDetails.accountNumber,
              accountNumber: _accountNumberController.text,
              ifscCode: _ifscCodeController.text,
              branchName: widget.profile.bankDetails.branchName,
              upiId: _upiIdController.text,
            )
          );
          helper.updateProfile(widget.profile.employeeId, updated);
          
          helper.logAudit(
            helper.activeEmployee.name,
            '${widget.profile.firstName} ${widget.profile.lastName}',
            'Bank Details Swapped',
            'HR updated bank ledger coordinates directly.',
          );
        }
      }

      setModalState(() {
        _isEditing = false;
      });
      
      widget.onSaved();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved successfully!'), backgroundColor: Colors.green),
      );
    }
  }

  void _openMockDocViewer(BuildContext context, String docName, String category) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        category,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10),
                Container(
                  height: 220,
                  color: Colors.grey.shade50,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.picture_as_pdf_rounded, size: 50, color: Colors.red),
                      const SizedBox(height: 12),
                      Text(docName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text('Size: 1.4 MB • Verified Mock Scan', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close Viewer'),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      icon: const Icon(Icons.download_rounded, color: Colors.white, size: 16),
                      label: const Text('Download File', style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Downloaded document: $docName')),
                        );
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final showEditButton = _canUserEdit(widget.category, widget.isSelf, widget.isHR) && !_isEditing;
    final isPersonalEdit = widget.category == 'Personal Details' && _isEditing;

    return Scaffold(
      backgroundColor: isPersonalEdit ? const Color(0xFFF7F8FC) : Colors.white,
      appBar: AppBar(
        backgroundColor: isPersonalEdit ? Colors.white : AppColors.blue500,
        elevation: 0,
        centerTitle: isPersonalEdit,
        iconTheme: IconThemeData(color: isPersonalEdit ? Colors.black : Colors.white),
        leading: isPersonalEdit
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F4FF),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF7A5AF8), size: 14),
                      onPressed: () {
                        setState(() {
                          _isEditing = false;
                          _initControllers();
                        });
                      },
                    ),
                  ),
                ),
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
        title: Text(
          isPersonalEdit ? 'Personal Data' : widget.category,
          style: TextStyle(
            color: isPersonalEdit ? Colors.black : Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (showEditButton)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton.icon(
                icon: Icon(Icons.edit_rounded, color: isPersonalEdit ? Colors.black : Colors.white, size: 18),
                label: Text('Edit', style: TextStyle(color: isPersonalEdit ? Colors.black : Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                onPressed: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
              ),
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isPersonalEdit ? 16 : 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildCategoryBody(widget.category, setState),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
          if (_isEditing) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: isPersonalEdit
                  ? SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7544FC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => _saveProfileChanges(context, widget.category, setState),
                        child: const Text(
                          'Update',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _isEditing = false;
                                _initControllers();
                              });
                            },
                            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: widget.primaryColor),
                            onPressed: () => _saveProfileChanges(context, widget.category, setState),
                            child: const Text('Save Details', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ],
      ),
    );
  }
}
