import 'package:either_dart/either.dart';
import '../entities/counter_entity.dart';

abstract class CounterRepository {
  Future<Either<Exception, CounterEntity>> getCounter();
  Future<Either<Exception, CounterEntity>> incrementCounter();
  Future<Either<Exception, CounterEntity>> decrementCounter();
  Future<Either<Exception, CounterEntity>> resetCounter();
}
