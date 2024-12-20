// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:moosyl/l10n/generated/moosyl_localization.dart';

import 'package:moosyl/src/widgets/icons.dart';

class AppErrorWidget extends StatelessWidget {
  final String? message;
  final String? description;
  final void Function()? onRetry;
  final double bottomPadding;
  final bool horizontalAxis;
  final bool withScaffold;
  final EdgeInsetsDirectional buttonMargin;

  const AppErrorWidget({
    super.key,
    this.message,
    this.description,
    this.onRetry,
    this.horizontalAxis = false,
    this.bottomPadding = 0,
    this.withScaffold = false,
    this.buttonMargin = const EdgeInsetsDirectional.only(top: 16),
  });

  @override
  Widget build(BuildContext context) {
    final localizationsHelper = MoosylLocalization.of(context)!;

    final Widget child;

    if (horizontalAxis) {
      child = InkWell(
        onTap: onRetry,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcons.error.apply(
              size: 24.0,
            ),
            const SizedBox(height: 16, width: 8),
            Flexible(
              child: Text(
                message ?? localizationsHelper.unknownError,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      );
    } else {
      child = Padding(
        padding: const EdgeInsets.all(20).add(
          EdgeInsets.only(bottom: bottomPadding),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcons.error.apply(size: 56.0),
            const SizedBox(height: 16),
            if (message != null)
              Text(
                message!,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: 18,
                    ),
                textAlign: TextAlign.center,
              ),
            if (description != null) ...[
              const SizedBox(
                height: 4,
                width: 4,
              ),
              Text(
                description!,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              ElevatedButton(
                onPressed: onRetry,
                child: Text(localizationsHelper.retry),
              ),
            ]
          ],
        ),
      );
    }

    return Center(
      child: withScaffold ? Scaffold(body: Center(child: child)) : child,
    );
  }
}
