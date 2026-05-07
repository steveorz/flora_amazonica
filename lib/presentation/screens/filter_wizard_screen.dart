import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../providers/plant_providers.dart';
import 'results_screen.dart';

class FilterWizardScreen extends ConsumerStatefulWidget {
  const FilterWizardScreen({super.key});

  @override
  ConsumerState<FilterWizardScreen> createState() => _FilterWizardScreenState();
}

class _FilterWizardScreenState extends ConsumerState<FilterWizardScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Hábito de Crecimiento',
      'subtitle': 'Selecciona la forma principal de la planta',
      'options': [
        {'label': 'Árbol', 'icon': Icons.park},
        {'label': 'Arbusto', 'icon': Icons.nature},
        {'label': 'Hierba', 'icon': Icons.grass},
        {'label': 'Liana', 'icon': Icons.timeline},
      ],
    },
    {
      'title': 'Tipo de Hoja',
      'subtitle': '¿Cómo es la estructura de la hoja?',
      'options': [
        {'label': 'Simple', 'icon': Icons.eco_outlined},
        {'label': 'Compuesta', 'icon': Icons.eco},
      ],
    },
    {
      'title': 'Borde de la Hoja',
      'subtitle': 'Selecciona el tipo de borde',
      'options': [
        {'label': 'Entero', 'icon': Icons.panorama_horizontal},
        {'label': 'Dentado', 'icon': Icons.waves},
      ],
    },
    {
      'title': 'Flores',
      'subtitle': '¿La planta presenta flores visibles?',
      'options': [
        {'label': 'Sí', 'icon': Icons.local_florist},
        {'label': 'No', 'icon': Icons.grass_outlined},
      ],
    },
    {
      'title': 'Color Principal',
      'subtitle': '¿Qué color predomina en sus hojas/flores?',
      'options': [
        {'label': 'Verde', 'icon': Icons.circle, 'color': Colors.green},
        {'label': 'Rojo', 'icon': Icons.circle, 'color': Colors.red},
        {'label': 'Amarillo', 'icon': Icons.circle, 'color': Colors.yellow},
        {'label': 'Blanco', 'icon': Icons.circle, 'color': Colors.grey.shade300},
      ],
    },
  ];

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentStep++);
    } else {
      // Last step: Navigate
      final map = ref.read(wizardProvider);
      // For simplicity, we search by the Morphology (Step 0 answer)
      final morphology = map[0] ?? 'Desconocido';
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ResultsScreen(
            title: 'Resultados: $morphology',
            selectedMorphology: morphology,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final answers = ref.watch(wizardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistente Botánico'),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                  setState(() => _currentStep--);
                },
              )
            : IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  ref.read(wizardProvider.notifier).clear();
                  ref.read(bottomNavIndexProvider.notifier).setIndex(0); // return to home
                },
              ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Indicator
            Row(
              children: List.generate(_steps.length, (index) {
                return Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    decoration: BoxDecoration(
                      color: index <= _currentStep ? AppColors.secondary : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Disable swipe
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  final stepData = _steps[index];
                  final options = stepData['options'] as List<Map<String, dynamic>>;
                  return _buildStepContent(
                    title: stepData['title']!,
                    subtitle: stepData['subtitle']!,
                    stepIndex: index,
                    options: options,
                    answers: answers,
                  );
                },
              ),
            ),
            
            const SizedBox(height: 32),

            // Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: answers.containsKey(_currentStep) ? _nextStep : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: Text(_currentStep == _steps.length - 1 ? 'Buscar Resultados' : 'Siguiente Paso'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent({
    required String title,
    required String subtitle,
    required int stepIndex,
    required List<Map<String, dynamic>> options,
    required Map<int, String> answers,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Paso ${stepIndex + 1}',
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 40),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: options.length,
            itemBuilder: (context, i) {
              final opt = options[i];
              return _buildGridItem(
                label: opt['label'],
                icon: opt['icon'],
                colorHint: opt['color'],
                isSelected: answers[stepIndex] == opt['label'],
                onTap: () {
                  ref.read(wizardProvider.notifier).answerStep(stepIndex, opt['label']);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGridItem({
    required String label,
    required IconData icon,
    Color? colorHint,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.secondary : Colors.grey.shade200,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.secondary.withAlpha(76),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: isSelected ? Colors.white : (colorHint ?? AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
