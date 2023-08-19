//@dart=2.12
import 'package:flutter/material.dart';
import 'package:tmt_photo_view/photo_slide_gallery.dart';
import 'package:tmt_photo_view/photo_view.dart';
import 'package:tmt_photo_view/photo_view_gallery.dart';
import 'package:photo_view_example/screens/examples/preview_gallery/preview_photo_dialog.dart';

// ignore: import_of_legacy_library_into_null_safe
typedef ImageProviderBuilder = ImageProvider Function(
    BuildContext context, int index);

class AppPhotoGallery extends StatelessWidget {
  const AppPhotoGallery({
    Key? key,
    required this.previewBuilder,
    required this.itemCount,
    required this.photoBuilder,
    required this.selectedPreviewBuilder,
    this.onScaleStart,
    this.onScaleEnd,
    this.previewSize = const Size.fromHeight(100),
    this.initialPage = 0,
  }) : super(key: key);

  final int itemCount;
  final Widget Function(BuildContext context, int index) previewBuilder;
  final Widget Function(BuildContext context, int index) selectedPreviewBuilder;
  final ImageProviderBuilder photoBuilder;
  final void Function(BuildContext context, ScaleStartDetails details)?
      onScaleStart;
  final void Function(BuildContext context, ScaleEndDetails details)?
      onScaleEnd;

  final Size previewSize;
  final int initialPage;

  @override
  Widget build(BuildContext context) {
    return PhotoSlideGallery.builder(
      initialPage: initialPage,
      loadingBuilder: (BuildContext context, ImageChunkEvent? event) {
        return const Center(child: LoadingIndicator());
      },
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          imageProvider: photoBuilder(context, index),
          minScale: PhotoViewComputedScale.contained,
          initialScale: PhotoViewComputedScale.contained,
          onScaleStart: (context, details, _) =>
              onScaleStart?.call(context, details),
          onScaleEnd: (context, details, _) =>
              onScaleEnd?.call(context, details),
        );
      },
      previewSize: previewSize,
      previewPadding: EdgeInsets.only(
          left: 10, bottom: MediaQuery.of(context).padding.bottom + 10),
      previewOptions: List<PhotoPreviewOptions>.generate(
        itemCount,
        (index) => PhotoPreviewOptions.customBuilder(
          selectedBuilder: selectedPreviewBuilder,
          builder: previewBuilder,
        ),
      ),
      itemCount: itemCount,
    );
  }
}
