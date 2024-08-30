import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:camera_avfoundation/camera_avfoundation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('하단 카메라 버튼을 눌러주세요',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                  const SizedBox(height: 8),
                  Material(
                      child: Ink(
                        decoration: const ShapeDecoration(
                          color: Colors.lightBlue,
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt_rounded),
                          color: Colors.white,
                          onPressed: () async{
                            await _pickCamera();
                          },
                        ),
                      )
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _pickCamera() async{
  final ImagePicker picker = ImagePicker();
  final XFile? imageFile = await picker.pickImage(source: ImageSource.camera);
  if (imageFile != null){
    await GallerySaver.saveImage(imageFile.path, albumName: 'MyAppAlbum');
  }
}