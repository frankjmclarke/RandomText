import 'package:flutter/material.dart';
import 'dart:math';
import 'package:stack/stack.dart' as MyStack;

//var exec = new List();
//      ".PassageFeatures\nprint Wandering Monsters\nprint Nothing\n..RoomType\n..RoomType\nprint 3 Doors\n\n\n" +
//      ".Main\n..PassageLength\n..PassageFeatures\n..PassageEnd\n\n";
enum tokens { print, random, loop }

MyStack.Stack<String> stack = MyStack.Stack();

void main() {
  String textOld = ".PassageLength\nprint 1 Section\nprint 2 Sections\n\n" +
      ".RoomType\nprint Normal\nprint Hazard\n\n" +
      ".PassageFeatures\n..RoomType\n..RoomType\n\n" +
      ".PassageEnd\nprint T-junction\nprint Dead End\nprint Right Turn\nprint Left Turn\nprint Stairs Down\nprint Stairs Out\n\n" +
      ".Main\n..PassageLength\n";
  String text1 =
      ".PassageLength\nrandom\nprint 1 Section\nprint 2 Sections\n\n" +
          ".RoomType \nrandom\nprint Normal\nprint Hazard\n\n" +
          ".PassageFeatures\n..RoomType\n\n" +
          ".Main\n..PassageLength\n..PassageFeatures loop 2\n";
  String text = ".PassageLength\nprint 1 Section\nprint 2 Sections\n\n" +
      ".RoomType \nrandom\nprint Normal\nprint Hazard\n\n" +
      ".PassageFeatures\n..RoomType\n\n" +
      ".Main\n..PassageLength\n..PassageFeatures loop 2\n";

  String textX =
      ".PassageLength\nloop 2\nprint 1 Section\nprint 2 Sections\n\n" +
          ".RoomType \nrandom\nprint Normal\nprint Hazard\n\n" +
          ".PassageFeatures\nrandom\n..RoomType\n\n" +
          ".Main\n..PassageLength\n..PassageFeatures\n";

  Map aMap = readCode(text);

  printCode(aMap);
  //processCode(aMap);
  callProc(".Main", aMap);

  runApp(MyApp());
}

