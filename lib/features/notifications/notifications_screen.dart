import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/models.dart';
import '../../services/mock_data_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  late List<NotificationModel> _notifications;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
    _notifications = MockDataService.notifications;
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  List<NotificationModel> _filtered(String tab) {
    if (tab == 'all') return _notifications;
    if (tab == 'unread') return _notifications.where((n) => !n.isRead).toList();
    if (tab == 'update') return _notifications.where((n) => n.type == 'update').toList();
    if (tab == 'appointment') return _notifications.where((n) => n.type == 'appointment').toList();
    return _notifications;
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes} dk önce';
    if (diff.inHours < 24) return '${diff.inHours} sa önce';
    return '${diff.inDays} gün önce';
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'queue': return Icons.queue_rounded;
      case 'message': return Icons.message_rounded;
      case 'appointment': return Icons.event_rounded;
      case 'update': return Icons.update_rounded;
      default: return Icons.notifications_rounded;
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'queue': return AppColors.primary;
      case 'message': return AppColors.secondary;
      case 'appointment': return AppColors.warning;
      case 'update': return AppColors.success;
      default: return AppColors.info;
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
        title: Text('Bildirimler',
            style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
        actions: [
          TextButton(
            onPressed: () =>
                setState(() => _notifications.forEach((n) => n.isRead = true)),
            child: Text('Tümünü Temizle',
                style: GoogleFonts.poppins(
                    fontSize: 13, color: AppColors.primary,
                    fontWeight: FontWeight.w500)),
          ),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          labelStyle: GoogleFonts.poppins(
              fontSize: 12, fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Tümü'),
            Tab(text: 'Okunmamış'),
            Tab(text: 'Güncelleme'),
            Tab(text: 'Randevu'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _buildList(_filtered('all')),
          _buildList(_filtered('unread')),
          _buildList(_filtered('update')),
          _buildList(_filtered('appointment')),
        ],
      ),
    );
  }

  Widget _buildList(List<NotificationModel> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_off_outlined,
                color: AppColors.border, size: 60),
            const SizedBox(height: 16),
            Text('Bildirim yok',
                style: GoogleFonts.poppins(
                    color: AppColors.textSecondary, fontSize: 15)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
      itemBuilder: (ctx, i) {
        final n = items[i];
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _typeColor(n.type).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(_typeIcon(n.type), color: _typeColor(n.type), size: 22),
          ),
          title: Text(n.title,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight:
                      n.isRead ? FontWeight.w500 : FontWeight.w700,
                  color: AppColors.textPrimary)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),
              Text(n.message,
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(_timeAgo(n.time),
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppColors.textHint)),
            ],
          ),
          trailing: !n.isRead
              ? Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                )
              : null,
          onTap: () => setState(() => n.isRead = true),
        );
      },
    );
  }
}
