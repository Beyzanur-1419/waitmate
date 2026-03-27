import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/models.dart';
import '../../services/mock_data_service.dart';

class DepartmentsScreen extends StatefulWidget {
  final String facilityId;
  const DepartmentsScreen({super.key, required this.facilityId});

  @override
  State<DepartmentsScreen> createState() => _DepartmentsScreenState();
}

class _DepartmentsScreenState extends State<DepartmentsScreen> {
  late FacilityModel _facility;
  DepartmentModel? _selectedDept;

  @override
  void initState() {
    super.initState();
    _facility = MockDataService.facilities
        .firstWhere((f) => f.id == widget.facilityId);
    if (_facility.departments.isNotEmpty) {
      _selectedDept = _facility.departments.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(_facility.name,
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Facility header card
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    color: AppColors.textSecondary, size: 16),
                const SizedBox(width: 4),
                Text(_facility.address,
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: AppColors.textSecondary)),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (_facility.isOpen ? AppColors.queueActive : AppColors.queueClosed)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _facility.isOpen ? 'AÇIK' : 'KAPALI',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _facility.isOpen
                          ? AppColors.queueActive
                          : AppColors.queueClosed,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Departments horizontal scroll
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 0, 8),
            child: Text('Bölümler',
                style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
          ),
          SizedBox(
            height: 86,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _facility.departments.length,
              itemBuilder: (ctx, i) {
                final dept = _facility.departments[i];
                final isSelected = _selectedDept?.id == dept.id;
                return GestureDetector(
                  onTap: () => setState(() => _selectedDept = dept),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(dept.icon, style: const TextStyle(fontSize: 22)),
                        const SizedBox(height: 4),
                        Text(
                          dept.name,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Staff list
          if (_selectedDept != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Row(
                children: [
                  Text('Personel',
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  const Spacer(),
                  Text('${_selectedDept!.staff.length} kişi',
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Expanded(
              child: _selectedDept!.staff.isEmpty
                  ? Center(
                      child: Text('Bu bölümde personel bulunmuyor.',
                          style: GoogleFonts.poppins(
                              color: AppColors.textSecondary)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _selectedDept!.staff.length,
                      itemBuilder: (ctx, i) =>
                          _StaffCard(staff: _selectedDept!.staff[i]),
                    ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StaffCard extends StatelessWidget {
  final StaffModel staff;
  const _StaffCard({required this.staff});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_rounded,
                  color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(staff.name,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600, fontSize: 14,
                          color: AppColors.textPrimary)),
                  Text(staff.title,
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFFFA000), size: 14),
                      Text(' ${staff.rating}',
                          style: GoogleFonts.poppins(
                              fontSize: 12, fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary)),
                      const SizedBox(width: 8),
                      const Icon(Icons.people_rounded,
                          color: AppColors.textSecondary, size: 14),
                      Text(' ${staff.currentQueueLength} sırada',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(width: 8),
                      const Icon(Icons.access_time_rounded,
                          color: AppColors.textSecondary, size: 14),
                      Text(' ~${staff.estimatedWaitMinutes} dk',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: (staff.isAvailable
                        ? AppColors.queueActive
                        : AppColors.queueClosed)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                staff.isAvailable ? 'UYGUN' : 'MEŞGUL',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: staff.isAvailable
                      ? AppColors.queueActive
                      : AppColors.queueClosed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
