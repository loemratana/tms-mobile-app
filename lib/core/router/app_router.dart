import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/product/screens/product_list_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',

    redirect: (context, state) {
      final authState = ref.read(authProvider);

      final isAuthenticated = authState.status == AuthStatus.authenticated;

      final isLoading =
          authState.status == AuthStatus.initial ||
          authState.status == AuthStatus.loading;

      final isAuthRoute =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/forgot-password';

      // The product catalog is public; everything else needs a session.
      final isPublicRoute = isAuthRoute || state.matchedLocation == '/products';

      // Wait while checking authentication
      if (isLoading) {
        return null;
      }

      // Already authenticated → don't allow auth pages
      if (isAuthenticated && isAuthRoute) {
        return '/products';
      }

      // Not authenticated → protect non-public routes
      if (!isAuthenticated && !isPublicRoute) {
        return '/login';
      }

      return null;
    },

    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductListScreen(),
      ),
    ],
  );
});

final appRouterProvider = routerProvider;
