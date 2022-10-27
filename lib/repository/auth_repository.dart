import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:quick_docs/models/api_response_model.dart';
import 'package:quick_docs/models/user_model.dart';
import 'package:quick_docs/utils/api.dart';
import 'package:riverpod/riverpod.dart';

// Creating an authRepo provider, to make it globally accessible.
// Using just Provider, as it's a read only situation.
// I'd have to pass in an Instance of the GoogleSignIn to it too

final authRepositoryProvider = Provider((ref) => AuthRepository(
      googleSignin: GoogleSignIn(),
      client: Client(),
    ));

// This stateprovider will help us update the userProvider after the user logs in.
// It'll be null, if the user is not logged in, or has a data with a model of UserModel, if the user is logged.
// Hence using the '?' for the <UserModel?>
final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;

  AuthRepository({
    required GoogleSignIn googleSignin,
    required Client client,
  })  : _googleSignIn = googleSignin,
        _client = client;

  Future<ApiResponseModel> signInWithGoogle() async {
    ApiResponseModel apiResponse = ApiResponseModel(
      error: "Oops!!! An error occured.",
      data: null,
    );
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAcc = UserModel(
          profilePic: user.photoUrl.toString(),
          email: user.email,
          name: user.displayName.toString(),
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
                uid: jsonDecode(res.body)['user']['_id']);
            apiResponse = ApiResponseModel(error: null, data: newUser);
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
}
