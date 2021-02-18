import 'package:stack/stack.dart' as MyStack;
import 'dart:math';
import 'dart:io';


enum tokens { print, random, loop }

class ExecuteCode{
  MyStack.Stack<String> stack = MyStack.Stack();
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
      line = line.trimRight();
      //if (printing)
      //text2 += line;
      //print(':$line');
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

      pos++;
    }
    return symbols;
  }
  void processCode(Map symbols) {
    for (var proc in symbols.keys) {
      List codeLines = symbols[proc];
      String zeroLine = codeLines[0].toString();
      int loopCount = getLoopCount(zeroLine);
      for (int i = 0; i < loopCount; i++)
        callProc(proc, symbols);
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

  void printCode(Map symbols) {
    for (var proc in symbols.keys) {
      print("Procedure : $proc, listing : ${symbols[proc]}");
      //text2 += symbols[proc].toString();
    }
  }

  String callProc(String procName, Map symbols) {
    String outStr = "";
    List codeLines = symbols[procName];
    for (int ind = codeLines.length - 1; ind >= 0; ind--)
      stack.push(codeLines[ind]);

    while (stack.isNotEmpty) {
      String token = stack.top();
      if (token.contains("...")) {
        var tokens = token.split("..");
        stack.pop();
        for (int i = tokens.length - 1; i >= 0; i--) {
          if (tokens[i].startsWith(".")) tokens[i] = "." + tokens[i];
          stack.push(tokens[i]);
        }
        token = stack.top();
      }
      if (token.startsWith("..")) {
        if (token.contains(" loop ")) {
          var first = token.split(" ")[0];
          var last = token.split(" ");
          String countStr = last[last.length - 1];
          int loopCount = int.tryParse(countStr) ?? 1;
          stack.pop();
          for (int j = 0; j < loopCount; j++)
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
      } else {
        token = stack.pop();
        if (token.startsWith("print ")) {
          token = token.replaceFirst("print ", "");
          printIt(token);
          outStr+=token.toString()+"\n";
        }
        if (token.startsWith("write ")) {
          token = token.replaceFirst("write ", "");
          writeIt(token);
          outStr+=token.toString();
        }
      }
    }
    return outStr;
  }

  void printIt(String s) {
    print(s);
  }

  void writeIt(String s) => print(s);


  int randomIndex(int max) {
    Random random = new Random();
    int randomNumber = random.nextInt(max);
    return randomNumber;
  }
}

