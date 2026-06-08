import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';

// ==========================================
// RECRUITMENT DATA MODELS
// ==========================================

class JobRequisitionModel {
  final String id;
  final String department;
  final String designation;
  final int positionsCount;
  final String employmentType;
  final String branch;
  final String expectedJoiningDate;
  final String priority;
  final String budget; // e.g. "12 LPA"
  final String reasonForHiring; // New Position / Replacement / Project / Expansion / Urgent
  final List<String> attachments; // jd, budget_approval, etc.
  String status; // Draft / Pending / Approved / Rejected / Cancelled
  final List<String> approvalFlow; // e.g. ["Team Lead", "Department Head", "HR", "Management"]
  int currentApprovalStep; // 0 to 4

  JobRequisitionModel({
    required this.id,
    required this.department,
    required this.designation,
    required this.positionsCount,
    required this.employmentType,
    required this.branch,
    required this.expectedJoiningDate,
    required this.priority,
    required this.budget,
    required this.reasonForHiring,
    required this.attachments,
    required this.status,
    required this.approvalFlow,
    this.currentApprovalStep = 0,
  });
}

class JobOpeningModel {
  final String id;
  final String requisitionId;
  final String jobTitle;
  final String department;
  final String experience; // e.g. "2 - 5 Years"
  final String location;
  final String salaryRange; // e.g. "8 - 12 LPA"
  final List<String> skills;
  final String jobDescription;
  final String employmentType; // Permanent / Contract / Intern / Part Time / Consultant
  String status; // Open / On Hold / Closed / Cancelled
  final List<String> publishChannels; // ["LinkedIn", "Indeed", etc.]

  JobOpeningModel({
    required this.id,
    required this.requisitionId,
    required this.jobTitle,
    required this.department,
    required this.experience,
    required this.location,
    required this.salaryRange,
    required this.skills,
    required this.jobDescription,
    required this.employmentType,
    required this.status,
    required this.publishChannels,
  });
}

class ScreeningFormModel {
  final double communicationRating; // 1-5
  final double technicalFitRating; // 1-5
  final double salaryFitRating; // 1-5
  final String noticePeriod;
  final double overallRating; // 1-5
  final String result; // Qualified / Rejected / Hold
  final String hrRemarks;

  ScreeningFormModel({
    required this.communicationRating,
    required this.technicalFitRating,
    required this.salaryFitRating,
    required this.noticePeriod,
    required this.overallRating,
    required this.result,
    required this.hrRemarks,
  });
}

class TimelineEvent {
  final String status;
  final String date;
  final String remarks;

  TimelineEvent({
    required this.status,
    required this.date,
    required this.remarks,
  });
}

class CandidateModel {
  final String id;
  final String photo;
  final String name;
  final String mobile;
  final String email;
  final String currentCompany;
  final double experience; // Years
  final String currentSalary;
  final String expectedSalary;
  String status; // Applied / Screening / Assessment / Technical Round / Manager Round / HR Round / Offer / Joined / Rejected
  final Map<String, String> personalInfo;
  final Map<String, String> professionalInfo;
  final List<String> skills;
  final Map<String, String> documents; // {"Resume": "path", "Portfolio": "path"}
  final String source; // LinkedIn / Naukri / Reference / Website / Consultant
  ScreeningFormModel? screeningFeedback;
  final List<TimelineEvent> timeline;
  final bool isDuplicateDetected;
  final int aiMatchScore; // Match % based on skills vs JD
  final List<String> suggestedQuestions;

  CandidateModel({
    required this.id,
    required this.photo,
    required this.name,
    required this.mobile,
    required this.email,
    required this.currentCompany,
    required this.experience,
    required this.currentSalary,
    required this.expectedSalary,
    required this.status,
    required this.personalInfo,
    required this.professionalInfo,
    required this.skills,
    required this.documents,
    required this.source,
    this.screeningFeedback,
    required this.timeline,
    this.isDuplicateDetected = false,
    this.aiMatchScore = 80,
    this.suggestedQuestions = const [],
  });
}

class InterviewFeedbackModel {
  final double technicalSkills; // 1-5
  final double communication; // 1-5
  final double problemSolving; // 1-5
  final double attitude; // 1-5
  final double domainKnowledge; // 1-5
  final String recommendation; // Strong Hire / Hire / Hold / Reject
  final String comments;

  InterviewFeedbackModel({
    required this.technicalSkills,
    required this.communication,
    required this.problemSolving,
    required this.attitude,
    required this.domainKnowledge,
    required this.recommendation,
    required this.comments,
  });
}

class InterviewModel {
  final String id;
  final String candidateId;
  final String candidateName;
  final String jobTitle;
  final String interviewType; // Technical / Managerial / HR / Final
  final String date;
  final String time;
  final List<String> interviewers; // Panel of multiple interviewers
  final String mode; // Online / Offline / Telephonic
  final String meetingLink; // Meet / Zoom / Teams
  final String notificationStatus; // Sent / Pending
  InterviewFeedbackModel? feedback;

  InterviewModel({
    required this.id,
    required this.candidateId,
    required this.candidateName,
    required this.jobTitle,
    required this.interviewType,
    required this.date,
    required this.time,
    required this.interviewers,
    required this.mode,
    required this.meetingLink,
    required this.notificationStatus,
    this.feedback,
  });
}

class OfferLetterModel {
  final String id;
  final String candidateId;
  final String candidateName;
  final String designation;
  final String department;
  final String location;
  final String joiningDate;
  String salary;
  final String benefits;
  final String probationPeriod;
  String approvalStatus; // Draft / Pending Approval / Sent / Accepted / Rejected / Expired / Negotiating
  final List<String> approvalFlow; // Manager -> HR -> Finance -> Director
  int currentApprovalStep;
  bool isDigitallySigned; // E-Signature complete

  OfferLetterModel({
    required this.id,
    required this.candidateId,
    required this.candidateName,
    required this.designation,
    required this.department,
    required this.location,
    required this.joiningDate,
    required this.salary,
    required this.benefits,
    required this.probationPeriod,
    required this.approvalStatus,
    required this.approvalFlow,
    this.currentApprovalStep = 0,
    this.isDigitallySigned = false,
  });
}

