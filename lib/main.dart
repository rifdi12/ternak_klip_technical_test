import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/home_page.dart';
import 'features/favorites/presentation/bloc/favorites_bloc.dart';
import 'features/movies/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'features/movies/presentation/bloc/search/search_bloc.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<MovieListBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<SearchBloc>(),
        ),
        BlocProvider(
          create: (_) =>
              sl<FavoritesBloc>()..add(const FavoritesLoadRequested()),
        ),
      ],
      child: MaterialApp(
        title: 'FilmBox',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6750A4),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
