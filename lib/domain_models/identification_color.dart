enum IdentificationColor {
  orange(hexCode: 0xFFFB8500),
  lightBlue(hexCode: 0xFF8ECAE6),
  deepBlue(hexCode: 0xFF023047),
  yellow(hexCode: 0xFFFFB703);

  const IdentificationColor({required this.hexCode});

  final int hexCode;
}