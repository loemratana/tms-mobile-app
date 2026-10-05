import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/product_repository.dart';
import '../model/product_page.dart';

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepository(),
);

final productListProvider = FutureProvider.autoDispose<ProductPage>((
  ref,
) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.fetchProducts();
});
