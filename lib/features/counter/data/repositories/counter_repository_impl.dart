import 'package:either_dart/either.dart';
import '../../domain/entities/counter_entity.dart';
import '../../domain/repositories/counter_repository.dart';
import '../datasources/counter_local_datasource.dart';

class CounterRepositoryImpl implements CounterRepository {
  final CounterLocalDataSource localDataSource;

  CounterRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Exception, CounterEntity>> getCounter() async {
    try {
      final result = await localDataSource.getCounter();
      return Right(result.toEntity());
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, CounterEntity>> incrementCounter() async {
    try {
      final result = await localDataSource.incrementCounter();
      return Right(result.toEntity());
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, CounterEntity>> decrementCounter() async {
    try {
      final result = await localDataSource.decrementCounter();
      return Right(result.toEntity());
    } on Exception catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Exception, CounterEntity>> resetCounter() async {
    try {
      final result = await localDataSource.resetCounter();
      return Right(result.toEntity());
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
