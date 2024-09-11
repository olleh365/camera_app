import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'camera_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final CameraController cameraController = Get.put(CameraController());
  File? selectedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 450,
                  width: 350,
                  color: Color(0xFFF1F1F1),
                  child: Obx(()=>
                    cameraController.imageFile.value != null
                        ? Image.file(
                      selectedImage = File(cameraController.imageFile.value!.path),
                      fit: BoxFit.fill,
                    )
                        : const Center(
                      child: Text('adf'),
                    )
                  )
                ),
                const SizedBox(height: 8),
                const Text(
                  '하단 카메라 버튼을 눌러주세요',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
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
                      onPressed: () async {
                        await _handleCameraPermission(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleCameraPermission(BuildContext context) async {
    PermissionStatus status = await Permission.camera.status;
    debugPrint('Initial camera permission status: $status');

    if (status.isGranted) {
      debugPrint('Camera permission granted.');
      await cameraController.pickCamera();
    } else if (status.isDenied || status.isRestricted || status.isLimited || status.isPermanentlyDenied) {
      // 권한이 제한된 상태 또는 거부된 경우
      debugPrint('Requesting camera permission...');
      status = await Permission.camera.request();
      debugPrint('New camera permission status: $status');
      if (status.isGranted) {
        await cameraController.pickCamera();
      } else if (status.isPermanentlyDenied) {
        if(context.mounted) {
          _showPermissionBottomSheet(context);
        }
      }
    }
  }

  // 사진 저장 기능
  // Future<void> _pickCamera() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? imageFile = await picker.pickImage(source: ImageSource.camera);
  //
  //   if (imageFile != null) {
  //     await GallerySaver.saveImage(imageFile.path, albumName: 'MyAppAlbum');
  //     debugPrint('Image saved to gallery: ${imageFile.path}');
  //   }
  // }

  void _showPermissionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          width: double.infinity,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '카메라 권한이 필요합니다.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  openAppSettings(); // 기기 설정으로 이동
                },
                child: const Text('기기에서 설정'),
              ),
            ],
          ),
        );
      },
    );
  }
}
