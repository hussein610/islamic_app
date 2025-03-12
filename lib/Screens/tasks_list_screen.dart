import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TasksListScreen extends StatefulWidget {
  const TasksListScreen({super.key});

  @override
  State<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends State<TasksListScreen> {
  Database? database;
  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    createMyDatabase();
  }

  Future<void> createMyDatabase() async {
    try {
      String databasesPath = await getDatabasesPath();
      String dbPath = join(databasesPath, "todo_app.db");

      database = await openDatabase(
        dbPath,
        version: 2,
        onCreate: (Database db, int version) async {
          await db.execute(
            "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT NOT NULL, description TEXT NOT NULL, status TEXT NOT NULL)",
          );
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute(
              "ALTER TABLE tasks ADD COLUMN description TEXT NOT NULL DEFAULT ''",
            );
          }
        },
        onOpen: (db) {
          fetchTasks();
        },
      );
    } catch (e) {
      print("Database error: $e");
    }
  }

  Future<void> fetchTasks() async {
    if (database != null) {
      List<Map<String, dynamic>> result = await database!.query("tasks");
      setState(() {
        tasks = result;
      });
    }
  }

  Future<void> addTask(String title, String description) async {
    if (database != null) {
      await database!.insert("tasks", {
        "title": title,
        "description": description,
        "status": "قيد التنفيذ",
      });
      fetchTasks();
    }
  }

  Future<void> deleteTask(int id) async {
    if (database != null) {
      await database!.delete("tasks", where: "id = ?", whereArgs: [id]);
      fetchTasks();
    }
  }

  void showAddTaskDialog(BuildContext dialogContext) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: dialogContext,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Color(0xffE2BE7F),
          title: Text(
            "إضافة مهمة",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                textDirection: TextDirection.rtl,
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "عنوان المهمة",
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 10),
              TextField(
                textDirection: TextDirection.rtl,
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: "وصف المهمة",
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text("إلغاء", style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                addTask(titleController.text, descriptionController.text);
                Navigator.pop(ctx);
              },
              child: Text("إضافة"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("قائمة المهام"),
        backgroundColor: Color(0xffE2BE7F),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/close-up-islamic-new-year-with-quran-books.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child:
            tasks.isEmpty
                ? Center(
                  child: Text(
                    "لا توجد مهام حتى الآن",
                    style: TextStyle(
                      color: Colors.black,
                      backgroundColor: Color(0xffE2BE7F),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Color(0xffE2BE7F),
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(
                          tasks[index]['title'] ?? "بدون عنوان",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          tasks[index]['description'] ?? "بدون وصف",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(color: Colors.white70),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.black),
                          onPressed: () => deleteTask(tasks[index]['id']),
                        ),
                      ),
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffE2BE7F),
        child: Icon(Icons.add, color: Colors.black),
        onPressed: () => showAddTaskDialog(context),
      ),
    );
  }
}
