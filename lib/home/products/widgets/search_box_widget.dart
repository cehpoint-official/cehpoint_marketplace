// ignore_for_file: no_leading_underscores_for_local_identifiers, unrelated_type_equality_checks, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:cehpoint_marketplace/common/colors.dart';
import 'package:cehpoint_marketplace/home/products/screens/search_products_page.dart';
import 'package:cehpoint_marketplace/home/products/screens/search_result_page.dart';
import 'package:cehpoint_marketplace/navigation/page_transitions.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> searchHistoryArray = [];

Widget searchBox(
  BuildContext context,
  bool isSearchable,
) {
  TextEditingController _searchText = TextEditingController();
  _searchText.text = '';
  return Container(
    height: 51,
    decoration: BoxDecoration(
      color: isSearchable ? Colors.white : ColorConstants.blue50,
      border: Border.all(
        color: isSearchable ? Colors.white : ColorConstants.blue200,
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              String searchKeyword = _searchText.text;
              isSearchable
                  ? _searchFunction(context, searchKeyword, searchHistoryArray)
                  : _navigateToSearchPage(context);
            },
            child: Icon(
              CupertinoIcons.search,
              color: isSearchable ? Colors.black : ColorConstants.blue700,
            ),
          ),
        ),
        Expanded(
          child: isSearchable
              ? TextField(
                  controller: _searchText,
                  decoration: const InputDecoration(
                    hintText: 'Search for products',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (String value) {
                    // Trigger search when the "Enter" key is pressed
                    String searchKeyword = _searchText.text;
                    if (searchKeyword.isNotEmpty) {
                      _searchFunction(
                          context, searchKeyword, searchHistoryArray);
                    }
                  },
                )
              : GestureDetector(
                  onTap: () {
                    _navigateToSearchPage(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Search for products",
                      style: TextStyle(
                        fontSize: 19,
                        color: isSearchable
                            ? Colors.black
                            : ColorConstants.blue700,
                      ),
                    ),
                  ),
                ),
        ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: GestureDetector(
        //     onTap: () {
        //       Fluttertoast.showToast(msg: 'camera');
        //     },
        //     child: Icon(
        //       Icons.camera_alt_outlined,
        //       color: isSearchable ? Colors.black : ColorConstants.blue700,
        //     ),
        //   ),
        // ),
        // SizedBox(
        //   width: isSearchable ? 4 : 12,
        // ),
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: GestureDetector(
        //     onTap: () {
        //       Fluttertoast.showToast(msg: 'voice');
        //     },
        //     child: Icon(
        //       isSearchable ? Icons.mic : CupertinoIcons.mic,
        //       color: isSearchable ? Colors.black : ColorConstants.blue700,
        //     ),
        //   ),
        // ),
      ],
    ),
  );
}

Widget searchHistoryTray(BuildContext context, List<String> historyArray) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: historyArray.length.toInt == 0
        ? null
        : Container(
            color: Colors.white,
            height: historyArray.length.toInt() * (25 + 16),
            child: ListView.builder(
              itemCount: historyArray.length > 4 ? 4 : historyArray.length,
              itemBuilder: (BuildContext context, int index) {
                return customListTile(
                    context, historyArray[historyArray.length - 1 - index]);
              },
            ),
          ),
  );
}

Widget customListTile(BuildContext context, String searchKeyword) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => _searchFunction(context, searchKeyword, []),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.history),
              ),
              Text(searchKeyword),
            ],
          ),
        ),
        // const Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 8.0),
        //   child: Icon(Icons.clear_rounded),
        // ),
      ],
    ),
  );
}

Future<void> _searchFunction(
  BuildContext context,
  String searchKeyword,
  List<String> historyArray,
) async {
  historyArray.add(searchKeyword);

  // Save search history to shared preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList('historyPrefs', historyArray);

  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return ResultPage(
          keyword: searchKeyword,
          isSearchResults: true,
        );
      },
      transitionsBuilder: customTransition(const Offset(1, 0)),
    ),
  );
}

Future<void> _navigateToSearchPage(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> historyArray = prefs.getStringList('historyPrefs') ?? [];
  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return SearchProductsPage(
          initialHistory: historyArray,
        );
      },
      transitionsBuilder: customTransition(const Offset(0, 0)),
    ),
  );
}
