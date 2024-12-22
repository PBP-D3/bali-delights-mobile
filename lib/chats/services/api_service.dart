import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/chat.dart';
import '../models/message.dart';
import 'package:bali_delights_mobile/constants.dart';

class ApiService {
  static Future<List<Chat>> fetchChats(CookieRequest request) async {
    // Using list_chats_json endpoint
    final response =
        await request.get('${Constants.baseUrl}/chats/api/chats/list/');
    if (response != null && response['chats'] != null) {
      List<dynamic> data = response['chats'];
      return data.map((json) => Chat.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load chats');
    }
  }

  static Future<Map<String, dynamic>> initializeChat(
      CookieRequest request, int storeId) async {
    // Using chat_with_store_json endpoint
    final response = await request
        .get('${Constants.baseUrl}/chats/api/chats/$storeId/view/');

    if (response != null) {
      return {
        'success': true,
        'chat_id': response['chat_id'],
        'store': response['store'],
      };
    } else {
      throw Exception('Failed to initialize chat');
    }
  }

  static Future<Map<String, dynamic>> createChat(
      CookieRequest request, int storeId) async {
    print('Creating chat with store ID: $storeId'); // Debug log
    
    final response = await request.post(
      '${Constants.baseUrl}/chats/api/chats/create/',
      {'store_id': storeId.toString()}
    );
    
    print('Create chat response: $response'); // Debug log
    
    if (response != null) {
      return {
        'success': true,
        'chat_id': response['chat_id'],  // Changed from store_id to chat_id
        'store_id': storeId,
      };
    } else {
      throw Exception('Failed to create chat');
    }
  }

  static Future<Map<String, dynamic>> getOrCreateChat(
      CookieRequest request, int storeId) async {
    final response = await request
        .get('${Constants.baseUrl}/chats/api/chats/$storeId/view/');

    if (response != null) {
      final userId = response['user']?['id'];
      final messages = response['messages'] as List<dynamic>;
      
      return {
        'success': true,
        'chat_id': response['chat_id'],
        'store': response['store'],
        'user': response['user'],
        'messages': messages,
      };
    } else {
      throw Exception('Failed to initialize chat');
    }
  }

  static Future<Map<String, dynamic>> fetchMessages(
      CookieRequest request, int chatId) async {
    final response = await request
        .get('${Constants.baseUrl}/chats/api/chats/$chatId/messages/');

    if (response != null) {
      return {
        'messages': response['messages'],
        'user': response['user'], // Include user info in response
      };
    } else {
      throw Exception('Failed to load messages');
    }
  }

  static Future<bool> sendMessage(
      CookieRequest request, int chatId, String content) async {
    final response = await request.post(
      '${Constants.baseUrl}/chats/api/chats/$chatId/send/',
      {'message': content},
    );
    return response['success'] ?? false;
  }

  static Future<bool> deleteChat(CookieRequest request, int chatId) async {
    final response = await request.post(
      '${Constants.baseUrl}/chats/api/chats/$chatId/delete/',
      {},
    );
    return response['success'] ?? false;
  }

  static Future<bool> editMessage(
      CookieRequest request, int messageId, String content) async {
    final response = await request.post(
      '${Constants.baseUrl}/chats/api/messages/$messageId/edit/',
      {'content': content},
    );
    return response['success'] ?? false;
  }

  static Future<List<Map<String, dynamic>>> fetchStores(CookieRequest request,
      {String? searchQuery}) async {
    String url = '${Constants.baseUrl}/chats/api/stores/';
    if (searchQuery != null && searchQuery.isNotEmpty) {
      url += '?search=$searchQuery';
    }

    final response = await request.get(url);

    if (response != null && response['stores'] != null) {
      return List<Map<String, dynamic>>.from(response['stores']);
    } else {
      throw Exception('Failed to load stores');
    }
  }
}
