import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/circleanimation.dart';
import 'package:flutter_app/emdrbottom.dart';
import 'package:flutter_app/infinity.dart';
import 'package:flutter_app/music.dart';
import 'package:flutter_app/path.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'line.dart';

var xMax = 0.0;
Color color = Color(0xFFba343c);
int time = 700;
Widget ballWidget = Container();
double top = 170;

class EMDR extends StatefulWidget {
  const EMDR({Key? key}) : super(key: key);

  @override
  _EMDRState createState() => _EMDRState();
}

class _EMDRState extends State<EMDR> with TickerProviderStateMixin {
  late AnimationController _animationController;
  File _image = File("");
  File _ball = File("");
  final picker = ImagePicker();
  int active = 2;
  int colorAct = 0;
  late CustomPainter ballAniWidget;
  bool isImageLoaded = false;
  late ui.Image image;
  bool fullScreen = false;
  int topSize = 5;
  int bottomSize = 5;
  bool _start = false;

  List<Color> boxColor = [
    Color(0xFF9ea1b4),
    Color(0xFF9ea1b4),
    Color(0xFF9ea1b4),
    Color(0xFF9ea1b4),
    Color(0xFF9ea1b4)
  ];
  List<Color> modeBoxColor = [
    Color(0xFF9ea1b4),
    Color(0xFF9ea1b4),
    Color(0xFF9ea1b4),
    Color(0xFF9ea1b4),
  ];
  List<Color> colorBorder = [
    Color(0xFFba343c),
    Color(0XFFba853c),
    Color(0XFFb8b23b),
    Color(0XFF54b23b),
    Color(0XFF5886ba),
    Color(0XFF4d4863),
    Color(0XFF8c6ba1),
  ];

  IconData screen = FontAwesomeIcons.expand;
  bool speedCheck = false;
  bool zeroCheck = false;
  late Widget paint;

