import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:cehpoint_marketplace/common/colors.dart';
import 'package:cehpoint_marketplace/common/utils.dart';
import 'package:cehpoint_marketplace/home/properties/property_controller.dart';
import 'package:cehpoint_marketplace/models/property.dart';
import 'package:cehpoint_marketplace/routes/app_routes.dart';

class PropertySavedScreen extends StatelessWidget {
  const PropertySavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PropertyController>();

    return Scaffold(
      backgroundColor: ColorConstants.bgColour,
      body: GetBuilder<PropertyController>(builder: (_) {
        return FutureBuilder<QuerySnapshot>(
          future: controller.fetchSavedProperties(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Utils.customLoadingSpinner();
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                List<DocumentSnapshot> documents = snapshot.data!.docs;
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 300,
                    crossAxisSpacing: 18,
                  ),
                  itemCount: documents.length,
                  itemBuilder: (context, i) {
                    final PropertyModel data =
                        PropertyModel.fromDocument(documents[i]);
                    log(data.locality.toString());
                    return propertiesBox(
                      pid: data.pid,
                      margin:
                          EdgeInsets.symmetric(vertical: Get.height * 0.008),
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
                      onDelete: () async {
                        try {
                          await controller.deleteSavedProperty(data.pid);
                        } catch (e) {
                          Logger().e(e.toString());
                          Fluttertoast.showToast(
                              msg: 'Failed to delete property');
                        }
                      },
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('No Saved Properties'),
                );
              }
            }
          },
        );
      }),
    );
  }

  static Widget propertiesBox({
    required String pid,
    required String image,
    required String rooms,
    required String coveredArea,
    required String sellingPrice,
    required String location,
    required String postDate,
    required VoidCallback onTap,
    EdgeInsets? margin,
    required Future<Null> Function() onDelete,
  }) {
    final convertPostDate = Utils.formatPostDate(postDate.toString());
    final formattedPrice = Utils.formatPrice(sellingPrice);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        margin: margin,
        padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.014, vertical: Get.height * 0.006),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: image.isEmpty
                    ? const AssetImage(
                            'assets/PropertyImage/empty_property_image.png')
                        as ImageProvider
                    : NetworkImage(image),
                fit: BoxFit.cover,
              )),
            ),
            const SizedBox(height: 8),
            Text('$rooms Flat', style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 6),
            Text(
              '$formattedPrice | $coveredArea sqft',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 2),
            Text(location,
                style: const TextStyle(
                    fontSize: 12, overflow: TextOverflow.ellipsis)),
            Text(convertPostDate,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: onDelete,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: const Text(
                    'Delete',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
