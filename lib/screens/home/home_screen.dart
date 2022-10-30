import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_docs/common/widgets/loader.dart';
import 'package:quick_docs/models/api_response_model.dart';
import 'package:quick_docs/models/document_model.dart';
import 'package:quick_docs/repository/auth_repository.dart';
import 'package:quick_docs/repository/document_repository.dart';
import 'package:quick_docs/utils/colors.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void signOut(WidgetRef ref) {
    ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(WidgetRef ref, BuildContext context) async {
    String token = ref.read(userProvider)!.token;
    final navigator = Routemaster.of(context);
    final snackbar = ScaffoldMessenger.of(context);

    final apiResponseModel =
        await ref.read(documentRepositoryProvider).createDocument(token);
    if (apiResponseModel.data != null) {
      navigator.push('/document/${apiResponseModel.data.id}');
    } else {
      snackbar.showSnackBar(SnackBar(content: Text(apiResponseModel.error!)));
    }
  }

  void navigateToDocument(BuildContext context, String documentId) {
    Routemaster.of(context).push('/document/$documentId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        actions: [
          IconButton(
            splashRadius: 20,
            onPressed: () => createDocument(ref, context),
            icon: const Icon(
              Icons.add,
              color: black,
            ),
          ),
          IconButton(
            splashRadius: 20,
            onPressed: () => signOut(ref),
            icon: const Icon(
              Icons.logout,
              color: red,
            ),
          ),
        ],
      ),
      body: FutureBuilder<ApiResponseModel>(
        future: ref
            .watch(documentRepositoryProvider)
            .getDocuments(ref.watch(userProvider)!.token),
        builder:
            (BuildContext context, AsyncSnapshot<ApiResponseModel> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Loader();
            default:
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return Center(
                  child: Container(
                    width: 600,
                    margin: const EdgeInsets.only(top: 10),
                    child: ListView.builder(
                      itemCount: snapshot.data!.data.length,
                      itemBuilder: (context, index) {
                        DocumentModel document = snapshot.data!.data[index];
                        return InkWell(
                          onTap: () => navigateToDocument(context, document.id),
                          child: SizedBox(
                            height: 50,
                            child: Card(
                              child: Center(
                                child: Text(
                                  document.title,
                                  style: const TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
