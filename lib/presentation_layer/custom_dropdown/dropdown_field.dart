part of 'custom_dropdown.dart';

const _noTextStyle = TextStyle(height: 0);
const _borderSide = BorderSide(color: Colors.transparent);
const _errorBorderSide = BorderSide(color: Colors.redAccent, width: 2);

class _DropDownField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onTap;
  final Function(String)? onChanged;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final String? errorText;
  final TextStyle? errorStyle;
  final BorderSide? borderSide;
  final BorderSide? errorBorderSide;
  final BorderRadius? borderRadius;
  final Widget? suffixIcon;
  final Color? fillColor;
  final TextAlign textAlign;
  final bool isOutlineBorder;

  const _DropDownField({
    Key? key,
    required this.controller,
    required this.onTap,
    this.onChanged,
    this.suffixIcon,
    this.hintText,
    this.hintStyle,
    this.style,
    this.errorText,
    this.errorStyle,
    this.borderSide,
    this.errorBorderSide,
    this.borderRadius,
    this.fillColor,
    this.textAlign = TextAlign.start,
    this.isOutlineBorder = true,
  }) : super(key: key);

  @override
  State<_DropDownField> createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<_DropDownField> {
  String? prevText;
  bool listenChanges = true;

  @override
  void initState() {
    super.initState();
    if (widget.onChanged != null) {
      widget.controller.addListener(listenItemChanges);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(listenItemChanges);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _DropDownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onChanged != null) {
      widget.controller.addListener(listenItemChanges);
    } else {
      listenChanges = false;
    }
  }

  void listenItemChanges() {
    if (listenChanges) {
      final text = widget.controller.text;
      if (prevText != null && prevText != text && text.isNotEmpty) {
        widget.onChanged!(text);
      }
      prevText = text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final outlineBorder = OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
      borderSide: widget.borderSide ?? _borderSide,
    );
    final outlineErrorBorder = OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
      borderSide: widget.errorBorderSide ?? _errorBorderSide,
    );

    final underlineBorder = UnderlineInputBorder(
      borderSide: widget.borderSide ?? _borderSide,
    );
    final underlineErrorBorder = UnderlineInputBorder(
      borderSide: widget.errorBorderSide ?? _errorBorderSide,
    );

    return TextFormField(
      controller: widget.controller,
      validator: (val) {
        if (val?.isEmpty ?? false) return widget.errorText ?? '';
        return null;
      },
      readOnly: true,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      style: widget.style,
      textAlign: widget.textAlign,
      decoration: InputDecoration(
        suffixIcon: widget.suffixIcon,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        fillColor: widget.fillColor,
        filled: true,
        errorStyle: widget.errorText != null ? widget.errorStyle : _noTextStyle,
        border: widget.isOutlineBorder ? outlineBorder : underlineBorder,
        enabledBorder: widget.isOutlineBorder ? outlineBorder : underlineBorder,
        focusedBorder: widget.isOutlineBorder ? outlineBorder : underlineBorder,
        errorBorder:
            widget.isOutlineBorder ? outlineErrorBorder : underlineErrorBorder,
        focusedErrorBorder:
            widget.isOutlineBorder ? outlineErrorBorder : underlineErrorBorder,
      ),
    );
  }
}
