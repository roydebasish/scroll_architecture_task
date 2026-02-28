import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_architecture_task/core/token_storage.dart';
import 'package:scroll_architecture_task/data/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo;

  AuthBloc(this.repo) : super(const AuthState()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);

    // Check auth status when bloc is created
    add(CheckAuthStatus());
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      // Call login API
      final token = await repo.login(event.username, event.password);

      // Save token
      await TokenStorage.save(token);

      // Fetch user profile
      final user = await repo.getUser();

      emit(state.copyWith(
        loading: false,
        authenticated: true,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(
        loading: false,
        authenticated: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthState> emit) async {
    await TokenStorage.clear();
    emit(const AuthState(authenticated: false));
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event, Emitter<AuthState> emit) async {

    final token = await TokenStorage.get();

    if (token != null) {
      try {
        final user = await repo.getUser();
        emit(state.copyWith(
          authenticated: true,
          checking: false,
          user: user,
        ));
      } catch (_) {
        await TokenStorage.clear();
        emit(const AuthState(
          authenticated: false,
          checking: false,
        ));
      }
    } else {
      emit(const AuthState(
        authenticated: false,
        checking: false,
      ));
    }
  }
}