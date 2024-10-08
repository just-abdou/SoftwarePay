import 'package:flutter/widgets.dart';
import 'package:moosyl/l10n/generated/moosyl_localization.dart';

import 'package:moosyl/src/widgets/icons.dart';

enum PaymentType {
  manual,
  auto;

  String get toStr {
    return switch (this) {
      PaymentType.manual => 'manual',
      PaymentType.auto => 'auto'
    };
  }

  bool get isManual => this == manual;
  bool get isAuto => this == auto;

  static PaymentType fromString(String type) {
    return PaymentType.values.firstWhere(
      (value) => value.toStr == type,
      orElse: () =>
          throw UnimplementedError('This payment method is not supported'),
    );
  }
}

/// Enum representing the different types of payment methods available.
///
/// Each enum value corresponds to a specific payment method
/// and provides access to its associated icon, title, and string representation.
enum PaymentMethodTypes {
  /// Represents the Masrivi payment method.
  masrivi,

  /// Represents the Bankily payment method.
  bankily,

  /// Represents the Sedad payment method.
  sedad,

  /// Represents the Bim Bank payment method.
  bimBank,

  /// Represents the Amanty payment method.
  amanty,

  /// Represents the BCIpay payment method.
  bCIpay;

  /// Gets the icon associated with the payment method type.
  ///
  /// Returns an instance of [AppIcon] based on the payment method.
  AppIcon get icon {
    return switch (this) {
      bankily => AppIcons.bankily,
      masrivi => AppIcons.masrivi,
      sedad => AppIcons.sedad,
      bimBank => AppIcons.bimBank,
      bCIpay => AppIcons.bCIpay,
      amanty => AppIcons.amanty,
    };
  }

  /// Gets the localized title for the payment method type.
  ///
  /// Uses [LocalizationsHelper] to retrieve the appropriate localized string
  /// for each payment method.
  String title(BuildContext context) {
    final localizationsHelper = MoosylLocalization.of(context)!;

    return switch (this) {
      PaymentMethodTypes.masrivi => localizationsHelper.masrivi,
      PaymentMethodTypes.bankily => localizationsHelper.bankily,
      PaymentMethodTypes.sedad => localizationsHelper.sedad,
      PaymentMethodTypes.bimBank => localizationsHelper.bimBank,
      PaymentMethodTypes.amanty => localizationsHelper.amanty,
      PaymentMethodTypes.bCIpay => localizationsHelper.bCIpay,
    };
  }

  /// Gets the string representation of the payment method type.
  String get toStr {
    return switch (this) {
      PaymentMethodTypes.masrivi => 'masrivi',
      PaymentMethodTypes.bankily => 'bankily',
      PaymentMethodTypes.sedad => 'sedad',
      PaymentMethodTypes.bimBank => 'bim_bank',
      PaymentMethodTypes.amanty => 'amanty',
      PaymentMethodTypes.bCIpay => 'bci_pay',
    };
  }

  /// Creates a [PaymentMethodTypes] instance from its string representation.
  ///
  /// Throws an [UnimplementedError] if the provided method is not supported.
  static PaymentMethodTypes fromString(String method) {
    return PaymentMethodTypes.values.firstWhere(
      (value) => value.toStr == method,
      orElse: () =>
          throw UnimplementedError('This payment method is not supported'),
    );
  }
}

/// Abstract class representing a payment method.
///
/// This class holds the common properties and methods for all payment methods.
abstract class PaymentMethod {
  /// The unique identifier for the payment method.
  final String id;

  /// The type of the payment method.
  final PaymentMethodTypes method;
  final PaymentType type;

  /// Creates an instance of [PaymentMethod].
  ///
  /// Requires [id] and [method] to initialize the model.
  PaymentMethod({
    required this.id,
    required this.method,
    required this.type,
  });

  /// Creates an instance of [PaymentMethod] from a map.
  ///
  /// The [map] must contain the keys 'id' and 'method' to initialize the properties.
  PaymentMethod.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        method = PaymentMethodTypes.fromString(map['type']),
        type = PaymentType.fromString(map['configurationType']);

  /// Creates a [PaymentMethod] instance from the provided type.
  ///
  /// The [map] must contain the key 'method' to determine the specific type
  /// of payment method to create.
  ///
  /// Throws an [UnimplementedError] if the payment method type is not supported.
  static PaymentMethod fromPaymentMethod(Map<String, dynamic> map) {
    final type = PaymentMethodTypes.fromString(map['type']);
    switch (type) {
      case PaymentMethodTypes.bankily:
        return BankilyConfigModel.fromMap(map);
      default:
        throw UnimplementedError('This payment method is not supported');
    }
  }

  static PaymentMethod fromPaymentType(Map<String, dynamic> map) {
    final type = PaymentType.fromString(map['configurationType']);
    switch (type) {
      case PaymentType.auto:
        return fromPaymentMethod(map);
      case PaymentType.manual:
        return ManualConfigModel.fromMap(map);
      default:
        throw UnimplementedError('This payment method is not supported');
    }
  }
}

/// Model representing the configuration for the Bankily payment method.
///
/// Extends [PaymentMethod] to include specific properties for Bankily.
class BankilyConfigModel extends PaymentMethod {
  /// The BPay number associated with the Bankily payment method.
  final String bPayNumber;

  /// Creates an instance of [BankilyConfigModel].
  ///
  /// Requires [id], [method], and [bPayNumber] to initialize the model.
  BankilyConfigModel({
    required super.id,
    required super.method,
    required this.bPayNumber,
    required super.type,
  });

  /// Creates an instance of [BankilyConfigModel] from a map.
  ///
  /// The [map] must contain the key 'bpay_number' to initialize the property.
  BankilyConfigModel.fromMap(super.map)
      : bPayNumber = map['config']['code'],
        super.fromMap();
}

/// Model representing the configuration for the Bankily payment method.
///
/// Extends [PaymentMethod] to include specific properties for Bankily.
class ManualConfigModel extends PaymentMethod {
  /// The BPay number associated with the Bankily payment method.
  final String merchantCode;

  /// Creates an instance of [ManualConfigModel].
  ///
  /// Requires [id], [method], and [bPayNumber] to initialize the model.
  ManualConfigModel({
    required super.id,
    required super.method,
    required this.merchantCode,
    required super.type,
  });

  /// Creates an instance of [ManualConfigModel] from a map.
  ///
  /// The [map] must contain the key 'merchant code' to initialize the property.
  ManualConfigModel.fromMap(super.map)
      : merchantCode = map['config']['code'],
        super.fromMap();
}
