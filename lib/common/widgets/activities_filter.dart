import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:interval_insights_app/common/controllers/activity_filter.dart';
import 'package:interval_insights_app/common/models/enums/training_type_enum.dart';
import 'package:interval_insights_app/common/widgets/custom_modal.dart';

class ActivitiesFilterButton extends StatelessWidget {
  const ActivitiesFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomModalIconTrigger(
      icon: Icon(Icons.tune_rounded),
      title: "Filter Activities",
      scrollable: true,
      modalContent: _FilterModalContent(),
    );
  }
}

class _FilterModalContent extends ConsumerStatefulWidget {
  const _FilterModalContent();

  @override
  ConsumerState<_FilterModalContent> createState() =>
      __FilterModalContentState();
}

class __FilterModalContentState extends ConsumerState<_FilterModalContent> {
  // Local state for the modal form
  late TextEditingController _searchController;
  TrainingType? _selectedType;
  double _distance = 0;

  @override
  void initState() {
    super.initState();
    final currentFilters = ref.read(activityFilterProvider);
    _searchController = TextEditingController(text: currentFilters.search);
    _selectedType = currentFilters.trainingType;
    _distance = currentFilters.minDistanceMeters ?? 0;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onApply() {
    // Commit local changes to the global provider
    ref
        .read(activityFilterProvider.notifier)
        .applyAll(
          search: _searchController.text.isEmpty
              ? null
              : _searchController.text,
          trainingType: _selectedType,
          minDistance: _distance > 0 ? _distance : null,
        );
    context.pop(); // Close modal
  }

  void _onReset() {
    setState(() {
      _searchController.clear();
      _selectedType = null;
      _distance = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Search Section
        const Text("Search", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Title or description...",
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
        const SizedBox(height: 24),

        // 2. Distance Slider Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Min Distance",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              _distance == 0
                  ? "Any"
                  : "${(_distance / 1000).toStringAsFixed(1)} km",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Slider(
          value: _distance,
          min: 0,
          max: 42200, // Marathon + padding
          divisions: 42, // 1km steps roughly
          label: "${(_distance / 1000).toStringAsFixed(1)} km",
          onChanged: (val) => setState(() => _distance = val),
        ),
        const SizedBox(height: 16),

        // 3. Training Type Section
        const Text(
          "Training Type",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TrainingType.values.map((type) {
            final isSelected = _selectedType == type;
            return ChoiceChip(
              label: Text(
                type.name.replaceAll('_', ' ').toLowerCase().capitalize(),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedType = selected ? type : null;
                });
              },
              // Optional: Style your chip to match your theme
              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 32),

        // 4. Action Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _onReset,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Reset"),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FilledButton(
                onPressed: _onApply,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Show Results"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
