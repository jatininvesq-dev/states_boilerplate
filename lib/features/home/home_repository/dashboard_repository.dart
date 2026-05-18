import 'package:dio/dio.dart';
import 'package:states_app/services/api_services.dart';

class DashboardRepository {
  final ApiService _apiService = ApiService();

  Future<dynamic> createPost(String? postImage, String? description) async {
    dynamic data;

    // Check if we have a local file path (not a network URL)
    if (postImage != null &&
        postImage.isNotEmpty &&
        !postImage.startsWith('http')) {
      final mapData = <String, dynamic>{};
      if (description != null) mapData['description'] = description;
      mapData['postImage'] = await MultipartFile.fromFile(postImage);

      data = FormData.fromMap(mapData);
    } else {
      data = <String, dynamic>{};
      if (postImage != null) data['postImage'] = postImage;
      if (description != null) data['description'] = description;
    }

    return await _apiService.post('/posts', data);
  }

  Future<dynamic> getAllPosts() async {
    return await _apiService.get('/posts');
  }

  Future<dynamic> getMyPosts() async {
    return await _apiService.get('/posts/my-posts');
  }

  Future<dynamic> updatePost(
    String id, {
    String? description,
    int? likeCount,
  }) async {
    final data = <String, dynamic>{};
    if (description != null) data['description'] = description;
    if (likeCount != null) data['likeCount'] = likeCount;

    return await _apiService.put('/posts/$id', data);
  }

  Future<dynamic> deletePost(String id) async {
    return await _apiService.delete('/posts/$id');
  }
}
