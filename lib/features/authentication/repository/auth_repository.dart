import 'package:states_app/core/global/constants/end_points.dart';
import 'package:states_app/services/api_services.dart';
import 'package:either_dart/either.dart';

class AuthRepository {
  ApiService _apiService = ApiService();

  Future<Either<String, Map<String, dynamic>>> register(
    Map<String, String> data,
  ) async {
    try {
      final res = await _apiService.post(EndPoints.register, data);
      if (res.isRight) {
        if (res.right.statusCode == 201) {
          return Right(res.right.data);
        } else {
          return Left(res.right.data['message']);
        }
      } else {
        return Left(res.left);
      }
    } catch (e) {
      if (e is Exception) {
        return Left(e.toString());
      }
      return Left('An unexpected error occurred');
    }
  }

  Future<Either<String, Map<String, dynamic>>> login(
    Map<String, String> data,
  ) async {
    try {
      final res = await _apiService.post(EndPoints.login, data);
      if (res.isRight) {
        if (res.right.statusCode == 200) {
          return Right(res.right.data);
        } else {
          return Left(res.right.data['message']);
        }
      } else {
        return Left(res.left);
      }
    } catch (e) {
      if (e is Exception) {
        return Left(e.toString());
      }
      return Left('An unexpected error occurred');
    }
  }
}
