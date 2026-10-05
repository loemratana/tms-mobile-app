import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants.dart';
import '../../../core/theme/app_colors.dart';
import '../model/product.dart';
import '../providers/product_provider.dart';
import '../widget/productWidget.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: AppColors.lightGrey,
        foregroundColor: AppColors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => context.go('/login'),
            child: const Text('Log in'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(productListProvider.future),
        child: productsAsync.when(
          data: (page) {
            if (page.content.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 120),
                  Center(child: Text('No products yet.')),
                ],
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.all(defaultPadding),
              itemCount: page.content.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: defaultPadding,
                crossAxisSpacing: defaultPadding,
                childAspectRatio: 0.62,
              ),
              itemBuilder: (context, index) {
                final product = page.content[index];
                return _ProductCard(product: product);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => ListView(
            children: [
              const SizedBox(height: 80),
              Icon(Icons.error_outline, size: 40, color: AppColors.error),
              const SizedBox(height: 12),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Could not load products.\n$error',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: OutlinedButton(
                  onPressed: () => ref.invalidate(productListProvider),
                  child: const Text('Retry'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final variant = product.primaryVariant;
    final price = (variant?.price ?? 0).toDouble();
    final priceAfterDiscount = variant?.priceAfterDiscount?.toDouble();
    final discountPercent = (priceAfterDiscount != null && price > 0)
        ? (100 - (priceAfterDiscount / price * 100)).round()
        : null;

    return ProductWidget(
      image: product.imageCover,
      brandName: product.brand?.brandName ?? '',
      title: product.title,
      price: price,
      priceAfetDiscount: priceAfterDiscount,
      dicountpercent: discountPercent,
      press: () {},
    );
  }
}
