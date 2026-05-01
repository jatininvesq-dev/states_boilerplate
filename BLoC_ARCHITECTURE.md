# BLoC State Management Architecture

This project uses the **BLoC (Business Logic Component)** pattern with **Clean Architecture** for state management.

## Project Structure

```
lib/
├── app.dart                          # App configuration and BLoC providers
├── main.dart                         # Entry point
├── core/
│   ├── di/                          # Dependency Injection
│   │   └── app_injection.dart       # App-level BLoC initialization
│   ├── bloc/                        # App-level BLoCs (theme, auth, etc.)
│   ├── network/
│   ├── preferences/
│   ├── services/
│   └── utils/
└── features/
    └── counter/                     # Example feature
        ├── data/
        │   ├── datasources/         # Local/Remote data sources
        │   ├── models/              # Data models (extend entities)
        │   └── repositories/        # Repository implementations
        ├── domain/
        │   ├── entities/            # Pure data objects
        │   ├── repositories/        # Abstract repository interfaces
        │   └── usecases/            # Business logic
        └── presentation/
            ├── bloc/                # BLoC, Events, States
            ├── pages/               # Full pages
            └── widgets/             # Reusable components
```

## Key Concepts

### 1. **Events**
User actions or system events that trigger state changes.
```dart
class IncrementCounterEvent extends CounterEvent {
  const IncrementCounterEvent();
}
```

### 2. **States**
Different UI states: Loading, Loaded, Error, etc.
```dart
class CounterLoaded extends CounterState {
  final int value;
  const CounterLoaded({required this.value});
}
```

### 3. **BLoC**
Listens to events and emits states.
```dart
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc(...) : super(const CounterInitial()) {
    on<IncrementCounterEvent>(_onIncrementCounter);
  }

  Future<void> _onIncrementCounter(
    IncrementCounterEvent event,
    Emitter<CounterState> emit,
  ) async {
    emit(const CounterLoading());
    // Business logic via use cases
  }
}
```

### 4. **Use Cases**
Encapsulate single business operations.
```dart
class IncrementCounterUseCase {
  final CounterRepository repository;
  
  Future<Either<Exception, CounterEntity>> call() async {
    return await repository.incrementCounter();
  }
}
```

### 5. **Repository Pattern**
Abstract data operations and switch between data sources.
```dart
abstract class CounterRepository {
  Future<Either<Exception, CounterEntity>> incrementCounter();
}

class CounterRepositoryImpl implements CounterRepository {
  final CounterLocalDataSource localDataSource;
  
  @override
  Future<Either<Exception, CounterEntity>> incrementCounter() async {
    // Implementation
  }
}
```

### 6. **Data Sources**
Concrete implementations for fetching/storing data.
```dart
class CounterLocalDataSourceImpl implements CounterLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  Future<CounterModel> incrementCounter() async {
    final newValue = (sharedPreferences.getInt('counter') ?? 0) + 1;
    await sharedPreferences.setInt('counter', newValue);
    return CounterModel(value: newValue);
  }
}
```

## How to Use BLoC in Widgets

### Access BLoC with `context.read()`
```dart
ElevatedButton(
  onPressed: () => context.read<CounterBloc>().add(
    const IncrementCounterEvent(),
  ),
  child: const Text('Increment'),
)
```

### Listen to State Changes with `BlocBuilder`
```dart
BlocBuilder<CounterBloc, CounterState>(
  builder: (context, state) {
    if (state is CounterLoading) {
      return const CircularProgressIndicator();
    } else if (state is CounterLoaded) {
      return Text('Count: ${state.value}');
    } else if (state is CounterError) {
      return Text('Error: ${state.message}');
    }
    return const SizedBox.shrink();
  },
)
```

### Listen to Multiple Events with `BlocListener`
```dart
BlocListener<CounterBloc, CounterState>(
  listener: (context, state) {
    if (state is CounterLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Count: ${state.value}')),
      );
    }
  },
  child: Text('Counter'),
)
```

## Adding a New Feature

### Step 1: Create Feature Structure
```bash
lib/features/[feature_name]/
├── data/
│   ├── datasources/[feature]_datasource.dart
│   ├── models/[feature]_model.dart
│   └── repositories/[feature]_repository_impl.dart
├── domain/
│   ├── entities/[feature]_entity.dart
│   ├── repositories/[feature]_repository.dart
│   └── usecases/[operation]_usecase.dart
└── presentation/
    ├── bloc/[feature]_bloc.dart|event.dart|state.dart
    ├── pages/[feature]_page.dart
    └── widgets/[feature]_widget.dart
```

### Step 2: Create Domain Layer
1. Create entity (pure data object)
2. Create abstract repository
3. Create use cases

### Step 3: Create Data Layer
1. Create data source (local/remote)
2. Create model (extends entity)
3. Create repository implementation

### Step 4: Create Presentation Layer
1. Create events
2. Create states
3. Create BLoC
4. Create pages and widgets

### Step 5: Add to Dependency Injection
Update `lib/core/di/app_injection.dart`:
```dart
class AppBlocProviders {
  final CounterBloc counterBloc;
  final YourNewBloc yourNewBloc;

  AppBlocProviders({
    required this.counterBloc,
    required this.yourNewBloc,
  });
}
```

### Step 6: Provide BLoC in App
Update `lib/app.dart`:
```dart
BlocProvider(
  create: (context) => counterBloc,
  child: BlocProvider(
    create: (context) => yourNewBloc,
    child: MaterialApp(...),
  ),
)
```

## Best Practices

1. **One BLoC per feature** - Each feature has its own BLoC
2. **Use Either for error handling** - Use `Either<Exception, Result>` for safe error handling
3. **Keep BLoCs simple** - Delegate business logic to use cases
4. **Immutable states** - States should be immutable
5. **Use Equatable** - For state comparison and preventing unnecessary rebuilds
6. **Map models to entities** - Data layer works with models, domain layer with entities
7. **Close BLoCs** - BLoCs should be closed when not needed
8. **Dependency injection** - Use constructor injection for dependencies

## Error Handling

This project uses the `either_dart` package for functional error handling:

```dart
// In repository
Future<Either<Exception, CounterEntity>> incrementCounter() async {
  try {
    final result = await localDataSource.incrementCounter();
    return Right(result.toEntity());
  } on Exception catch (e) {
    return Left(e);
  }
}

// In BLoC
result.fold(
  (exception) => emit(CounterError(message: exception.toString())),
  (counter) => emit(CounterLoaded(value: counter.value)),
);
```

## State Management Flow

```
Widget → Event → BLoC → UseCase → Repository → DataSource → UI Update
   ↑                                                           ↓
   └───────────────────── State ───────────────────────────────┘
```

## Testing

Each layer can be tested independently:
- **Data Layer**: Test data sources and repositories
- **Domain Layer**: Test use cases
- **Presentation Layer**: Test BLoC and widgets

## Dependencies

- `flutter_bloc: ^9.1.1` - BLoC state management
- `bloc: ^9.2.0` - Core BLoC library
- `equatable: ^2.0.5` - Equality comparison
- `either_dart: ^1.0.0` - Functional error handling
- `shared_preferences: ^2.5.3` - Local data persistence
