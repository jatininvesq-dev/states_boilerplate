// TEMPLATE: Use this as a reference to create new features with BLoC
// Replace [FeatureName] with your actual feature name (e.g., 'User', 'Product')

// ============================================================================
// STEP 1: Create Entity (domain/entities/[feature]_entity.dart)
// ============================================================================
/*
class [FeatureName]Entity {
  final String id;
  final String name;

  [FeatureName]Entity({
    required this.id,
    required this.name,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is [FeatureName]Entity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
*/

// ============================================================================
// STEP 2: Create Abstract Repository (domain/repositories/[feature]_repository.dart)
// ============================================================================
/*
import 'package:either_dart/either.dart';
import '../entities/[feature]_entity.dart';

abstract class [FeatureName]Repository {
  Future<Either<Exception, [FeatureName]Entity>> get[FeatureName](String id);
  Future<Either<Exception, List<[FeatureName]Entity>>> get[FeatureName]s();
  Future<Either<Exception, [FeatureName]Entity>> create[FeatureName]([FeatureName]Entity entity);
  Future<Either<Exception, [FeatureName]Entity>> update[FeatureName]([FeatureName]Entity entity);
  Future<Either<Exception, void>> delete[FeatureName](String id);
}
*/

// ============================================================================
// STEP 3: Create Use Cases (domain/usecases/[operation]_usecase.dart)
// ============================================================================
/*
import 'package:either_dart/either.dart';
import '../entities/[feature]_entity.dart';
import '../repositories/[feature]_repository.dart';

class Get[FeatureName]UseCase {
  final [FeatureName]Repository repository;

  Get[FeatureName]UseCase(this.repository);

  Future<Either<Exception, [FeatureName]Entity>> call(String id) async {
    return await repository.get[FeatureName](id);
  }
}

class Create[FeatureName]UseCase {
  final [FeatureName]Repository repository;

  Create[FeatureName]UseCase(this.repository);

  Future<Either<Exception, [FeatureName]Entity>> call([FeatureName]Entity entity) async {
    return await repository.create[FeatureName](entity);
  }
}
*/

// ============================================================================
// STEP 4: Create Model (data/models/[feature]_model.dart)
// ============================================================================
/*
import '../../domain/entities/[feature]_entity.dart';

class [FeatureName]Model extends [FeatureName]Entity {
  [FeatureName]Model({
    required super.id,
    required super.name,
  });

  factory [FeatureName]Model.fromEntity([FeatureName]Entity entity) {
    return [FeatureName]Model(
      id: entity.id,
      name: entity.name,
    );
  }

  factory [FeatureName]Model.fromJson(Map<String, dynamic> json) {
    return [FeatureName]Model(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };

  [FeatureName]Entity toEntity() => [FeatureName]Entity(
    id: id,
    name: name,
  );
}
*/

