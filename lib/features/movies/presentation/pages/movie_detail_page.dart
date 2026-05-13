import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../../favorites/presentation/bloc/favorites_bloc.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;
  final String heroTag;
  const MovieDetailPage({super.key, required this.movie, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 360,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: heroTag,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      movie.posterUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: colorScheme.surfaceContainerHighest,
                        child: const Center(
                          child: Icon(Icons.movie_outlined,
                              size: 72, color: Colors.white38),
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            colorScheme.surface.withAlpha(230),
                          ],
                          stops: const [0.5, 1.0],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              BlocBuilder<FavoritesBloc, FavoritesState>(
                builder: (context, state) {
                  final isFav = state is FavoritesLoadSuccess &&
                      state.isFavorite(movie.id);
                  return IconButton(
                    tooltip: isFav ? 'Hapus dari Favorit' : 'Tambah ke Favorit',
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey(isFav),
                        color: isFav ? Colors.redAccent : null,
                      ),
                    ),
                    onPressed: () => context
                        .read<FavoritesBloc>()
                        .add(FavoriteToggleRequested(movie.id)),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      _InfoChip(
                        icon: Icons.star_rounded,
                        label: movie.voteAverage.toStringAsFixed(1),
                        color: Colors.amber,
                      ),
                      _InfoChip(
                        icon: Icons.calendar_today_rounded,
                        label: movie.releaseDate,
                      ),
                      if (movie.runtime > 0)
                        _InfoChip(
                          icon: Icons.timer_outlined,
                          label: '${movie.runtime} min',
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: movie.genres
                        .map((g) => Chip(
                              label: Text(g,
                                  style: const TextStyle(fontSize: 12)),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Sinopsis',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.overview,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.6,
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          final isFav =
              state is FavoritesLoadSuccess && state.isFavorite(movie.id);
          return FloatingActionButton.extended(
            onPressed: () => context
                .read<FavoritesBloc>()
                .add(FavoriteToggleRequested(movie.id)),
            backgroundColor:
                isFav ? Colors.redAccent : colorScheme.primaryContainer,
            foregroundColor:
                isFav ? Colors.white : colorScheme.onPrimaryContainer,
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
            label: Text(isFav ? 'Hapus Favorit' : 'Tambah Favorit'),
          );
        },
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _InfoChip({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
        color ?? Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: effectiveColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: effectiveColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
