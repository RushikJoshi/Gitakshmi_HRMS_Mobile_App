import 'package:flutter/material.dart';

class RoleModel {
  final String id;
  final String name;
  final String description;
  final List<String> permissions;
  final bool isSystemDefault;
  final String status; // 'Active' or 'Inactive'
  final int usersCount;

  RoleModel({
    required this.id,
    required this.name,
    required this.description,
    required this.permissions,
    required this.isSystemDefault,
    required this.status,
    required this.usersCount,
  });

  RoleModel copyWith({
    String? name,
    String? description,
    List<String>? permissions,
    bool? isSystemDefault,
    String? status,
    int? usersCount,
  }) {
    return RoleModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      permissions: permissions ?? this.permissions,
      isSystemDefault: isSystemDefault ?? this.isSystemDefault,
      status: status ?? this.status,
      usersCount: usersCount ?? this.usersCount,
    );
  }
}

class EmployeeModel {
  final String id;
  final String name;
  final String roleId;
  final String dept;
  final List<String> extraPermissions;
  final List<String> restrictedPermissions;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.roleId,
    required this.dept,
    required this.extraPermissions,
    required this.restrictedPermissions,
  });

  EmployeeModel copyWith({
    String? roleId,
    List<String>? extraPermissions,
    List<String>? restrictedPermissions,
  }) {
    return EmployeeModel(
      id: id,
      name: name,
      roleId: roleId ?? this.roleId,
      dept: dept,
      extraPermissions: extraPermissions ?? this.extraPermissions,
      restrictedPermissions: restrictedPermissions ?? this.restrictedPermissions,
    );
  }
}

class AuditLogModel {
  final String id;
  final String actorName;
  final String targetName; // e.g. Action For
  final String actionType;
  final String description;
  final String timestamp;

  AuditLogModel({
    required this.id,
    required this.actorName,
    required this.targetName,
    required this.actionType,
    required this.description,
    required this.timestamp,
  });
}

class WorkflowModel {
  final String id;
  final String name;
  final String requiredPermission;
  final String description;

  WorkflowModel({
    required this.id,
    required this.name,
    required this.requiredPermission,
    required this.description,
  });
}

// On Behalf Of Data Models
class TeamLeaveModel {
  final String id;
  final String employeeName;
  final String leaveType;
  final String dateRange;
  final String reason;
  final String status;
  final String appliedBy;
  final String timestamp;

  TeamLeaveModel({
    required this.id,
    required this.employeeName,
    required this.leaveType,
    required this.dateRange,
    required this.reason,
    required this.status,
    required this.appliedBy,
    required this.timestamp,
  });
}

class TeamAttendanceCorrectionModel {
  final String id;
  final String employeeName;
  final String date;
  final String punchIn;
  final String punchOut;
  final String reason;
  final String correctedBy;
  final String timestamp;

  TeamAttendanceCorrectionModel({
    required this.id,
    required this.employeeName,
    required this.date,
    required this.punchIn,
    required this.punchOut,
    required this.reason,
    required this.correctedBy,
    required this.timestamp,
  });
}

class TeamVisitModel {
  final String id;
  final String employeeName;
  final String clientName;
  final String location;
  final String time;
  final String status;
  final String assignedBy;

  TeamVisitModel({
    required this.id,
    required this.employeeName,
    required this.clientName,
    required this.location,
    required this.time,
    required this.status,
    required this.assignedBy,
  });
}

class TeamDocModel {
  final String id;
  final String employeeName;
  final String docType;
  final String docName;
  final String uploadedBy;
  final String timestamp;

  TeamDocModel({
    required this.id,
    required this.employeeName,
    required this.docType,
    required this.docName,
    required this.uploadedBy,
    required this.timestamp,
  });
}

class TeamTimesheetModel {
  final String employeeName;
  final String dept;
  final String workingHours;
  final int lateCount;
  final int absentCount;
  final String overtime;
  final String breakDuration;

  TeamTimesheetModel({
    required this.employeeName,
    required this.dept,
    required this.workingHours,
    required this.lateCount,
    required this.absentCount,
    required this.overtime,
    required this.breakDuration,
  });
}

class RolePermissionHelper extends ChangeNotifier {
  RolePermissionHelper._internal() {
    _initializeData();
  }
  static final RolePermissionHelper instance = RolePermissionHelper._internal();

  // Categories definition
  final Map<String, List<Map<String, String>>> permissionCategories = {
    'Attendance': [
      {'key': 'view_attendance', 'desc': 'View attendance records'},
      {'key': 'create_attendance', 'desc': 'Check-in/punch-in attendance'},
      {'key': 'edit_attendance', 'desc': 'Modify attendance records'},
      {'key': 'delete_attendance', 'desc': 'Remove attendance logs'},
      {'key': 'approve_attendance', 'desc': 'Approve regularizations'},
    ],
    'Leave': [
      {'key': 'view_leave', 'desc': 'View leave history'},
      {'key': 'apply_leave', 'desc': 'Apply for leaves'},
      {'key': 'approve_leave', 'desc': 'Approve or reject leaves'},
      {'key': 'cancel_leave', 'desc': 'Cancel applied leaves'},
    ],
    'Payroll': [
      {'key': 'view_payroll', 'desc': 'View payslips and payroll status'},
      {'key': 'generate_payroll', 'desc': 'Generate payroll for employees'},
      {'key': 'download_payslip', 'desc': 'Download salary payslips'},
    ],
    'Recruitment': [
      {'key': 'view_recruitment', 'desc': 'View job openings and candidates'},
      {'key': 'create_recruitment', 'desc': 'Create job postings'},
      {'key': 'approve_recruitment', 'desc': 'Approve hires/candidate progress'},
    ],
    'Offer Letter': [
      {'key': 'view_offer_letter', 'desc': 'View candidate offer letters'},
      {'key': 'create_offer_letter', 'desc': 'Draft and issue offer letters'},
      {'key': 'approve_offer_letter', 'desc': 'Approve draft offer letters'},
    ],
    'Budget': [
      {'key': 'view_budget', 'desc': 'View department budgets'},
      {'key': 'create_budget', 'desc': 'Draft company/department budgets'},
      {'key': 'approve_budget', 'desc': 'Approve financial budgets'},
    ],
    'Expense': [
      {'key': 'view_expense', 'desc': 'View expense claims'},
      {'key': 'create_expense', 'desc': 'Submit reimbursement claims'},
      {'key': 'approve_expense', 'desc': 'Approve expense reimbursements'},
    ],
    'Team (On Behalf Of)': [
      {'key': 'view_team', 'desc': 'View team roster and directory'},
      {'key': 'view_team_attendance', 'desc': 'View live team attendance status'},
      {'key': 'view_team_leave', 'desc': 'View team applied leaves history'},
      {'key': 'apply_leave_for_team', 'desc': 'Apply for leave on behalf of team members'},
      {'key': 'cancel_leave_for_team', 'desc': 'Cancel leaves on behalf of team members'},
      {'key': 'mark_attendance_for_team', 'desc': 'Punch manual attendance on behalf of team'},
      {'key': 'correct_attendance_for_team', 'desc': 'Submit attendance correction on behalf of team'},
      {'key': 'view_team_tracking', 'desc': 'Review live tracking coordinates for team'},
      {'key': 'create_visit_for_team', 'desc': 'Assign client visits on behalf of team reps'},
      {'key': 'approve_team_request', 'desc': 'Approve leaves, regularizations, WFH requests'},
      {'key': 'manage_team_documents', 'desc': 'Upload warning, revisions, appointment docs on behalf of team'},
      {'key': 'view_team_timesheet', 'desc': 'Access team weekly working hours and breaks timesheet'},
    ],
    'Tracking': [
      {'key': 'view_tracking', 'desc': 'Access live GPS field tracking dashboard'},
      {'key': 'live_tracking', 'desc': 'Track employees routes and live location'},
      {'key': 'view_route_history', 'desc': 'View route and stoppage history logs'},
    ],
    'Reports': [
      {'key': 'view_reports', 'desc': 'View daily/monthly workforce analytics reports'},
      {'key': 'export_reports', 'desc': 'Export report logs in PDF/Excel'},
    ],
    'Employee': [
      {'key': 'view_employee', 'desc': 'View employees directory profile info'},
      {'key': 'add_employee', 'desc': 'Onboard/add new employee profiles'},
      {'key': 'edit_employee', 'desc': 'Edit existing employee details'},
      {'key': 'delete_employee', 'desc': 'Offboard/archive employee records'},
    ],
    'Approval': [
      {'key': 'view_approval', 'desc': 'Access unified approvals inbox'},
      {'key': 'approve_request', 'desc': 'Approve pending workflows'},
      {'key': 'reject_request', 'desc': 'Reject pending workflows'},
      {'key': 'escalate_request', 'desc': 'Escalate workflow requests'},
      {'key': 'view_full_workflow', 'desc': 'See all approval levels including future pending levels'},
      {'key': 'send_back_request', 'desc': 'Send back request for corrections'},
      {'key': 'request_more_info', 'desc': 'Request additional information on pending workflows'},
    ],
  };

  // State Lists
  List<RoleModel> _roles = [];
  List<EmployeeModel> _employees = [];
  List<AuditLogModel> _auditLogs = [];
  List<WorkflowModel> _workflows = [];
  String _activeEmployeeId = '';
  String _currentCompany = 'ABC Pvt Ltd';

  // On Behalf Of lists
  List<TeamLeaveModel> _teamLeaves = [];
  List<TeamAttendanceCorrectionModel> _teamAttendanceLogs = [];
  List<TeamVisitModel> _teamVisits = [];
  List<TeamDocModel> _teamDocuments = [];
  List<TeamTimesheetModel> _teamTimesheets = [];

  // Profile Module state lists
  List<EmployeeProfileModel> _profiles = [];
  List<ProfileChangeRequest> _profileChangeRequests = [];

  // Asset Management state lists
  List<CompanyAssetModel> _companyAssets = [];
  List<AssetRequestModel> _assetRequests = [];
  List<AssetTicketModel> _assetTickets = [];
  List<AssetTransferLogModel> _assetTransfers = [];
  List<AssetAuditLogModel> _assetAudits = [];

  // Expense Management state lists
  List<ExpenseClaimModel> _expenseClaims = [];
  List<AdvanceRequestModel> _advanceRequests = [];
  List<ExpenseReimbursementModel> _reimbursements = [];
  List<ExpensePolicyModel> _expensePolicies = [];

  // Unified Approval Requests
  List<UnifiedApprovalRequest> _approvalRequests = [];

  // Getters
  List<RoleModel> get roles => _roles;
  List<EmployeeModel> get employees => _employees;
  List<AuditLogModel> get auditLogs => _auditLogs;
  List<WorkflowModel> get workflows => _workflows;
  String get activeEmployeeId => _activeEmployeeId;
  String get currentCompany => _currentCompany;

  List<TeamLeaveModel> get teamLeaves => _teamLeaves;
  List<TeamAttendanceCorrectionModel> get teamAttendanceLogs => _teamAttendanceLogs;
  List<TeamVisitModel> get teamVisits => _teamVisits;
  List<TeamDocModel> get teamDocuments => _teamDocuments;
  List<TeamTimesheetModel> get teamTimesheets => _teamTimesheets;
  List<EmployeeProfileModel> get profiles => _profiles;
  List<ProfileChangeRequest> get profileChangeRequests => _profileChangeRequests;
  
  List<CompanyAssetModel> get companyAssets => _companyAssets;
  List<AssetRequestModel> get assetRequests => _assetRequests;
  List<AssetTicketModel> get assetTickets => _assetTickets;
  List<AssetTransferLogModel> get assetTransfers => _assetTransfers;
  List<AssetAuditLogModel> get assetAudits => _assetAudits;

  List<ExpenseClaimModel> get expenseClaims => _expenseClaims;
  List<AdvanceRequestModel> get advanceRequests => _advanceRequests;
  List<ExpenseReimbursementModel> get reimbursements => _reimbursements;
  List<ExpensePolicyModel> get expensePolicies => _expensePolicies;

  List<UnifiedApprovalRequest> get approvalRequests => _approvalRequests;

  EmployeeModel get activeEmployee => _employees.firstWhere(
        (e) => e.id == _activeEmployeeId,
        orElse: () => _employees.first,
      );

  // Initialize Lists
  void _initializeData() {
    _roles = [
      RoleModel(
        id: 'r_admin',
        name: 'Admin',
        description: 'Complete system access and absolute operational authority across all departments.',
        permissions: getAllPermissionKeys(),
        isSystemDefault: true,
        status: 'Active',
        usersCount: 1,
      ),
      RoleModel(
        id: 'r_hr',
        name: 'HR Manager',
        description: 'Responsible for employee directory, recruitment, issuing offer letters, and approving leaves.',
        permissions: [
          'view_employee',
          'add_employee',
          'edit_employee',
          'view_recruitment',
          'create_recruitment',
          'approve_recruitment',
          'view_offer_letter',
          'create_offer_letter',
          'approve_offer_letter',
          'view_approval',
          'approve_request',
          'reject_request',
          'view_leave',
          'approve_leave',
          'view_team',
          'view_team_leave',
          'cancel_leave_for_team',
          'approve_team_request',
          'manage_team_documents',
        ],
        isSystemDefault: true,
        status: 'Active',
        usersCount: 1,
      ),
      RoleModel(
        id: 'r_manager',
        name: 'Manager',
        description: 'Oversees team structure, live sales tracking, approves expenses, and generates department reports.',
        permissions: [
          'view_team',
          'view_team_attendance',
          'view_team_leave',
          'apply_leave_for_team',
          'cancel_leave_for_team',
          'mark_attendance_for_team',
          'correct_attendance_for_team',
          'view_team_tracking',
          'create_visit_for_team',
          'approve_team_request',
          'view_team_timesheet',
          'view_tracking',
          'live_tracking',
          'view_route_history',
          'view_approval',
          'approve_request',
          'reject_request',
          'view_reports',
          'export_reports',
          'view_leave',
          'approve_leave',
        ],
        isSystemDefault: true,
        status: 'Active',
        usersCount: 1,
      ),
      RoleModel(
        id: 'r_tl',
        name: 'Team Leader',
        description: 'Manages basic team assignments, reviews attendance regularization, and views team leaves.',
        permissions: [
          'view_team',
          'view_team_attendance',
          'view_team_leave',
          'apply_leave_for_team',
          'view_team_timesheet',
          'view_attendance',
          'approve_attendance',
          'view_leave',
          'view_reports',
        ],
        isSystemDefault: true,
        status: 'Active',
        usersCount: 1,
      ),
      RoleModel(
        id: 'r_employee',
        name: 'Employee',
        description: 'Standard access for logging attendance, applying for leaves, and viewing personal payslips.',
        permissions: [
          'view_attendance',
          'create_attendance',
          'view_leave',
          'apply_leave',
          'cancel_leave',
          'view_payroll',
          'download_payslip',
        ],
        isSystemDefault: true,
        status: 'Active',
        usersCount: 2,
      ),
      RoleModel(
        id: 'r_finance',
        name: 'Finance Manager',
        description: 'Manages payroll calculations, budgets, and reviews operational expense sheets.',
        permissions: [
          'view_payroll',
          'generate_payroll',
          'download_payslip',
          'view_budget',
          'create_budget',
          'approve_budget',
          'view_expense',
          'approve_expense',
          'view_approval',
          'approve_request',
        ],
        isSystemDefault: true,
        status: 'Active',
        usersCount: 1,
      )
    ];

    _employees = [
      EmployeeModel(
        id: 'emp_mayur',
        name: 'Mayur Sonowane',
        roleId: 'r_admin',
        dept: 'Engineering',
        extraPermissions: [],
        restrictedPermissions: [],
      ),
      EmployeeModel(
        id: 'emp_riya',
        name: 'Riya Sharma',
        roleId: 'r_tl',
        dept: 'Engineering',
        extraPermissions: ['approve_budget'],
        restrictedPermissions: [],
      ),
      EmployeeModel(
        id: 'emp_amit',
        name: 'Amit Shah',
        roleId: 'r_employee',
        dept: 'Sales',
        extraPermissions: ['view_tracking'],
        restrictedPermissions: [],
      ),
      EmployeeModel(
        id: 'emp_akash',
        name: 'Akash Patel',
        roleId: 'r_hr',
        dept: 'Marketing',
        extraPermissions: [],
        restrictedPermissions: ['approve_offer_letter'],
      ),
      EmployeeModel(
        id: 'emp_karan',
        name: 'Karan Malhotra',
        roleId: 'r_employee',
        dept: 'Sales',
        extraPermissions: [],
        restrictedPermissions: [],
      ),
      EmployeeModel(
        id: 'emp_finance_user',
        name: 'Hitesh Mehta',
        roleId: 'r_finance',
        dept: 'Finance',
        extraPermissions: [],
        restrictedPermissions: [],
      ),
    ];

    _activeEmployeeId = 'emp_mayur';

    _workflows = [
      WorkflowModel(
        id: 'wf_budget',
        name: 'Budget Approval Flow',
        requiredPermission: 'approve_budget',
        description: 'Requires authorization to release company/department funds.',
      ),
      WorkflowModel(
        id: 'wf_leave',
        name: 'Leave Approval Flow',
        requiredPermission: 'approve_leave',
        description: 'Requires authorization to approve employee leave applications.',
      ),
      WorkflowModel(
        id: 'wf_payroll',
        name: 'Payroll Generation Flow',
        requiredPermission: 'generate_payroll',
        description: 'Requires authorization to calculate and disburse monthly payslips.',
      ),
      WorkflowModel(
        id: 'wf_recruitment',
        name: 'Recruitment Approval Flow',
        requiredPermission: 'approve_recruitment',
        description: 'Requires authorization to approve job offers and hires.',
      ),
      WorkflowModel(
        id: 'wf_offer',
        name: 'Offer Letter Release Flow',
        requiredPermission: 'approve_offer_letter',
        description: 'Requires authorization to release official candidate offer letters.',
      ),
    ];

    _auditLogs = [
      AuditLogModel(
        id: 'log_1',
        actorName: 'System Engine',
        targetName: 'All Users',
        actionType: 'Role Created',
        description: 'Initialized system default roles with 3 levels (Self, Team, Global) permissions.',
        timestamp: '06-Jun-2026 09:00 AM',
      ),
      AuditLogModel(
        id: 'log_2',
        actorName: 'Mayur Sonowane',
        targetName: 'Riya Sharma',
        actionType: 'Permission Override',
        description: 'Added extra permission [approve_budget] to user Riya Sharma.',
        timestamp: '06-Jun-2026 09:32 AM',
      ),
      AuditLogModel(
        id: 'log_3',
        actorName: 'Mayur Sonowane',
        targetName: 'Akash Patel',
        actionType: 'Permission Override',
        description: 'Restricted permission [approve_offer_letter] from user Akash Patel.',
        timestamp: '06-Jun-2026 09:40 AM',
      ),
    ];

    // Seed mock data for On Behalf Of
    _teamLeaves = [
      TeamLeaveModel(
        id: 'tl_1',
        employeeName: 'Karan Malhotra',
        leaveType: 'Sick Leave',
        dateRange: '08-Jun-2026 to 09-Jun-2026',
        reason: 'Severe high fever, resting as recommended.',
        status: 'Approved',
        appliedBy: 'Akash Patel',
        timestamp: '05-Jun-2026 04:30 PM',
      ),
      TeamLeaveModel(
        id: 'tl_2',
        employeeName: 'Amit Shah',
        leaveType: 'Casual Leave',
        dateRange: '15-Jun-2026',
        reason: 'Personal family emergency, travelling out of station.',
        status: 'Pending HR Approval',
        appliedBy: 'Riya Sharma',
        timestamp: '06-Jun-2026 10:15 AM',
      )
    ];

    _teamAttendanceLogs = [
      TeamAttendanceCorrectionModel(
        id: 'tc_1',
        employeeName: 'Amit Shah',
        date: '04-Jun-2026',
        punchIn: '09:05 AM',
        punchOut: '06:12 PM',
        reason: 'Forgot to punch out due to client meeting extension.',
        correctedBy: 'Riya Sharma',
        timestamp: '05-Jun-2026 10:00 AM',
      )
    ];

    _teamVisits = [
      TeamVisitModel(
        id: 'tv_1',
        employeeName: 'Amit Shah',
        clientName: 'Tata Motors Corporate Office',
        location: 'Worli, Mumbai',
        time: '11:00 AM',
        status: 'Completed',
        assignedBy: 'Riya Sharma',
      ),
      TeamVisitModel(
        id: 'tv_2',
        employeeName: 'Karan Malhotra',
        clientName: 'Reliance Industries',
        location: 'Navi Mumbai',
        time: '02:30 PM',
        status: 'Assigned',
        assignedBy: 'Riya Sharma',
      )
    ];

    _teamDocuments = [
      TeamDocModel(
        id: 'td_1',
        employeeName: 'Amit Shah',
        docType: 'Salary Revision',
        docName: 'Increment_Letter_2026.pdf',
        uploadedBy: 'Akash Patel',
        timestamp: '02-Jun-2026 11:20 AM',
      ),
      TeamDocModel(
        id: 'td_2',
        employeeName: 'Karan Malhotra',
        docType: 'Warning Letter',
        docName: 'Warning_Attendance_Violation.pdf',
        uploadedBy: 'Akash Patel',
        timestamp: '04-Jun-2026 03:45 PM',
      )
    ];

    _teamTimesheets = [
      TeamTimesheetModel(employeeName: 'Amit Shah', dept: 'Sales', workingHours: '42.5 Hrs', lateCount: 2, absentCount: 0, overtime: '2.5 Hrs', breakDuration: '4.2 Hrs'),
      TeamTimesheetModel(employeeName: 'Riya Sharma', dept: 'Engineering', workingHours: '38.0 Hrs', lateCount: 0, absentCount: 0, overtime: '0.0 Hrs', breakDuration: '3.8 Hrs'),
      TeamTimesheetModel(employeeName: 'Karan Malhotra', dept: 'Sales', workingHours: '35.2 Hrs', lateCount: 4, absentCount: 1, overtime: '0.0 Hrs', breakDuration: '5.1 Hrs'),
      TeamTimesheetModel(employeeName: 'Akash Patel', dept: 'Marketing', workingHours: '40.0 Hrs', lateCount: 1, absentCount: 0, overtime: '1.2 Hrs', breakDuration: '4.0 Hrs'),
    ];
    _seedProfiles();
    _seedAssets();
    _seedExpenses();
    _seedApprovalRequests();
  }

