import 'package:states_app/core/global/constants/end_points.dart';
import 'package:states_app/services/api_services.dart';
import 'package:either_dart/either.dart';

class HomeRepository {
  final ApiService _apiService = ApiService();

  Future<Either<String, Map<String, dynamic>>> getProfile() async {
    try {
      final res = await _apiService.get(EndPoints.getProfile);
      if (res.isRight) {
        if (res.right.statusCode == 200) {
          return Right(res.right.data);
        } else {
          return Left(res.right.data['message'] ?? 'Failed to load profile');
        }
      } else {
        return Left(res.left);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, Map<String, dynamic>>> getAllUsers() async {
    try {
      final res = await _apiService.get(EndPoints.getAllUsers);
      if (res.isRight) {
        if (res.right.statusCode == 200) {
          return Right(res.right.data);
        } else {
          return Left(res.right.data['message'] ?? 'Failed to load users');
        }
      } else {
        return Left(res.left);
      }
    } catch (e) {
      if (e is Exception) {
        return Left(e.toString());
      }
      return const Left('An unexpected error occurred');
    }
  }
}
