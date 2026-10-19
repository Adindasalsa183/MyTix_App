import 'package:flutter/material.dart';
import '../services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF001935)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF001935)),
        ),
      ),
      body: notificationService.notifications.isEmpty
          ? const Center(
              child: Text('Belum ada notifikasi', style: TextStyle(color: Colors.grey)),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notificationService.notifications.length,
              separatorBuilder: (context, index) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final item = notificationService.notifications[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF001935).withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.confirmation_number, color: Color(0xFF001935), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item['title'],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF001935)),
                              ),
                              Text(item['time'], style: const TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['message'],
                            style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}