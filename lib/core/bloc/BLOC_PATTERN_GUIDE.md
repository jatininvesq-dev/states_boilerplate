// BLoC Pattern Documentation
// ===========================
//
// This project uses the BLoC (Business Logic Component) pattern for state management.
// The structure follows Clean Architecture principles with clear separation of concerns.
//
// Folder Structure:
// ├── features/
// │   └── [feature_name]/
// │       ├── data/
// │       │   ├── datasources/      # Data sources (API, local storage)
// │       │   ├── models/           # Models that extend entities
// │       │   └── repositories/     # Repository implementations
// │       ├── domain/
// │       │   ├── entities/         # Core entities/models
// │       │   ├── repositories/     # Abstract repository interfaces
// │       │   └── usecases/         # Business logic use cases
// │       └── presentation/
// │           ├── bloc/             # BLoC, Events, and States
// │           ├── pages/            # Full page widgets
// │           └── widgets/          # Reusable widgets
// ├── core/
// │   ├── di/                       # Dependency injection setup
// │   ├── bloc/                     # App-level BLoCs
// │   ├── network/                  # Network configuration
// │   ├── preferences/              # Preferences management
// │   ├── services/                 # Core services
// │   └── utils/                    # Utility functions
//
// Key Principles:
//
// 1. Events: Represent user actions or system events
//    - Extend CounterEvent abstract class
//    - Use const constructors with equatable
//
// 2. States: Represent UI states (Loading, Loaded, Error)
//    - Extend CounterState abstract class
//    - Include data needed for UI rendering
//
// 3. BLoC: Orchestrates events and emits states
//    - Listen to events using on<EventType>()
//    - Emit states using emit()
//    - Handle business logic via use cases
//
// 4. Use Cases: Encapsulate business logic
//    - One use case per business operation
//    - Return Either<Exception, Result> for error handling
//
// 5. Repositories: Abstract data operations
//    - Implement repository interfaces
//    - Handle data source switching
//    - Map models to entities
//
// 6. Data Sources: Handle data retrieval
//    - Local data sources (SharedPreferences, local DB)
//    - Remote data sources (API calls)
//
// Example Usage in Widget:
// ========================
//
// @override
// void initState() {
//   super.initState();
//   context.read<CounterBloc>().add(const GetCounterEvent());
// }
//
// @override
// Widget build(BuildContext context) {
//   return BlocBuilder<CounterBloc, CounterState>(
//     builder: (context, state) {
//       if (state is CounterLoading) {
//         return const CircularProgressIndicator();
//       } else if (state is CounterLoaded) {
//         return Text('Count: ${state.value}');
//       } else if (state is CounterError) {
//         return Text('Error: ${state.message}');
//       }
//       return const SizedBox.shrink();
//     },
//   );
// }
//
// // Trigger events
// ElevatedButton(
//   onPressed: () => context.read<CounterBloc>().add(
//         const IncrementCounterEvent(),
//       ),
//   child: const Text('Increment'),
// )
