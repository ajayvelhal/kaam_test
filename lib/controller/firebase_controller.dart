import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kaam_test/screens/todo_list.dart';
import 'package:kaam_test/screens/todo_model.dart';

class FirebaseController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  RxString userId = "".obs;

  loginUser({required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Get.to(ToDoList());
    } catch (e) {
      Get.snackbar("Error",e.toString());
    }
  }

  registerUser({required String email, required String password}) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Get.to(ToDoList());
    } catch (e) {
      Get.snackbar("Error",e.toString());
    }
  }

  getCurrentUser() {
    userId.value = auth.currentUser?.uid ?? "";
  }

  RxInt statusId = 0.obs;

  setStatus(String status) {
    if (status.isNotEmpty) {
      statusId.value = int.parse(status);
    }
  }

  updateTaskData(
      {required String id,
      required String title,
      required String description,
      required String date,
      required String status}) async {
    await firebaseFirestore
        .collection("tasks")
        .doc(userId.value)
        .collection(userId.value)
        .doc(id)
        .update({
      "title": title,
      "description": description,
      "date": date,
      "status": status
    });
    Get.back();
    Get.snackbar("Task saved", "Task saved successfully");

    await retrieveData();
  }

  storeTaskData(
      {required String title,
      required String description,
      required String date,
      required String status}) async {
    await firebaseFirestore
        .collection("tasks")
        .doc(userId.value)
        .collection(userId.value)
        .add({
      "title": title,
      "description": description,
      "date": date,
      "status": status
    });
    Get.back();
    Get.snackbar("Task saved", "Task saved successfully");

    await retrieveData();
  }

  RxList<TodoModel> todoModelList = <TodoModel>[].obs;
  RxBool isLoading = false.obs;

  retrieveData() async {
    todoModelList.clear();
    isLoading(true);
    await firebaseFirestore
        .collection("tasks")
        .doc(userId.value)
        .collection(userId.value)
        .get()
        .then((QuerySnapshot snapshot) {
      for (var action in snapshot.docs) {
        todoModelList.add(TodoModel.fromJson(action));
      }
      isLoading(false);
    });
  }

  Future<void> deleteItem(String? id) async {
    await firebaseFirestore
        .collection("tasks")
        .doc(userId.value)
        .collection(userId.value)
        .doc(id)
        .delete();
    retrieveData();
  }
}
