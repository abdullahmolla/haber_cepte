import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haber_cepte/app/views/auth/view_models/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      emit(const AuthLoading());

      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      emit(const AuthSuccess());
    } on FirebaseAuthException catch (error) {
      emit(AuthError(error.message ?? 'Giriş işlemi başarısız oldu.'));
    } catch (_) {
      emit(const AuthError('Beklenmeyen bir hata oluştu.'));
    }
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    try {
      emit(const AuthLoading());

      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      emit(const AuthSuccess());
    } on FirebaseAuthException catch (error) {
      emit(AuthError(error.message ?? 'Kayıt işlemi başarısız oldu.'));
    } catch (_) {
      emit(const AuthError('Beklenmeyen bir hata oluştu.'));
    }
  }

  Future<void> forgotPassword({
    required String email,
  }) async {
    try {
      emit(const AuthLoading());

      await _firebaseAuth.sendPasswordResetEmail(
        email: email.trim(),
      );

      emit(const AuthSuccess());
    } on FirebaseAuthException catch (error) {
      emit(AuthError(error.message ?? 'Şifre sıfırlama işlemi başarısız oldu.'));
    } catch (_) {
      emit(const AuthError('Beklenmeyen bir hata oluştu.'));
    }
  }
}