import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:interval_insights_app/common/controllers/pending_activities_controller.dart';
import 'package:interval_insights_app/common/models/pending_activity.dart';
import 'package:interval_insights_app/common/utils/app_theme.dart';
import 'package:interval_insights_app/common/widgets/pending_review/pending_review_view.dart';

class PendingReviewTabBar extends ConsumerWidget {
  const PendingReviewTabBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingActivitiesControllerProvider);
    return pendingAsync.when(
      data: (data) {
        if (data.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(child: Text("All caught up! Great job.")),
          );
        }
        return _ReviewSession(items: data);
      },
      error: (error, _) => const Center(child: Text("Something went wrong")),
      loading: () => const CircularProgressIndicator(),
    );
  }
}

class _ReviewSession extends StatefulWidget {
  final List<PendingActivity> items;
  const _ReviewSession({required this.items});
  @override
  State<_ReviewSession> createState() => _ReviewSessionState();
}

class _ReviewSessionState extends State<_ReviewSession>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.items.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant _ReviewSession oldWidget) {
    if (widget.items[_currentIndex].isCompleted &&
        _currentIndex < widget.items.length - 1) {
      _tabController.animateTo(_currentIndex + 1);
    }
    if (widget.items.every((activity) => activity.isCompleted)) {
      context.pop();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _nextTab() {
    if (_currentIndex < widget.items.length - 1) {
      _tabController.animateTo(_currentIndex + 1);
    }
  }

  void _prevTab() {
    if (_currentIndex > 0) {
      _tabController.animateTo(_currentIndex - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _currentIndex > 0 ? _prevTab : null,
                icon: const Icon(Icons.arrow_back_ios),
                color: AppColors.accentStrong,
                disabledColor: Colors.grey.shade300,
              ),
              Expanded(
                child: Text(
                  widget.items[_currentIndex].title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis,
                    color: AppColors.accentStrong,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: _currentIndex < widget.items.length - 1
                    ? _nextTab
                    : null,
                icon: const Icon(Icons.arrow_forward_ios),
                color: AppColors.accentStrong,
                disabledColor: Colors.grey.shade300,
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.items.map((item) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: PendingReviewView(item),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
