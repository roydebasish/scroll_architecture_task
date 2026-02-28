import 'package:scroll_architecture_task/core/dio_client.dart';

class ProductRepository {
  Future<List> fetchProducts() async {
    final res = await DioClient.dio.get("/products");
    return res.data;
  }
}