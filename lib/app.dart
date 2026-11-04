import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/navigation/shop_shell.dart';
import 'core/storage/preferences_service.dart';
import 'core/widgets/responsive_app.dart';
import 'features/auth/auth_screen.dart';
import 'features/auth/controller/auth_cubit/auth_cubit.dart';
import 'features/auth/domain/entities/session_entity.dart';
import 'features/auth/domain/repo/auth_repo.dart';
import 'features/cart/controller/cart_cubit/cart_cubit.dart';
import 'features/cart/domain/repo/cart_repo.dart';
import 'features/products_home/controller/products_home_cubit/products_home_cubit.dart';
import 'features/products_home/domain/repo/products_home_repo.dart';
import 'features/splash/splash_screen.dart';

class ShopApp extends StatelessWidget {
  const ShopApp({
    super.key,
    required this.authRepository,
    required this.productsHomeRepository,
    required this.cartRepository,
    required this.preferences,
  });
  final AuthRepository authRepository;
  final ProductsHomeRepository productsHomeRepository;
  final CartRepository cartRepository;
  final LayoutPreferences preferences;

  /// app layout
  @override
  Widget build(BuildContext context) => ResponsiveApp(
    builder: (context) => BlocProvider(
      create: (_) => AuthCubit(authRepository)..restoreSession(),
      child: MaterialApp(
        title: 'Maher Shop',
        debugShowCheckedModeBanner: false,
        theme: ResponsiveApp.responsiveTheme(
          ThemeData(
            useMaterial3: true,
            colorSchemeSeed: const Color(0xff246c57),
            inputDecorationTheme: const InputDecorationTheme(filled: true),
          ),
        ),
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final auth = context.read<AuthCubit>();
            if (auth.status == AuthStatus.restoring) {
              return const SplashScreen();
            }
            final session = auth.session;
            if (auth.status != AuthStatus.authenticated ||
                session == null ||
                !session.validAt(DateTime.now())) {
              return const LoginScreen();
            }
            return SessionArea(
              key: ValueKey(session.profile.id),
              session: session,
              productsHomeRepository: productsHomeRepository,
              cartRepository: cartRepository,
              preferences: preferences,
            );
          },
        ),
      ),
    ),
  );
}

class SessionArea extends StatefulWidget {
  const SessionArea({
    super.key,
    required this.session,
    required this.productsHomeRepository,
    required this.cartRepository,
    required this.preferences,
  });
  final Session session;
  final ProductsHomeRepository productsHomeRepository;
  final CartRepository cartRepository;
  final LayoutPreferences preferences;

  @override
  State<SessionArea> createState() => SessionAreaState();
}

/// handle navigation within the authenticated session
class SessionAreaState extends State<SessionArea> {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) => RepositoryProvider.value(
    value: widget.productsHomeRepository,
    child: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CartCubit(
            widget.cartRepository,
            isSessionActive: () =>
                context.read<AuthCubit>().session == widget.session,
          )..loadCartForSession(widget.session),
        ),
        BlocProvider(
          create: (context) => ProductsHomeCubit(
            widget.productsHomeRepository,
            widget.preferences,
          )..initializeProducts(),
        ),
      ],
      child: NavigatorPopHandler<Object?>(
        onPopWithResult: (result) =>
            navigatorKey.currentState!.maybePop(result),
        child: Navigator(
          key: navigatorKey,
          onGenerateRoute: (context) =>
              MaterialPageRoute<void>(builder: (context) => const ShopShell()),
        ),
      ),
    ),
  );
}
