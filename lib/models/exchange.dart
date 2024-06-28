class ExchangeData {
  int? id;
  String? fromCurrencyName;
  double? fromCurrency;
  String?  toCurrencyName;
 double? toCurrency;
double? rate;
  // constructor
  ExchangeData.fromJson(Map<String, dynamic> data) {
    id = data["id"];
    fromCurrencyName = data["fromCurrencyName"];
    fromCurrency = data["fromCurrency"];
    toCurrencyName = data["toCurrencyName"];
   toCurrency = data["toCurrency"];
    rate = data["rate"];
  }

  get to_currency => null;
  Map<String, dynamic> toJson() {
    return {"id": id,  
    "fromCurrencyName":fromCurrencyName,
     "fromCurrency":fromCurrency,
    "toCurrencyName":toCurrencyName ,
   "toCurrency":toCurrency ,
   "rate": rate };
  }
}