  // Get all permission keys list
  List<String> getAllPermissionKeys() {
    final List<String> keys = [];
    for (var categoryList in permissionCategories.values) {
      for (var perm in categoryList) {
        if (perm['key'] != null) {
          keys.add(perm['key']!);
        }
      }
    }
    return keys;
  }

  // Computes Final Permissions
  List<String> getFinalPermissions(String employeeId) {
    final emp = _employees.firstWhere((e) => e.id == employeeId, orElse: () => _employees.first);
    final role = _roles.firstWhere((r) => r.id == emp.roleId, orElse: () => _roles.first);
    final computed = Set<String>.from(role.permissions);
    computed.addAll(emp.extraPermissions);
    computed.removeAll(emp.restrictedPermissions);
    return computed.toList();
  }

  bool hasPermission(String employeeId, String permissionKey) {
    return getFinalPermissions(employeeId).contains(permissionKey);
  }

  List<EmployeeModel> getAuthorizedApprovers(String permissionKey) {
    return _employees.where((emp) => hasPermission(emp.id, permissionKey)).toList();
  }

  void setActiveEmployee(String employeeId) {
    _activeEmployeeId = employeeId;
    logAudit(activeEmployee.name, 'All Users', 'Context Switched', 'Switched session context view to ${activeEmployee.name}.');
    notifyListeners();
  }

  void addEmployee(EmployeeModel employee) {
    _employees.add(employee);
    notifyListeners();
  }

  void addEmployeeProfile(EmployeeProfileModel profile) {
    _profiles.add(profile);
    notifyListeners();
  }


  // Role CRUD
  void createRole(String name, String description, List<String> permissions) {
    final newId = 'r_custom_${DateTime.now().millisecondsSinceEpoch}';
    final newRole = RoleModel(
      id: newId,
      name: name,
      description: description,
      permissions: permissions,
      isSystemDefault: false,
      status: 'Active',
      usersCount: 0,
    );
    _roles.add(newRole);
    logAudit(activeEmployee.name, 'Role Master', 'Role Created', 'Created custom role "$name" with ${permissions.length} permissions.');
    notifyListeners();
  }

  void updateRole(String roleId, String name, String description, List<String> permissions) {
    final idx = _roles.indexWhere((r) => r.id == roleId);
    if (idx != -1) {
      final oldRole = _roles[idx];
      _roles[idx] = oldRole.copyWith(
        name: name,
        description: description,
        permissions: permissions,
      );
      logAudit(activeEmployee.name, 'Role Master', 'Role Updated', 'Updated custom role "$name" permissions (${permissions.length} active).');
      notifyListeners();
    }
  }

  void cloneRole(String roleId, String newName) {
    final source = _roles.firstWhere((r) => r.id == roleId);
    final newId = 'r_custom_${DateTime.now().millisecondsSinceEpoch}';
    final clonedRole = RoleModel(
      id: newId,
      name: newName,
      description: 'Clone of ${source.name}. ${source.description}',
      permissions: List<String>.from(source.permissions),
      isSystemDefault: false,
      status: 'Active',
      usersCount: 0,
    );
    _roles.add(clonedRole);
    logAudit(activeEmployee.name, 'Role Master', 'Role Cloned', 'Cloned role "${source.name}" as "$newName".');
    notifyListeners();
  }

  void deleteRole(String roleId) {
    final idx = _roles.indexWhere((r) => r.id == roleId);
    if (idx != -1) {
      final roleName = _roles[idx].name;
      _roles.removeAt(idx);
      logAudit(activeEmployee.name, 'Role Master', 'Role Deleted', 'Deleted custom role "$roleName".');
      notifyListeners();
    }
  }

  void updateEmployeeOverrides(String employeeId, {String? roleId, List<String>? extra, List<String>? restricted}) {
    final idx = _employees.indexWhere((e) => e.id == employeeId);
    if (idx != -1) {
      final old = _employees[idx];
      _employees[idx] = old.copyWith(
        roleId: roleId,
        extraPermissions: extra,
        restrictedPermissions: restricted,
      );
      
      _recalculateUserCounts();

      logAudit(
        activeEmployee.name,
        old.name,
        'User Overrides Configured',
        'Updated overrides for employee ${old.name}. (Extras: ${extra?.length ?? 0}, Restricted: ${restricted?.length ?? 0})',
      );
      notifyListeners();
    }
  }

  void _recalculateUserCounts() {
    for (int i = 0; i < _roles.length; i++) {
      final role = _roles[i];
      final count = _employees.where((e) => e.roleId == role.id).length;
      _roles[i] = role.copyWith(usersCount: count);
    }
  }

  // ==========================================
  // DELEGATED ON-BEHALF ACTIONS
  // ==========================================

  // Apply Leave On Behalf Of
  void applyLeaveOnBehalf(String employeeName, String leaveType, String dateRange, String reason) {
    final id = 'tl_custom_${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();
    final timeStr = '${now.day.toString().padLeft(2, '0')}-Jun-${now.year}';
    
    final newLeave = TeamLeaveModel(
      id: id,
      employeeName: employeeName,
      leaveType: leaveType,
      dateRange: dateRange,
      reason: reason,
      status: 'Approved (Delegated)',
      appliedBy: activeEmployee.name,
      timestamp: '$timeStr ${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}',
    );
    
    _teamLeaves.insert(0, newLeave);
    logAudit(
      activeEmployee.name,
      employeeName,
      'Leave On Behalf',
      'Applied $leaveType for $employeeName. Date: $dateRange. Reason: $reason.',
    );
    notifyListeners();
  }

  // Cancel Leave On Behalf Of
  void cancelLeaveOnBehalf(String leaveId) {
    final idx = _teamLeaves.indexWhere((l) => l.id == leaveId);
    if (idx != -1) {
      final old = _teamLeaves[idx];
      _teamLeaves[idx] = TeamLeaveModel(
        id: old.id,
        employeeName: old.employeeName,
        leaveType: old.leaveType,
        dateRange: old.dateRange,
        reason: old.reason,
        status: 'Cancelled by Manager',
        appliedBy: old.appliedBy,
        timestamp: old.timestamp,
      );
      
      logAudit(
        activeEmployee.name,
        old.employeeName,
        'Cancel Leave On Behalf',
        'Cancelled leave request for ${old.employeeName} (type: ${old.leaveType}, date: ${old.dateRange}).',
      );
      notifyListeners();
    }
  }

  // Manual Punch Attendance On Behalf Of
  void markManualAttendanceOnBehalf(String employeeName, String date, String punchIn, String punchOut, String reason) {
    final id = 'tc_custom_${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();
    final timeStr = '${now.day.toString().padLeft(2, '0')}-Jun-${now.year}';

    final newLog = TeamAttendanceCorrectionModel(
      id: id,
      employeeName: employeeName,
      date: date,
      punchIn: punchIn,
      punchOut: punchOut,
      reason: reason,
      correctedBy: activeEmployee.name,
      timestamp: '$timeStr ${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}',
    );

    _teamAttendanceLogs.insert(0, newLog);
    logAudit(
      activeEmployee.name,
      employeeName,
      'Manual Attendance Punch',
      'Marked manual punch for $employeeName. Date: $date. In: $punchIn, Out: $punchOut. Reason: $reason.',
    );
    notifyListeners();
  }

  // Attendance Correction On Behalf Of
  void correctAttendanceOnBehalf(String employeeName, String date, String punchIn, String punchOut, String reason) {
    final id = 'tc_custom_${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();
    final timeStr = '${now.day.toString().padLeft(2, '0')}-Jun-${now.year}';

    final newLog = TeamAttendanceCorrectionModel(
      id: id,
      employeeName: employeeName,
      date: date,
      punchIn: punchIn,
      punchOut: punchOut,
      reason: 'Correction: $reason',
      correctedBy: activeEmployee.name,
      timestamp: '$timeStr ${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}',
    );

    _teamAttendanceLogs.insert(0, newLog);
    logAudit(
      activeEmployee.name,
      employeeName,
      'Attendance Correction',
      'Corrected attendance logs for $employeeName on $date. Adjusted In: $punchIn, Out: $punchOut. Reason: $reason.',
    );
    notifyListeners();
  }

  // WFH Request On Behalf Of
  void applyWfhOnBehalf(String employeeName, String date, String reason) {
    logAudit(
      activeEmployee.name,
      employeeName,
      'WFH Request On Behalf',
      'Initiated Work From Home request on behalf of $employeeName for date: $date. Reason: $reason.',
    );
    notifyListeners();
  }

  // Expense Claim On Behalf Of
  void claimExpenseOnBehalf(String employeeName, String amount, String category, String description) {
    logAudit(
      activeEmployee.name,
      employeeName,
      'Expense Claim On Behalf',
      'Submitted expense claim on behalf of $employeeName. Amount: Rs. $amount, Category: $category. Description: $description.',
    );
    notifyListeners();
  }

  // Client Visit On Behalf Of
  void assignClientVisitOnBehalf(String employeeName, String client, String location, String time) {
    final id = 'tv_custom_${DateTime.now().millisecondsSinceEpoch}';
    final newVisit = TeamVisitModel(
      id: id,
      employeeName: employeeName,
      clientName: client,
      location: location,
      time: time,
      status: 'Assigned',
      assignedBy: activeEmployee.name,
    );

    _teamVisits.insert(0, newVisit);
    logAudit(
      activeEmployee.name,
      employeeName,
      'Assign Client Visit',
      'Assigned new client visit to $employeeName. Client: $client, Location: $location, Time: $time.',
    );
    notifyListeners();
  }

  // Resignation / Separation Management On Behalf Of
  void initiateSeparationOnBehalf(String employeeName, String reason, String noticePeriod) {
    logAudit(
      activeEmployee.name,
      employeeName,
      'Initiate Resignation',
      'Initiated employee resignation separation process on behalf of $employeeName. Reason: $reason. Notice Period: $noticePeriod Days.',
    );
    notifyListeners();
  }

  // Document Management On Behalf Of
  void uploadDocumentOnBehalf(String employeeName, String docType, String docName) {
    final id = 'td_custom_${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();
    final timeStr = '${now.day.toString().padLeft(2, '0')}-Jun-${now.year}';

    final newDoc = TeamDocModel(
      id: id,
      employeeName: employeeName,
      docType: docType,
      docName: docName,
      uploadedBy: activeEmployee.name,
      timestamp: '$timeStr ${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}',
    );

    _teamDocuments.insert(0, newDoc);
    logAudit(
      activeEmployee.name,
      employeeName,
      'Upload Document',
      'Uploaded $docType file ($docName) on behalf of $employeeName.',
    );
    notifyListeners();
  }

  // Dynamic Audit logs logger
  void logAudit(String actor, String target, String action, String description) {
    final logId = 'log_${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    final minuteStr = now.minute.toString().padLeft(2, '0');
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final timeStr = '${now.day.toString().padLeft(2, '0')}-${months[now.month-1]}-${now.year} ${hour.toString().padLeft(2, '0')}:$minuteStr $ampm';

    _auditLogs.insert(
      0,
      AuditLogModel(
        id: logId,
        actorName: actor,
        targetName: target,
        actionType: action,
        description: description,
        timestamp: timeStr,
      ),
    );
  }

  // SaaS Multi-company reset
  void switchCompany(String companyName) {
    _currentCompany = companyName;
    
    if (companyName == 'ABC Pvt Ltd') {
      _initializeData();
    } else if (companyName == 'XYZ Tech') {
      _roles = [
        RoleModel(
          id: 'r_admin',
          name: 'Tech Admin',
          description: 'Absolute admin access.',
          permissions: getAllPermissionKeys(),
          isSystemDefault: true,
          status: 'Active',
          usersCount: 1,
        ),
        RoleModel(
          id: 'r_people_manager',
          name: 'People Manager',
          description: 'Custom HR role for XYZ Tech.',
          permissions: ['view_employee', 'add_employee', 'view_leave', 'approve_leave', 'view_team', 'manage_team_documents'],
          isSystemDefault: false,
          status: 'Active',
          usersCount: 1,
        ),
        RoleModel(
          id: 'r_developer',
          name: 'Developer',
          description: 'Basic access for engineering team.',
          permissions: ['view_attendance', 'create_attendance', 'view_leave', 'apply_leave'],
          isSystemDefault: false,
          status: 'Active',
          usersCount: 1,
        ),
      ];

      _employees = [
        EmployeeModel(id: 'emp_xyz_1', name: 'Alok Mishra', roleId: 'r_admin', dept: 'Engineering', extraPermissions: [], restrictedPermissions: []),
        EmployeeModel(id: 'emp_xyz_2', name: 'Shreya Iyer', roleId: 'r_people_manager', dept: 'HR', extraPermissions: [], restrictedPermissions: []),
        EmployeeModel(id: 'emp_xyz_3', name: 'Vikas Dubey', roleId: 'r_developer', dept: 'Engineering', extraPermissions: [], restrictedPermissions: []),
      ];
      _activeEmployeeId = 'emp_xyz_1';

      _teamLeaves = [];
      _teamAttendanceLogs = [];
      _teamVisits = [];
      _teamDocuments = [];
      _teamTimesheets = [
        TeamTimesheetModel(employeeName: 'Vikas Dubey', dept: 'Engineering', workingHours: '40.0 Hrs', lateCount: 0, absentCount: 0, overtime: '0.0', breakDuration: '3.5 Hrs')
      ];
    } else if (companyName == 'SalesPro') {
      _roles = [
        RoleModel(
          id: 'r_admin',
          name: 'Sales Director',
          description: 'Super user for SalesPro operations.',
          permissions: getAllPermissionKeys(),
          isSystemDefault: true,
          status: 'Active',
          usersCount: 1,
        ),
        RoleModel(
          id: 'r_sales_supervisor',
          name: 'Sales Supervisor',
          description: 'Reviews sales teams location, visits, and tracking routes.',
          permissions: ['view_team', 'view_team_tracking', 'view_tracking', 'live_tracking', 'view_route_history', 'view_approval', 'approve_request', 'create_visit_for_team'],
          isSystemDefault: false,
          status: 'Active',
          usersCount: 1,
        ),
        RoleModel(
          id: 'r_sales_rep',
          name: 'Sales Representative',
          description: 'Log visits, travel and punch in details.',
          permissions: ['view_attendance', 'create_attendance', 'view_leave', 'apply_leave'],
          isSystemDefault: false,
          status: 'Active',
          usersCount: 1,
        ),
      ];

      _employees = [
        EmployeeModel(id: 'emp_sp_1', name: 'Mayur Sonowane', roleId: 'r_admin', dept: 'Sales', extraPermissions: [], restrictedPermissions: []),
        EmployeeModel(id: 'emp_sp_2', name: 'Kunal Khemu', roleId: 'r_sales_supervisor', dept: 'Sales', extraPermissions: [], restrictedPermissions: []),
        EmployeeModel(id: 'emp_sp_3', name: 'Deepak Punia', roleId: 'r_sales_rep', dept: 'Sales', extraPermissions: [], restrictedPermissions: []),
      ];
      _activeEmployeeId = 'emp_sp_1';

      _teamLeaves = [];
      _teamAttendanceLogs = [];
      _teamVisits = [
        TeamVisitModel(id: 'tv_sp_1', employeeName: 'Deepak Punia', clientName: 'Retail Shop A', location: 'Bandra', time: '10:00 AM', status: 'Assigned', assignedBy: 'Kunal Khemu')
      ];
      _teamDocuments = [];
      _teamTimesheets = [
        TeamTimesheetModel(employeeName: 'Deepak Punia', dept: 'Sales', workingHours: '32.1 Hrs', lateCount: 2, absentCount: 1, overtime: '0.0', breakDuration: '4.8 Hrs')
      ];
    }
    _seedProfiles();
    _seedAssets();
    _seedExpenses();
    _seedApprovalRequests();
    
    logAudit('System Engine', 'All Users', 'Company Switched', 'Switched configuration database to company "$companyName". Loaded custom white-labeled schema.');
    notifyListeners();
  }