// ============================================================================
// STEP 5: Create Data Source (data/datasources/[feature]_datasource.dart)
// ============================================================================
/*
import 'package:shared_preferences/shared_preferences.dart';
import '../models/[feature]_model.dart';

abstract class [FeatureName]LocalDataSource {
  Future<[FeatureName]Model> get[FeatureName](String id);
  Future<List<[FeatureName]Model>> get[FeatureName]s();
  Future<[FeatureName]Model> create[FeatureName]([FeatureName]Model model);
  Future<[FeatureName]Model> update[FeatureName]([FeatureName]Model model);
  Future<void> delete[FeatureName](String id);
}

class [FeatureName]LocalDataSourceImpl implements [FeatureName]LocalDataSource {
  final SharedPreferences sharedPreferences;

  [FeatureName]LocalDataSourceImpl({required this.sharedPreferences});

  static const String _key[FeatureName] = '[feature_name]_list';

  @override
  Future<[FeatureName]Model> get[FeatureName](String id) async {
    // Implementation
    throw UnimplementedError();
  }

  @override
  Future<List<[FeatureName]Model>> get[FeatureName]s() async {
    // Implementation
    throw UnimplementedError();
  }

  @override
  Future<[FeatureName]Model> create[FeatureName]([FeatureName]Model model) async {
    // Implementation
    throw UnimplementedError();
  }

  @override
  Future<[FeatureName]Model> update[FeatureName]([FeatureName]Model model) async {
    // Implementation
    throw UnimplementedError();
  }

  @override
  Future<void> delete[FeatureName](String id) async {
    // Implementation
    throw UnimplementedError();
  }
}

// Optional: Remote Data Source
abstract class [FeatureName]RemoteDataSource {
  Future<[FeatureName]Model> get[FeatureName](String id);
  Future<List<[FeatureName]Model>> get[FeatureName]s();
  Future<[FeatureName]Model> create[FeatureName]([FeatureName]Model model);
  Future<[FeatureName]Model> update[FeatureName]([FeatureName]Model model);
  Future<void> delete[FeatureName](String id);
}

class [FeatureName]RemoteDataSourceImpl implements [FeatureName]RemoteDataSource {
  // Use Dio or your HTTP client here
  
  @override
  Future<[FeatureName]Model> get[FeatureName](String id) async {
    // Implementation
    throw UnimplementedError();
  }

  @override
  Future<List<[FeatureName]Model>> get[FeatureName]s() async {
    // Implementation
    throw UnimplementedError();
  }

  @override
  Future<[FeatureName]Model> create[FeatureName]([FeatureName]Model model) async {
    // Implementation
    throw UnimplementedError();
  }

  @override
  Future<[FeatureName]Model> update[FeatureName]([FeatureName]Model model) async {
    // Implementation
    throw UnimplementedError();
  }

  @override
  Future<void> delete[FeatureName](String id) async {
    // Implementation
    throw UnimplementedError();
  }
}
*/

// ============================================================================
// STEP 6: Create Repository Implementation (data/repositories/[feature]_repository_impl.dart)
// ============================================================================
/*
import 'package:either_dart/either.dart';
import '../../domain/entities/[feature]_entity.dart';
import '../../domain/repositories/[feature]_repository.dart';
import '../datasources/[feature]_datasource.dart';

class [FeatureName]RepositoryImpl implements [FeatureName]Repository {
  final [FeatureName]LocalDataSource localDataSource;
  final [FeatureName]RemoteDataSource remoteDataSource;

  [FeatureName]RepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Exception, [FeatureName]Entity>> get[FeatureName](String id) async {
    try {
      final result = await remoteDataSource.get[FeatureName](id);
      return Right(result.toEntity());
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, List<[FeatureName]Entity>>> get[FeatureName]s() async {
    try {
      final result = await remoteDataSource.get[FeatureName]s();
      return Right(result.map((e) => e.toEntity()).toList());
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, [FeatureName]Entity>> create[FeatureName]([FeatureName]Entity entity) async {
    try {
      final model = [FeatureName]Model.fromEntity(entity);
      final result = await remoteDataSource.create[FeatureName](model);
      return Right(result.toEntity());
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, [FeatureName]Entity>> update[FeatureName]([FeatureName]Entity entity) async {
    try {
      final model = [FeatureName]Model.fromEntity(entity);
      final result = await remoteDataSource.update[FeatureName](model);
      return Right(result.toEntity());
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, void>> delete[FeatureName](String id) async {
    try {
      await remoteDataSource.delete[FeatureName](id);
      return const Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
*/

// ============================================================================
// STEP 7: Create Events (presentation/bloc/[feature]_event.dart)
// ============================================================================
/*
part of '[feature]_bloc.dart';

abstract class [FeatureName]Event extends Equatable {
  const [FeatureName]Event();

  @override
  List<Object?> get props => [];
}

class Get[FeatureName]Event extends [FeatureName]Event {
  final String id;
  const Get[FeatureName]Event(this.id);

  @override
  List<Object?> get props => [id];
}

class Get[FeatureName]sEvent extends [FeatureName]Event {
  const Get[FeatureName]sEvent();
}

class Create[FeatureName]Event extends [FeatureName]Event {
  final [FeatureName]Entity entity;
  const Create[FeatureName]Event(this.entity);

  @override
  List<Object?> get props => [entity];
}

class Update[FeatureName]Event extends [FeatureName]Event {
  final [FeatureName]Entity entity;
  const Update[FeatureName]Event(this.entity);

  @override
  List<Object?> get props => [entity];
}

class Delete[FeatureName]Event extends [FeatureName]Event {
  final String id;
  const Delete[FeatureName]Event(this.id);

  @override
  List<Object?> get props => [id];
}
*/

