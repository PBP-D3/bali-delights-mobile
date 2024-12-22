import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/chat.dart';
import 'package:bali_delights_mobile/constants.dart';

class ApiService {
  static Future<List<Chat>> fetchChats() async {
    final response = await http.get(Uri.parse('${Constants.baseUrl}/chats/json/'));
    
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Chat.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load chats');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchStores({String? searchQuery}) async {
    final response = await http.get(Uri.parse('${Constants.baseUrl}/stores/json/'));
    
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Map<String, dynamic>> stores = data.map((item) => Map<String, dynamic>.from(item)).toList();
      
      if (searchQuery != null && searchQuery.isNotEmpty) {
        stores = stores.where((store) => 
          store['fields']['name'].toString().toLowerCase().contains(searchQuery.toLowerCase())
        ).toList();
      }
      
      return stores;
    } else {
      throw Exception('Failed to load stores');
    }
  }
}
