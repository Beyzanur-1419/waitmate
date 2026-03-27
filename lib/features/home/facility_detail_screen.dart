import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/models.dart';
import '../../services/mock_data_service.dart';

class FacilityDetailScreen extends StatelessWidget {
  final String facilityId;
  const FacilityDetailScreen({super.key, required this.facilityId});

  @override
  Widget build(BuildContext context) {
    final facility = MockDataService.facilities
        .firstWhere((f) => f.id == facilityId);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(facility.name,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.push('/departments/$facilityId'),
          child: const Text('Bölümleri Gör'),
        ),
      ),
    );
  }
}
