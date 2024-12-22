import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/chat.dart';
import '../../models/message.dart';
import 'dart:io';
import '../models/chat.dart';
import '../models/message.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000'; // Ganti dengan URL backend Anda
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer YOUR_AUTH_TOKEN', // Tambahkan autentikasi jika diperlukan
  };

  /// Fetch list of chats
  static Future<List<Chat>> fetchChats() async {
    final url = Uri.parse('$baseUrl/api/chats/');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final chatsJson = data['chats'] ?? [];
      return List<Chat>.from(chatsJson.map((c) => Chat.fromJson(c)));
    } else {
      throw Exception('Failed to load chats: ${response.reasonPhrase}');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchStores({String? searchQuery}) async {
    final uri = Uri.parse('$baseUrl/api/stores/').replace(queryParameters: {
      if (searchQuery != null) 'search': searchQuery,
    });

    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer YOUR_AUTH_TOKEN', // Tambahkan jika menggunakan autentikasi
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['stores']);
    } else {
      throw Exception('Failed to fetch stores: ${response.reasonPhrase}');
    }
  }

  /// Fetch messages of a specific chat
  static Future<List<Message>> fetchMessages(int chatId) async {
    final url = Uri.parse('$baseUrl/api/chats/$chatId/messages/');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final messagesJson = data['messages'] ?? [];
      return List<Message>.from(messagesJson.map((m) => Message.fromJson(m)));
    } else {
      throw Exception('Failed to load messages: ${response.reasonPhrase}');
    }
  }

  /// Send a new message to a chat
  static Future<bool> sendMessage(int chatId, String content) async {
    final url = Uri.parse('$baseUrl/api/chats/$chatId/send/');
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode({'message': content}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      return data['success'] == true;
    } else {
      print('Failed to send message: ${response.reasonPhrase}');
      return false;
    }
  }

  /// Edit an existing message
  static Future<bool> editMessage(int messageId, String updatedContent) async {
  final url = Uri.parse('$baseUrl/api/messages/$messageId/edit/');
  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer YOUR_AUTH_TOKEN', // Tambahkan jika diperlukan
      'Content-Type': 'application/json',
    },
    body: json.encode({'content': updatedContent}),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['success'] == true;
  } else {
    return false;
  }
}

  /// Create a new chat
  static Future<Map<String, dynamic>> createChat(int storeId) async {
    final url = Uri.parse('$baseUrl/api/chats/create/');
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode({'store_id': storeId}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to create chat: ${response.reasonPhrase}');
    }
  }

  /// Delete a chat
  static Future<bool> deleteChat(int chatId) async {
    final url = Uri.parse('$baseUrl/api/chats/$chatId/delete/');
    final response = await http.post(url, headers: {
      'Authorization': 'Bearer YOUR_AUTH_TOKEN', // Tambahkan token autentikasi jika diperlukan
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['success'] == true;
    } else {
      return false;
    }
  }
}
