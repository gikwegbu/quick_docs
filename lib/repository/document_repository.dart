import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:quick_docs/models/api_response_model.dart';
import 'package:quick_docs/models/document_model.dart';
import 'package:quick_docs/utils/api.dart';

final documentRepositoryProvider = Provider((ref) {
  return DocumentRepositoryModel(client: Client());
});

class DocumentRepositoryModel {
  final Client _client;

  DocumentRepositoryModel({
    required Client client,
  }) : _client = client;

  Future<ApiResponseModel> createDocument(String token) async {
    ApiResponseModel apiResponse = ApiResponseModel(
      error: "Oops!!! An error occured.",
      data: null,
    );
    try {
      var res = await _client.post(
        Uri.parse("$host/doc/create"),
        headers: {
          'content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'createdAt': DateTime.now().millisecondsSinceEpoch,
        }),
      );

      switch (res.statusCode) {
        case 200:
          apiResponse = ApiResponseModel(
            error: null,
            data: DocumentModel.fromJson(res.body),
          );
          break;
        // You can do more error handling here, by capturing other statusCodes...
        default:
          apiResponse = ApiResponseModel(
            error: res.body,
            data: null,
          );
      }
    } catch (e) {
      debugPrint('George Create Document Error: $e');
      apiResponse = ApiResponseModel(error: e.toString(), data: null);
    }
    return apiResponse;
  }

  Future<ApiResponseModel> getDocuments(String token) async {
    ApiResponseModel apiResponse = ApiResponseModel(
      error: "Oops!!! An error occured.",
      data: null,
    );
    try {
      var res = await _client.get(
        Uri.parse("$host/docs/me"),
        headers: {
          'content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      switch (res.statusCode) {
        case 200:
          List<DocumentModel> documents = [];

          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            documents.add(
              DocumentModel.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }

          apiResponse = ApiResponseModel(
            error: null,
            data: documents,
          );
          break;
        // You can do more error handling here, by capturing other statusCodes...
        default:
          apiResponse = ApiResponseModel(
            error: res.body,
            data: null,
          );
      }
    } catch (e) {
      debugPrint('George get Document Error: $e');
      apiResponse = ApiResponseModel(error: e.toString(), data: null);
    }
    return apiResponse;
  }

  Future<ApiResponseModel> getDocumentById(String token, String id) async {
    ApiResponseModel apiResponse = ApiResponseModel(
      error: "Oops!!! An error occured.",
      data: null,
    );
    try {
      var res = await _client.get(
        Uri.parse("$host/docs/$id"),
        headers: {
          'content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      switch (res.statusCode) {
        case 200:
          apiResponse = ApiResponseModel(
            error: null,
            data: DocumentModel.fromJson(res.body),
          );
          break;
        // You can do more error handling here, by capturing other statusCodes...
        default:
          // This is the only likely error to come up here.
          // As user might wanna access a different document.
          throw "Oops!! Document does not exist 🙃";
      }
    } catch (e) {
      debugPrint('George get Document Error: $e');
      apiResponse = ApiResponseModel(error: e.toString(), data: null);
    }
    return apiResponse;
  }

  Future<ApiResponseModel> updateTitle({
    required String token,
    required String id,
    required String title,
  }) async {
    ApiResponseModel apiResponse = ApiResponseModel(
      error: "Oops!!! An error occured.",
      data: null,
    );
    try {
      var res = await _client.post(
        Uri.parse("$host/doc/title"),
        headers: {
          'content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'id': id,
          'title': title,
        }),
      );

      switch (res.statusCode) {
        case 200:
          apiResponse = ApiResponseModel(
            error: null,
            data: DocumentModel.fromJson(res.body),
          );
          break;
        // You can do more error handling here, by capturing other statusCodes...
        default:
          apiResponse = ApiResponseModel(
            error: res.body,
            data: null,
          );
      }
    } catch (e) {
      debugPrint('George Update Title Error: $e');
      apiResponse = ApiResponseModel(error: e.toString(), data: null);
    }
    return apiResponse;
  }
}
