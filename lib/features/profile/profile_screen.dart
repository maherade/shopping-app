import 'package:flutter/material.dart';
import 'package:shopping_app_task/features/profile/widgets/profile_screen_body.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.onSelectTab});

  final ValueChanged<int> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return ProfileScreenBody(onSelectTab: onSelectTab);
  }
}
