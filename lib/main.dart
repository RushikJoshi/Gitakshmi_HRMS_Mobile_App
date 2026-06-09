import 'package:flutter/material.dart';
import 'package:gitakshmi_hrms_app/app/app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  runApp(const App());
}
