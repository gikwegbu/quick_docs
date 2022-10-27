import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:quick_docs/models/api_response_model.dart';
import 'package:quick_docs/models/user_model.dart';
import 'package:quick_docs/repository/local_storage_repository.dart';
import 'package:quick_docs/utils/api.dart';
import 'package:riverpod/riverpod.dart';

// Creating an authRepo provider, to make it globally accessible.
// Using just Provider, as it's a read only situation.
// I'd have to pass in an Instance of the GoogleSignIn to it too

final authRepositoryProvider = Provider((ref) => AuthRepository(
      googleSignin: GoogleSignIn(),
      client: Client(),
      localStorageRepository: LocalStorageRepository(),
    ));

// This stateprovider will help us update the userProvider after the user logs in.
// It'll be null, if the user is not logged in, or has a data with a model of UserModel, if the user is logged.
// Hence using the '?' for the <UserModel?>
final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  // This way, unit testing will be easier to carry out...
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorageRepository _localStorageRepository;

  AuthRepository({
    required GoogleSignIn googleSignin,
    required Client client,
    required LocalStorageRepository localStorageRepository,
  })  : _googleSignIn = googleSignin,
        _client = client,
        _localStorageRepository = localStorageRepository;

  Future<ApiResponseModel> signInWithGoogle() async {
    ApiResponseModel apiResponse = ApiResponseModel(
      error: "Oops!!! An error occured.",
      data: null,
    );
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAcc = UserModel(
          profilePic: user.photoUrl ?? '',
          email: user.email,
          name: user.displayName ?? '',
          token: '',
          uid: '',
        );

        var res = await _client.post(Uri.parse("$host/api/signup"),
            body: userAcc.toJson(),
            headers: {
              'content-Type': 'application/json; charset=UTF-8',
            });

        switch (res.statusCode) {
          case 200:
            final newUser = userAcc.copyWith(
              // gotten from the response body, select the user object and take the _id from MongoDB
              uid: jsonDecode(res.body)['user']['_id'],
              token: jsonDecode(res.body)['token'],
            );
            apiResponse = ApiResponseModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token);
            break;
          // You can do more error handling here, by capturing other statusCodes...
          default:
        }
      }
    } catch (e) {
      debugPrint('George Google Signin Error: $e');
      apiResponse = ApiResponseModel(error: e.toString(), data: null);
    }
    return apiResponse;
  }

  Future<ApiResponseModel> getUserData() async {
    ApiResponseModel apiResponse = ApiResponseModel(
      error: "Oops!!! An error occured.",
      data: null,
    );
    try {
      String? token = await _localStorageRepository.getToken();
      if (token != null) {
        var res = await _client.get(Uri.parse("$host/"), headers: {
          'content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        });

        switch (res.statusCode) {
          case 200:
            /*
            1. First, grab the res.body, and decode it as json, so you have access to the ['user'], since that
               is the format server is sending it back, recall, server is sending both user and token object back to you.
              
            2. Since the UserModel.fromJson() is expecting a string as a source, we need to jsonEncode the entire 
               jsonDecode(res.body)['user']. The Json encode expects an object btw.

            3. Remeber we still need the token, so using the copyWith, we'd include the token.
          */
            final newUser = UserModel.fromJson(
              jsonEncode(jsonDecode(res.body)['user']),
            ).copyWith(token: token);
            apiResponse = ApiResponseModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token);
            break;
          // You can do more error handling here, by capturing other statusCodes...
          default:
        }
      }
    } catch (e) {
      debugPrint('George Token Error: $e');
      apiResponse = ApiResponseModel(error: e.toString(), data: null);
    }
    return apiResponse;
  }

  void signOut() async {
    await _googleSignIn.signOut();
    _localStorageRepository.setToken("");
  }
}