  // ==========================================
  // PROFILE STATE OPERATIONS
  // ==========================================

  // Seeding Profiles
  void _seedProfiles() {
    _profileChangeRequests = [];
    if (_currentCompany == 'ABC Pvt Ltd') {
      _profiles = [
        _buildSeedProfile('emp_mayur', 'Mayur', 'Sonowane', 'Male', '12-May-1990', 'O+', 'Married', 'Director', 'Engineering', 'Surat Branch', 'Permanent', '01-Jan-2021', 'INR 1,20,000', 'INR 15,60,000 LPA', 'MacBook Pro 16" (S/N: MP-3982)', 'RFID Card (S/N: RFID-001)'),
        _buildSeedProfile('emp_riya', 'Riya', 'Sharma', 'Female', '22-Mar-1994', 'A+', 'Single', 'Team Leader', 'Engineering', 'Surat Branch', 'Permanent', '15-Mar-2022', 'INR 85,000', 'INR 11,05,000 LPA', 'HP EliteBook 840 (S/N: HP-2918)', 'RFID Card (S/N: RFID-002)'),
        _buildSeedProfile('emp_amit', 'Amit', 'Shah', 'Male', '08-Oct-1992', 'B+', 'Married', 'Sales Executive', 'Sales', 'Ahmedabad Branch', 'Permanent', '10-Jul-2023', 'INR 45,000', 'INR 5,85,000 LPA', 'Lenovo ThinkPad L14 (S/N: LN-1082)', 'Access Key (S/N: RFID-003)'),
        _buildSeedProfile('emp_akash', 'Akash', 'Patel', 'Male', '15-Jan-1988', 'AB+', 'Married', 'HR Manager', 'Marketing', 'Surat Branch', 'Permanent', '01-Nov-2022', 'INR 75,000', 'INR 9,75,000 LPA', 'Dell Vostro 15 (S/N: DL-4019)', 'RFID Card (S/N: RFID-004)'),
        _buildSeedProfile('emp_karan', 'Karan', 'Malhotra', 'Male', '25-Dec-1997', 'O-', 'Single', 'Developer', 'Sales', 'Surat Branch', 'Contract', '01-Feb-2024', 'INR 35,000', 'INR 4,55,000 LPA', 'Dell Latitude 3420 (S/N: DL-9921)', 'RFID Card (S/N: RFID-005)'),
        _buildSeedProfile('emp_finance_user', 'Hitesh', 'Mehta', 'Male', '03-Sep-1985', 'O+', 'Married', 'Finance Manager', 'Finance', 'Surat Branch', 'Permanent', '12-Aug-2023', 'INR 90,000', 'INR 11,70,000 LPA', 'MacBook Air 13" (S/N: MA-0291)', 'RFID Card (S/N: RFID-006)'),
      ];
    } else if (_currentCompany == 'XYZ Tech') {
      _profiles = [
        _buildSeedProfile('emp_xyz_1', 'Alok', 'Mishra', 'Male', '18-Jun-1989', 'A+', 'Married', 'Tech Admin', 'Engineering', 'Mumbai Branch', 'Permanent', '01-Aug-2021', 'INR 1,50,000', 'INR 19,50,000 LPA', 'MacBook Pro 14" (S/N: MP-8819)', 'RFID (S/N: XYZ-001)'),
        _buildSeedProfile('emp_xyz_2', 'Shreya', 'Iyer', 'Female', '04-Feb-1996', 'O+', 'Single', 'People Manager', 'HR', 'Mumbai Branch', 'Permanent', '15-Oct-2022', 'INR 80,000', 'INR 10,40,000 LPA', 'Dell XPS 13 (S/N: DL-8821)', 'RFID (S/N: XYZ-002)'),
        _buildSeedProfile('emp_xyz_3', 'Vikas', 'Dubey', 'Male', '30-Nov-1995', 'B-', 'Single', 'Developer', 'Engineering', 'Mumbai Branch', 'Permanent', '12-Dec-2023', 'INR 50,000', 'INR 6,50,000 LPA', 'Lenovo ThinkPad T14 (S/N: LN-0091)', 'RFID (S/N: XYZ-003)'),
      ];
    } else if (_currentCompany == 'SalesPro') {
      _profiles = [
        _buildSeedProfile('emp_sp_1', 'Mayur', 'Sonowane', 'Male', '12-May-1990', 'O+', 'Married', 'Sales Director', 'Sales', 'Surat Branch', 'Permanent', '01-Jan-2021', 'INR 1,60,000', 'INR 20,80,000 LPA', 'MacBook Pro 16" (S/N: MP-3982)', 'RFID Card (S/N: SP-001)'),
        _buildSeedProfile('emp_sp_2', 'Kunal', 'Khemu', 'Male', '21-Apr-1991', 'A+', 'Married', 'Sales Supervisor', 'Sales', 'Surat Branch', 'Permanent', '10-Feb-2022', 'INR 90,000', 'INR 11,70,000 LPA', 'Dell Latitude (S/N: DL-3981)', 'RFID Card (S/N: SP-002)'),
        _buildSeedProfile('emp_sp_3', 'Deepak', 'Punia', 'Male', '14-Sep-1998', 'O+', 'Single', 'Sales Representative', 'Sales', 'Surat Branch', 'Permanent', '01-Mar-2023', 'INR 30,000', 'INR 3,90,000 LPA', 'SIM Card (S/N: SIM-9982)', 'ID Card (S/N: SP-ID-003)'),
      ];
    }
  }

  EmployeeProfileModel _buildSeedProfile(
    String empId,
    String first,
    String last,
    String gender,
    String dob,
    String blood,
    String marital,
    String desig,
    String dept,
    String branch,
    String empType,
    String joinDate,
    String salary,
    String ctc,
    String laptopSerial,
    String accessCardSerial,
  ) {
    return EmployeeProfileModel(
      employeeId: empId,
      photoUrl: gender == 'Female'
          ? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80'
          : 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
      firstName: first,
      middleName: 'Kumar',
      lastName: last,
      gender: gender,
      dob: dob,
      bloodGroup: blood,
      maritalStatus: marital,
      nationality: 'Indian',
      religion: 'Hindu',
      aadharNumber: '4832 9981 ${1000 + empId.hashCode % 9000}',
      panNumber: 'ABCDE${1000 + empId.hashCode % 9000}F',
      passportNumber: 'Z${1000000 + empId.hashCode % 9000000}',
      drivingLicenseNumber: 'GJ-05-${20200000000 + empId.hashCode % 90000000}',
      mobileNumber: '+91 90123 ${40000 + empId.hashCode % 50000}',
      alternateMobile: '+91 88776 65544',
      personalEmail: '${first.toLowerCase()}.${last.toLowerCase()}@personal.com',
      officialEmail: '${first.toLowerCase()}@gitakshmi.com',
      employeeCode: empId.toUpperCase().replaceAll('EMP_', 'GIT-'),
      biometricId: 'BIO_${empId.toUpperCase()}',
      faceRegistrationStatus: 'Registered',
      addressDetails: AddressDetails(
        currentLine1: 'Row House No. 24, Green Valley',
        currentLine2: 'VIP Road, Veshu',
        currentCity: 'Surat',
        currentState: 'Gujarat',
        currentCountry: 'India',
        currentPincode: '395007',
        permanentLine1: 'Row House No. 24, Green Valley',
        permanentLine2: 'VIP Road, Veshu',
        permanentCity: 'Surat',
        permanentState: 'Gujarat',
        permanentCountry: 'India',
        permanentPincode: '395007',
        isPermanentSameAsCurrent: true,
      ),
      educationRecords: [
        EducationRecord(
          qualification: 'Bachelor',
          course: 'B.E. / B.Tech',
          specialization: 'Information Technology',
          university: 'Gujarat Technological University',
          institute: 'Sarvajanik College of Eng & Tech',
          board: 'GSEB',
          passingYear: '2016',
          percentage: '80%',
          grade: 'Distinction',
          cgpa: '8.0',
          attachedDoc: 'BTech_Degree.pdf',
        ),
        EducationRecord(
          qualification: 'HSC',
          course: 'Science',
          specialization: 'Mathematics (A-Group)',
          university: 'Gujarat Board',
          institute: 'T & T.V. High School',
          board: 'GSEB',
          passingYear: '2012',
          percentage: '85%',
          grade: 'A1',
          cgpa: '8.5',
          attachedDoc: 'HSC_Marksheet.pdf',
        )
      ],
      experienceRecords: [
        ExperienceRecord(
          companyName: 'L&T Infotech',
          designation: 'Software Engineer',
          department: 'Delivery',
          industry: 'IT Services',
          joiningDate: '15-Jul-2016',
          relievingDate: '10-Mar-2020',
          totalExperience: '3 Years 8 Months',
          currentSalary: 'INR 4,20,000 LPA',
          reasonForLeaving: 'Relocation and role progression.',
          attachedDoc: 'Exp_Letter_LNT.pdf',
        )
      ],
      familyMembers: [
        FamilyMember(
          name: '${first} Father',
          relation: 'Father',
          dob: '12-Apr-1960',
          occupation: 'Retired Service',
        ),
        FamilyMember(
          name: '${first} Mother',
          relation: 'Mother',
          dob: '05-Sep-1965',
          occupation: 'Homemaker',
        )
      ],
      emergencyContacts: [
        EmergencyContact(
          name: '${first} Brother',
          relation: 'Brother',
          mobileNumber: '+91 99001 12233',
          alternateNumber: '+91 99001 98765',
          address: 'Row House No. 24, VIP Road, Surat',
        )
      ],
      bankDetails: BankDetails(
        bankName: 'HDFC Bank',
        accountHolderName: '$first $last',
        accountNumber: '5010048293${1000 + empId.hashCode % 9000}',
        ifscCode: 'HDFC0000124',
        branchName: 'Vesu Branch',
        upiId: '${first.toLowerCase()}@okhdfc',
      ),
      assignedAssets: [
        AssignedAsset(
          assetName: laptopSerial,
          serialNumber: 'SN-${100000 + empId.hashCode % 900000}',
          issueDate: joinDate,
          returnDate: '--',
        ),
        AssignedAsset(
          assetName: accessCardSerial,
          serialNumber: 'CARD-${200000 + empId.hashCode % 800000}',
          issueDate: joinDate,
          returnDate: '--',
        )
      ],
      attendanceSummary: AttendanceSummary(
        presentDays: 22,
        absentDays: 0,
        leaveDays: 1,
        lateDays: 1,
        otHours: 5.0,
        currentMonthHours: 176.0,
      ),
      leaveSummary: LeaveSummary(
        availableLeave: 15,
        usedLeave: 3,
        pendingRequests: 0,
        approvedRequests: 2,
      ),
      payrollSummary: PayrollSummary(
        currentSalary: salary,
        ctc: ctc,
        lastPayslip: 'Payslip_May_2026.pdf',
        taxDetails: 'Form 16 Tax Deducted Source. No outstanding liability.',
      ),
      documents: [
        ProfileDocument(
          id: 'doc_aadhar_${empId}',
          category: 'Aadhar',
          name: 'Aadhar_${first}.pdf',
          uploadedBy: 'HR Admin',
          uploadedAt: '12-Mar-2024 11:00 AM',
          filePath: 'mock/Aadhar_${first}.pdf',
        ),
        ProfileDocument(
          id: 'doc_pan_${empId}',
          category: 'PAN',
          name: 'PAN_${first}.png',
          uploadedBy: 'HR Admin',
          uploadedAt: '12-Mar-2024 11:05 AM',
          filePath: 'mock/PAN_${first}.png',
        ),
        ProfileDocument(
          id: 'doc_offer_${empId}',
          category: 'Offer Letter',
          name: 'Offer_Letter_${first}.pdf',
          uploadedBy: 'Akash Patel',
          uploadedAt: joinDate + ' 10:00 AM',
          filePath: 'mock/Offer_Letter_${first}.pdf',
        )
      ],
      settings: ProfileSettings(
        changePassword: true,
        changePin: false,
        enableBiometric: true,
        enableFaceLogin: true,
        attendanceNotifications: true,
        approvalNotifications: true,
        leaveNotifications: true,
        payrollNotifications: true,
        profileVisibility: 'Team Only',
        contactVisibility: 'Public',
        documentVisibility: 'Private',
      ),
      timelineActivities: [
        TimelineActivity(
          title: 'Joined Company',
          description: 'Successfully joined $dept department at $branch.',
          timestamp: joinDate + ' 09:00 AM',
          category: 'Career',
        ),
        TimelineActivity(
          title: 'Onboarded Assets',
          description: 'Issued corporate laptop and identity security badges.',
          timestamp: joinDate + ' 11:30 AM',
          category: 'Assets',
        )
      ],
    );
  }

  // Get Profile
  EmployeeProfileModel getProfile(String employeeId) {
    return _profiles.firstWhere(
      (p) => p.employeeId == employeeId,
      orElse: () => _buildFallbackProfile(employeeId),
    );
  }

  EmployeeProfileModel _buildFallbackProfile(String empId) {
    final emp = _employees.firstWhere((e) => e.id == empId, orElse: () => _employees.first);
    return EmployeeProfileModel(
      employeeId: emp.id,
      photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
      firstName: emp.name.split(' ').first,
      middleName: 'Kumar',
      lastName: emp.name.split(' ').length > 1 ? emp.name.split(' ')[1] : 'Singh',
      gender: 'Male',
      dob: '15-Aug-1995',
      bloodGroup: 'O+',
      maritalStatus: 'Single',
      nationality: 'Indian',
      religion: 'Hindu',
      aadharNumber: '1234 5678 9012',
      panNumber: 'ABCDE1234F',
      passportNumber: 'Z1234567',
      drivingLicenseNumber: 'GJ-05-123456789',
      mobileNumber: '+91 98765 43210',
      alternateMobile: '',
      personalEmail: '${emp.id}@gmail.com',
      officialEmail: '${emp.id}@gitakshmi.com',
      employeeCode: emp.id.toUpperCase().replaceAll('EMP_', 'GIT-'),
      biometricId: 'BIO_${emp.id.toUpperCase()}',
      faceRegistrationStatus: 'Registered',
      addressDetails: AddressDetails(
        currentLine1: 'Flat 101, Sunrise Apartments',
        currentLine2: 'Adajan Road',
        currentCity: 'Surat',
        currentState: 'Gujarat',
        currentCountry: 'India',
        currentPincode: '395009',
        permanentLine1: 'Flat 101, Sunrise Apartments',
        permanentLine2: 'Adajan Road',
        permanentCity: 'Surat',
        permanentState: 'Gujarat',
        permanentCountry: 'India',
        permanentPincode: '395009',
        isPermanentSameAsCurrent: true,
      ),
      educationRecords: [
        EducationRecord(
          qualification: 'Bachelor',
          course: 'B.Tech',
          specialization: 'Computer Science',
          university: 'GTU',
          institute: 'SCET Surat',
          board: 'State Board',
          passingYear: '2018',
          percentage: '82%',
          grade: 'A',
          cgpa: '8.2',
          attachedDoc: 'Degree_Certificate_BTech.pdf',
        )
      ],
      experienceRecords: [
        ExperienceRecord(
          companyName: 'TechSolutions Pvt Ltd',
          designation: 'Software Developer',
          department: 'Engineering',
          industry: 'IT Services',
          joiningDate: '01-Jul-2018',
          relievingDate: '15-May-2022',
          totalExperience: '3 Years 10 Months',
          currentSalary: 'INR 4,50,000 LPA',
          reasonForLeaving: 'Better growth opportunities.',
          attachedDoc: 'Relieving_Letter_TechSolutions.pdf',
        )
      ],
      familyMembers: [
        FamilyMember(
          name: 'Ramesh Singh',
          relation: 'Father',
          dob: '10-May-1965',
          occupation: 'Business',
        )
      ],
      emergencyContacts: [
        EmergencyContact(
          name: 'Ramesh Singh',
          relation: 'Father',
          mobileNumber: '+91 98765 00001',
          alternateNumber: '',
          address: 'Flat 101, Sunrise Apartments, Adajan Road, Surat',
        )
      ],
      bankDetails: BankDetails(
        bankName: 'State Bank of India',
        accountHolderName: emp.name,
        accountNumber: '123456789012',
        ifscCode: 'SBIN0001234',
        branchName: 'Adajan Branch',
        upiId: '${emp.id}@oksbi',
      ),
      assignedAssets: [
        AssignedAsset(
          assetName: 'Dell Latitude Laptop',
          serialNumber: 'DL-8472-MX',
          issueDate: '01-Jun-2022',
          returnDate: '--',
        ),
        AssignedAsset(
          assetName: 'RFID Access Card',
          serialNumber: 'RFID-990-21',
          issueDate: '01-Jun-2022',
          returnDate: '--',
        )
      ],
      attendanceSummary: AttendanceSummary(
        presentDays: 20,
        absentDays: 1,
        leaveDays: 2,
        lateDays: 2,
        otHours: 4.5,
        currentMonthHours: 168.0,
      ),
      leaveSummary: LeaveSummary(
        availableLeave: 12,
        usedLeave: 5,
        pendingRequests: 1,
        approvedRequests: 3,
      ),
      payrollSummary: PayrollSummary(
        currentSalary: 'INR 50,000',
        ctc: 'INR 6,50,000 LPA',
        lastPayslip: 'Payslip_May_2026.pdf',
        taxDetails: 'Form 16 Tax Deducted Source.',
      ),
      documents: [
        ProfileDocument(
          id: 'doc_aadhaar',
          category: 'Aadhar',
          name: 'Aadhaar_Card.pdf',
          uploadedBy: 'System',
          uploadedAt: '01-Jun-2022 10:00 AM',
          filePath: 'mock/docs/Aadhaar_Card.pdf',
        )
      ],
      settings: ProfileSettings(
        changePassword: true,
        changePin: false,
        enableBiometric: true,
        enableFaceLogin: true,
        attendanceNotifications: true,
        approvalNotifications: true,
        leaveNotifications: true,
        payrollNotifications: false,
        profileVisibility: 'Team Only',
        contactVisibility: 'Public',
        documentVisibility: 'Private',
      ),
      timelineActivities: [
        TimelineActivity(
          title: 'Joined Company',
          description: 'Successfully onboarded.',
          timestamp: '01-Jun-2022 09:30 AM',
          category: 'Career',
        )
      ],
    );
  }

