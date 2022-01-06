import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const urlCoin = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = 'F9201796-702E-4367-84E4-F485EDE44D18';

class CoinData {


  Future getCoinData(selectedCurrency) async {
    Map<String, String> cryptoPrice = {};
    for (String crypto in cryptoList) {
      var url = Uri.parse('$urlCoin/$crypto/$selectedCurrency?apikey=$apiKey');

      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        double price = jsonResponse['rate'];
        cryptoPrice[crypto] = price.toStringAsFixed(0);
      } else {
        print('Status code error');
      }
    }
    return cryptoPrice;
  }
}
