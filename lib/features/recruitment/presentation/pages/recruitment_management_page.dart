import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/role_permission_helper.dart';
import 'package:gitakshmi_hrms_app/core/helpers/saas_branding_helper.dart';
import 'package:gitakshmi_hrms_app/core/helpers/recruitment_helper.dart';
import 'package:gitakshmi_hrms_app/features/recruitment/presentation/widgets/recruitment_dashboard_workforce_tabs.dart';
import 'package:gitakshmi_hrms_app/features/recruitment/presentation/widgets/recruitment_requisition_openings_tabs.dart';
import 'package:gitakshmi_hrms_app/features/recruitment/presentation/widgets/recruitment_pipeline_screening_tabs.dart';
import 'package:gitakshmi_hrms_app/features/recruitment/presentation/widgets/recruitment_assessments_interviews_tabs.dart';
import 'package:gitakshmi_hrms_app/features/recruitment/presentation/widgets/recruitment_offers_preboarding_tabs.dart';
import 'package:gitakshmi_hrms_app/features/recruitment/presentation/widgets/recruitment_campus_referrals_pool_tabs.dart';

class RecruitmentManagementPage extends StatefulWidget {
  const RecruitmentManagementPage({super.key});

  @override
  State<RecruitmentManagementPage> createState() => _RecruitmentManagementPageState();
}

class _RecruitmentManagementPageState extends State<RecruitmentManagementPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 13, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final helper = RolePermissionHelper.instance;
    final rHelper = RecruitmentHelper.instance;

    return AnimatedBuilder(
      animation: Listenable.merge([helper, rHelper]),
      builder: (context, _) {
        final config = SaaSBrandingHelper.instance.configNotifier.value;
        final primaryColor = config.primaryColor;
        final activeEmp = helper.activeEmployee;

        // Role configurations
        final isHR = activeEmp.roleId == 'r_hr' || activeEmp.roleId == 'r_admin';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Talent Acquisition Suite'),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: primaryColor,
              labelColor: primaryColor,
              unselectedLabelColor: AppColors.textSecondary,
              tabs: const [
                Tab(icon: Icon(Icons.analytics_rounded), text: 'Dashboard'),
                Tab(icon: Icon(Icons.calendar_view_month_rounded), text: 'Workforce Plan'),
                Tab(icon: Icon(Icons.assignment_ind_rounded), text: 'Requisitions'),
                Tab(icon: Icon(Icons.work_rounded), text: 'Job Openings'),
                Tab(icon: Icon(Icons.dashboard_customize_rounded), text: 'Pipeline (Kanban)'),
                Tab(icon: Icon(Icons.rate_review_rounded), text: 'Screening'),
                Tab(icon: Icon(Icons.quiz_rounded), text: 'Assessments'),
                Tab(icon: Icon(Icons.event_note_rounded), text: 'Interviews'),
                Tab(icon: Icon(Icons.description_rounded), text: 'Offer & Negotiate'),
                Tab(icon: Icon(Icons.security_rounded), text: 'Preboarding & BGV'),
                Tab(icon: Icon(Icons.school_rounded), text: 'Campus Hiring'),
                Tab(icon: Icon(Icons.share_rounded), text: 'Referrals'),
                Tab(icon: Icon(Icons.folder_shared_rounded), text: 'Talent Pool'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              RecruitmentDashboardTab(
                rHelper: rHelper,
                primaryColor: primaryColor,
              ),
              RecruitmentWorkforceTab(
                rHelper: rHelper,
                primaryColor: primaryColor,
              ),
              RecruitmentRequisitionTab(
                rHelper: rHelper,
                activeEmp: activeEmp,
                primaryColor: primaryColor,
              ),
              RecruitmentOpeningsTab(
                rHelper: rHelper,
                primaryColor: primaryColor,
              ),
              RecruitmentPipelineTab(
                rHelper: rHelper,
                primaryColor: primaryColor,
              ),
              RecruitmentScreeningTab(
                rHelper: rHelper,
                isHR: isHR,
                primaryColor: primaryColor,
              ),
              RecruitmentAssessmentsTab(
                rHelper: rHelper,
                primaryColor: primaryColor,
              ),
              RecruitmentInterviewsTab(
                rHelper: rHelper,
                primaryColor: primaryColor,
              ),
              RecruitmentOffersTab(
                rHelper: rHelper,
                activeEmp: activeEmp,
                primaryColor: primaryColor,
              ),
              RecruitmentPreboardingTab(
                rHelper: rHelper,
                primaryColor: primaryColor,
              ),
              RecruitmentCampusTab(
                rHelper: rHelper,
                primaryColor: primaryColor,
              ),
              RecruitmentReferralTab(
                rHelper: rHelper,
                primaryColor: primaryColor,
              ),
              RecruitmentTalentPoolTab(
                rHelper: rHelper,
                primaryColor: primaryColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
