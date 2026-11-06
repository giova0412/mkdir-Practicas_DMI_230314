import 'package:cinemapedia/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Imagen de póster desde Internet con un cargador propio en **cian**.
///
/// Reemplaza al loader morado de la referencia: mientras la imagen se
/// descarga se ve un spinner cian y, al terminar, aparece con un fundido.
class MovieNetworkImage extends StatelessWidget {

  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;

  const MovieNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      width: width,
      height: height,

      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if ( wasSynchronouslyLoaded ) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          child: child,
        );
      },

      loadingBuilder: (context, child, loadingProgress) {
        if ( loadingProgress == null ) return child;
        return _Placeholder(
          width: width,
          height: height,
          child: const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator( strokeWidth: 2, color: AppTheme.cyan ),
          ),
        );
      },

      errorBuilder: (context, error, stackTrace) => _Placeholder(
        width: width,
        height: height,
        child: const Icon( Icons.broken_image_outlined, color: Colors.white38 ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {

  final double? width;
  final double? height;
  final Widget child;

  const _Placeholder({ this.width, this.height, required this.child });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: Colors.black26,
      alignment: Alignment.center,
      child: child,
    );
  }
}
