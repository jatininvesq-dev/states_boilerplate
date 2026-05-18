import 'package:flutter/foundation.dart';
import 'package:states_app/features/home/home_repository/dashboard_repository.dart';
import 'package:states_app/features/home/model/post_model.dart';

class DashboardProvider with ChangeNotifier {
  final DashboardRepository _repository = DashboardRepository();

  List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchPosts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.getAllPosts();

    result.fold(
      (leftError) {
        _error = leftError;
        _isLoading = false;
        notifyListeners();
      },
      (response) {
        if (response.statusCode == 200) {
          final data = response.data['posts'] as List;
          _posts = data.map((json) => PostModel.fromJson(json)).toList();
        } else {
          _error = 'Failed to fetch posts';
        }
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  List<PostModel> _myPosts = [];
  List<PostModel> get myPosts => _myPosts;

  bool _isMyPostsLoading = false;
  bool get isMyPostsLoading => _isMyPostsLoading;

  Future<void> fetchMyPosts() async {
    _isMyPostsLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.getMyPosts();

    result.fold(
      (leftError) {
        _error = leftError;
        _isMyPostsLoading = false;
        notifyListeners();
      },
      (response) {
        if (response.statusCode == 200) {
          final data = response.data['posts'] as List;
          _myPosts = data.map((json) => PostModel.fromJson(json)).toList();
        } else {
          _error = 'Failed to fetch my posts';
        }
        _isMyPostsLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> addPost(String? image, String? desc) async {
    final result = await _repository.createPost(image, desc);
    result.fold((leftError) => print('Error adding post: $leftError'), (
      response,
    ) {
      if (response.statusCode == 201) {
        fetchPosts(); // Refresh list after adding
        fetchMyPosts();
      }
    });
  }

  Future<void> editPost(String id, String? desc, int? likeCount) async {
    final result = await _repository.updatePost(
      id,
      description: desc,
      likeCount: likeCount,
    );
    result.fold((leftError) => print('Error updating post: $leftError'), (
      response,
    ) {
      if (response.statusCode == 200) {
        fetchPosts(); // Refresh list after editing
        fetchMyPosts();
      }
    });
  }

  Future<void> removePost(String id) async {
    final result = await _repository.deletePost(id);
    result.fold((leftError) => print('Error deleting post: $leftError'), (
      response,
    ) {
      if (response.statusCode == 200) {
        fetchPosts(); // Refresh list after deleting
        fetchMyPosts();
      }
    });
  }
}
