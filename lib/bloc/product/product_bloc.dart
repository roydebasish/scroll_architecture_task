import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_architecture_task/data/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repo;

  ProductBloc(this.repo) : super(const ProductState()) {
    on<LoadProducts>(_onLoadProducts);
  }

  Future<void> _onLoadProducts(
      LoadProducts event, Emitter<ProductState> emit) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      final products = await repo.fetchProducts();

      final electronics =
          products.where((e) => e['category'] == "electronics").toList();
      final jewelery =
          products.where((e) => e['category'] == "jewelery").toList();
      final mens =
          products.where((e) => e['category'] == "men's clothing").toList();

      emit(state.copyWith(
        loading: false,
        electronics: electronics,
        jewelery: jewelery,
        mens: mens,
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}