class PreJoiningPortalModel {
  final String candidateId;
  final String portalAccessCode;
  final Map<String, bool> uploadedDocuments; // {"Aadhar": true, "PAN": false}
  final Map<String, String> completedForms; // {"Personal Details": "Complete", "Bank Details": "Pending"}
  final Map<String, bool> joiningChecklist; // {"Laptop Assigned": true, "Email Created": false}
  bool isAssetsAllocated;
  bool isEmailCreated;

  PreJoiningPortalModel({
    required this.candidateId,
    required this.portalAccessCode,
    required this.uploadedDocuments,
    required this.completedForms,
    required this.joiningChecklist,
    this.isAssetsAllocated = false,
    this.isEmailCreated = false,
  });
}

class ReferralModel {
  final String id;
  final String candidateName;
  final String positionTitle;
  final String resumeName;
  final String referredBy; // Employee Name
  final String status; // Applied / Screened / Interviewed / Selected / Joined / Rejected
  final String bonusStatus; // Pending / Eligible / Paid
  final double bonusAmount;

  ReferralModel({
    required this.id,
    required this.candidateName,
    required this.positionTitle,
    required this.resumeName,
    required this.referredBy,
    required this.status,
    required this.bonusStatus,
    required this.bonusAmount,
  });
}

class WorkforcePlanModel {
  final String id;
  final String department;
  final String designation;
  final int requiredHeadcount;
  final int currentHeadcount;
  final int vacancy;
  final String budget; // e.g. "₹25 Lakh"
  final String quarter; // Q1 / Q2 / Q3 / Q4
  final String financialYear; // FY26-27

  WorkforcePlanModel({
    required this.id,
    required this.department,
    required this.designation,
    required this.requiredHeadcount,
    required this.currentHeadcount,
    required this.vacancy,
    required this.budget,
    required this.quarter,
    required this.financialYear,
  });
}

class AssessmentModel {
  final String id;
  final String candidateId;
  final String candidateName;
  final String testType; // Technical Test / MCQ Test / Coding Test / Aptitude Test
  final int score; // out of 100
  final int durationMinutes;
  final String resultStatus; // Pass / Fail

  AssessmentModel({
    required this.id,
    required this.candidateId,
    required this.candidateName,
    required this.testType,
    required this.score,
    required this.durationMinutes,
    required this.resultStatus,
  });
}

class BGVTrackerModel {
  final String candidateId;
  final String candidateName;
  String employmentStatus; // Verified / Pending / Rejected
  String educationStatus; // Verified / Pending / Rejected
  String identityStatus; // Verified / Pending / Rejected
  String remarks;

  BGVTrackerModel({
    required this.candidateId,
    required this.candidateName,
    this.employmentStatus = 'Pending',
    this.educationStatus = 'Pending',
    this.identityStatus = 'Pending',
    this.remarks = 'Initial verification pending',
  });
}

class CampusHiringModel {
  final String id;
  final String collegeName;
  final String positionTitle;
  final int registeredCount;
  final int shortListedCount;
  final int offersReleasedCount;
  final String contactPerson;
  final String status; // Scheduled / Ongoing / Completed

  CampusHiringModel({
    required this.id,
    required this.collegeName,
    required this.positionTitle,
    required this.registeredCount,
    required this.shortListedCount,
    required this.offersReleasedCount,
    required this.contactPerson,
    required this.status,
  });
}

class OfferNegotiationModel {
  final String id;
  final String offerId;
  final String candidateName;
  final String originalCtc;
  final String proposedCtc;
  final String originalJoiningDate;
  final String proposedJoiningDate;
  String status; // Pending Review / Approved / Rejected
  final String remarks;

  OfferNegotiationModel({
    required this.id,
    required this.offerId,
    required this.candidateName,
    required this.originalCtc,
    required this.proposedCtc,
    required this.originalJoiningDate,
    required this.proposedJoiningDate,
    this.status = 'Pending Review',
    required this.remarks,
  });
}

// ==========================================
// RECRUITMENT ATS HELPER STATE MANAGER
// ==========================================

class RecruitmentHelper extends ChangeNotifier {
  RecruitmentHelper._internal() {
    _initializeData();
  }
  static final RecruitmentHelper instance = RecruitmentHelper._internal();

  List<JobRequisitionModel> _requisitions = [];
  List<JobOpeningModel> _openings = [];
  List<CandidateModel> _candidates = [];
  List<InterviewModel> _interviews = [];
  List<OfferLetterModel> _offers = [];
  List<PreJoiningPortalModel> _preJoiningPortals = [];
  List<ReferralModel> _referrals = [];
  List<String> _notifications = [];

  // Extended features lists
  List<WorkforcePlanModel> _workforcePlans = [];
  List<AssessmentModel> _assessments = [];
  List<BGVTrackerModel> _bgvChecks = [];
  List<CampusHiringModel> _campusEvents = [];
  List<OfferNegotiationModel> _negotiations = [];

  // Recruitment Budget Tracker
  double budgetAllocated = 1500000; // INR 15 Lakh
  double budgetUsed = 850000; // INR 8.5 Lakh

  // Getters
  List<JobRequisitionModel> get requisitions => _requisitions;
  List<JobOpeningModel> get openings => _openings;
  List<CandidateModel> get candidates => _candidates.where((c) => c.status != 'Rejected').toList();
  List<CandidateModel> get talentPool => _candidates.where((c) => c.status == 'Rejected').toList();
  List<InterviewModel> get interviews => _interviews;
  List<OfferLetterModel> get offers => _offers;
  List<PreJoiningPortalModel> get preJoiningPortals => _preJoiningPortals;
  List<ReferralModel> get referrals => _referrals;
  List<String> get notifications => _notifications;

  List<WorkforcePlanModel> get workforcePlans => _workforcePlans;
  List<AssessmentModel> get assessments => _assessments;
  List<BGVTrackerModel> get bgvChecks => _bgvChecks;
  List<CampusHiringModel> get campusEvents => _campusEvents;
  List<OfferNegotiationModel> get negotiations => _negotiations;

