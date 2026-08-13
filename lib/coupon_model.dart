class CouponModel {
  final String id;

  final String code;

  final String description;

  final String type;

  final double value;

  final double minOrderAmount;

  final double maxDiscount;

  final bool isActive;

  final int usageLimit;

  final int usedCount;

  final String vendorId;

  final DateTime expiryDate;

  final DateTime createdAt;

  CouponModel({
    required this.id,
    required this.code,
    required this.description,
    required this.type,
    required this.value,
    required this.minOrderAmount,
    required this.maxDiscount,
    required this.isActive,
    required this.usageLimit,
    required this.usedCount,
    required this.vendorId,
    required this.expiryDate,
    required this.createdAt,
  });

  factory CouponModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {

    return CouponModel(
      id: id,

      code: map['code'] ?? '',

      description:
          map['description'] ?? '',

      type: map['type'] ?? 'flat',

      value:
          (map['value'] ?? 0)
              .toDouble(),

      minOrderAmount:
          (map['minOrderAmount'] ?? 0)
              .toDouble(),

      maxDiscount:
          (map['maxDiscount'] ?? 0)
              .toDouble(),

      isActive:
          map['isActive'] ?? true,

      usageLimit:
          map['usageLimit'] ?? 0,

      usedCount:
          map['usedCount'] ?? 0,

      vendorId:
          map['vendorId'] ?? '',

      expiryDate:
          map['expiryDate']
              .toDate(),

      createdAt:
          map['createdAt']
              .toDate(),
    );
  }

  Map<String, dynamic> toMap() {

    return {
      'code': code,

      'description':
          description,

      'type': type,

      'value': value,

      'minOrderAmount':
          minOrderAmount,

      'maxDiscount':
          maxDiscount,

      'isActive':
          isActive,

      'usageLimit':
          usageLimit,

      'usedCount':
          usedCount,

      'vendorId':
          vendorId,

      'expiryDate':
          expiryDate,

      'createdAt':
          createdAt,
    };
  }
}