// ============================================================================
// STEP 8: Create States (presentation/bloc/[feature]_state.dart)
// ============================================================================
/*
part of '[feature]_bloc.dart';

abstract class [FeatureName]State extends Equatable {
  const [FeatureName]State();

  @override
  List<Object?> get props => [];
}

class [FeatureName]Initial extends [FeatureName]State {
  const [FeatureName]Initial();
}

class [FeatureName]Loading extends [FeatureName]State {
  const [FeatureName]Loading();
}

class [FeatureName]Loaded extends [FeatureName]State {
  final [FeatureName]Entity data;
  const [FeatureName]Loaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class [FeatureName]sLoaded extends [FeatureName]State {
  final List<[FeatureName]Entity> data;
  const [FeatureName]sLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class [FeatureName]Error extends [FeatureName]State {
  final String message;
  const [FeatureName]Error({required this.message});

  @override
  List<Object?> get props => [message];
}

class [FeatureName]Success extends [FeatureName]State {
  final String message;
  const [FeatureName]Success({required this.message});

  @override
  List<Object?> get props => [message];
}
*/

// ============================================================================
// STEP 9: Create BLoC (presentation/bloc/[feature]_bloc.dart)
// ============================================================================
/*
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/[feature]_entity.dart';
import '../../domain/usecases/get_[feature]_usecase.dart';
import '../../domain/usecases/create_[feature]_usecase.dart';
import '../../domain/usecases/update_[feature]_usecase.dart';
import '../../domain/usecases/delete_[feature]_usecase.dart';

part '[feature]_event.dart';
part '[feature]_state.dart';

class [FeatureName]Bloc extends Bloc<[FeatureName]Event, [FeatureName]State> {
  final Get[FeatureName]UseCase get[FeatureName]UseCase;
  final Create[FeatureName]UseCase create[FeatureName]UseCase;
  final Update[FeatureName]UseCase update[FeatureName]UseCase;
  final Delete[FeatureName]UseCase delete[FeatureName]UseCase;

  [FeatureName]Bloc({
    required this.get[FeatureName]UseCase,
    required this.create[FeatureName]UseCase,
    required this.update[FeatureName]UseCase,
    required this.delete[FeatureName]UseCase,
  }) : super(const [FeatureName]Initial()) {
    on<Get[FeatureName]Event>(_onGet[FeatureName]);
    on<Create[FeatureName]Event>(_onCreate[FeatureName]);
    on<Update[FeatureName]Event>(_onUpdate[FeatureName]);
    on<Delete[FeatureName]Event>(_onDelete[FeatureName]);
  }

  Future<void> _onGet[FeatureName](
    Get[FeatureName]Event event,
    Emitter<[FeatureName]State> emit,
  ) async {
    emit(const [FeatureName]Loading());
    final result = await get[FeatureName]UseCase(event.id);
    result.fold(
      (exception) => emit([FeatureName]Error(message: exception.toString())),
      ([FeatureName] data) => emit([FeatureName]Loaded(data: data)),
    );
  }

  Future<void> _onCreate[FeatureName](
    Create[FeatureName]Event event,
    Emitter<[FeatureName]State> emit,
  ) async {
    emit(const [FeatureName]Loading());
    final result = await create[FeatureName]UseCase(event.entity);
    result.fold(
      (exception) => emit([FeatureName]Error(message: exception.toString())),
      ([FeatureName] data) => emit(const [FeatureName]Success(message: 'Created successfully')),
    );
  }

  Future<void> _onUpdate[FeatureName](
    Update[FeatureName]Event event,
    Emitter<[FeatureName]State> emit,
  ) async {
    emit(const [FeatureName]Loading());
    final result = await update[FeatureName]UseCase(event.entity);
    result.fold(
      (exception) => emit([FeatureName]Error(message: exception.toString())),
      ([FeatureName] data) => emit(const [FeatureName]Success(message: 'Updated successfully')),
    );
  }

  Future<void> _onDelete[FeatureName](
    Delete[FeatureName]Event event,
    Emitter<[FeatureName]State> emit,
  ) async {
    emit(const [FeatureName]Loading());
    final result = await delete[FeatureName]UseCase(event.id);
    result.fold(
      (exception) => emit([FeatureName]Error(message: exception.toString())),
      (_) => emit(const [FeatureName]Success(message: 'Deleted successfully')),
    );
  }
}
*/

