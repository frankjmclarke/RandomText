import 'package:flutter/material.dart';
import 'code.dart';
import 'package:text_editor/text_editor.dart';




String text2 = "";
String sourceText = """.PassageLength
random
print 1 Section
print 2 Sections
print 3 Sections

.RoomType
random
..NormalRoom
..HazardRoom
..Lair
..QuestRoom


.PassageFeatures
random
..WanderingMonsters
print Corridor is empty
..RoomType

.Lair
random
print Lair, one door
print Lair, two doors
print Lair, three doors

.RoomDoors
random
print one door
print two doors
print three doors

.HazardRoom
random
write Hazard small room with...WanderingMonsters ...RoomDoors
write Hazard small room with NPC ...RoomDoors
write Hazard small room with Chasm ...RoomDoors
write Hazard small room with Statue ...RoomDoors
write Hazard small room with Rats or Bats ...RoomDoors
write Hazard small room with Mould ...RoomDoors
write Hazard small room with Mushrooms...RoomDoors
write Hazard small room with Grate ...RoomDoors
write Hazard small room with Pool ...RoomDoors
write Hazard small room with Magic Circle ...RoomDoors
write Hazard small room with Trapdoor ...RoomDoors
write Hazard small room with Throne ...RoomDoors

.NormalRoom
random
write Normal small room with ...RoomDoors
write Normal small room with ...RoomDoors
write Normal small room with ...RoomDoors

.QuestRoom
random
write Quest room with ...RoomDoors...QuestMonsters
write Quest room with ...RoomDoors...QuestMonsters
write Quest room with ...RoomDoors...QuestMonsters

.QuestMonsters
random
print 2 Champions & 1 Warlord, 100 gc
print 6 Warriors & 2 Champions, 100 gc
print 8 Warriors & 1 Champions, 100 gc
print 4 Warriors, 1 Sentry & 1 Warlord, 120gc
print 3 Champions & 1 Warlord, 120gc
print 8 Warriors & 2 Champions, 120gc
print 2 Warriors, 2 Champions & 1 Warlord, 120gc
print 6 Warriors, 1 Sentry & 1 Warlord,140gc
print 4 Warriors, 2 Champions & 1 Warlord, 140gc 
print 8 Warriors & 3 Champions, 140gc
print 4 Champions & 1 Warlord, 140gc
print 12 Warriors, 1 Sentry & 1 Champion, 160gc

.WanderingMonsters
random
print 2 Wandering Warriors, 20 gc
print 1 Wandering Sentry, 20 gc
print 3 Wandering Warriors, 30 gc
print 1 WanderingWarrior & 1 Champion, 30gc
print 4 Wandering Warriors, 40 gc
print 2 Wandering Warriors & 1 Champion, 40gc
print 3 Wandering Warriors & 1 Sentry, 50gc
print 4 Wandering Warriors & 1 Champion, 60gc

.Main
..PassageLength
..PassageFeatures loop 2
""";

String _text=text2;
void main() {
  var myCode = new ExecuteCode();
  Map aMap = myCode.readCode(sourceText);
  String outStr = myCode.callProc(".Main", aMap);
  _text = outStr;
  int i = 0;
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


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Text',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final fonts = [
    'OpenSans',
    'Billabong',
    'GrandHotel',
    'Oswald',
    'Quicksand',
    'BeautifulPeople',
    'BeautyMountains',
    'BiteChocolate',
    'BlackberryJam',
    'BunchBlossoms',
    'CinderelaRegular',
    'Countryside',
    'Halimun',
    'LemonJelly',
    'QuiteMagicalRegular',
    'Tomatoes',
    'TropicalAsianDemoRegular',
    'VeganStyle',
  ];
  TextStyle _textStyle = TextStyle(
    fontSize: 15,
    color: Colors.white,
    fontFamily: 'Billabong',
  );



  TextAlign _textAlign = TextAlign.center;

  void _tapHandler(text, textStyle, textAlign) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(
        milliseconds: 400,
      ), // how long it takes to popup dialog after button click
      pageBuilder: (_, __, ___) {
        // your widget implementation
        return Container(
          color: Colors.black.withOpacity(0.4),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              // top: false,
              child: Container(
                child: TextEditor(
                  fonts: fonts,
                  text: text,
                  textStyle: textStyle,
                  textAlingment: textAlign,
                  // paletteColors: [
                  //   Colors.black,
                  //   Colors.white,
                  //   Colors.blue,
                  //   Colors.red,
                  //   Colors.green,
                  //   Colors.yellow,
                  //   Colors.pink,
                  //   Colors.cyanAccent,
                  // ],
                  // decoration: EditorDecoration(
                  //   doneButton: Icon(Icons.close, color: Colors.white),
                  //   fontFamily: Icon(Icons.title, color: Colors.white),
                  //   colorPalette: Icon(Icons.palette, color: Colors.white),
                  //   alignment: AlignmentDecoration(
                  //     left: Text(
                  //       'left',
                  //       style: TextStyle(color: Colors.white),
                  //     ),
                  //     center: Text(
                  //       'center',
                  //       style: TextStyle(color: Colors.white),
                  //     ),
                  //     right: Text(
                  //       'right',
                  //       style: TextStyle(color: Colors.white),
                  //     ),
                  //   ),
                  // ),
                  onEditCompleted: (style, align, text) {
                    setState(() {
                      _text = text;
                      _textStyle = style;
                      _textAlign = align;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        top: false,
        child: Center(
          child: Stack(
            children: [
              Image.asset('assets/story.png'),
              Center(
                child: GestureDetector(
                  onTap: () => _tapHandler(_text, _textStyle, _textAlign),
                  child: Text(
                    _text,
                    style: _textStyle,
                    textAlign: _textAlign,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}