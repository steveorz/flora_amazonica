import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../domain/entities/plant.dart';
import '../providers/plant_providers.dart';
import 'results_screen.dart';
import 'species_detail_screen.dart';

const _categories = ['Todos', 'Árboles', 'Hierbas', 'Lianas', 'Arbustos'];

const _categoryToType = <String, String>{
  'Árboles': 'Árbol',
  'Hierbas': 'Hierba',
  'Lianas': 'Liana',
  'Arbustos': 'Arbusto',
};

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectedCategory = 'Todos';

  @override
  Widget build(BuildContext context) {
    final asyncPlants = ref.watch(featuredPlantsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TopBar(onSubmit: (q) => _runSearch(context, q)),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Descubre la Flora\nAmazónica',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 44,
                    fontWeight: FontWeight.w700,
                    height: 1.05,
                    letterSpacing: -0.5,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _MorphologyCta(
                  onTap: () => ref
                      .read(bottomNavIndexProvider.notifier)
                      .setIndex(1),
                ),
              ),
              const SizedBox(height: 28),
              _CategoryChips(
                selected: _selectedCategory,
                onSelect: (c) => setState(() => _selectedCategory = c),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 360,
                child: asyncPlants.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                  error: (e, _) => Center(child: Text('Error: $e')),
                  data: (plants) => _SpecimenCardList(
                    plants: _filter(plants),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Plant> _filter(List<Plant> plants) {
    final type = _categoryToType[_selectedCategory];
    if (type == null) return plants;
    return plants.where((p) => p.morphologyType == type).toList();
  }

  void _runSearch(BuildContext context, String query) {
    if (query.trim().isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ResultsScreen(
          title: 'Búsqueda: $query',
          query: query,
        ),
      ),
    );
  }
}

class _TopBar extends StatefulWidget {
  const _TopBar({required this.onSubmit});

  final ValueChanged<String> onSubmit;

  @override
  State<_TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<_TopBar> {
  bool _searching = false;
  final _ctrl = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _expand() {
    setState(() => _searching = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focus.requestFocus();
    });
  }

  void _collapse() {
    setState(() => _searching = false);
    _ctrl.clear();
    _focus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: SizedBox(
        height: 44,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: _searching ? _expandedRow() : _collapsedRow(),
        ),
      ),
    );
  }

  Widget _collapsedRow() {
    return Row(
      key: const ValueKey('collapsed'),
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=200',
              ),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
        const Spacer(),
        const _PillIconButton(icon: Icons.notifications_none_rounded),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _expand,
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: _pillDecoration,
            child: Row(
              children: [
                const Icon(Icons.search_rounded, size: 20, color: AppColors.textPrimary),
                const SizedBox(width: 8),
                Text(
                  'Buscar',
                  style: GoogleFonts.publicSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _expandedRow() {
    return Container(
      key: const ValueKey('expanded'),
      height: 44,
      padding: const EdgeInsets.only(left: 18, right: 6),
      decoration: _pillDecoration,
      child: Row(
        children: [
          const Icon(Icons.search_rounded, size: 20, color: AppColors.textPrimary),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _ctrl,
              focusNode: _focus,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onSubmitted: (q) {
                widget.onSubmit(q);
                _collapse();
              },
              style: GoogleFonts.publicSans(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'Nombre científico o común…',
                hintStyle: GoogleFonts.publicSans(
                  fontSize: 14,
                  color: AppColors.textPrimary.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: _collapse,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.textPrimary.withValues(alpha: 0.06),
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 18,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PillIconButton extends StatelessWidget {
  const _PillIconButton({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: _pillDecoration,
      child: Icon(icon, size: 22, color: AppColors.textPrimary),
    );
  }
}

final BoxDecoration _pillDecoration = BoxDecoration(
  color: Colors.white.withValues(alpha: 0.7),
  borderRadius: BorderRadius.circular(40),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 10,
      offset: const Offset(0, 3),
    ),
  ],
);

class _MorphologyCta extends StatelessWidget {
  const _MorphologyCta({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, 22, 22, 22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE07A3D), Color(0xFFD35400)],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Identificación\nMorfológica',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Identifique especímenes mediante hábito, exudado y hojas.',
                    style: GoogleFonts.publicSans(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.biotech_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({required this.selected, required this.onSelect});

  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final cat = _categories[i];
          final isActive = cat == selected;
          return GestureDetector(
            onTap: () => onSelect(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(40),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  cat,
                  style: GoogleFonts.publicSans(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SpecimenCardList extends StatelessWidget {
  const _SpecimenCardList({required this.plants});

  final List<Plant> plants;

  @override
  Widget build(BuildContext context) {
    if (plants.isEmpty) {
      return Center(
        child: Text(
          'Sin resultados en esta categoría',
          style: GoogleFonts.publicSans(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: plants.length,
      separatorBuilder: (_, _) => const SizedBox(width: 16),
      itemBuilder: (_, i) => _SpecimenCard(plant: plants[i]),
    );
  }
}

class _SpecimenCard extends StatelessWidget {
  const _SpecimenCard({required this.plant});

  final Plant plant;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => SpeciesDetailScreen(plant: plant)),
        );
      },
      child: SizedBox(
        width: 240,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.network(
                plant.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(color: AppColors.tertiary),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.75),
                      Colors.transparent,
                    ],
                    stops: const [0, 0.6],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: AppColors.textPrimary,
                  size: 22,
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 22,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    plant.scientificName,
                    style: GoogleFonts.publicSans(
                      color: const Color(0xFFFFDBCD),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 1.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    plant.commonName,
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
