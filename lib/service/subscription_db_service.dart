import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

// ignore: depend_on_referenced_packages
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
class SubscriptionDbService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String userId = "";

  Future<void> saveSubcriptionsDetails(PurchaseDetails purchaseDetails) async {


    GooglePlayPurchaseDetails gpp =
        purchaseDetails as GooglePlayPurchaseDetails;
    Map map = {
      'developerPayload': gpp.billingClientPurchase.developerPayload,
      'isAcknowledged': gpp.billingClientPurchase.isAcknowledged,
      'isAutoRenewing': gpp.billingClientPurchase.isAutoRenewing,
      'obfuscatedAccountId': gpp.billingClientPurchase.obfuscatedAccountId,
      'obfuscatedProfileId': gpp.billingClientPurchase.obfuscatedProfileId,
      'orderId': gpp.billingClientPurchase.orderId,
      'originalJson': gpp.billingClientPurchase.originalJson,
      'packageName': gpp.billingClientPurchase.packageName,
      'purchaseTime': gpp.billingClientPurchase.purchaseTime,
      'purchaseToken': gpp.billingClientPurchase.purchaseToken,
      'signature': gpp.billingClientPurchase.signature,
      'sku': gpp.billingClientPurchase.sku
    };
  }

/*  Stream<UserData> get featchUserDataFromDb {
    Map<String, dynamic>? userData = Helper.checkLogIn();
    return _firestore
        .collection('user')
        .doc(userData!['userId'])
        .snapshots()
        .map((event) => userDataFromSnapshot(event));
  }*/


  UserData userDataFromSnapshot(DocumentSnapshot ds) {
    debugPrint("Data :: ${ds.data()}");
    GooglePlayPurchaseDetails? oldPd;
    try {
      var pw = ds.get('Purchase Wrapper');
      oldPd = GooglePlayPurchaseDetails.fromPurchase(PurchaseWrapper(
        isAcknowledged: pw['isAcknowledged'],
        isAutoRenewing: pw['isAutoRenewing'],
        orderId: pw['orderId'],
        originalJson: pw['originalJson'],
        packageName: pw['packageName'],
        purchaseState: PurchaseStateWrapper.purchased,
        purchaseTime: pw['purchaseTime'],
        purchaseToken: pw['purchaseToken'],
        signature: pw['signature'],
        sku: pw['sku'],
        developerPayload: pw['developerPayload'],
        obfuscatedAccountId: pw['obfuscatedAccountId'],
        obfuscatedProfileId: pw['obfuscatedProfileId'],
        skus: [],
      ));
    } catch (e) {}
    return UserData(oldPdFromDb: oldPd, username: ds.get('name'));
  }

}

class UserData {
  String username;
  GooglePlayPurchaseDetails? oldPdFromDb;

  UserData({required this.username, required this.oldPdFromDb});
}
