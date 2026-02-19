enum Currency {
  mxn(symbol: '\$'),
  inr(symbol: '₹'),
  usd(symbol: '\$');

  const Currency({
    required this.symbol
  });

  final String symbol;
}