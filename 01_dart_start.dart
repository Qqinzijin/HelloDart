import 'dart:io';

// 无需显式地声明变量类型
// 灵活地定义了类似于String、int、double、List、Map的变量
void variable_use() {
  var name = "Voyager I";
  var year = 1977;
  var antennaDiameter = 3.7;
  var flybyObjects = ['Jupiter', 'Saturn', 'Uranus', 'Neptune'];
  var image = {
    'tags': ['saturn'],
    'url': '//path/to/saturn.jpg'
  };
}

// 流程控制语句for、if、while
// for-in的语法和Python类似，利用目标对象的迭代器进行循环
void progress_control() {
  var year = 1977;
  var flybyObjects = ['Jupiter', 'Saturn', 'Uranus', 'Neptune'];

  for (final object in flybyObjects) {
    print(object);
  }

  if (year >= 2001) {
    print("21st century");
  } else if (year >= 1901) {
    print("20th century");
  }

  for (int month = 1; month <= 12; month++) {
    print(month);
  }

  while (year < 2016) {
    year += 1;
  }
}

//基本的函数定义，与Java类似
int fibonacci(int n) {
  if (n == 0 || n == 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

void func() {
  var flybyObjects = ['Jupiter', 'Saturn', 'Uranus', 'Neptune'];
  // 只有一条return的匿名函数的语法糖(arg)=> value to return
  flybyObjects.where((name) => name.contains("turn")).forEach(print);
}

// 类的基本定义
class Spacecraft {
  // 类变量
  String name;

  // 带问号的是允许空的类型
  DateTime? launchDate;

  // 使用get标识符简便地声明Getter方法
  int? get launchYear => launchDate?.year;

  // 定义默认构造函数，使用了类变量初始化的语法糖
  Spacecraft(this.name, this.launchDate) {}

  // 定义有名字的构造函数，使用与C++类似的调用默认构造函数的方法
  Spacecraft.unlaunched(String name) : this(name, null);

  // 定义类方法
  void describe() {
    print("Spacecraft: $name");
    var launchDate = this.launchDate;
    if (launchDate != null) {
      //运算符~/表示取整除法
      int years = DateTime.now().difference(launchDate).inDays ~/ 365;
      print("Launched: $launchYear ($years years ago)");
    } else {
      print("Unlaunched");
    }
  }
}

// 使用类的继承
class Orbiter extends Spacecraft {
  double altitude;

  // 与调用自身的默认构造函数一样，也可以调用父类的默认构造函数
  Orbiter(String name, DateTime launchDate, this.altitude)
      : super(name, launchDate);
}

// dart支持mixin的语言特性，可以简单地实现代码复用
mixin Piloted {
  int astronauts = 1;

  void describeCrew() {
    if (astronauts == 0) {
      throw StateError("No astronauts.");
    } else {
      print("Number of astronauts: $astronauts");
    }
  }

  set setAstronauts(int value) {
    this.astronauts = value;
  }
}

// 同时使用继承和mixin
class PilotedCraft extends Spacecraft with Piloted {
  PilotedCraft(String name, DateTime date) : super(name, date);
}

// 可以定义抽象类，抽象类中的方法可以没有函数体，以留给其子类实现
abstract class Describable {
  void describe();

  void describeWithEmphasis() {
    print("========");
    describe();
    print("========");
  }
}

// dart的语言特性，每个类都实现了一个隐式的接口
class MockSpaceship extends Describable implements Spacecraft {
  String name;
  DateTime? launchDate;

  int? get launchYear => launchDate?.year;

  set setDate(DateTime date){
    this.launchDate = date;
  }
  MockSpaceship(this.name) {}

  @override
  void describe() {
    print("$launchYear");
  }
}


const oneSecond = Duration(seconds: 1);

void use_extend_class() {
  Orbiter orbiter = Orbiter("Orbiter I", DateTime(2022, 3, 31), 1980.5);

  print(orbiter.launchYear);
}

void use_Spacecraft() {
  var voyager = Spacecraft("Voyager I", DateTime(1977, 9, 5));
  voyager.describe();

  var voyager3 = Spacecraft.unlaunched("Voyager III");
  voyager3.describe();
}

void use_PilotedCraft() {
  PilotedCraft pilotedCraft =
      PilotedCraft("PilotedCraft I", DateTime(2022, 3, 30));
  pilotedCraft.describeCrew();
}

void use_MockSpaceship() {
  MockSpaceship spaceship = MockSpaceship("spaceship I");
  spaceship.setDate = DateTime(2022, 3, 10);
  spaceship.describeWithEmphasis();
}

// 一个会在1秒后输出message的异步测试函数
Future<void> printWithDelay(String message) async {
  await Future.delayed(oneSecond);
  print(message);
}

Future<void> async_test() async{
  List<Future<void>> fList = [];
  for (int i = 0; i < 10; i++) {
    fList.add(printWithDelay("hello" + i.toString()));
  }
  await Future.wait(fList);
}

Future<void> sync_test() async {
  for (int i = 0; i < 10; i++) {
    await printWithDelay("hello" + i.toString());
  }
}

void test_exception() {
  PilotedCraft pilotedCraft = PilotedCraft("Pilot II", DateTime(2022, 3, 1));
  pilotedCraft.setAstronauts = 0;
  try {
    pilotedCraft.describeCrew();
  } on StateError catch (e) {
    print("Can not describe object $e");
  }
}

Future<void> test_exception2() async {
  var flybyObjects = ['Jupiter', 'Saturn', 'Uranus', 'Neptune'];
  try {
    for (final object in flybyObjects) {
      var description = await File('$object.txt').readAsString();
      print(description);
    }
  } on IOException catch (e) {
    print("Could not describe object: $e");
  } finally {
    flybyObjects.clear();
  }
}

// 双斜杠注释
/* 单斜杠加星号的注释 */
void main(List<String> args) async {
  var timeStamp;
  print("\n-----------测试fibonacci函数---------\n");
  var result = fibonacci(20);
  print(result.toString());
  print("\n------------测试变量定义-------------\n");
  variable_use();
  print("\n-----------测试流程控制函数-----------\n");
  progress_control();
  print("\n------------测试func函数------------\n");
  func();

  print("\n----------Spacecraft类测试-----------\n");
  use_Spacecraft();
  print("\n------Spacecraft的子类Orbiter测试------\n");
  use_extend_class();
  print("\n----------PilotedCraft类测试-----------\n");
  use_PilotedCraft();
  print("\n----------MockSpaceship类测试-----------\n");
  use_MockSpaceship();

  print("\n----------同步/异步对比测试------------\n");
  print("异步操作：\n");
  timeStamp = DateTime.now().millisecondsSinceEpoch;
  await async_test();
  print("异步操作用时：${DateTime.now().millisecondsSinceEpoch - timeStamp}ms\n");
  print("同步操作：\n");
  timeStamp = DateTime.now().millisecondsSinceEpoch;
  await sync_test();
  print("同步操作用时：${DateTime.now().millisecondsSinceEpoch - timeStamp}ms\n");
}