import 'package:driver_app/Data/models/requests/change_password_request.dart';
import 'package:driver_app/Data/models/requests/login_driver_request.dart';
import 'package:driver_app/Data/models/requests/login_response.dart';
import 'package:driver_app/Data/models/requests/register_driver_request.dart';
import 'package:driver_app/Data/providers/api_provider.dart';
import 'package:driver_app/core/exceptions/bussiness_exception.dart';
import 'package:driver_app/core/exceptions/unexpected_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GeneralAPIService {
  Future<void> login({required LoginDriverRequestBody body}) async {
    try {
      var response = await APIHandlerImp.instance
          .post(body.toJson(), '/Authentication/Login');

      if (response.data["status"]) {
        var body = LoginResponseBody.fromJson(response.data['data']);
        print("Login Result: ${body.toJson()}");
        await _storeAllIdentity(body);
      } else {
        return Future.error(IBussinessException(response.data['message']));
      }
    } catch (e) {
      return Future.error(
          UnexpectedException(context: "login", debugMessage: e.toString()));
    }
  }

  Future<void> loginByGoogle() async {
    try {
      // begin sign in process

      await GoogleSignIn().signOut();
      final GoogleSignInAccount? gUser = await GoogleSignIn(
        scopes: [
          // 'https://www.googleapis.com/auth/userinfo.email',
          // 'https://www.googleapis.com/auth/userinfo.profile',
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ],
      ).signIn();

      // obtain auth detail from request
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      // create a new credential for user
      final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);

      print(credential);

      // await FirebaseAuth.instance.signInWithCredential(credential);
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
}

Future<void> _storeAllIdentity(LoginResponseBody body) async {
  await APIHandlerImp.instance.storeIdentity(body.accountId);
  await APIHandlerImp.instance.storeRefreshToken(body.refreshToken);
  await APIHandlerImp.instance.storeAccessToken(body.accessToken);
}
