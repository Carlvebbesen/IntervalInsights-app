import 'package:clerk_auth/clerk_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:interval_insights_app/common/api/strava_api.dart';
import 'package:interval_insights_app/common/services/sercure_persistor.dart';
import 'package:interval_insights_app/common/utils/toast_helper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

class ClerkInstance {
  static final Auth auth = Auth(
    config: AuthConfig(
      publishableKey: const String.fromEnvironment("CLERK_AUTH_KEY"),
      persistor: SecurePersistor(),
    ),
  );

  Future<SessionToken> get getToken =>
      ClerkInstance.auth.sessionToken(templateName: "neon-session");
}

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class Unauthenticated extends AuthState {
  const Unauthenticated();
}

class VerifyOtpCode extends AuthState {
  final String email;
  final bool isSignUp;
  const VerifyOtpCode(this.email, this.isSignUp);

  @override
  List<Object?> get props => [email];
}

class StravaAuth extends AuthState {
  final String clerkUserId;
  const StravaAuth(this.clerkUserId);
  @override
  List<Object?> get props => [clerkUserId];
}

class Authenticated extends AuthState {
  final String clerkUserId;
  const Authenticated(this.clerkUserId);
  @override
  List<Object?> get props => [clerkUserId];
}

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  Auth get _clerkAuth => ClerkInstance.auth;

  @override
  Future<AuthState> build() async {
    try {
      await _clerkAuth.initialize();
      final user = _clerkAuth.user;
      if (user != null) {
        return await _handlePostLogin(user);
      }
      return const Unauthenticated();
    } catch (e) {
      ToastHelper.showError(title: "noe gikk galt");
      return const Unauthenticated();
    }
  }

  Future<void> signUp(String email, String firstName, String lastName) async {
    await _executeSafeAuth(() async {
      await _clerkAuth.attemptSignUp(
        strategy: Strategy.emailCode,
        emailAddress: email,
        firstName: firstName,
        lastName: lastName,
      );
      return VerifyOtpCode(email, true);
    });
  }

  Future<void> requestOtp(String email) async {
    await _executeSafeAuth(() async {
      await _clerkAuth.attemptSignIn(
        strategy: Strategy.emailCode,
        identifier: email,
      );

      final signIn = _clerkAuth.signIn;
      if (signIn != null && signIn.status.needsFactor) {
        final strategy =
            signIn.firstFactorVerification?.strategy ??
            signIn.secondFactorVerification?.strategy;
        if (strategy == Strategy.emailCode) {
          return VerifyOtpCode(email, false);
        }
      }
      final user = _clerkAuth.user;
      if (user != null) {
        return await _handlePostLogin(user);
      }
      throw Exception("Could not initiate OTP flow. Status: ${signIn?.status}");
    });
  }

  Future<void> verifyOtpCode(String code) async {
    final tmp = state.value;
    if (tmp is! VerifyOtpCode) {
      state = const AsyncData(Unauthenticated());
      return;
    }

    return _executeSafeAuth(() async {
      tmp.isSignUp
          ? await _clerkAuth.attemptSignUp(
              strategy: Strategy.emailCode,
              emailAddress: tmp.email,
              code: code,
            )
          : await _clerkAuth.attemptSignIn(
              strategy: Strategy.emailCode,
              identifier: tmp.email,
              code: code,
            );
      final user = _clerkAuth.user;
      if (user == null) {
        throw Exception('Verification failed or incomplete.');
      }
      return await _handlePostLogin(user);
    }, setGlobalLoading: false);
  }

  Future<void> resendOtp() async {
    final tmp = state.value;
    if (tmp is! VerifyOtpCode) {
      state = const AsyncData(Unauthenticated());
      return;
    }

    await _executeSafeAuth(() async {
      await _clerkAuth.resetClient();
      tmp.isSignUp
          ? await _clerkAuth.attemptSignUp(
              strategy: Strategy.emailCode,
              emailAddress: tmp.email,
            )
          : await _clerkAuth.attemptSignIn(
              strategy: Strategy.emailCode,
              identifier: tmp.email,
            );
      return VerifyOtpCode(tmp.email, tmp.isSignUp);
    }, setGlobalLoading: false);
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    try {
      await _clerkAuth.signOut();
    } catch (e) {
      ToastHelper.showError(title: "error_occurred");
    } finally {
      state = const AsyncData(Unauthenticated());
    }
  }

  Future<void> _executeSafeAuth(
    Future<AuthState> Function() action, {
    bool setGlobalLoading = true,
  }) async {
    final prevState = state;
    if (setGlobalLoading) {
      state = const AsyncLoading();
    }
    try {
      final newState = await action();
      state = AsyncData(newState);
    } catch (e) {
      ToastHelper.showError(title: "error_occurred");
      final previousAuthData = prevState.value;
      final fallback = previousAuthData is VerifyOtpCode
          ? previousAuthData
          : const Unauthenticated();
      state = AsyncData(fallback);
    }
  }

  Future<AuthState> _handlePostLogin(User user) async {
    final isConnectedToStrava =
        user.publicMetadata?["strava_connected"] == true;
    if (isConnectedToStrava) {
      return Authenticated(user.id);
    }
    return StravaAuth(user.id);
  }

  Future<AuthState> handleStravaAuthCompleted(String code) async {
    await StravaService().exchangeCode(code);
    ToastHelper.showFeedback(title: "Strava Connected!");
    final current = state.value;
    AuthState updatedState = const Unauthenticated();
    if (current is StravaAuth) {
      updatedState = Authenticated(current.clerkUserId);
    }
    state = AsyncData(updatedState);
    return updatedState;
  }

  Future<SessionToken> getAuthToken() async {
    try {
      return await ClerkInstance().getToken;
    } catch (error) {
      await signOut();
      rethrow;
    }
  }
}