String getToken(var aToken) {
  switch (aToken) {
    case tokens.print:
      return "print";
      break;
    case tokens.random:
      return "random";
      break;
    case tokens.loop:
      return "loop";
      break;
  }
  return "";
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
    line = line.trim();
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

String symbolKey(String name) {
  int index = name.indexOf(' ');
}

void printCode(Map symbols) {
  for (var proc in symbols.keys) {
    print("Procedure : $proc, listing : ${symbols[proc]}");
  }
}

void processCode(Map symbols) {
  for (var proc in symbols.keys) {
    List codeLines = symbols[proc];
    String zeroLine = codeLines[0].toString();
    int loopCount = getLoopCount(zeroLine);
    for (int i = 0; i < loopCount; i++) callProc(proc, symbols);
  }
}

int getLoopCount(String zeroLine) {
  int result = 1;
  if (zeroLine.startsWith("loop")) {
    var last = zeroLine.split(" ");
    String countStr = last[last.length - 1];
    result = int.tryParse(countStr) ?? 1;
  }
  return result;
}

void doStack(MyStack.Stack<String> stack) {
  while (stack.isNotEmpty) {
    String token = stack.top();
    if (token.startsWith("..")) print("SS " + stack.pop());
  }
}

void callProc(String procName, Map symbols) {
  List codeLines = symbols[procName];
  for (int ind = codeLines.length - 1; ind >= 0; ind--)
    stack.push(codeLines[ind]);

  while (stack.isNotEmpty) {
    String token = stack.top();
    if (token.startsWith("..")) {
      int loopCount = 1;
      if (token.contains(" loop ")) {
        var first = token.split(" ")[0];
        var last = token.split(" ");
        String countStr = last[last.length - 1];
        loopCount = int.tryParse(countStr) ?? 1;
        stack.pop();
        for (int j=0;j<loopCount;j++)
          stack.push(first);
      }
      token = stack.pop();
      String name = token.substring(1, token.length);
      List codeLines2 = symbols[name];

      if (codeLines2[0].toString().startsWith("random")) {
        stack.push(codeLines2[1 + randomIndex(codeLines2.length - 1)]);
      } else {
        for (int ind = codeLines2.length - 1; ind >= 0; ind--) {
          stack.push(codeLines2[ind]);
        } //end for
      }
    } else //!token.startsWith("..")
      print("SS " + stack.pop());
  }
}

void callProcZ(String procName, Map symbols) {
  // test no loop

  List codeLines = symbols[procName];
  for (int ind = 0; ind < codeLines.length; ind++) stack.push(codeLines[ind]);

  while (stack.isNotEmpty) {
    //doStack(stack);
  }

  int rand = 1 + randomIndex(codeLines.length - 1); //second to last
  String codeStr;
  int codeStart = 0;
  String zeroLine = codeLines[0].toString();
  int loopCount = getLoopCount(zeroLine);

  if (zeroLine.startsWith("random"))
    codeStr = codeLines[rand];
  else
    codeStr = codeLines[1];
  if (zeroLine.startsWith("loop")) {
    var last = zeroLine.split(" ");
    String countStr = last[last.length - 1];
    loopCount = int.tryParse(countStr) ?? 1;
    codeStart = 1;
  }

  for (int j = 0; j < codeLines.length; j++) {
    //  for (int j = 0; j < loopCount; j++) {
    if (zeroLine.startsWith("random")) {
      rand = 1 + randomIndex(codeLines.length - 1); //second to last
      codeStr = codeLines[rand];
    } else
      codeStr = codeLines[1];
    if (codeStr.startsWith("print ")) {
      //print random
      codeStr = codeLines[j];

      print(codeStr.replaceFirst(getToken(tokens.print) + " ", ""));
    } else if (procName.startsWith(".")) {
      //was ..
      for (var i = codeStart; i < codeLines.length; i++) {
        codeStr = codeLines[i];
        //print("%" + codeStr);
        //if (codeStr.startsWith("Print ")) {
        //codeStr = codeLines[rand];
        // print(codeStr.replaceFirst("Print ", ""));
        //} else
        if (!codeStr.startsWith("print ") && !codeStr.startsWith("random"))
          callProc(codeStr.substring(1, codeStr.length), symbols);
      }
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
String xtext = ".Hello\nprint 1..50 1 Section\nprint 51..100 2 Sections\n.End\n\n" +
    ".Hello2\nprint 1..20 Wandering Monsters\nprint 21..40 Nothing\nprint 41..60 1 Door\nprint 61..90 2 Doors\nprint 91..100 3 Doors\n.End\n\n" +
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

void callProcOld(String procName, Map symbols) {
  List codeLines = symbols[procName];
  int rand = 1 + randomIndex(codeLines.length - 1); //second to last
  String codeStr;
  int loopCount = 0;
  if (codeLines[0].toString().startsWith("random"))
    codeStr = codeLines[rand];
  else
    codeStr = codeLines[1];
  if (codeLines[0].toString().startsWith("loop")) loopCount = 2;
  if (codeStr.startsWith("print ")) {
    //print random
    print(codeStr.replaceFirst(getToken(tokens.print) + " ", ""));
  } else if (procName.startsWith(".")) {
    //was ..
    for (var i = 0; i < codeLines.length; i++) {
      codeStr = codeLines[i];
      //print("%" + codeStr);
      //if (codeStr.startsWith("Print ")) {
      //codeStr = codeLines[rand];
      // print(codeStr.replaceFirst("Print ", ""));
      //} else
      if (!codeStr.startsWith(getToken(tokens.print) + " "))
        callProc(codeStr.substring(1, codeStr.length), symbols);
    }
  }
}

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
