import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Replace the placeholders with your actual API key and secret
String apiKey = "7cbf607bc7e6184"; //yaanee
String apiSecret = "bbce3ba695e127f"; //yaanee

class doctype extends StatelessWidget {
  const doctype({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frappe API Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Frappe API Demo'),
        ),
        body: Center(
          child: FutureBuilder<List<dynamic>>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Extract the partner_name values from the data
                List<String> partnerNames = (snapshot.data ?? [])
                    .map((item) => item["name"].toString())
                    .toList();

                // Build a ListView widget to display the partner_names
                return ListView.builder(
                  itemCount: partnerNames.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(partnerNames[index]),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

// Make a GET request to the API endpoint
Future<List<dynamic>> fetchData() async {
  final response = await http.get(
    Uri.parse(
        'https://erp.yaaneefashions.com/api/resource/Production Delivery'),
    headers: {
      "Authorization": "token $apiKey:$apiSecret",
      "Content-Type": "application/json"
    },
  );

  // Check if the request was successful
  if (response.statusCode == 200) {
    // Convert the response data from JSON to a List
    print(response.body);
    List<dynamic> data = jsonDecode(response.body)["data"];
    return data;
  } else {
    // If the request was not successful, throw an error
    throw Exception("Failed to load data from API");
  }
}
