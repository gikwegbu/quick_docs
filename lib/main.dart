import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_docs/models/api_response_model.dart';
import 'package:quick_docs/repository/auth_repository.dart';
import 'package:quick_docs/screens/home/home_screen.dart';
import 'package:quick_docs/screens/login/login_screen.dart';
import 'package:quick_docs/utils/routes.dart';
import 'package:routemaster/routemaster.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  // While using ConsumerStatefulWidget, the 'ref' is available already, no need adding the 'WidgetRef ref';
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  ApiResponseModel? apiResponseModel;
  // As long as the apiResponseModel is null, then we are fetching the data, else, we ain't.

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    apiResponseModel = await ref.read(authRepositoryProvider).getUserData();
    if (apiResponseModel != null && apiResponseModel!.data != null) {
      ref.read(userProvider.notifier).update((state) => apiResponseModel!.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Quick Docs 📝',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: user == null ? const LoginScreen() : const HomeScreen(),
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        final user = ref.watch(userProvider);
        if(user != null && user.token.isNotEmpty) {
          return loggedInRoute;
        }
          return loggedOutRoute;
      }),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
