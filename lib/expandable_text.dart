import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:simple_html_css/simple_html_css.dart';

import './text_parser.dart';

typedef StringCallback = void Function(String value);

class ExpandableTextHtml extends StatefulWidget {
  const ExpandableTextHtml(
    this.text, {
    Key? key,
    required this.expandText,
    this.collapseText,
    this.expanded = false,
    this.onExpandedChanged,
    this.onLinkTap,
    this.linkColor,
    this.linkEllipsis = true,
    this.linkStyle,
    this.prefixText,
    this.prefixStyle,
    this.onPrefixTap,
    this.urlStyle,
    this.onUrlTap,
    this.hashtagStyle,
    this.onHashtagTap,
    this.mentionStyle,
    this.onMentionTap,
    this.expandOnTextTap = false,
    this.collapseOnTextTap = false,
    this.style,
    this.textDirection,
    this.textAlign,
    this.textScaleFactor,
    this.maxLines = 2,
    this.animation = false,
    this.animationDuration,
    this.animationCurve,
    this.semanticsLabel,
  })  : assert(maxLines > 0),
        super(key: key);

  final String text;
  final String expandText;
  final String? collapseText;
  final bool expanded;
  final ValueChanged<bool>? onExpandedChanged;
  final VoidCallback? onLinkTap;
  final Color? linkColor;
  final bool linkEllipsis;
  final TextStyle? linkStyle;
  final String? prefixText;
  final TextStyle? prefixStyle;
  final VoidCallback? onPrefixTap;
  final TextStyle? urlStyle;
  final StringCallback? onUrlTap;
  final TextStyle? hashtagStyle;
  final StringCallback? onHashtagTap;
  final TextStyle? mentionStyle;
  final StringCallback? onMentionTap;
  final bool expandOnTextTap;
  final bool collapseOnTextTap;
  final TextStyle? style;
  final TextDirection? textDirection;
  final TextAlign? textAlign;
  final double? textScaleFactor;
  final int maxLines;
  final bool animation;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final String? semanticsLabel;

  @override
  ExpandableTextHtmlState createState() => ExpandableTextHtmlState();
}