  // Update Profile
  void updateProfile(String employeeId, EmployeeProfileModel updated) {
    final idx = _profiles.indexWhere((p) => p.employeeId == employeeId);
    if (idx != -1) {
      _profiles[idx] = updated;
      notifyListeners();
    }
  }

  // Request change for approval-based fields
  void requestProfileChange({
    required String employeeId,
    required String category,
    required String fieldName,
    required String oldValue,
    required String newValue,
  }) {
    final emp = _employees.firstWhere((e) => e.id == employeeId);
    final reqId = 'req_${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final dateStr = '${now.day.toString().padLeft(2, '0')} ${months[now.month-1]} ${now.year}';

    _profileChangeRequests.insert(
      0,
      ProfileChangeRequest(
        id: reqId,
        employeeId: employeeId,
        employeeName: emp.name,
        category: category,
        fieldName: fieldName,
        oldValue: oldValue,
        newValue: newValue,
        status: 'Pending',
        date: dateStr,
      ),
    );

    logAudit(
      activeEmployee.name,
      emp.name,
      'Profile Edit Requested',
      'Requested $category update ($fieldName). Old: "$oldValue", New: "$newValue". Requires approval.',
    );
    notifyListeners();
  }

  // Process change request
  void approveProfileRequest(String requestId) {
    final reqIdx = _profileChangeRequests.indexWhere((r) => r.id == requestId);
    if (reqIdx != -1) {
      final req = _profileChangeRequests[reqIdx];
      _profileChangeRequests[reqIdx] = ProfileChangeRequest(
        id: req.id,
        employeeId: req.employeeId,
        employeeName: req.employeeName,
        category: req.category,
        fieldName: req.fieldName,
        oldValue: req.oldValue,
        newValue: req.newValue,
        status: 'Approved',
        date: req.date,
      );

      // Apply the update to the profile
      final profIdx = _profiles.indexWhere((p) => p.employeeId == req.employeeId);
      if (profIdx != -1) {
        final profile = _profiles[profIdx];
        EmployeeProfileModel newProf = profile;
        if (req.category == 'Bank Details') {
          final bank = profile.bankDetails;
          BankDetails newBank = bank;
          if (req.fieldName == 'Bank Name') newBank = bank.copyWith(bankName: req.newValue);
          if (req.fieldName == 'Account Number') newBank = bank.copyWith(accountNumber: req.newValue);
          if (req.fieldName == 'IFSC Code') newBank = bank.copyWith(ifscCode: req.newValue);
          if (req.fieldName == 'Account Holder') newBank = bank.copyWith(accountHolderName: req.newValue);
          if (req.fieldName == 'Branch Name') newBank = bank.copyWith(branchName: req.newValue);
          if (req.fieldName == 'UPI ID') newBank = bank.copyWith(upiId: req.newValue);
          newProf = profile.copyWith(bankDetails: newBank);
        } else if (req.category == 'Personal Info' || req.category == 'Personal Details') {
          if (req.fieldName == 'First Name') newProf = profile.copyWith(firstName: req.newValue);
          if (req.fieldName == 'Last Name') newProf = profile.copyWith(lastName: req.newValue);
          if (req.fieldName == 'Mobile Number') newProf = profile.copyWith(mobileNumber: req.newValue);
          if (req.fieldName == 'Personal Email') newProf = profile.copyWith(personalEmail: req.newValue);
          if (req.fieldName == 'Aadhar Number') newProf = profile.copyWith(aadharNumber: req.newValue);
          if (req.fieldName == 'PAN Number') newProf = profile.copyWith(panNumber: req.newValue);
        }
        _profiles[profIdx] = newProf;
      }

      logAudit(
        activeEmployee.name,
        req.employeeName,
        'Profile Edit Approved',
        'Approved ${req.category} update for ${req.employeeName} (${req.fieldName} -> "${req.newValue}").',
      );
      notifyListeners();
    }
  }

  void rejectProfileRequest(String requestId, {String reason = 'Rejected by HR'}) {
    final reqIdx = _profileChangeRequests.indexWhere((r) => r.id == requestId);
    if (reqIdx != -1) {
      final req = _profileChangeRequests[reqIdx];
      _profileChangeRequests[reqIdx] = ProfileChangeRequest(
        id: req.id,
        employeeId: req.employeeId,
        employeeName: req.employeeName,
        category: req.category,
        fieldName: req.fieldName,
        oldValue: req.oldValue,
        newValue: req.newValue,
        status: 'Rejected',
        date: req.date,
      );

      logAudit(
        activeEmployee.name,
        req.employeeName,
        'Profile Edit Rejected',
        'Rejected ${req.category} update for ${req.employeeName} (${req.fieldName}). Reason: $reason.',
      );
      notifyListeners();
    }
  }

  // Profile Documents actions
  void uploadDocument(String employeeId, ProfileDocument doc) {
    final idx = _profiles.indexWhere((p) => p.employeeId == employeeId);
    if (idx != -1) {
      final old = _profiles[idx];
      final List<ProfileDocument> updatedDocs = List.from(old.documents)..insert(0, doc);
      _profiles[idx] = old.copyWith(documents: updatedDocs);

      logAudit(
        activeEmployee.name,
        old.firstName + ' ' + old.lastName,
        'Document Uploaded',
        'Uploaded profile document: ${doc.name} (${doc.category}).',
      );
      notifyListeners();
    }
  }

  void deleteDocument(String employeeId, String docId) {
    final idx = _profiles.indexWhere((p) => p.employeeId == employeeId);
    if (idx != -1) {
      final old = _profiles[idx];
      final docName = old.documents.firstWhere((d) => d.id == docId, orElse: () => ProfileDocument(id: '', category: '', name: 'Doc', uploadedBy: '', uploadedAt: '', filePath: '')).name;
      final List<ProfileDocument> updatedDocs = List.from(old.documents)..removeWhere((d) => d.id == docId);
      _profiles[idx] = old.copyWith(documents: updatedDocs);

      logAudit(
        activeEmployee.name,
        old.firstName + ' ' + old.lastName,
        'Document Deleted',
        'Deleted profile document: $docName.',
      );
      notifyListeners();
    }
  }

  // Profile Assets action
  void assignAsset(String employeeId, AssignedAsset asset) {
    final idx = _profiles.indexWhere((p) => p.employeeId == employeeId);
    if (idx != -1) {
      final old = _profiles[idx];
      final List<AssignedAsset> updatedAssets = List.from(old.assignedAssets)..insert(0, asset);
      _profiles[idx] = old.copyWith(assignedAssets: updatedAssets);

      logAudit(
        activeEmployee.name,
        old.firstName + ' ' + old.lastName,
        'Asset Assigned',
        'Assigned new corporate asset: ${asset.assetName} (S/N: ${asset.serialNumber}).',
      );
      notifyListeners();
    }
  }

  // ==========================================
  // ASSET MANAGEMENT STATE OPERATIONS
  // ==========================================

  void _seedAssets() {
    _assetRequests = [];
    _assetTickets = [];
    _assetTransfers = [];
    _assetAudits = [];

    if (_currentCompany == 'ABC Pvt Ltd') {
      _companyAssets = [
        CompanyAssetModel(
          id: 'ast_abc_1',
          name: 'MacBook Pro 16" (M3 Pro)',
          category: 'IT',
          assetCode: 'LAP-00125',
          serialNumber: 'SN-MP3-88271',
          brand: 'Apple',
          model: 'MacBook Pro M3 Pro',
          issueDate: '01-Jan-2025',
          condition: 'Excellent',
          healthScore: 92.0,
          qrData: 'LAP-00125',
          warrantyStart: '01-Jan-2025',
          warrantyEnd: '01-Jan-2028',
          purchaseDate: '15-Dec-2024',
          specifications: {
            'Processor': 'M3 Pro (12-core CPU, 18-core GPU)',
            'RAM': '36GB Unified Memory',
            'Storage': '512GB SSD',
            'OS': 'macOS Sequoia',
          },
          assignedToEmployeeId: 'emp_mayur',
          assignedToEmployeeName: 'Mayur Sonowane',
          assignedByEmployeeName: 'HR Specialist',
          warrantyAlert: false,
          documentManual: 'MacBook_Pro_Manual.pdf',
          documentInvoice: 'Invoice_L-00125.pdf',
        ),
        CompanyAssetModel(
          id: 'ast_abc_2',
          name: 'RFID Corporate Access Card',
          category: 'Office',
          assetCode: 'CRD-00448',
          serialNumber: 'SN-RFID-10029',
          brand: 'HID Global',
          model: 'iCLASS Seos',
          issueDate: '01-Jan-2025',
          condition: 'Good',
          healthScore: 95.0,
          qrData: 'CRD-00448',
          warrantyStart: 'N/A',
          warrantyEnd: 'N/A',
          purchaseDate: '10-Dec-2024',
          specifications: {
            'Frequency': '13.56 MHz',
            'Format': '37-bit H10302',
          },
          assignedToEmployeeId: 'emp_mayur',
          assignedToEmployeeName: 'Mayur Sonowane',
          assignedByEmployeeName: 'HR Specialist',
          warrantyAlert: false,
          documentManual: 'Access_Card_Policy.pdf',
          documentInvoice: 'Invoice_CRD-00448.pdf',
        ),
        CompanyAssetModel(
          id: 'ast_abc_3',
          name: 'HP EliteBook 840 G10',
          category: 'IT',
          assetCode: 'LAP-00126',
          serialNumber: 'SN-HP-998822',
          brand: 'HP',
          model: 'EliteBook 840 G10',
          issueDate: '15-Mar-2022',
          condition: 'Fair',
          healthScore: 78.0,
          qrData: 'LAP-00126',
          warrantyStart: '15-Mar-2022',
          warrantyEnd: '15-Mar-2025',
          purchaseDate: '01-Mar-2022',
          specifications: {
            'Processor': 'Intel Core i7-1365U',
            'RAM': '16GB DDR5',
            'Storage': '512GB NVMe SSD',
            'OS': 'Windows 11 Pro',
          },
          assignedToEmployeeId: 'emp_riya',
          assignedToEmployeeName: 'Riya Sharma',
          assignedByEmployeeName: 'HR Specialist',
          warrantyAlert: true,
          documentManual: 'HP_EliteBook_Manual.pdf',
          documentInvoice: 'Invoice_HP-126.pdf',
        ),
        CompanyAssetModel(
          id: 'ast_abc_4',
          name: 'Lenovo ThinkPad L14',
          category: 'IT',
          assetCode: 'LAP-00127',
          serialNumber: 'SN-LN-108272',
          brand: 'Lenovo',
          model: 'ThinkPad L14 Gen 4',
          issueDate: '10-Jul-2023',
          condition: 'Good',
          healthScore: 84.0,
          qrData: 'LAP-00127',
          warrantyStart: '10-Jul-2023',
          warrantyEnd: '10-Jul-2026',
          purchaseDate: '25-Jun-2023',
          specifications: {
            'Processor': 'AMD Ryzen 5 7530U',
            'RAM': '16GB DDR4',
            'Storage': '512GB PCIe SSD',
            'OS': 'Windows 11 Pro',
          },
          assignedToEmployeeId: 'emp_amit',
          assignedToEmployeeName: 'Amit Shah',
          assignedByEmployeeName: 'Riya Sharma',
          warrantyAlert: false,
          documentManual: 'ThinkPad_L14_Manual.pdf',
          documentInvoice: 'Invoice_LN-127.pdf',
        ),
        CompanyAssetModel(
          id: 'ast_abc_5',
          name: 'SIM Card Jio Enterprise',
          category: 'Field',
          assetCode: 'SIM-00910',
          serialNumber: 'SN-JIO-998271',
          brand: 'Jio',
          model: '4G LTE Enterprise SIM',
          issueDate: '10-Jul-2023',
          condition: 'Excellent',
          healthScore: 100.0,
          qrData: 'SIM-00910',
          warrantyStart: 'N/A',
          warrantyEnd: 'N/A',
          purchaseDate: '01-Jul-2023',
          specifications: {
            'Carrier': 'Reliance Jio',
            'Plan': 'Unlimited Calls & 5GB Data/Day',
            'Phone Number': '+91 90123 48172',
          },
          assignedToEmployeeId: 'emp_amit',
          assignedToEmployeeName: 'Amit Shah',
          assignedByEmployeeName: 'Riya Sharma',
          warrantyAlert: false,
          documentManual: 'Jio_Enterprise_Usage_Policy.pdf',
          documentInvoice: 'Invoice_SIM-00910.pdf',
        )
      ];

      _assetRequests = [
        AssetRequestModel(
          id: 'req_ast_1',
          employeeId: 'emp_amit',
          employeeName: 'Amit Shah',
          category: 'IT',
          type: 'Replacement',
          priority: 'High',
          reason: 'Current HP EliteBook is running extremely slow during sales pitch presentations.',
          attachment: 'Diagnostic_Screenshot.png',
          status: 'Pending',
          date: '05 Jun 2026',
        ),
        AssetRequestModel(
          id: 'req_ast_2',
          employeeId: 'emp_karan',
          employeeName: 'Karan Malhotra',
          category: 'Office',
          type: 'New',
          priority: 'Medium',
          reason: 'Need physical corporate locker keys to store testing devices safely.',
          attachment: 'Project_Lead_Signature.pdf',
          status: 'Approved',
          date: '04 Jun 2026',
        )
      ];

      _assetTickets = [
        AssetTicketModel(
          id: 'tkt_ast_1',
          assetId: 'ast_abc_4',
          assetName: 'Lenovo ThinkPad L14',
          employeeId: 'emp_amit',
          employeeName: 'Amit Shah',
          issueType: 'Keyboard Issue',
          description: 'The "Enter" and "Backspace" keys are frequently getting stuck.',
          priority: 'Medium',
          status: 'In Progress',
          date: '04 Jun 2026',
          resolutionRemarks: '',
        )
      ];
    } else if (_currentCompany == 'XYZ Tech') {
      _companyAssets = [
        CompanyAssetModel(
          id: 'ast_xyz_1',
          name: 'Developer MacBook Pro 14"',
          category: 'IT',
          assetCode: 'LAP-00210',
          serialNumber: 'SN-MP14-99018',
          brand: 'Apple',
          model: 'MacBook Pro M3',
          issueDate: '01-Aug-2021',
          condition: 'Good',
          healthScore: 82.0,
          qrData: 'LAP-00210',
          warrantyStart: '01-Aug-2021',
          warrantyEnd: '01-Aug-2024',
          purchaseDate: '15-Jul-2021',
          specifications: {
            'Processor': 'M3 (8-core CPU, 10-core GPU)',
            'RAM': '16GB Unified Memory',
            'Storage': '512GB SSD',
          },
          assignedToEmployeeId: 'emp_xyz_1',
          assignedToEmployeeName: 'Alok Mishra',
          assignedByEmployeeName: 'System Admin',
          warrantyAlert: true,
          documentManual: 'MacBook_Manual.pdf',
          documentInvoice: 'Invoice_LAP-210.pdf',
        )
      ];
    } else if (_currentCompany == 'SalesPro') {
      _companyAssets = [
        CompanyAssetModel(
          id: 'ast_sp_1',
          name: 'Sales Delivery Vehicle (Honda Activa)',
          category: 'Field',
          assetCode: 'VEH-00812',
          serialNumber: 'SN-HONDA-ACT829',
          brand: 'Honda',
          model: 'Activa 6G',
          issueDate: '01-Jan-2021',
          condition: 'Good',
          healthScore: 88.0,
          qrData: 'VEH-00812',
          warrantyStart: '01-Jan-2021',
          warrantyEnd: '01-Jan-2026',
          purchaseDate: '20-Dec-2020',
          specifications: {
            'Engine': '110cc Fan Cooled',
            'Fuel': 'Petrol',
            'Registration No.': 'GJ-05-AB-1234',
          },
          assignedToEmployeeId: 'emp_sp_1',
          assignedToEmployeeName: 'Mayur Sonowane',
          assignedByEmployeeName: 'SalesPro Admin',
          warrantyAlert: true,
          documentManual: 'Activa_User_Guide.pdf',
          documentInvoice: 'Invoice_VEH-812.pdf',
        ),
        CompanyAssetModel(
          id: 'ast_sp_2',
          name: 'Mobile POS Machine',
          category: 'Field',
          assetCode: 'POS-00192',
          serialNumber: 'SN-POS-8827',
          brand: 'Pax Technologies',
          model: 'A920 Smart POS',
          issueDate: '10-Feb-2022',
          condition: 'Fair',
          healthScore: 76.0,
          qrData: 'POS-00192',
          warrantyStart: '10-Feb-2022',
          warrantyEnd: '10-Feb-2025',
          purchaseDate: '01-Feb-2022',
          specifications: {
            'OS': 'Android PayDroid',
            'Connectivity': '4G / Wi-Fi',
            'Printer': 'Thermal Printer Built-in',
          },
          assignedToEmployeeId: 'emp_sp_2',
          assignedToEmployeeName: 'Kunal Khemu',
          assignedByEmployeeName: 'SalesPro Admin',
          warrantyAlert: true,
          documentManual: 'Pax_A920_User_Manual.pdf',
          documentInvoice: 'Invoice_POS-192.pdf',
        )
      ];
    }
  }

  // Submit new request
  void createAssetRequest({
    required String category,
    required String type,
    required String priority,
    required String reason,
    required String attachment,
  }) {
    final newId = 'req_ast_${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final dateStr = '${now.day.toString().padLeft(2, '0')} ${months[now.month-1]} ${now.year}';

    final request = AssetRequestModel(
      id: newId,
      employeeId: activeEmployeeId,
      employeeName: activeEmployee.name,
      category: category,
      type: type,
      priority: priority,
      reason: reason,
      attachment: attachment,
      status: 'Pending',
      date: dateStr,
    );

    _assetRequests.insert(0, request);

    logAudit(
      activeEmployee.name,
      'IT Department',
      'Asset Request Submitted',
      'Submitted request for a $category asset ($type). Priority: $priority. Reason: $reason.',
    );
    notifyListeners();
  }

  // Report issue ticket
  void reportAssetIssue({
    required String assetId,
    required String assetName,
    required String issueType,
    required String description,
    required String priority,
  }) {
    final newId = 'tkt_ast_${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final dateStr = '${now.day.toString().padLeft(2, '0')} ${months[now.month-1]} ${now.year}';

    final ticket = AssetTicketModel(
      id: newId,
      assetId: assetId,
      assetName: assetName,
      employeeId: activeEmployeeId,
      employeeName: activeEmployee.name,
      issueType: issueType,
      description: description,
      priority: priority,
      status: 'Open',
      date: dateStr,
      resolutionRemarks: '',
    );

    _assetTickets.insert(0, ticket);

    logAudit(
      activeEmployee.name,
      'IT Support Team',
      'Asset Issue Logged',
      'Logged issue for $assetName: $issueType ($priority). Details: $description.',
    );
    notifyListeners();
  }

