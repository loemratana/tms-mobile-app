import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../model/product_page.dart';

/// Talks to the public `/product` endpoints. Unlike [AuthRepository], these
/// responses are plain Spring `Page` bodies, not the `{ message, success,
/// data }` envelope, so they're parsed directly.
class ProductRepository {
  ProductRepository({Dio? dio}) : _dio = dio ?? DioClient().dio;

  final Dio _dio;

  Future<ProductPage> fetchProducts({int page = 0, int size = 20}) async {
    final response = await _dio.get(
      ApiConstants.products,
      queryParameters: {'page': page, 'size': size},
    );
    return ProductPage.fromJson(response.data as Map<String, dynamic>);
  }
}
