import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiburo_app/core/theme/app_colors.dart';
import 'package:jiburo_app/core/theme/app_fonts.dart';
import 'package:jiburo_app/core/views/widgets/dividing-line/dividing_line.dart';
import 'package:jiburo_app/models/search_location_model.dart';

class LocationCard extends StatelessWidget {
  final SearchLocationModel location;
  final Function() onTap;
  const LocationCard({super.key, required this.location, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3),
            child: Row(
              spacing: 8,
              children: [
                SvgPicture.asset('assets/images/icons/ic_Location.svg'),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(location.locationName, style: AppFonts.b2nM),
                    Text(
                      '${location.distance}km · ${location.foundLocation}',
                      style: AppFonts.c1R.copyWith(color: AppColors.neutral60),
                    ),
                  ],
                ),
              ],
            ),
          ),
          DividingLine(margin: 8),
        ],
      ),
    );
  }
}
