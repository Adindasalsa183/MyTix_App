import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Selamat Datang di MyTix!',
      'message': 'Dapatkan promo menarik dan diskon hingga 50% untuk pembelian tiket pertamamu.',
      'time': '15 Okt 2026, 10:00',
      'isRead': false,
    }
  ];

  void addPaymentSuccessNotification({
    required String movieTitle,
    required String cinemaName,
    required String seats,
    required int totalPrice,
  }) {
    notifications.insert(0, {
      'title': 'Pembayaran Berhasil! 🎟️',
      'message': 'Tiket film "$movieTitle" di $cinemaName (Kursi: $seats) telah berhasil diterbitkan. Selamat menonton!',
      'time': 'Hari Ini',
      'isRead': false,
    });
  }

  void addEventPaymentSuccessNotification({
    required String eventTitle,
    required String showTitle,
    required String orderId,
  }) {
    notifications.insert(0, {
      'title': 'Pembayaran Event Berhasil! 🎪',
      'message': 'Tiket "$showTitle" ($eventTitle) dengan Kode Tiket: $orderId berhasil diproses.',
      'time': 'Baru saja',
      'isRead': false,
    });
  }
}