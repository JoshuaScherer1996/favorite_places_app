import 'package:flutter/material.dart'; // Material Design package for Flutter UI components.
import 'package:image_picker/image_picker.dart'; // Package for picking images (e.g., from the camera).
import 'dart:io'; // Dart's IO library for file and system operations.

// A StatefulWidget for capturing and displaying an image.
class ImageInput extends StatefulWidget {
  // Constructor requiring a function to be called with the picked image file.
  const ImageInput({
    super.key, // Optional key parameter for widget identification.
    // Callback function to handle the picked image.
    required this.onPickImage,
  });

  // Callback function type definition.
  final void Function(File image) onPickImage;

  // Creates the mutable state for this widget.
  @override
  State<ImageInput> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage; // A variable to hold the selected image file.

  // Function to open the camera, let the user take a picture, and set the taken picture as the selected image.
  void _takePicture() async {
    final imagePicker = ImagePicker();
    // Specifies the camera as the source and sets a maximum width to downscale the image for performance.
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (pickedImage == null) {
      return; // If the user cancels the operation, do nothing.
    }
    setState(() {
      // Updates the UI with the new image.
      _selectedImage = File(pickedImage.path);
    });

    // Calls the callback function with the new image.
    widget.onPickImage(_selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    // Content of the widget, starts with a button allowing the user to take a picture.
    Widget content = TextButton.icon(
      onPressed: _takePicture, // Calls the _takePicture function when pressed.
      icon: const Icon(Icons.camera), // Icon for the button.
      label: const Text('Take Picture'), // Label for the button.
    );

    // If an image is selected, display it instead of the button.
    if (_selectedImage != null) {
      content = GestureDetector(
        // Allows the user to retake the picture by tapping on the image.
        onTap: _takePicture,
        child: Image.file(
          _selectedImage!, // Displays the selected image.
          fit: BoxFit.cover, // Covers the container fully with the image.
          width: double.infinity, // Uses the full width of the container.
          height: double.infinity, // Uses the full height of the container.
        ),
      );
    }

    // The main container of the widget, including its decoration and containing the content (button or image).
    return Container(
      decoration: BoxDecoration(
        // Border with some transparency.
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      height: 250, // Fixed height for the container.
      // Container width stretches to the full width of its parent.
      width: double.infinity,
      alignment: Alignment.center, // Centers the content within the container.
      // The dynamic content based on whether an image has been selected.
      child: content,
    );
  }
}
