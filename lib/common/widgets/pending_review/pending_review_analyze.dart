import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interval_insights_app/common/controllers/pending_activities_controller.dart';
import 'package:interval_insights_app/common/models/enums/training_type_enum.dart';
import 'package:interval_insights_app/common/models/pending_activity.dart';
import 'package:interval_insights_app/common/widgets/app_button.dart';
import 'package:interval_insights_app/common/widgets/build_stats_badge.dart';
import 'package:interval_insights_app/common/widgets/callout_view.dart';
import 'package:interval_insights_app/common/widgets/pace_selector_view/pace_selector_view.dart';

class PendingReviewAnalyze extends ConsumerStatefulWidget {
  final PendingActivity activity;
  final TrainingType selectedType;
  const PendingReviewAnalyze(this.activity, this.selectedType, {super.key});

  @override
  ConsumerState<PendingReviewAnalyze> createState() =>
      _PendingReviewAnalyzeState();
}

class _PendingReviewAnalyzeState extends ConsumerState<PendingReviewAnalyze> {
  late TextEditingController _notesController;
  final _formKeyStep2 = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.activity.notes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleCompletion() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKeyStep2.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });
    await ref
        .read(pendingActivitiesControllerProvider.notifier)
        .markAsCompleted(
          widget.activity.id,
          widget.activity.stravaId,
          _notesController.text,
          widget.activity.draftAnalysisResult?.detectedStructure ?? [],
        );
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final intervalsDesc =
        widget.activity.draftAnalysisResult?.intervalsDescription;
    final aiResult = widget.activity.draftAnalysisResult;
    final confidence = aiResult != null
        ? (aiResult.confidenceScore * 100).toInt()
        : 0;
    return Form(
      key: _formKeyStep2,
      child: Column(
        key: const ValueKey("Step2"),
        spacing: 16,

        children: [
          Row(
            children: [
              const Text(
                "Step 2: Add Details",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Spacer(),
              BuildStatsBadge(
                onTap: () => ref
                    .read(pendingActivitiesControllerProvider.notifier)
                    .changeTrainingType(widget.activity.id),
                icon: Icons.run_circle_outlined,
                text: widget.selectedType.displayName,
                color: Colors.green[900] ?? Colors.green,
                bgColor: Colors.green,
                iconColor: Colors.green,
              ),
            ],
          ),
          if (intervalsDesc != null && intervalsDesc.isNotEmpty)
            CalloutView(
              icon: Icons.auto_awesome,
              title: "Suggested Structure: (AI: $confidence % conf)",
              description: intervalsDesc,
            ),
          if (widget.activity.trainingType?.isIntervalType == true)
            PaceSelectorView(
              structure:
                  widget.activity.draftAnalysisResult?.detectedStructure ?? [],
            ),
          TextFormField(
            controller: _notesController,
            maxLines: 5,
            onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Notes",
              hintText: "e.g. Felt strong or Slept good",
              alignLabelWithHint: true,
            ),
          ),
          if (widget.activity.isCompleted)
            const CalloutView(
              icon: Icons.info_outline,
              title: "Already updated!",
              description: "You can find this activity in the activities list",
            ),
          AppButton(
            onPressed: _isLoading ? null : () => _handleCompletion(),
            isLoading: _isLoading,
            disabled: widget.activity.isCompleted,
            icon: Icons.check_circle,
            label: "Complete Activity",
          ),
        ],
      ),
    );
  }
}