  // Transfer asset from Employee A to Employee B
  void transferAsset(String assetId, String targetEmployeeId, String remarks) {
    final assetIdx = _companyAssets.indexWhere((a) => a.id == assetId);
    final targetEmp = _employees.firstWhere((e) => e.id == targetEmployeeId);

    if (assetIdx != -1) {
      final asset = _companyAssets[assetIdx];
      final fromName = asset.assignedToEmployeeName;
      
      final updatedAsset = CompanyAssetModel(
        id: asset.id,
        name: asset.name,
        category: asset.category,
        assetCode: asset.assetCode,
        serialNumber: asset.serialNumber,
        brand: asset.brand,
        model: asset.model,
        issueDate: asset.issueDate,
        condition: asset.condition,
        healthScore: asset.healthScore,
        qrData: asset.qrData,
        warrantyStart: asset.warrantyStart,
        warrantyEnd: asset.warrantyEnd,
        purchaseDate: asset.purchaseDate,
        specifications: asset.specifications,
        assignedToEmployeeId: targetEmployeeId,
        assignedToEmployeeName: targetEmp.name,
        assignedByEmployeeName: activeEmployee.name,
        warrantyAlert: asset.warrantyAlert,
        documentManual: asset.documentManual,
        documentInvoice: asset.documentInvoice,
      );

      _companyAssets[assetIdx] = updatedAsset;

      // Log the transfer
      final transferId = 'xfer_${DateTime.now().millisecondsSinceEpoch}';
      final now = DateTime.now();
      final dateStr = '${now.day.toString().padLeft(2, '0')}-Jun-${now.year}';
      
      _assetTransfers.insert(
        0,
        AssetTransferLogModel(
          id: transferId,
          assetId: asset.id,
          assetName: asset.name,
          fromEmployeeName: fromName,
          toEmployeeName: targetEmp.name,
          date: dateStr,
          remarks: remarks,
        ),
      );

      logAudit(
        activeEmployee.name,
        targetEmp.name,
        'Asset Transferred',
        'Transferred asset "${asset.name}" from $fromName to ${targetEmp.name}. Notes: $remarks.',
      );
      notifyListeners();
    }
  }

  // Scan & Verify audit verification
  void auditVerifyAsset(String assetId, String scannedBy, String condition) {
    final asset = _companyAssets.firstWhere((a) => a.id == assetId || a.assetCode == assetId);
    final now = DateTime.now();
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final dateStr = '${now.day.toString().padLeft(2, '0')} ${months[now.month-1]} ${now.year}';

    final isMatched = asset.assignedToEmployeeId == activeEmployeeId || activeEmployee.roleId == 'r_admin' || activeEmployee.roleId == 'r_hr';

    final audit = AssetAuditLogModel(
      id: 'aud_${DateTime.now().millisecondsSinceEpoch}',
      assetId: asset.id,
      assetName: asset.name,
      scannedBy: scannedBy,
      date: dateStr,
      scannedCondition: condition,
      result: isMatched ? 'Verified Ownership' : 'Mismatch Warning',
    );

    _assetAudits.insert(0, audit);

    // Update asset condition based on audit scan
    final assetIdx = _companyAssets.indexWhere((a) => a.id == asset.id);
    if (assetIdx != -1) {
      _companyAssets[assetIdx] = CompanyAssetModel(
        id: asset.id,
        name: asset.name,
        category: asset.category,
        assetCode: asset.assetCode,
        serialNumber: asset.serialNumber,
        brand: asset.brand,
        model: asset.model,
        issueDate: asset.issueDate,
        condition: condition,
        healthScore: condition == 'Excellent' ? 95.0 : condition == 'Good' ? 88.0 : condition == 'Fair' ? 70.0 : 45.0,
        qrData: asset.qrData,
        warrantyStart: asset.warrantyStart,
        warrantyEnd: asset.warrantyEnd,
        purchaseDate: asset.purchaseDate,
        specifications: asset.specifications,
        assignedToEmployeeId: asset.assignedToEmployeeId,
        assignedToEmployeeName: asset.assignedToEmployeeName,
        assignedByEmployeeName: asset.assignedByEmployeeName,
        warrantyAlert: asset.warrantyAlert,
        documentManual: asset.documentManual,
        documentInvoice: asset.documentInvoice,
      );
    }

    logAudit(
      scannedBy,
      asset.assignedToEmployeeName,
      'Asset Audited',
      'Scanned QR for ${asset.name}. Verified Ownership: ${isMatched ? "YES" : "NO"}. Audited condition: $condition.',
    );
    notifyListeners();
  }

  // Request asset return
  void requestAssetReturn(String assetId, String reason) {
    final asset = _companyAssets.firstWhere((a) => a.id == assetId);
    final newId = 'req_ast_${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final dateStr = '${now.day.toString().padLeft(2, '0')} ${months[now.month-1]} ${now.year}';

    final request = AssetRequestModel(
      id: newId,
      employeeId: activeEmployeeId,
      employeeName: activeEmployee.name,
      category: asset.category,
      type: 'Return',
      priority: 'Medium',
      reason: 'Asset return process triggered. Reason: $reason.',
      attachment: 'Release_Form.pdf',
      status: 'Pending',
      date: dateStr,
    );

    _assetRequests.insert(0, request);

    logAudit(
      activeEmployee.name,
      'HR Department',
      'Asset Return Initiated',
      'Initiated return process for "${asset.name}". Reason: $reason.',
    );
    notifyListeners();
  }

  // IT Admin operations: Create Asset
  void createAsset({
    required String name,
    required String category,
    required String assetCode,
    required String serialNumber,
    required String brand,
    required String model,
    required double healthScore,
    required Map<String, String> specifications,
  }) {
    final newId = 'ast_abc_${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();
    final dateStr = '${now.day.toString().padLeft(2, '0')}-Jun-${now.year}';

    final newAsset = CompanyAssetModel(
      id: newId,
      name: name,
      category: category,
      assetCode: assetCode,
      serialNumber: serialNumber,
      brand: brand,
      model: model,
      issueDate: '--',
      condition: 'Excellent',
      healthScore: healthScore,
      qrData: assetCode,
      warrantyStart: dateStr,
      warrantyEnd: '${now.day.toString().padLeft(2, '0')}-Jun-${now.year + 3}',
      purchaseDate: dateStr,
      specifications: specifications,
      assignedToEmployeeId: '',
      assignedToEmployeeName: '--',
      assignedByEmployeeName: '--',
      warrantyAlert: false,
      documentManual: 'Generic_User_Manual.pdf',
      documentInvoice: 'Invoice_${assetCode}.pdf',
    );

    _companyAssets.add(newAsset);

    logAudit(
      activeEmployee.name,
      'Asset Inventory',
      'Asset Registered',
      'Registered new $category asset: $name (Code: $assetCode).',
    );
    notifyListeners();
  }

  // IT Admin / HR operations: Assign Asset
  void assignAssetToUser(String assetId, String employeeId) {
    final assetIdx = _companyAssets.indexWhere((a) => a.id == assetId);
    final targetEmp = _employees.firstWhere((e) => e.id == employeeId);

    if (assetIdx != -1) {
      final asset = _companyAssets[assetIdx];
      final now = DateTime.now();
      final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      final dateStr = '${now.day.toString().padLeft(2, '0')} ${months[now.month-1]} ${now.year}';

      _companyAssets[assetIdx] = CompanyAssetModel(
        id: asset.id,
        name: asset.name,
        category: asset.category,
        assetCode: asset.assetCode,
        serialNumber: asset.serialNumber,
        brand: asset.brand,
        model: asset.model,
        issueDate: dateStr,
        condition: asset.condition,
        healthScore: asset.healthScore,
        qrData: asset.qrData,
        warrantyStart: asset.warrantyStart,
        warrantyEnd: asset.warrantyEnd,
        purchaseDate: asset.purchaseDate,
        specifications: asset.specifications,
        assignedToEmployeeId: employeeId,
        assignedToEmployeeName: targetEmp.name,
        assignedByEmployeeName: activeEmployee.name,
        warrantyAlert: asset.warrantyAlert,
        documentManual: asset.documentManual,
        documentInvoice: asset.documentInvoice,
      );

      // Append to Employee profile asset checklist
      final profIdx = _profiles.indexWhere((p) => p.employeeId == employeeId);
      if (profIdx != -1) {
        final profile = _profiles[profIdx];
        final List<AssignedAsset> updated = List.from(profile.assignedAssets)
          ..insert(
            0,
            AssignedAsset(
              assetName: asset.name,
              serialNumber: asset.serialNumber,
              issueDate: dateStr,
              returnDate: '--',
            ),
          );
        
        final List<TimelineActivity> updatedTimeline = List.from(profile.timelineActivities)
          ..insert(
            0,
            TimelineActivity(
              title: 'Asset Allocated',
              description: 'Issued asset: ${asset.name} (Code: ${asset.assetCode}).',
              timestamp: '$dateStr 10:00 AM',
              category: 'Assets',
            ),
          );

        _profiles[profIdx] = profile.copyWith(
          assignedAssets: updated,
          timelineActivities: updatedTimeline,
        );
      }

      logAudit(
        activeEmployee.name,
        targetEmp.name,
        'Asset Assigned',
        'Allocated asset "${asset.name}" to employee ${targetEmp.name}.',
      );
      notifyListeners();
    }
  }

  // IT Admin operations: Resolve Ticket
  void resolveAssetTicket(String ticketId, String remarks) {
    final idx = _assetTickets.indexWhere((t) => t.id == ticketId);
    if (idx != -1) {
      final old = _assetTickets[idx];
      _assetTickets[idx] = AssetTicketModel(
        id: old.id,
        assetId: old.assetId,
        assetName: old.assetName,
        employeeId: old.employeeId,
        employeeName: old.employeeName,
        issueType: old.issueType,
        description: old.description,
        priority: old.priority,
        status: 'Resolved',
        date: old.date,
        resolutionRemarks: remarks,
      );

      logAudit(
        activeEmployee.name,
        old.employeeName,
        'Asset Ticket Resolved',
        'Resolved issue ticket for "${old.assetName}" (${old.issueType}). Remarks: $remarks.',
      );
      notifyListeners();
    }
  }

  // HR Admin operations: Approve Request
  void approveAssetRequest(String requestId) {
    final idx = _assetRequests.indexWhere((r) => r.id == requestId);
    if (idx != -1) {
      final req = _assetRequests[idx];
      _assetRequests[idx] = AssetRequestModel(
        id: req.id,
        employeeId: req.employeeId,
        employeeName: req.employeeName,
        category: req.category,
        type: req.type,
        priority: req.priority,
        reason: req.reason,
        attachment: req.attachment,
        status: 'Approved',
        date: req.date,
      );

      logAudit(
        activeEmployee.name,
        req.employeeName,
        'Asset Request Approved',
        'Approved $req.category asset request ($req.type) for ${req.employeeName}.',
      );
      notifyListeners();
    }
  }

  void rejectAssetRequest(String requestId) {
    final idx = _assetRequests.indexWhere((r) => r.id == requestId);
    if (idx != -1) {
      final req = _assetRequests[idx];
      _assetRequests[idx] = AssetRequestModel(
        id: req.id,
        employeeId: req.employeeId,
        employeeName: req.employeeName,
        category: req.category,
        type: req.type,
        priority: req.priority,
        reason: req.reason,
        attachment: req.attachment,
        status: 'Rejected',
        date: req.date,
      );

      logAudit(
        activeEmployee.name,
        req.employeeName,
        'Asset Request Rejected',
        'Rejected $req.category asset request ($req.type) for ${req.employeeName}.',
      );
      notifyListeners();
    }
  }

  // ==========================================
  // EXPENSE MANAGEMENT STATE OPERATIONS
  // ==========================================

  void _seedExpenses() {
    _advanceRequests = [];
    _reimbursements = [];

    _expensePolicies = [
      ExpensePolicyModel(category: 'Food', limitPerClaim: 500, unit: 'per meal', notes: 'Includes all meals during business hours.'),
      ExpensePolicyModel(category: 'Hotel', limitPerClaim: 3000, unit: 'per night', notes: 'Economy or business class hotels only.'),
      ExpensePolicyModel(category: 'Fuel', limitPerClaim: 5, unit: 'per km', notes: 'Calculated at ₹5 per km for approved vehicles.'),
      ExpensePolicyModel(category: 'Travel', limitPerClaim: 5000, unit: 'per trip', notes: 'Air/rail tickets economy class only.'),
      ExpensePolicyModel(category: 'Client Meeting', limitPerClaim: 2000, unit: 'per meeting', notes: 'Includes hospitality for client guests.'),
      ExpensePolicyModel(category: 'Entertainment', limitPerClaim: 1500, unit: 'per event', notes: 'Pre-approval required above ₹1,000.'),
      ExpensePolicyModel(category: 'Office Supplies', limitPerClaim: 1000, unit: 'per month', notes: 'Must attach vendor invoice.'),
      ExpensePolicyModel(category: 'Internet', limitPerClaim: 999, unit: 'per month', notes: 'Home broadband for WFH employees.'),
      ExpensePolicyModel(category: 'Mobile Recharge', limitPerClaim: 299, unit: 'per month', notes: 'Corporate plan recharge only.'),
      ExpensePolicyModel(category: 'Training', limitPerClaim: 10000, unit: 'per course', notes: 'Requires manager pre-approval.'),
      ExpensePolicyModel(category: 'Medical', limitPerClaim: 2000, unit: 'per claim', notes: 'Emergency medical only. Requires prescription.'),
      ExpensePolicyModel(category: 'Other', limitPerClaim: 500, unit: 'per claim', notes: 'Other miscellaneous approved expenses.'),
    ];

    if (_currentCompany == 'ABC Pvt Ltd') {
      _expenseClaims = [
        ExpenseClaimModel(
          id: 'exp_abc_1',
          employeeId: 'emp_mayur',
          employeeName: 'Mayur Sonowane',
          title: 'Mumbai Client Visit — Q2 Strategy Meeting',
          status: 'Approved',
          totalClaimed: 8750,
          approvedAmount: 8750,
          submittedDate: '01 Jun 2026',
          approvedDate: '03 Jun 2026',
          approvedBy: 'Akash Patel',
          rejectionReason: '',
          onBehalfOfEmployeeId: '',
          onBehalfOfEmployeeName: '',
          lineItems: [
            ExpenseLineItem(id: 'li_1', category: 'Travel', description: 'Mumbai–Surat return train ticket', amount: 3200, date: '01 Jun 2026', billAttached: 'Train_Ticket.pdf', policyLimit: 5000),
            ExpenseLineItem(id: 'li_2', category: 'Hotel', description: 'One night stay — Taj Santacruz', amount: 3500, date: '01 Jun 2026', billAttached: 'Hotel_Invoice.pdf', policyLimit: 3000),
            ExpenseLineItem(id: 'li_3', category: 'Food', description: 'Team dinner with client', amount: 1200, date: '01 Jun 2026', billAttached: 'Restaurant_Bill.jpg', policyLimit: 500),
            ExpenseLineItem(id: 'li_4', category: 'Fuel', description: 'Cab from station to hotel', amount: 850, date: '01 Jun 2026', billAttached: 'Ola_Receipt.pdf', policyLimit: 5),
          ],
        ),
        ExpenseClaimModel(
          id: 'exp_abc_2',
          employeeId: 'emp_amit',
          employeeName: 'Amit Shah',
          title: 'Ahmedabad Client Demo — Tata Motors',
          status: 'Pending',
          totalClaimed: 4650,
          approvedAmount: 0,
          submittedDate: '04 Jun 2026',
          approvedDate: '',
          approvedBy: '',
          rejectionReason: '',
          onBehalfOfEmployeeId: '',
          onBehalfOfEmployeeName: '',
          lineItems: [
            ExpenseLineItem(id: 'li_5', category: 'Fuel', description: 'Bike fuel — 120 km at ₹5/km', amount: 600, date: '04 Jun 2026', billAttached: 'Fuel_Receipt.jpg', policyLimit: 5),
            ExpenseLineItem(id: 'li_6', category: 'Food', description: 'Lunch with Tata Motors team', amount: 850, date: '04 Jun 2026', billAttached: 'Lunch_Bill.jpg', policyLimit: 500),
            ExpenseLineItem(id: 'li_7', category: 'Client Meeting', description: 'Meeting hospitality expenses', amount: 1800, date: '04 Jun 2026', billAttached: 'Meeting_Bill.pdf', policyLimit: 2000),
            ExpenseLineItem(id: 'li_8', category: 'Mobile Recharge', description: 'Jio enterprise plan recharge', amount: 299, date: '01 Jun 2026', billAttached: 'Jio_Recharge.pdf', policyLimit: 299),
            ExpenseLineItem(id: 'li_9', category: 'Fuel', description: 'Return fuel + parking', amount: 1101, date: '04 Jun 2026', billAttached: 'Parking_Slip.jpg', policyLimit: 5),
          ],
        ),
        ExpenseClaimModel(
          id: 'exp_abc_3',
          employeeId: 'emp_riya',
          employeeName: 'Riya Sharma',
          title: 'Online Training — Flutter Advanced Course',
          status: 'Reimbursed',
          totalClaimed: 8999,
          approvedAmount: 8999,
          submittedDate: '25 May 2026',
          approvedDate: '27 May 2026',
          approvedBy: 'Mayur Sonowane',
          rejectionReason: '',
          onBehalfOfEmployeeId: '',
          onBehalfOfEmployeeName: '',
          lineItems: [
            ExpenseLineItem(id: 'li_10', category: 'Training', description: 'Udemy Flutter Masterclass — Annual License', amount: 8999, date: '25 May 2026', billAttached: 'Udemy_Invoice.pdf', policyLimit: 10000),
          ],
        ),
        ExpenseClaimModel(
          id: 'exp_abc_4',
          employeeId: 'emp_karan',
          employeeName: 'Karan Malhotra',
          title: 'Office Supplies — Stationery & Toners',
          status: 'Rejected',
          totalClaimed: 2300,
          approvedAmount: 0,
          submittedDate: '02 Jun 2026',
          approvedDate: '',
          approvedBy: '',
          rejectionReason: 'Amount exceeds policy limit. Please attach original vendor invoice and re-submit.',
          onBehalfOfEmployeeId: '',
          onBehalfOfEmployeeName: '',
          lineItems: [
            ExpenseLineItem(id: 'li_11', category: 'Office Supplies', description: 'A4 paper reams, pens, toners', amount: 2300, date: '02 Jun 2026', billAttached: '', policyLimit: 1000),
          ],
        ),
        ExpenseClaimModel(
          id: 'exp_abc_5',
          employeeId: 'emp_akash',
          employeeName: 'Akash Patel',
          title: 'Recruitment Drive — Campus Visit',
          status: 'Partially Approved',
          totalClaimed: 6200,
          approvedAmount: 4500,
          submittedDate: '28 May 2026',
          approvedDate: '30 May 2026',
          approvedBy: 'Mayur Sonowane',
          rejectionReason: 'Entertainment claim partially rejected — exceeds policy. ₹1,700 approved against ₹3,400 claimed.',
          onBehalfOfEmployeeId: '',
          onBehalfOfEmployeeName: '',
          lineItems: [
            ExpenseLineItem(id: 'li_12', category: 'Travel', description: 'Return flight Surat–Pune', amount: 2800, date: '28 May 2026', billAttached: 'Indigo_Ticket.pdf', policyLimit: 5000),
            ExpenseLineItem(id: 'li_13', category: 'Entertainment', description: 'Campus team welcome dinner', amount: 3400, date: '28 May 2026', billAttached: 'Hotel_Restaurant.jpg', policyLimit: 1500),
          ],
        ),
      ];

      _advanceRequests = [
        AdvanceRequestModel(
          id: 'adv_abc_1',
          employeeId: 'emp_amit',
          employeeName: 'Amit Shah',
          type: 'Business Trip',
          purpose: 'Pune client site visit for Q3 contract discussions',
          requestedAmount: 12000,
          disbursedAmount: 12000,
          actualExpense: 9800,
          settlementAmount: 2200,
          expectedDate: '10 Jun 2026',
          status: 'Settled',
          requestDate: '05 Jun 2026',
          settledDate: '12 Jun 2026',
        ),
        AdvanceRequestModel(
          id: 'adv_abc_2',
          employeeId: 'emp_riya',
          employeeName: 'Riya Sharma',
          type: 'Conference',
          purpose: 'Flutter Forward India 2026 — Bangalore',
          requestedAmount: 18000,
          disbursedAmount: 18000,
          actualExpense: 0,
          settlementAmount: 0,
          expectedDate: '20 Jun 2026',
          status: 'Approved',
          requestDate: '04 Jun 2026',
          settledDate: '',
        ),
      ];

      _reimbursements = [
        ExpenseReimbursementModel(
          id: 'reimb_abc_1',
          claimId: 'exp_abc_3',
          employeeName: 'Riya Sharma',
          claimTitle: 'Online Training — Flutter Advanced Course',
          amount: 8999,
          status: 'Paid',
          processedDate: '31 May 2026',
          paymentReferenceNo: 'NEFT-2026-0531-8821',
          bankAccount: 'HDFC ****9872',
        ),
        ExpenseReimbursementModel(
          id: 'reimb_abc_2',
          claimId: 'exp_abc_1',
          employeeName: 'Mayur Sonowane',
          claimTitle: 'Mumbai Client Visit — Q2 Strategy Meeting',
          amount: 8750,
          status: 'Processing',
          processedDate: '05 Jun 2026',
          paymentReferenceNo: '',
          bankAccount: 'HDFC ****4821',
        ),
      ];
    } else if (_currentCompany == 'XYZ Tech') {
      _expenseClaims = [
        ExpenseClaimModel(
          id: 'exp_xyz_1',
          employeeId: 'emp_xyz_3',
          employeeName: 'Vikas Dubey',
          title: 'Remote Work Setup — Home Internet',
          status: 'Approved',
          totalClaimed: 999,
          approvedAmount: 999,
          submittedDate: '01 Jun 2026',
          approvedDate: '02 Jun 2026',
          approvedBy: 'Shreya Iyer',
          rejectionReason: '',
          onBehalfOfEmployeeId: '',
          onBehalfOfEmployeeName: '',
          lineItems: [
            ExpenseLineItem(id: 'li_xyz_1', category: 'Internet', description: 'Jio Fiber 100Mbps May 2026', amount: 999, date: '01 Jun 2026', billAttached: 'Jio_Fiber_Bill.pdf', policyLimit: 999),
          ],
        ),
      ];
      _reimbursements = [];
    } else if (_currentCompany == 'SalesPro') {
      _expenseClaims = [
        ExpenseClaimModel(
          id: 'exp_sp_1',
          employeeId: 'emp_sp_3',
          employeeName: 'Deepak Punia',
          title: 'Bandra Client Route — May Week 4',
          status: 'Pending',
          totalClaimed: 2250,
          approvedAmount: 0,
          submittedDate: '03 Jun 2026',
          approvedDate: '',
          approvedBy: '',
          rejectionReason: '',
          onBehalfOfEmployeeId: '',
          onBehalfOfEmployeeName: '',
          lineItems: [
            ExpenseLineItem(id: 'li_sp_1', category: 'Fuel', description: '90 km travel at ₹5/km', amount: 450, date: '03 Jun 2026', billAttached: 'Fuel_Bill.jpg', policyLimit: 5),
            ExpenseLineItem(id: 'li_sp_2', category: 'Food', description: 'Field lunch', amount: 380, date: '03 Jun 2026', billAttached: 'Lunch.jpg', policyLimit: 500),
            ExpenseLineItem(id: 'li_sp_3', category: 'Client Meeting', description: 'Retail Shop A tea + refreshments', amount: 320, date: '03 Jun 2026', billAttached: 'Bill.jpg', policyLimit: 2000),
            ExpenseLineItem(id: 'li_sp_4', category: 'Other', description: 'Parking charge at Bandra', amount: 100, date: '03 Jun 2026', billAttached: '', policyLimit: 500),
            ExpenseLineItem(id: 'li_sp_5', category: 'Mobile Recharge', description: 'Jio top-up for field calls', amount: 1000, date: '01 Jun 2026', billAttached: 'Jio.pdf', policyLimit: 299),
          ],
        ),
      ];
      _reimbursements = [];
    }
  }

