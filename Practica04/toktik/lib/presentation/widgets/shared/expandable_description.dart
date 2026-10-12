import 'package:flutter/material.dart';

class ExpandableDescription extends StatefulWidget {
  final String title;
  final String description;
  final int collapsedMaxLines;

  const ExpandableDescription({
    super.key,
    required this.title,
    required this.description,
    this.collapsedMaxLines = 2,
  });

  @override
  State<ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<ExpandableDescription> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          shadows: const [Shadow(blurRadius: 8, color: Colors.black87)],
        );
    final bodyStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          shadows: const [Shadow(blurRadius: 8, color: Colors.black87)],
        );

    return SizedBox(
      width: size.width * 0.68,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.title, style: titleStyle, maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          if (_expanded)
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 160),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.description, style: bodyStyle),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => setState(() => _expanded = false),
                      child: Text(
                        'menos',
                        style: bodyStyle?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            _CollapsedText(
              text: widget.description,
              style: bodyStyle,
              maxLines: widget.collapsedMaxLines,
              onExpand: () => setState(() => _expanded = true),
            ),
        ],
      ),
    );
  }
}

class _CollapsedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int maxLines;
  final VoidCallback onExpand;

  const _CollapsedText({
    required this.text,
    required this.style,
    required this.maxLines,
    required this.onExpand,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);
        final overflow = painter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: style,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
            if (overflow)
              GestureDetector(
                onTap: onExpand,
                child: Text(
                  '... más',
                  style: style?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
          ],
        );
      },
    );
  }
}
