import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kaam_test/controller/firebase_controller.dart';
import 'package:kaam_test/screens/todo_model.dart';

class CreateTaskScreen extends StatefulWidget {
  final TodoModel? todoModel;

  const CreateTaskScreen({super.key, this.todoModel});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final FirebaseController firebaseController = Get.put(FirebaseController());

  final TextEditingController titleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController dateController = TextEditingController();

  final TextEditingController statusController = TextEditingController();

  @override
  void initState() {
    if(widget.todoModel!=null){
      titleController.text = widget.todoModel?.title ?? "";
      descriptionController.text = widget.todoModel?.description ?? "";
      dateController.text = DateFormat.yMMMd().format(DateTime.parse(widget.todoModel?.date ?? ""));
      statusController.text = widget.todoModel?.status ?? "";
      firebaseController.setStatus(widget.todoModel?.status ?? "");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Task")),
      body: Column(
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(8, 6, 0, 0),
              margin: const EdgeInsets.only(left: 10, right: 10),
              height: 40,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                keyboardType: TextInputType.visiblePassword,
                cursorColor: Colors.black,
                controller: titleController,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter Title',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(color: Colors.black),
              )),
          const SizedBox(
            height: 12.0,
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
              margin: const EdgeInsets.only(left: 10, right: 10),
              // height: 100,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)),
              child: TextFormField(
                maxLines: 6,
                keyboardType: TextInputType.visiblePassword,
                cursorColor: Colors.black,
                controller: descriptionController,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter Description',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(color: Colors.black),
              )),
          const SizedBox(
            height: 12.0,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(4, 4, 0, 0),
            margin: const EdgeInsets.only(left: 10, right: 10),
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)),
            child: TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'Select Date',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  prefixIcon: Icon(Icons.calendar_month,size: 24,),

                ),
                readOnly: true, // when true user cannot edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: widget.todoModel?.date != null ? DateTime.parse(widget.todoModel?.date ?? "") : DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101));
                  dateController.text =  pickedDate.toString();
                }),
          ),
          const SizedBox(
            height: 12.0,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(8, 12, 0, 0),
            margin: const EdgeInsets.only(left: 10, right: 10),
            height: 40,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)),
            child: Obx(() => DropdownButtonFormField(
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Please select status",
                    isDense: true,
                    hintStyle: TextStyle(color: Colors.grey)),
                style: const TextStyle(color: Colors.blue),
                items: const [
                  DropdownMenuItem(
                    value: 1,
                    child: Text("Pending"),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text("In Progress"),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Text("Completed"),
                  ),
                ],
                value: firebaseController.statusId.value == 0
                    ? null
                    : firebaseController.statusId.value,
                onChanged: (value) {
                  statusController.text = value.toString();
                })),
          ),
          const SizedBox(
            height: 12.0,
          ),
          ElevatedButton(
            onPressed: () async {
              if (widget.todoModel == null) {
                firebaseController.storeTaskData(
                    title: titleController.text,
                    description: descriptionController.text,
                    date: dateController.text,
                    status: statusController.text);
              } else {
                firebaseController.updateTaskData(
                    id: widget.todoModel?.id ?? "",
                    title: titleController.text,
                    description: descriptionController.text,
                    date: dateController.text,
                    status: statusController.text);
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.blue, // foreground
            ),
            child: Text(widget.todoModel!=null ? "Update" : "Save"),
          ),
        ],
      ),
    );
  }
}
