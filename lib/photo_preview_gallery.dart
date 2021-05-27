part of 'photo_view_gallery.dart';

/// A [StatefulWidget] that shows multiple [PhotoView] widgets in a [PageView]
///
/// Some of [PhotoView] constructor options are passed direct to [PhotoViewGallery] constructor. Those options will affect the gallery in a whole.
///
/// Some of the options may be defined to each image individually, such as `initialScale` or `heroAttributes`. Those must be passed via each [PhotoViewGalleryPageOptions].
///
/// Example of usage as a list of options:
/// ```
/// PhotoViewGallery(
///   pageOptions: <PhotoViewGalleryPageOptions>[
///     PhotoViewGalleryPageOptions(
///       imageProvider: AssetImage("assets/gallery1.jpg"),
///       heroAttributes: const HeroAttributes(tag: "tag1"),
///     ),
///     PhotoViewGalleryPageOptions(
///       imageProvider: AssetImage("assets/gallery2.jpg"),
///       heroAttributes: const HeroAttributes(tag: "tag2"),
///       maxScale: PhotoViewComputedScale.contained * 0.3
///     ),
///     PhotoViewGalleryPageOptions(
///       imageProvider: AssetImage("assets/gallery3.jpg"),
///       minScale: PhotoViewComputedScale.contained * 0.8,
///       maxScale: PhotoViewComputedScale.covered * 1.1,
///       heroAttributes: const HeroAttributes(tag: "tag3"),
///     ),
///   ],
///   loadingBuilder: (context, progress) => Center(
///            child: Container(
///              width: 20.0,
///              height: 20.0,
///              child: CircularProgressIndicator(
///                value: _progress == null
///                    ? null
///                    : _progress.cumulativeBytesLoaded /
///                        _progress.expectedTotalBytes,
///              ),
///            ),
///          ),
///   backgroundDecoration: widget.backgroundDecoration,
///   pageController: widget.pageController,
///   onPageChanged: onPageChanged,
/// )
/// ```
///
/// Example of usage with builder pattern:
/// ```
/// PhotoViewGallery.builder(
///   scrollPhysics: const BouncingScrollPhysics(),
///   builder: (BuildContext context, int index) {
///     return PhotoViewGalleryPageOptions(
///       imageProvider: AssetImage(widget.galleryItems[index].image),
///       initialScale: PhotoViewComputedScale.contained * 0.8,
///       minScale: PhotoViewComputedScale.contained * 0.8,
///       maxScale: PhotoViewComputedScale.covered * 1.1,
///       heroAttributes: HeroAttributes(tag: galleryItems[index].id),
///     );
///   },
///   itemCount: galleryItems.length,
///   loadingBuilder: (context, progress) => Center(
///            child: Container(
///              width: 20.0,
///              height: 20.0,
///              child: CircularProgressIndicator(
///                value: _progress == null
///                    ? null
///                    : _progress.cumulativeBytesLoaded /
///                        _progress.expectedTotalBytes,
///              ),
///            ),
///          ),
///   backgroundDecoration: widget.backgroundDecoration,
///   pageController: widget.pageController,
///   onPageChanged: onPageChanged,
/// )
/// ```
class PhotoPreviewGallery extends StatefulWidget {
  /// Construct a gallery with static items through a list of [PhotoViewGalleryPageOptions].
  const PhotoPreviewGallery({
    Key? key,
    required this.pageOptions,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.gaplessPlayback = false,
    this.reverse = false,
    this.pageController,
    this.onPageChanged,
    this.scaleStateChangedCallback,
    this.enableRotation = false,
    this.scrollPhysics,
    this.scrollDirection = Axis.horizontal,
    this.customSize,
    this.previewOptions,
    this.backgroundColor = Colors.black,
  })  : itemCount = null,
        builder = null,
        super(key: key);

  /// Construct a gallery with dynamic items.
  ///
  /// The builder must return a [PhotoViewGalleryPageOptions].
  const PhotoPreviewGallery.builder({
    Key? key,
    required this.itemCount,
    required this.builder,
    this.loadingBuilder,
    this.backgroundDecoration,
    this.gaplessPlayback = false,
    this.reverse = false,
    this.pageController,
    this.onPageChanged,
    this.scaleStateChangedCallback,
    this.enableRotation = false,
    this.scrollPhysics,
    this.scrollDirection = Axis.horizontal,
    this.customSize,
    this.previewOptions,
    this.backgroundColor = Colors.black,
  })  : pageOptions = null,
        assert(itemCount != null),
        assert(builder != null),
        super(key: key);

  /// A list of options to describe the items in the gallery
  final List<PhotoViewGalleryPageOptions>? pageOptions;

  ///Preview option to build preview item
  final List<PhotoPreviewOptions>? previewOptions;

