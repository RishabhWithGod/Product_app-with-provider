import 'package:flutter/foundation.dart';
import 'package:practial_task/Models/product_model.dart';
import 'package:practial_task/Services/product_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<String> _brands = [];
  List<String> _categories = [];
  List<String> _selectedBrands = [];
  List<String> _selectedCategories = [];

  List<Product> get products => _filteredProducts;
  List<String> get brands => _brands;
  List<String> get categories => _categories;
  List<String> get selectedBrands => _selectedBrands;
  List<String> get selectedCategories => _selectedCategories;

  Future<void> fetchProducts() async {
    try {
      final service = ProductService();
      final productList = await service.fetchProducts();
      _products = productList.map<Product>((json) => Product.fromJson(json)).toList();
      _filteredProducts = List.from(_products);
      _updateBrandsAndCategories();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void filterProducts() {
    _filteredProducts = _products.where((product) {
      final matchesBrand = _selectedBrands.isEmpty || _selectedBrands.contains(product.brand);
      final matchesCategory = _selectedCategories.isEmpty || _selectedCategories.contains(product.category);
      return matchesBrand && matchesCategory;
    }).toList();
    notifyListeners();
  }

  void toggleBrandSelection(String brand) {
    if (_selectedBrands.contains(brand)) {
      _selectedBrands.remove(brand);
    } else {
      _selectedBrands.add(brand);
    }
    filterProducts();
  }

  void toggleCategorySelection(String category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    filterProducts();
  }

  void _updateBrandsAndCategories() {
    _brands = _products.map((p) => p.brand).toSet().toList();
    _categories = _products.map((p) => p.category).toSet().toList();
  }
}
