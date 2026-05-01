# BLoC Implementation - FAQ & Troubleshooting

## Frequently Asked Questions

### Q: Where should I put my BLoC?
**A:** Each feature gets its own BLoC in `features/[feature_name]/presentation/bloc/`. The BLoC coordinates between the presentation layer (widgets) and domain layer (use cases).

### Q: Do I need separate BLoCs for each feature?
**A:** Yes, this is the recommended pattern. Each feature should have its own BLoC to maintain separation of concerns and make testing easier.

### Q: How do I handle errors in BLoC?
**A:** Use the `Either<Exception, T>` pattern from the `either_dart` package:
```dart
result.fold(
  (exception) => emit(YourError(message: exception.toString())),
  (data) => emit(YourLoaded(data: data)),
);
```

### Q: Should I use BlocBuilder or BlocListener?
**A:** 
- **BlocBuilder**: For UI updates based on state changes
- **BlocListener**: For one-time actions (toast, navigation, etc.)
- Use both together when needed

### Q: How do I access the BLoC in a widget?
**A:**
```dart
// Read without listening
context.read<CounterBloc>().add(const IncrementEvent());

// Build widget with listener
BlocBuilder<CounterBloc, CounterState>(
  builder: (context, state) => /* widget */
);

// One-time action
BlocListener<CounterBloc, CounterState>(
  listener: (context, state) { /* action */ },
);
```

### Q: What's the difference between events and states?
**A:**
- **Events**: Actions/requests (user clicks, timer fires, API call)
- **States**: Results/responses (loading, loaded, error)

### Q: Do I need to create models if I already have entities?
**A:** Yes, models extend entities and add serialization logic. This separation keeps domain layer independent of data layer.

### Q: How do I test a BLoC?
**A:** Use the `bloc_test` package:
```dart
blocTest<CounterBloc, CounterState>(
  'emits [CounterLoading, CounterLoaded] when GetCounterEvent is added',
  build: () => CounterBloc(...),
  act: (bloc) => bloc.add(const GetCounterEvent()),
  expect: () => [
    const CounterLoading(),
    const CounterLoaded(value: 0),
  ],
);
```

## Troubleshooting

### Issue: "Cannot find BLoC" error
**Solution:**
1. Ensure BLoC is initialized in `lib/core/di/app_injection.dart`
2. Add it to `AppBlocProviders` class
3. Provide it in widget tree with `BlocProvider`
4. Check import path is correct

### Issue: Widget not rebuilding when state changes
**Solution:**
1. Make sure you're emitting a new state object (not mutating old one)
2. Verify `Equatable` is implemented correctly in state
3. Use `BlocBuilder` instead of `BlocListener`
4. Check that BLoC is provided in parent widget

### Issue: BLoC event not being processed
**Solution:**
1. Verify event extends the correct event class
2. Check `on<EventType>()` is registered in BLoC constructor
3. Ensure event handler is async and uses `await`
4. Check BLoC hasn't been closed

### Issue: "Unresolved import" for feature files
**Solution:**
1. Run `flutter pub get` to resolve dependencies
2. Check file paths use correct case (case-sensitive on Linux/Mac)
3. Verify feature folder structure matches import path
4. Restart IDE if imports still not recognized

### Issue: Circular dependency errors
**Solution:**
1. Keep domain layer independent - no imports from data or presentation
2. Data layer should depend on domain, not vice versa
3. Use abstract repository in domain, implementation in data
4. BLoC imports from presentation and domain, not vice versa

### Issue: State not persisting after app restart
**Solution:**
1. Add persistence logic to local data source
2. Load persisted data in the appropriate use case
3. Save state changes to local storage (SharedPreferences, SQLite, etc.)
4. Example: `await sharedPreferences.setInt('counter', value);`

### Issue: Multiple BLoCs causing memory issues
**Solution:**
1. Ensure BLoCs are closed when no longer needed
2. Use `BlocProvider` with proper scope management
3. Avoid creating multiple instances of the same BLoC
4. Implement `close()` method properly if overriding

### Issue: "Cannot add event to a closed BLoC"
**Solution:**
1. Check if BLoC has been closed elsewhere
2. Verify the BLoC is properly scoped to the widget
3. Don't try to use BLoC after the page is disposed
4. Handle BLoC lifecycle properly with context lifecycle

