import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:photo_view_example/screens/common/app_bar.dart';

class PreviewGalleryExample extends StatefulWidget {
  @override
  _PreviewGalleryExampleState createState() => _PreviewGalleryExampleState();
}

class _PreviewGalleryExampleState extends State<PreviewGalleryExample> {
  final List<String> _imageUrls = [
    'https://previews.123rf.com/images/artshock/artshock1210/artshock121000046/15557821-imag-of-water-drops-on-window-and-blue-sky-background.jpg',
    'https://static8.depositphotos.com/1020341/896/i/950/depositphotos_8969502-stock-photo-human-face-with-cracked-texture.jpg',
    'https://www.imagdisplays.co.uk/wp-content/uploads/2021/04/IMG_8315-scaled-e1618243394893-1900x1216.jpg',
  ];

  void openDialog(BuildContext context) => showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
              child: Container(
            height: MediaQuery.of(context).size.height,
            child: PhotoPreviewGallery.builder(
              // pageOptions: [],
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(_imageUrls[index]));
              },
              previewOptions: _imageUrls
                  .asMap()
                  .entries
                  .map((e) => PhotoPreviewOptions(
                        imageProvider: NetworkImage(_imageUrls[e.key]),

                      ))
                  .toList(),
              itemCount: _imageUrls.length,
            ),
          ));
        },
      );

  void openBottomSheet(BuildContext context) => showBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        shape: const ContinuousRectangleBorder(),
        builder: (BuildContext context) {
          return PhotoViewGestureDetectorScope(
            axis: Axis.vertical,
            child: PhotoView(
              backgroundDecoration: BoxDecoration(
                color: Colors.black.withAlpha(240),
              ),
              imageProvider: const AssetImage("assets/large-image.jpg"),
              heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
            ),
          );
        },
      );

  void openBottomSheetModal(BuildContext context) => showModalBottomSheet(
        context: context,
        shape: const ContinuousRectangleBorder(),
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              height: 250,
              child: PhotoViewGestureDetectorScope(
                axis: Axis.vertical,
                child: PhotoView(
                  tightMode: true,
                  imageProvider: const AssetImage("assets/large-image.jpg"),
                  heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
                  scaleStateChangedCallback: (PhotoViewScaleState state) {},
                ),
              ),
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return ExampleAppBarLayout(
      title: "Dialogs integration",
      showGoBack: true,
      child: Builder(
        builder: (context) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(color: Colors.red),
            ),
            ElevatedButton(
              child: const Text("Dialog"),
              onPressed: () => openDialog(context),
            ),
            const Divider(),
            ElevatedButton(
              child: const Text("Bottom sheet"),
              onPressed: () => openBottomSheet(context),
            ),
            const Divider(),
            ElevatedButton(
              child: const Text("Bottom sheet tight mode"),
              onPressed: () => openBottomSheetModal(context),
            ),
          ],
        ),
      ),
    );
  }
}
