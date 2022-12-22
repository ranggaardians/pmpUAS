import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uaspmp/main.dart';
import 'package:uaspmp/screen/home_page.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController matKulController = TextEditingController();
  TextEditingController kodeMatKulController = TextEditingController();
  TextEditingController jadwalKuliahController = TextEditingController();

  List<Map<String, dynamic>> _course = [];

  final _courseBox = Hive.box('course_box');

  void _refreshCourse() {
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

  Future<void> _createCourse(Map<String, dynamic> newCourse) async {
    await _courseBox.add(newCourse);
    _refreshCourse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Course Reminder'),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back))),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Masukkan Mata Kuliah')),
                TextField(
                  controller: matKulController,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Kode Mata Kuliah')),
                TextField(
                  controller: kodeMatKulController,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Jadwal Kuliah')),
                TextField(
                  controller: jadwalKuliahController,
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                _createCourse({
                  "matkul": matKulController.text,
                  "kode": kodeMatKulController.text,
                  "jadwal": jadwalKuliahController.text,
                });

                matKulController.text = '';
                kodeMatKulController.text = '';
                jadwalKuliahController.text = '';

                _refreshCourse();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyHomePage()));
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50), // NEW
              ),
              child: const Text('Add'),
            )
          ],
        ),
      ),
    );
  }
}