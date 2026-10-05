class ProductBrand {
  final int brandId;
  final String brandName;

  const ProductBrand({required this.brandId, required this.brandName});

  factory ProductBrand.fromJson(Map<String, dynamic> json) => ProductBrand(
    brandId: json['brandId'] as int,
    brandName: json['brandName'] as String? ?? '',
  );
}

class ProductSubCategory {
  final int subCategoryId;
  final String subCategoryName;

  const ProductSubCategory({
    required this.subCategoryId,
    required this.subCategoryName,
  });

  factory ProductSubCategory.fromJson(Map<String, dynamic> json) =>
      ProductSubCategory(
        subCategoryId: json['subCategoryId'] as int,
        subCategoryName: json['subCategoryName'] as String? ?? '',
      );
}

class ProductVariant {
  final int id;
  final String color;
  final String sku;
  final num price;
  final num? priceAfterDiscount;
  final int soldQuantity;

  const ProductVariant({
    required this.id,
    required this.color,
    required this.sku,
    required this.price,
    this.priceAfterDiscount,
    required this.soldQuantity,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) =>
      ProductVariant(
        id: json['id'] as int,
        color: json['color'] as String? ?? '',
        sku: json['sku'] as String? ?? '',
        price: json['price'] as num? ?? 0,
        priceAfterDiscount: json['priceAfterDiscount'] as num?,
        soldQuantity: json['soldQuantity'] as int? ?? 0,
      );
}

class ProductImage {
  final int id;
  final String imageUrl;
  final int sortOrder;

  const ProductImage({
    required this.id,
    required this.imageUrl,
    required this.sortOrder,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
    id: json['id'] as int,
    imageUrl: json['imageUrl'] as String? ?? '',
    sortOrder: json['sortOrder'] as int? ?? 0,
  );
}

class Product {
  final int id;
  final String title;
  final String slug;
  final String? description;
  final String imageCover;
  final num ratingsAverage;
  final int ratingsQuantity;
  final ProductSubCategory? subCategory;
  final ProductBrand? brand;
  final List<ProductVariant> variants;
  final List<ProductImage> images;

  const Product({
    required this.id,
    required this.title,
    required this.slug,
    this.description,
    required this.imageCover,
    required this.ratingsAverage,
    required this.ratingsQuantity,
    this.subCategory,
    this.brand,
    this.variants = const [],
    this.images = const [],
  });

  /// The cheapest variant, or `null` when the product has none.
  ProductVariant? get primaryVariant {
    if (variants.isEmpty) return null;
    return variants.reduce((a, b) => a.price <= b.price ? a : b);
  }

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'] as int,
    title: json['title'] as String? ?? '',
    slug: json['slug'] as String? ?? '',
    description: json['description'] as String?,
    imageCover: json['imageCover'] as String? ?? '',
    ratingsAverage: json['ratingsAverage'] as num? ?? 0,
    ratingsQuantity: json['ratingsQuantity'] as int? ?? 0,
    subCategory: json['subCategory'] != null
        ? ProductSubCategory.fromJson(json['subCategory'] as Map<String, dynamic>)
        : null,
    brand: json['brand'] != null
        ? ProductBrand.fromJson(json['brand'] as Map<String, dynamic>)
        : null,
    variants: (json['variants'] as List<dynamic>? ?? [])
        .map((e) => ProductVariant.fromJson(e as Map<String, dynamic>))
        .toList(),
    images: (json['images'] as List<dynamic>? ?? [])
        .map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}