  String _nowDate() {
    final now = DateTime.now();
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${now.day.toString().padLeft(2,'0')} ${months[now.month-1]} ${now.year}';
  }

  // Create a new expense claim (Draft)
  void createExpenseClaim({
    required String title,
    required List<ExpenseLineItem> lineItems,
    String onBehalfOfId = '',
    String onBehalfOfName = '',
  }) {
    final newId = 'exp_${DateTime.now().millisecondsSinceEpoch}';
    final total = lineItems.fold<double>(0, (sum, item) => sum + item.amount);
    final empId = onBehalfOfId.isNotEmpty ? onBehalfOfId : activeEmployeeId;
    final empName = onBehalfOfName.isNotEmpty ? onBehalfOfName : activeEmployee.name;

    final claim = ExpenseClaimModel(
      id: newId,
      employeeId: empId,
      employeeName: empName,
      title: title,
      status: 'Pending',
      totalClaimed: total,
      approvedAmount: 0,
      submittedDate: _nowDate(),
      approvedDate: '',
      approvedBy: '',
      rejectionReason: '',
      onBehalfOfEmployeeId: onBehalfOfId,
      onBehalfOfEmployeeName: onBehalfOfName,
      lineItems: lineItems,
    );

    _expenseClaims.insert(0, claim);
    logAudit(activeEmployee.name, empName, 'Expense Claim Submitted',
        'Submitted expense claim "$title" for ₹${total.toStringAsFixed(0)}. Items: ${lineItems.length}.');
    notifyListeners();
  }

  // Approve expense claim fully
  void approveExpenseClaim(String claimId) {
    final idx = _expenseClaims.indexWhere((c) => c.id == claimId);
    if (idx != -1) {
      final old = _expenseClaims[idx];
      _expenseClaims[idx] = old.copyWith(
        status: 'Approved',
        approvedAmount: old.totalClaimed,
        approvedDate: _nowDate(),
        approvedBy: activeEmployee.name,
      );
      logAudit(activeEmployee.name, old.employeeName, 'Expense Approved',
          'Fully approved claim "${old.title}" for ₹${old.totalClaimed.toStringAsFixed(0)}.');
      notifyListeners();
    }
  }

  // Partial approval
  void partiallyApproveExpenseClaim(String claimId, double approvedAmount, String remarks) {
    final idx = _expenseClaims.indexWhere((c) => c.id == claimId);
    if (idx != -1) {
      final old = _expenseClaims[idx];
      _expenseClaims[idx] = old.copyWith(
        status: 'Partially Approved',
        approvedAmount: approvedAmount,
        approvedDate: _nowDate(),
        approvedBy: activeEmployee.name,
        rejectionReason: remarks,
      );
      logAudit(activeEmployee.name, old.employeeName, 'Expense Partially Approved',
          'Partially approved "${old.title}". Approved: ₹$approvedAmount / Claimed: ₹${old.totalClaimed}. Remarks: $remarks.');
      notifyListeners();
    }
  }

  // Reject expense claim
  void rejectExpenseClaim(String claimId, String reason) {
    final idx = _expenseClaims.indexWhere((c) => c.id == claimId);
    if (idx != -1) {
      final old = _expenseClaims[idx];
      _expenseClaims[idx] = old.copyWith(
        status: 'Rejected',
        approvedAmount: 0,
        approvedDate: _nowDate(),
        approvedBy: activeEmployee.name,
        rejectionReason: reason,
      );
      logAudit(activeEmployee.name, old.employeeName, 'Expense Rejected',
          'Rejected claim "${old.title}". Reason: $reason.');
      notifyListeners();
    }
  }

  // Finance: Process reimbursement
  void processReimbursement(String claimId, String paymentRef) {
    final claimIdx = _expenseClaims.indexWhere((c) => c.id == claimId);
    if (claimIdx != -1) {
      final claim = _expenseClaims[claimIdx];
      _expenseClaims[claimIdx] = claim.copyWith(status: 'Reimbursed');

      final reimb = ExpenseReimbursementModel(
        id: 'reimb_${DateTime.now().millisecondsSinceEpoch}',
        claimId: claimId,
        employeeName: claim.employeeName,
        claimTitle: claim.title,
        amount: claim.approvedAmount,
        status: 'Paid',
        processedDate: _nowDate(),
        paymentReferenceNo: paymentRef,
        bankAccount: 'HDFC ****0000',
      );
      _reimbursements.insert(0, reimb);
      logAudit(activeEmployee.name, claim.employeeName, 'Reimbursement Processed',
          'Processed payment ₹${claim.approvedAmount} for "${claim.title}". Ref: $paymentRef.');
      notifyListeners();
    }
  }

  // Create advance request
  void createAdvanceRequest({
    required String type,
    required String purpose,
    required double amount,
    required String expectedDate,
  }) {
    final newId = 'adv_${DateTime.now().millisecondsSinceEpoch}';
    final req = AdvanceRequestModel(
      id: newId,
      employeeId: activeEmployeeId,
      employeeName: activeEmployee.name,
      type: type,
      purpose: purpose,
      requestedAmount: amount,
      disbursedAmount: 0,
      actualExpense: 0,
      settlementAmount: 0,
      expectedDate: expectedDate,
      status: 'Pending',
      requestDate: _nowDate(),
      settledDate: '',
    );
    _advanceRequests.insert(0, req);
    logAudit(activeEmployee.name, 'Finance Dept', 'Advance Requested',
        'Advance request of ₹$amount for "$type — $purpose". Expected by $expectedDate.');
    notifyListeners();
  }

  // Finance: Approve advance
  void approveAdvance(String advanceId) {
    final idx = _advanceRequests.indexWhere((a) => a.id == advanceId);
    if (idx != -1) {
      final old = _advanceRequests[idx];
      _advanceRequests[idx] = old.copyWith(status: 'Approved', disbursedAmount: old.requestedAmount);
      logAudit(activeEmployee.name, old.employeeName, 'Advance Approved',
          'Approved advance of ₹${old.requestedAmount} for "${old.type} — ${old.purpose}".');
      notifyListeners();
    }
  }

  // Finance: Reject advance
  void rejectAdvance(String advanceId, String reason) {
    final idx = _advanceRequests.indexWhere((a) => a.id == advanceId);
    if (idx != -1) {
      final old = _advanceRequests[idx];
      _advanceRequests[idx] = old.copyWith(status: 'Rejected');
      logAudit(activeEmployee.name, old.employeeName, 'Advance Rejected',
          'Rejected advance for "${old.type}". Reason: $reason.');
      notifyListeners();
    }
  }

  // Employee: Settle advance
  void settleAdvance(String advanceId, double actualExpense) {
    final idx = _advanceRequests.indexWhere((a) => a.id == advanceId);
    if (idx != -1) {
      final old = _advanceRequests[idx];
      final settlement = old.disbursedAmount - actualExpense;
      _advanceRequests[idx] = old.copyWith(
        status: 'Settled',
        actualExpense: actualExpense,
        settlementAmount: settlement > 0 ? settlement : 0,
        settledDate: _nowDate(),
      );
      logAudit(activeEmployee.name, old.employeeName, 'Advance Settled',
          'Settled advance. Disbursed: ₹${old.disbursedAmount}, Actual: ₹$actualExpense, Return: ₹${settlement > 0 ? settlement : 0}.');
      notifyListeners();
    }
  }

  // ==========================================
  // UNIFIED APPROVAL REQUESTS — SEED & STATE
  // ==========================================

