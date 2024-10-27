import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Inisialisasi FCM dan minta izin notifikasi
  Future<void> initializeFCM() async {
    // Memunculkan popup izin notifikasi aplikasi
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Izin notifikasi diberikan oleh pengguna');

      // Mendapatkan token FCM untuk identifikasi perangkat
      String? token = await _firebaseMessaging.getToken();
      print("Token FCM: $token");
    } else {
      print('Pengguna menolak atau belum memberikan izin');
    }

    // Mengatur penanganan notifikasi saat aplikasi dibuka dari notifikasi
    setupInteractedMessage();
  }

  // Menangani notifikasi saat aplikasi dalam keadaan terminated atau background
  void setupInteractedMessage() async {
    // Mengatur notifikasi yang diterima saat aplikasi dalam background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Mengatur notifikasi yang diterima saat aplikasi aktif (foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Pesan diterima saat aplikasi aktif: ${message.notification?.title}");

      // Menampilkan notifikasi sebagai pop-up
      _showNotificationPopup(message);
    });

    // Mengatur notifikasi yang diklik saat aplikasi dalam keadaan terminated atau background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Pesan diklik!: ${message.notification?.title}");
      // Tindak lanjut saat notifikasi diklik, misalnya navigasi ke halaman tertentu
      _handleNotificationClick(message);
    });
  }//

  // Fungsi untuk menampilkan notifikasi sebagai pop-up
  void _showNotificationPopup(RemoteMessage message) {
    showOverlayNotification((context) {
      return Card(
        margin: EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(message.notification?.title ?? "Tanpa Judul"),
          subtitle: Text(message.notification?.body ?? "Tanpa Isi"),
          
        ),
      );
    }, duration: Duration(seconds: 4));
  }

  // Fungsi untuk menangani klik notifikasi
  void _handleNotificationClick(RemoteMessage message) {
    // Contoh logika navigasi atau tindakan lain
    print("Anda mengklik notifikasi dan otomatis membukanya");
  }
}

// Fungsi penanganan notifikasi background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Menangani pesan di latar belakang: ${message.messageId}");
  // Lakukan tindakan yang diperlukan saat notifikasi diterima di latar belakang
}
