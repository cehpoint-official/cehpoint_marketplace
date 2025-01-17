import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyModel {
  final String pid;
  final int bathRoom;
  final String agentUid;
  final String category;

  // final bool loanAvailable;
  final dynamic
      mapLocation; // You might need to define a custom class for GeoPoint
  final int storeRoom;
  final String sellerEmail;
  final String sellerName;
  final String agentName;
  final String agentEmail;
  final int sellingPrice;
  final String bankName;
  final String listingStatus;
  final String qualityCheck;
  final String waterAvailability;
  final List<dynamic> images;
  final int electricityAvailability;
  final String title;
  final DateTime postDate;
  final int bedRoom;
  final String disclaimer;
  final String rooms;
  final String postBy;
  final List<String> services;
  final String reraId;
  final String propertyType;
  final int coveredArea;
  final int kitchen;
  final String propertyDescription;
  final int livingRoom;
  final String locality;

  PropertyModel({
    required this.pid,
    required this.bathRoom,
    required this.agentUid,
    required this.category,
    // required this.loanAvailable,
    required this.mapLocation,
    required this.sellerEmail,
    required this.sellerName,
    required this.storeRoom,
    required this.agentName,
    required this.agentEmail,
    required this.sellingPrice,
    required this.bankName,
    required this.listingStatus,
    required this.qualityCheck,
    required this.waterAvailability,
    required this.images,
    required this.electricityAvailability,
    required this.title,
    required this.postDate,
    required this.bedRoom,
    required this.disclaimer,
    required this.rooms,
    required this.postBy,
    required this.services,
    required this.reraId,
    required this.propertyType,
    required this.coveredArea,
    required this.kitchen,
    required this.propertyDescription,
    required this.livingRoom,
    required this.locality,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    int parsetoInt(dynamic value) {
      if (value is int) {
        return value;
      } else if (value is String) {
        return int.tryParse(value) ?? 0;
      }
      return 0; // Return a default value if neither int nor String
    }

    return PropertyModel(
      pid: json['pid'] as String? ?? '',
      bathRoom: parsetoInt(json['Features']['No. of Bathroom']),
      agentUid: json['Agent UID'] as String? ?? '',
      category: json['Category'] as String? ?? '',
      // loanAvailable: json['Loan Available'] as bool? ?? false,
      mapLocation: json['Location Point'],
      storeRoom: parsetoInt(json['Store Room']),
      sellerEmail: json['Seller Email'],
      sellerName: json['Seller Name'],
      agentName: json['Agent Name'] as String? ?? '',
      agentEmail: json['Agent Email'] as String? ?? '',
      sellingPrice: parsetoInt(json['Selling Price (INR)']),
      bankName: json['Bank'] as String? ?? '',
      listingStatus: json['Listing Status'] as String? ?? '',
      qualityCheck: json['Quality Check'] as String? ?? '',
      waterAvailability: json['Water Availablity'] as String? ?? '',
      images: json['Images'] as List<dynamic>? ?? [],
      electricityAvailability: parsetoInt(json['Electricity Availability']),
      title: json['Title'] as String? ?? '',
      postDate: json['Post Date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (json['Post Date'] as Timestamp).seconds * 1000)
          : DateTime.now(),
      // Assuming this might be a complex type
      bedRoom: parsetoInt(json['Features']['No. of Bedroom']),
      disclaimer: json['Disclaimer'] as String? ?? '',
      rooms: json['Rooms'] as String? ?? '',
      postBy: json['Post By'] as String? ?? '',
      services: List<String>.from(json['Services'] as List<dynamic>? ?? []),
      reraId: json['Rera ID'] as String? ?? '',
      propertyType: json['Property Type'] as String? ?? '',
      coveredArea: parsetoInt(json['Covered Area (sqft)']),
      kitchen: parsetoInt(json['Kitchen']),
      propertyDescription: json['Property Description'] as String? ?? '',
      livingRoom: parsetoInt(json['Living Room']),
      locality: json['Locality'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pid': pid,
      'Bath Room': bathRoom,
      'Agent UID': agentUid,
      'Category': category,
      // 'Loan Available': loanAvailable,
      'Map Location': mapLocation,
      'Store Room': storeRoom,
      'Agent Name': agentName,
      'Agent Email': agentEmail,
      'Seller Email': sellerEmail,
      'Seller Name': sellerName,
      'Selling Price (INR)': sellingPrice,
      'Bank': bankName,
      'Listing Status': listingStatus,
      'Quality Check': qualityCheck,
      'Water Availablity': waterAvailability,
      'Images': images,
      'Electricity Availability': electricityAvailability,
      'Title': title,
      'Post Date': postDate.toUtc(),
      'Bed Room': bedRoom,
      'Disclaimer': disclaimer,
      'Rooms': rooms,
      'Post By': postBy,
      'Services': services,
      'Rera ID': reraId,
      'Property Type': propertyType,
      'Covered Area (sqft)': coveredArea,
      'Kitchen': kitchen,
      'Property Description': propertyDescription,
      'Living Room': livingRoom,
      'Locality': locality,
    };
  }

  factory PropertyModel.fromDocument(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    int parsetoInt(dynamic value) {
      if (value is int) {
        return value;
      } else if (value is String) {
        return int.tryParse(value) ?? 0;
      }
      return 0; // Return a default value if neither int nor String
    }

    return PropertyModel(
      pid: data?['pid'] ?? '',
      bathRoom: parsetoInt(data?['Bath Room']),
      agentUid: data?['Agent UID'] ?? '',
      category: data?['Category'] ?? '',
      // loanAvailable: data?['Loan Available'] ?? false,
      mapLocation: data?['Location Point'],
      sellerEmail: data?['Seller Email'],
      sellerName: data?['Seller Name'],
      storeRoom: parsetoInt(data?['Store Room']),
      agentName: data?['Agent Name'] ?? '',
      agentEmail: data?['Agent Email'] ?? '',
      sellingPrice: parsetoInt(data?['Selling Price (INR)']),
      bankName: data?['Bank'] ?? '',
      listingStatus: data?['Listing Status'] ?? '',
      qualityCheck: data?['Quality Check'] ?? '',
      waterAvailability: data?['Water Availablity'] ?? '',
      images: List<String>.from(data?['Images'] ?? ''),
      electricityAvailability: parsetoInt(data?['Electricity Availability']),
      title: data?['Title'] ?? '',
      postDate: data?['Post Date'] != null
          ? (data?['Post Date'] as Timestamp).toDate()
          : DateTime.now(),
      bedRoom: parsetoInt(data?['Bed Room']),
      disclaimer: data?['Disclaimer'] ?? '',
      rooms: data?['Rooms'] ?? '',
      postBy: data?['Post By'] ?? '',
      services: List<String>.from(data?['Services'] ?? []),
      reraId: data?['Rera ID'] ?? '',
      propertyType: data?['Property Type'] ?? '',
      coveredArea: parsetoInt(data?['Covered Area (sqft)']),
      kitchen: parsetoInt(data?['Kitchen']),
      propertyDescription: data?['Property Description'] ?? '',
      livingRoom: parsetoInt(data?['Living Room']),
      locality: data?['Locality'] ?? '',
    );
  }

  factory PropertyModel.fromDocument1(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return PropertyModel(
      pid: data['pid'] ?? '',
      // bathRoom: (data['Bath Room'] as num?)?.toInt() ?? 0,
      bathRoom: data['Bath Room'] is int
          ? data['Bath Room']
          : int.tryParse(data['Bath Room'].toString()) ?? 0,
      agentUid: data['Agent UID'] ?? '',
      category: data['Category'] ?? '',
      mapLocation: data['Location Point'],
      sellerEmail: data['Seller Email'] ?? '',
      sellerName: data['Seller Name'] ?? '',
      // storeRoom: (data['Store Room'] as num?)?.toInt() ?? 0,
      storeRoom: data['Store Room'] is int
          ? data['Store Room']
          : int.tryParse(data['Store Room'].toString()) ?? 0,
      agentName: data['Agent Name'] ?? '',
      agentEmail: data['Agent Email'] ?? '',
      // sellingPrice: (data['Selling Price (INR)'] as num?)?.toInt() ?? 0,
      sellingPrice: data['Selling Price (INR)'] is int
          ? data['Selling Price (INR)']
          : int.tryParse(data['Selling Price (INR)'].toString()) ?? 0,
      bankName: data['Bank'] ?? '',
      listingStatus: data['Listing Status'] ?? '',
      qualityCheck: data['Quality Check'] ?? '',
      waterAvailability: data['Water Availablity'] ?? '',
      images: List<String>.from(data['Images'] ?? []),
      // electricityAvailability:
      //     (data['Electricity Availability'] as num?)?.toInt() ?? 0,
      electricityAvailability: data['Electricity Availability'] is int
          ? data['Electricity Availability']
          : int.tryParse(data['Electricity Availability'].toString()) ?? 0,
      title: data['Title'] ?? '',
      postDate: data['Post Date'] != null
          ? (data['Post Date'] as Timestamp).toDate()
          : DateTime.now(),
      // bedRoom: (data['Bed Room'] as num?)?.toInt() ?? 0,
      bedRoom: data['Bed Room'] is int
          ? data['Bed Room']
          : int.tryParse(data['Bed Room'].toString()) ?? 0,
      disclaimer: data['Disclaimer'] ?? '',
      rooms: data['Rooms'] ?? '',
      postBy: data['Post By'] ?? '',
      services: List<String>.from(data['Services'] ?? []),
      reraId: data['Rera ID'] ?? '',
      propertyType: data['Property Type'] ?? '',
      coveredArea: data['Covered Area (sqft)'] is int
          ? data['Covered Area (sqft)']
          : int.tryParse(data['Covered Area (sqft)'].toString()) ?? 0,
      // kitchen: (data['Kitchen'] as num?)?.toInt() ?? 0,
      kitchen: data['Kitchen'] is int
          ? data['Kitchen']
          : int.tryParse(data['Kitchen'].toString()) ?? 0,
      propertyDescription: data['Property Description'] ?? '',
      // livingRoom: (data['Living Room'] as num?)?.toInt() ?? 0,
      livingRoom: data['Living Room'] is int
          ? data['Living Room']
          : int.tryParse(data['Living Room'].toString()) ?? 0,
      locality: data['Locality'] ?? '',
    );
  }
}
