import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class ItemDAO {
  final CollectionReference collection = FirebaseFirestore.instance
      .collection('SomeCollection'); // enter your collection

  // check the firestore docs for more info..
  // or youtube

  // READ collection
  Stream<QuerySnapshot> getStream() {
    // returns a stream
    // orders the stream by the field 'date' (date must be a field in the document)
    //// ore use the index option in the firestore (choose one of them)
    return collection.orderBy('date', descending: true).snapshots();
    // use in StreamBuilder

    // if only one item is needed >>> configure in the StreamBuilder
  }

  // enter your item model here
  void saveItem(SomeItemModel item) {
    collection.add(item.toMap());
    //item.toMap() -->> "jsonify" your data
  }

  void updateItem(SomeItemModel item, String documentName) {
    // get the document name from the collection
    final DocumentReference documentRef = collection.doc(documentName);

    documentRef.update(item.toMap()); //toMap to make it a json format
    // you could also use just one field/value (e.g. name) to update just that one, but this (using SomeItemModel) is more convenient
    // nested values -->> use e.g. city.name
  }

  void deleteItem(String documentName) {
    // get the document name from the collection
    final DocumentReference documentRef = collection.doc(documentName);

    documentRef.delete(); //delete the document
  }

  // upload image
  // returns Future
  Future uploadImage(image) async {
    // TODO: add more comments
    try {
      if (image == null) return;

      final imageName = basename(
          image!.path); // to get only the image name and not the whole location
      final destination = 'images/$imageName';
      final ref = FirebaseStorage.instance.ref(destination);
      final task = ref.putFile(image);

      if (task == null) return;

      final snapshot = await task.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();

      // print('Doenloadink = $urlDownload');
      // print(urlDownload);
      return urlDownload;
    } on FirebaseException {
      return;
    }
  }
}