  void _initializeData() {
    // 1. Seed Requisitions
    _requisitions = [
      JobRequisitionModel(
        id: 'req_1',
        department: 'Mobile Development',
        designation: 'Flutter Developer',
        positionsCount: 2,
        employmentType: 'Permanent',
        branch: 'Ahmedabad HQ',
        expectedJoiningDate: '15-Jun-2026',
        priority: 'High',
        budget: '12 LPA',
        reasonForHiring: 'Expansion',
        attachments: ['Flutter_JD_v2.pdf', 'Budget_Sheet_2026.xlsx'],
        status: 'Approved',
        approvalFlow: ['Team Lead', 'Department Head', 'HR', 'Management'],
        currentApprovalStep: 4,
      ),
      JobRequisitionModel(
        id: 'req_2',
        department: 'Product & Engineering',
        designation: 'Senior Node.js Developer',
        positionsCount: 1,
        employmentType: 'Permanent',
        branch: 'Mumbai Branch',
        expectedJoiningDate: '01-Jul-2026',
        priority: 'Medium',
        budget: '18 LPA',
        reasonForHiring: 'New Position',
        attachments: ['NodeJS_JD.pdf'],
        status: 'Pending',
        approvalFlow: ['Team Lead', 'Department Head', 'HR', 'Management'],
        currentApprovalStep: 1, // Pending Dept Head
      ),
    ];

    // 2. Seed Job Openings
    _openings = [
      JobOpeningModel(
        id: 'job_1',
        requisitionId: 'req_1',
        jobTitle: 'Flutter Developer',
        department: 'Mobile Development',
        experience: '2 - 4 Years',
        location: 'Ahmedabad (On-site)',
        salaryRange: '8 - 12 LPA',
        skills: ['Flutter', 'Dart', 'REST API', 'Firebase', 'State Management'],
        jobDescription: 'We are looking for a skilled Flutter Developer to join our team in building next-gen enterprise apps.',
        employmentType: 'Permanent',
        status: 'Open',
        publishChannels: ['Company Website', 'LinkedIn', 'Naukri', 'Indeed'],
      ),
      JobOpeningModel(
        id: 'job_2',
        requisitionId: 'none',
        jobTitle: 'UI/UX Designer',
        department: 'Product & Design',
        experience: '1 - 3 Years',
        location: 'Remote',
        salaryRange: '6 - 9 LPA',
        skills: ['Figma', 'Wireframing', 'Prototyping', 'User Research'],
        jobDescription: 'Create clean layouts and rich user experiences for our enterprise SaaS products.',
        employmentType: 'Permanent',
        status: 'On Hold',
        publishChannels: ['Company Website', 'LinkedIn', 'Monster'],
      ),
    ];

    // 3. Seed Candidates
    _candidates = [
      CandidateModel(
        id: 'cand_1',
        photo: 'A',
        name: 'Aarav Patel',
        mobile: '9876543210',
        email: 'aarav.patel@gmail.com',
        currentCompany: 'Infotech Ltd',
        experience: 2.5,
        currentSalary: '6 LPA',
        expectedSalary: '9 LPA',
        status: 'Applied',
        personalInfo: {'DOB': '12-May-2001', 'Gender': 'Male', 'Address': 'Satellite, Ahmedabad'},
        professionalInfo: {'Current Company': 'Infotech Ltd', 'Current Role': 'Associate Developer', 'Notice Period': '30 Days'},
        skills: ['Flutter', 'Dart', 'SQL'],
        documents: {'Resume': 'aarav_patel_resume.pdf'},
        source: 'LinkedIn',
        aiMatchScore: 82,
        suggestedQuestions: [
          'Explain Dart event loops and isolate mechanics.',
          'How does setState() build context tree internally?'
        ],
        timeline: [TimelineEvent(status: 'Applied', date: '01-Jun-2026', remarks: 'Applied via LinkedIn profile')],
      ),
      CandidateModel(
        id: 'cand_2',
        photo: 'S',
        name: 'Shreya Sharma',
        mobile: '9123456789',
        email: 'shreya.sharma@yahoo.com',
        currentCompany: 'WebApps Corp',
        experience: 3.0,
        currentSalary: '7.5 LPA',
        expectedSalary: '10 LPA',
        status: 'Screening',
        personalInfo: {'DOB': '24-Sep-1999', 'Gender': 'Female', 'Address': 'SG Highway, Ahmedabad'},
        professionalInfo: {'Current Company': 'WebApps Corp', 'Current Role': 'Flutter Developer', 'Notice Period': '15 Days'},
        skills: ['Flutter', 'Dart', 'Firebase', 'Git'],
        documents: {'Resume': 'shreya_sharma_resume.pdf', 'Portfolio': 'shreya_portfolio.link'},
        source: 'Naukri',
        aiMatchScore: 89,
        suggestedQuestions: [
          'What is dynamic theme configurations logic in Flutter?',
          'How do you manage complex multi-company permissions state?'
        ],
        screeningFeedback: ScreeningFormModel(
          communicationRating: 4.0,
          technicalFitRating: 4.5,
          salaryFitRating: 4.0,
          noticePeriod: '15 Days',
          overallRating: 4.2,
          result: 'Qualified',
          hrRemarks: 'Excellent technical fit and communication.',
        ),
        timeline: [
          TimelineEvent(status: 'Applied', date: '02-Jun-2026', remarks: 'Applied via Naukri'),
          TimelineEvent(status: 'Screening', date: '03-Jun-2026', remarks: 'Qualified HR screening. Communication is fluent.'),
        ],
      ),
      CandidateModel(
        id: 'cand_3',
        photo: 'R',
        name: 'Rohan Gupta',
        mobile: '9898989898',
        email: 'rohan.gupta@outlook.com',
        currentCompany: 'AppTech Solutions',
        experience: 4.0,
        currentSalary: '8.5 LPA',
        expectedSalary: '11 LPA',
        status: 'Technical Round',
        personalInfo: {'DOB': '05-Dec-1997', 'Gender': 'Male', 'Address': 'Bopal, Ahmedabad'},
        professionalInfo: {'Current Company': 'AppTech Solutions', 'Current Role': 'Senior Flutter Dev', 'Notice Period': 'Immediate'},
        skills: ['Flutter', 'Dart', 'REST API', 'Provider', 'CI/CD'],
        documents: {'Resume': 'rohan_gupta_resume.pdf'},
        source: 'Reference',
        aiMatchScore: 94,
        suggestedQuestions: [
          'Draft CI/CD actions config file for Flutter App.',
          'Explain difference between Provider vs Bloc architecture.'
        ],
        screeningFeedback: ScreeningFormModel(
          communicationRating: 4.5,
          technicalFitRating: 4.0,
          salaryFitRating: 4.5,
          noticePeriod: 'Immediate',
          overallRating: 4.3,
          result: 'Qualified',
          hrRemarks: 'Immediate joiner referred by Riya Sharma.',
        ),
        timeline: [
          TimelineEvent(status: 'Applied', date: '03-Jun-2026', remarks: 'Referred by Riya Sharma (Engineering Lead)'),
          TimelineEvent(status: 'Screening', date: '04-Jun-2026', remarks: 'Screening qualified'),
          TimelineEvent(status: 'Technical Round', date: '05-Jun-2026', remarks: 'Technical Round 1 scheduled for 8th June'),
        ],
      ),
      CandidateModel(
        id: 'cand_5',
        photo: 'K',
        name: 'Kabir Verma',
        mobile: '9666777888',
        email: 'kabir.v@consulting.com',
        currentCompany: 'MobileMinds',
        experience: 3.5,
        currentSalary: '8 LPA',
        expectedSalary: '12 LPA',
        status: 'Manager Round',
        personalInfo: {'DOB': '15-Mar-1998', 'Gender': 'Male', 'Address': 'Ghatlodia, Ahmedabad'},
        professionalInfo: {'Current Company': 'MobileMinds', 'Current Role': 'Flutter Developer', 'Notice Period': '30 Days'},
        skills: ['Flutter', 'Dart', 'Bloc', 'REST API'],
        documents: {'Resume': 'kabir_verma_resume.pdf'},
        source: 'Consultant',
        aiMatchScore: 86,
        timeline: [
          TimelineEvent(status: 'Applied', date: '25-May-2026', remarks: 'Sourced via consultant referral'),
          TimelineEvent(status: 'Screening', date: '26-May-2026', remarks: 'Screening cleared'),
          TimelineEvent(status: 'Assessment', date: '27-May-2026', remarks: 'Cleared Technical Test score: 85/100'),
          TimelineEvent(status: 'Technical Round', date: '30-May-2026', remarks: 'Finished Technical panel check'),
          TimelineEvent(status: 'Manager Round', date: '04-Jun-2026', remarks: 'Manager loop scheduled'),
        ],
      ),
      CandidateModel(
        id: 'cand_6',
        photo: 'V',
        name: 'Vikram Malhotra',
        mobile: '9555444332',
        email: 'vikram.m@gmail.com',
        currentCompany: 'GlobalTech Solutions',
        experience: 4.5,
        currentSalary: '9.5 LPA',
        expectedSalary: '12.5 LPA',
        status: 'Offer',
        personalInfo: {'DOB': '09-Jul-1996', 'Gender': 'Male', 'Address': 'Vastrapur, Ahmedabad'},
        professionalInfo: {'Current Company': 'GlobalTech Solutions', 'Current Role': 'Senior Developer', 'Notice Period': '15 Days'},
        skills: ['Flutter', 'Dart', 'Bloc', 'CI/CD', 'Docker'],
        documents: {'Resume': 'vikram_m_resume.pdf'},
        source: 'Reference',
        aiMatchScore: 92,
        timeline: [
          TimelineEvent(status: 'Applied', date: '15-May-2026', remarks: 'Sourced'),
          TimelineEvent(status: 'Selected', date: '24-May-2026', remarks: 'Cleared final rounds'),
          TimelineEvent(status: 'Offer', date: '26-May-2026', remarks: 'Offer Letter sent with 12 LPA CTC'),
        ],
      ),
    ];

    // 4. Seed Interviews
    _interviews = [
      InterviewModel(
        id: 'int_1',
        candidateId: 'cand_3',
        candidateName: 'Rohan Gupta',
        jobTitle: 'Flutter Developer',
        interviewType: 'Technical',
        date: '08-Jun-2026',
        time: '11:00 AM',
        interviewers: ['Riya Sharma (Lead)', 'Alok Mishra (Architect)'],
        mode: 'Online',
        meetingLink: 'https://meet.google.com/abc-defg-hij',
        notificationStatus: 'Sent',
      ),
    ];

    // 5. Seed Offer Letters
    _offers = [
      OfferLetterModel(
        id: 'off_1',
        candidateId: 'cand_6',
        candidateName: 'Vikram Malhotra',
        designation: 'Senior Flutter Developer',
        department: 'Mobile Development',
        location: 'Ahmedabad HQ',
        joiningDate: '15-Jun-2026',
        salary: '12 LPA',
        benefits: 'Medical Insurance, Gratuity, Performance Bonus',
        probationPeriod: '6 Months',
        approvalStatus: 'Sent',
        approvalFlow: ['Manager', 'HR', 'Finance', 'Director'],
        currentApprovalStep: 4,
        isDigitallySigned: false,
      ),
    ];

    // 6. Seed Pre-joining checklists
    _preJoiningPortals = [
      PreJoiningPortalModel(
        candidateId: 'cand_6',
        portalAccessCode: 'PORT-VIK-998',
        uploadedDocuments: {'Aadhar Proof': true, 'PAN Card': true, 'Certificates': true, 'Relieving Letter': false},
        completedForms: {'Personal Details': 'Complete', 'Bank Details': 'Complete', 'Emergency Contact': 'Complete'},
        joiningChecklist: {'Laptop Assigned': true, 'Email Created': true, 'Attendance Created': true, 'Leave Balance Created': true, 'Payroll Setup': true},
        isAssetsAllocated: true,
        isEmailCreated: true,
      ),
    ];

    // 7. Seed Referrals
    _referrals = [
      ReferralModel(
        id: 'ref_1',
        candidateName: 'Rohan Gupta',
        positionTitle: 'Flutter Developer',
        resumeName: 'rohan_gupta_resume.pdf',
        referredBy: 'Riya Sharma',
        status: 'Interviewed',
        bonusStatus: 'Pending',
        bonusAmount: 15000,
      ),
    ];

    // 8. Seed Workforce Planning
    _workforcePlans = [
      WorkforcePlanModel(id: 'wp_1', department: 'Mobile Development', designation: 'Flutter Developer', requiredHeadcount: 10, currentHeadcount: 8, vacancy: 2, budget: '₹24 Lakh', quarter: 'Q3', financialYear: 'FY26-27'),
      WorkforcePlanModel(id: 'wp_2', department: 'Product & Engineering', designation: 'QA Engineer', requiredHeadcount: 5, currentHeadcount: 3, vacancy: 2, budget: '₹12 Lakh', quarter: 'Q4', financialYear: 'FY26-27'),
    ];

    // 9. Seed Online Assessments
    _assessments = [
      AssessmentModel(id: 'as_1', candidateId: 'cand_2', candidateName: 'Shreya Sharma', testType: 'Technical Test', score: 85, durationMinutes: 45, resultStatus: 'Pass'),
      AssessmentModel(id: 'as_2', candidateId: 'cand_5', candidateName: 'Kabir Verma', testType: 'Coding Test', score: 92, durationMinutes: 60, resultStatus: 'Pass'),
      AssessmentModel(id: 'as_3', candidateId: 'cand_1', candidateName: 'Aarav Patel', testType: 'Aptitude Test', score: 48, durationMinutes: 30, resultStatus: 'Fail'),
    ];

    // 10. Seed BGV Check Statuses
    _bgvChecks = [
      BGVTrackerModel(candidateId: 'cand_6', candidateName: 'Vikram Malhotra', employmentStatus: 'Verified', educationStatus: 'Verified', identityStatus: 'Verified', remarks: 'All credentials cleared by verification agent.'),
    ];

    // 11. Seed Campus Hiring Events
    _campusEvents = [
      CampusHiringModel(id: 'c_1', collegeName: 'Nirma University', positionTitle: 'Graduate Engineer Trainee', registeredCount: 120, shortListedCount: 15, offersReleasedCount: 4, contactPerson: 'Dr. Vyas (Placement Cell)', status: 'Completed'),
      CampusHiringModel(id: 'c_2', collegeName: 'DA-IICT', positionTitle: 'Flutter Intern', registeredCount: 85, shortListedCount: 10, offersReleasedCount: 2, contactPerson: 'Prof. Shah', status: 'Ongoing'),
    ];

    _notifications = [
      'HR: New Candidate Aarav Patel applied for Flutter Developer opening.',
      'Manager: Approval Pending for Job Requisition [Senior Node.js Developer].',
      'Candidate Rohan Gupta: Technical Interview loops set by Riya Sharma.',
    ];
  }

