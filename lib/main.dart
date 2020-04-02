// v2: add Gesture detector
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Axes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key); // changed

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController _xController;
  AnimationController _yController;
  Animation _xAnim;
  Animation _yAnim;
  double _rotateX = 1.0;
  double _rotateXSlider = 1.0;
  double _rotateY = 1.0;
  double _rotateYSlider = 1.0;

  @override
  void initState() {
    super.initState();

    _xController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));

    _yController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
  }

  @override
  Widget build(BuildContext context) {
    return _buildApp(context);
  }

  _buildApp(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Axes'), // changed
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Slider.adaptive(
                value: _rotateXSlider,
                onChanged: (double newValue) {
                  setState(() {
                    _rotateXSlider = newValue;
                    _rotateX = newValue;
                    _xController.stop();
                  });
                },
                onChangeEnd: (double newValue) {
                  _xAnim = Tween<double>(begin: newValue - 20, end: newValue)
                      .animate(CurvedAnimation(
                          parent: _xController, curve: Curves.elasticOut))
                        ..addListener(() {
                          setState(() {
                            _rotateX = _xAnim.value;
                          });
                        });
                  _xController.reset();
                  _xController.forward();
                },
                min: 1,
                max: 180,
                divisions: 180,
                label: "Rotate X",
              ),
              SizedBox(height: 20),
              Slider.adaptive(
                value: _rotateYSlider,
                onChanged: (double newValue) {
                  setState(() {
                    _rotateYSlider = newValue;
                    _rotateY = newValue;
                    _yController.stop();
                  });
                },
                onChangeEnd: (double newValue) {
                  _yAnim = Tween<double>(begin: newValue - 20, end: newValue)
                      .animate(CurvedAnimation(
                          parent: _yController, curve: Curves.elasticOut))
                        ..addListener(() {
                          setState(() {
                            _rotateY = _yAnim.value;
                          });
                        });
                  _yController.reset();
                  _yController.forward();
                },
                min: 1,
                max: 180,
                divisions: 180,
                label: "Rotate Y",
              ),
              SizedBox(height: 20),
              Transform(
                  // Transform widget
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // perspective
                    ..rotateX(0.01 * _rotateX) // changed
                    ..rotateY(-0.01 * _rotateY), // changed
                  alignment: FractionalOffset.center,
                  child: _buildCard(context))
            ],
          ),
        ));
  }

  Widget _buildCard(BuildContext context) {
    return Container(
        width: 300,
        child: Card(
          elevation: 8,
          child: Container(
            child: Column(
              children: <Widget>[
                AppBar(),
                Container(
                    height: 100,
                    child: Center(child: CircularProgressIndicator())),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 16, 16),
                      child: FloatingActionButton(
                        onPressed: () {},
                        child: Icon(Icons.add),
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}
