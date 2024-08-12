// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cehpoint_marketplace/common/colors.dart';
import 'package:get/get.dart';
import 'package:cehpoint_marketplace/common/utils.dart';
import 'package:cehpoint_marketplace/home/properties/property_controller.dart';
import 'package:cehpoint_marketplace/home/properties/widget/properties_screen_widget.dart';
import 'package:cehpoint_marketplace/models/property.dart';
import 'package:cehpoint_marketplace/routes/app_routes.dart';

enum SortOptions {
  relevance,
  popularity,
  priceHighToLow,
  priceLowToHigh,
}

class ResultPageProperty extends StatefulWidget {
  final String keyword;
  final bool isSearchResults;

  const ResultPageProperty({
    super.key,
    required this.keyword,
    required this.isSearchResults,
  });

  @override
  _ResultPagePropertyState createState() => _ResultPagePropertyState();
}

class _ResultPagePropertyState extends State<ResultPageProperty> {
  final controller = Get.find<PropertyController>();
  SortOptions currentSortOption = SortOptions.relevance;
  bool isFiltered = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.bgColour,
        appBar: AppBar(
          title: Text(widget.keyword),
          actions: [
            // IconButton(
            //     onPressed: () {}, icon: const Icon(Icons.camera_alt_outlined)),
            // IconButton(onPressed: () {}, icon: const Icon(Icons.mic)),
            IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.cart)),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                topBar(context),
                FutureBuilder(
                  future: controller.fetchHomeImageFromFirebase(),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // While data is loading
                      return Utils.customLoadingSpinner();
                    } else if (snapshot.hasError) {
                      // If an error occurs
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final data = snapshot.data?.data();
                      return PropertiesScreenWidget.propertiesHomeImage(
                        images: [Image.network(data?['url'])],
                      );
                    }
                  },
                ),
                // widget.isSearchResults
                //     ? _searchBody(widget.keyword)
                //     : _categorisedBody(widget.keyword),
                _searchBody(widget.keyword),
              ],
            ),
          ),
        ),
      ),
    );
  }

  late double filteredMaxPrice;
  late double filteredMinPrice;

  Set<String> setFilteredCategory = {};
  Set<String> setFilteredPropertyType = {};

  Widget filtersBottomSheet() {
    const List<double> priceList = <double>[1000.0, 100000.0, 10000000.0];
    const List<double> coveredAreaList = <double>[
      100.0,
      500.0,
      1000.0,
      1500.0,
      2000.0,
      2500.0,
      3000.0
    ];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0, right: 25, left: 25),
          child: Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Filter',
              style: TextStyle(fontSize: 23),
            ),
          ),
        ),
        const Divider(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ListView(
              // body
              children: <Widget>[
                const Text(
                  'Selling Price',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropdownMenu<double>(
                      hintText: 'Max Price',
                      textStyle: const TextStyle(fontSize: 15),
                      onSelected: (double? value) {
                        filteredMaxPrice = value!;
                      },
                      dropdownMenuEntries: priceList
                          .map<DropdownMenuEntry<double>>((double value) {
                        return DropdownMenuEntry<double>(
                            value: value, label: value.toString());
                      }).toList(),
                    ),
                    DropdownMenu<double>(
                      hintText: 'Min Price',
                      onSelected: (double? value) {
                        filteredMaxPrice = value!;
                      },
                      dropdownMenuEntries: priceList
                          .map<DropdownMenuEntry<double>>((double value) {
                        return DropdownMenuEntry<double>(
                            value: value, label: value.toString());
                      }).toList(),
                    ),
                  ],
                ),
                const Text(
                  'Covered Area (sqft)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropdownMenu<double>(
                      hintText: 'Max Area ',
                      textStyle: const TextStyle(fontSize: 15),
                      onSelected: (double? value) {
                        filteredMaxPrice = value!;
                      },
                      dropdownMenuEntries: coveredAreaList
                          .map<DropdownMenuEntry<double>>((double value) {
                        return DropdownMenuEntry<double>(
                            value: value, label: value.toString());
                      }).toList(),
                    ),
                    DropdownMenu<double>(
                      hintText: 'Min Area',
                      onSelected: (double? value) {
                        filteredMaxPrice = value!;
                      },
                      dropdownMenuEntries: coveredAreaList
                          .map<DropdownMenuEntry<double>>((double value) {
                        return DropdownMenuEntry<double>(
                            value: value, label: value.toString());
                      }).toList(),
                    ),
                  ],
                ),
                SelectableRow(
                  title: 'Category',
                  items: const [
                    'Buy',
                    'Rent',
                    'PG',
                    'Commercial',
                    'Project',
                  ],
                  selectedItems: setFilteredCategory,
                ),
                SelectableRow(
                  title: 'Property Type',
                  items: const [
                    'Flat',
                    'House',
                    'Plot',
                    'Office Space',
                    'Other',
                  ],
                  selectedItems: setFilteredPropertyType,
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isFiltered = true;
            });

            Navigator.pop(context);
          },
          child: Container(
            alignment: Alignment.center,
            height: 60,
            width: double.infinity,
            color: const Color(0xFFFA7023),
            child: const Text(
              'Apply',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w600),
            ),
          ),
        )
      ],
    );
  }

  // Future<List<PropertyModel>> fetchFilteredProducts(String keyword) async {
  //   switch (isFiltered) {
  //     case true:
  //       return controller.futureSearchFilterProperties(
  //         keyword,
  //         setFilteredCategory,
  //         setFilteredPropertyType,
  //       );
  //     case false:
  //       return controller.futureSearchResultProperties(keyword);
  //   }
  // }

  Widget sortOptionsBottomSheet() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25),
      child: SizedBox(
        height: 270,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sort by',
              style: TextStyle(fontSize: 20),
            ),
            const Divider(),
            Column(
              children: <Widget>[
                buildSortOption(context, SortOptions.relevance, 'Relevance'),
                buildSortOption(context, SortOptions.popularity, 'Popularity'),
                buildSortOption(
                    context, SortOptions.priceHighToLow, 'Price High to Low'),
                buildSortOption(
                    context, SortOptions.priceLowToHigh, 'Price Low to High'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Future<List<PropertyModel>> fetchSortedProducts(
  //     String keyword, isCategory) async {
  //   switch (currentSortOption) {
  //     case SortOptions.relevance:
  //       switch (isCategory) {
  //         case true:
  //           return controller
  //               .futureCheckSelectedCategoryProperties(widget.keyword);
  //         case false:
  //           return controller.futureSearchResultProperties(widget.keyword);
  //       }
  //     case SortOptions.popularity:
  //       break;
  //     case SortOptions.priceHighToLow:
  //       return controller.sortByPrice(widget.keyword, true);
  //     case SortOptions.priceLowToHigh:
  //       return controller.sortByPrice(widget.keyword, false);
  //   }
  //   return [];
  // }

  Widget buildSortOption(
      BuildContext context, SortOptions option, String label) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text(label),
      trailing: Radio<SortOptions>(
        value: option,
        groupValue: currentSortOption,
        onChanged: (SortOptions? value) {
          if (value != null) {
            Navigator.pop(context);
            setState(() {
              currentSortOption = value;
            });
          }
        },
      ),
    );
  }

  Widget topBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return sortOptionsBottomSheet();
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Container(
                height: 54,
                alignment: Alignment.center,
                color: Colors.white,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sort by'),
                    Icon(Icons.keyboard_arrow_down_sharp, size: 20.0),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Container(
                        constraints: const BoxConstraints(
                          maxHeight: 500,
                        ),
                        child: filtersBottomSheet(),
                      );
                    },
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: Container(
                height: 54,
                alignment: Alignment.center,
                color: Colors.white,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Filters'),
                    Icon(Icons.keyboard_arrow_down_sharp, size: 20.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _searchBody(String searchKeyword) {
    return FutureBuilder<List<PropertyModel>>(
      future: controller.futureSearchResultProperties(searchKeyword),
      builder: (context, AsyncSnapshot<List<PropertyModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Utils.customLoadingSpinner();
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data found'));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<PropertyModel> properties = snapshot.data!;
          return SizedBox(
            height: (properties.length / 2) * 700,
            child: GridView.builder(
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.63,
                crossAxisSpacing: 20,
              ),
              itemCount: properties.length,
              itemBuilder: (context, index) {
                final PropertyModel data = properties[index];

                return PropertiesScreenWidget.propertiesBox(
                  pid: data.pid,
                  margin: EdgeInsets.symmetric(vertical: Get.height * 0.008),
                  image: data.images.isNotEmpty ? data.images[0] : '',
                  rooms: data.rooms,
                  coveredArea: data.coveredArea.toString(),
                  sellingPrice: data.sellingPrice.toString(),
                  location: data.locality,
                  postDate: data.postDate.toString(),
                  onTap: () {
                    Get.toNamed(AppRoutes.propertiesDetailScreen,
                        arguments: data);
                  },
                );
              },
            ),
          );
        }
      },
    );
  }

  // Widget _categorisedBody(String title) {
  //   return FutureBuilder<List<Map<String, dynamic>>>(
  //     future: fetchSortedProducts(title, true),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const CircularProgressIndicator();
  //       } else if (snapshot.data == null || snapshot.data!.isEmpty) {
  //         return const Center(child: Text('No data found'));
  //       } else if (snapshot.hasError) {
  //         return Text('Error: ${snapshot.error}');
  //       } else {
  //         List<Map<String, dynamic>> products = snapshot.data!;
  //         return SizedBox(
  //           // color: Colors.red,
  //           height: (products.length / 2) * 500,
  //           child: GridView.builder(
  //             primary: false,
  //             physics: const NeverScrollableScrollPhysics(),
  //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: 2,
  //               childAspectRatio: 0.58,
  //               crossAxisSpacing: 18.0,
  //               mainAxisSpacing: 20.0,
  //             ),
  //             itemCount: products.length,
  //             itemBuilder: (context, index) {
  //               return ProductThumbnail(
  //                 itemPid: (products[index]['pid']),
  //                 itemThumbnail: (products[index]['itemThumbnail']),
  //                 itemSubCategory: (products[index]['itemSubCategory']),
  //                 itemName: (products[index]['itemName']),
  //                 itemMrp: (products[index]['itemMrp']),
  //                 itemShippingCharge:
  //                     (products[index]['itemShippingCharge']).toString(),
  //                 itemDiscountPercentage: (products[index]
  //                     ['itemDiscountPercentage']),
  //                 itemOrderCount:
  //                     (products[index]['itemOrderCount']).toString(),
  //               );
  //             },
  //           ),
  //         );
  //       }
  //     },
  //   );
  // }
}

class SelectableRow extends StatefulWidget {
  final List<String> items;
  final Set<String> selectedItems;
  final String title;

  const SelectableRow({
    super.key,
    required this.items,
    required this.selectedItems,
    required this.title,
  });

  @override
  SelectableRowState createState() => SelectableRowState();
}

class SelectableRowState extends State<SelectableRow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(widget.items.length, (index) {
                bool isSelected =
                    widget.selectedItems.contains(widget.items[index]);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        widget.selectedItems.remove(widget.items[index]);
                      } else {
                        widget.selectedItems.add(widget.items[index]);
                      }
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 9),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF3072D4)
                          : Colors.transparent,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      widget.items[index],
                      style: TextStyle(
                        fontSize: 15,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
