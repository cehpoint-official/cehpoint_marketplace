// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cehpoint_marketplace/common/colors.dart';
import 'package:cehpoint_marketplace/models/product_model.dart';
import 'package:cehpoint_marketplace/navigation/bottomNavigationItems/paymentsPage/payments_details.dart';
import 'package:cehpoint_marketplace/navigation/page_transitions.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String timeAgo;
  final bool isBuyer;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isBuyer,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    BubbleStyle style = (isBuyer)
        ? const BubbleStyle(
            nip: BubbleNip.rightTop,
            color: ColorConstants.blue50,
            elevation: 1.0, // Adjust elevation as needed
            margin: BubbleEdges.only(top: 8.0, left: 50.0),
            alignment: Alignment.topRight,
          )
        : const BubbleStyle(
            nip: BubbleNip.leftTop,
            color: ColorConstants.blue50,
            elevation: 1.0, // Adjust elevation as needed
            margin: BubbleEdges.only(top: 8.0, right: 50.0),
            alignment: Alignment.topLeft,
          );

    return Column(
      crossAxisAlignment:
          (isBuyer) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisAlignment:
          (isBuyer) ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Bubble(
          style: style,
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            timeAgo,
            style: const TextStyle(
              fontSize: 12.0, // Adjust font size as needed
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}

// chat bubble for banners
class BannerChatBubble extends StatelessWidget {
  final String imageUrl;
  final String message;
  final String timeAgo;
  final bool isBuyer;

  const BannerChatBubble({
    super.key,
    required this.imageUrl,
    required this.message,
    required this.isBuyer,
    required this.timeAgo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 290,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ColorConstants.blue50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.network(imageUrl, height: 185, width: 185),
                Text(
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  message,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(timeAgo),
          ),
        ],
      ),
    );
  }
}

// chat bubble for banners
class ConfirmationChatBubble extends StatelessWidget {
  final String productId;
  final String imageUrl;
  final String message;
  final String timeAgo;
  final int orderQuantity;
  final double orderDeliveryCharge;
  final bool isBuyer;

  const ConfirmationChatBubble({
    super.key,
    required this.productId,
    required this.imageUrl,
    required this.message,
    required this.timeAgo,
    required this.isBuyer,
    required this.orderQuantity,
    required this.orderDeliveryCharge,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 171,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ColorConstants.blue50,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //details
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.network(imageUrl, height: 93, width: 76),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              message,
                              maxLines: 3,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Your order will be delivered on July 25th',
                              maxLines: 2,
                              textAlign: TextAlign.left,
                              style:
                                  TextStyle(fontSize: 14, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //buttons
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => Fluttertoast.showToast(msg: 'cancel'),
                          child: Container(
                            height: 40,
                            color: ColorConstants.blue100,
                            child: const Center(
                                child: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            ProductModel? productModel =
                                await collectProductData(productId);
                            if (productModel != null) {
                              Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) {
                                  return PaymentsDetails(
                                    productModel: productModel,
                                    orderQuantity: orderQuantity,
                                    orderDeliveryCharge: orderDeliveryCharge,
                                  );
                                },
                                transitionsBuilder:
                                    customTransition(const Offset(0, 0)),
                              ));
                            } else {
                              log('No product data available for $productId');
                            }
                          },
                          child: Container(
                            color: ColorConstants.blue700,
                            child: const Center(
                                child: Text(
                              'Pay Now',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(timeAgo),
          ),
        ],
      ),
    );
  }
}
