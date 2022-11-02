import 'dart:async';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart'
    as quill; // because it has some stuffs that interferes with material app
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_docs/common/widgets/loader.dart';
import 'package:quick_docs/models/api_response_model.dart';
import 'package:quick_docs/models/document_model.dart';
import 'package:quick_docs/repository/auth_repository.dart';
import 'package:quick_docs/repository/document_repository.dart';
import 'package:quick_docs/repository/socket_repository.dart';
import 'package:quick_docs/utils/colors.dart';
import 'package:quick_docs/utils/image_utils.dart';
import 'package:routemaster/routemaster.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  const DocumentScreen({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  // This is how to pass initial value
  TextEditingController titleController =
      TextEditingController(text: 'Untitled Document');

  quill.QuillController? _quillController;
  ApiResponseModel? apiResponseModel;

  SocketRepository socketRepository = SocketRepository();

  @override
  initState() {
    super.initState();

    // Adding it to the Top before fetching the files bayi
    socketRepository.joinRoom(
      widget.id,
    );

    // Fetching a document data
    fetchDocumentData();

    // The p0 (p zero) is the data returned from our function, pretty kinky and smart
    // socketRepository.changeListener((p0) => null);
    socketRepository.changeListener(
      (data) => {
        // The .compose, does same thing as notifyListerner(), so no need of calling the setState afterwards
        _quillController?.compose(
          quill.Delta.fromJson(data['delta']),
          _quillController?.selection ??
              const TextSelection.collapsed(offset: 0),
          quill.ChangeSource.REMOTE,
        )
      },
    );

    // Calling the AutoSave periodically of 2seconds
    Timer.periodic(const Duration(seconds: 2), (timer) {
      socketRepository.autoSave(<String, dynamic>{
        // Getting the entire content, not just Tuple item2, (i.e the current changed character...)
        'delta': _quillController?.document.toDelta(),
        'room': widget.id,
      });
    });
  }

  void fetchDocumentData() async {
    apiResponseModel = await ref
        .read(documentRepositoryProvider)
        .getDocumentById(ref.read(userProvider)!.token, widget.id);

    if (apiResponseModel?.data != null) {
      // Getting the response data, and type casting it as DocumentModel... 💪
      titleController.text = (apiResponseModel?.data as DocumentModel).title;

      // First, if the apiResponseModel data is empty,
      // We set the _quillController to an empty Document, i.e gotten from quill itself
      // Second, if the apiResponseModel data is not empty, then we format the apiResponseModel data's content
      // using the quill.Delta.fromJson(), and then parse it with the quill.Document.fromDelta() as the value of the _quillController document.
      _quillController = quill.QuillController(
        document: apiResponseModel?.data.content.isEmpty
            ? quill.Document()
            : quill.Document.fromDelta(
                quill.Delta.fromJson(apiResponseModel?.data.content),
              ),
        selection: const TextSelection.collapsed(offset: 0),
      );
      setState(() {});
    } else {
      // Here we capture the fact that the document does not exist, then navigate user back...
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${apiResponseModel?.error}")),
      );
      Navigator.pop(context);
    }

    _quillController?.document.changes.listen((event) {
      // The event has three Tuple values;
      // 1. item1: First Delta:- Tells us about the entire new content of the document.
      // 2. item2: Second Delta:- Tells us about just the particular changes that were made, from the previous part.
      // 3. item3: ChangeSource:- Tells if the change from either Local or Remote.
      // i.e, if it's local, then the current user was the one that made the change, if it's Remote,
      // then another user made the changes and the current user is has access to those changes.

      // Our Logic would be, if the changes is Local, then we'd wanna send the content of the quill to the server, to update others in the room.
      if (event.item3 == quill.ChangeSource.LOCAL) {
        Map<String, dynamic> map = {
          'delta': event
              .item2, // item2, justs passes the current character that was typed in the quill editor,
          'room': widget.id,
        };
        socketRepository.typing(map);
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  void updateTitle(WidgetRef ref, String title) {
    ref.read(documentRepositoryProvider).updateTitle(
          token: ref.read(userProvider)!.token,
          id: widget.id,
          title: title,
        );
  }

  @override
  Widget build(BuildContext context) {
    if (_quillController == null) {
      return const Scaffold(
        body: Loader(),
      );
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(
                          text:
                              'http://localhost:3000/#/document/${widget.id}'))
                      .then(
                    (value) => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Link Copied! 💪"),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.lock, size: 16),
                label: const Text('share'),
                style: ElevatedButton.styleFrom(primary: blue),
              ),
            )
          ],
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(children: [
              GestureDetector(
                onTap: () {
                  // This replaces the current screen with '/', which is the home kinda
                  Routemaster.of(context).replace('/');
                },
                child: Image.asset(
                  ImageUtils.gdicon,
                  height: 40,
                ),
              ),
              SizedBox(
                width: 180,
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: blue,
                      ),
                    ),
                    contentPadding: EdgeInsets.only(left: 10),
                  ),
                  onSubmitted: (value) => updateTitle(ref, value),
                ),
              ),
            ]),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: grey, width: 0.1),
              ),
            ),
          ),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              quill.QuillToolbar.basic(controller: _quillController!),
              Expanded(
                child: SizedBox(
                  width: 750,
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: quill.QuillEditor.basic(
                        controller: _quillController!,
                        readOnly: false, // true for view only mode
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
