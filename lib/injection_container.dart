import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivial_number/core/platform/network_info.dart';
import 'package:trivial_number/core/util/input_converter.dart';
import 'package:trivial_number/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:trivial_number/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:trivial_number/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:trivial_number/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:trivial_number/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:trivial_number/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:trivial_number/features/number_trivia/presentation/bloc/bloc/number_trivia_bloc.dart';

// import 'injection_container.config.dart';

final sl = GetIt.instance;

// @InjectableInit(
//   initializerName: r'$initGetIt', // default
//   preferRelativeImports: true, // default
//   asExtension: false, // default
// )
// void configureDependencies() => $initGetIt(sl);

// @module
// abstract class RegisterModule {
//   @preResolve
//   Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
// }

Future<void> init() async {
//Bloc
  sl.registerFactory(() =>
      NumberTriviaBloc(concrete: sl(), random: sl(), inputConverter: sl()));
// Use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTriviaFun(sl()));
//! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

// Repository
  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

// Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));

//! External

  sl.registerSingletonAsync<SharedPreferences>(
      () async => SharedPreferences.getInstance());
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
