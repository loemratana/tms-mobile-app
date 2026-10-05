1. Create the Flutter project
flutter create ecommerce_mobile
cd ecommerce_mobile

Then add the core packages:

flutter pub add flutter_riverpod
flutter pub add dio
flutter pub add go_router
flutter pub add freezed_annotation
flutter pub add json_annotation
flutter pub add flutter_secure_storage

Development packages:

flutter pub add --dev build_runner
flutter pub add --dev freezed
flutter pub add --dev json_serializable
2. Build the foundation first

Start with only:

lib/
├── main.dart
├── app.dart
│
└── core/
    ├── constants/
    ├── network/
    ├── router/
    ├── theme/
    ├── utils/
    └── widgets/

Don't build Products, Cart, Orders, etc. yet.

3. Configure main.dart

Keep main.dart very small.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

The important idea is:

main.dart
   ↓
ProviderScope
   ↓
App
4. Create app.dart

This becomes the application root.

import 'package:flutter/material.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'E-Commerce',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,

      routerConfig: appRouter,
    );
  }
}

Now your application has:

Theme
Dark mode
GoRouter
Riverpod

from the beginning.

5. Configure Dio

Create:

core/
└── network/
    ├── dio_client.dart
    ├── dio_provider.dart
    └── auth_interceptor.dart

Start simple.

dio_client.dart
import 'package:dio/dio.dart';

class DioClient {
  static Dio create() {
    return Dio(
      BaseOptions(
        baseUrl: 'http://10.0.2.2:8083/api/v1',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }
}

For Android emulator:

10.0.2.2

represents your computer's localhost.

For a physical phone, you'll eventually use your computer's LAN IP.

6. Connect Dio to Riverpod

dio_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dio_client.dart';

final dioProvider = Provider<Dio>((ref) {
  return DioClient.create();
});

Now every Repository can get the same Dio instance.

Riverpod
   │
   ▼
dioProvider
   │
   ▼
Dio
7. Configure GoRouter

Create:

core/router/app_router.dart

Start with:

import 'package:go_router/go_router.dart';

import '../../features/home/screens/home_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',

  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
  ],
);

Later we'll add:

/login
/register
/home
/products
/products/:id
/cart
/checkout
/orders
/profile
8. Build Theme

Create:

core/theme/
├── app_theme.dart
├── light_theme.dart
├── dark_theme.dart
└── app_colors.dart

For example:

class AppColors {
  static const primary = Color(0xFF2563EB);
  static const background = Color(0xFFF8FAFC);
}

Then:

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: AppColors.primary,
        brightness: Brightness.light,
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: AppColors.primary,
        brightness: Brightness.dark,
      );
}

Don't spend too much time on visual design yet.

9. Now build your FIRST complete feature

I recommend:

Products

Not authentication.

Why?

Because Products will prove that your entire architecture works:

Flutter UI
   ↓
Riverpod
   ↓
Repository
   ↓
Dio
   ↓
Spring Boot
   ↓
PostgreSQL

That's the most important integration to establish early.

10. Create Products
features/
└── products/
    ├── models/
    │   └── product.dart
    │
    ├── repositories/
    │   └── product_repository.dart
    │
    ├── providers/
    │   └── product_provider.dart
    │
    ├── screens/
    │   ├── products_screen.dart
    │   └── product_detail_screen.dart
    │
    └── widgets/
        ├── product_card.dart
        └── product_grid.dart
11. Create the Product model

For example, if your Spring Boot API returns:

{
  "id": 1,
  "name": "Nike Air Max",
  "price": 120.00,
  "description": "Running shoes",
  "imageUrl": "https://..."
}

Create:

class Product {
  final int id;
  final String name;
  final double price;
  final String description;
  final String? imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }
}
12. Create Product Repository

This is where API communication belongs.

class ProductRepository {
  final Dio _dio;

  ProductRepository(this._dio);

  Future<List<Product>> getProducts() async {
    final response = await _dio.get('/products');

    final data = response.data['data'] as List;

    return data
        .map(
          (json) => Product.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<Product> getProduct(int id) async {
    final response = await _dio.get('/products/$id');

    return Product.fromJson(
      response.data['data'],
    );
  }
}

Your Repository becomes the boundary between Flutter and your backend.

13. Create Riverpod provider
final productRepositoryProvider =
    Provider<ProductRepository>((ref) {
  return ProductRepository(
    ref.watch(dioProvider),
  );
});

Then:

final productsProvider =
    FutureProvider.autoDispose<List<Product>>((ref) {
  return ref
      .watch(productRepositoryProvider)
      .getProducts();
});

Now your UI doesn't know anything about Dio.

14. Screen
class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: products.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stack) {
          return Center(
            child: Text(error.toString()),
          );
        },
        data: (products) {
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(
                product: products[index],
              );
            },
          );
        },
      ),
    );
  }
}

Now you've completed your first vertical slice.

15. Your development order

I would build the project in this order:

PHASE 1 — FOUNDATION
│
├── Flutter project
├── Riverpod
├── Dio
├── GoRouter
├── Theme
├── Secure Storage
└── Core widgets
        ↓
PHASE 2 — PRODUCTS
│
├── Product model
├── Product repository
├── Product provider
├── Product list
├── Product detail
└── API integration
        ↓
PHASE 3 — AUTH
│
├── Login
├── Register
├── JWT
├── Secure storage
├── Dio interceptor
└── Route protection
        ↓
PHASE 4 — CATEGORIES
│
├── Categories
├── Product filtering
└── Search
        ↓
PHASE 5 — CART
│
├── Add cart item
├── Update quantity
├── Remove item
└── Cart total
        ↓
PHASE 6 — CHECKOUT
│
├── Address
├── Payment
└── Order creation
        ↓
PHASE 7 — ORDERS
│
├── Order history
├── Order detail
└── Order status
        ↓
PHASE 8 — PROFILE
│
├── Profile
├── Update profile
└── Logout
Most important rule

Don't build this:

30 folders
100 files
0 working API

Build this first:

Products Screen
      ↓
Riverpod
      ↓
ProductRepository
      ↓
Dio
      ↓
Spring Boot
      ↓
PostgreSQL

Once Products works end-to-end, the same pattern can be reused for Categories, Cart, Orders, and Profile.

That's the approach I'd recommend for your project.