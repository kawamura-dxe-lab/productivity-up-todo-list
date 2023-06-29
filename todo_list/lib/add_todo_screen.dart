import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoAddPage extends StatefulWidget {
  const TodoAddPage({super.key});

  @override
  _TodoAddPageState createState() => _TodoAddPageState();
}

class _TodoAddPageState extends State<TodoAddPage> {
  String _text = '';
  final TextEditingController _date = TextEditingController();

  final tasks = {""};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Container(
        padding: const EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // テキスト入力
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'タイトル',
              ),
              // 入力されたテキストの値を受け取る
              onChanged: (String value) {
                setState(() {
                  // データを変更
                  _text = value;
                });
              },
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _date,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: '期日',
                // inputの端にカレンダーアイコンをつける
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    // デフォルトの日付を取得する
                    DateTime initDate = DateTime.now();
                    try {
                      initDate = DateFormat('yyyy/MM/dd').parse(_date.text);
                    } catch (_) {}

                    // DatePickerを表示する
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: initDate,
                      firstDate: DateTime(2016),
                      lastDate: DateTime.now().add(
                        const Duration(days: 360),
                      ),
                    );

                    // DatePickerで取得した日付を文字列に変換
                    String? formatedDate;
                    try {
                      formatedDate = DateFormat('yyyy/MM/dd').format(picked!);
                    } catch (_) {}
                    if (formatedDate != null) {
                      _date.text = formatedDate;
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop({
                    'text': _text,
                    'date': _date.text,
                  });
                },
                child: const Text('Add', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
