import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final bool loading;
  final bool authenticated;
  final bool checking;
  final Map<String, dynamic>? user;
  final String? error;

  const AuthState({
    this.loading = false,
    this.authenticated = false,
    this.checking = true,
    this.user,
    this.error,
  });

  AuthState copyWith({
    bool? loading,
    bool? authenticated,
    bool? checking,
    Map<String, dynamic>? user,
    String? error,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      authenticated: authenticated ?? this.authenticated,
      checking: checking ?? this.checking,
      user: user ?? this.user,
      error: error,
    );
  }

  @override
  List<Object?> get props => [loading, authenticated, checking, user, error];
}