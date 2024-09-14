import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  final String apiUrl = 'https://dummyjson.com/products';

  Future<List<dynamic>> fetchProducts() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['products'];
    } else {
      throw Exception('Failed to load products');
    }
  }
}
