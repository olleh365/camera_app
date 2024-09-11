import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CameraController extends GetxController {
  var imageFile = Rx<XFile?>(null);

  final ImagePicker picker = ImagePicker();

  Future<void> pickCamera() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      imageFile.value = XFile(pickedFile.path);
    }
  }
}