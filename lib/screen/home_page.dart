import 'package:flutter/material.dart';
import 'package:uaspmp/screen/create_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _course = [];

  final _courseBox = Hive.box('course_box');
  @override
  void initState() {
    _refreshCourse();
    super.initState();
  }

  Future<void> _deleteCourse(int courseKey) async {
    await _courseBox.delete(courseKey);
    _refreshCourse();
  }

  void _refreshCourse() async {
    final data = _courseBox.keys.map((key) {
      final item = _courseBox.get(key);
      return {
        "key": key,
        "matkul": item["matkul"],
        "kode": item["kode"],
        "jadwal": item["jadwal"],
      };
    }).toList();
    setState(() {
      _course = data.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_course.length == 0) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Course Reminder'),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Text('Empty'),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreatePage()),
              );
            },
            child: const Icon(Icons.add)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Reminder'),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
          itemCount: _course.length,
          itemBuilder: (_, index) {
            final currentCourse = _course[index];
            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(currentCourse['matkul']),
                trailing: IconButton(
                  onPressed: () {
                    _deleteCourse(currentCourse['key']);
                  },
                  icon: const Icon(Icons.delete),
                  color: Colors.redAccent,
                ),
                subtitle: Column(
                  children: [
                    Row(
                      children: [
                        Text(currentCourse['kode']),
                      ],
                    ),
                    Row(
                      children: [
                        Text(currentCourse['jadwal']),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreatePage()),
            );
          },
          child: const Icon(Icons.add)),
    );
  }
}