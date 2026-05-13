import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../movies/presentation/pages/movie_detail_page.dart';
import '../../../movies/presentation/widgets/empty_state_view.dart';
import '../../../movies/presentation/widgets/movie_card.dart';
import '../bloc/favorites_bloc.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit'),
        centerTitle: false,
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is! FavoritesLoadSuccess || state.favorites.isEmpty) {
            return const EmptyStateView(
              icon: Icons.favorite_outline_rounded,
              title: 'Belum Ada Film Favorit',
              subtitle:
                  'Tambahkan film ke favorit dengan menekan\nikon hati pada halaman detail film',
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.55,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: state.favorites.length,
            itemBuilder: (context, index) {
              final movie = state.favorites[index];
              final tag = 'favorites_poster_${movie.id}';
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
          );
        },
      ),
    );
  }
}
