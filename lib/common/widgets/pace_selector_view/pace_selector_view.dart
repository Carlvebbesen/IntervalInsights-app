import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interval_insights_app/common/controllers/proposed_pace_controller.dart';
import 'package:interval_insights_app/common/models/pending_activity.dart';
import 'package:interval_insights_app/common/utils/app_theme.dart';
import 'package:interval_insights_app/common/widgets/app_button.dart';
import 'package:interval_insights_app/common/widgets/pace_selector_view/interval_set_view.dart';

class PaceSelectorView extends ConsumerStatefulWidget {
  final List<DetectedSet> structure;

  const PaceSelectorView({super.key, required this.structure});

  @override
  ConsumerState<PaceSelectorView> createState() => _PaceSelectorViewState();
}

class _PaceSelectorViewState extends ConsumerState<PaceSelectorView> {
  bool _isSpeedMode = false;
  bool _hide = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final intervalsAsync = ref.watch(
      proposedPaceControllerProvider(widget.structure),
    );
    return intervalsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text("Error: $err")),
      data: (data) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PaceToggleButton(
                    isSpeedMode: _isSpeedMode,
                    onToggle: (val) => setState(() => _isSpeedMode = val),
                  ),
                  AppButton(
                    type: AppButtonType.text,
                    textColor: AppColors.accentStrong,
                    label: _hide ? "Show view" : "Hide view",
                    onPressed: () => setState(() {
                      _hide = !_hide;
                    }),
                  ),
                ],
              ),
              _hide
                  ? const SizedBox.shrink()
                  : IntervalSetView(
                      speedMode: _isSpeedMode,
                      structure: widget.structure,
                      sets: data,
                    ),
            ],
          ),
        );
      },
    );
  }
}

class PaceToggleButton extends StatelessWidget {
  final bool isSpeedMode;
  final ValueChanged<bool> onToggle;

  const PaceToggleButton({
    super.key,
    required this.isSpeedMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: [!isSpeedMode, isSpeedMode],
      onPressed: (i) => onToggle(i == 1),
      borderRadius: BorderRadius.circular(8),
      constraints: const BoxConstraints(minHeight: 32, minWidth: 80),
      children: const [Text("Pace"), Text("Speed")],
    );
  }
}
