import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:gitakshmi_hrms_app/core/api/network_checker.dart';
import 'package:gitakshmi_hrms_app/core/storage/preference/preference_manager.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/features/profile/domain/repositories/profile_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc({required this.repository}) : super(ProfileInitial()) {
    on<FetchProfileEvent>(_onFetchProfile);
    on<RegisterFaceEvent>(_onRegisterFace);
  }

  String _formatIsoDate(String? isoStr) {
    if (isoStr == null || isoStr.isEmpty) return '';
    try {
      final parsed = DateTime.parse(isoStr);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${parsed.day.toString().padLeft(2, '0')}-${months[parsed.month - 1]}-${parsed.year}';
    } catch (_) {
      if (isoStr.length >= 10 && isoStr.contains('T')) {
        return isoStr.substring(0, 10);
      }
      return isoStr;
    }
  }

  EmployeeProfileModel _mergeProfileWithApiResponse(EmployeeProfileModel original, Map<String, dynamic> api) {
    // Top level info
    String rawFirst = api['first_name'] ?? api['firstName'] ?? api['first'] ?? '';
    String rawLast = api['last_name'] ?? api['lastName'] ?? api['last'] ?? '';
    if (rawFirst.isEmpty && rawLast.isEmpty) {
      final fullName = api['name'] ?? api['fullName'] ?? api['full_name'];
      if (fullName != null) {
        final parts = fullName.toString().trim().split(' ');
        if (parts.isNotEmpty) {
          rawFirst = parts.first;
          if (parts.length > 1) {
            rawLast = parts.sublist(1).join(' ');
          }
        }
      }
    }
    
    final firstName = rawFirst.isNotEmpty ? rawFirst : '';
    final lastName = rawLast.isNotEmpty ? rawLast : '';
    final middleName = api['middle_name'] ?? api['middleName'] ?? api['middle'] ?? '';
    final mobileNumber = api['mobile_number'] ?? api['mobileNumber'] ?? api['phone'] ?? api['mobile'] ?? api['contactNo'] ?? '';
    final alternateMobile = api['alternate_mobile'] ?? api['alternateMobile'] ?? api['alternate_phone'] ?? api['alt_phone'] ?? '';
    final personalEmail = api['personal_email'] ?? api['personalEmail'] ?? api['email'] ?? '';
    final officialEmail = api['official_email'] ?? api['officialEmail'] ?? api['work_email'] ?? api['workEmail'] ?? '';
    final gender = api['gender'] ?? api['sex'] ?? '';
    
    final rawDob = api['dob'] ?? api['date_of_birth'] ?? api['birthdate'] ?? '';
    final dob = _formatIsoDate(rawDob.toString());
    
    final bloodGroup = api['blood_group'] ?? api['bloodGroup'] ?? api['blood'] ?? '';
    final maritalStatus = api['marital_status'] ?? api['maritalStatus'] ?? api['marital'] ?? '';
    final nationality = api['nationality'] ?? api['citizen'] ?? '';
    final religion = api['religion'] ?? '';
    
    // Identity numbers
    final aadharNumber = (api['documents'] is Map)
        ? (api['documents']['aadharNumber'] ?? api['documents']['aadhar_number'] ?? '').toString()
        : (api['aadhar_number'] ?? api['aadharNumber'] ?? api['aadhar'] ?? '').toString();

    final panNumber = (api['documents'] is Map)
        ? (api['documents']['panNumber'] ?? api['documents']['pan_number'] ?? '').toString()
        : (api['pan_number'] ?? api['panNumber'] ?? api['pan'] ?? '').toString();
        
    final passportNumber = api['passport_number'] ?? api['passportNumber'] ?? api['passport'] ?? '';
    final drivingLicenseNumber = api['driving_license_number'] ?? api['drivingLicenseNumber'] ?? api['driving_license'] ?? api['license'] ?? '';

    // Biometric & Face scan
    final biometricId = api['biometric_id'] ?? api['biometricId'] ?? api['biometric'] ?? '';
    final faceRegistrationStatus = api['face_registration_status'] ?? api['faceRegistrationStatus'] ?? api['face_status'] ?? '';

    // Address Details
    AddressDetails addressDetails = AddressDetails(
      currentLine1: '',
      currentLine2: '',
      currentCity: '',
      currentState: '',
      currentCountry: '',
      currentPincode: '',
      permanentLine1: '',
      permanentLine2: '',
      permanentCity: '',
      permanentState: '',
      permanentCountry: '',
      permanentPincode: '',
      isPermanentSameAsCurrent: false,
    );

    final tempAddr = api['tempAddress'];
    final permAddr = api['permAddress'];
    if (tempAddr is Map || permAddr is Map) {
      addressDetails = AddressDetails(
        currentLine1: tempAddr is Map ? (tempAddr['line1'] ?? '').toString() : '',
        currentLine2: tempAddr is Map ? (tempAddr['line2'] ?? '').toString() : '',
        currentCity: tempAddr is Map ? (tempAddr['city'] ?? '').toString() : '',
        currentState: tempAddr is Map ? (tempAddr['state'] ?? '').toString() : '',
        currentCountry: tempAddr is Map ? (tempAddr['country'] ?? '').toString() : '',
        currentPincode: tempAddr is Map ? (tempAddr['pinCode'] ?? tempAddr['pincode'] ?? '').toString() : '',
        permanentLine1: permAddr is Map ? (permAddr['line1'] ?? '').toString() : '',
        permanentLine2: permAddr is Map ? (permAddr['line2'] ?? '').toString() : '',
        permanentCity: permAddr is Map ? (permAddr['city'] ?? '').toString() : '',
        permanentState: permAddr is Map ? (permAddr['state'] ?? '').toString() : '',
        permanentCountry: permAddr is Map ? (permAddr['country'] ?? '').toString() : '',
        permanentPincode: permAddr is Map ? (permAddr['pinCode'] ?? permAddr['pincode'] ?? '').toString() : '',
        isPermanentSameAsCurrent: false,
      );
    } else {
      final apiAddress = api['address'] ?? api['address_details'] ?? api['addressDetails'];
      if (apiAddress is Map) {
        addressDetails = AddressDetails(
          currentLine1: (apiAddress['current_line_1'] ?? apiAddress['currentLine1'] ?? apiAddress['line1'] ?? apiAddress['street'] ?? '').toString(),
          currentLine2: (apiAddress['current_line_2'] ?? apiAddress['currentLine2'] ?? apiAddress['line2'] ?? '').toString(),
          currentCity: (apiAddress['current_city'] ?? apiAddress['currentCity'] ?? apiAddress['city'] ?? '').toString(),
          currentState: (apiAddress['current_state'] ?? apiAddress['currentState'] ?? apiAddress['state'] ?? '').toString(),
          currentCountry: (apiAddress['current_country'] ?? apiAddress['currentCountry'] ?? apiAddress['country'] ?? '').toString(),
          currentPincode: (apiAddress['current_pincode'] ?? apiAddress['currentPincode'] ?? apiAddress['pincode'] ?? apiAddress['zip'] ?? apiAddress['postal_code'] ?? '').toString(),
          permanentLine1: (apiAddress['permanent_line_1'] ?? apiAddress['permanentLine1'] ?? apiAddress['perm_line1'] ?? '').toString(),
          permanentLine2: (apiAddress['permanent_line_2'] ?? apiAddress['permanentLine2'] ?? apiAddress['perm_line2'] ?? '').toString(),
          permanentCity: (apiAddress['permanent_city'] ?? apiAddress['permanentCity'] ?? apiAddress['perm_city'] ?? '').toString(),
          permanentState: (apiAddress['permanent_state'] ?? apiAddress['permanentState'] ?? apiAddress['perm_state'] ?? '').toString(),
          permanentCountry: (apiAddress['permanent_country'] ?? apiAddress['permanentCountry'] ?? apiAddress['perm_country'] ?? '').toString(),
          permanentPincode: (apiAddress['permanent_pincode'] ?? apiAddress['permanentPincode'] ?? apiAddress['perm_pincode'] ?? '').toString(),
          isPermanentSameAsCurrent: apiAddress['isPermanentSameAsCurrent'] ?? false,
        );
      }
    }

    // Bank Details
    BankDetails bankDetails = BankDetails(
      bankName: '',
      accountHolderName: '',
      accountNumber: '',
      ifscCode: '',
      branchName: '',
      upiId: '',
    );
    final apiBank = api['bank'] ?? api['bank_details'] ?? api['bankDetails'] ?? api['bankDetails'];
    if (apiBank is Map) {
      bankDetails = BankDetails(
        bankName: (apiBank['bankName'] ?? apiBank['bank_name'] ?? apiBank['name'] ?? '').toString(),
        accountHolderName: (apiBank['accountHolderName'] ?? apiBank['account_holder_name'] ?? apiBank['holder'] ?? '').toString(),
        accountNumber: (apiBank['accountNumber'] ?? apiBank['account_number'] ?? apiBank['number'] ?? '').toString(),
        ifscCode: (apiBank['ifsc'] ?? apiBank['ifsc_code'] ?? apiBank['ifscCode'] ?? '').toString(),
        branchName: (apiBank['branchName'] ?? apiBank['branch_name'] ?? apiBank['branch'] ?? '').toString(),
        upiId: (apiBank['upiId'] ?? apiBank['upi_id'] ?? apiBank['upi'] ?? '').toString(),
      );
    }

    // Education Records
    List<EducationRecord> educationRecords = [];
    final apiEducation = api['education'] ?? api['education_details'] ?? api['educationRecords'] ?? api['educations'];
    if (apiEducation is List) {
      educationRecords = apiEducation.map((item) {
        final m = item is Map ? Map<String, dynamic>.from(item) : <String, dynamic>{};
        return EducationRecord(
          qualification: (m['qualification'] ?? m['degree'] ?? '').toString(),
          course: (m['course'] ?? '').toString(),
          specialization: (m['specialization'] ?? '').toString(),
          university: (m['university'] ?? m['board_university'] ?? '').toString(),
          institute: (m['institute'] ?? m['school_college'] ?? '').toString(),
          board: (m['board'] ?? '').toString(),
          passingYear: (m['passing_year'] ?? m['passingYear'] ?? m['year'] ?? '').toString(),
          percentage: (m['percentage'] ?? m['marks_percentage'] ?? '').toString(),
          grade: (m['grade'] ?? '').toString(),
          cgpa: (m['cgpa'] ?? '').toString(),
          attachedDoc: (m['attached_doc'] ?? m['attachedDoc'] ?? m['document'] ?? m['file'] ?? '').toString(),
        );
      }).toList();
    } else if (apiEducation is Map) {
      final type = (apiEducation['type'] ?? '').toString();
      if (type.isNotEmpty) {
        educationRecords.add(EducationRecord(
          qualification: type,
          course: '',
          specialization: '',
          university: '',
          institute: '',
          board: '',
          passingYear: '',
          percentage: '',
          grade: '',
          cgpa: '',
          attachedDoc: '',
        ));
      }
      
      final class10 = (apiEducation['class10Marksheet'] ?? '').toString();
      if (class10.isNotEmpty) {
        educationRecords.add(EducationRecord(
          qualification: 'Class 10 Marksheet',
          course: '',
          specialization: '',
          university: '',
          institute: '',
          board: '',
          passingYear: '',
          percentage: '',
          grade: '',
          cgpa: '',
          attachedDoc: class10,
        ));
      }
      
      final diploma = (apiEducation['diplomaCertificate'] ?? '').toString();
      if (diploma.isNotEmpty) {
        educationRecords.add(EducationRecord(
          qualification: 'Diploma Certificate',
          course: '',
          specialization: '',
          university: '',
          institute: '',
          board: '',
          passingYear: '',
          percentage: '',
          grade: '',
          cgpa: '',
          attachedDoc: diploma,
        ));
      }

      final master = (apiEducation['masterDegree'] ?? '').toString();
      if (master.isNotEmpty) {
        educationRecords.add(EducationRecord(
          qualification: 'Master Degree',
          course: '',
          specialization: '',
          university: '',
          institute: '',
          board: '',
          passingYear: '',
          percentage: '',
          grade: '',
          cgpa: '',
          attachedDoc: master,
        ));
      }
    }

    // Experience Records
    List<ExperienceRecord> experienceRecords = [];
    final apiExperience = api['experience'] ?? api['experience_details'] ?? api['experienceRecords'] ?? api['experiences'] ?? api['work_experience'];
    if (apiExperience is List) {
      experienceRecords = apiExperience.map((item) {
        final m = item is Map ? Map<String, dynamic>.from(item) : <String, dynamic>{};
        return ExperienceRecord(
          companyName: (m['company_name'] ?? m['companyName'] ?? m['company'] ?? '').toString(),
          designation: (m['designation'] ?? m['role'] ?? '').toString(),
          department: (m['department'] ?? '').toString(),
          industry: (m['industry'] ?? '').toString(),
          joiningDate: (m['joining_date'] ?? m['joiningDate'] ?? m['start_date'] ?? '').toString(),
          relievingDate: (m['relieving_date'] ?? m['relievingDate'] ?? m['end_date'] ?? '').toString(),
          totalExperience: (m['total_experience'] ?? m['totalExperience'] ?? '').toString(),
          currentSalary: (m['current_salary'] ?? m['currentSalary'] ?? m['salary'] ?? '').toString(),
          reasonForLeaving: (m['reason_for_leaving'] ?? m['reasonForLeaving'] ?? m['leaving_reason'] ?? '').toString(),
          attachedDoc: (m['attached_doc'] ?? m['attachedDoc'] ?? m['document'] ?? m['file'] ?? '').toString(),
        );
      }).toList();
    }

    // Documents
    List<ProfileDocument> documents = [];
    final apiDocs = api['documents'] ?? api['document_vault'] ?? api['files'] ?? api['profile_documents'];
    if (apiDocs is List) {
      documents = apiDocs.map((item) {
        final m = item is Map ? Map<String, dynamic>.from(item) : <String, dynamic>{};
        return ProfileDocument(
          id: (m['id'] ?? '').toString(),
          category: (m['category'] ?? m['document_type'] ?? '').toString(),
          name: (m['name'] ?? m['document_name'] ?? m['file_name'] ?? '').toString(),
          uploadedBy: (m['uploaded_by'] ?? m['uploadedBy'] ?? '').toString(),
          uploadedAt: (m['uploaded_at'] ?? m['uploadedAt'] ?? m['created_at'] ?? '').toString(),
          filePath: (m['file_path'] ?? m['filePath'] ?? m['file'] ?? m['url'] ?? '').toString(),
        );
      }).toList();
    } else if (apiDocs is Map) {
      final aadharFront = (apiDocs['aadharFront'] ?? '').toString();
      if (aadharFront.isNotEmpty) {
        documents.add(ProfileDocument(
          id: 'aadhar_front',
          category: 'Aadhar',
          name: 'Aadhar Front Card',
          uploadedBy: 'System',
          uploadedAt: '',
          filePath: aadharFront,
        ));
      }
      final aadharBack = (apiDocs['aadharBack'] ?? '').toString();
      if (aadharBack.isNotEmpty) {
        documents.add(ProfileDocument(
          id: 'aadhar_back',
          category: 'Aadhar',
          name: 'Aadhar Back Card',
          uploadedBy: 'System',
          uploadedAt: '',
          filePath: aadharBack,
        ));
      }
      final panCard = (apiDocs['panCard'] ?? '').toString();
      if (panCard.isNotEmpty) {
        documents.add(ProfileDocument(
          id: 'pan_card',
          category: 'PAN',
          name: 'PAN Card Photo',
          uploadedBy: 'System',
          uploadedAt: '',
          filePath: panCard,
        ));
      }
    }

    return original.copyWith(
      firstName: firstName.toString(),
      lastName: lastName.toString(),
      middleName: middleName.toString(),
      mobileNumber: mobileNumber.toString(),
      alternateMobile: alternateMobile.toString(),
      personalEmail: personalEmail.toString(),
      officialEmail: officialEmail.toString(),
      gender: gender.toString(),
      dob: dob.toString(),
      bloodGroup: bloodGroup.toString(),
      maritalStatus: maritalStatus.toString(),
      nationality: nationality.toString(),
      religion: religion.toString(),
      aadharNumber: aadharNumber.toString(),
      panNumber: panNumber.toString(),
      passportNumber: passportNumber.toString(),
      drivingLicenseNumber: drivingLicenseNumber.toString(),
      biometricId: biometricId.toString(),
      faceRegistrationStatus: faceRegistrationStatus.toString(),
      addressDetails: addressDetails,
      bankDetails: bankDetails,
      educationRecords: educationRecords,
      experienceRecords: experienceRecords,
      documents: documents,
    );
  }

  Future<void> _onFetchProfile(FetchProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    try {
      final hasInternet = await NetworkChecker.hasInternetConnection();
      if (!hasInternet) {
        emit(const ProfileError('No internet connection. Please check your network.'));
        return;
      }

      final token = await PreferenceManager.getToken();
      if (token == null || token.trim().isEmpty) {
        emit(const ProfileError('Session expired. Please log in again.'));
        return;
      }

      final response = await repository.getProfile('Bearer $token');

      Map<String, dynamic>? dataMap;
      if (response is Map) {
        if (response.containsKey('data') && response['data'] is Map) {
          dataMap = Map<String, dynamic>.from(response['data']);
        } else {
          dataMap = Map<String, dynamic>.from(response);
        }
      }

      if (dataMap == null) {
        emit(const ProfileError('Failed to fetch profile details.'));
        return;
      }

      final designation = (dataMap['designation'] ?? dataMap['position'] ?? dataMap['role'] ?? dataMap['role_name'] ?? dataMap['title'] ?? dataMap['department'])?.toString();
      
      // Format ISO dates in dataMap so children can display them formatted
      if (dataMap.containsKey('dob')) {
        dataMap['dob'] = _formatIsoDate(dataMap['dob']?.toString());
      }
      if (dataMap.containsKey('joiningDate')) {
        dataMap['joiningDate'] = _formatIsoDate(dataMap['joiningDate']?.toString());
      }
      if (dataMap.containsKey('joining_date')) {
        dataMap['joining_date'] = _formatIsoDate(dataMap['joining_date']?.toString());
      }

      final helper = RolePermissionHelper.instance;
      final String apiEmpId = (dataMap['employeeId'] ?? dataMap['employee_id'] ?? dataMap['_id'] ?? '').toString();
      
      if (apiEmpId.isNotEmpty) {
        if (event.employeeId == null || event.employeeId == helper.activeEmployeeId) {
          final existingEmpIdx = helper.employees.indexWhere((e) => e.id == apiEmpId);
          if (existingEmpIdx == -1) {
            helper.addEmployee(EmployeeModel(
              id: apiEmpId,
              name: '${dataMap['firstName'] ?? ''} ${dataMap['lastName'] ?? ''}'.trim(),
              roleId: 'r_employee',
              dept: (dataMap['department'] ?? 'Technology').toString(),
              extraPermissions: [],
              restrictedPermissions: [],
            ));
          }
          helper.setActiveEmployee(apiEmpId);
        }
      }

      final activeEmpId = helper.activeEmployeeId;
      final targetEmpId = event.employeeId ?? activeEmpId;
      
      helper.apiResponses[targetEmpId] = dataMap;
      final originalProfile = helper.getProfile(targetEmpId);
      
      final updatedProfile = _mergeProfileWithApiResponse(originalProfile, dataMap);
      helper.updateProfile(targetEmpId, updatedProfile);

      emit(ProfileLoaded(
        profile: updatedProfile,
        designation: designation,
      ));
    } on DioException catch (e) {
      String errorMsg = 'Failed to fetch profile details. Please try again.';
      if (e.response?.data != null && e.response!.data is Map) {
        final responseBody = e.response!.data;
        if (responseBody.containsKey('message')) {
          errorMsg = responseBody['message'].toString();
        }
      }
      emit(ProfileError(errorMsg));
    } catch (e) {
      emit(const ProfileError('An unexpected error occurred. Please try again.'));
    }
  }

  Future<void> _onRegisterFace(RegisterFaceEvent event, Emitter<ProfileState> emit) async {
    final currentState = state;
    EmployeeProfileModel? currentProfile;
    String? currentDesignation;

    if (currentState is ProfileLoaded) {
      currentProfile = currentState.profile;
      currentDesignation = currentState.designation;
    } else if (currentState is FaceRegisterSuccess) {
      currentProfile = currentState.profile;
      currentDesignation = currentState.designation;
    } else if (currentState is FaceRegisterError) {
      currentProfile = currentState.profile;
      currentDesignation = currentState.designation;
    } else if (currentState is FaceRegisterLoading) {
      currentProfile = currentState.profile;
      currentDesignation = currentState.designation;
    }

    if (currentProfile == null) {
      emit(const ProfileError('Cannot register face without loading profile first.'));
      return;
    }

    emit(FaceRegisterLoading(profile: currentProfile, designation: currentDesignation));

    try {
      final hasInternet = await NetworkChecker.hasInternetConnection();
      if (!hasInternet) {
        emit(FaceRegisterError(
          profile: currentProfile,
          designation: currentDesignation,
          message: 'No internet connection. Please check your network.',
        ));
        return;
      }

      final token = await PreferenceManager.getToken();
      if (token == null || token.trim().isEmpty) {
        emit(FaceRegisterError(
          profile: currentProfile,
          designation: currentDesignation,
          message: 'Session expired. Please log in again.',
        ));
        return;
      }

      final employeeName = '${currentProfile.firstName} ${currentProfile.lastName}'.trim();
      await repository.registerFace(
        'Bearer $token',
        event.base64Image,
        employeeName: employeeName.isNotEmpty ? employeeName : 'Employee',
        employeeId: currentProfile.employeeId.isNotEmpty ? currentProfile.employeeId : 'EMP-UNKNOWN',
      );

      await PreferenceManager.saveRegisteredFace(event.base64Image);

      final helper = RolePermissionHelper.instance;
      final activeEmpId = helper.activeEmployeeId;
      final updatedProfile = currentProfile.copyWith(
        faceRegistrationStatus: 'Registered',
      );
      helper.updateProfile(activeEmpId, updatedProfile);

      emit(FaceRegisterSuccess(
        profile: updatedProfile,
        designation: currentDesignation,
        message: 'Face registered successfully!',
      ));
    } on DioException catch (e) {
      String errorMsg = 'Failed to register face. Please try again.';
      if (e.response?.data != null && e.response!.data is Map) {
        final responseBody = e.response!.data;
        if (responseBody.containsKey('message')) {
          errorMsg = responseBody['message'].toString();
        }
      }
      emit(FaceRegisterError(
        profile: currentProfile,
        designation: currentDesignation,
        message: errorMsg,
      ));
    } catch (e) {
      emit(FaceRegisterError(
        profile: currentProfile,
        designation: currentDesignation,
        message: 'An unexpected error occurred. Please try again.',
      ));
    }
  }
}