  // ==========================================
  // EXTENDED ACTION METHODS
  // ==========================================

  void addNotification(String msg) {
    _notifications.insert(0, msg);
    notifyListeners();
  }

  // Workforce Planning Action
  void addWorkforcePlan({
    required String department,
    required String designation,
    required int requiredHc,
    required int currentHc,
    required String budget,
    required String quarter,
  }) {
    final newPlan = WorkforcePlanModel(
      id: 'wp_${DateTime.now().millisecondsSinceEpoch}',
      department: department,
      designation: designation,
      requiredHeadcount: requiredHc,
      currentHeadcount: currentHc,
      vacancy: requiredHc - currentHc,
      budget: budget,
      quarter: quarter,
      financialYear: 'FY26-27',
    );
    _workforcePlans.add(newPlan);
    addNotification('Workforce Planning: Added Q3 plan for $designation ($department). Required: $requiredHc.');
    notifyListeners();
  }

  // Requisition CRUD
  void createRequisition({
    required String department,
    required String designation,
    required int positions,
    required String employmentType,
    required String branch,
    required String expectedDate,
    required String priority,
    required String budget,
    required String reason,
    required List<String> files,
  }) {
    final newId = 'req_${DateTime.now().millisecondsSinceEpoch}';
    final newReq = JobRequisitionModel(
      id: newId,
      department: department,
      designation: designation,
      positionsCount: positions,
      employmentType: employmentType,
      branch: branch,
      expectedJoiningDate: expectedDate,
      priority: priority,
      budget: budget,
      reasonForHiring: reason,
      attachments: files,
      status: 'Pending',
      approvalFlow: ['Team Lead', 'Department Head', 'HR', 'Management'],
      currentApprovalStep: 0,
    );
    _requisitions.add(newReq);
    addNotification('System: Requisition created for $designation ($department). Pending Team Lead approval.');
    notifyListeners();
  }

