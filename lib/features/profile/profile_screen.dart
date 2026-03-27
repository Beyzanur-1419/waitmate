import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Profil',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, fontSize: 17,
                color: AppColors.textPrimary)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_rounded, color: Colors.white, size: 50),
            ),
            const SizedBox(height: 12),
            Text('Alex Thompson',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            Text('alex.waitmate@ornek.com',
                style: GoogleFonts.poppins(
                    fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 28),
            // Settings list
            _settingTile(context, Icons.notifications_rounded, 'Push Bildirimleri', trailing: Switch(value: true, onChanged: (_) {}, activeColor: AppColors.primary)),
            _settingTile(context, Icons.language_rounded, 'Dil', trailing: Text('Türkçe', style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13))),
            const Divider(height: 32),
            _settingTile(context, Icons.privacy_tip_outlined, 'Gizlilik Politikası'),
            _settingTile(context, Icons.help_outline_rounded, 'Yardım & Destek'),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () async {
                await AuthService().logout();
                if (context.mounted) context.go('/login');
              },
              icon: const Icon(Icons.logout_rounded, color: AppColors.error),
              label: Text('Çıkış Yap',
                  style: GoogleFonts.poppins(color: AppColors.error, fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingTile(BuildContext ctx, IconData icon, String label, {Widget? trailing}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(label,
          style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary)),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
    );
  }
}
