import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_converter/currency_converter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:cehpoint_marketplace/models/property.dart';

class PropertyController extends GetxController {
  late TextEditingController searchController;
  final CarouselController carouselController = CarouselController();
  final CurrencyConverter converter = CurrencyConverter();
  var propertyImageCurrentIndex = 0.obs;
  String selectedSortOption = '';

  // List homeImages = [];

  var isExpandedForDisclaimer = true.obs;
  var isExpandedForPropertyDescription = true.obs;

  void toggleExpandedForDisclaimer() {
    isExpandedForDisclaimer.toggle();
  }

  void toggleExpandedForPropertyDescription() {
    isExpandedForPropertyDescription.toggle();
  }

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    // fetchHomeImageFromFirebase();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  void setImageViewIndex(int i) {
    propertyImageCurrentIndex.value = i;
    update();
  }

  void setSortValue(sortValue) {
    selectedSortOption = sortValue;
    update();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>>
      fetchHomeImageFromFirebase() async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('property_basic_images')
        .doc('HomeImage')
        .get();
    return querySnapshot;
  }

  // Existing code...

  Future<QuerySnapshot<Map<String, dynamic>>> fetchDataFromFirebase(
      {String? sortOption}) async {
    Query<Map<String, dynamic>> collection =
        FirebaseFirestore.instance.collection('property_items');

    if (sortOption == 'highToLow') {
      collection = collection.orderBy('Selling Price (INR)', descending: true);
    } else if (sortOption == 'lowToHigh') {
      collection = collection.orderBy('Selling Price (INR)');
    }

    var querySnapshot = await collection.get();
    return querySnapshot;
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Buyers')
          .doc(FirebaseAuth.instance.currentUser?.email.toString() ?? '')
          .collection('Call History')
          .get();

      List<Map<String, dynamic>> dataList = [];

      if (snapshot.size > 0) {
        for (var doc in snapshot.docs) {
          // Extract data from each document
          Map<String, dynamic> data = doc.data();
          dataList.add(data);
          update();
        }
      }

      return dataList;
    } catch (e) {
      Logger().e(e.toString());
      return []; // Return an empty list in case of an error
    }
  }

  Future uploadCallingDataToFirebase(
      {required String agentName,
      required String agentEmail,
      required userType}) async {
    DateTime nowTime = DateTime.now();
    try {
      await FirebaseFirestore.instance
          .collection('Buyers')
          .doc(FirebaseAuth.instance.currentUser?.email.toString() ?? '')
          .collection('Call History')
          .doc()
          .set({
        'Name': agentName,
        'CallID': agentEmail,
        'Direction': "Outgoing",
        'Date-Time': nowTime,
        'User Type': 'Agents',
      });
      final userType = await fetchData();
      await FirebaseFirestore.instance
          .collection(
              (userType[0]['User Type'] == "Seller") ? "users" : "Agents")
          .doc(agentEmail)
          .collection('Call History')
          .doc()
          .set({
        'Name': FirebaseAuth.instance.currentUser?.displayName.toString() ?? '',
        'CallID': FirebaseAuth.instance.currentUser?.email.toString() ?? '',
        'Direction': "Incoming",
        'Date-Time': nowTime,
        'User Type': "Buyers"
      });
    } on FirebaseFirestore catch (e) {
      Logger().e(e.toString());
    }
  }

  Future<List<PropertyModel>> futureSearchResultProperties(
      String keyword) async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection('property_items').get();

    var filteredDocs = querySnapshot.docs
        .where((doc) =>
            doc['Category']
                .toString()
                .toLowerCase()
                .contains(keyword.toLowerCase()) ||
            doc['Locality']
                .toString()
                .toLowerCase()
                .contains(keyword.toLowerCase()) ||
            doc['Property Type']
                .toString()
                .toLowerCase()
                .contains(keyword.toLowerCase()) ||
            doc['Title']
                .toString()
                .toLowerCase()
                .contains(keyword.toLowerCase()))
        .toList();
    return filteredDocs.map((doc) => PropertyModel.fromDocument1(doc)).toList();
  }

  // Future<List<PropertyModel>> futureSearchFilterProperties(
  //   String keyword,
  //   Set<String> categorySet,
  //   Set<String> propertyTypeSet,
  // ) async {
  //   var querySnapshot =
  //       await FirebaseFirestore.instance.collection('property_items').get();

  //   var filteredDocs = querySnapshot.docs
  //       .where((doc) =>
  //           doc['Category']
  //               .toString()
  //               .toLowerCase()
  //               .contains(keyword.toLowerCase()) ||
  //           doc['Property Type']
  //               .toString()
  //               .toLowerCase()
  //               .contains(keyword.toLowerCase()))
  //       .toList();

  //   return filteredDocs.map((doc) => PropertyModel.fromDocument1(doc)).toList();
  // }

  Future<void> saveProperty(PropertyModel property) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final savedCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .collection('saved_properties');

      await savedCollection.doc(property.pid).set(property.toJson());
    }
  }

  Future<void> deleteSavedProperty(String pid) async {
    try {
      final userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
      final savedCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .collection('saved_properties');

      await savedCollection.doc(pid).delete();
      update();
      Fluttertoast.showToast(msg: 'Property removed');
    } catch (e) {
      Logger().e(e.toString());
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchSavedProperties() async {
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
    Query<Map<String, dynamic>> collection = FirebaseFirestore.instance
        .collection('users')
        .doc(userEmail)
        .collection('saved_properties');

    var querySnapshot = await collection.get();
    return querySnapshot;
  }
}
