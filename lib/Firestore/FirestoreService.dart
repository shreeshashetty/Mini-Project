import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference<Map<String, dynamic>> complaintsCollection =
      FirebaseFirestore.instance.collection('Complaints');

  Future<void> addComplaint({
    required String name,
    required String phoneNumber,
    required String building,
    required String floor,
    required String room,
    required String roomNo,
    required String object,
    required String description,
    required int roomPriority,
    required DateTime timestamp,
    required bool completed,
  }) async {
    try {
      await complaintsCollection.add({
        'name': name,
        'phoneNumber': phoneNumber,
        'building': building,
        'floor': floor,
        'room': room,
        'roomNo': roomNo,
        'object': object,
        'description': description,
        'roomPriority': roomPriority,
        'timestamp': timestamp,
        'completed': completed,
      });
    } catch (e) {
      print('Error adding complaint: $e');
      // Handle the error as needed
    }
  }

  Future<void> updateCompletedStatus(String complaintId, bool completed) async {
    try {
      await complaintsCollection
          .doc(complaintId)
          .update({'completed': completed});
    } catch (e) {
      print('Error updating completed status: $e');
      // Handle the error as needed
    }
  }

  Future<Map<String, dynamic>> getComplaintDetails(String complaintId) async {
    try {
      var document = await complaintsCollection.doc(complaintId).get();

      if (document.exists) {
        return document.data() as Map<String, dynamic>;
      } else {
        // Document does not exist
        return {};
      }
    } catch (e) {
      print('Error getting complaint details: $e');
      // Handle the error as needed
      return {};
    }
  }
}
