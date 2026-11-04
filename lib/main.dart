import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/helper/api/api_helper.dart';
import 'core/helper/dio/dio_helper.dart';
import 'core/storage/local_store.dart';
import 'core/storage/preferences_service.dart';
import 'core/storage/session_store.dart';
import 'core/widgets/responsive_app.dart';
import 'features/auth/data/data_source/auth_api_service.dart';
import 'features/auth/data/repo_imp/auth_repo_imp.dart';
import 'features/cart/data/data_source/cart_api_service.dart';
import 'features/cart/data/repo_imp/cart_repo_imp.dart';
import 'features/products_home/data/data_source/products_home_api_service.dart';
import 'features/products_home/data/repo_imp/products_home_repo_imp.dart';
import 'features/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppBootstrap());
}

class AppBootstrap extends StatefulWidget {
  const AppBootstrap({super.key});

  @override
  State<AppBootstrap> createState() => AppBootstrapState();
}

class AppBootstrapState extends State<AppBootstrap> {
  late Future<Widget> applicationFuture;

  @override
  void initState() {
    super.initState();
    applicationFuture = initializeApplication();
  }

  /// Opens storage and handle initializations
  Future<Widget> initializeApplication() async {
    final store = await SqliteStore.open();
    final preferences = await SharedPreferences.getInstance();
    final client = ApiHelper(dioHelper: DioHelper());
    final authApi = DioAuthApiService(client);
    final productsHomeApi = DioProductsHomeApiService(client);
    final cartApi = DioCartApiService(client, authApi);
    return ShopApp(
      authRepository: AuthRepoImp(authApi, SecureSessionStore()),
      productsHomeRepository: ProductsHomeRepoImp(productsHomeApi, store),
      cartRepository: CartRepoImp(store, cartApi),
      preferences: PreferencesService(preferences),
    );
  }

  /// app bootstrap layout
  @override
  Widget build(BuildContext context) => FutureBuilder<Widget>(
    future: applicationFuture,
    builder: (context, snapshot) {
      if (snapshot.hasData) return snapshot.data!;
      return ResponsiveApp(
        builder: (context) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ResponsiveApp.responsiveTheme(
            ThemeData(
              useMaterial3: true,
              colorSchemeSeed: const Color(0xff246c57),
            ),
          ),
          home: snapshot.hasError
              ? Scaffold(
                  body: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 24.h,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 337.5.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Could not open local storage. Please retry.',
                              textAlign: TextAlign.center,
                            ),
                            FilledButton(
                              onPressed: () => setState(
                                () =>
                                    applicationFuture = initializeApplication(),
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : const SplashScreen(),
        ),
      );
    },
  );
}
