import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search/search_bloc.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/movie_card.dart';
import 'movie_detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencarian Film'),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SearchBar(
              controller: _controller,
              hintText: 'Cari judul film...',
              leading: const Icon(Icons.search),
              trailing: [
                BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (_controller.text.isEmpty) return const SizedBox.shrink();
                    return IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        context.read<SearchBloc>().add(const SearchCleared());
                      },
                    );
                  },
                ),
              ],
              onChanged: (value) =>
                  context.read<SearchBloc>().add(SearchQueryChanged(value)),
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          return switch (state) {
            SearchInitial() => const EmptyStateView(
                icon: Icons.movie_filter_outlined,
                title: 'Cari Film Favorit Anda',
                subtitle: 'Ketik judul film untuk mulai mencari',
              ),
            SearchLoading() => const Center(child: CircularProgressIndicator()),
            SearchEmpty(:final query) => EmptyStateView(
                icon: Icons.search_off_rounded,
                title: 'Film Tidak Ditemukan',
                subtitle: 'Tidak ada hasil untuk "$query"\nCoba kata kunci lain',
              ),
            SearchSuccess(:final results) => ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: results.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final movie = results[index];
                  final tag = 'search_poster_${movie.id}';
                  return MovieListTile(
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
          };
        },
      ),
    );
  }
}