  void approveRequisition(String id, String roleTitle) {
    final idx = _requisitions.indexWhere((r) => r.id == id);
    if (idx != -1) {
      final req = _requisitions[idx];
      if (req.currentApprovalStep < req.approvalFlow.length) {
        req.currentApprovalStep++;
        if (req.currentApprovalStep == req.approvalFlow.length) {
          req.status = 'Approved';
          addNotification('System: Requisition for ${req.designation} is fully Approved! Creating Job Opening.');
          createJobOpeningFromRequisition(req);
        } else {
          final nextApprover = req.approvalFlow[req.currentApprovalStep];
          addNotification('System: Requisition for ${req.designation} approved by $roleTitle. Pending $nextApprover.');
        }
        notifyListeners();
      }
    }
  }

  void rejectRequisition(String id, String roleTitle) {
    final idx = _requisitions.indexWhere((r) => r.id == id);
    if (idx != -1) {
      _requisitions[idx].status = 'Rejected';
      addNotification('System: Requisition for ${_requisitions[idx].designation} was Rejected by $roleTitle.');
      notifyListeners();
    }
  }

  void createJobOpeningFromRequisition(JobRequisitionModel req) {
    final newJob = JobOpeningModel(
      id: 'job_${DateTime.now().millisecondsSinceEpoch}',
      requisitionId: req.id,
      jobTitle: req.designation,
      department: req.department,
      experience: '2 - 5 Years',
      location: req.branch,
      salaryRange: req.budget,
      skills: ['Flutter', 'Dart', 'REST API'],
      jobDescription: 'Job details for ${req.designation} position.',
      employmentType: req.employmentType,
      status: 'Open',
      publishChannels: ['Company Website', 'LinkedIn', 'Naukri', 'Indeed'],
    );
    _openings.add(newJob);
  }