## Common Patterns

### Pattern 1: Load Data on Page Init
```dart
@override
void initState() {
  super.initState();
  context.read<YourBloc>().add(const GetDataEvent());
}
```

### Pattern 2: Handle Success/Failure with Toast
```dart
BlocListener<YourBloc, YourState>(
  listener: (context, state) {
    if (state is YourSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    } else if (state is YourError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${state.message}')),
      );
    }
  },
  child: YourWidget(),
)
```

### Pattern 3: Navigate on State Change
```dart
BlocListener<YourBloc, YourState>(
  listener: (context, state) {
    if (state is LoginSuccess) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  },
  child: LoginPage(),
)
```

### Pattern 4: Combine Multiple BLoCs
```dart
BlocBuilder<FirstBloc, FirstState>(
  builder: (context, firstState) {
    return BlocBuilder<SecondBloc, SecondState>(
      builder: (context, secondState) {
        return YourWidget(first: firstState, second: secondState);
      },
    );
  },
)
```

### Pattern 5: Conditional Rendering
```dart
BlocBuilder<YourBloc, YourState>(
  builder: (context, state) {
    if (state is YourInitial) {
      return Text('Initial state');
    } else if (state is YourLoading) {
      return CircularProgressIndicator();
    } else if (state is YourLoaded) {
      return Text('Data: ${state.data}');
    } else if (state is YourError) {
      return Text('Error: ${state.message}');
    }
    return SizedBox.shrink();
  },
)
```

## Best Practices Checklist

- ✅ One BLoC per feature
- ✅ Keep BLoC constructor logic minimal
- ✅ Use use cases for all business logic
- ✅ Emit new state objects (immutable)
- ✅ Use Equatable for states and events
- ✅ Handle errors with Either pattern
- ✅ Test each layer independently
- ✅ Keep domain layer independent
- ✅ Map models to entities in data layer
- ✅ Close BLoCs when done
- ✅ Use BlocListener for side effects
- ✅ Use BlocBuilder for UI updates
- ✅ Avoid circular imports
- ✅ Document state transitions
- ✅ Keep event handlers simple

## Useful Terminal Commands

```bash
# Check project for issues
flutter analyze

# Get dependencies
flutter pub get

# Run specific test file
flutter test test/widget_test.dart

# Format code
dart format lib/

# Watch for changes and run tests
flutter test --watch

# Generate code (if using generators)
flutter pub run build_runner build

# Clean build
flutter clean && flutter pub get
```

## Resources

- [Official BLoC Documentation](https://bloclibrary.dev/)
- [BLoC Tutorials](https://www.youtube.com/c/ResoCoder)
- [Flutter State Management Guide](https://flutter.dev/docs/development/data-and-backend/state-mgmt/intro)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Functional Programming in Dart](https://dart.dev/guides/language/effective-dart)

## Quick Decision Matrix

| Need | Use |
|------|-----|
| Store and update UI state | BLoC + Events + States |
| Handle one-time action | BlocListener |
| Update UI based on state | BlocBuilder |
| Share data between features | Service + Provider or GetIt |
| Persist data | SharedPreferences or SQLite |
| Handle errors | Either<Exception, T> |
| Validate input | Use Cases |
| Test logic | Unit test use cases |
| Test BLoC | bloc_test package |
| Test widgets | flutter_test package |

## File Naming Convention

```
✅ Good Names:
- counter_bloc.dart
- counter_event.dart
- counter_state.dart
- increment_counter_usecase.dart
- counter_repository.dart
- counter_local_datasource.dart
- counter_model.dart
- counter_entity.dart
- counter_page.dart
- counter_widget.dart

❌ Avoid:
- CounterBloc.dart (use lowercase with underscores)
- counter_bloc_file.dart (too descriptive)
- cb.dart (too short)
- bloc.dart (not descriptive)
```

---

**Still have questions?** Check the documentation files:
- [BLoC_ARCHITECTURE.md](BLoC_ARCHITECTURE.md)
- [QUICK_START.md](QUICK_START.md)
- [lib/FEATURE_TEMPLATE.dart](lib/FEATURE_TEMPLATE.dart)