  /// The count of items in the gallery, only used when constructed via [PhotoViewGallery.builder]
  final int? itemCount;

  /// Called to build items for the gallery when using [PhotoViewGallery.builder]
  final PhotoViewGalleryBuilder? builder;

  /// [ScrollPhysics] for the internal [PageView]
  final ScrollPhysics? scrollPhysics;

  /// Mirror to [PhotoView.loadingBuilder]
  final LoadingBuilder? loadingBuilder;

  /// Mirror to [PhotoView.backgroundDecoration]
  final BoxDecoration? backgroundDecoration;

  /// Mirror to [PhotoView.gaplessPlayback]
  final bool gaplessPlayback;

  /// Mirror to [PageView.reverse]
  final bool reverse;

  /// An object that controls the [PageView] inside [PhotoViewGallery]
  final PageController? pageController;

  /// An callback to be called on a page change
  final PhotoViewGalleryPageChangedCallback? onPageChanged;

  /// Mirror to [PhotoView.scaleStateChangedCallback]
  final ValueChanged<PhotoViewScaleState>? scaleStateChangedCallback;

  /// Mirror to [PhotoView.enableRotation]
  final bool enableRotation;

  /// Mirror to [PhotoView.customSize]
  final Size? customSize;

  /// The axis along which the [PageView] scrolls. Mirror to [PageView.scrollDirection]
  final Axis scrollDirection;

  final Color backgroundColor;

  bool get _isBuilder => builder != null;

  @override
  State<StatefulWidget> createState() {
    return _PhotoPreviewGalleryState();
  }
}

