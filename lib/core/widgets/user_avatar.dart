import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.imageUrl, required this.size});
  final String imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    Widget placeholder() => ColoredBox(
      color: colors.primaryContainer,
      child: Center(
        child: Icon(
          Icons.person_outline_rounded,
          size: size * .6,
          color: colors.onPrimaryContainer,
        ),
      ),
    );
    return ClipOval(
      child: SizedBox.square(
        dimension: size,
        child: imageUrl.isEmpty
            ? placeholder()
            : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => placeholder(),
                errorWidget: (context, url, error) => placeholder(),
              ),
      ),
    );
  }
}
