import 'package:currency_converter/api_client.dart';
import 'package:currency_converter/drop_down.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Instance of API Client
  ApiClient client = ApiClient();

  // Function to call API

  @override
  void initState() {
    super.initState();
    (() async {
      List<String> list = await client.getCurrencies();
      setState(() {
        currencies = list;
      });
    })();
  }

  // Setting main colors
  Color kMainColor = Color(0x245E5E5E);
  Color kSecondaryColor = Color(0xFF0D39A0);

  //Setting the variables
  List<String> currencies = ["INR", "USD"];
  String from = "INR";
  String to = "USD";

  //variables for exchange rate
  double rate = 1;
  String result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Currency Converter"),
        backgroundColor: kSecondaryColor,
      ),
      backgroundColor: kMainColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 18.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      onChanged: (value) async {
                        rate = await client.getRate(from, to);
                        setState(() {
                          result =
                              (rate * double.parse(value)).toStringAsFixed(3);
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Input amount to convert",
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18.0,
                          color: kMainColor,
                        ),
                      ),
                      style: TextStyle(
                        color: kMainColor,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customDropDown(currencies, from, (val) {
                          setState(() {
                            from = val;
                          });
                        }),
                        FloatingActionButton(
                          onPressed: () {
                            setState(() {
                              String temp = from;
                              from = to;
                              to = temp;
                            });
                          },
                          child: Icon(Icons.swap_horiz),
                          elevation: 0.0,
                          backgroundColor: kSecondaryColor,
                        ),
                        customDropDown(currencies, to, (val) {
                          setState(() {
                            to = val;
                          });
                        }),
                      ],
                    ),
                    SizedBox(height: 50.0),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        children: [
                          Text(
                            result,
                            style: TextStyle(
                              color: kMainColor,
                              fontSize: 36.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