// ============================================================================
// STEP 10: Create Pages & Widgets (presentation/pages and widgets)
// ============================================================================
/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/[feature]_bloc.dart';

class [FeatureName]Page extends StatefulWidget {
  const [FeatureName]Page({super.key});

  @override
  State<[FeatureName]Page> createState() => _[FeatureName]PageState();
}

class _[FeatureName]PageState extends State<[FeatureName]Page> {
  @override
  void initState() {
    super.initState();
    // Load initial data
    context.read<[FeatureName]Bloc>().add(const Get[FeatureName]sEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('[FeatureName]')),
      body: BlocBuilder<[FeatureName]Bloc, [FeatureName]State>(
        builder: (context, state) {
          if (state is [FeatureName]Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is [FeatureName]Loaded) {
            return Center(child: Text(state.data.toString()));
          } else if (state is [FeatureName]Error) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
*/

// ============================================================================
// STEP 11: Create Dependency Injection ([feature]_injection.dart)
// ============================================================================
/*
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasources/[feature]_datasource.dart';
import 'data/repositories/[feature]_repository_impl.dart';
import 'domain/repositories/[feature]_repository.dart';
import 'domain/usecases/get_[feature]_usecase.dart';
import 'domain/usecases/create_[feature]_usecase.dart';
import 'domain/usecases/update_[feature]_usecase.dart';
import 'domain/usecases/delete_[feature]_usecase.dart';
import 'presentation/bloc/[feature]_bloc.dart';

class [FeatureName]Injection {
  static Future<[FeatureName]Bloc> init[FeatureName](
    SharedPreferences sharedPreferences,
  ) async {
    // DataSources
    final [feature]LocalDataSource = [FeatureName]LocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
    );
    final [feature]RemoteDataSource = [FeatureName]RemoteDataSourceImpl();

    // Repository
    final [FeatureName]Repository [feature]Repository = [FeatureName]RepositoryImpl(
      localDataSource: [feature]LocalDataSource,
      remoteDataSource: [feature]RemoteDataSource,
    );

    // Use Cases
    final get[FeatureName]UseCase = Get[FeatureName]UseCase([feature]Repository);
    final create[FeatureName]UseCase = Create[FeatureName]UseCase([feature]Repository);
    final update[FeatureName]UseCase = Update[FeatureName]UseCase([feature]Repository);
    final delete[FeatureName]UseCase = Delete[FeatureName]UseCase([feature]Repository);

    // BLoC
    return [FeatureName]Bloc(
      get[FeatureName]UseCase: get[FeatureName]UseCase,
      create[FeatureName]UseCase: create[FeatureName]UseCase,
      update[FeatureName]UseCase: update[FeatureName]UseCase,
      delete[FeatureName]UseCase: delete[FeatureName]UseCase,
    );
  }
}
*/

// ============================================================================
// STEP 12: Update AppInjection (core/di/app_injection.dart)
// ============================================================================
/*
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/[feature]/[feature]_injection.dart';
import '../../features/[feature]/presentation/bloc/[feature]_bloc.dart';
import '../../features/counter/counter_injection.dart';
import '../../features/counter/presentation/bloc/counter_bloc.dart';

class AppInjection {
  static Future<AppBlocProviders> init() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    // Initialize all feature BLoCs
    final counterBloc = await CounterInjection.initCounter(sharedPreferences);
    final [feature]Bloc = await [FeatureName]Injection.init[FeatureName](sharedPreferences);

    return AppBlocProviders(
      counterBloc: counterBloc,
      [feature]Bloc: [feature]Bloc,
    );
  }
}

class AppBlocProviders {
  final CounterBloc counterBloc;
  final [FeatureName]Bloc [feature]Bloc;

  AppBlocProviders({
    required this.counterBloc,
    required this.[feature]Bloc,
  });
}
*/
