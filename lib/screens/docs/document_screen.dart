import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart'
    as quill; // because it has some stuffs that interferes with material app
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_docs/utils/colors.dart';
import 'package:quick_docs/utils/image_utils.dart';

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

  final quill.QuillController _quillController = quill.QuillController.basic();

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.lock, size: 16),
                label: const Text('share'),
                style: ElevatedButton.styleFrom(primary: blue),
              ),
            )
          ],
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(children: [
              Image.asset(
                ImageUtils.gdicon,
                height: 40,
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
              quill.QuillToolbar.basic(controller: _quillController),
              Expanded(
                child: SizedBox(
                  width: 750,
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: quill.QuillEditor.basic(
                        controller: _quillController,
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
