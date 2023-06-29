import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/add_todo_screen.dart';
import 'package:todo_list/weather_ripository.dart';

void main() {
  runApp(const MyTodoApp());
}

class MyTodoApp extends StatelessWidget {
  const MyTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // アプリ名
      title: 'Kawamura Todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodoListPage(),
    );
  }
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  // Todoリストのデータ
  List<Map<String, String>> todoList = [];
  List<bool> checkedList = [];
  List<WeatherData> weatherDataList = [];

  @override
  void initState() {
    super.initState();
    fetchWeatherDataList().then((dataList) {
      setState(() {
        weatherDataList = dataList;
      });
    });
    todoList = [];
    checkedList = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TO DO'),
      ),
      body: Column(
        children: [
          // 天気情報を表示するウィジェット
          if (weatherDataList.isNotEmpty)
            Column(
              children: [
                const Text('天気予報',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    for (int i = 0; i < 3; i++)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Text(
                                DateFormat('M/d')
                                    .format(weatherDataList[i].time),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'Max: ${weatherDataList[i].maxTemperature}°C',
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                'Min: ${weatherDataList[i].minTemperature}°C',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          const SizedBox(height: 8),
          // Todoリストを表示するウィジェット
          Expanded(
            child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(index.toString()),
                  onDismissed: (direction) {
                    setState(() {
                      todoList.removeAt(index);
                      checkedList.removeAt(index);
                    });
                  },
                  background: Container(
                    color: Colors.red,
                  ),
                  child: Card(
                    child: ListTile(
                      leading: Checkbox(
                        value: checkedList[index],
                        onChanged: (value) {
                          setState(() {
                            checkedList[index] = value!;
                          });
                        },
                      ),
                      title: Text(todoList[index]['text'].toString()),
                      subtitle: Text(todoList[index]['date'].toString()),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // "push"でタスク追加画面に遷移
          final newListText = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return const TodoAddPage();
            }),
          );
          if (newListText != null) {
            setState(() {
              // リスト追加
              todoList.add(newListText);
              checkedList.add(false);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
