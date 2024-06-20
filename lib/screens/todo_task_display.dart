import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kaam_test/screens/todo_model.dart';

class TodoTaskDisplay extends StatelessWidget {
  final TodoModel todoModel;
  const TodoTaskDisplay({super.key, required this.todoModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.cancel_outlined),

            Text(
              todoModel.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              todoModel.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.yMMMd().format(DateTime.parse(todoModel.date)),
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  todoModel.status,
                  style: TextStyle(fontSize: 14, color: todoModel.status == '3'? Colors.green : Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
