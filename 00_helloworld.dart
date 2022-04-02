//导入,访问其他库中的API
//https://dart.cn/samples#imports
// Importing core libraries
import 'dart:io';
import 'dart:math';//导入的包并未被使用,会警告但不会报错

// Importing libraries from external packages
import 'package:test/test.dart';

// Importing files
import 'path/to/my_other file.dart';
//变量的声明
//https://dart.cn/samples#variables
var name = 'Voyager I';
var year = 1977;
var antennaDiameter = 3.7;
var flybyObjects = ['Jupiter', 'Saturn', 'Uranus', 'Neptune'];
var image = {
  'tags': ['saturn'],
  'url': '//path/to/saturn.jpg'
};
//流程控制语句
//https://dart.cn/samples#control-flow-statements
void kongzhi() {
  if (year >= 2001) {
    print('21st century');
  } else if (year >= 1901) {
    print('20th century');
  }

  for (final object in flybyObjects) {
    print(object);
  }

  for (int month = 1; month <= 12; month++) {
    print(month);
  }

  while (year < 2016) {
    year += 1;
  }
}

//函数定义
//https://dart.cn/samples#functions
int fibonacci(int n) {
  if (n == 0 || n == 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

/// 这是一个文档注释。
/// 文档注释用于为库、类以及类的成员添加注释。
/// 像 IDE 和 dartdoc 这样的工具可以专门处理文档注释。

/* 也可以像这样使用单斜杠和星号的注释方式 */
//类,下面是一个包含三个属性、两个构造函数以及一个方法的类。其中一个属性不能直接赋值，因此它被定义为一个 getter 方法（而不是变量）
//https://dart.cn/samples#classes
class Spacecraft {
  String? name;
  DateTime? launchDate;

  // Read-only non-final property
  int? get launchYear => launchDate?.year;

  // Constructor, with syntactic sugar for assignment to members.
  Spacecraft(this.name, this.launchDate) {
    // Initialization code goes here.
  }

  // Named constructor that forwards to the default one.
  Spacecraft.unlaunched(String name) : this(name, null);

  // Method.
  void describe() {
    print('Spacecraft: $name');
    // Type promotion doesn't work on getters.
    var launchDate = this.launchDate;
    if (launchDate != null) {
      int years = DateTime.now().difference(launchDate).inDays ~/ 365;
      print('Launched: $launchYear ($years years ago)');
    } else {
      print('Unlaunched');
    }
  }
}

//下面是拓展类(继承)
//https://dart.cn/samples#inheritance
class Orbiter extends Spacecraft {
  double altitude;

  Orbiter(String name, DateTime launchDate, this.altitude)
      : super(name, launchDate);
}
//Mixin 是一种在多个类层次结构中重用代码的方法。下面的是声明一个 Mixin 的做法：
//https://dart.cn/samples#mixins
mixin Piloted {
  int astronauts = 1;

  void describeCrew() {
    print('Number of astronauts: $astronauts');
  }
}
//现在你只需使用 Mixin 的方式继承这个类就可将该类中的功能添加给其它类。
class PilotedCraft extends Spacecraft with Piloted {
  // ···
  int altitude;
  PilotedCraft(String name, DateTime launchDate, this.altitude)
      : super(name, launchDate);
}
//接口和抽象类,Dart 没有 interface 关键字。相反，所有的类都隐式定义了一个接口。因此，任意类都可以作为接口被实现。
//https://dart.cn/samples#interfaces-and-abstract-classes
class MockSpaceship implements Spacecraft {
  // ···
  String? name;
  //String get name=>' ';
  DateTime? launchDate;
  int? get launchYear => launchDate?.year;
  void describe(){}

 }
//你可以创建一个被任意具体类扩展（或实现）的抽象类。抽象类可以包含抽象方法（不含方法体的方法）。
abstract class Describable {
  void describe();

  void describeWithEmphasis() {//任意一个扩展了 Describable 的类都拥有 describeWithEmphasis() 方法，这个方法又会去调用实现类中实现的 describe() 方法。
    print('=========');
    describe();
    print('=========');
  }
}
//异步,使用 async 和 await 关键字可以让你避免回调地狱（Callback Hell）并使你的代码更具可读性。
//https://dart.cn/samples#async
const oneSecond = Duration(seconds: 1);
// ···
Future<void> printWithDelay(String message) async {
  await Future.delayed(oneSecond);
  print(message);
}
/*上面的方法相当于：

Future<void> printWithDelay(String message) {
  return Future.delayed(oneSecond).then((_) {
    print(message);
  });
}*/
//如下一个示例所示，async 和 await 关键字有助于使异步代码变得易于阅读。
Future<void> createDescriptions(Iterable<String> objects) async {
  for (final object in objects) {
    try {
      var file = File('$object.txt');
      if (await file.exists()) {
        var modified = await file.lastModified();
        print(
            'File for $object already exists. It was modified on $modified.');
        continue;
      }
      await file.create();
      await file.writeAsString('Start describing $object in this file.');
    } on IOException catch (e) {
      print('Cannot create description for $object: $e');
    }
  }
}
//你也可以使用 async* 关键字，其可以为你提供一个可读性更好的方式去生成 Stream。
Stream<String> report(Spacecraft craft, Iterable<String> objects) async* {
  for (final object in objects) {
    await Future.delayed(oneSecond);
    yield '${craft.name} flies by $object';
  }
}
//异常,使用 throw 关键字抛出一个异常：
//https://dart.cn/samples#exceptions
class except with Piloted{
 Future<void> excepts() async {
if (astronauts == 0) {
  throw StateError('No astronauts.');
}
//使用 try 语句配合 on 或 catch（两者也可同时使用）关键字来捕获一个异常:
try {
  for (final object in flybyObjects) {
    var description = await File('$object.txt').readAsString();
    print(description);
  }
// ignore: nullable_type_in_catch_clause
} on IOException catch (e) {
  print('Could not describe object: $e');
} finally {
  flybyObjects.clear();
}
  }
}
//注意上述代码是异步的；同步代码以及异步函数中得代码都可以使用 try 捕获异常。
void main(List<String> args) {
  print('hello world');
  print('name: $name,year: $year');
  kongzhi();
  var result = fibonacci(20);
  print('result: $result');
  //可以像下面这样使用 Spacecraft 类
  var voyager = Spacecraft('Voyager I', DateTime(1977, 9, 5));
  voyager.describe();

  var voyager3 = Spacecraft.unlaunched('Voyager III');
  voyager3.describe();
}