class CartEntry {
  CartEntry({
    required this.menu,
    required this.menuName,
    required List<Map<String, dynamic>> options,
    required this.unitPrice,
    required this.quantity,
    required this.menuImagePath,
  }) : options = List<Map<String, dynamic>>.unmodifiable(
         options.map((opt) => Map<String, dynamic>.from(opt)),
       ),
       _optionsKey = _buildOptionsKey(options);

  final Map<String, dynamic> menu;
  final String menuName;
  final String menuImagePath;
  final List<Map<String, dynamic>> options;
  final num unitPrice;
  int quantity;
  final String _optionsKey;

  num get totalPrice => unitPrice * quantity;

  CartEntry copyWith({
    Map<String, dynamic>? menu,
    String? menuName,
    List<Map<String, dynamic>>? options,
    num? unitPrice,
    int? quantity,
    String? menuImagePath,
  }) {
    final copiedOptions = (options ?? this.options)
        .map((opt) => Map<String, dynamic>.from(opt))
        .toList();
    return CartEntry(
      menu: Map<String, dynamic>.from(menu ?? this.menu),
      menuName: menuName ?? this.menuName,
      options: copiedOptions,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      menuImagePath: menuImagePath ?? this.menuImagePath,
    );
  }

  static String _buildOptionsKey(List<Map<String, dynamic>> options) {
    if (options.isEmpty) {
      return '';
    }
    final names = options.map((opt) => opt['name']?.toString() ?? '').toList()
      ..sort();
    return names.join('|');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartEntry &&
        other.menuName == menuName &&
        other._optionsKey == _optionsKey;
  }

  @override
  int get hashCode => Object.hash(menuName, _optionsKey);
}
