import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/models.dart';

class QueueScreen extends StatefulWidget {
  const QueueScreen({super.key});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  QueueEntryModel? _activeQueue;
  Timer? _timer;

  // Simulated queue entry for demo
  final QueueEntryModel _demoQueue = QueueEntryModel(
    id: 'q1',
    userId: 'u1',
    staffId: 's1',
    staffName: 'Ahmet Yılmaz',
    facilityName: 'Beşiktaş Belediyesi',
    departmentName: 'Vatandaş Hizmetleri',
    position: 5,
    estimatedWaitMinutes: 14,
    status: 'waiting',
    joinedAt: DateTime.now().subtract(const Duration(minutes: 6)),
  );

  @override
  void initState() {
    super.initState();
    _activeQueue = _demoQueue;
    // Simulate real-time queue count decrement every 8 seconds
    _timer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (_activeQueue != null && _activeQueue!.position > 1) {
        setState(() {
          _activeQueue!.position--;
          _activeQueue!.estimatedWaitMinutes =
              (_activeQueue!.position * 2.8).round();
          if (_activeQueue!.position <= 1) {
            _activeQueue!.status = 'called';
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Sıra Durumum',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, fontSize: 17,
                color: AppColors.textPrimary)),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: _activeQueue == null
          ? _buildNoQueue()
          : _buildActiveQueue(_activeQueue!),
    );
  }

  Widget _buildNoQueue() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.queue_rounded,
                color: AppColors.primary, size: 50),
          ),
          const SizedBox(height: 20),
          Text('Aktif sıranız yok',
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text('Bir tesise gidip kuyruğa katılabilirsiniz.',
              style: GoogleFonts.poppins(
                  fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Tesis Bul'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveQueue(QueueEntryModel q) {
    final isCalled = q.status == 'called';
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Status card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isCalled
                    ? [AppColors.queueActive, const Color(0xFF66BB6A)]
                    : [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  isCalled ? '🎉 Sıranız Geldi!' : 'Sıra Numaranız',
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.85)),
                ),
                const SizedBox(height: 8),
                Text(
                  isCalled ? 'Lütfen Gişeye Gelin' : '${q.position}',
                  style: GoogleFonts.poppins(
                      fontSize: isCalled ? 28 : 64,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
                if (!isCalled) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Tahmini Bekleme: ${q.estimatedWaitMinutes} dakika',
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.85)),
                  ),
                ],
                const SizedBox(height: 16),
                // Progress indicator
                if (!isCalled)
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1 - (q.position / 10)),
                    duration: const Duration(milliseconds: 800),
                    builder: (_, value, __) => ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: value,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 8,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Info cards
          Row(
            children: [
              Expanded(
                  child: _infoCard('Tesis', q.facilityName,
                      Icons.business_rounded)),
              const SizedBox(width: 12),
              Expanded(
                  child: _infoCard('Bölüm', q.departmentName,
                      Icons.meeting_room_rounded)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: _infoCard('Personel', q.staffName,
                      Icons.person_rounded)),
              const SizedBox(width: 12),
              Expanded(
                  child: _infoCard(
                      'Katıldınız',
                      '${q.joinedAt.hour.toString().padLeft(2, '0')}:${q.joinedAt.minute.toString().padLeft(2, '0')}',
                      Icons.schedule_rounded)),
            ],
          ),
          const SizedBox(height: 24),
          // Leave queue button
          OutlinedButton(
            onPressed: () {
              setState(() => _activeQueue = null);
              _timer?.cancel();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: Text('Kuyruktan Ayrıl',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: 6),
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 11, color: AppColors.textSecondary)),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}
