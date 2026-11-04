import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../auth/domain/entities/profile_entity.dart';

class ProfileDetailsCard extends StatelessWidget {
  const ProfileDetailsCard({super.key, required this.profile});
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Account details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            ProfileDetailRow(label: 'First name', value: profile.firstName),
            ProfileDetailRow(label: 'Last name', value: profile.lastName),
            ProfileDetailRow(label: 'E-Mail', value: profile.email),
            ProfileDetailRow(label: 'Gender', value: profile.gender),
          ],
        ),
      ),
    );
  }
}

/// Shows a labeled profile value.
class ProfileDetailRow extends StatelessWidget {
  /// Creates the profile detail row.
  const ProfileDetailRow({super.key, required this.label, required this.value});
  final String label, value;

  /// Builds a labeled profile value.
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            value.isEmpty ? 'Not provided' : value,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
