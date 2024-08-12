// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cehpoint_marketplace/common/colors.dart';
import 'package:cehpoint_marketplace/home/products/widgets/search_box_widget.dart';

class SearchProductsPage extends StatefulWidget {
  final List<String> initialHistory;

  const SearchProductsPage({Key? key, required this.initialHistory})
      : super(key: key);

  @override
  _SearchProductsPageState createState() => _SearchProductsPageState();
}

class _SearchProductsPageState extends State<SearchProductsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.bgColour,
        body: Column(
          children: [
            searchBox(context, true),
            searchHistoryTray(context, searchHistoryArray),
          ],
        ),
      ),
    );
  }
}
