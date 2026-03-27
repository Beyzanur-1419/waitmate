import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../models/models.dart';
import '../../services/mock_data_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  bool _onlyOpen = false;

  List<FacilityModel> get _filtered {
    var list = MockDataService.facilities;
    if (_searchQuery.isNotEmpty) {
      list = list
          .where((f) =>
              f.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              f.address.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    if (_onlyOpen) list = list.where((f) => f.isOpen).toList();
    return list;
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'belediye': return 'Belediye';
      case 'banka': return 'Banka';
      case 'ptt': return 'PTT';
      case 'noter': return 'Noter';
      default: return type;
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'belediye': return Icons.account_balance_rounded;
      case 'banka': return Icons.credit_card_rounded;
      case 'ptt': return Icons.local_post_office_rounded;
      case 'noter': return Icons.gavel_rounded;
      default: return Icons.business_rounded;
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [_buildFacilitiesPage(), _buildQueuePage(), _buildGamesPage(), _buildProfilePage()];
    return Scaffold(
      backgroundColor: AppColors.background,
      body: pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16)],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (i) {
            if (i == 1) { context.push('/queue'); return; }
            if (i == 2) { context.push('/games'); return; }
            if (i == 3) { context.push('/profile'); return; }
            setState(() => _selectedIndex = i);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Tesisler'),
            BottomNavigationBarItem(icon: Icon(Icons.queue_rounded), label: 'Kuyruk'),
            BottomNavigationBarItem(icon: Icon(Icons.sports_esports_rounded), label: 'Oyunlar'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profil'),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilitiesPage() {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Text(AppStrings.appName,
                    style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined,
                      color: AppColors.textPrimary),
                  onPressed: () => context.push('/notifications'),
                ),
              ],
            ),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColors.textSecondary, size: 22),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.tune_rounded,
                    color: _onlyOpen ? AppColors.primary : AppColors.textSecondary,
                  ),
                  onPressed: () => setState(() => _onlyOpen = !_onlyOpen),
                  tooltip: 'Sadece açık olanlar',
                ),
              ),
            ),
          ),
          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _chip('Top Puanlı', Icons.star_rounded),
                const SizedBox(width: 8),
                _chip('Şu An Açık', Icons.access_time_rounded, active: _onlyOpen,
                    onTap: () => setState(() => _onlyOpen = !_onlyOpen)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Row(
              children: [
                Text(AppStrings.nearbyFacilities,
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const Spacer(),
                Text('${_filtered.length} tesis',
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
          ),
          // List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: _filtered.length,
              itemBuilder: (ctx, i) => _FacilityCard(
                facility: _filtered[i],
                typeLabel: _typeLabel(_filtered[i].type),
                typeIcon: _typeIcon(_filtered[i].type),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, IconData icon,
      {bool active = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: active ? AppColors.primary : AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14,
                color: active ? Colors.white : AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: active ? Colors.white : AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildQueuePage() => const Center(child: Text('Kuyruk'));
  Widget _buildGamesPage() => const Center(child: Text('Oyunlar'));
  Widget _buildProfilePage() => const Center(child: Text('Profil'));
}

class _FacilityCard extends StatelessWidget {
  final FacilityModel facility;
  final String typeLabel;
  final IconData typeIcon;

  const _FacilityCard({
    required this.facility,
    required this.typeLabel,
    required this.typeIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(typeIcon, color: AppColors.primary, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(facility.name,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: AppColors.textPrimary)),
                      Text(facility.address,
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: facility.isOpen
                        ? AppColors.queueActive.withOpacity(0.1)
                        : AppColors.queueClosed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    facility.isOpen ? AppStrings.openNow : AppStrings.closed,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: facility.isOpen
                          ? AppColors.queueActive
                          : AppColors.queueClosed,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.star_rounded,
                    color: Color(0xFFFFA000), size: 16),
                const SizedBox(width: 4),
                Text(facility.rating.toStringAsFixed(1),
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary)),
                const SizedBox(width: 12),
                const Icon(Icons.access_time_rounded,
                    color: AppColors.textSecondary, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${facility.estimatedWaitMinutes} ${AppStrings.minutesWait}',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.meeting_room_outlined,
                    color: AppColors.textSecondary, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${facility.departments.length} bölüm',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () =>
                    context.push('/departments/${facility.id}'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 40),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: Text(AppStrings.viewDepartments,
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