  void _seedApprovalRequests() {
    if (_currentCompany == 'ABC Pvt Ltd') {
      _approvalRequests = [
        UnifiedApprovalRequest(
          id: 'apr_abc_1',
          requestNo: 'LEV-2026-00101',
          type: 'Leave',
          category: 'HR & Leaves',
          priority: 'High',
          employeeId: 'emp_akash',
          employeeName: 'Akash Patel',
          department: 'Marketing',
          requestDate: '04 Jun 2026',
          status: 'Pending',
          currentLevel: 1,
          typeSpecificData: {
            'Leave Type': 'Casual Leave',
            'From Date': '15 Jun 2026',
            'To Date': '17 Jun 2026',
            'Total Days': '3 Days',
            'Reason': 'Family emergency travel — parents visiting from outstation.',
            'Applied Date': '04 Jun 2026',
          },
          workflowLevels: [
            WorkflowLevelModel(level: 1, roleTitle: 'Manager', approverName: 'Mayur Sonowane', approverEmpId: 'emp_mayur', decision: 'Pending', comment: '', decidedAt: ''),
            WorkflowLevelModel(level: 2, roleTitle: 'HR', approverName: 'Akash Patel', approverEmpId: 'emp_akash', decision: 'Waiting', comment: '', decidedAt: ''),
            WorkflowLevelModel(level: 3, roleTitle: 'Director', approverName: 'Mayur Sonowane', approverEmpId: 'emp_mayur', decision: 'Waiting', comment: '', decidedAt: ''),
          ],
          attachments: [
            ApprovalAttachment(filename: 'Medical_Certificate.pdf', type: 'PDF', sizeKb: 342),
            ApprovalAttachment(filename: 'Travel_Booking.jpg', type: 'JPG', sizeKb: 128),
          ],
          history: [
            RequestHistoryEvent(eventType: 'Created', actor: 'Akash Patel', note: 'Leave application submitted.', timestamp: '04 Jun 2026 09:30 AM'),
            RequestHistoryEvent(eventType: 'Attachment Added', actor: 'Akash Patel', note: 'Medical_Certificate.pdf uploaded.', timestamp: '04 Jun 2026 09:35 AM'),
          ],
        ),
        UnifiedApprovalRequest(
          id: 'apr_abc_2',
          requestNo: 'REC-2026-00045',
          type: 'Recruitment',
          category: 'HR & Leaves',
          priority: 'Medium',
          employeeId: 'emp_riya',
          employeeName: 'Riya Sharma',
          department: 'Engineering',
          requestDate: '05 Jun 2026',
          status: 'Pending',
          currentLevel: 1,
          typeSpecificData: {
            'Position': 'Senior Flutter Developer',
            'Department': 'Product & Engineering',
            'Budget': '₹18,00,000 LPA',
            'Openings': '2',
            'Justification': 'Critical requirement for Q3 product roadmap delivery. Two senior resources needed to meet deadlines.',
          },
          workflowLevels: [
            WorkflowLevelModel(level: 1, roleTitle: 'HR Manager', approverName: 'Mayur Sonowane', approverEmpId: 'emp_mayur', decision: 'Approved', comment: 'Requirement validated. Budget approved by management.', decidedAt: '05 Jun 2026 11:00 AM'),
            WorkflowLevelModel(level: 2, roleTitle: 'Director', approverName: 'Mayur Sonowane', approverEmpId: 'emp_mayur', decision: 'Pending', comment: '', decidedAt: ''),
          ],
          attachments: [
            ApprovalAttachment(filename: 'JD_Flutter_Developer.pdf', type: 'PDF', sizeKb: 215),
            ApprovalAttachment(filename: 'Budget_Approval.docx', type: 'DOCX', sizeKb: 98),
          ],
          history: [
            RequestHistoryEvent(eventType: 'Created', actor: 'Riya Sharma', note: 'Recruitment request raised.', timestamp: '05 Jun 2026 09:00 AM'),
            RequestHistoryEvent(eventType: 'Approved', actor: 'Mayur Sonowane', note: 'HR Manager approved. Forwarded to Director.', timestamp: '05 Jun 2026 11:00 AM'),
          ],
        ),
        UnifiedApprovalRequest(
          id: 'apr_abc_3',
          requestNo: 'EXP-2026-00125',
          type: 'Expense',
          category: 'Finance & Expenses',
          priority: 'Low',
          employeeId: 'emp_amit',
          employeeName: 'Amit Shah',
          department: 'Sales',
          requestDate: '04 Jun 2026',
          status: 'Pending',
          currentLevel: 0,
          typeSpecificData: {
            'Expense Category': 'Travel + Client Meeting',
            'Amount': '₹12,500',
            'Expense Date': '03 Jun 2026',
            'Reason': 'Client travel to Ahmedabad — Tata Motors Q3 contract demo.',
          },
          workflowLevels: [
            WorkflowLevelModel(level: 1, roleTitle: 'Manager', approverName: 'Mayur Sonowane', approverEmpId: 'emp_mayur', decision: 'Pending', comment: '', decidedAt: ''),
          ],
          attachments: [
            ApprovalAttachment(filename: 'Tata_Motors_Invoice.pdf', type: 'PDF', sizeKb: 512),
            ApprovalAttachment(filename: 'Travel_Receipt.jpg', type: 'JPG', sizeKb: 200),
            ApprovalAttachment(filename: 'Hotel_Bill.jpg', type: 'JPG', sizeKb: 175),
          ],
          history: [
            RequestHistoryEvent(eventType: 'Created', actor: 'Amit Shah', note: 'Expense claim submitted.', timestamp: '04 Jun 2026 08:45 AM'),
            RequestHistoryEvent(eventType: 'Attachment Added', actor: 'Amit Shah', note: 'Bills and invoices attached.', timestamp: '04 Jun 2026 08:50 AM'),
          ],
        ),
        UnifiedApprovalRequest(
          id: 'apr_abc_4',
          requestNo: 'AST-2026-00033',
          type: 'Asset Request',
          category: 'Operations & Assets',
          priority: 'Medium',
          employeeId: 'emp_riya',
          employeeName: 'Riya Sharma',
          department: 'Engineering',
          requestDate: '03 Jun 2026',
          status: 'Pending',
          currentLevel: 1,
          typeSpecificData: {
            'Asset Type': 'Laptop',
            'Specification': 'MacBook Pro 16" M3 Max 32GB RAM 1TB SSD',
            'Priority': 'High',
            'Reason': 'Current laptop is 4 years old and performance is inadequate for Flutter development and testing.',
            'Expected Delivery': '15 Jun 2026',
          },
          workflowLevels: [
            WorkflowLevelModel(level: 1, roleTitle: 'Manager', approverName: 'Mayur Sonowane', approverEmpId: 'emp_mayur', decision: 'Approved', comment: 'Critical hardware. Approved for procurement.', decidedAt: '03 Jun 2026 02:00 PM'),
            WorkflowLevelModel(level: 2, roleTitle: 'IT Admin', approverName: 'Karan Malhotra', approverEmpId: 'emp_karan', decision: 'Pending', comment: '', decidedAt: ''),
          ],
          attachments: [
            ApprovalAttachment(filename: 'MacBook_Quote.pdf', type: 'PDF', sizeKb: 280),
          ],
          history: [
            RequestHistoryEvent(eventType: 'Created', actor: 'Riya Sharma', note: 'Asset request submitted.', timestamp: '03 Jun 2026 10:00 AM'),
            RequestHistoryEvent(eventType: 'Approved', actor: 'Mayur Sonowane', note: 'Manager approved.', timestamp: '03 Jun 2026 02:00 PM'),
          ],
        ),
        UnifiedApprovalRequest(
          id: 'apr_abc_5',
          requestNo: 'TRV-2026-00078',
          type: 'Travel',
          category: 'Finance & Expenses',
          priority: 'High',
          employeeId: 'emp_amit',
          employeeName: 'Amit Shah',
          department: 'Sales',
          requestDate: '04 Jun 2026',
          status: 'Pending',
          currentLevel: 2,
          typeSpecificData: {
            'Destination': 'Singapore',
            'Purpose': 'Business Development — Asia Pacific expansion meetings',
            'Duration': '5 Days',
            'Dates': '15 Jun – 20 Jun 2026',
            'Estimated Budget': '₹1,80,000',
          },
          workflowLevels: [
            WorkflowLevelModel(level: 1, roleTitle: 'Manager', approverName: 'Mayur Sonowane', approverEmpId: 'emp_mayur', decision: 'Approved', comment: 'Strategic trip. Approved.', decidedAt: '04 Jun 2026 10:30 AM'),
            WorkflowLevelModel(level: 2, roleTitle: 'Finance', approverName: 'Akash Patel', approverEmpId: 'emp_akash', decision: 'Approved', comment: 'Budget available in Q2.', decidedAt: '04 Jun 2026 03:00 PM'),
            WorkflowLevelModel(level: 3, roleTitle: 'Director', approverName: 'Mayur Sonowane', approverEmpId: 'emp_mayur', decision: 'Pending', comment: '', decidedAt: ''),
          ],
          attachments: [
            ApprovalAttachment(filename: 'Singapore_Itinerary.pdf', type: 'PDF', sizeKb: 620),
            ApprovalAttachment(filename: 'Visa_Application.pdf', type: 'PDF', sizeKb: 310),
          ],
          history: [
            RequestHistoryEvent(eventType: 'Created', actor: 'Amit Shah', note: 'Travel request submitted.', timestamp: '04 Jun 2026 08:00 AM'),
            RequestHistoryEvent(eventType: 'Approved', actor: 'Mayur Sonowane', note: 'Manager approved.', timestamp: '04 Jun 2026 10:30 AM'),
            RequestHistoryEvent(eventType: 'Approved', actor: 'Akash Patel', note: 'Finance approved.', timestamp: '04 Jun 2026 03:00 PM'),
          ],
        ),
        UnifiedApprovalRequest(
          id: 'apr_abc_6',
          requestNo: 'ATT-2026-00209',
          type: 'Attendance Correction',
          category: 'Operations & Assets',
          priority: 'Low',
          employeeId: 'emp_karan',
          employeeName: 'Karan Malhotra',
          department: 'Operations',
          requestDate: '02 Jun 2026',
          status: 'Approved',
          currentLevel: -1,
          typeSpecificData: {
            'Date': '01 Jun 2026',
            'Punch In': '09:15 AM',
            'Punch Out': '06:30 PM',
            'Reason': 'Internet connectivity issue caused geo-fence mismatch during punch-in.',
          },
          workflowLevels: [
            WorkflowLevelModel(level: 1, roleTitle: 'Manager', approverName: 'Mayur Sonowane', approverEmpId: 'emp_mayur', decision: 'Approved', comment: 'Technical issue confirmed. Attendance corrected.', decidedAt: '02 Jun 2026 11:00 AM'),
          ],
          attachments: [],
          history: [
            RequestHistoryEvent(eventType: 'Created', actor: 'Karan Malhotra', note: 'Attendance correction requested.', timestamp: '02 Jun 2026 09:30 AM'),
            RequestHistoryEvent(eventType: 'Approved', actor: 'Mayur Sonowane', note: 'Approved and corrected in system.', timestamp: '02 Jun 2026 11:00 AM'),
          ],
        ),
        UnifiedApprovalRequest(
          id: 'apr_abc_7',
          requestNo: 'BDG-2026-00015',
          type: 'Budget',
          category: 'Finance & Expenses',
          priority: 'High',
          employeeId: 'emp_akash',
          employeeName: 'Akash Patel',
          department: 'Marketing',
          requestDate: '05 Jun 2026',
          status: 'Rejected',
          currentLevel: -1,
          typeSpecificData: {
            'Budget Title': 'Q3 Marketing Campaign',
            'Amount': '₹5,50,000',
            'Quarter': 'Q3 2026',
            'Justification': 'Digital + offline campaign for product launch. Includes influencer collaborations.',
          },
          workflowLevels: [
            WorkflowLevelModel(level: 1, roleTitle: 'Manager', approverName: 'Mayur Sonowane', approverEmpId: 'emp_mayur', decision: 'Approved', comment: 'Campaign plan looks solid.', decidedAt: '05 Jun 2026 10:00 AM'),
            WorkflowLevelModel(level: 2, roleTitle: 'Finance', approverName: 'Akash Patel', approverEmpId: 'emp_akash', decision: 'Rejected', comment: 'Q3 budget allocation already committed. Resubmit for Q4.', decidedAt: '05 Jun 2026 04:00 PM'),
          ],
          attachments: [
            ApprovalAttachment(filename: 'Q3_Campaign_Plan.pdf', type: 'PDF', sizeKb: 850),
            ApprovalAttachment(filename: 'Budget_Breakdown.xlsx', type: 'DOCX', sizeKb: 120),
          ],
          history: [
            RequestHistoryEvent(eventType: 'Created', actor: 'Akash Patel', note: 'Budget approval request raised.', timestamp: '05 Jun 2026 09:00 AM'),
            RequestHistoryEvent(eventType: 'Approved', actor: 'Mayur Sonowane', note: 'Manager approved.', timestamp: '05 Jun 2026 10:00 AM'),
            RequestHistoryEvent(eventType: 'Rejected', actor: 'Akash Patel', note: 'Finance rejected — budget exhausted.', timestamp: '05 Jun 2026 04:00 PM'),
          ],
        ),
      ];
    } else if (_currentCompany == 'XYZ Tech') {
      _approvalRequests = [
        UnifiedApprovalRequest(
          id: 'apr_xyz_1',
          requestNo: 'LEV-2026-00201',
          type: 'Leave',
          category: 'HR & Leaves',
          priority: 'Medium',
          employeeId: 'emp_xyz_2',
          employeeName: 'Deepa Nair',
          department: 'Design',
          requestDate: '03 Jun 2026',
          status: 'Pending',
          currentLevel: 0,
          typeSpecificData: {
            'Leave Type': 'Sick Leave',
            'From Date': '08 Jun 2026',
            'To Date': '09 Jun 2026',
            'Total Days': '2 Days',
            'Reason': 'Fever and flu — doctor prescribed rest.',
          },
          workflowLevels: [
            WorkflowLevelModel(level: 1, roleTitle: 'Manager', approverName: 'Shreya Iyer', approverEmpId: 'emp_xyz_1', decision: 'Pending', comment: '', decidedAt: ''),
          ],
          attachments: [
            ApprovalAttachment(filename: 'Doctor_Certificate.jpg', type: 'JPG', sizeKb: 95),
          ],
          history: [
            RequestHistoryEvent(eventType: 'Created', actor: 'Deepa Nair', note: 'Sick leave request submitted.', timestamp: '03 Jun 2026 10:00 AM'),
          ],
        ),
      ];
    } else {
      _approvalRequests = [
        UnifiedApprovalRequest(
          id: 'apr_sp_1',
          requestNo: 'TRV-2026-00311',
          type: 'Travel',
          category: 'Finance & Expenses',
          priority: 'Medium',
          employeeId: 'emp_sp_2',
          employeeName: 'Neha Gupta',
          department: 'Sales',
          requestDate: '02 Jun 2026',
          status: 'Pending',
          currentLevel: 0,
          typeSpecificData: {
            'Destination': 'Pune',
            'Purpose': 'Client visit — Retail chain account expansion',
            'Duration': '2 Days',
            'Dates': '10 Jun – 11 Jun 2026',
            'Estimated Budget': '₹8,500',
          },
          workflowLevels: [
            WorkflowLevelModel(level: 1, roleTitle: 'Manager', approverName: 'Priya Mehta', approverEmpId: 'emp_sp_1', decision: 'Pending', comment: '', decidedAt: ''),
            WorkflowLevelModel(level: 2, roleTitle: 'Finance', approverName: 'Priya Mehta', approverEmpId: 'emp_sp_1', decision: 'Waiting', comment: '', decidedAt: ''),
          ],
          attachments: [],
          history: [
            RequestHistoryEvent(eventType: 'Created', actor: 'Neha Gupta', note: 'Travel request submitted.', timestamp: '02 Jun 2026 09:00 AM'),
          ],
        ),
      ];
    }
  }

  // Approve a request at current level
  void approveUnifiedRequest(String requestId, String comment) {
    final idx = _approvalRequests.indexWhere((r) => r.id == requestId);
    if (idx == -1) return;
    final req = _approvalRequests[idx];
    final levelIdx = req.workflowLevels.indexWhere((l) => l.level == req.currentLevel + 1);
    if (levelIdx == -1) return;

    final updatedLevel = req.workflowLevels[levelIdx].copyWith(decision: 'Approved', comment: comment, decidedAt: _nowDateTime());
    final updatedLevels = List<WorkflowLevelModel>.from(req.workflowLevels)..[levelIdx] = updatedLevel;

    final nextPending = updatedLevels.where((l) => l.decision == 'Pending' || l.decision == 'Waiting').toList();
    if (nextPending.isNotEmpty) {
      final nextIdx = updatedLevels.indexOf(nextPending.first);
      updatedLevels[nextIdx] = nextPending.first.copyWith(decision: 'Pending');
    }

    final newStatus = nextPending.length <= 1 ? 'Approved' : 'Pending';
    final newCurrentLevel = nextPending.length <= 1 ? -1 : req.currentLevel + 1;

    final updatedHistory = List<RequestHistoryEvent>.from(req.history)
      ..add(RequestHistoryEvent(eventType: 'Approved', actor: activeEmployee.name, note: comment.isNotEmpty ? comment : 'Approved.', timestamp: _nowDateTime()));

    _approvalRequests[idx] = req.copyWith(status: newStatus, currentLevel: newCurrentLevel, workflowLevels: updatedLevels, history: updatedHistory);
    logAudit(activeEmployee.name, req.employeeName, 'Request Approved', 'Approved ${req.type} request ${req.requestNo}. Comment: $comment');
    notifyListeners();
  }

  // Reject a request
  void rejectUnifiedRequest(String requestId, String reason) {
    final idx = _approvalRequests.indexWhere((r) => r.id == requestId);
    if (idx == -1) return;
    final req = _approvalRequests[idx];
    final levelIdx = req.workflowLevels.indexWhere((l) => l.decision == 'Pending');
    if (levelIdx == -1) return;

    final updatedLevel = req.workflowLevels[levelIdx].copyWith(decision: 'Rejected', comment: reason, decidedAt: _nowDateTime());
    final updatedLevels = List<WorkflowLevelModel>.from(req.workflowLevels)..[levelIdx] = updatedLevel;

    final updatedHistory = List<RequestHistoryEvent>.from(req.history)
      ..add(RequestHistoryEvent(eventType: 'Rejected', actor: activeEmployee.name, note: reason, timestamp: _nowDateTime()));

    _approvalRequests[idx] = req.copyWith(status: 'Rejected', currentLevel: -1, workflowLevels: updatedLevels, history: updatedHistory);
    logAudit(activeEmployee.name, req.employeeName, 'Request Rejected', 'Rejected ${req.type} request ${req.requestNo}. Reason: $reason');
    notifyListeners();
  }

  // Send back for correction
  void sendBackRequest(String requestId, String note) {
    final idx = _approvalRequests.indexWhere((r) => r.id == requestId);
    if (idx == -1) return;
    final req = _approvalRequests[idx];

    final updatedHistory = List<RequestHistoryEvent>.from(req.history)
      ..add(RequestHistoryEvent(eventType: 'Sent Back', actor: activeEmployee.name, note: note, timestamp: _nowDateTime()));

    _approvalRequests[idx] = req.copyWith(status: 'Sent Back', history: updatedHistory);
    logAudit(activeEmployee.name, req.employeeName, 'Request Sent Back', 'Sent back ${req.type} request ${req.requestNo}. Note: $note');
    notifyListeners();
  }

  // Request more information
  void requestMoreInfoOnRequest(String requestId, String question) {
    final idx = _approvalRequests.indexWhere((r) => r.id == requestId);
    if (idx == -1) return;
    final req = _approvalRequests[idx];

    final updatedHistory = List<RequestHistoryEvent>.from(req.history)
      ..add(RequestHistoryEvent(eventType: 'Info Requested', actor: activeEmployee.name, note: question, timestamp: _nowDateTime()));

    _approvalRequests[idx] = req.copyWith(status: 'Info Requested', history: updatedHistory);
    logAudit(activeEmployee.name, req.employeeName, 'More Info Requested', 'Requested info on ${req.type} ${req.requestNo}. Q: $question');
    notifyListeners();
  }

  // Escalate request
  void escalateRequest(String requestId, String note) {
    final idx = _approvalRequests.indexWhere((r) => r.id == requestId);
    if (idx == -1) return;
    final req = _approvalRequests[idx];

    final updatedHistory = List<RequestHistoryEvent>.from(req.history)
      ..add(RequestHistoryEvent(eventType: 'Escalated', actor: activeEmployee.name, note: note, timestamp: _nowDateTime()));

    _approvalRequests[idx] = req.copyWith(status: 'Escalated', history: updatedHistory);
    logAudit(activeEmployee.name, req.employeeName, 'Request Escalated', 'Escalated ${req.type} ${req.requestNo}. Note: $note');
    notifyListeners();
  }

  String _nowDateTime() {
    final now = DateTime.now();
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final h = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    final m = now.minute.toString().padLeft(2, '0');
    return '${now.day.toString().padLeft(2,'0')} ${months[now.month-1]} ${now.year} $h:$m $ampm';
  }
}



// ==========================================
// PROFILE MODULE DATA MODELS
// ==========================================

class AddressDetails {
  String currentLine1;
  String currentLine2;
  String currentCity;
  String currentState;
  String currentCountry;
  String currentPincode;
  String permanentLine1;
  String permanentLine2;
  String permanentCity;
  String permanentState;
  String permanentCountry;
  String permanentPincode;
  bool isPermanentSameAsCurrent;

  AddressDetails({
    required this.currentLine1,
    required this.currentLine2,
    required this.currentCity,
    required this.currentState,
    required this.currentCountry,
    required this.currentPincode,
    required this.permanentLine1,
    required this.permanentLine2,
    required this.permanentCity,
    required this.permanentState,
    required this.permanentCountry,
    required this.permanentPincode,
    required this.isPermanentSameAsCurrent,
  });

  AddressDetails copyWith({
    String? currentLine1,
    String? currentLine2,
    String? currentCity,
    String? currentState,
    String? currentCountry,
    String? currentPincode,
    String? permanentLine1,
    String? permanentLine2,
    String? permanentCity,
    String? permanentState,
    String? permanentCountry,
    String? permanentPincode,
    bool? isPermanentSameAsCurrent,
  }) {
    return AddressDetails(
      currentLine1: currentLine1 ?? this.currentLine1,
      currentLine2: currentLine2 ?? this.currentLine2,
      currentCity: currentCity ?? this.currentCity,
      currentState: currentState ?? this.currentState,
      currentCountry: currentCountry ?? this.currentCountry,
      currentPincode: currentPincode ?? this.currentPincode,
      permanentLine1: permanentLine1 ?? this.permanentLine1,
      permanentLine2: permanentLine2 ?? this.permanentLine2,
      permanentCity: permanentCity ?? this.permanentCity,
      permanentState: permanentState ?? this.permanentState,
      permanentCountry: permanentCountry ?? this.permanentCountry,
      permanentPincode: permanentPincode ?? this.permanentPincode,
      isPermanentSameAsCurrent: isPermanentSameAsCurrent ?? this.isPermanentSameAsCurrent,
    );
  }
}

class EducationRecord {
  String qualification;
  String course;
  String specialization;
  String university;
  String institute;
  String board;
  String passingYear;
  String percentage;
  String grade;
  String cgpa;
  String attachedDoc;

  EducationRecord({
    required this.qualification,
    required this.course,
    required this.specialization,
    required this.university,
    required this.institute,
    required this.board,
    required this.passingYear,
    required this.percentage,
    required this.grade,
    required this.cgpa,
    required this.attachedDoc,
  });
}

class ExperienceRecord {
  String companyName;
  String designation;
  String department;
  String industry;
  String joiningDate;
  String relievingDate;
  String totalExperience;
  String currentSalary;
  String reasonForLeaving;
  String attachedDoc;

  ExperienceRecord({
    required this.companyName,
    required this.designation,
    required this.department,
    required this.industry,
    required this.joiningDate,
    required this.relievingDate,
    required this.totalExperience,
    required this.currentSalary,
    required this.reasonForLeaving,
    required this.attachedDoc,
  });
}

class FamilyMember {
  String name;
  String relation;
  String dob;
  String occupation;

  FamilyMember({
    required this.name,
    required this.relation,
    required this.dob,
    required this.occupation,
  });
}

class EmergencyContact {
  String name;
  String relation;
  String mobileNumber;
  String alternateNumber;
  String address;

  EmergencyContact({
    required this.name,
    required this.relation,
    required this.mobileNumber,
    required this.alternateNumber,
    required this.address,
  });
}

class BankDetails {
  String bankName;
  String accountHolderName;
  String accountNumber;
  String ifscCode;
  String branchName;
  String upiId;

  BankDetails({
    required this.bankName,
    required this.accountHolderName,
    required this.accountNumber,
    required this.ifscCode,
    required this.branchName,
    required this.upiId,
  });

  BankDetails copyWith({
    String? bankName,
    String? accountHolderName,
    String? accountNumber,
    String? ifscCode,
    String? branchName,
    String? upiId,
  }) {
    return BankDetails(
      bankName: bankName ?? this.bankName,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      accountNumber: accountNumber ?? this.accountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      branchName: branchName ?? this.branchName,
      upiId: upiId ?? this.upiId,
    );
  }
}

