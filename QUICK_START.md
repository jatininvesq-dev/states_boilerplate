# Quick Start Guide - BLoC State Management

## What's Been Updated

Your Flutter project now uses **BLoC State Management** with **Clean Architecture**. Here's what was set up:

### ✅ Created Files Structure

```
lib/
├── app.dart (UPDATED)                    # Now uses BlocProvider
├── main.dart (UPDATED)                   # Initializes BLoCs via dependency injection
│
├── core/
│   ├── di/
│   │   └── app_injection.dart (NEW)     # Central BLoC initialization
│   ├── bloc/
│   │   └── BLOC_PATTERN_GUIDE.md (NEW)  # BLoC pattern documentation
│   ├── network/
│   ├── preferences/
│   ├── services/
│   └── utils/
│
└── features/
    └── counter/ (NEW - Example Feature)
        ├── data/
        │   ├── datasources/
        │   │   └── counter_local_datasource.dart
        │   ├── models/
        │   │   └── counter_model.dart
        │   └── repositories/
        │       └── counter_repository_impl.dart
        ├── domain/
        │   ├── entities/
        │   │   └── counter_entity.dart
        │   ├── repositories/
        │   │   └── counter_repository.dart
        │   └── usecases/
        │       ├── get_counter_usecase.dart
        │       ├── increment_counter_usecase.dart
        │       ├── decrement_counter_usecase.dart
        │       └── reset_counter_usecase.dart
        ├── presentation/
        │   ├── bloc/
        │   │   ├── counter_bloc.dart
        │   │   ├── counter_event.dart
        │   │   └── counter_state.dart
        │   ├── pages/
        │   │   └── counter_page.dart
        │   └── widgets/
        │       └── counter_body.dart
        └── counter_injection.dart
```

### 📦 New Dependencies Added

- `equatable: ^2.0.5` - For state/event equality comparison

### 🚀 Running the App

The app is ready to run! You now have:
- A working Counter example using BLoC
- Proper dependency injection setup
- Clean architecture separation of concerns

```bash
flutter pub get
flutter run
```

## Understanding the Flow

### 1. **User Interaction**
User taps a button → Event is added to BLoC

```dart
ElevatedButton(
  onPressed: () => context.read<CounterBloc>().add(
    const IncrementCounterEvent(),
  ),
  child: const Text('Increment'),
)
```

### 2. **BLoC Processing**
BLoC receives event → Calls use case → Receives result → Emits new state

```dart
on<IncrementCounterEvent>(_onIncrementCounter);

Future<void> _onIncrementCounter(
  IncrementCounterEvent event,
  Emitter<CounterState> emit,
) async {
  emit(const CounterLoading());
  final result = await incrementCounterUseCase();
  result.fold(
    (exception) => emit(CounterError(message: exception.toString())),
    (counter) => emit(CounterLoaded(value: counter.value)),
  );
}
```

### 3. **UI Update**
Widget listens to state → Rebuilds when state changes

```dart
BlocBuilder<CounterBloc, CounterState>(
  builder: (context, state) {
    if (state is CounterLoading) {
      return const CircularProgressIndicator();
    } else if (state is CounterLoaded) {
      return Text('Count: ${state.value}');
    }
    return const SizedBox.shrink();
  },
)
```

## Key Files to Understand

1. **[lib/core/di/app_injection.dart](lib/core/di/app_injection.dart)** - Central place to initialize all BLoCs
2. **[lib/features/counter/counter_injection.dart](lib/features/counter/counter_injection.dart)** - Counter feature setup
3. **[lib/features/counter/presentation/bloc/counter_bloc.dart](lib/features/counter/presentation/bloc/counter_bloc.dart)** - BLoC logic
4. **[lib/app.dart](lib/app.dart)** - App widget with BlocProvider
5. **[lib/main.dart](lib/main.dart)** - Entry point with initialization

## Adding a New Feature

### Quick Steps:

