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
      debugPrint('George Token Error: $e');
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
      debugPrint('George Token Error: $e');
      apiResponse = ApiResponseModel(error: e.toString(), data: null);
    }
    return apiResponse;
  }
}
