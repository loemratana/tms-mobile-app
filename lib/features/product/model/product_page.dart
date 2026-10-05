import 'product.dart';

class ProductPage {
  final List<Product> content;
  final int pageNumber;
  final int pageSize;
  final int totalElements;
  final int totalPages;

  const ProductPage({
    required this.content,
    required this.pageNumber,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
  });

  bool get hasMore => pageNumber + 1 < totalPages;

  factory ProductPage.fromJson(Map<String, dynamic> json) {
    final page = json['page'] as Map<String, dynamic>? ?? const {};
    return ProductPage(
      content: (json['content'] as List<dynamic>? ?? [])
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageNumber: page['number'] as int? ?? 0,
      pageSize: page['size'] as int? ?? 20,
      totalElements: page['totalElements'] as int? ?? 0,
      totalPages: page['totalPages'] as int? ?? 0,
    );
  }
}