1. **Create folder structure** for your feature under `lib/features/[your_feature]/`
2. **Use [FEATURE_TEMPLATE.dart](FEATURE_TEMPLATE.dart)** as reference
3. **Copy the counter example** and adapt it to your needs
4. **Update [lib/core/di/app_injection.dart](lib/core/di/app_injection.dart)** to initialize your new BLoC
5. **Add your BLoC to AppBlocProviders** class

Example structure for a "User" feature:
```
features/user/
├── data/
│   ├── datasources/user_datasource.dart
│   ├── models/user_model.dart
│   └── repositories/user_repository_impl.dart
├── domain/
│   ├── entities/user_entity.dart
│   ├── repositories/user_repository.dart
│   └── usecases/
│       ├── get_user_usecase.dart
│       └── update_user_usecase.dart
├── presentation/
│   ├── bloc/user_bloc.dart
│   ├── pages/user_page.dart
│   └── widgets/user_widget.dart
└── user_injection.dart
```

## Documentation

- **[BLoC_ARCHITECTURE.md](BLoC_ARCHITECTURE.md)** - Comprehensive architecture guide
- **[lib/core/bloc/BLOC_PATTERN_GUIDE.md](lib/core/bloc/BLOC_PATTERN_GUIDE.md)** - BLoC pattern explanations
- **[lib/FEATURE_TEMPLATE.dart](lib/FEATURE_TEMPLATE.dart)** - Template for creating new features

## Important Concepts

### Events
Represent user actions or system events:
```dart
class IncrementCounterEvent extends CounterEvent {
  const IncrementCounterEvent();
}
```

### States
Represent UI states (Loading, Loaded, Error):
```dart
class CounterLoaded extends CounterState {
  final int value;
  const CounterLoaded({required this.value});
}
```

### Use Cases
Encapsulate single business operations:
```dart
class IncrementCounterUseCase {
  final CounterRepository repository;
  
  IncrementCounterUseCase(this.repository);
  
  Future<Either<Exception, CounterEntity>> call() async {
    return await repository.incrementCounter();
  }
}
```

### Either Pattern
Safe error handling using `Either<Exception, Result>`:
```dart
result.fold(
  (exception) => emit(CounterError(message: exception.toString())), // Error
  (counter) => emit(CounterLoaded(value: counter.value)), // Success
);
```

## Next Steps

1. ✅ **Understand the Counter Example** - Read through the counter feature
2. 📚 **Study the Architecture** - Read BLoC_ARCHITECTURE.md
3. 🎯 **Create Your First Feature** - Use FEATURE_TEMPLATE.dart as guide
4. 🔗 **Integrate with Your Backend** - Add remote data sources
5. 🧪 **Write Tests** - Test your BLoCs, use cases, and repositories

## Useful Tips

- **BlocListener** - Use for one-time events (show toast, navigate, etc.)
- **BlocBuilder** - Use for state-dependent UI changes
- **context.read()** - Access BLoC without listening to state changes
- **context.watch()** - Same as BlocBuilder (use inside build method)
- **emit()** - Send new state from BLoC
- **add()** - Add event to BLoC

## Troubleshooting

**"Cannot find BLoC"?**
- Make sure it's initialized in `AppInjection.init()`
- Add it to `AppBlocProviders` class
- Provide it in the widget tree with `BlocProvider`

**"State not updating"?**
- Make sure you're using `Equatable` correctly
- Check if you're emitting a new state object
- Verify the BLoC event handler is being called

**"Dependency injection error"?**
- Check if all dependencies are properly initialized
- Verify the order of initialization
- Make sure repositories are correctly passed to use cases

## Resources

- [Flutter BLoC Documentation](https://bloclibrary.dev)
- [Clean Architecture](https://resocoder.com/clean-architecture)
- [BLoC Pattern Best Practices](https://resocoder.com/flutter-state-management)

---

**Happy coding! 🚀**
