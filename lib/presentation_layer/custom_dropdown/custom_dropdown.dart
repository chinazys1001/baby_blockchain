library animated_custom_dropdown;

export 'custom_dropdown.dart';

import 'package:flutter/material.dart';

part 'animated_section.dart';
part 'dropdown_field.dart';
part 'dropdown_overlay.dart';
part 'overlay_builder.dart';

enum SearchType { onListData }

class CustomDropdown extends StatefulWidget {
  final List<String> items;
  final TextEditingController controller;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? selectedStyle;
  final String? errorText;
  final TextStyle? errorStyle;
  final TextStyle? listItemStyle;
  final BorderSide? borderSide;
  final BorderSide? errorBorderSide;
  final BorderRadius? borderRadius;
  final Widget? fieldSuffixIcon;
  final Function(String)? onChanged;
  final bool? excludeSelected;
  final Color? fillColor;
  final bool? canCloseOutsideBounds;
  final SearchType? searchType;
  final String onNoResult;
  final double overlayBorderRadius;
  final String searchHint;
  final TextAlign textAlign;
  final bool isOutlineBorder;
  final EdgeInsets? contentPadding;

  CustomDropdown({
    Key? key,
    required this.items,
    required this.controller,
    this.hintText,
    this.hintStyle,
    this.selectedStyle,
    this.errorText,
    this.errorStyle,
    this.listItemStyle,
    this.errorBorderSide,
    this.borderRadius,
    this.borderSide,
    this.fieldSuffixIcon,
    this.onChanged,
    this.excludeSelected = true,
    this.fillColor = Colors.white,
    this.onNoResult = 'No matches found :(',
    this.overlayBorderRadius = 10,
    this.searchHint = 'Search',
    this.textAlign = TextAlign.start,
    this.isOutlineBorder = true,
    this.contentPadding,
  })  : assert(items.isNotEmpty, 'Items list must contain at least one item.'),
        assert(
          controller.text.isEmpty || items.contains(controller.text),
          'Controller value must match with one of the item in items list.',
        ),
        searchType = null,
        canCloseOutsideBounds = true,
        super(key: key);

  CustomDropdown.search({
    Key? key,
    required this.items,
    required this.controller,
    this.hintText,
    this.hintStyle,
    this.selectedStyle,
    this.errorText,
    this.errorStyle,
    this.listItemStyle,
    this.errorBorderSide,
    this.borderRadius,
    this.borderSide,
    this.fieldSuffixIcon,
    this.onChanged,
    this.excludeSelected = true,
    this.canCloseOutsideBounds = true,
    this.fillColor = Colors.white,
    this.onNoResult = 'No matches found :(',
    this.overlayBorderRadius = 10,
    this.searchHint = 'Search',
    this.textAlign = TextAlign.start,
    this.isOutlineBorder = true,
    this.contentPadding,
  })  : assert(items.isNotEmpty, 'Items list must contain at least one item.'),
        assert(
          controller.text.isEmpty || items.contains(controller.text),
          'Controller value must match with one of the item in items list.',
        ),
        searchType = SearchType.onListData,
        super(key: key);

  @override
  CustomDropdownState createState() => CustomDropdownState();
}

class CustomDropdownState extends State<CustomDropdown> {
  final layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    /// hint text
    final hintText = widget.hintText ?? 'Select value';

    // hint style :: if provided then merge with default
    final hintStyle = const TextStyle(
      fontSize: 16,
      color: Color(0xFFA7A7A7),
      fontWeight: FontWeight.w400,
    ).merge(widget.hintStyle);

    // selected item style :: if provided then merge with default
    final selectedStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ).merge(widget.selectedStyle);

    return _OverlayBuilder(
      overlay: (size, hideCallback) {
        return _DropdownOverlay(
          items: widget.items,
          controller: widget.controller,
          size: size,
          layerLink: layerLink,
          hideOverlay: hideCallback,
          headerStyle:
              widget.controller.text.isNotEmpty ? selectedStyle : hintStyle,
          hintText: hintText,
          listItemStyle: widget.listItemStyle,
          excludeSelected: widget.excludeSelected,
          canCloseOutsideBounds: widget.canCloseOutsideBounds,
          searchType: widget.searchType,
          searchHint: widget.searchHint,
          overlayBorderRadius: widget.overlayBorderRadius,
          onNoResult: widget.onNoResult,
        );
      },
      child: (showCallback) {
        return CompositedTransformTarget(
          link: layerLink,
          child: _DropDownField(
            controller: widget.controller,
            onTap: showCallback,
            style: selectedStyle,
            borderRadius: widget.borderRadius,
            borderSide: widget.borderSide,
            errorBorderSide: widget.errorBorderSide,
            errorStyle: widget.errorStyle,
            errorText: widget.errorText,
            hintStyle: hintStyle,
            hintText: hintText,
            suffixIcon: widget.fieldSuffixIcon,
            onChanged: widget.onChanged,
            fillColor: widget.fillColor,
            textAlign: widget.textAlign,
            isOutlineBorder: widget.isOutlineBorder,
            contentPadding: widget.contentPadding,
          ),
        );
      },
    );
  }
}
