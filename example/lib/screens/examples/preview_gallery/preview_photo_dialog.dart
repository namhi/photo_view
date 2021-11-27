//@dart=2.12
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_view_example/screens/examples/preview_gallery/custom_dialog.dart';
import 'package:photo_view_example/screens/examples/preview_gallery/photo_view_gallery.dart';
import 'package:rxdart/rxdart.dart';

typedef ImageProviderBuilder = ImageProvider Function(
    BuildContext context, int index);

class AppPhotoGalleryDialog extends StatefulWidget {
  const AppPhotoGalleryDialog(
      {Key? key,
      required this.itemCount,
      required this.previewBuilder,
      required this.selectedPreviewBuilder,
      required this.photoBuilder,
      this.initialPage = 0})
      : super(key: key);

  final int itemCount;
  final Widget Function(BuildContext context, int index) previewBuilder;
  final Widget Function(BuildContext context, int index) selectedPreviewBuilder;
  final ImageProviderBuilder photoBuilder;
  final int initialPage;

  @override
  _AppPhotoGalleryDialogState createState() => _AppPhotoGalleryDialogState();
}

class _AppPhotoGalleryDialogState extends State<AppPhotoGalleryDialog> {
  ///Dùng để ẩn khi đang thực hiện thao tác trên hình và hiện thị khi kết thúc
  final BehaviorSubject<bool> _behaviorVisible = BehaviorSubject<bool>();

  @override
  void initState() {
    _behaviorVisible.add(true);
    super.initState();
  }

  @override
  void dispose() {
    _behaviorVisible.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          AppPhotoGallery(
            previewBuilder: widget.previewBuilder,
            itemCount: widget.itemCount,
            selectedPreviewBuilder: widget.selectedPreviewBuilder,
            photoBuilder: widget.photoBuilder,
            onScaleStart: (BuildContext context, ScaleStartDetails details) {
              _behaviorVisible.add(false);
            },
            onScaleEnd: (BuildContext context, ScaleEndDetails details) {
              _behaviorVisible.add(true);
            },
            initialPage: widget.initialPage,
          ),
          StreamBuilder<bool>(
            stream: _behaviorVisible.stream,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return snapshot.data ?? true
                  ? Positioned(
                      right: 10,
                      top: MediaQuery.of(context).padding.top,
                      child: ClipOval(
                        child: Material(
                          color: Colors.white.withOpacity(0.13),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}

Future<void> showPhotoGalleryDialog({
  required BuildContext context,
  required Widget Function(BuildContext context, int index) previewBuilder,
  required Widget Function(BuildContext context, int index)
      selectedPreviewBuilder,
  required ImageProviderBuilder photoBuilder,
  required int itemCount,
  int initialPage = 0,
}) {
  return showCustomDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeIn,
          child: Dialog(
            insetPadding: EdgeInsets.zero,
            child: AppPhotoGalleryDialog(
              previewBuilder: previewBuilder,
              itemCount: itemCount,
              selectedPreviewBuilder: selectedPreviewBuilder,
              photoBuilder: photoBuilder,
              initialPage: initialPage,
            ),
          ));
    },
    useRootNavigator: false,
  );
}

Future<void> showNetworkPhotoGalleryDialog({
  required BuildContext context,
  required List<String> imageUrls,
  int initialPage = 0,
}) {
  return showPhotoGalleryDialog(
    itemCount: imageUrls.length,
    initialPage: initialPage,
    previewBuilder: (BuildContext context, int index) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(50)),
          ),
        ),
      );
      // return Container(
      //   margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      //   child: Stack(
      //     children: [
      //       _buildCachedImage(
      //         width: 100,
      //         height: 100,
      //         imageUrl: imageUrls[index],
      //         imageBuilder:
      //             (BuildContext context, ImageProvider imageProvider) {
      //           return Container(
      //             decoration: BoxDecoration(
      //               borderRadius: const BorderRadius.all(Radius.circular(8)),
      //               image: DecorationImage(
      //                 image: imageProvider,
      //                 fit: BoxFit.cover,
      //               ),
      //             ),
      //           );
      //         },
      //       ),
      //       Container(
      //         width: 100,
      //         height: 100,
      //         decoration: BoxDecoration(
      //           borderRadius: const BorderRadius.all(Radius.circular(8)),
      //           color: Colors.black.withAlpha(150),
      //         ),
      //       )
      //     ],
      //   ),
      // );
    },
    context: context,
    selectedPreviewBuilder: (BuildContext context, int index) {
      // return Container(
      //   width: 10,
      //   height: 10,
      //   decoration: BoxDecoration(
      //       color: Colors.white,
      //       borderRadius: BorderRadius.circular(50)
      //   ),
      // );
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(50)),
          ),
        ),
      );
      return Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: _buildCachedImage(
          width: 100,
          height: 100,
          imageUrl: imageUrls[index],
          imageBuilder: (BuildContext context, ImageProvider imageProvider) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: Colors.white),
                color: Colors.white,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      );
    },
    photoBuilder: (BuildContext context, int index) {
      return CachedNetworkImageProvider(imageUrls[index]);
    },
  );
}

///Hiện thị hình ảnh
Widget _buildCachedImage(
    {required String imageUrl,
    required double width,
    required double height,
    ImageWidgetBuilder? imageBuilder}) {
  return CachedNetworkImage(
    width: width,
    height: height,
    imageUrl: imageUrl,
    fit: BoxFit.cover,
    imageBuilder: imageBuilder,
    progressIndicatorBuilder: (BuildContext context, url, downloadProgress) =>
        const LoadingIndicator(),
    errorWidget: (BuildContext context, url, error) => Container(
      decoration: BoxDecoration(
          color: Colors.grey,
          border: Border.all(
            color: Colors.grey.withAlpha(100),
          )),
      child: SvgPicture.asset('assets/icon/empty-image-product.svg',
          width: 50, height: 50, fit: BoxFit.cover),
    ),
  );
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key, this.backgroundColor}) : super(key: key);
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      color: backgroundColor ?? Colors.grey.shade300.withOpacity(0.6),
      child: const Center(
        child: SpinKitCircle(color: Colors.green, size: 50),
      ),
    );
  }
}