  void updateJobStatus(String jobId, String newStatus) {
    final idx = _openings.indexWhere((j) => j.id == jobId);
    if (idx != -1) {
      _openings[idx].status = newStatus;
      notifyListeners();
    }
  }

  // Candidate Actions & Visual Pipeline Stage changes
  void addCandidate({
    required String name,
    required String email,
    required String mobile,
    required String company,
    required double exp,
    required String curSal,
    required String expSal,
    required String source,
    required List<String> skills,
  }) {
    final newId = 'cand_${DateTime.now().millisecondsSinceEpoch}';
    final isDuplicate = _candidates.any((c) => c.email == email || c.mobile == mobile);

    final newCand = CandidateModel(
      id: newId,
      photo: name.isNotEmpty ? name[0].toUpperCase() : 'C',
      name: name,
      mobile: mobile,
      email: email,
      currentCompany: company,
      experience: exp,
      currentSalary: curSal,
      expectedSalary: expSal,
      status: 'Applied',
      personalInfo: {'DOB': '01-Jan-2000', 'Gender': 'Not Specified', 'Address': 'N/A'},
      professionalInfo: {'Current Company': company, 'Current Role': 'Developer', 'Notice Period': '30 Days'},
      skills: skills,
      documents: {'Resume': 'resume_spliced.pdf'},
      source: source,
      isDuplicateDetected: isDuplicate,
      aiMatchScore: 85,
      suggestedQuestions: [
        'How do you manage complex Dart asynchronous processes?',
        'Describe architectural patterns used in production apps.'
      ],
      timeline: [TimelineEvent(status: 'Applied', date: '06-Jun-2026', remarks: 'Added to pipeline')],
    );

    _candidates.add(newCand);
    // Auto seed default BGV check
    _bgvChecks.add(BGVTrackerModel(candidateId: newId, candidateName: name));
    addNotification('Recruiter: Sourced candidate $name. ${isDuplicate ? "⚠️ DUPLICATE EMAIL/MOBILE!" : ""}');
    notifyListeners();
  }

  void updateCandidateStage(String candidateId, String newStage) {
    final idx = _candidates.indexWhere((c) => c.id == candidateId);
    if (idx != -1) {
      final cand = _candidates[idx];
      cand.status = newStage;
      cand.timeline.add(TimelineEvent(status: newStage, date: '06-Jun-2026', remarks: 'Pipeline stage updated to $newStage'));
      notifyListeners();
    }
  }

  void submitScreeningFeedback(String candidateId, ScreeningFormModel form) {
    final idx = _candidates.indexWhere((c) => c.id == candidateId);
    if (idx != -1) {
      final cand = _candidates[idx];
      cand.screeningFeedback = form;
      cand.status = form.result == 'Qualified' ? 'Screening' : 'Rejected';
      cand.timeline.add(TimelineEvent(
        status: cand.status,
        date: '06-Jun-2026',
        remarks: 'HR Screening: ${form.result}. communication: ${form.communicationRating}/5.',
      ));
      notifyListeners();
    }
  }

  // Interview Loops
  void scheduleInterview({
    required String candidateId,
    required String type,
    required String date,
    required String time,
    required List<String> interviewers,
    required String mode,
    required String meetingLink,
  }) {
    final candIdx = _candidates.indexWhere((c) => c.id == candidateId);
    if (candIdx != -1) {
      final cand = _candidates[candIdx];
      cand.status = type == 'Technical' ? 'Technical Round' : type == 'Managerial' ? 'Manager Round' : 'HR Round';
      cand.timeline.add(TimelineEvent(
        status: cand.status,
        date: date,
        remarks: 'Scheduled $type with panel: ${interviewers.join(", ")}',
      ));

      final newInt = InterviewModel(
        id: 'int_${DateTime.now().millisecondsSinceEpoch}',
        candidateId: candidateId,
        candidateName: cand.name,
        jobTitle: 'Developer',
        interviewType: type,
        date: date,
        time: time,
        interviewers: interviewers,
        mode: mode,
        meetingLink: meetingLink,
        notificationStatus: 'Sent',
      );
      _interviews.add(newInt);
      addNotification('Interview: Scheduled $type for ${cand.name} on $date.');
      notifyListeners();
    }
  }

  void submitInterviewFeedback(String interviewId, InterviewFeedbackModel feedback) {
    final idx = _interviews.indexWhere((i) => i.id == interviewId);
    if (idx != -1) {
      final interview = _interviews[idx];
      interview.feedback = feedback;

      final candIdx = _candidates.indexWhere((c) => c.id == interview.candidateId);
      if (candIdx != -1) {
        final cand = _candidates[candIdx];
        String nextStatus = cand.status;
        if (feedback.recommendation == 'Strong Hire' || feedback.recommendation == 'Hire') {
          nextStatus = 'Offer';
          cand.status = 'Offer';
        } else if (feedback.recommendation == 'Reject') {
          nextStatus = 'Rejected';
          cand.status = 'Rejected';
        }
        cand.timeline.add(TimelineEvent(
          status: nextStatus,
          date: '06-Jun-2026',
          remarks: '${interview.interviewType} feedback score: ${feedback.technicalSkills}/5. Recommend: ${feedback.recommendation}.',
        ));
      }
      notifyListeners();
    }
  }