class AssignedAsset {
  String assetName;
  String serialNumber;
  String issueDate;
  String returnDate;

  AssignedAsset({
    required this.assetName,
    required this.serialNumber,
    required this.issueDate,
    required this.returnDate,
  });
}

class AttendanceSummary {
  int presentDays;
  int absentDays;
  int leaveDays;
  int lateDays;
  double otHours;
  double currentMonthHours;

  AttendanceSummary({
    required this.presentDays,
    required this.absentDays,
    required this.leaveDays,
    required this.lateDays,
    required this.otHours,
    required this.currentMonthHours,
  });
}

class LeaveSummary {
  int availableLeave;
  int usedLeave;
  int pendingRequests;
  int approvedRequests;

  LeaveSummary({
    required this.availableLeave,
    required this.usedLeave,
    required this.pendingRequests,
    required this.approvedRequests,
  });
}

class PayrollSummary {
  String currentSalary;
  String ctc;
  String lastPayslip;
  String taxDetails;

  PayrollSummary({
    required this.currentSalary,
    required this.ctc,
    required this.lastPayslip,
    required this.taxDetails,
  });
}

class ProfileDocument {
  String id;
  String category;
  String name;
  String uploadedBy;
  String uploadedAt;
  String filePath;

  ProfileDocument({
    required this.id,
    required this.category,
    required this.name,
    required this.uploadedBy,
    required this.uploadedAt,
    required this.filePath,
  });
}

class ProfileSettings {
  bool changePassword;
  bool changePin;
  bool enableBiometric;
  bool enableFaceLogin;
  bool attendanceNotifications;
  bool approvalNotifications;
  bool leaveNotifications;
  bool payrollNotifications;
  String profileVisibility;
  String contactVisibility;
  String documentVisibility;

  ProfileSettings({
    required this.changePassword,
    required this.changePin,
    required this.enableBiometric,
    required this.enableFaceLogin,
    required this.attendanceNotifications,
    required this.approvalNotifications,
    required this.leaveNotifications,
    required this.payrollNotifications,
    required this.profileVisibility,
    required this.contactVisibility,
    required this.documentVisibility,
  });
}

class TimelineActivity {
  String title;
  String description;
  String timestamp;
  String category;

  TimelineActivity({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.category,
  });
}

class ProfileChangeRequest {
  final String id;
  final String employeeId;
  final String employeeName;
  final String category;
  final String fieldName;
  final String oldValue;
  final String newValue;
  final String status;
  final String date;

  ProfileChangeRequest({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.category,
    required this.fieldName,
    required this.oldValue,
    required this.newValue,
    required this.status,
    required this.date,
  });
}

class EmployeeProfileModel {
  final String employeeId;
  final String photoUrl;
  final String firstName;
  final String middleName;
  final String lastName;
  final String gender;
  final String dob;
  final String bloodGroup;
  final String maritalStatus;
  final String nationality;
  final String religion;
  final String aadharNumber;
  final String panNumber;
  final String passportNumber;
  final String drivingLicenseNumber;
  final String mobileNumber;
  final String alternateMobile;
  final String personalEmail;
  final String officialEmail;
  final String employeeCode;
  final String biometricId;
  final String faceRegistrationStatus;

  final AddressDetails addressDetails;
  final List<EducationRecord> educationRecords;
  final List<ExperienceRecord> experienceRecords;
  final List<FamilyMember> familyMembers;
  final List<EmergencyContact> emergencyContacts;
  final BankDetails bankDetails;
  final List<AssignedAsset> assignedAssets;
  final AttendanceSummary attendanceSummary;
  final LeaveSummary leaveSummary;
  final PayrollSummary payrollSummary;
  final List<ProfileDocument> documents;
  final ProfileSettings settings;
  final List<TimelineActivity> timelineActivities;

  EmployeeProfileModel({
    required this.employeeId,
    required this.photoUrl,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.gender,
    required this.dob,
    required this.bloodGroup,
    required this.maritalStatus,
    required this.nationality,
    required this.religion,
    required this.aadharNumber,
    required this.panNumber,
    required this.passportNumber,
    required this.drivingLicenseNumber,
    required this.mobileNumber,
    required this.alternateMobile,
    required this.personalEmail,
    required this.officialEmail,
    required this.employeeCode,
    required this.biometricId,
    required this.faceRegistrationStatus,
    required this.addressDetails,
    required this.educationRecords,
    required this.experienceRecords,
    required this.familyMembers,
    required this.emergencyContacts,
    required this.bankDetails,
    required this.assignedAssets,
    required this.attendanceSummary,
    required this.leaveSummary,
    required this.payrollSummary,
    required this.documents,
    required this.settings,
    required this.timelineActivities,
  });

  EmployeeProfileModel copyWith({
    String? photoUrl,
    String? firstName,
    String? middleName,
    String? lastName,
    String? gender,
    String? dob,
    String? bloodGroup,
    String? maritalStatus,
    String? nationality,
    String? religion,
    String? aadharNumber,
    String? panNumber,
    String? passportNumber,
    String? drivingLicenseNumber,
    String? mobileNumber,
    String? alternateMobile,
    String? personalEmail,
    String? officialEmail,
    String? biometricId,
    String? faceRegistrationStatus,
    AddressDetails? addressDetails,
    List<EducationRecord>? educationRecords,
    List<ExperienceRecord>? experienceRecords,
    List<FamilyMember>? familyMembers,
    List<EmergencyContact>? emergencyContacts,
    BankDetails? bankDetails,
    List<AssignedAsset>? assignedAssets,
    AttendanceSummary? attendanceSummary,
    LeaveSummary? leaveSummary,
    PayrollSummary? payrollSummary,
    List<ProfileDocument>? documents,
    ProfileSettings? settings,
    List<TimelineActivity>? timelineActivities,
  }) {
    return EmployeeProfileModel(
      employeeId: employeeId,
      photoUrl: photoUrl ?? this.photoUrl,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      nationality: nationality ?? this.nationality,
      religion: religion ?? this.religion,
      aadharNumber: aadharNumber ?? this.aadharNumber,
      panNumber: panNumber ?? this.panNumber,
      passportNumber: passportNumber ?? this.passportNumber,
      drivingLicenseNumber: drivingLicenseNumber ?? this.drivingLicenseNumber,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      alternateMobile: alternateMobile ?? this.alternateMobile,
      personalEmail: personalEmail ?? this.personalEmail,
      officialEmail: officialEmail ?? this.officialEmail,
      employeeCode: employeeCode,
      biometricId: biometricId ?? this.biometricId,
      faceRegistrationStatus: faceRegistrationStatus ?? this.faceRegistrationStatus,
      addressDetails: addressDetails ?? this.addressDetails,
      educationRecords: educationRecords ?? this.educationRecords,
      experienceRecords: experienceRecords ?? this.experienceRecords,
      familyMembers: familyMembers ?? this.familyMembers,
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
      bankDetails: bankDetails ?? this.bankDetails,
      assignedAssets: assignedAssets ?? this.assignedAssets,
      attendanceSummary: attendanceSummary ?? this.attendanceSummary,
      leaveSummary: leaveSummary ?? this.leaveSummary,
      payrollSummary: payrollSummary ?? this.payrollSummary,
      documents: documents ?? this.documents,
      settings: settings ?? this.settings,
      timelineActivities: timelineActivities ?? this.timelineActivities,
    );
  }
}

// ==========================================
// ASSET MANAGEMENT DATA MODELS
// ==========================================

class CompanyAssetModel {
  final String id;
  final String name;
  final String category; // 'IT', 'Office', 'Field'
  final String assetCode;
  final String serialNumber;
  final String brand;
  final String model;
  final String issueDate;
  final String condition;
  final double healthScore;
  final String qrData;
  final String warrantyStart;
  final String warrantyEnd;
  final String purchaseDate;
  final Map<String, String> specifications;
  final String assignedToEmployeeId;
  final String assignedToEmployeeName;
  final String assignedByEmployeeName;
  final bool warrantyAlert;
  final String documentManual;
  final String documentInvoice;

  CompanyAssetModel({
    required this.id,
    required this.name,
    required this.category,
    required this.assetCode,
    required this.serialNumber,
    required this.brand,
    required this.model,
    required this.issueDate,
    required this.condition,
    required this.healthScore,
    required this.qrData,
    required this.warrantyStart,
    required this.warrantyEnd,
    required this.purchaseDate,
    required this.specifications,
    required this.assignedToEmployeeId,
    required this.assignedToEmployeeName,
    required this.assignedByEmployeeName,
    required this.warrantyAlert,
    required this.documentManual,
    required this.documentInvoice,
  });
}

class AssetRequestModel {
  final String id;
  final String employeeId;
  final String employeeName;
  final String category;
  final String type; // 'New', 'Upgrade', 'Replacement', 'Lost Asset', 'Return'
  final String priority; // 'Low', 'Medium', 'High', 'Critical'
  final String reason;
  final String attachment;
  final String status; // 'Pending', 'Approved', 'Assigned', 'Rejected'
  final String date;

  AssetRequestModel({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.category,
    required this.type,
    required this.priority,
    required this.reason,
    required this.attachment,
    required this.status,
    required this.date,
  });
}

class AssetTicketModel {
  final String id;
  final String assetId;
  final String assetName;
  final String employeeId;
  final String employeeName;
  final String issueType;
  final String description;
  final String priority;
  final String status; // 'Open', 'Assigned', 'In Progress', 'Resolved', 'Closed'
  final String date;
  final String resolutionRemarks;

  AssetTicketModel({
    required this.id,
    required this.assetId,
    required this.assetName,
    required this.employeeId,
    required this.employeeName,
    required this.issueType,
    required this.description,
    required this.priority,
    required this.status,
    required this.date,
    required this.resolutionRemarks,
  });
}

class AssetTransferLogModel {
  final String id;
  final String assetId;
  final String assetName;
  final String fromEmployeeName;
  final String toEmployeeName;
  final String date;
  final String remarks;

  AssetTransferLogModel({
    required this.id,
    required this.assetId,
    required this.assetName,
    required this.fromEmployeeName,
    required this.toEmployeeName,
    required this.date,
    required this.remarks,
  });
}

class AssetAuditLogModel {
  final String id;
  final String assetId;
  final String assetName;
  final String scannedBy;
  final String date;
  final String scannedCondition;
  final String result;

  AssetAuditLogModel({
    required this.id,
    required this.assetId,
    required this.assetName,
    required this.scannedBy,
    required this.date,
    required this.scannedCondition,
    required this.result,
  });
}

// ==========================================
// EXPENSE MANAGEMENT DATA MODELS
// ==========================================

class ExpenseLineItem {
  final String id;
  final String category;
  final String description;
  final double amount;
  final String date;
  final String billAttached; // filename or empty
  final double policyLimit;  // limit for this category

  ExpenseLineItem({
    required this.id,
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
    required this.billAttached,
    required this.policyLimit,
  });

  bool get exceedsPolicy => policyLimit > 0 && amount > policyLimit;
}

class ExpenseClaimModel {
  final String id;
  final String employeeId;
  final String employeeName;
  final String title;
  final String status; // Draft / Pending / Approved / Partially Approved / Rejected / Reimbursed
  final double totalClaimed;
  final double approvedAmount;
  final String submittedDate;
  final String approvedDate;
  final String approvedBy;
  final String rejectionReason;
  final String onBehalfOfEmployeeId;
  final String onBehalfOfEmployeeName;
  final List<ExpenseLineItem> lineItems;

  ExpenseClaimModel({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.title,
    required this.status,
    required this.totalClaimed,
    required this.approvedAmount,
    required this.submittedDate,
    required this.approvedDate,
    required this.approvedBy,
    required this.rejectionReason,
    required this.onBehalfOfEmployeeId,
    required this.onBehalfOfEmployeeName,
    required this.lineItems,
  });

  ExpenseClaimModel copyWith({
    String? status,
    double? approvedAmount,
    String? approvedDate,
    String? approvedBy,
    String? rejectionReason,
  }) {
    return ExpenseClaimModel(
      id: id,
      employeeId: employeeId,
      employeeName: employeeName,
      title: title,
      status: status ?? this.status,
      totalClaimed: totalClaimed,
      approvedAmount: approvedAmount ?? this.approvedAmount,
      submittedDate: submittedDate,
      approvedDate: approvedDate ?? this.approvedDate,
      approvedBy: approvedBy ?? this.approvedBy,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      onBehalfOfEmployeeId: onBehalfOfEmployeeId,
      onBehalfOfEmployeeName: onBehalfOfEmployeeName,
      lineItems: lineItems,
    );
  }

  List<ExpenseLineItem> get policyViolations => lineItems.where((l) => l.exceedsPolicy).toList();
}

class AdvanceRequestModel {
  final String id;
  final String employeeId;
  final String employeeName;
  final String type; // Business Trip / Conference / Client Visit / Other
  final String purpose;
  final double requestedAmount;
  final double disbursedAmount;
  final double actualExpense;
  final double settlementAmount; // excess to return / deficit to claim
  final String expectedDate;
  final String status; // Pending / Approved / Rejected / Settled
  final String requestDate;
  final String settledDate;

  AdvanceRequestModel({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.type,
    required this.purpose,
    required this.requestedAmount,
    required this.disbursedAmount,
    required this.actualExpense,
    required this.settlementAmount,
    required this.expectedDate,
    required this.status,
    required this.requestDate,
    required this.settledDate,
  });

  AdvanceRequestModel copyWith({
    String? status,
    double? disbursedAmount,
    double? actualExpense,
    double? settlementAmount,
    String? settledDate,
  }) {
    return AdvanceRequestModel(
      id: id,
      employeeId: employeeId,
      employeeName: employeeName,
      type: type,
      purpose: purpose,
      requestedAmount: requestedAmount,
      disbursedAmount: disbursedAmount ?? this.disbursedAmount,
      actualExpense: actualExpense ?? this.actualExpense,
      settlementAmount: settlementAmount ?? this.settlementAmount,
      expectedDate: expectedDate,
      status: status ?? this.status,
      requestDate: requestDate,
      settledDate: settledDate ?? this.settledDate,
    );
  }
}

class ExpenseReimbursementModel {
  final String id;
  final String claimId;
  final String employeeName;
  final String claimTitle;
  final double amount;
  final String status; // Pending Finance / Processing / Paid
  final String processedDate;
  final String paymentReferenceNo;
  final String bankAccount;

  ExpenseReimbursementModel({
    required this.id,
    required this.claimId,
    required this.employeeName,
    required this.claimTitle,
    required this.amount,
    required this.status,
    required this.processedDate,
    required this.paymentReferenceNo,
    required this.bankAccount,
  });
}

class ExpensePolicyModel {
  final String category;
  final double limitPerClaim;
  final String unit;
  final String notes;

  ExpensePolicyModel({
    required this.category,
    required this.limitPerClaim,
    required this.unit,
    required this.notes,
  });
}

// ==========================================
// UNIFIED APPROVAL REQUEST DATA MODELS
// ==========================================

class WorkflowLevelModel {
  final int level;
  final String roleTitle;
  final String approverName;
  final String approverEmpId;
  final String decision; // Pending / Approved / Rejected / Waiting
  final String comment;
  final String decidedAt;

  WorkflowLevelModel({
    required this.level,
    required this.roleTitle,
    required this.approverName,
    required this.approverEmpId,
    required this.decision,
    required this.comment,
    required this.decidedAt,
  });

  WorkflowLevelModel copyWith({
    String? decision,
    String? comment,
    String? decidedAt,
  }) {
    return WorkflowLevelModel(
      level: level,
      roleTitle: roleTitle,
      approverName: approverName,
      approverEmpId: approverEmpId,
      decision: decision ?? this.decision,
      comment: comment ?? this.comment,
      decidedAt: decidedAt ?? this.decidedAt,
    );
  }
}

class ApprovalAttachment {
  final String filename;
  final String type; // PDF / JPG / PNG / DOC / DOCX
  final int sizeKb;

  ApprovalAttachment({
    required this.filename,
    required this.type,
    required this.sizeKb,
  });

  String get sizeDisplay => sizeKb > 1024 ? '${(sizeKb / 1024).toStringAsFixed(1)} MB' : '${sizeKb} KB';
}

class RequestHistoryEvent {
  final String eventType; // Created / Attachment Added / Approved / Rejected / Sent Back / Info Requested / Escalated / Updated / Resubmitted
  final String actor;
  final String note;
  final String timestamp;

  RequestHistoryEvent({
    required this.eventType,
    required this.actor,
    required this.note,
    required this.timestamp,
  });
}

class UnifiedApprovalRequest {
  final String id;
  final String requestNo;
  final String type; // Leave / Expense / Asset Request / Recruitment / Offer Letter / Resignation / Travel / Budget / Attendance Correction
  final String category; // HR & Leaves / Finance & Expenses / Operations & Assets
  final String priority; // High / Medium / Low
  final String employeeId;
  final String employeeName;
  final String department;
  final String requestDate;
  final String status; // Pending / Approved / Rejected / Sent Back / Info Requested / Escalated
  final int currentLevel; // Which level is pending (0-indexed base), -1 = completed
  final Map<String, String> typeSpecificData;
  final List<WorkflowLevelModel> workflowLevels;
  final List<ApprovalAttachment> attachments;
  final List<RequestHistoryEvent> history;

  UnifiedApprovalRequest({
    required this.id,
    required this.requestNo,
    required this.type,
    required this.category,
    required this.priority,
    required this.employeeId,
    required this.employeeName,
    required this.department,
    required this.requestDate,
    required this.status,
    required this.currentLevel,
    required this.typeSpecificData,
    required this.workflowLevels,
    required this.attachments,
    required this.history,
  });

  UnifiedApprovalRequest copyWith({
    String? status,
    int? currentLevel,
    List<WorkflowLevelModel>? workflowLevels,
    List<RequestHistoryEvent>? history,
  }) {
    return UnifiedApprovalRequest(
      id: id,
      requestNo: requestNo,
      type: type,
      category: category,
      priority: priority,
      employeeId: employeeId,
      employeeName: employeeName,
      department: department,
      requestDate: requestDate,
      status: status ?? this.status,
      currentLevel: currentLevel ?? this.currentLevel,
      typeSpecificData: typeSpecificData,
      workflowLevels: workflowLevels ?? this.workflowLevels,
      attachments: attachments,
      history: history ?? this.history,
    );
  }

  int get totalLevels => workflowLevels.length;
  int get completedLevels => workflowLevels.where((l) => l.decision == 'Approved').length;

  WorkflowLevelModel? get currentPendingLevel =>
      workflowLevels.where((l) => l.decision == 'Pending').isEmpty
          ? null
          : workflowLevels.firstWhere((l) => l.decision == 'Pending');

  String get pendingWithName => currentPendingLevel?.approverName ?? '—';
  String get pendingWithRole => currentPendingLevel?.roleTitle ?? '—';
}


