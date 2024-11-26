import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:b2buy/layers/cart_details.dart';
import 'package:b2buy/layers/product_single.dart';
import 'package:b2buy/universalkey.dart';
import 'package:iconsax/iconsax.dart';

String apiKey = nrg_api_Key; //nrg
String apiSecret = nrg_api_secret; //nrg

class product_page extends StatefulWidget {
  const product_page({Key key, Map<String, dynamic> product}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<product_page> {
  final String _imageUrl =
      'https://nrgimpex.com/wp-content/uploads/2022/07/nrg-impex-classic-color-white-vest-rns.png';

  String _searchTerm = '';
  String _searchFilter = '';

  Future<List<Map<String, dynamic>>> fetchData() async {
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = IOClient(client);

    // Construct the API URL with search filter
    String apiUrl =
        '$http_key://$core_url/api/resource/Product?fields=["name","image","item_name","item_names","size_type","brand"]&limit_page_length=50000';
    /*  if (_searchTerm.isNotEmpty) {
      apiUrl +=
          '&filters=[["is_inactive","=","0"],["name","like","%$_searchTerm%"]]';
    } else if (_searchFilter.isNotEmpty) {
      apiUrl +=
          '&filters=[["is_inactive","=","0"],["product_type","like","%$_searchTerm%"]]';
    } else {
      apiUrl += '&filters=[["is_inactive","=","0"]]';
    }*/

// Check if both _searchTerm and _searchFilter contain data
    if (_searchTerm != null &&
        _searchTerm.isNotEmpty &&
        _searchFilter != null &&
        _searchFilter.isNotEmpty) {
      // Decide how to prioritize or combine the filters
      // For example, you can prioritize _searchTerm and ignore _searchFilter
      apiUrl +=
          '&filters=[["is_inactive","=","0"],["name","like","%$_searchTerm%"],["product_type","like","%$_searchFilter%"]]&order_by=modified%20desc';
    }
// Check if only _searchTerm contains data
    else if (_searchTerm != null && _searchTerm.isNotEmpty) {
      apiUrl +=
          '&filters=[["is_inactive","=","0"],["published","=","1"],["name","like","%$_searchTerm%"]]&order_by=modified%20desc';
    }
// Check if only _searchFilter contains data
    else if (_searchFilter != null && _searchFilter.isNotEmpty) {
      apiUrl +=
          '&filters=[["is_inactive","=","0"],["published","=","1"],["product_type","like","%$_searchFilter%"]]&order_by=modified%20desc';
    }
// Both _searchTerm and _searchFilter are empty
    else {
      apiUrl +=
          '&filters=[["is_inactive","=","0"],["published","=","1"]]&order_by=modified%20desc';
    }

    print(apiUrl);
    print(apiUrl);
    print(apiUrl);
    print(apiUrl);
    print(apiUrl);
    print(apiUrl);
    final response = await ioClient.get(
      Uri.parse(apiUrl),
      // ,"item_size.size" &filters=[["name","like","%gym%20vest%"]]
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

  @override
  void initState() {
    super.initState();
    _loadCartCount();
  }

  int totalCartQty = 0;
  final totalCartCount = TextEditingController();
  Future<void> _loadCartCount() async {
    List<CartItemQty> cartItems =
        (await CartDatabaseHelper.instance.getQtyCountCartItems())
            .cast<CartItemQty>();
    setState(() {
      totalCartQty = 0;
      for (CartItemQty item in cartItems) {
        totalCartQty += item.qty;
      }
      print("Total Quantity: $totalCartQty");
      totalCartCount.text = totalCartQty.toString();
    });
  }

  void handleProductTap(String index) {
    print(index);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductView(productName: index),
        ));
    // Add other actions you want to perform on tap
  }

  void _showFilterDialog(BuildContext context) {
    String selectedFilter;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Select Filter'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      title: Row(
                        children: [
                          if (selectedFilter == 'Gents')
                            const Icon(Icons.check),
                          const Text('Gents'),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          selectedFilter = 'Gents';
                        });
                      },
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          if (selectedFilter == 'Ladies')
                            const Icon(Icons.check),
                          const Text('Ladies'),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          selectedFilter = 'Ladies';
                        });
                      },
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          if (selectedFilter == 'Kids') const Icon(Icons.check),
                          const Text('Kids'),
                        ],
                      ),
                      onTap: () {
                        selectedFilter = 'Kids';
                        setState(() {
                          selectedFilter = 'Kids';
                        });
                      },
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          if (selectedFilter == 'Born') const Icon(Icons.check),
                          const Text('Born'),
                        ],
                      ),
                      onTap: () {
                        selectedFilter = 'Born';
                        setState(() {
                          selectedFilter = 'Born';
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Clear'),
                  onPressed: () {
                    fetchData();
                    setState(() {
                      selectedFilter = null;
                      _searchFilter = null;
                    });
                    fetchData();
                    print(_searchFilter);
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: const Text('Apply'),
                  onPressed: () {
                    Navigator.pop(context);
                    fetchData();
                    setState(() {
                      _searchFilter = selectedFilter;
                    });
                    fetchData();

                    fetchData();
                    print(_searchFilter);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size(
          double.infinity,
          56.0,
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              // child: Expanded(
              child: AppBar(
                backgroundColor: Colors.transparent,
                title: const Center(
                    child: Text(
                  'Product List',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.black87,
                  ),
                )),
                actions: [
                  /* Stack(children: [
                    IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        size: 22,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartScreen(),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      // top: 0.5, // Adjust the top position as needed
                      left: 15, // Adjust the right position as needed
                      child: Container(
                        height: 15,
                        decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(50),
                            // color: Colors.redAccent
                            ),
                        child: Text(
                          totalCartCount.text,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ]),*/
                  IconButton(
                    icon: Stack(
                      children: [
                        const Icon(
                          Iconsax.shopping_bag,
                          size: 30,
                          color: Colors.black,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 9.0,
                            ),
                            child: Text(
                              totalCartCount.text,
                              style: const TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    },
                  )
                  // Spacer(), // This will push the Text widget to the right edge
                ],
                elevation: 0.0,
              ),
              // ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /*Padding(
            padding: EdgeInsets.only(top: 80.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.search),
                SizedBox(
                  width: 10,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    hintText: 'Search...',
                  ),
                  onChanged: (value) {
                    fetchData();
                    setState(() {
                      _searchTerm = value;
                    });
                  },
                ),
              ],
            ),
          ),*/
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 85.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Background color
                borderRadius: BorderRadius.circular(80),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Shadow color
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(Icons.search),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        fetchData();
                        setState(() {
                          _searchTerm = value;
                        });
                      },
                    ),
                  ),
                  /*  GestureDetector(
                    onTap: () {
                      _showFilterDialog(context);
                      fetchData();
                      setState(() {
                        fetchData();
                        fetchData();
                        fetchData();
                        fetchData();
                        fetchData();
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.filter_list),
                    ),
                  ),*/

                  PopupMenuButton<String>(
                    padding: const EdgeInsets.only(right: 18.0),
                    icon: const Icon(Icons.filter_list),
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Gents',
                        child: Text('Mens'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Ladies',
                        child: Text('Ladies'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Kids',
                        child: Text('Kids'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Born',
                        child: Text('Boys'),
                      ),
                    ],
                    onSelected: (String value) {
                      // Handle selection here
                      print('Selected: $value');

                      fetchData();
                      fetchData();
                      fetchData();
                      fetchData();
                      fetchData();
                      setState(() {
                        _searchFilter = value;
                      });
                    },
                  )
                ],
              ),

              /* Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.search),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        fetchData();
                        setState(() {
                          _searchTerm = value;
                        });
                      },
                    ),
                  ),
                ],
              ),*/
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print('waiting');
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircularProgressIndicator(),
                        ],
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  print('Error');
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data == null) {
                  print('No data');
                  return const Text('No data available');
                } else {
                  // Use the data to populate the GridView
                  List<Map<String, dynamic>> products =
                      List<Map<String, dynamic>>.from(snapshot.data);
                  if (products.isNotEmpty) {
                    return GridView.builder(
                      padding: const EdgeInsets.only(top: 8),
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 5,
                        childAspectRatio: 0.60,
                        crossAxisSpacing: 5,
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        bool highlight = index < 5; // Highlight first 5 items
                        return GestureDetector(
                          onTap: () =>
                              handleProductTap(products[index]["name"]),
                          child: Padding(
                            padding: const EdgeInsets.all(0.2),
                            child: Card(
                              color: Colors.white,
                              child: Material(
                                shadowColor:
                                    highlight ? Colors.yellow.shade400 : null,
                                elevation: 15,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      // border: highlight
                                      //     ? Border.all(
                                      //         color: Colors.red, width: 3)
                                      //     : null, // Add orange border if index < 5
                                      ),
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
                                        Expanded(
                                          flex: 2,
                                          child: Center(
                                            child: SizedBox(
                                              height: 400,
                                              width: 180,
                                              child: Image.network(
                                                '$http_key://$core_url/${products[index]["image"]}',
                                                fit: BoxFit.cover,
                                              ),
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
                    );
                  }
                  if (products.isEmpty) {
                    return const Center(child: Text('No data available'));
                  }
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

/*class _Product_PageState extends State<product_page> {
  Future<List<dynamic>> fetchData() async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(client);
    final response = await ioClient.get(
      Uri.parse(
          'http://$core_url/api/resource/Product?fields=["name"]&limit_page_length=50000'),
      headers: {
        'Authorization': 'token $apiKey:$apiSecret',
      },
    );

    print('token $apiKey:$apiSecret');
    print(response.statusCode);
    // print(DateTime.now());

    if (response.statusCode == 200) {
      return json.decode(response.body)["data"];
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AppBar(
              backgroundColor: Colors.transparent.withOpacity(0.2),
              title: Center(child: Text('Product List')),
              elevation: 0.0,
            ),
          ),
        ),
        preferredSize: Size(
          double.infinity,
          56.0,
        ),
      ),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('waiting');
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            print('Error');
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data == null) {
            print('No data');
            return Text('No data available');
          } else {
            // Use the data to populate the GridView
            List<String> productNames = List<String>.generate(
              snapshot.data.length,
              (index) => snapshot.data[index]["name"],
            );

            return GridView.builder(
              itemCount: productNames.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) => Column(
                children: [
                  Container(
                    height: 100,
                    color: Color(0xFFD89167),
                    margin: EdgeInsets.all(2),
                    child: Center(
                      child: Text(
                        productNames[index][0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    productNames[index].toUpperCase(),
                    style: TextStyle(
                      backgroundColor: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD89167),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}*/

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AppBar(
              backgroundColor: Colors.transparent.withOpacity(0.2),
              title: Center(child: Text('Product List')),
              elevation: 0.0,
            ),
          ),
        ),
        preferredSize: Size(
          double.infinity,
          56.0,
        ),
      ),
      body: GridView.builder(
          itemCount: 64,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index) => Container(
                color: Color(0xFFD89167),
                margin: EdgeInsets.all(2),
              )),
    );
  }
}
*/
