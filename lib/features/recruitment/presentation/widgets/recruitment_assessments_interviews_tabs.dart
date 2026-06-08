import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/core/constants/app_colors.dart';
import 'package:gitakshmi_hrms_app/core/helpers/recruitment_helper.dart';
import 'package:gitakshmi_hrms_app/core/widgets/dropdown/app_dropdown_field.dart';
import 'package:gitakshmi_hrms_app/core/widgets/textfield/app_text_field.dart';

class RecruitmentAssessmentsTab extends StatelessWidget {
  final RecruitmentHelper rHelper;
  final Color primaryColor;

  const RecruitmentAssessmentsTab({
    super.key,
    required this.rHelper,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rHelper.assessments.length,
      itemBuilder: (context, index) {
        final ass = rHelper.assessments[index];
        final isPass = ass.resultStatus == 'Pass';
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isPass ? Colors.green.shade50 : Colors.red.shade50,
              child: Icon(isPass ? Icons.check : Icons.close, color: isPass ? Colors.green : Colors.red),
            ),
            title: Text(ass.candidateName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Test: ${ass.testType} • Duration: ${ass.durationMinutes} Mins'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${ass.score}/100', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isPass ? Colors.green : Colors.red)),
                Text(ass.resultStatus, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isPass ? Colors.green : Colors.red)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class RecruitmentInterviewsTab extends StatefulWidget {
  final RecruitmentHelper rHelper;
  final Color primaryColor;

  const RecruitmentInterviewsTab({
    super.key,
    required this.rHelper,
    required this.primaryColor,
  });

  @override
  State<RecruitmentInterviewsTab> createState() => _RecruitmentInterviewsTabState();
}

class _RecruitmentInterviewsTabState extends State<RecruitmentInterviewsTab> {
  final _interviewFormKey = GlobalKey<FormState>();
  final _feedbackFormKey = GlobalKey<FormState>();

  String? _intCandId;
  String _intType = 'Technical';
  String _intDate = '08-Jun-2026';
  String _intTime = '11:00 AM';
  final _intInterviewersController = TextEditingController(text: 'Riya Sharma, Alok Mishra');
  String _intMode = 'Online';
  String _intMeetLink = 'https://meet.google.com/xyz-pdqr-abc';

  double _feedTech = 4.0;
  double _feedComm = 4.0;
  double _feedProblem = 4.0;
  final double _feedAttitude = 4.0;
  final double _feedDomain = 4.0;
  String _feedRecommend = 'Hire';
  final _feedCommentsController = TextEditingController();

  @override
  void dispose() {
    _intInterviewersController.dispose();
    _feedCommentsController.dispose();
    super.dispose();
  }

  void _openScheduleInterviewDialog() {
    final eligibleCands = widget.rHelper.candidates.where((c) => c.status == 'Screening' || c.status == 'Technical Round' || c.status == 'Manager Round').toList();
    if (eligibleCands.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No qualified screened candidates available to interview.')),
      );
      return;
    }
    _intCandId = eligibleCands.first.id;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Schedule Panel Interview', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Form(
                  key: _interviewFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppDropdownField<String>(
                  labelText: 'Candidate',
                  value: _intCandId,
                  items: eligibleCands.map((c) {
                          return DropdownMenuItem(value: c.id, child: Text(c.name));
                        }).toList(),
                  onChanged: (val) {
                          if (val != null) setDialogState(() => _intCandId = val);
                        },
                ),
                      const SizedBox(height: 10),
                      AppDropdownField<String>(
                  labelText: 'Interview Round',
                  value: _intType,
                  items: ['Technical', 'Managerial', 'HR', 'Final'].map((t) {
                          return DropdownMenuItem(value: t, child: Text(t));
                        }).toList(),
                  onChanged: (val) {
                          if (val != null) setDialogState(() => _intType = val);
                        },
                ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Panel Interviewers (Comma separated)'),
                        controller: _intInterviewersController,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(labelText: 'Date (e.g. 08-Jun-2026)'),
                              onChanged: (v) => _intDate = v,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(labelText: 'Time (e.g. 11:00 AM)'),
                              onChanged: (v) => _intTime = v,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      AppDropdownField<String>(
                  labelText: 'Interview Mode',
                  value: _intMode,
                  items: ['Online', 'Offline', 'Telephonic'].map((m) {
                          return DropdownMenuItem(value: m, child: Text(m));
                        }).toList(),
                  onChanged: (val) {
                          if (val != null) setDialogState(() => _intMode = val);
                        },
                ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Meeting Link (Google Meet/Zoom)'),
                        onChanged: (v) => _intMeetLink = v,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    widget.rHelper.scheduleInterview(
                      candidateId: _intCandId!,
                      type: _intType,
                      date: _intDate,
                      time: _intTime,
                      interviewers: _intInterviewersController.text.split(','),
                      mode: _intMode,
                      meetingLink: _intMeetLink,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Schedule Loop'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _openFeedbackFormDialog(InterviewModel interview) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text('Feedback: ${interview.candidateName}', style: const TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Form(
                  key: _feedbackFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Technical Score:'),
                          DropdownButton<double>(
                            value: _feedTech,
                            items: [1.0, 2.0, 3.0, 4.0, 5.0].map((v) => DropdownMenuItem(value: v, child: Text(v.toString()))).toList(),
                            onChanged: (val) {
                              if (val != null) setDialogState(() => _feedTech = val);
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Communication:'),
                          DropdownButton<double>(
                            value: _feedComm,
                            items: [1.0, 2.0, 3.0, 4.0, 5.0].map((v) => DropdownMenuItem(value: v, child: Text(v.toString()))).toList(),
                            onChanged: (val) {
                              if (val != null) setDialogState(() => _feedComm = val);
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Problem Solving:'),
                          DropdownButton<double>(
                            value: _feedProblem,
                            items: [1.0, 2.0, 3.0, 4.0, 5.0].map((v) => DropdownMenuItem(value: v, child: Text(v.toString()))).toList(),
                            onChanged: (val) {
                              if (val != null) setDialogState(() => _feedProblem = val);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      AppDropdownField<String>(
                  labelText: 'Final Verdict',
                  value: _feedRecommend,
                  items: ['Strong Hire', 'Hire', 'Hold', 'Reject'].map((r) {
                          return DropdownMenuItem(value: r, child: Text(r));
                        }).toList(),
                  onChanged: (val) {
                          if (val != null) setDialogState(() => _feedRecommend = val);
                        },
                ),
                      const SizedBox(height: 10),
                      AppTextField(
                  controller: _feedCommentsController,
                  labelText: 'Detailed Comments',
                ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    widget.rHelper.submitInterviewFeedback(
                      interview.id,
                      InterviewFeedbackModel(
                        technicalSkills: _feedTech,
                        communication: _feedComm,
                        problemSolving: _feedProblem,
                        attitude: _feedAttitude,
                        domainKnowledge: _feedDomain,
                        recommendation: _feedRecommend,
                        comments: _feedCommentsController.text,
                      ),
                    );
                    Navigator.pop(context);
                    _feedCommentsController.clear();
                  },
                  child: const Text('Submit Feedback'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            icon: const Icon(Icons.video_call_rounded, color: Colors.white),
            label: const Text('Schedule Interview Panel Loop', style: TextStyle(color: Colors.white)),
            onPressed: _openScheduleInterviewDialog,
          ),
        ),
        const Divider(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.rHelper.interviews.length,
            itemBuilder: (context, index) {
              final interview = widget.rHelper.interviews[index];
              final isCompleted = interview.feedback != null;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(interview.candidateName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isCompleted ? Colors.green.shade50 : Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isCompleted ? 'Completed' : 'Scheduled',
                              style: TextStyle(color: isCompleted ? Colors.green : Colors.blue, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Round: ${interview.interviewType} • ${interview.date} at ${interview.time}'),
                      Text('Panel Members: ${interview.interviewers.join(", ")}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      Text('Mode: ${interview.mode}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(height: 8),
                      if (!isCompleted) ...[
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.link_rounded, size: 14, color: Colors.white),
                                label: const Text('Join Meet Call', style: TextStyle(fontSize: 12, color: Colors.white)),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Launching URL: ${interview.meetingLink}')),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(side: BorderSide(color: widget.primaryColor)),
                                icon: Icon(Icons.feedback_rounded, size: 14, color: widget.primaryColor),
                                label: Text('Submit Feedback', style: TextStyle(fontSize: 12, color: widget.primaryColor)),
                                onPressed: () => _openFeedbackFormDialog(interview),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Recommendation: ${interview.feedback!.recommendation}', style: TextStyle(fontWeight: FontWeight.bold, color: widget.primaryColor, fontSize: 12)),
                              Text('Score: ${interview.feedback!.technicalSkills}/5 Tech, ${interview.feedback!.communication}/5 Comm', style: const TextStyle(fontSize: 11)),
                              Text('Comments: "${interview.feedback!.comments}"', style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
