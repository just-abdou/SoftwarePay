import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:moosyl/src/payment_methods/models/payment_method_model.dart';
import 'package:moosyl/src/payment_methods/pages/available_method_payments.dart';
import 'package:moosyl/src/payment_methods/pages/manual_payment_page.dart';
import 'package:moosyl/src/payment_methods/pages/pay.dart';
import 'package:moosyl/src/payment_methods/providers/get_payment_methods_provider.dart';
import 'package:moosyl/src/payment_methods/providers/pay_provider.dart';

/// A widget that provides a payment interface for the Software Pay system.
///
/// This widget allows users to select a payment method and proceed with the payment.
/// It handles localization and manages the state of the selected payment method.
class MoosylBody extends HookWidget {
  /// Creates an instance of [MoosylBody].

  /// Requires the [apiKey] and [transactionId] for the payment transaction,
  /// an [organizationLogo] to display, and optional handlers for custom payment methods,
  /// success callbacks, and custom icons.
  const MoosylBody({
    super.key,
    required this.apiKey,
    required this.transactionId,
    required this.organizationLogo,
    this.customHandlers = const {},
    this.onPaymentSuccess,
    this.customIcons,
    this.isTestingMode = false,
  });

  /// The API key for authenticating the payment transaction.
  final String apiKey;

  /// The transaction ID for the specific payment transaction.
  final String transactionId;

  /// A widget representing the logo of the organization.
  final Widget organizationLogo;

  /// Optional custom handlers for specific payment methods.
  final Map<PaymentMethodTypes, FutureOr<void> Function()> customHandlers;

  /// Optional callback that is invoked when the payment is successful.
  final FutureOr<void> Function()? onPaymentSuccess;

  /// Optional custom icons for different payment methods.
  final Map<PaymentMethodTypes, String>? customIcons;

  /// A flag to indicate whether the widget is in testing mode.
  final bool isTestingMode;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => PayProvider(
              apiKey: apiKey,
              transactionId: transactionId,
              onPaymentSuccess: onPaymentSuccess,
              context: context,
            ),
          ),
          ChangeNotifierProvider(
            create: (_) => GetPaymentMethodsProvider(
              context: context,
              customHandlers: customHandlers,
              apiKey: apiKey,
              isTestingMode: isTestingMode,
              customIcons: customIcons,
            ),
          ),
        ],
        child: Builder(
          builder: (context) {
            final provider = context.watch<GetPaymentMethodsProvider>();

            final selectedModeOfPayment = provider.selected;
            // State to hold the selected payment method.

            // If no payment method is selected, show the available methods page.
            if (selectedModeOfPayment == null) {
              return const AvailableMethodPage();
            }

            if (selectedModeOfPayment.type.isManual) {
              if (selectedModeOfPayment is! ManualConfigModel) {
                throw Exception('Invalid payment method selected');
              }

              return ManualPaymentPage(
                organizationLogo: organizationLogo,
                apiKey: apiKey,
                transactionId: transactionId,
                method: selectedModeOfPayment,
              );
            }

            // If a payment method is selected, proceed to the payment page.
            return Pay(
              apiKey: apiKey,
              method: selectedModeOfPayment,
              transactionId: transactionId,
              organizationLogo: organizationLogo,
              onPaymentSuccess: onPaymentSuccess,
            );
          },
        ),
      ),
    );
  }
}
