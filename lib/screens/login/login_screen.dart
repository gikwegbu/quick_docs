import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_docs/repository/auth_repository.dart';
import 'package:quick_docs/screens/home/home_screen.dart';
import 'package:quick_docs/utils/colors.dart';
import 'package:quick_docs/utils/image_utils.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void signInWithGoogle(WidgetRef ref, BuildContext context) async {
    final sMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final apiResponse =
        await ref.read(authRepositoryProvider).signInWithGoogle();

    if (apiResponse.error == null) {
      // Remember the userProvider we created at the AuthRepository bah,
      // Since we created it using the StateProvider, we can update it from here, by appending the '.notifier'
      // This .update(), is inbuilt, i.e comes with the StateProvider
      // After then, we move to the HomeScreen
      ref.read(userProvider.notifier).update((state) => apiResponse.data);
      navigator.push(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      sMessenger.showSnackBar(
        SnackBar(
          content: Text(apiResponse.error!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => signInWithGoogle(ref, context),
              // onPressed: () {
              //   Navigator.of(context).push(
              //     MaterialPageRoute(
              //       builder: (context) => const HomeScreen(),
              //     ),
              //   );
              // },
              icon: Image.asset(
                ImageUtils.glogo,
                height: 20,
              ),
              label: const Text(
                "Sign in with Google",
                style: TextStyle(
                  color: black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: white,
                minimumSize: const Size(150, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
