import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/movie_list/movie_list_bloc.dart';
import '../widgets/error_view.dart';
import '../widgets/movie_card.dart';
import 'movie_detail_page.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<MovieListBloc>().add(const MovieListStarted());
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<MovieListBloc>().add(const MovieListLoadMoreRequested());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Film'),
        centerTitle: false,
      ),
      body: BlocBuilder<MovieListBloc, MovieListState>(
        builder: (context, state) {
          return switch (state) {
            MovieListInitial() || MovieListLoading() =>
              const Center(child: CircularProgressIndicator()),
            MovieListError(:final message) => ErrorView(
                message: message,
                onRetry: () =>
                    context.read<MovieListBloc>().add(const MovieListStarted()),
              ),
            MovieListLoaded(:final movies, :final isLoadingMore) =>
              RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<MovieListBloc>()
                      .add(const MovieListRefreshed());
                },
                child: GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.55,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: movies.length + (isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == movies.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final movie = movies[index];
                    final tag = 'list_poster_${movie.id}';
                    return MovieCard(
                      movie: movie,
                      heroTag: tag,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MovieDetailPage(movie: movie, heroTag: tag),
                        ),
                      ),
                    );
                  },
                ),
              ),
          };
        },
      ),
    );
  }
}
