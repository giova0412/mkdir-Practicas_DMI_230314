import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toktik/config/helpers/human_formats.dart';
import 'package:toktik/domain/entities/video_post_extended.dart';
import 'package:toktik/presentation/providers/season_theme_manager.dart';

class VideoButtons extends StatelessWidget {
  final VideoPostExtended video;
  final Future<void> Function(String videoId)? onToggleLike;
  final bool isMuted;
  final VoidCallback? onToggleMute;

  const VideoButtons({
    super.key,
    required this.video,
    this.onToggleLike,
    this.isMuted = true,
    this.onToggleMute,
  });

  void _showStatsSheet(BuildContext context) {
    final theme = context.read<SeasonThemeManager>().currentTheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              video.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(theme.likeIcon, size: 18),
                const SizedBox(width: 6),
                Text(HumanFormats.humanReadbleNumber(video.likes.toDouble())),
                const SizedBox(width: 16),
                Icon(theme.viewsIcon, size: 18),
                const SizedBox(width: 6),
                Text(HumanFormats.humanReadbleNumber(video.views.toDouble())),
              ],
            ),
            const SizedBox(height: 12),
            Text('Fuente: ${video.source} · ${video.provider.name}'),
            Text('ID: ${video.id}', style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoSheet(BuildContext context) {
    final theme = context.read<SeasonThemeManager>().currentTheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(theme.playIcon, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    video.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              video.description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showStatsSheet(context);
                    },
                    icon: const Icon(Icons.bar_chart, size: 18),
                    label: const Text('Estadísticas'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      if (onToggleLike != null) {
                        await onToggleLike!(video.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                video.liked
                                    ? 'Quitado de favoritos'
                                    : 'Guardado en favoritos',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      }
                    },
                    icon: Icon(
                      video.liked ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                    ),
                    label: Text(video.liked ? 'Quitar' : 'Favorito'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<SeasonThemeManager>().currentTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Like: persiste en local storage, suma/resta.
        _CustomIconButton(
          value: video.likes,
          iconData: video.liked ? theme.likeIcon : theme.likeOutlinedIcon,
          iconColor: video.liked ? theme.colorScheme.primary : Colors.white,
          tooltip: video.liked ? 'Quitar me gusta' : 'Me gusta',
          onTap: onToggleLike == null
              ? null
              : () async {
                  await onToggleLike!(video.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          video.liked
                              ? 'Quitaste tu me gusta'
                              : '¡Te gusta este video!',
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
        ),
        const SizedBox(height: 18),
        // 2. Vistas: abre hoja de estadísticas.
        _CustomIconButton(
          value: video.views,
          iconData: theme.viewsIcon,
          tooltip: 'Ver estadísticas',
          onTap: () => _showStatsSheet(context),
        ),
        const SizedBox(height: 18),
        // 3. Mute: activa/desactiva sonido.
        _CustomIconButton(
          value: 0,
          iconData: isMuted ? theme.volumeOffIcon : theme.volumeOnIcon,
          tooltip: isMuted ? 'Activar sonido' : 'Silenciar',
          onTap: () {
            onToggleMute?.call();
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isMuted ? 'Sonido activado' : 'Sonido silenciado'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
        const SizedBox(height: 18),
        // 4. Disco giratorio: abre info del video + acceso a favorito.
        SpinPerfect(
          infinite: true,
          duration: const Duration(seconds: 5),
          child: _CustomIconButton(
            value: 0,
            iconData: theme.playIcon,
            tooltip: 'Info del video',
            onTap: () => _showInfoSheet(context),
          ),
        ),
      ],
    );
  }
}

class _CustomIconButton extends StatelessWidget {
  final int value;
  final IconData iconData;
  final Color? color;
  final VoidCallback? onTap;
  final String? tooltip;

  const _CustomIconButton({
    required this.value,
    required this.iconData,
    Color? iconColor,
    this.onTap,
    this.tooltip,
  }) : color = iconColor;

  @override
  Widget build(BuildContext context) {
    final button = GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(iconData, color: color ?? Colors.white, size: 28),
            if (value > 0)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  HumanFormats.humanReadbleNumber(value.toDouble()),
                  style: TextStyle(color: color ?? Colors.white, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}
