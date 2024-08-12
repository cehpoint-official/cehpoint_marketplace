// ignore_for_file: use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:cehpoint_marketplace/common/colors.dart';
import 'package:cehpoint_marketplace/home/properties/property_controller.dart';
import 'package:cehpoint_marketplace/home/properties/screens/search_property_page.dart';
import 'package:cehpoint_marketplace/home/properties/widget/properties_screen_widget.dart';
import 'package:cehpoint_marketplace/models/property.dart';
import 'package:cehpoint_marketplace/navigation/bottomNavigationItems/propertyMessageScreen/property_message_screen.dart';
import 'package:cehpoint_marketplace/navigation/page_transitions.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class PropertiesDetailScreen extends StatelessWidget {
  const PropertiesDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PropertyModel properties = Get.arguments;
    final controller = Get.find<PropertyController>();
    return Scaffold(
      backgroundColor: ColorConstants.bgColour,
      appBar: AppBar(
        backgroundColor: ColorConstants.green800,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          InkWell(
            onTap: () {
              _navigateToSearchPage(context);
            },
            child: Padding(
              padding: EdgeInsets.only(right: Get.width * 0.04),
              child: const Icon(Icons.search),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: Get.height * 0.1),
          child: Column(
            children: [
              CarouselSlider.builder(
                itemCount:
                    properties.images.isNotEmpty ? properties.images.length : 1,
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return Stack(
                    children: [
                      if (properties.images.isEmpty ||
                          properties.images[index] == null ||
                          properties.images[index].isEmpty)
                        Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/PropertyImage/empty_property_image.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(properties.images[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black.withOpacity(0.4),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          margin: EdgeInsets.only(
                              top: Get.height * 0.004, right: Get.width * 0.02),
                          child: Row(
                            children: [
                              // InkWell(
                              //     onTap: () {
                              //       Fluttertoast.showToast(
                              //           msg: 'Under Construction');
                              //     },
                              //     child: const Icon(Icons.share,
                              //         color: Colors.white)),
                              // const SizedBox(width: 8),
                              InkWell(
                                  onTap: () async {
                                    await controller.saveProperty(properties);
                                    Fluttertoast.showToast(
                                        msg: 'Property saved');
                                  },
                                  child: const Icon(Icons.bookmark_border,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  aspectRatio: 16 / 9,
                  onPageChanged: (i, option) {
                    if (i >= 0 && i < properties.images.length) {
                      controller.setImageViewIndex(i);
                    }
                  },
                  viewportFraction: 1,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                ),
              ),
              SizedBox(height: Get.height * 0.01),
              Obx(
                () {
                  final currentIndex =
                      controller.propertyImageCurrentIndex.value;
                  final itemCount = properties.images.length;

                  // Handle the case when itemCount is zero
                  if (itemCount == 0) {
                    return const SizedBox
                        .shrink(); // Or handle this case as needed
                  }

                  // Ensure the index is valid
                  final validIndex =
                      (currentIndex >= 0 && currentIndex < itemCount)
                          ? currentIndex
                          : 0;

                  return PageViewDotIndicator(
                    currentItem: validIndex,
                    count: itemCount,
                    unselectedColor: Colors.grey,
                    selectedColor: ColorConstants.blue200,
                    size: const Size(20, 10),
                    borderRadius: BorderRadius.circular(6),
                    boxShape: BoxShape.rectangle,
                  );
                },
              ),
              SizedBox(height: Get.height * 0.004),
              PropertiesScreenWidget.propertiesDetailTitleBox(
                propertyModel: properties,
              ),
              SizedBox(height: Get.height * 0.004),
              PropertiesScreenWidget.propertiesDetailContactBox(
                propertyModel: properties,
              ),
              SizedBox(height: Get.height * 0.004),
              PropertiesScreenWidget.propertiesDetailInfoBox(
                propertyModel: properties,
              ),
              SizedBox(height: Get.height * 0.004),
              PropertiesScreenWidget.propertiesDetailBox(
                  propertyModel: properties),
              SizedBox(height: Get.height * 0.01),
              PropertiesScreenWidget.propertiesDetailAmenitiesBox(
                  propertyModel: properties),
              SizedBox(height: Get.height * 0.01),
              PropertiesScreenWidget.propertiesDetailDisclaimerBox(
                propertyModel: properties,
                controller: controller,
              ),
              SizedBox(height: Get.height * 0.01),
              PropertiesScreenWidget.propertiesDetailPropertyDescriptionBox(
                propertyModel: properties,
                controller: controller,
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () async {
                // Get.toNamed(AppRoutes.propertyMessageScreen, arguments: {
                //   "agentId": properties.agentUid,
                //   "agentEmail": properties.sellerEmail,
                //   "agentName": properties.agentName,
                // });
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: Get.width * 0.02, vertical: 12),
                        backgroundColor: ColorConstants.green50,
                        content: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black),
                              onPressed: () {
                                Get.to(
                                  PropertyMessageScreen(
                                    receiverEmail: properties.sellerEmail,
                                    receiverName: properties.sellerName,
                                    myEmail: FirebaseAuth
                                            .instance.currentUser?.email
                                            .toString() ??
                                        '',
                                    myName: FirebaseAuth
                                            .instance.currentUser?.displayName
                                            .toString() ??
                                        '',
                                    userType: 'Seller',
                                  ),
                                );
                              },
                              child: const Text('Chat Seller'),
                            ),
                            SizedBox(width: Get.width * 0.01),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black),
                              onPressed: () {
                                Get.to(
                                  PropertyMessageScreen(
                                    receiverEmail: properties.agentEmail,
                                    receiverName: properties.agentName,
                                    myEmail: FirebaseAuth
                                            .instance.currentUser?.email
                                            .toString() ??
                                        '',
                                    myName: FirebaseAuth
                                            .instance.currentUser?.displayName
                                            .toString() ??
                                        '',
                                    userType: 'Agents',
                                  ),
                                );
                              },
                              child: const Text('Chat Agent'),
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: Container(
                alignment: Alignment.center,
                height: Get.height * 0.08,
                color: Colors.white,
                child: const Text(
                  'Chat Now',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ZegoSendCallInvitationButton(
              onPressed: (code, message, p2) {
                controller.uploadCallingDataToFirebase(
                  agentName: properties.agentName,
                  agentEmail: properties.agentEmail,
                  userType: "",
                );
              },
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              borderRadius: 0,
              buttonSize: Size(Get.width, Get.height * 0.08),
              text: "Call Agent",
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              iconVisible: false,
              // notificationTitle: 'Incoming',
              // notificationMessage:
              //     '${FirebaseAuth.instance.currentUser!.displayName} is calling you',
              clickableBackgroundColor: Colors.yellow,
              isVideoCall: false,
              resourceID: "zego_sokoni",
              invitees: [
                ZegoUIKitUser(
                  id: properties.agentEmail,
                  name: properties.agentName,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _navigateToSearchPage(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> historyArray = prefs.getStringList('historyPrefs') ?? [];
  Navigator.of(context).push(
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return SearchPropertyPage(
          initialHistory: historyArray,
        );
      },
      transitionsBuilder: customTransition(const Offset(0, 0)),
    ),
  );
}
