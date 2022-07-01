import 'package:cloud_functions/cloud_functions.dart';

// this function to access the "addAdmin" that is (already) created in the Cloud Functions on Firebase

class CloudFunctionsDAO {
  FirebaseFunctions functions = FirebaseFunctions.instance;

  Future addModerator(String email) async {
    HttpsCallable callable = functions.httpsCallable(
        'addAdmin'); //addAdmin is the name of the function on Cloud Functions server

    // a call to the cloud function addAdmin on the server is made to add the 'moderator' field in the custom claims
    final resp = await callable.call(<String, dynamic>{
      'email': email,
    });

    // print("result: ${resp.data}");
  }
}
