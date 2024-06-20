import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kaam_test/screens/create_task_screen.dart';
import 'package:kaam_test/controller/firebase_controller.dart';
import 'package:kaam_test/screens/todo_model.dart';
import 'package:kaam_test/screens/todo_task_display.dart';

class ToDoList extends StatefulWidget {
  ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final FirebaseController firebaseController = Get.put(FirebaseController());

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    firebaseController.getCurrentUser();
    firebaseController.retrieveData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await firebaseController.retrieveData();
      },
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () {
              Get.to(const CreateTaskScreen());
            },
            child: const Icon(Icons.add),
          ),
          appBar: AppBar(title: const Text("To-Do List")),
          body: Obx(() => Visibility(
              visible: !firebaseController.isLoading.value,
              replacement: const Center(child: CircularProgressIndicator()),
              child: firebaseController.todoModelList.isNotEmpty
                  ? ListView.builder(
                      itemCount: firebaseController.todoModelList.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        TodoModel todoModel =
                            firebaseController.todoModelList[index];
                        return ListTile(
                          title: Text(todoModel.title),
                          subtitle: Text(
                              "Status :  ${todoModel.status == "1" ? "Pending" : todoModel.status == "2" ? "In Progress" : "Completed"}"),
                          onTap: () {
                            Get.defaultDialog(
                              backgroundColor: Colors.blue,
                              barrierDismissible: true,
                              title: todoModel.title,
                              middleText: todoModel.description,
                              content: Column(
                                children: [
                                  Text(
                                    todoModel.description,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat.yMMMd().format(
                                            DateTime.parse(todoModel.date)),
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        todoModel.status == "1"
                                            ? "Pending"
                                            : todoModel.status == "2"
                                                ? "In Progress"
                                                : "Completed",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                  onTap: () {
                                    Get.to(() => CreateTaskScreen(
                                          todoModel: todoModel,
                                        ));
                                  },
                                  child: const Icon(Icons.edit)),
                              const SizedBox(
                                width: 8.0,
                              ),
                              InkWell(
                                  onTap: () {
                                    firebaseController.deleteItem(todoModel.id);
                                  },
                                  child: const Icon(Icons.delete)),
                            ],
                          ),
                        );
                      })
                  : const Center(
                      child: Text("No Items Found"),
                    )))),
    );
  }
}
