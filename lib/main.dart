import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final double e = 0.0818191908426;
  int z = 0;
  int x = 0;
  int y = 0;
  bool isShow = false;

  late TextEditingController _latController;
  late TextEditingController _longController;
  late TextEditingController _zoomController;

  @override
  void initState() {
    super.initState();
    _latController = TextEditingController();
    _longController = TextEditingController();
    _zoomController = TextEditingController();
  }

  @override
  void dispose() {
    _latController.dispose();
    _longController.dispose();
    _zoomController.dispose();
    super.dispose();
  }

  void findTile(lat, long, zoom) {
    double myLat = double.parse(lat);
    double myLong = double.parse(long);
    int myZoom = int.parse(zoom);
    double b = (pi * myLat) / 180;
    double u = (1 - e * sin(b)) / (1 + e * sin(b));
    double o = tan(pi / 4 + b / 2) * pow(u, e / 2);
    double p = pow(2, myZoom + 8) / 2;
    double xP = p * (1 + myLong / 180);
    double yP = p * (1 - log(o) / pi);
    setState(() {
      x = xP ~/ 256;
      y = yP ~/ 256;
      z = myZoom;
      if (!isShow) isShow = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            const Text('Введите координаты'),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 400,
              child: TextField(
                  controller: _latController,
                  decoration: const InputDecoration(
                    hintText: 'Ширина',
                    border: OutlineInputBorder(),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
                  ]),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 400,
              child: TextField(
                controller: _longController,
                decoration: const InputDecoration(
                  hintText: 'Долгота',
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 400,
              child: TextField(
                controller: _zoomController,
                decoration: const InputDecoration(
                  hintText: 'Зум',
                  border: OutlineInputBorder(),
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () => findTile(_latController.text,
                    _longController.text, _zoomController.text),
                child: const Text('Рассчитать')),
            const SizedBox(
              height: 30,
            ),
            if (isShow)
              Column(children: [
                Image(
                  image: NetworkImage(
                      'https://core-carparks-renderer-lots.maps.yandex.net/maps-rdr-carparks/tiles?l=carparks&x=$x&y=$y&z=$z&scale=1&lang=ru_RU'),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text('X: $x, Y: $y'),
              ])
          ],
        ),
      ),
    );
  }
}
