import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

class BrevoService {
  final String _apiKey = 'xkeysib-YOUR_BREVO_API_KEY';
  final String _apiUrl = 'https://api.brevo.com/v3/smtp/email';

  Future<bool> sendEmergencyAlert({
    required String contactEmail,
    required String userName,
    required String locationLink,
    required String medicalInfoLink,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'accept': 'application/json',
          'api-key': _apiKey,
          'content-type': 'application/json',
        },
        body: jsonEncode({
          "sender": {
            "name": "Are You Alive",
            "email": "noreply@areyoualive.app",
          },
          "to": [
            {"email": contactEmail},
          ],
          "subject": "EMERGENCY ALERT: $userName needs help",
          "htmlContent": '''
            <html>
              <body>
                <h1 style="color: red;">URGENT: Missed Safety Check-In</h1>
                <p><strong>$userName</strong> has missed their scheduled safety check-in and the grace period has expired.</p>
                <p>Last known location: <a href="\$locationLink">View Location</a></p>
                <p>Medical Information: <a href="\$medicalInfoLink">View Medical Profile</a></p>
                <hr>
                <p>Please attempt to contact them immediately or dispatch emergency services.</p>
              </body>
            </html>
          ''',
        }),
      );

      if (response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Brevo Error: $e');
      return false;
    }
  }
}

final brevoServiceProvider = Provider<BrevoService>((ref) {
  return BrevoService();
});
