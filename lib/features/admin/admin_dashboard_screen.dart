import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_colors.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedNav = 0;
  Timer? _timer;

  // Simulated live queue data
  final List<Map<String, dynamic>> _deptQueues = [
    {'dept': 'Kardiyoloji', 'current': 'K-194', 'waiting': 12, 'avgWait': '~24dk', 'status': 'normal'},
    {'dept': 'Acil Servis', 'current': 'E-012', 'waiting': 28, 'avgWait': '~04dk', 'status': 'critical'},
    {'dept': 'Radyoloji', 'current': 'R-109', 'waiting': 4, 'avgWait': '~12dk', 'status': 'low'},
    {'dept': 'Pediatri', 'current': 'P-331', 'waiting': 18, 'avgWait': '~40dk', 'status': 'high'},
  ];

  int _dailyUsers = 1240;
  int _activeQueues = 8;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      setState(() {
        _dailyUsers += (1 + (3 * (DateTime.now().second % 3)));
        _activeQueues = 6 + (DateTime.now().second % 4);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  static const _navItems = [
    {'label': 'Dashboard', 'icon': Icons.dashboard_rounded},
    {'label': 'Kuyruk', 'icon': Icons.queue_rounded},
    {'label': 'Tesisler', 'icon': Icons.business_rounded},
    {'label': 'Personel', 'icon': Icons.people_rounded},
    {'label': 'Raporlar', 'icon': Icons.bar_chart_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: Row(
        children: [
          // Sidebar (web)
          if (isWide) _buildSidebar(),
          // Main content
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: _selectedNav == 0
                        ? _buildDashboardContent()
                        : _selectedNav == 1
                            ? _buildQueueManagement()
                            : _buildComingSoon(_navItems[_selectedNav]['label'] as String),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // Bottom nav (mobile)
      bottomNavigationBar: isWide
          ? null
          : BottomNavigationBar(
              currentIndex: _selectedNav,
              onTap: (i) => setState(() => _selectedNav = i),
              items: _navItems
                  .map((n) => BottomNavigationBarItem(
                        icon: Icon(n['icon'] as IconData),
                        label: n['label'] as String,
                      ))
                  .toList(),
            ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 220,
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(Icons.work_rounded, color: Colors.white, size: 28),
                const SizedBox(width: 10),
                Text('WaitMate',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Yönetici Paneli',
                style: GoogleFonts.poppins(
                    color: Colors.white54, fontSize: 11)),
          ),
          const SizedBox(height: 28),
          ..._navItems.asMap().entries.map((e) {
            final isSelected = _selectedNav == e.key;
            return GestureDetector(
              onTap: () => setState(() => _selectedNav = e.key),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(e.value['icon'] as IconData,
                        color: isSelected ? Colors.white : Colors.white60,
                        size: 20),
                    const SizedBox(width: 12),
                    Text(e.value['label'] as String,
                        style: GoogleFonts.poppins(
                            color: isSelected ? Colors.white : Colors.white60,
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal)),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Row(
        children: [
          Text('Yönetici Paneli',
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.admin_panel_settings_rounded,
                    color: AppColors.primary, size: 16),
                const SizedBox(width: 6),
                Text('Yönetici',
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person_rounded, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stat cards
        GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 700 ? 4 : 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _statCard('Günlük Kullanıcı', '$_dailyUsers',
                Icons.people_rounded, AppColors.primary, '+12% dün'),
            _statCard('Aktif Kuyruk', '$_activeQueues',
                Icons.queue_rounded, AppColors.secondary, 'Normal performans'),
            _statCard('Ortalama Bekleme', '12dk',
                Icons.access_time_rounded, AppColors.warning, 'Hemen iyileştir'),
            _statCard('Tamamlanan', '89',
                Icons.check_circle_rounded, AppColors.success, '%94 verimlilik'),
          ],
        ),
        const SizedBox(height: 24),
        // Chart
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Yoğunluk Analizi',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Text('Son 7 gün',
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 20),
              SizedBox(
                height: 180,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (_) => FlLine(
                          color: AppColors.border, strokeWidth: 1),
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 24,
                          getTitlesWidget: (v, _) {
                            const days = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
                            if (v.toInt() < days.length) {
                              return Text(days[v.toInt()],
                                  style: GoogleFonts.poppins(
                                      fontSize: 11, color: AppColors.textSecondary));
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 820), FlSpot(1, 1100), FlSpot(2, 950),
                          FlSpot(3, 1340), FlSpot(4, 870), FlSpot(5, 1080), FlSpot(6, 1240),
                        ],
                        isCurved: true,
                        color: AppColors.primary,
                        barWidth: 3,
                        belowBarData: BarAreaData(
                          show: true,
                          color: AppColors.primary.withOpacity(0.08),
                        ),
                        dotData: const FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Active queue table
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Aktif Kuyruk Detayları',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 16),
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1.5),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1.5),
                  4: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColors.divider))),
                    children: ['Bölüm', 'Randevu No', 'Bekleyen', 'Ort. Süre', 'Durum']
                        .map((h) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(h,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w500)),
                            ))
                        .toList(),
                  ),
                  ..._deptQueues.map((q) => TableRow(
                        children: [
                          _tableCell(q['dept']),
                          _tableCell(q['current']),
                          _tableCell(q['waiting'].toString()),
                          _tableCell(q['avgWait']),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _statusColor(q['status']).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _statusLabel(q['status']),
                                style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: _statusColor(q['status'])),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQueueManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Kuyruk Yönetimi',
            style: GoogleFonts.poppins(
                fontSize: 18, fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(
              width: 8, height: 8,
              decoration: const BoxDecoration(
                  color: AppColors.queueActive, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text('CANLI – BAĞLANDI',
                style: GoogleFonts.poppins(
                    fontSize: 12, color: AppColors.queueActive,
                    fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 20),
        // Stat row
        Row(
          children: [
            Expanded(child: _statCard('Aktif Kuyruk', '$_activeQueues', Icons.queue_rounded, AppColors.primary, 'Bölümde')),
            const SizedBox(width: 12),
            Expanded(child: _statCard('Bekleyen', '${_deptQueues.fold(0, (s, q) => s + (q['waiting'] as int))}', Icons.people_rounded, AppColors.warning, 'Toplam')),
          ],
        ),
        const SizedBox(height: 20),
        // Queue cards
        ..._deptQueues.map((q) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(q['dept'],
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    Text('Mevcut: ${q['current']}',
                        style: GoogleFonts.poppins(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Column(
                children: [
                  Text('${q['waiting']}',
                      style: GoogleFonts.poppins(
                          fontSize: 22, fontWeight: FontWeight.w700,
                          color: _statusColor(q['status']))),
                  Text('bekliyor',
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  Text(q['avgWait'],
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  Text('ort. süre',
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 12)),
                child: Text('Sıradaki Al',
                    style: GoogleFonts.poppins(fontSize: 12)),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildComingSoon(String name) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          const Icon(Icons.construction_rounded, color: AppColors.primary, size: 60),
          const SizedBox(height: 16),
          Text('$name – Yakında',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color, String sub) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
            ],
          ),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 24, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 12, color: AppColors.textSecondary)),
              Text(sub,
                  style: GoogleFonts.poppins(
                      fontSize: 10, color: color)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tableCell(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(text,
            style: GoogleFonts.poppins(
                fontSize: 13, color: AppColors.textPrimary)),
      );

  Color _statusColor(String status) {
    switch (status) {
      case 'critical': return AppColors.error;
      case 'high': return AppColors.warning;
      case 'low': return AppColors.success;
      default: return AppColors.info;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'critical': return 'KRİTİK';
      case 'high': return 'YÜKSEK';
      case 'low': return 'DÜŞÜK';
      default: return 'NORMAL';
    }
  }
}
