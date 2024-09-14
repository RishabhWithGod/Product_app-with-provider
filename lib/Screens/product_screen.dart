import 'package:flutter/material.dart';
import 'package:practial_task/Models/product_model.dart';
import 'package:practial_task/Providers/product_provider.dart';
import 'package:practial_task/Screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilterSection(provider),
          Expanded(
            child: ListView.builder(
              itemCount: provider.products.length,
              itemBuilder: (context, index) {
                final product = provider.products[index];
                return _buildProductTile(context, product);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Build each product tile with image and discount badge
  Widget _buildProductTile(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(productId: product.id),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Product Image
                Image.network(
                  product.imageUrl[0],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                // Discount Badge
                if (product.discountPercentage > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        '${product.discountPercentage.toStringAsFixed(1)}% OFF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 12.0),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(product.brand),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('\$${product.price.toStringAsFixed(2)}'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the filter dialog for brand and category filters.
  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final provider = Provider.of<ProductProvider>(context, listen: false);

        // Use StatefulBuilder to handle state changes within the dialog
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Filter'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildBrandFilter(provider, setState),
                    _buildCategoryFilter(provider, setState),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Apply'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Build the section for filtering by categories above the product list.
  Widget _buildCategoryFilterSection(ProductProvider provider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: provider.categories.map((category) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FilterChip(
              label: Text(category),
              selected: provider.selectedCategories.contains(category),
              onSelected: (isSelected) {
                provider.toggleCategorySelection(category);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  // Build the brand filter section with local state management
  Widget _buildBrandFilter(
      ProductProvider provider, void Function(void Function()) setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Brands'),
        Wrap(
          spacing: 8.0,
          children: provider.brands.map((brand) {
            return FilterChip(
              label: Text(brand),
              selected: provider.selectedBrands.contains(brand),
              // backgroundColor: Colors.grey[200],
              // selectedColor: Colors.blueAccent, // Set the selected color
              onSelected: (isSelected) {
                setState(() {
                  provider.toggleBrandSelection(brand); // Update provider state
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // Build the category filter section with local state management
  Widget _buildCategoryFilter(
      ProductProvider provider, void Function(void Function()) setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Categories'),
        Wrap(
          spacing: 8.0,
          children: provider.categories.map((category) {
            return FilterChip(
              label: Text(category),
              selected: provider.selectedCategories.contains(category),
              // backgroundColor: Colors.grey[200],
              // selectedColor: Colors.blueAccent, // Set the selected color
              onSelected: (isSelected) {
                setState(() {
                  provider.toggleCategorySelection(
                      category); // Update provider state
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