  // Offer Letter & Negotiation flow
  void releaseOffer({
    required String candidateId,
    required String designation,
    required String department,
    required String location,
    required String joiningDate,
    required String salary,
    required String benefits,
    required String probation,
  }) {
    final candIdx = _candidates.indexWhere((c) => c.id == candidateId);
    if (candIdx != -1) {
      final cand = _candidates[candIdx];
      final newOffer = OfferLetterModel(
        id: 'off_${DateTime.now().millisecondsSinceEpoch}',
        candidateId: candidateId,
        candidateName: cand.name,
        designation: designation,
        department: department,
        location: location,
        joiningDate: joiningDate,
        salary: salary,
        benefits: benefits,
        probationPeriod: probation,
        approvalStatus: 'Pending Approval',
        approvalFlow: ['Manager', 'HR', 'Finance', 'Director'],
        currentApprovalStep: 0,
      );
      _offers.add(newOffer);
      cand.status = 'Offer';
      cand.timeline.add(TimelineEvent(status: 'Offer Released', date: '06-Jun-2026', remarks: 'Offer Letter generated for $designation ($salary)'));
      notifyListeners();
    }
  }

  void approveOffer(String offerId) {
    final idx = _offers.indexWhere((o) => o.id == offerId);
    if (idx != -1) {
      final offer = _offers[idx];
      offer.currentApprovalStep++;
      if (offer.currentApprovalStep == offer.approvalFlow.length) {
        offer.approvalStatus = 'Sent';
        addNotification('Offer: Approved & released to ${offer.candidateName}.');
      } else {
        final next = offer.approvalFlow[offer.currentApprovalStep];
        addNotification('Offer: Approved. Pending step $next.');
      }
      notifyListeners();
    }
  }

  // Offer Negotiations
  void submitNegotiationRequest({
    required String offerId,
    required String proposedSalary,
    required String proposedDate,
    required String remarks,
  }) {
    final offerIdx = _offers.indexWhere((o) => o.id == offerId);
    if (offerIdx != -1) {
      final offer = _offers[offerIdx];
      offer.approvalStatus = 'Negotiating';
      
      final newNeg = OfferNegotiationModel(
        id: 'neg_${DateTime.now().millisecondsSinceEpoch}',
        offerId: offerId,
        candidateName: offer.candidateName,
        originalCtc: offer.salary,
        proposedCtc: proposedSalary,
        originalJoiningDate: offer.joiningDate,
        proposedJoiningDate: proposedDate,
        status: 'Pending Review',
        remarks: remarks,
      );
      _negotiations.add(newNeg);
      addNotification('Offer Negotiation: ${offer.candidateName} requested revision to $proposedSalary.');
      notifyListeners();
    }
  }

  void respondNegotiation(String negId, bool approve) {
    final idx = _negotiations.indexWhere((n) => n.id == negId);
    if (idx != -1) {
      final neg = _negotiations[idx];
      neg.status = approve ? 'Approved' : 'Rejected';

      final offerIdx = _offers.indexWhere((o) => o.id == neg.offerId);
      if (offerIdx != -1) {
        final offer = _offers[offerIdx];
        if (approve) {
          offer.salary = neg.proposedCtc;
          offer.approvalStatus = 'Sent';
          addNotification('Negotiation Approved: Counter offer CTC revised to ${neg.proposedCtc}.');
        } else {
          offer.approvalStatus = 'Sent';
          addNotification('Negotiation Rejected: Candidate offer reverted to original CTC.');
        }
      }
      notifyListeners();
    }
  }

  void signOfferDigitally(String offerId) {
    final idx = _offers.indexWhere((o) => o.id == offerId);
    if (idx != -1) {
      final offer = _offers[idx];
      offer.isDigitallySigned = true;
      offer.approvalStatus = 'Accepted';

      final candIdx = _candidates.indexWhere((c) => c.id == offer.candidateId);
      if (candIdx != -1) {
        final cand = _candidates[candIdx];
        cand.status = 'Joined';
        cand.timeline.add(TimelineEvent(status: 'Offer Accepted', date: '06-Jun-2026', remarks: 'E-Signed Offer accepted. Pre-joining portal active.'));

        // Seed Pre-joining
        _preJoiningPortals.add(PreJoiningPortalModel(
          candidateId: cand.id,
          portalAccessCode: 'PORT-VIK-${DateTime.now().millisecond}',
          uploadedDocuments: {'Aadhar Proof': false, 'PAN Card': false, 'Certificates': false, 'Relieving Letter': false},
          completedForms: {'Personal Details': 'Pending', 'Bank Details': 'Pending', 'Emergency Contact': 'Pending'},
          joiningChecklist: {'Laptop Assigned': false, 'Email Created': false, 'Attendance Created': false, 'Leave Balance Created': false, 'Payroll Setup': false},
        ));
      }
      notifyListeners();
    }
  }

  // Background Verification Update
  void updateBGVCheck(String candidateId, String section, String status) {
    final idx = _bgvChecks.indexWhere((b) => b.candidateId == candidateId);
    if (idx != -1) {
      final bgv = _bgvChecks[idx];
      if (section == 'Employment') bgv.employmentStatus = status;
      if (section == 'Education') bgv.educationStatus = status;
      if (section == 'Identity') bgv.identityStatus = status;
      bgv.remarks = 'Updated $section check to $status.';
      notifyListeners();
    }
  }

  // Pre-joining checklist verification
  void updatePreJoiningDoc(String candidateId, String docName, bool isUploaded) {
    final idx = _preJoiningPortals.indexWhere((p) => p.candidateId == candidateId);
    if (idx != -1) {
      _preJoiningPortals[idx].uploadedDocuments[docName] = isUploaded;
      notifyListeners();
    }
  }

  void verifyPreJoiningChecklist(String candidateId, String taskName, bool isChecked) {
    final idx = _preJoiningPortals.indexWhere((p) => p.candidateId == candidateId);
    if (idx != -1) {
      final p = _preJoiningPortals[idx];
      p.joiningChecklist[taskName] = isChecked;
      if (taskName == 'Laptop Assigned') p.isAssetsAllocated = isChecked;
      if (taskName == 'Email Created') p.isEmailCreated = isChecked;
      notifyListeners();
    }
  }

