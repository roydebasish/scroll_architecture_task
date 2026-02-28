import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_architecture_task/bloc/auth/auth_state.dart';
import 'core/dio_client.dart';
import 'core/token_storage.dart';
import 'data/auth_repository.dart';
import 'data/product_repository.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/product/product_bloc.dart';
import 'ui/login_screen.dart';
import 'ui/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioClient.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _hasToken() async {
    final token = await TokenStorage.get();
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(AuthRepository())),
        BlocProvider(create: (_) => ProductBloc(ProductRepository())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Daraz Demo",
        theme: ThemeData(primarySwatch: Colors.orange),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {

            // Still checking token → show loading
            if (state.checking) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            // Authenticated
            if (state.authenticated) {
              return const HomeScreen();
            }

            // Not authenticated
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}