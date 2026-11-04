import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopping_app_task/features/profile/widgets/profile_details_card.dart';
import 'package:shopping_app_task/features/profile/widgets/profile_summary_card.dart';
import '../../auth/controller/auth_cubit/auth_cubit.dart';

class ProfileScreenBody extends StatelessWidget {
  const ProfileScreenBody({super.key, required this.onSelectTab});
  final ValueChanged<int> onSelectTab;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthCubit>();
    final profile = auth.session?.profile;
    if (profile == null) return const SizedBox.shrink();
    return SafeArea(
      bottom: false,
      child: Center(
        child: SizedBox(
          width: 700.w,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            children: [
              /// profile card
              ProfileSummaryCard(profile: profile, offline: auth.offline),
              SizedBox(height: 20.h),

              /// user details
              ProfileDetailsCard(profile: profile),
            ],
          ),
        ),
      ),
    );
  }
}