  // Final onboarding employee creation
  void completeJoiningAndOnboard(String candidateId, String dept, String roleId, String managerName) {
    final candIdx = _candidates.indexWhere((c) => c.id == candidateId);
    if (candIdx != -1) {
      final cand = _candidates[candIdx];
      cand.status = 'Joined';
      cand.timeline.add(TimelineEvent(status: 'Onboarded', date: '06-Jun-2026', remarks: 'Marked Joined. Employee records registered.'));

      final empId = 'emp_${cand.name.toLowerCase().replaceAll(" ", "_")}_${DateTime.now().millisecond}';
      final newEmp = EmployeeModel(
        id: empId,
        name: cand.name,
        roleId: roleId,
        dept: dept,
        extraPermissions: [],
        restrictedPermissions: [],
      );

      final newProfile = EmployeeProfileModel(
        employeeId: empId,
        photoUrl: '',
        firstName: cand.name.split(' ').first,
        middleName: '',
        lastName: cand.name.split(' ').length > 1 ? cand.name.split(' ').last : '',
        gender: cand.personalInfo['Gender'] ?? 'Male',
        dob: cand.personalInfo['DOB'] ?? '01-Jan-2000',
        bloodGroup: 'B+',
        maritalStatus: 'Single',
        nationality: 'Indian',
        religion: 'Hindu',
        aadharNumber: '123456789012',
        panNumber: 'ABCDE1234F',
        passportNumber: '',
        drivingLicenseNumber: '',
        mobileNumber: cand.mobile,
        alternateMobile: '',
        personalEmail: cand.email,
        officialEmail: '${cand.name.toLowerCase().replaceAll(" ", ".")}@abcpvtltd.com',
        employeeCode: 'EMP-${DateTime.now().millisecond}',
        biometricId: 'BIO-${DateTime.now().millisecond}',
        faceRegistrationStatus: 'Registered',
        addressDetails: AddressDetails(
          currentLine1: 'Satellite',
          currentLine2: '',
          currentCity: 'Ahmedabad',
          currentState: 'Gujarat',
          currentCountry: 'India',
          currentPincode: '380015',
          permanentLine1: 'Satellite',
          permanentLine2: '',
          permanentCity: 'Ahmedabad',
          permanentState: 'Gujarat',
          permanentCountry: 'India',
          permanentPincode: '380015',
          isPermanentSameAsCurrent: true,
        ),
        educationRecords: [],
        experienceRecords: [
          ExperienceRecord(
            companyName: cand.currentCompany,
            designation: 'Flutter Developer',
            department: 'Engineering',
            industry: 'IT',
            joiningDate: '01-Jan-2024',
            relievingDate: '05-Jun-2026',
            totalExperience: '2.5 Years',
            currentSalary: cand.currentSalary,
            reasonForLeaving: 'Better Opportunity',
            attachedDoc: 'experience_letter.pdf',
          )
        ],
        familyMembers: [],
        emergencyContacts: [
          EmergencyContact(
            name: 'Emergency Contact',
            relation: 'Relative',
            mobileNumber: '9000000000',
            alternateNumber: '',
            address: 'Ahmedabad',
          )
        ],
        bankDetails: BankDetails(
          accountHolderName: cand.name,
          bankName: 'SBI Bank',
          accountNumber: '12345678901',
          ifscCode: 'SBIN0001234',
          branchName: 'Ahmedabad',
          upiId: '${cand.name.toLowerCase().replaceAll(" ", "")}@oksbi',
        ),
        assignedAssets: [],
        attendanceSummary: AttendanceSummary(presentDays: 0, absentDays: 0, leaveDays: 0, lateDays: 0, otHours: 0.0, currentMonthHours: 0.0),
        leaveSummary: LeaveSummary(availableLeave: 12, usedLeave: 0, pendingRequests: 0, approvedRequests: 0),
        payrollSummary: PayrollSummary(currentSalary: '50000', ctc: cand.expectedSalary, lastPayslip: 'N/A', taxDetails: 'New Tax Regime'),
        documents: [],
        settings: ProfileSettings(
          changePassword: false,
          changePin: false,
          enableBiometric: true,
          enableFaceLogin: true,
          attendanceNotifications: true,
          approvalNotifications: true,
          leaveNotifications: true,
          payrollNotifications: true,
          profileVisibility: 'Public',
          contactVisibility: 'Public',
          documentVisibility: 'Private',
        ),
        timelineActivities: [
          TimelineActivity(title: 'Onboarded', description: 'Onboarded via Recruitment ATS', timestamp: '06-Jun-2026 12:00 PM', category: 'General')
        ],
      );

      RolePermissionHelper.instance.addEmployee(newEmp);
      RolePermissionHelper.instance.addEmployeeProfile(newProfile);
      addNotification('Onboarding: Created Employee Profile: ${cand.name}. setup basic payroll, leave balance and attendance accounts.');
      notifyListeners();
    }
  }

  // Campus Hiring
  void addCampusEvent({
    required String college,
    required String position,
    required int registered,
    required String contact,
  }) {
    final event = CampusHiringModel(
      id: 'c_${DateTime.now().millisecondsSinceEpoch}',
      collegeName: college,
      positionTitle: position,
      registeredCount: registered,
      shortListedCount: (registered * 0.15).toInt(),
      offersReleasedCount: 0,
      contactPerson: contact,
      status: 'Scheduled',
    );
    _campusEvents.add(event);
    notifyListeners();
  }

  // Referrals
  void submitReferral({
    required String name,
    required String position,
    required String resume,
    required String referrer,
  }) {
    final newRef = ReferralModel(
      id: 'ref_${DateTime.now().millisecondsSinceEpoch}',
      candidateName: name,
      positionTitle: position,
      resumeName: resume,
      referredBy: referrer,
      status: 'Applied',
      bonusStatus: 'Pending',
      bonusAmount: 12000,
    );
    _referrals.add(newRef);
    notifyListeners();
  }
}
