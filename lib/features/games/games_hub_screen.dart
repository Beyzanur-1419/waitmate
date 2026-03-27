import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

class GamesHubScreen extends StatelessWidget {
  const GamesHubScreen({super.key});

  static const _games = [
    {'title': 'Hafıza Eşleştirme', 'desc': 'Kartları eşleştir, beynini çalıştır', 'icon': '🧠', 'color': Color(0xFF4A148C)},
    {'title': 'Bulmaca', 'desc': 'Sayıları çöz, zihni geliştir', 'icon': '🧩', 'color': Color(0xFF1565C0)},
    {'title': 'Tepki Testi', 'desc': 'Reflekslerini test et', 'icon': '⚡', 'color': Color(0xFF00695C)},
    {'title': 'Kelime Arama', 'desc': 'Gizli kelimeleri bul', 'icon': '🔤', 'color': Color(0xFFE65100)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('WaitMate Oyunları',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, fontSize: 17,
                color: AppColors.textPrimary)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Beklerken Eğlen',
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.w700,
                          fontSize: 18)),
                  Text('Sıranı beklerken mini oyunlarla vakit geçir',
                      style: GoogleFonts.poppins(
                          color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _statBadge('24d', 'Harcanan Süre'),
                      const SizedBox(width: 16),
                      _statBadge('12', 'Kazanılan Oyun'),
                      const SizedBox(width: 16),
                      _statBadge('1.420', 'Skor'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Tüm Oyunlar',
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
            Text('${_games.length} oyun mevcut',
                style: GoogleFonts.poppins(
                    fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.1,
              ),
              itemCount: _games.length,
              itemBuilder: (ctx, i) {
                final g = _games[i];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: (g['color'] as Color).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(g['icon'] as String,
                              style: const TextStyle(fontSize: 22)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(g['title'] as String,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, fontSize: 13,
                              color: AppColors.textPrimary)),
                      Text(g['desc'] as String,
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: AppColors.textSecondary),
                          maxLines: 2),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 32,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              textStyle: GoogleFonts.poppins(fontSize: 12)),
                          child: const Text('Oyna'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _statBadge(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
        Text(label,
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 10)),
      ],
    );
  }
}
