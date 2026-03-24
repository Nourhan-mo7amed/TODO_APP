import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser?.uid ?? '';

  CollectionReference<Map<String, dynamic>> _tasksCollection() {
    return _firestore.collection('users').doc(_uid).collection('tasks');
  }

  CollectionReference<Map<String, dynamic>> _subTasksCollection(String taskId) {
    return _tasksCollection().doc(taskId).collection('sub_tasks');
  }

  // ─── Main Tasks ───
  Future<List<Map<String, dynamic>>> getMainTasks() async {
    final snapshot =
        await _tasksCollection().where('is_deleted', isEqualTo: false).get();

    final docs = [...snapshot.docs];
    docs.sort((a, b) {
      final aTs = a.data()['created_at'] as Timestamp?;
      final bTs = b.data()['created_at'] as Timestamp?;
      if (aTs == null && bTs == null) return 0;
      if (aTs == null) return 1;
      if (bTs == null) return -1;
      return bTs.compareTo(aTs);
    });

    return docs
        .map((doc) => {
              'id': doc.id,
              'title': doc['title'] ?? '',
              'dueDate': doc['dueDate'],
              'color': doc['color'] ?? 'FF2196F3',
              'is_favorite': (doc['is_favorite'] ?? false) ? 1 : 0,
            })
        .toList();
  }

  Future<String> addMainTask(
      String title, String? dueDate, String color) async {
    final now = FieldValue.serverTimestamp();
    final docRef = await _tasksCollection().add({
      'title': title,
      'dueDate': dueDate,
      'color': color,
      'is_favorite': false,
      'is_deleted': false,
      'created_at': now,
      'updated_at': now,
      'deleted_at': null,
    });
    return docRef.id;
  }

  Future<void> deleteMainTask(String taskId) async {
    final now = FieldValue.serverTimestamp();
    final taskRef = _tasksCollection().doc(taskId);
    final subSnapshot = await _subTasksCollection(taskId)
        .where('is_deleted', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    batch.update(taskRef, {
      'is_deleted': true,
      'deleted_at': now,
      'updated_at': now,
    });

    for (final doc in subSnapshot.docs) {
      batch.update(doc.reference, {
        'is_deleted': true,
        'deleted_at': now,
        'updated_at': now,
      });
    }

    await batch.commit();
  }

  Future<void> toggleFavorite(String taskId, bool isFav) async {
    await _tasksCollection().doc(taskId).update({
      'is_favorite': isFav,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateTaskTitle(String taskId, String title) async {
    await _tasksCollection().doc(taskId).update({
      'title': title,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  // ─── Sub Tasks ───
  Future<List<Map<String, dynamic>>> getSubTasks(String taskId) async {
    final snapshot = await _subTasksCollection(taskId)
        .where('is_deleted', isEqualTo: false)
        .get();

    final docs = [...snapshot.docs];
    docs.sort((a, b) {
      final aTs = a.data()['created_at'] as Timestamp?;
      final bTs = b.data()['created_at'] as Timestamp?;
      if (aTs == null && bTs == null) return 0;
      if (aTs == null) return 1;
      if (bTs == null) return -1;
      return aTs.compareTo(bTs);
    });

    return docs
        .map((doc) => {
              'id': doc.id,
              'content': doc['content'] ?? '',
              'is_done': (doc['is_done'] ?? false) ? 1 : 0,
            })
        .toList();
  }

  Future<String> addSubTask(String taskId, String content) async {
    final now = FieldValue.serverTimestamp();
    final docRef = await _subTasksCollection(taskId).add({
      'content': content,
      'is_done': false,
      'is_deleted': false,
      'created_at': now,
      'updated_at': now,
      'deleted_at': null,
    });

    await _tasksCollection().doc(taskId).update({
      'updated_at': now,
    });

    return docRef.id;
  }

  Future<void> toggleSubTaskDone(
      String taskId, String subTaskId, bool isDone) async {
    final now = FieldValue.serverTimestamp();
    await _subTasksCollection(taskId).doc(subTaskId).update({
      'is_done': isDone,
      'updated_at': now,
    });

    await _tasksCollection().doc(taskId).update({
      'updated_at': now,
    });
  }

  Future<void> deleteSubTask(String taskId, String subTaskId) async {
    final now = FieldValue.serverTimestamp();
    await _subTasksCollection(taskId).doc(subTaskId).update({
      'is_deleted': true,
      'deleted_at': now,
      'updated_at': now,
    });

    await _tasksCollection().doc(taskId).update({
      'updated_at': now,
    });
  }
}
