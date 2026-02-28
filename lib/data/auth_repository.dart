import 'package:scroll_architecture_task/core/dio_client.dart';

class AuthRepository {
  Future<String> login(String username, String password) async {
    final res = await DioClient.dio.post(
      "/auth/login",
      data: {
        "username": username,
        "password": password,
      },
    );
    return res.data['token'];
  }

  Future<Map<String, dynamic>> getUser() async {
    final res = await DioClient.dio.get("/users/1");
    return res.data;
  }
}