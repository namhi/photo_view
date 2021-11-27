import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:photo_view_example/screens/common/app_bar.dart';
import 'package:photo_view_example/screens/examples/preview_gallery/preview_photo_dialog.dart';

class PreviewGalleryExample extends StatefulWidget {
  @override
  _PreviewGalleryExampleState createState() => _PreviewGalleryExampleState();
}

class _PreviewGalleryExampleState extends State<PreviewGalleryExample> {
  final List<String> _imageUrls = [
    'https://previews.123rf.com/images/artshock/artshock1210/artshock121000046/15557821-imag-of-water-drops-on-window-and-blue-sky-background.jpg',
    'https://static8.depositphotos.com/1020341/896/i/950/depositphotos_8969502-stock-photo-human-face-with-cracked-texture.jpg',
    'https://www.imagdisplays.co.uk/wp-content/uploads/2021/04/IMG_8315-scaled-e1618243394893-1900x1216.jpg',
    'https://statics.tpos.vn/images/tmt25/210526/090059_product_image_picker7087741224206715181.jpg',
    'https://statics.tpos.vn/images/tmt25/210526/090059_product_image_picker7087741224206715181.jpg',
    'https://statics.tpos.vn/images/tmt25/210526/090059_product_image_picker7087741224206715181.jpg',
];
  void openDialog(BuildContext context) => showNetworkPhotoGalleryDialog(
      imageUrls: _imageUrls,
      context: context,
      initialPage: 0
  );

  // void openDialog(BuildContext context) => showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Dialog(
  //             insetPadding: EdgeInsets.zero,
  //             child: Container(
  //               color: Colors.black,
  //               height: MediaQuery.of(context).size.height,
  //               child: PhotoPreviewGallery.builder(
  //                 builder: (BuildContext context, int index) {
  //                   return PhotoViewGalleryPageOptions(
  //                     imageProvider: NetworkImage(_imageUrls[index]),
  //                     minScale: PhotoViewComputedScale.contained,
  //                     initialScale: PhotoViewComputedScale.contained,
  //                   );
  //                 },
  //                 previewOptions: _imageUrls
  //                     .asMap()
  //                     .entries
  //                     .map((e) => PhotoPreviewOptions.customBuilder(
  //                           selectedBuilder: (BuildContext context, int index) {
  //                             return Container(
  //                               width: 100,
  //                               height: 100,
  //                               decoration: BoxDecoration(
  //                                 borderRadius: const BorderRadius.all(
  //                                     Radius.circular(8)),
  //                                 border: Border.all(color: Colors.white),
  //                                 image: DecorationImage(
  //                                     image: NetworkImage(_imageUrls[index]),
  //                                     fit: BoxFit.cover,
  //                                     alignment: Alignment.center),
  //                                 color: Colors.white,
  //                               ),
  //                             );
  //                           },
  //                           builder: (BuildContext context, int index) {
  //                             return Container(
  //                               width: 100,
  //                               height: 100,
  //                               child: Stack(
  //                                 children: [
  //                                   Container(
  //                                     decoration: BoxDecoration(
  //                                       borderRadius: const BorderRadius.all(
  //                                           Radius.circular(8)),
  //                                       // border: Border.all(color: Colors.white),
  //                                       image: DecorationImage(
  //                                           image:
  //                                               NetworkImage(_imageUrls[index]),
  //                                           fit: BoxFit.cover,
  //                                           alignment: Alignment.center),
  //                                       color: Colors.white,
  //                                     ),
  //                                   ),
  //                                   Container(
  //                                     decoration: BoxDecoration(
  //                                       borderRadius: const BorderRadius.all(
  //                                           Radius.circular(8)),
  //                                       color: Colors.black.withAlpha(150),
  //                                     ),
  //                                   )
  //                                 ],
  //                               ),
  //                             );
  //                           },
  //                         ))
  //                     .toList(),
  //                 itemCount: _imageUrls.length,
  //               ),
  //             ));
  //       },
  //     );