  int mode = 0;
  double circleRadius = 20;
  @override
  void initState() {
    setImage();
    setBall();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (fullScreen) {
      top = MediaQuery.of(context).size.height / 2 - 80;
    } else {
      top = MediaQuery.of(context).size.height / 4 - 20;
    }

    xMax = MediaQuery.of(context).size.width - 60;
    boxColor = [
      Color(0xFF9ea1b4),
      Color(0xFF9ea1b4),
      Color(0xFF9ea1b4),
      Color(0xFF9ea1b4),
      Color(0xFF9ea1b4)
    ];
    modeBoxColor = [
      Color(0xFF9ea1b4),
      Color(0xFF9ea1b4),
      Color(0xFF9ea1b4),
      Color(0xFF9ea1b4),
    ];
    colorBorder = [
      Color(0xFFba343c),
      Color(0XFFba853c),
      Color(0XFFb8b23b),
      Color(0XFF54b23b),
      Color(0XFF5886ba),
      Color(0XFF4d4863),
      Color(0XFF8c6ba1),
    ];
    colorBorder[colorAct] = Colors.white;
    modeBoxColor[mode] = Color(0xFF26283a);
    boxColor[active] = Color(0xFF26283a);
    circleRadius = MediaQuery.of(context).size.width / 17;

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: time),
    );
    modeCheck();
    _animationController.forward();
    _animationController.repeat(reverse: true);

    return Scaffold(
      backgroundColor: Color(0xFF14242e),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(_image),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: topSize,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0x66999999),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white),
                      ),
                      child: Stack(
                        children: [
                          paint,
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                onPressed: () {
                                  modeChange();
                                  setState(() {
                                    if (fullScreen) {
                                      fullScreen = false;
                                      topSize = 5;
                                      bottomSize = 5;
                                      screen = FontAwesomeIcons.expand;
                                    } else {
                                      fullScreen = true;
                                      topSize = 10;
                                      bottomSize = 0;
                                      screen = FontAwesomeIcons.compress;
                                    }
                                  });
                                },
                                icon: Icon(
                                  screen,
                                  color: Colors.white,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.indigo[900],
                  height: 10,
                ),
                Expanded(
                  flex: bottomSize,
                  child: EMDRControl(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void modeCheck() {
    if (_start) {
      if (mode == 0) {
        //paint = _buildImage();
        if (speedCheck) {
          Future.delayed(const Duration(milliseconds: 1), () {
            setState(() {
              mode++;
              speedCheck = false;
            });
          });
        }
        paint = Line();
      } else if (mode == 1) {
        if (zeroCheck) {
          Future.delayed(const Duration(milliseconds: 10), () {
            setState(() {
              mode--;
              zeroCheck = false;
            });
          });
        }
        if (speedCheck) {
          Future.delayed(const Duration(milliseconds: 10), () {
            setState(() {
              mode++;
              speedCheck = false;
            });
          });
        }
        paint = SampleAnimation();
      } else if (mode == 2) {
        if (speedCheck) {
          Future.delayed(const Duration(milliseconds: 10), () {
            setState(() {
              mode++;
              speedCheck = false;
            });
          });
        }
        paint = CircleAnimation();
      } else if (mode == 3) {
        paint = Infinity();
      }
    } else {
      paint = Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: top,
              left: MediaQuery.of(context).size.width / 2 - 20,
              child: Container(
                decoration: BoxDecoration(
                    color: color, borderRadius: BorderRadius.circular(30)),
                width: 30,
                height: 30,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: ballWidget,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _update(bool ch) {
    setState(() => _start = !_start);
  }

  // ignore: non_constant_identifier_names
  Container EMDRControl() {
    // if (fullScreen) {
    //   return Container();
    // } else {
    bool vi = true;
    if (fullScreen) vi = false;
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Color(0x88999999)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            EMDRBottom(
              update: _update,
            ),
            Container(
              child: Visibility(
                visible: vi,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: boxColor[0],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                height: 30,
                                width: 30,
                                alignment: Alignment.center,
                                child: Text(
                                  "S1",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              onTap: () {
                                speedChange(2000, 0);
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: boxColor[1],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                height: 30,
                                width: 30,
                                alignment: Alignment.center,
                                child: Text(
                                  "S2",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              onTap: () {
                                speedChange(1400, 1);
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: boxColor[2],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                height: 30,
                                width: 30,
                                alignment: Alignment.center,
                                child: Text(
                                  "S3",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              onTap: () {
                                speedChange(700, 2);
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: boxColor[3],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                height: 30,
                                width: 30,
                                alignment: Alignment.center,
                                child: Text(
                                  "S4",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              onTap: () {
                                speedChange(500, 3);
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: boxColor[4],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                height: 30,
                                width: 30,
                                alignment: Alignment.center,
                                child: Text(
                                  "S5",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              onTap: () {
                                speedChange(300, 4);
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: modeBoxColor[0],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: 30,
                                  width: 35,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    CupertinoIcons.resize_h,
                                    color: Colors.white,
                                  )),
                              onTap: () {
                                if (_start) {
                                  setState(() {
                                    mode = 0;
                                  });
                                }
                              },
                            ),
                            VerticalDivider(
                              color: Colors.white12,
                              width: 5,
                            ),
                            GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: modeBoxColor[1],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                height: 30,
                                width: 35,
                                alignment: Alignment.center,
                                child: Icon(
                                  CupertinoIcons.chevron_compact_down,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () {
                                if (_start) {
                                  setState(() {
                                    mode = 1;
                                  });
                                }
                              },
                            ),
                            VerticalDivider(
                              color: Colors.white12,
                              width: 5,
                            ),
                            GestureDetector(
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: modeBoxColor[2],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: 30,
                                  width: 35,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    CupertinoIcons.circle,
                                    color: Colors.white,
                                  )),
                              onTap: () {
                                if (_start) {
                                  setState(() {
                                    mode = 2;
                                  });
                                }
                              },
                            ),
                            VerticalDivider(
                              color: Colors.white10,
                              width: 5,
                            ),
                            GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: modeBoxColor[3],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                height: 30,
                                width: 35,
                                alignment: Alignment.center,
                                child: Icon(
                                  CupertinoIcons.infinite,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () {
                                if (_start) {
                                  setState(() {
                                    mode = 3;
                                  });
                                }
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.white10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            colorChange(Color(0xFFba343c), 0);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xFFba343c),
                                borderRadius:
                                    BorderRadius.circular(circleRadius),
                                border: Border.all(
                                  color: colorBorder[0],
                                )),
                            height: circleRadius,
                            width: circleRadius,
                          ),
                        ),
                        VerticalDivider(),
                        GestureDetector(
                          onTap: () {
                            colorChange(Color(0XFFba853c), 1);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0XFFba853c),
                                borderRadius:
                                    BorderRadius.circular(circleRadius),
                                border: Border.all(
                                  color: colorBorder[1],
                                )),
                            height: circleRadius,
                            width: circleRadius,
                          ),
                        ),
                        VerticalDivider(),
                        GestureDetector(
                          onTap: () {
                            colorChange(Color(0XFFb8b23b), 2);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0XFFb8b23b),
                                borderRadius:
                                    BorderRadius.circular(circleRadius),
                                border: Border.all(
                                  color: colorBorder[2],
                                )),
                            height: circleRadius,
                            width: circleRadius,
                          ),
                        ),
                        VerticalDivider(),
                        GestureDetector(
                          onTap: () {
                            colorChange(Color(0XFF54b23b), 3);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0XFF54b23b),
                                borderRadius:
                                    BorderRadius.circular(circleRadius),
                                border: Border.all(
                                  color: colorBorder[3],
                                )),
                            height: circleRadius,
                            width: circleRadius,
                          ),
                        ),
                        VerticalDivider(),
                        GestureDetector(
                          onTap: () {
                            colorChange(Color(0XFF5886ba), 4);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0XFF5886ba),
                                borderRadius:
                                    BorderRadius.circular(circleRadius),
                                border: Border.all(
                                  color: colorBorder[4],
                                )),
                            height: circleRadius,
                            width: circleRadius,
                          ),
                        ),
                        VerticalDivider(),
                        GestureDetector(
                          onTap: () {
                            colorChange(Color(0XFF4d4863), 5);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0XFF4d4863),
                                borderRadius:
                                    BorderRadius.circular(circleRadius),
                                border: Border.all(
                                  color: colorBorder[5],
                                )),
                            height: circleRadius,
                            width: circleRadius,
                          ),
                        ),
                        VerticalDivider(),
                        GestureDetector(
                          onTap: () {
                            colorChange(Color(0XFF8c6ba1), 6);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0XFF8c6ba1),
                                borderRadius:
                                    BorderRadius.circular(circleRadius),
                                border: Border.all(
                                  color: colorBorder[6],
                                )),
                            height: circleRadius,
                            width: circleRadius,
                          ),
                        ),
                        VerticalDivider(),
                      ],
                    ),
                    Divider(
                      color: Colors.white12,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.defaultDialog(
                            title: "이미지 선택",
                            content: Column(
                              children: [
                                RaisedButton(
                                  onPressed: getImage,
                                  child: Text("배경 이미지"),
                                ),
                                RaisedButton(
                                  onPressed: getBall,
                                  child: Text("볼 이미지"),
                                )
                              ],
                            ),
                            textCancel: "닫기",
                            buttonColor: Colors.white,
                            cancelTextColor: Colors.black);
                      },
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.camera_fill,
                            color: Colors.white54,
                            size: 25,
                          ),
                          VerticalDivider(
                            color: Colors.white12,
                            width: 10,
                          ),
                          Text(
                            "배경과 볼을 원하는 이미지로 업로드 할 수 있습니다.",
                            style: TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.white70,
                      height: 5,
                    ),
                    Music(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    //}
  }

  void colorChange(Color _color, int act) {
    if (_start) {
      setState(() {
        color = _color;
        colorAct = act;
        ballWidget = Container();
        removeBall();
      });
    }
  }

  void speedChange(int _time, int _active) {
    if (_start) {
      modeChange();
      setState(() {
        time = _time;
        active = _active;
      });
    }
  }

  void modeChange() {
    if (mode > 0) {
      mode--;
      speedCheck = true;
    } else {
      mode++;
      zeroCheck = true;
    }
  }

  Future setImage() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = appDocDir.path;
    File mainImage = File('$path/background.png');

    setState(() {
      _image = mainImage;
    });
  }

  Future getImage() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = appDocDir.path;

    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        // Get.snackbar(
        //   "배경 이미지",
        //   "저장되었습니다.",
        //   snackPosition: SnackPosition.BOTTOM,
        // );
      } else {
        print('No image selected.');
      }
    });

    final File newImage = await _image.copy('$path/background.png');
  }

  Future setBall() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = appDocDir.path;
    //final ByteData data = await rootBundle.load('$path/ball.png');
    //image = await loadImage(new Uint8List.view(data.buffer));
    File mainImage = File('$path/ball.png');
    print(mainImage);

    setState(() {
      _ball = mainImage;
      ballWidget = CircleAvatar(
        backgroundColor: color,
        radius: 30,
        backgroundImage: FileImage(_ball),
      );
    });
  }

  Future getBall() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = appDocDir.path;

    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _ball = File(pickedFile.path);
        ballWidget = CircleAvatar(
          radius: 25,
          backgroundColor: color,
          backgroundImage: FileImage(_ball),
        );
        // Get.snackbar(
        //   "공 이미지",
        //   "저장되었습니다.",
        //   snackPosition: SnackPosition.BOTTOM,
        // );
      } else {
        print('No image selected.');
      }
    });

    final File newImage = await _ball.copy('$path/ball.png');
  }

  Future removeBall() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = appDocDir.path;
    if (await File('$path/ball.png').exists()) {
      await File('$path/ball.png').delete();
    }
    print("remove");
  }
}