class _PhotoPreviewGalleryState extends State<PhotoPreviewGallery>
    with SingleTickerProviderStateMixin {
  late final PageController _controller =
      widget.pageController ?? PageController();

  ///animation to visible or invisible preview photos when zoom
  late AnimationController _animationController;

  late PhotoGalleryController _photoGalleryController;

  late Animation<double> _opacityAnimation;
  late Animation<double> _sizeAnimation;

  bool _animated = false;

  bool isInteger(num value) => value is int || value == value.roundToDouble();

  @override
  void initState() {
    _photoGalleryController = PhotoGalleryController(page: actualPage);
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _opacityAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear);
    _opacityAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_opacityAnimation);
    _sizeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear);
    _sizeAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_sizeAnimation);
    _currentPage = actualPage;
    _controller.addListener(() {
      if (_animated) {
        if (_controller.page == _currentPage) {
          _animated = false;
        }
      } else {
        if (isInteger(_controller.page ?? actualPage)) {
          _currentPage = actualPage;
          _photoGalleryController.changePage(actualPage);
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void scaleStateChangedCallback(PhotoViewScaleState scaleState) {
    if (widget.scaleStateChangedCallback != null) {
      widget.scaleStateChangedCallback!(scaleState);
    }
  }

  int get actualPage {
    return _controller.hasClients ? _controller.page!.floor() : 0;
  }

  int _currentPage = 0;

  int get itemCount {
    if (widget._isBuilder) {
      return widget.itemCount!;
    }
    return widget.pageOptions!.length;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor,
      child: Column(
        children: [
          Expanded(
            child: PhotoViewGestureDetectorScope(
              axis: widget.scrollDirection,
              child: PageView.builder(
                reverse: widget.reverse,
                controller: _controller,
                onPageChanged: widget.onPageChanged,
                itemCount: itemCount,
                itemBuilder: _buildItem,
                scrollDirection: widget.scrollDirection,
                physics: widget.scrollPhysics,
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _sizeAnimation,
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: Container(
                height: 100,
                margin: const EdgeInsets.only(bottom: 10),
                child: _buildPreviewPhotos(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final pageOption = _buildPageOption(context, index);
    final isCustomChild = pageOption.child != null;

    final PhotoView photoView = isCustomChild
        ? PhotoView.customChild(
            key: ObjectKey(index),
            child: pageOption.child,
            childSize: pageOption.childSize,
            backgroundDecoration: widget.backgroundDecoration,
            controller: pageOption.controller,
            scaleStateController: pageOption.scaleStateController,
            customSize: widget.customSize,
            heroAttributes: pageOption.heroAttributes,
            scaleStateChangedCallback: scaleStateChangedCallback,
            enableRotation: widget.enableRotation,
            initialScale: pageOption.initialScale,
            minScale: pageOption.minScale,
            maxScale: pageOption.maxScale,
            scaleStateCycle: pageOption.scaleStateCycle,
            onTapUp: (
              BuildContext context,
              TapUpDetails details,
              PhotoViewControllerValue controllerValue,
            ) {
              pageOption.onTapUp?.call(context, details, controllerValue);
              if (_animationController.isCompleted ||
                  _animationController.isAnimating) {
                _animationController.reverse();
              }
            },
            onTapDown: pageOption.onTapDown,
            gestureDetectorBehavior: pageOption.gestureDetectorBehavior,
            tightMode: pageOption.tightMode,
            filterQuality: pageOption.filterQuality,
            basePosition: pageOption.basePosition,
            disableGestures: pageOption.disableGestures,
            onScaleStart: (BuildContext context, ScaleStartDetails details,
                PhotoViewControllerValue controllerValue) {
              pageOption.onScaleStart?.call(context, details, controllerValue);
              if (!(_animationController.isCompleted ||
                  _animationController.isAnimating)) {
                _animationController.forward();
              }
            },
            onScaleUpdate: pageOption.onScaleUpdate,
            onScaleEnd: (
              BuildContext context,
              ScaleEndDetails details,
              PhotoViewControllerValue controllerValue,
            ) {
              pageOption.onScaleEnd?.call(context, details, controllerValue);
              if (_animationController.isCompleted ||
                  _animationController.isAnimating) {
                _animationController.reverse();
              }
            },
          )
        : PhotoView(
            key: ObjectKey(index),
            imageProvider: pageOption.imageProvider,
            loadingBuilder: widget.loadingBuilder,
            backgroundDecoration: widget.backgroundDecoration,
            controller: pageOption.controller,
            scaleStateController: pageOption.scaleStateController,
            customSize: widget.customSize,
            gaplessPlayback: widget.gaplessPlayback,
            heroAttributes: pageOption.heroAttributes,
            scaleStateChangedCallback: scaleStateChangedCallback,
            enableRotation: widget.enableRotation,
            initialScale: pageOption.initialScale,
            minScale: pageOption.minScale,
            maxScale: pageOption.maxScale,
            scaleStateCycle: pageOption.scaleStateCycle,
            onTapUp: (
              BuildContext context,
              TapUpDetails details,
              PhotoViewControllerValue controllerValue,
            ) {
              pageOption.onTapUp?.call(context, details, controllerValue);
              if (_animationController.isCompleted ||
                  _animationController.isAnimating) {
                _animationController.reverse();
              }
            },
            onTapDown: pageOption.onTapDown,
            gestureDetectorBehavior: pageOption.gestureDetectorBehavior,
            tightMode: pageOption.tightMode,
            filterQuality: pageOption.filterQuality,
            basePosition: pageOption.basePosition,
            disableGestures: pageOption.disableGestures,
            errorBuilder: pageOption.errorBuilder,
            onScaleStart: (BuildContext context, ScaleStartDetails details,
                PhotoViewControllerValue controllerValue) {
              pageOption.onScaleStart?.call(context, details, controllerValue);
              if (!(_animationController.isCompleted ||
                  _animationController.isAnimating)) {
                _animationController.forward();
              }
            },
            onScaleUpdate: (
              BuildContext context,
              ScaleUpdateDetails details,
              PhotoViewControllerValue controllerValue,
            ) {
              pageOption.onScaleUpdate?.call(context, details, controllerValue);
            },
            onScaleEnd: (
              BuildContext context,
              ScaleEndDetails details,
              PhotoViewControllerValue controllerValue,
            ) {
              pageOption.onScaleEnd?.call(context, details, controllerValue);
            },
          );

    return ClipRect(
      child: photoView,
    );
  }

  Widget _buildPreviewPhotos() {
    return _PreviewGallery(
      itemCount: itemCount,
      previewOptions: widget.previewOptions,
      photoGalleryController: _photoGalleryController,
      backgroundColor: widget.backgroundColor,
      onPageChanged: (int page) {
        _currentPage = _photoGalleryController.page;
        widget.onPageChanged?.call(_photoGalleryController.page);
        _photoGalleryController.changePage(page);
        _controller.animateToPage(page,
            duration: const Duration(milliseconds: 500), curve: Curves.linear);
      },
    );
  }

  PhotoViewGalleryPageOptions _buildPageOption(
      BuildContext context, int index) {
    if (widget._isBuilder) {
      return widget.builder!(context, index);
    }
    return widget.pageOptions![index];
  }
}

/// A helper class that wraps individual options of a page in [PhotoViewGallery]
///
/// The [maxScale], [minScale] and [initialScale] options may be [double] or a [PhotoViewComputedScale] constant
///
class PhotoPreviewOptions {
  PhotoPreviewOptions({
    Key? key,
    required this.imageProvider,
    this.gestureDetectorBehavior,
    this.tightMode,
    this.disableGestures,
    this.errorBuilder,
    this.onPressed,
    this.selectedBuilder,
  })  : builder = null,
        childSize = null,
        assert(imageProvider != null);

  PhotoPreviewOptions.customBuilder({
    required this.builder,
    this.gestureDetectorBehavior,
    this.tightMode,
    this.disableGestures,
    this.onPressed,
    this.childSize,
    this.selectedBuilder,
  })  : errorBuilder = null,
        imageProvider = null;

  /// Mirror to [PhotoView.imageProvider]
  final ImageProvider? imageProvider;

  final PreviewGalleryBuilder? selectedBuilder;

  final PreviewGalleryBuilder? builder;

  final Size? childSize;

  /// Mirror to [PhotoView.onTapDown]
  final PhotoPreviewOnPressed? onPressed;

  /// Mirror to [PhotoView.gestureDetectorBehavior]
  final HitTestBehavior? gestureDetectorBehavior;

  /// Mirror to [PhotoView.tightMode]
  final bool? tightMode;

  /// Mirror to [PhotoView.disableGestures]
  final bool? disableGestures;

  /// Mirror to [PhotoView.errorBuilder]
  final ImageErrorWidgetBuilder? errorBuilder;
}

/// A type definition for a callback when the user taps up the photoview region
typedef PhotoPreviewOnPressed = void Function();

/// A type definition for a [Function] that defines a page in [_PreviewGallery.build]
typedef PreviewGalleryBuilder = Widget Function(
    BuildContext context, int index);

///[PreviewGallery] widget use for [PhotoPreviewGallery] to preview all photos
class _PreviewGallery extends StatefulWidget {
  const _PreviewGallery({
    Key? key,
    this.previewOptions,
    this.builder,
    this.itemCount,
    this.onPageChanged,
    this.scrollPhysics,
    required this.photoGalleryController,
    this.backgroundColor = Colors.black,
  }) : super(key: key);

  @override
  _PreviewGalleryState createState() => _PreviewGalleryState();

  ///Preview option to build preview item
  final List<PhotoPreviewOptions>? previewOptions;

  /// The count of items in the preview gallery, only used when constructed via [PreviewGalleryBuilder.builder]
  final int? itemCount;

  /// Called to build items for the preview gallery when using [PreviewGalleryBuilder.builder]
  final PreviewGalleryBuilder? builder;

  /// [ScrollPhysics] for the internal [PageView]
  final ScrollPhysics? scrollPhysics;

  /// An callback to be called on a page change
  final PhotoViewGalleryPageChangedCallback? onPageChanged;

  final PhotoGalleryController photoGalleryController;

  final Color backgroundColor;
}

class _PreviewGalleryState extends State<_PreviewGallery> {
  final AutoScrollController _autoScrollController = AutoScrollController();

  int _currentPage = 0;

  @override
  void initState() {
    _currentPage = widget.photoGalleryController.page;
    WidgetsBinding.instance!.addPostFrameCallback(
        (_) => _autoScrollController.scrollToIndex(_currentPage));

    widget.photoGalleryController.addListener(() {
      if (_currentPage != widget.photoGalleryController.page) {
        setState(() {
          _currentPage = widget.photoGalleryController.page;
        });

        _autoScrollController.scrollToIndex(_currentPage);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: ListView.separated(
        controller: _autoScrollController,
        itemBuilder: _buildItem,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(width: 10);
        },
        itemCount: itemCount,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  int get itemCount {
    if (widget.builder != null) {
      return widget.itemCount!;
    }
    return widget.previewOptions!.length;
  }

  PhotoPreviewOptions _buildPageOption(BuildContext context, int index) {
    return widget.previewOptions![index];
  }

  Widget? _buildSelectedItem() {
    return widget.previewOptions?[_currentPage].selectedBuilder
        ?.call(context, _currentPage);
  }

  Widget _buildItem(BuildContext context, int index) {
    final pageOption = _buildPageOption(context, index);
    final isCustomChild = pageOption.builder != null;

    final Widget previewPhoto = isCustomChild
        ? pageOption.builder!(context, index)
        : Container(
            width: widget.previewOptions?[index].childSize?.width ?? 100,
            height: widget.previewOptions?[index].childSize?.width ?? 100,
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              image: DecorationImage(
                image: pageOption.imageProvider!,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          );

    return AutoScrollTag(
      key: ValueKey(index),
      index: index,
      controller: _autoScrollController,
      child: InkWell(
        child: _currentPage == index
            ? _buildSelectedItem() ?? previewPhoto
            : previewPhoto,
        onTap: () {
          setState(() {
            _currentPage = index;
          });

          widget.photoGalleryController.changePage(index);
          widget.onPageChanged?.call(index);
          _autoScrollController.scrollToIndex(
            index,
            duration: const Duration(milliseconds: 500),
          );
        },
      ),
    );
  }
}

class PhotoGalleryController extends ChangeNotifier {
  PhotoGalleryController({required this.page});

  int page;

  void changePage(int index) {
    page = index;
    notifyListeners();
  }
}
