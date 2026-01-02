import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomModalIconTrigger extends StatelessWidget {
  const CustomModalIconTrigger({
    super.key,
    required this.icon,
    required this.title,
    this.backgroundIconColor,
    this.scrollable = true,
    this.modalContent,
  });

  final Icon icon;
  final String title;
  final bool scrollable;
  final Color? backgroundIconColor;
  final Widget? modalContent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: IconButton(
        onPressed: () => CustomModal.show(
          context,
          scrollable,
          child: modalContent,
          title: title,
        ),
        icon: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: backgroundIconColor,
          ),
          child: icon,
        ),
      ),
    );
  }
}

class CustomModal extends StatelessWidget {
  final Widget child;
  final String title;
  final bool scrollable;
  final bool dismissible;
  final double initalChildSize;
  final double maxChildSize;
  final double minChildSize;
  final bool shouldCloseOnMinExtent;
  final List<double>? snapSizes;
  final bool useRootListView;

  static void show(
    BuildContext context,
    bool scrollable, {
    required String title,
    Widget? child,
    bool? dismissible,
    double? initalChildSize,
    double? maxChildSize,
    double? minChildSize,
    bool? shouldCloseOnMinExtent,
    List<double>? snapSizes,
    bool useRootListView = true,
  }) => showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.white,
    context: context,
    isDismissible: true,
    builder: (context) => CustomModal(
      scrollable: scrollable,
      title: title,
      dismissible: dismissible ?? true,
      initalChildSize: initalChildSize ?? 0.9,
      maxChildSize: maxChildSize ?? 0.9,
      minChildSize: minChildSize ?? 0.25,
      shouldCloseOnMinExtent: shouldCloseOnMinExtent ?? true,
      snapSizes: snapSizes,
      useRootListView: useRootListView,
      child: child ?? const SizedBox(),
    ),
  );

  const CustomModal({
    super.key,
    required this.child,
    required this.scrollable,
    required this.title,
    this.dismissible = true,
    this.initalChildSize = 0.9,
    this.maxChildSize = 0.9,
    this.minChildSize = 0.25,
    this.shouldCloseOnMinExtent = true,
    this.useRootListView = true,
    this.snapSizes,
  });

  @override
  Widget build(BuildContext context) {
    if (scrollable) {
      return _buildDraggableSheet(context);
    } else {
      return _buildStaticSheet(context);
    }
  }

  Widget _buildDraggableSheet(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: initalChildSize,
      maxChildSize: maxChildSize,
      minChildSize: minChildSize,
      snapSizes: snapSizes,
      shouldCloseOnMinExtent: shouldCloseOnMinExtent,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: useRootListView
                    ? ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.only(top: 40.0),
                        children: [child],
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: child,
                      ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SizedBox(height: 40, child: _buildHeader(context)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStaticSheet(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 30,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 40, child: _buildHeader(context)),
          child,
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