class ExpandableTextHtmlState extends State<ExpandableTextHtml>
    with TickerProviderStateMixin {
  bool _expanded = false;
  late TapGestureRecognizer _linkTapGestureRecognizer;
  late TapGestureRecognizer _prefixTapGestureRecognizer;

  List<TextSegment> _textSegments = [];
  final List<TapGestureRecognizer> _textSegmentsTapGestureRecognizers = [];

  @override
  void initState() {
    super.initState();

    _expanded = widget.expanded;
    _linkTapGestureRecognizer = TapGestureRecognizer()..onTap = _linkTapped;
    _prefixTapGestureRecognizer = TapGestureRecognizer()..onTap = _prefixTapped;

    _updateText();
  }

  @override
  void didUpdateWidget(ExpandableTextHtml oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.text != widget.text ||
        oldWidget.onHashtagTap != widget.onHashtagTap ||
        oldWidget.onMentionTap != widget.onMentionTap) {
      _updateText();
    }
  }

  @override
  void dispose() {
    _linkTapGestureRecognizer.dispose();
    _prefixTapGestureRecognizer.dispose();
    _textSegmentsTapGestureRecognizers
        .forEach((recognizer) => recognizer.dispose());
    super.dispose();
  }

  void _linkTapped() {
    if (widget.onLinkTap != null) {
      widget.onLinkTap!();
      return;
    }

    final toggledExpanded = !_expanded;

    setState(() => _expanded = toggledExpanded);

    widget.onExpandedChanged?.call(toggledExpanded);
  }

  void _prefixTapped() {
    widget.onPrefixTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    var effectiveTextStyle = widget.style;
    if (widget.style == null || widget.style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);
    }

    final linkText =
        (_expanded ? widget.collapseText : widget.expandText) ?? '';
    final linkColor = widget.linkColor ??
        widget.linkStyle?.color ??
        Theme.of(context).colorScheme.secondary;
    final linkTextStyle =
        effectiveTextStyle!.merge(widget.linkStyle).copyWith(color: linkColor);

    final prefixText =
        widget.prefixText != null && widget.prefixText!.isNotEmpty
            ? '${widget.prefixText} '
            : '';

    final link = TextSpan(
      children: [
        if (!_expanded)
          TextSpan(
            text: '\u2026 ',
            style: widget.linkEllipsis ? linkTextStyle : effectiveTextStyle,
            recognizer: widget.linkEllipsis ? _linkTapGestureRecognizer : null,
          ),
        if (linkText.length > 0)
          TextSpan(
            style: effectiveTextStyle,
            children: <TextSpan>[
              if (_expanded)
                TextSpan(
                  text: ' ',
                ),
              TextSpan(
                text: linkText,
                style: linkTextStyle,
                recognizer: _linkTapGestureRecognizer,
              ),
            ],
          ),
      ],
    );

    final prefix = TextSpan(
      text: prefixText,
      style: effectiveTextStyle.merge(widget.prefixStyle),
      recognizer: _prefixTapGestureRecognizer,
    );

    final text = _textSegments.isNotEmpty
        ? TextSpan(
            children: _buildTextSpans(_textSegments, effectiveTextStyle, null))
        : TextSpan(children: _buildTextSpanHtml(text: widget.text));

    final content = TextSpan(
      children: <TextSpan>[prefix, text],
      style: effectiveTextStyle,
    );

    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;

        final textAlign =
            widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start;
        final textDirection =
            widget.textDirection ?? Directionality.of(context);
        final textScaleFactor =
            widget.textScaleFactor ?? MediaQuery.textScaleFactorOf(context);
        final locale = Localizations.maybeLocaleOf(context);

        TextPainter textPainter = TextPainter(
          text: link,
          textAlign: textAlign,
          textDirection: textDirection,
          textScaleFactor: textScaleFactor,
          maxLines: widget.maxLines,
          locale: locale,
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;

        textPainter.text = content;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;

        TextSpan textSpan;

        if (textPainter.didExceedMaxLines) {
          final position = textPainter.getPositionForOffset(Offset(
            textSize.width - linkSize.width,
            textSize.height,
          ));
          final endOffset =
              (textPainter.getOffsetBefore(position.offset) ?? 0) -
                  prefixText.length;

          final recognizer =
              (_expanded ? widget.collapseOnTextTap : widget.expandOnTextTap)
                  ? _linkTapGestureRecognizer
                  : null;

          final text = _textSegments.isNotEmpty
              ? TextSpan(
                  children: _buildTextSpans(
                      _expanded
                          ? _textSegments
                          : parseText(
                              widget.text.substring(0, max(endOffset, 0))),
                      effectiveTextStyle!,
                      recognizer),
                )
              : TextSpan(
                  children: _expanded
                      ? _buildTextSpanHtml(
                          text: widget.text, recognizer: recognizer)
                      : _getCollapseText(max(endOffset, 0)),
                );
          textSpan = TextSpan(
            style: effectiveTextStyle,
            children: <TextSpan>[
              prefix,
              text,
              link,
            ],
          );
        } else {
          textSpan = content;
        }

        final richText = RichText(
          text: textSpan,
          softWrap: true,
          textDirection: textDirection,
          textAlign: textAlign,
          textScaleFactor: textScaleFactor,
          overflow: TextOverflow.clip,
        );

        if (widget.animation) {
          return AnimatedSize(
            child: richText,
            duration: widget.animationDuration ?? Duration(milliseconds: 200),
            curve: widget.animationCurve ?? Curves.fastLinearToSlowEaseIn,
            alignment: Alignment.topLeft,
          );
        }

        return richText;
      },
    );

    if (widget.semanticsLabel != null) {
      result = Semantics(
        textDirection: widget.textDirection,
        label: widget.semanticsLabel,
        child: ExcludeSemantics(
          child: result,
        ),
      );
    }
    return result;
  }

  void _updateText() {
    _textSegmentsTapGestureRecognizers
        .forEach((recognizer) => recognizer.dispose());
    _textSegmentsTapGestureRecognizers.clear();

    if (widget.onHashtagTap == null && widget.onMentionTap == null) {
      _textSegments.clear();
      return;
    }

    _textSegments = parseText(widget.text);

    _textSegments.forEach((element) {
      if (element.isHashtag && widget.onHashtagTap != null) {
        final recognizer = TapGestureRecognizer()
          ..onTap = () {
            widget.onHashtagTap!(element.name!);
          };

        _textSegmentsTapGestureRecognizers.add(recognizer);
      } else if (element.isMention && widget.onMentionTap != null) {
        final recognizer = TapGestureRecognizer()
          ..onTap = () {
            widget.onMentionTap!(element.name!);
          };

        _textSegmentsTapGestureRecognizers.add(recognizer);
      }
    });
  }

  List<TextSpan> _buildTextSpans(List<TextSegment> segments,
      TextStyle textStyle, TapGestureRecognizer? textTapRecognizer) {
    final spans = <TextSpan>[];

    for (var segment in segments) {
      if (!segment.isUrl) {
        List<TextSpan> list = _buildTextSpanHtml(
            text: segment.text, recognizer: textTapRecognizer);
        spans.addAll(list);
      }
    }

    return spans;
  }

  List<TextSpan> _buildTextSpanHtml(
      {String? text, TapGestureRecognizer? recognizer}) {
    String content = text ?? '';

    content = content.replaceAll('&nbsp;', ' ').replaceAll('&nbsp', ' ');

    content = content.replaceAll('<br>', '<br />');

    final Parser parser = Parser(
      context,
      HtmlUnescape().convert(content),
      linksCallback: (p0) => widget.onUrlTap?.call(p0),
    );
    List<TextSpan> list = <TextSpan>[];
    try {
      parser.parse().forEach((element) {
        print('ghghghgh ${element.text}');
        list.add(TextSpan(
            text: element.text,
            style: element.style
                ?.copyWith(background: Paint()..color = Colors.transparent),
            recognizer: recognizer));
      });
    } catch (error, stackTrace) {
      debugPrint('simple_html_css Exception: ${error.toString()}');
      debugPrint('simple_html_css Stack Trace: ${stackTrace.toString()}');
    }
    return list;
  }

  List<TextSpan> _getCollapseText(int endOffset) {
    print('endOffset $endOffset');
    List<TextSpan> list = <TextSpan>[];
    int lengthShort = 0;
    List<TextSpan> listFull = _buildTextSpanHtml(text: widget.text);
    for (int i = 0; i < listFull.length; i++) {
      TextSpan element = listFull[i];
      print('element $i, ${element.text}');

      if (i == 0 && (element.text?.length ?? 0) >= max(endOffset, 0)) {
        lengthShort = max(endOffset, 0);
        list.add(TextSpan(
            text: element.text?.trim().substring(0, endOffset),
            style: element.style));
        break;
      }
      if (lengthShort >= max(endOffset, 0)) break;
      list.add(TextSpan(
        text: (element.text?.length ?? 0) <= (endOffset - lengthShort)
            ? element.text
            : element.text?.trim().substring(0, endOffset - lengthShort),
        style: element.style,
      ));
      lengthShort += ((element.text?.length ?? 0) >= (endOffset - lengthShort)
          ? (endOffset - lengthShort)
          : (element.text?.length ?? 0));
    }
    return list;
  }
}