  void openCustomDialog(BuildContext context) {
    showCustomDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            insetPadding: EdgeInsets.zero,
            child: Container(
              color: Colors.black,
              height: MediaQuery.of(context).size.height,
              child: PhotoPreviewGallery.builder(
                initialPage: 2,
                previewPadding: EdgeInsets.only(left: 10,
                    bottom: MediaQuery.of(context).padding.bottom),
                loadingBuilder: (BuildContext context, ImageChunkEvent? event) {
                  return const Center(child: const CircularProgressIndicator());
                },
                builder: (BuildContext context, int index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider:
                        CachedNetworkImageProvider(_imageUrls[index]),
                    minScale: PhotoViewComputedScale.contained,
                    initialScale: PhotoViewComputedScale.contained,
                  );
                },
                previewOptions: _imageUrls
                    .asMap()
                    .entries
                    .map((e) => PhotoPreviewOptions.customBuilder(
                          selectedBuilder: (BuildContext context, int index) {
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                border: Border.all(color: Colors.white),
                                image: DecorationImage(
                                    image: NetworkImage(_imageUrls[index]),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center),
                                color: Colors.white,
                              ),
                            );
                          },
                          builder: (BuildContext context, int index) {
                            return Container(
                              width: 100,
                              height: 100,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      // border: Border.all(color: Colors.white),
                                      image: DecorationImage(
                                          image:
                                              NetworkImage(_imageUrls[index]),
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center),
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      color: Colors.black.withAlpha(150),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ))
                    .toList(),
                itemCount: _imageUrls.length,
              ),
            ));
      },
      useRootNavigator: false,
    );
  }

  void openDialogCacheImage(BuildContext context) => showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              insetPadding: EdgeInsets.zero,
              child: Container(
                color: Colors.black,
                height: MediaQuery.of(context).size.height,
                child: PhotoPreviewGallery.builder(
                  loadingBuilder:
                      (BuildContext context, ImageChunkEvent? event) {
                    return const Center(
                        child: const CircularProgressIndicator());
                  },
                  builder: (BuildContext context, int index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider:
                          CachedNetworkImageProvider(_imageUrls[index]),
                      minScale: PhotoViewComputedScale.contained,
                      initialScale: PhotoViewComputedScale.contained,
                    );
                  },
                  previewOptions: _imageUrls
                      .asMap()
                      .entries
                      .map((e) => PhotoPreviewOptions.customBuilder(
                            selectedBuilder: (BuildContext context, int index) {
                              return Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  border: Border.all(color: Colors.white),
                                  image: DecorationImage(
                                      image: NetworkImage(_imageUrls[index]),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center),
                                  color: Colors.white,
                                ),
                              );
                            },
                            builder: (BuildContext context, int index) {
                              return Container(
                                width: 100,
                                height: 100,
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                        // border: Border.all(color: Colors.white),
                                        image: DecorationImage(
                                            image:
                                                NetworkImage(_imageUrls[index]),
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center),
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8)),
                                        color: Colors.black.withAlpha(150),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
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
              child: const Text("Dialog cache image network"),
              onPressed: () => openCustomDialog(context),
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

class ImageWidgetPlaceholder extends StatelessWidget {
  const ImageWidgetPlaceholder({
    Key? key,
    required this.image,
    required this.placeholder,
  }) : super(key: key);
  final ImageProvider image;
  final Widget placeholder;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: image,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        } else {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: frame != null ? child : placeholder,
          );
        }
      },
    );
  }
}

Future<T?> showCustomDialog<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  required WidgetBuilder builder,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) {
  final ThemeData theme = Theme.of(context);
  return showGeneralDialog<T?>(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      final Widget pageChild = Builder(builder: builder);
      return Builder(builder: (BuildContext context) {
        return theme != null ? Theme(data: theme, child: pageChild) : pageChild;
      });
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 150),
    transitionBuilder: _buildMaterialDialogTransitions,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
  );
}

Widget _buildMaterialDialogTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: child,
  );
}
