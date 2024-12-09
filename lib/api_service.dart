import 'dart:convert';
import 'dart:io';
import 'models/chat.dart';
import 'models/message.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000';

  static Future<List<Chat>> fetchChats() async {
    final url = Uri.parse('$baseUrl/api/chats/');
    final httpClient = HttpClient();
    try {
      final request = await httpClient.getUrl(url);
      final response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = jsonDecode(responseBody) as Map<String, dynamic>;
        List chatsJson = data['chats'] ?? [];
        return chatsJson.map((c) => Chat.fromJson(c)).toList();
      } else {
        throw Exception('Failed to load chats');
      }
    } finally {
      httpClient.close();
    }
  }

  static Future<List<Message>> fetchMessages(int chatId) async {
    final url = Uri.parse('$baseUrl/api/chats/$chatId/messages/');
    final httpClient = HttpClient();
    try {
      final request = await httpClient.getUrl(url);
      final response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = jsonDecode(responseBody) as Map<String, dynamic>;
        List messagesJson = data['messages'] ?? [];
        return messagesJson.map((m) => Message.fromJson(m)).toList();
      } else {
        throw Exception('Failed to load messages');
      }
    } finally {
      httpClient.close();
    }
  }

  static Future<bool> sendMessage(int chatId, String content) async {
    final url = Uri.parse('$baseUrl/api/chats/$chatId/send/');
    final httpClient = HttpClient();
    try {
      final request = await httpClient.postUrl(url);
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/x-www-form-urlencoded');
      request.write('message=$content');

      final response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = jsonDecode(responseBody);
        return data['success'] == true;
      } else {
        return false;
      }
    } finally {
      httpClient.close();
    }
  }
}
