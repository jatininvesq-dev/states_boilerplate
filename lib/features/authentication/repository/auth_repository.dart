import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:states_app/core/global/constants/end_points.dart';
import 'package:states_app/services/api_services.dart';

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

  Future<Either<String, Map<String, dynamic>>> registerFaceData(
    List<double> faceEmbedding, {
    String? authToken,
  }) async {
    try {
      final data = {'faceEmbedding': faceEmbedding};

      final res = await _apiService.post(
        EndPoints.registerFace,
        data,
        options: authToken != null && authToken.isNotEmpty
            ? Options(headers: {'Authorization': 'Bearer $authToken'})
            : null,
      );

      if (res.isRight) {
        final statusCode = res.right.statusCode;
        if (statusCode == 201 || statusCode == 200) {
          return Right(Map<String, dynamic>.from(res.right.data as Map));
        }
        final responseData = res.right.data;
        if (responseData is Map) {
          return Left(
            responseData['error']?.toString() ??
                responseData['message']?.toString() ??
                'Failed to register face',
          );
        }
        return const Left('Failed to register face');
      }

      return Left(res.left);
    } catch (e) {
      if (e is Exception) {
        return Left(e.toString());
      }
      return const Left('An unexpected error occurred');
    }
  }
}
