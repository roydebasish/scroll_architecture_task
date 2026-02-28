import 'package:equatable/equatable.dart';

class ProductState extends Equatable {
  final bool loading;
  final List electronics;
  final List jewelery;
  final List mens;
  final String? error;

  const ProductState({
    this.loading = false,
    this.electronics = const [],
    this.jewelery = const [],
    this.mens = const [],
    this.error,
  });

  ProductState copyWith({
    bool? loading,
    List? electronics,
    List? jewelery,
    List? mens,
    String? error,
    bool clearError = false,
  }) {
    return ProductState(
      loading: loading ?? this.loading,
      electronics: electronics ?? this.electronics,
      jewelery: jewelery ?? this.jewelery,
      mens: mens ?? this.mens,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
        loading,
        electronics,
        jewelery,
        mens,
        error,
      ];
}