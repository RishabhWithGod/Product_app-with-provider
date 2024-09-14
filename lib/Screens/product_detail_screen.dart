import 'package:flutter/material.dart';
import 'package:practial_task/Providers/product_provider.dart';
import 'package:provider/provider.dart';


class ProductDetailScreen extends StatelessWidget {
  final String productId;

  ProductDetailScreen({required this.productId});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final product = provider.products.firstWhere((p) => p.id == productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.imageUrl[0]),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                product.name,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                product.description,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Price: \$${product.price}',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Reviews',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            ..._buildReviews(product.reviews,context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildReviews(List<dynamic> reviews,context) {
    return reviews.map((review) {
      final reviewer = review['reviewer'] ?? 'Anonymous';
      final date = review['date'] ?? 'Unknown date';
      final rating = review['rating'] ?? 0;
      final comment = review['comment'] ?? '';

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$reviewer on $date', style: Theme.of(context).textTheme.subtitle2),
            Row(
              children: List.generate(rating, (index) => Icon(Icons.star, color: Colors.yellow)),
            ),
            Text(comment),
          ],
        ),
      );
    }).toList();
  }
}
