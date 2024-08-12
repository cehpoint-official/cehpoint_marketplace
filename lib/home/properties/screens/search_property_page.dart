// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cehpoint_marketplace/common/colors.dart';
import 'package:cehpoint_marketplace/home/properties/widget/search_box_property.dart';

class SearchPropertyPage extends StatefulWidget {
  final List<String> initialHistory;

  const SearchPropertyPage({Key? key, required this.initialHistory})
      : super(key: key);

  @override
  _SearchPropertyPageState createState() => _SearchPropertyPageState();
}

class _SearchPropertyPageState extends State<SearchPropertyPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.bgColour,
        body: Column(
          children: [
            searchBoxProperty(context, true),
            searchHistoryTray(context, searchHistoryArray),
          ],
        ),
      ),
    );
  }
}
