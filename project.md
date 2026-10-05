lib/
│
├── main.dart
├── app.dart
│
├── core/
│   ├── constants/
│   │   ├── api_constants.dart
│   │   ├── app_constants.dart
│   │   └── storage_keys.dart
│   │
│   ├── network/
│   │   ├── dio_client.dart
│   │   ├── dio_interceptor.dart
│   │   └── api_exception.dart
│   │
│   ├── router/
│   │   └── app_router.dart
│   │
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── light_theme.dart
│   │   └── dark_theme.dart
│   │
│   ├── utils/
│   │   └── ...
│   │
│   └── widgets/
│       ├── app_button.dart
│       ├── app_text_field.dart
│       ├── app_loader.dart
│       └── app_error.dart
│
├── features/
│   │
│   ├── auth/
│   │   ├── /
│   │   │   ├── user.dart
│   │   │   ├── login_request.dart
│   │   │   └── login_response.dart
│   │   │
│   │   ├── repositories/
│   │   │   └── auth_repository.dart
│   │   │
│   │   ├── providers/
│   │   │   └── auth_provider.dart
│   │   │
│   │   ├── screens/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   │
│   │   └── widgets/
│   │       └── login_form.dart
│   │
│   ├── products/
│   │   ├── models/
│   │   │   ├── product.dart
│   │   │   └── product_page.dart
│   │   │
│   │   ├── repositories/
│   │   │   └── product_repository.dart
│   │   │
│   │   ├── providers/
│   │   │   └── product_provider.dart
│   │   │
│   │   ├── screens/
│   │   │   ├── products_screen.dart
│   │   │   └── product_detail_screen.dart
│   │   │
│   │   └── widgets/
│   │       ├── product_card.dart
│   │       └── product_grid.dart
│   │
│   ├── categories/
│   │   ├── models/
│   │   ├── repositories/
│   │   ├── providers/
│   │   ├── screens/
│   │   └── widgets/
│   │
│   ├── cart/
│   │   ├── models/
│   │   ├── repositories/
│   │   ├── providers/
│   │   ├── screens/
│   │   └── widgets/
│   │
│   ├── orders/
│   │   ├── models/
│   │   ├── repositories/
│   │   ├── providers/
│   │   ├── screens/
│   │   └── widgets/
│   │
│   ├── wishlist/
│   │   ├── models/
│   │   ├── repositories/
│   │   ├── providers/
│   │   ├── screens/
│   │   └── widgets/
│   │
│   └── profile/
│       ├── models/
│       ├── repositories/
│       ├── providers/
│       ├── screens/
│       └── widgets/
│
└── shared/
    ├── extensions/
    └── widgets/