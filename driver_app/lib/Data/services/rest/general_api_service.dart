import 'package:driver_app/Data/models/requests/change_password_request.dart';
import 'package:driver_app/Data/models/requests/login_driver_request.dart';
import 'package:driver_app/Data/models/requests/login_response.dart';
import 'package:driver_app/Data/models/requests/register_driver_request.dart';
import 'package:driver_app/Data/models/requests/register_driver_request_2.dart';
import 'package:driver_app/Data/providers/api_provider.dart';
import 'package:driver_app/core/exceptions/bussiness_exception.dart';
import 'package:driver_app/core/exceptions/unexpected_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GeneralAPIService {
  Future<void> login({required LoginDriverRequestBody body}) async {
    try {
      var response = await APIHandlerImp.instance
          .post(body.toJson(), '/Authentication/Login');

      if (response.data["status"]) {
        var body = LoginResponseBody.fromJson(response.data['data']);
        await _storeAllIdentity(body);

        if (body.isEmailValidated == false) {
          return Future.error(
              const AccountNotActiveException("This Account is not actived"));
        }
      } else {
        return Future.error(IBussinessException(
          response.data['message'],
          debugMessage: response.data['message'],
          place: "Login",
        ));
      }
    } catch (e) {
      return Future.error(
          UnexpectedException(context: "login", debugMessage: e.toString()));
    }
  }

  Future<void> loginByGoogle() async {
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    try {
      // begin sign in process

      final GoogleSignInAccount? gUser = await GoogleSignIn(
        scopes: [
          'https://www.googleapis.com/auth/userinfo.email',
          'https://www.googleapis.com/auth/userinfo.profile',
        ],
      ).signIn();

      if (gUser == null) {
        return Future.error(
            const CancelActionException(message: "Cancel Google Signin"));
      }
      // obtain auth detail from request
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // create a new credential for user
      final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);

      final body = {
        "loginToken": credential.accessToken,
        "role": "Driver",
      };

      var response = await APIHandlerImp.instance
          .post(body, "/Authentication/LoginWithGoogle");

      var responseBody = LoginResponseBody.fromJson(response.data['data']);
      await _storeAllIdentity(responseBody);

      // await FirebaseAuth.instance.signInWithCredential(credential);
    } on PlatformException catch (_) {
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "Google Login", debugMessage: e.toString()));
    }
  }

  Future<void> googleSignout() async {
    try {
      await GoogleSignIn().signOut();
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "Logout-google", debugMessage: e.toString()));
    }
  }

  Future<void> register(RegisterDriverRequestBody body) async {
    try {
      var response = await APIHandlerImp.instance
          .post(body.toJson(), '/Authentication/Register');
      if (response.data["status"]) {
      } else {
        return Future.error(IBussinessException(response.data['message']));
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "register-account", debugMessage: e.toString()));
    }
  }

  Future<void> registerV2(RegisterDriverRequestBodyV2 body) async {
    try {
      var response = await APIHandlerImp.instance
          .post(body.toJson(), '/Authentication/Register');
      if (response.data["status"]) {
      } else {
        return Future.error(IBussinessException(response.data['message']));
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "register-account-v2", debugMessage: e.toString()));
    }
  }

  Future<void> changePassword(ChangePasswordRequest body) async {
    try {
      var response = await APIHandlerImp.instance.post(
        body.toJson(),
        "/Authentication/ChangePassword",
        useToken: true,
      );
      if (response.data['status']) {
      } else {
        return Future.error(IBussinessException(response.data['message']));
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "change-password", debugMessage: e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      var response = await APIHandlerImp.instance.get(
        "/Authentication/Logout",
        useToken: true,
      );
      if (response.data['status']) {
      } else {
        return Future.error(IBussinessException(response.data['message']));
      }
    } catch (e) {
      return Future.error(
          UnexpectedException(context: "logout", debugMessage: e.toString()));
    } finally {
      await APIHandlerImp.instance.deleteToken();
    }
  }

  Future<void> refreshToken() async {
    try {
      var accessToken = await APIHandlerImp.instance.getAccessToken();
      var refreshToken = await APIHandlerImp.instance.getRefreshToken();

      var response = await APIHandlerImp.instance.post(
        {
          'AccessToken': accessToken,
          'RefreshToken': refreshToken,
        },
        "/Authentication/RetriveTokens",
      );
      if (response.data['status']) {
        var body = LoginResponseBody.fromJson(response.data['data']);
        await _storeAllIdentity(body);
      } else {
        return Future.error(UnexpectedException(
          message: "Something Happend Please Login Again",
          context: "Refresh Token",
          debugMessage: response.data['message'],
        ));
      }
    } catch (e) {
      await APIHandlerImp.instance.deleteToken();
      return Future.error(UnexpectedException(
          context: "Refresh Token", debugMessage: e.toString()));
    }
  }

  Future<void> requestActiveAccountOTP(String email) async {
    try {
      var accountId = await APIHandlerImp.instance.getIdentity();
      var body = {
        'email': email,
        'accountId': accountId,
      };
      var response = await APIHandlerImp.instance
          .post(body, "/Authentication/SendEmailActivateAccount");
      if (response.data['status']) {
      } else {
        return Future.error(UnexpectedException(
          context: "Active OTP",
          debugMessage: response.data['message'],
        ));
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "Request OTP", debugMessage: e.toString()));
    }
  }

  Future<void> activeAccountByOTP(String email, String activeOTP) async {
    try {
      var body = {
        'email': email,
        'OTP': activeOTP,
      };
      var response = await APIHandlerImp.instance
          .post(body, "/Authentication/ActivateAccount");
      if (response.data['status']) {
      } else {
        return Future.error(IBussinessException(
          response.data['message'],
          place: "Active OTP",
          debugMessage: response.data['message'],
        ));
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "Active OTP", debugMessage: e.toString()));
    }
  }

  Future<void> requestResetPassword(String email) async {
    debugPrint(email);
    try {
      var body = {
        'email': email,
      };
      var response = await APIHandlerImp.instance
          .post(body, "/Authentication/GetResetPasswordOTP");
      if (response.data['status']) {
      } else {
        return Future.error(UnexpectedException(
          context: "Request Resetpassword OTP",
          debugMessage: response.data['message'],
        ));
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "Request Resetpassword OTP", debugMessage: e.toString()));
    }
  }

  Future<void> resetPassword(
      String email, String newPassword, String otp) async {
    try {
      var body = {
        'email': email,
        'newPassword': newPassword,
        'OTP': otp,
      };
      var response = await APIHandlerImp.instance
          .post(body, "/Authentication/ResetPassword");
      if (response.data['status']) {
      } else {
        return Future.error(IBussinessException(
          response.data['message'],
          place: "Reset Password",
          debugMessage: response.data['message'],
        ));
      }
    } catch (e) {
      return Future.error(UnexpectedException(
          context: "Reset Password", debugMessage: e.toString()));
    }
  }
}

Future<void> _storeAllIdentity(LoginResponseBody body,
    {bool isRefreshToken = false}) async {
  if (!isRefreshToken) {
    await APIHandlerImp.instance.storeIdentity(body.accountId);
  }
  await APIHandlerImp.instance.storeRefreshToken(body.refreshToken);
  await APIHandlerImp.instance.storeAccessToken(body.accessToken);
}
