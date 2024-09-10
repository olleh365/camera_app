import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

    if (status.isGranted) {
      // 카메라 접근이 허용되었을 때 카메라를 열고 사진을 찍습니다.
      await _pickCamera();
    } else if (status.isDenied) {
      // 처음 거부했을 때 다시 권한 요청
      status = await Permission.camera.request();
      if (status.isGranted) {
        await _pickCamera(); // 권한이 다시 허용되었을 때 카메라 작동
      } else if (status.isPermanentlyDenied) {
        if(context.mounted) {
          // 권한이 영구적으로 거부되었을 때 설정으로 이동하는 바텀시트 생성
          _showPermissionBottomSheet(context);
        }
      }
    } else if (status.isPermanentlyDenied) {
      if(context.mounted) {
        // 이미 영구적으로 거부된 상태일 때 설정으로 이동하는 바텀시트 생성
        _showPermissionBottomSheet(context);
      }
    }
  }

  Future<void> _pickCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(source: ImageSource.camera);

    if (imageFile != null) {
      await GallerySaver.saveImage(imageFile.path, albumName: 'MyAppAlbum');
      debugPrint('Image saved to gallery: ${imageFile.path}');
    }
  }

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
