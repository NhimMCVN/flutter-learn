import 'package:cached_network_image/cached_network_image.dart';
import '../../../../utils/image_error_listener.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

class TitleCards extends StatelessWidget {
  const TitleCards({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: const AspectRatio(
        aspectRatio: 1,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              child: _Card(
                imageUrl: 'https://rstr.in/google/tripedia/g2i0BsYPKW-',
                width: 200,
                height: 273,
                titl: -3.83 / 360,
              ),
            ),
            Positioned(
              child: _Card(
                imageUrl: 'https://rstr.in/google/tripedia/980sqNgaDRK',
                width: 180,
                height: 230,
                titl: 3.46 / 360,
              ),
            ),
            Positioned(
              child: _Card(
                imageUrl: 'https://rstr.in/google/tripedia/pHfPmf3o5NU',
                width: 225,
                height: 322,
                titl: 0,
                showTitle: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final double titl;
  final double width;
  final double height;
  final String imageUrl;
  final bool showTitle;

  const _Card({
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.titl,
    this.showTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: AlwaysStoppedAnimation(titl),
      child: SizedBox(
        width: width,
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                color: showTitle ? Colors.black.withValues(alpha: 0.5) : null,
                colorBlendMode: showTitle ? BlendMode.darken : null,
                errorListener: imageErrorListener,
              ),
              if (showTitle) Center(child: SvgPicture.asset("assets/logo.svg")),
            ],
          ),
        ),
      ),
    );
  }
}
