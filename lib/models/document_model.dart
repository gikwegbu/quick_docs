import 'dart:convert';

class DocumentModel {
  final String title;
  // The id of the user creating the Document.
  final String uid;
  // Here i'm not giving the List any type, because, it could be bullet points, numbers, anything literally...
  final List content;
  final DateTime createdAt;
  // The id of the document
  final String id;

  DocumentModel({
    required this.id,
    required this.title,
    required this.uid,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'title': title,
        'uid': uid,
        'content': content,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'id': id,
      };

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      title: map['title'] ?? '',
      uid: map['uid'] ?? '',
      content: List.from(map['content']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      id: map['_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentModel.fromJson(String source) =>
      DocumentModel.fromMap(jsonDecode(source));
}
