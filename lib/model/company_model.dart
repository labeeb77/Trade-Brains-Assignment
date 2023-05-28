class Company {
  final String symbol;
  final String name;
  final double latestPrice;

  Company(
      {required this.symbol, required this.name, required this.latestPrice});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      symbol: json['1. symbol'],
      name: json['2. name'],
      latestPrice: double.parse(json['9. matchScore']),
    );
  }
}
