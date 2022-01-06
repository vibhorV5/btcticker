import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

// AE1BEDE1-524D-4C52-B9BE-8C1C409EB9C1 apikey

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  Map<String, String> prices = {};
  String? selectedCurrency = 'INR';
  bool isWaiting = false;

  void coinPrice() async {
    isWaiting = true;
    try {
      CoinData coinData = await CoinData();

      var data = await coinData.getCoinData(selectedCurrency);
      isWaiting = false;

      setState(() {
        prices = data;
      });
    } catch (e) {
      print(e);
    }
    print(prices);
  }

  @override
  void initState() {
    super.initState();
    coinPrice();
  }

  CupertinoPicker iOSPicker() {
    List<Text> scrollItems = [];

    for (String currency in currenciesList) {
      var currencyItem = Text(
        currency,
        style: TextStyle(
          color: Colors.white,
        ),
      );
      scrollItems.add(currencyItem);
    }

    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedindex) {
          setState(() {
            print(selectedindex);
            selectedCurrency = currenciesList[selectedindex];
            coinPrice();
          });
        },
        children: scrollItems);
  }

  DropdownButton<String> androidItems() {
    List<DropdownMenuItem<String>> currencyItems = [];

    for (String currency in currenciesList) {
      var dropdownItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      currencyItems.add(dropdownItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: currencyItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          coinPrice();
        });
      },
    );
  }

  Column makeCard() {
    List<coinCard> addCard = [];

    for (String? cryptoo in cryptoList) {
      addCard.add(coinCard(
          selectedCurrency: selectedCurrency,
          crypto: cryptoo,
          value: isWaiting ? '?' : prices[cryptoo]));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, children: addCard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCard(),
          Expanded(
            child: Container(
                margin: EdgeInsets.only(top: 375),
                height: 150.0,
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 30.0),
                color: Colors.lightBlue,
                child: Platform.isIOS ? iOSPicker() : androidItems()),
          ),
        ],
      ),
    );
  }
}

class coinCard extends StatelessWidget {
  const coinCard({
    required this.selectedCurrency,
    required this.crypto,
    required this.value,
  });

  final String? selectedCurrency;
  final String? crypto;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
