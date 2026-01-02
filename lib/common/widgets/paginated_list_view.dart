import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginatedListView<T> extends StatefulWidget {
  final AsyncValue<List<T>> asyncData;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final Widget Function(BuildContext context, Object error)? errorBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoadMore;
  final EdgeInsetsGeometry padding;
  final ScrollPhysics? physics;
  final double loadMoreScrollThreshold;

  const PaginatedListView({
    super.key,
    required this.asyncData,
    required this.itemBuilder,
    this.separatorBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.onRefresh,
    this.onLoadMore,
    this.padding = EdgeInsets.zero,
    this.physics,
    this.loadMoreScrollThreshold = 200.0,
  });

  @override
  // ignore: strict_raw_type
  State<PaginatedListView> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  bool _isFetchingNextPage = false;

  void _onScroll(ScrollNotification notification) {
    if (widget.onLoadMore == null) return;
    if (widget.asyncData.isLoading || _isFetchingNextPage) return;

    if (notification.metrics.pixels >=
        notification.metrics.maxScrollExtent - widget.loadMoreScrollThreshold) {
      _triggerLoadMore();
    }
  }

  Future<void> _triggerLoadMore() async {
    setState(() => _isFetchingNextPage = true);
    try {
      await widget.onLoadMore!();
    } finally {
      if (mounted) {
        setState(() => _isFetchingNextPage = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.asyncData.isLoading && !widget.asyncData.hasValue) {
      return const Center(child: CircularProgressIndicator());
    }
    if (widget.asyncData.hasError && !widget.asyncData.hasValue) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(context, widget.asyncData.error!);
      }
      // TODO: error handling
      return const Center(child: Text("unknown_error"));
    }

    final items = widget.asyncData.value ?? [];
    if (items.isEmpty) {
      if (widget.emptyBuilder != null) {
        return widget.emptyBuilder!(context);
      }
      return const Center(child: Text("no_result"));
    }
    final bool showBottomSpinner =
        widget.asyncData.isLoading || _isFetchingNextPage;

    final totalCount = items.length + (showBottomSpinner ? 1 : 0);

    Widget listContent = ListView.separated(
      physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
      padding: widget.padding,
      itemCount: totalCount,
      separatorBuilder: (context, index) {
        if (index >= items.length - 1) return const SizedBox.shrink();
        return widget.separatorBuilder?.call(context, index) ??
            const SizedBox(height: 0);
      },
      itemBuilder: (context, index) {
        if (index == items.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        return widget.itemBuilder(context, items[index], index);
      },
    );
    if (widget.onLoadMore != null) {
      listContent = NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          _onScroll(notification);
          return false;
        },
        child: listContent,
      );
    }
    if (widget.onRefresh != null) {
      listContent = RefreshIndicator(
        onRefresh: widget.onRefresh!,
        child: listContent,
      );
    }

    return listContent;
  }
}
