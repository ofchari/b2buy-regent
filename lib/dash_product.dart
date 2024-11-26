import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:b2buy/universalkey.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'admin_page.dart';

class DashProduct extends StatefulWidget {
  const DashProduct({Key key}) : super(key: key);

  @override
  State<DashProduct> createState() => _DashProductState();
}

class _DashProductState extends State<DashProduct> {
  String _searchTerm;
  String _searchFilter;

  Future<List<Map<String, dynamic>>> fetchProductlists() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    // Construct the API URL with search filter
    String apiUrl =
        '$http_key://$core_url/api/resource/Product?fields=["name","image","item_name","item_names","size_type","brand"]&limit_page_length=50000';

    // Check if both _searchTerm and _searchFilter contain data
    if (_searchTerm != null &&
        _searchTerm.isNotEmpty &&
        _searchFilter != null &&
        _searchFilter.isNotEmpty) {
      apiUrl +=
          '&filters=[["is_inactive","=","0"],["name","like","%$_searchTerm%"],["product_type","like","%$_searchFilter%"]]&order_by=modified%20desc';
    } else if (_searchTerm != null && _searchTerm.isNotEmpty) {
      apiUrl +=
          '&filters=[["is_inactive","=","0"],["published","=","1"],["name","like","%$_searchTerm%"]]&order_by=modified%20desc';
    } else if (_searchFilter != null && _searchFilter.isNotEmpty) {
      apiUrl +=
          '&filters=[["is_inactive","=","0"],["published","=","1"],["product_type","like","%$_searchFilter%"]]&order_by=modified%20desc';
    } else {
      apiUrl +=
          '&filters=[["is_inactive","=","0"],["published","=","1"]]&order_by=modified%20desc';
    }

    print(apiUrl);
    final response = await ioClient.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'token $apiKey:$apiSecret',
      },
    );

    print('token $apiKey:$apiSecret');
    print(response.statusCode);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(
          json.decode(response.body)["data"]);
    } else {
      throw Exception('Failed to load data');
    }
  }

  void handleProductTap(String productName) {
    // Handle the product tap action here
    print("Tapped on product: $productName");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchProductlists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            // Use the data to populate the GridView
            List<Map<String, dynamic>> products = snapshot.data;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Enables horizontal scrolling
              child: Row(
                children: List.generate(
                  products.length > 5 ? 5 : products.length,
                  (index) {
                    bool highlight = index < 5; // Highlight first 5 items
                    return GestureDetector(
                      onTap: () => handleProductTap(products[index]["name"]),
                      child: Padding(
                        padding: const EdgeInsets.all(0.2),
                        child: SizedBox(
                          height: 280,
                          child: Card(
                            color: Colors.white,
                            child: Material(
                              shadowColor:
                                  highlight ? Colors.yellow.shade400 : null,
                              elevation: 15,
                              child: Column(
                                children: [
                                  if (products[index]["image"] == null)
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          products[index]["name"][0]
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 80,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (products[index]["image"] != null)
                                    Center(
                                      child: SizedBox(
                                        height: 180,
                                        width: 150,
                                        child: Image.network(
                                          '$http_key://$core_url/${products[index]["image"]}',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 4),
                                  Text(
                                    (products[index]["name"])
                                        .split('-')
                                        .last
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
