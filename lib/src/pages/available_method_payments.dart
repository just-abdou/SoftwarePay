import 'package:flutter/material.dart';
import 'package:moosyl/src/helpers/exception_handling/exception_mapper.dart';

import 'package:provider/provider.dart';
import 'package:moosyl/l10n/generated/moosyl_localization.dart';
import 'package:moosyl/src/providers/get_payment_methods_provider.dart';
import 'package:moosyl/src/widgets/container.dart';
import 'package:moosyl/src/widgets/error_widget.dart';
import 'package:moosyl/src/widgets/icons.dart';

/// A widget that displays the available payment methods for selection.
///
/// This widget allows users to choose a payment method from a grid of options.
/// It retrieves the available methods using the [GetPaymentMethodsProvider]
/// and handles loading and error states.
class SelectPaymentMethodPage extends StatelessWidget {
  /// Creates an instance of [SelectPaymentMethodPage].
  ///
  /// the [fullPage] flag is used to determine whether the widget should be
  /// displayed in full page mode or as a part of a larger widget.
  const SelectPaymentMethodPage({
    super.key,
    required this.fullPage,
  });

  /// A flag to indicate whether the widget is in full page mode.
  final bool fullPage;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GetPaymentMethodsProvider>();

    // Show loading indicator while fetching payment methods.
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Display an error widget if there was an error fetching payment methods.
    if (provider.error != null) {
      return AppErrorWidget(
        message: ExceptionMapper.getErrorMessage(provider.error, context),
        withScaffold: fullPage,
        onRetry: provider.getMethods,
      );
    }

    final methods = provider.supportedTypes;

    final children = GridView.builder(
      padding: const EdgeInsets.all(16),
      shrinkWrap: !fullPage,
      physics: !fullPage ? const NeverScrollableScrollPhysics() : null,
      itemCount: methods.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (context, index) {
        final method = methods.elementAt(index);

        return InkWell(
          onTap: () => provider.onTap(method, context),
          child: AppContainer(
            border: Border.all(width: 1),
            padding: const EdgeInsetsDirectional.all(24),
            child: provider.customIcons?[method] != null
                ? AppIcon(path: provider.customIcons?[method])
                : method.icon,
          ),
        );
      },
    );

    final child = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              MoosylLocalization.of(context)!.paymentMethod,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontSize: 20,
                  ),
            ),
          ),
          if (fullPage) Expanded(child: children) else children,
        ],
      ),
    );

    return fullPage ? Scaffold(body: child) : child;
  }
}
