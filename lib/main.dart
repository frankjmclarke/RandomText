import 'package:flutter/material.dart';
import 'dart:math';

//var exec = new List();
//      ".PassageFeatures\nPrint Wandering Monsters\nPrint Nothing\n..RoomType\n..RoomType\nPrint 3 Doors\n\n\n" +
void main() {
  String textOld = ".PassageLength\nPrint 1 Section\nPrint 2 Sections\n\n" +
      ".RoomType\nPrint Normal\nPrint Hazard\n\n" +
      ".PassageFeatures\n..RoomType\n..RoomType\n\n" +
      ".PassageEnd\nPrint T-junction\nPrint Dead End\nPrint Right Turn\nPrint Left Turn\nPrint Stairs Down\nPrint Stairs Out\n\n" +
      ".Main\n..PassageLength\n..PassageFeatures\n..PassageEnd\n\n";
  String text = ".PassageLength Random\nPrint 1 Section\nPrint 2 Sections\n\n" +
      ".RoomType Random\nPrint Normal\nPrint Hazard\n\n" +
      ".PassageFeatures Loop 3\n..RoomType\n\n" +
      ".Main\n..PassageLength\n..PassageFeatures\n";

  Map aMap = readCode(text);

  printCode(aMap);
  //processCode(aMap);
  callProc(".Main", aMap);

  runApp(MyApp());
}

void runCode(Map exec, Map list) {}

Map readCode(String text) {
  int pos = 0;
  bool defining = false;
  var symbols = new Map();
  var codeLine = new List();

  String line;
  while (pos < text.length) {
    //read entire file
    line = "";
    while (text[pos] != "\n") {
      //read one line
      line += text[pos];
      pos++;
    }
    print(':$line');
    if (line.length > 1 && line[0] == "." && line[1] != ".") {
      //new definition
      defining = true;
      codeLine = new List();
      symbols[line] = codeLine;
    } else if (defining && line.length > 0) {
      // new line of code
      codeLine.add(line);
    }
    if (line.length < 3) {
      defining = false;
    }

    if (!defining && line.startsWith("..")) {
      //exec.add(line);
    }

    pos++;
  }
  return symbols;
}

void printCode(Map symbols) {
  for (var proc in symbols.keys) {
    print("Procedure : $proc, listing : ${symbols[proc]}");
  }
}

void processCode(Map symbols) {
  for (var proc in symbols.keys) {
    callProc(proc, symbols);
  }
}

void callProc(String procName, Map symbols) {
  List codeLines = symbols[procName];
  int rand = randomIndex(codeLines.length);
  String codeStr = codeLines[rand];
  if (codeStr.startsWith("Print ")) { //print random
    //codeStr = codeLines[rand];
    print(codeStr.replaceFirst("Print ", ""));
  } else if (procName.startsWith(".")) { //was ..
    for (var i = 0; i < codeLines.length; i++) {

      codeStr = codeLines[i];
      //print("%" + codeStr);
      //if (codeStr.startsWith("Print ")) {
        //codeStr = codeLines[rand];
       // print(codeStr.replaceFirst("Print ", ""));
      //} else
      if (!codeStr.startsWith("Print "))
      callProc(codeStr.substring(1, codeStr.length), symbols);
    }
  }
}

int randomIndex(int max) {
  Random random = new Random();
  int randomNumber = random.nextInt(max);
  return randomNumber;
}

bool _isEditingText = false;
TextEditingController _editingController;
String xtext = ".Hello\nPrint 1..50 1 Section\nPrint 51..100 2 Sections\n.End\n\n" +
    ".Hello2\nPrint 1..20 Wandering Monsters\nPrint 21..40 Nothing\nPrint 41..60 1 Door\nPrint 61..90 2 Doors\nPrint 91..100 3 Doors\n.End\n\n" +
    ".BigHello\n..Hello1\n..Hello2\n.End\n";

/*
 File data= new File("../winequality-red.csv");
  data.readAsLines().then(processLines)
  .catchError((e) => handleError(e));

    final filename = 'outString.txt';
  new File(filename).writeAsString('Dart is an elegant language').then((File file) {
  // do something with the file.
});
 */

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            _editTitleTextField(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _editTitleTextField() {
    if (_isEditingText)
      return Center(
        child: TextField(
          onSubmitted: (newValue) {
            setState(() {
              xtext = newValue;
              _isEditingText = false;
            });
          },
          autofocus: true,
          controller: _editingController,
        ),
      );
    return InkWell(
        onTap: () {
          setState(() {
            _isEditingText = true;
          });
        },
        child: Text(
          xtext,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
        ));
  }
}
