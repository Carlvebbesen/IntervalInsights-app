import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interval_insights_app/common/controllers/pending_activities_controller.dart';
import 'package:interval_insights_app/common/models/enums/training_type_enum.dart';
import 'package:interval_insights_app/common/models/pending_activity.dart';
import 'package:interval_insights_app/common/models/proposed_pace_group.dart';
import 'package:interval_insights_app/common/utils/app_theme.dart';
import 'package:interval_insights_app/common/utils/toast_helper.dart';
import 'package:interval_insights_app/common/widgets/app_button.dart';
import 'package:interval_insights_app/common/widgets/app_drop_down.dart';
import 'package:interval_insights_app/common/widgets/build_stats_badge.dart';
import 'package:interval_insights_app/common/widgets/callout_view.dart';
import 'package:interval_insights_app/common/widgets/pending_review/activity_feeling.dart';

class PendingReviewView extends ConsumerStatefulWidget {
  final PendingActivity activity;

  const PendingReviewView(this.activity, {super.key});

  @override
  ConsumerState<PendingReviewView> createState() => _PendingReviewViewState();
}

class _PendingReviewViewState extends ConsumerState<PendingReviewView> {
  bool _isLoading = false;

  late TrainingType _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType =
        widget.activity.trainingType ??
        widget.activity.draftAnalysisResult?.trainingType ??
        TrainingType.easyRun;
  }

  Future<void> _updateTrainingType(TrainingType trainingType) async {
    setState(() => _isLoading = true);
    try {
      await ref
          .read(pendingActivitiesControllerProvider.notifier)
          .updateTrainingType(widget.activity.id, _selectedType);
    } catch (e) {
      if (mounted) {
        ToastHelper.showError(
          title: "Could not update TrainingType",
          description: "Try again :D ",
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: widget.activity.isOnAnalyzeStep
              ? BuildStep2Analyze(widget.activity, _selectedType)
              : _buildStep1Classify(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    final description = widget.activity.description;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (description != null && description.isNotEmpty) ...[
          Text(
            "Strava desc:",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 12),
        Row(
          spacing: 12,
          children: [
            BuildStatsBadge(
              icon: Icons.straighten,
              text:
                  "${(widget.activity.distance / 1000).toStringAsFixed(2)} km",
            ),
            BuildStatsBadge(
              icon: Icons.timer,
              text: _formatDuration(widget.activity.movingTime),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep1Classify() {
    final aiResult = widget.activity.draftAnalysisResult;
    final confidence = aiResult != null
        ? (aiResult.confidenceScore * 100).toInt()
        : 0;
    return Column(
      key: const ValueKey("Step1"),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Step 1: Validate Type",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 16),
        CalloutView(
          icon: Icons.auto_awesome,
          title: "AI Analysis ($confidence% Confidence)",
          description:
              "Proposed training type: ${widget.activity.draftAnalysisResult?.trainingType.displayName ?? "-"}",
        ),
        const SizedBox(height: 24),
        AppDropdown<TrainingType>(
          value: _selectedType,
          labelText: "Training Type",
          prefixIcon: Icons.run_circle_outlined,
          items: TrainingType.values,
          itemLabelBuilder: (type) => type.displayName,
          bgColor: AppColors.accentStrong,
          textColor: AppColors.primary,

          onChanged: (val) {
            if (val != null) {
              setState(() => _selectedType = val);
            }
          },
        ),
        ActivityFeeling(
          widget.activity.feeling,
          activityId: widget.activity.id,
        ),

        const SizedBox(height: 24),
        AppButton(
          onPressed: _isLoading
              ? null
              : () => _updateTrainingType(_selectedType),
          isLoading: _isLoading,
          label: "Confirm Type & Continue",
        ),
      ],
    );
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final mins = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return "${hours}h ${mins}m";
    }
    return "${mins}m";
  }
}

class BuildStep2Analyze extends ConsumerStatefulWidget {
  final PendingActivity activity;
  final TrainingType selectedType;
  const BuildStep2Analyze(this.activity, this.selectedType, {super.key});

  @override
  ConsumerState<BuildStep2Analyze> createState() => _BuildStep2AnalyzeState();
}

class _BuildStep2AnalyzeState extends ConsumerState<BuildStep2Analyze> {
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
          // PaceSelectorView(structure: myStructure, onSave: (_) {}),
          TextFormField(
            controller: _notesController,
            maxLines: 5,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Notes",
              hintText: "e.g. 4x1km @ 3:45 pace. Felt strong...",
              alignLabelWithHint: true,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Please add a comment";
              }
              return null;
            },
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
