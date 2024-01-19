import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String modelUrl =
      'https://firebasestorage.googleapis.com/v0/b/armodel-c48be.appspot.com/o/transformed_1704807201643.glb?alt=media&token=4461f7c7-a2f9-4989-bcd1-d827d78a71d3'; // Replace with the actual URL of your 3D model
  final String cacheBox = 'model_cache';

  late Future<void> _modelLoading;

  @override
  void initState() {
    super.initState();
    _modelLoading = _loadModel();
  }

  Future<void> _loadModel() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    final box = await Hive.openBox(cacheBox);

    // Check if the model is already cached
    if (box.containsKey(modelUrl)) {
      return;
    }

    // Simulating a delay for model loading
    await Future.delayed(Duration(seconds: 3));

    // Store the model in the local cache
    box.put(modelUrl, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: _modelLoading,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ModelViewer(
                src: modelUrl,
                alt: "A 3D model",
                autoPlay: true,
                autoRotate: false,
                cameraControls: true,
              );
            } else {
              // While the model is loading, you can show a loading indicator or button
              return CircularProgressIndicator(); // Change to your preferred loading widget
            }
          },
        ),
      ),
    );
  }
}
