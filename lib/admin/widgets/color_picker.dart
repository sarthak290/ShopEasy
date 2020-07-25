import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:matrix/widgets/chips_input.dart';
import 'package:matrix/utils/tools.dart';

class ColorPicker extends StatefulWidget {
  final updateColors;
  final List<ColorProfile> initialColors;
  ColorPicker(
      {Key key, @required this.updateColors, @required this.initialColors})
      : super(key: key);

  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  List<ColorProfile> colors = [];

  @override
  void initState() {
    super.initState();
    getColors();
  }

  void getColors() async {
    String data =
        await DefaultAssetBundle.of(context).loadString("assets/colors.json");
    final jsonResult = json.decode(data);
    final jsonData = ColorResponse.fromJson({"data": jsonResult}).results;

    setState(() {
      colors = jsonData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ChipsInput(
          initialValue: widget.initialColors,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Select Colors",
              labelStyle: TextStyle(
                  fontSize: 22.0, color: Theme.of(context).primaryColor)),
          maxChips: 6,
          findSuggestions: (String query) {
            if (query.length != 0) {
              var lowercaseQuery = query.toLowerCase();
              return colors.where((color) {
                return color.name.toLowerCase().contains(query.toLowerCase());
              }).toList(growable: false)
                ..sort((a, b) => a.name
                    .toLowerCase()
                    .indexOf(lowercaseQuery)
                    .compareTo(b.name.toLowerCase().indexOf(lowercaseQuery)));
            }
            return colors;
          },
          onChanged: (data) {
            widget.updateColors(data);
          },
          chipBuilder: (context, state, profile) {
            return InputChip(
              key: ObjectKey(profile.colorId),
              label: Text(profile.name),
              avatar: CircleAvatar(
                backgroundColor: HexColor(profile.code),
              ),
              onDeleted: () => state.deleteChip(profile),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            );
          },
          suggestionBuilder: (context, state, profile) {
            return ListTile(
              key: ObjectKey(profile.colorId),
              leading: CircleAvatar(
                backgroundColor: HexColor(profile.code),
              ),
              title: Text(profile.name),
              onTap: () => state.selectSuggestion(profile),
            );
          },
        ),
      ),
    );
  }
}

class ColorProfile {
  final int colorId;
  final String name;
  final String code;

  ColorProfile({this.colorId, this.name, this.code});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ColorProfile &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  factory ColorProfile.fromJson(Map<String, dynamic> data) {
    data = data ?? {};
    return ColorProfile(
        name: data['name'] ?? '',
        colorId: data["colorId"],
        code: data["hexString"]);
  }

  @override
  String toString() {
    return name;
  }
}

class ColorResponse {
  List<ColorProfile> results;

  ColorResponse.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      results = new List<ColorProfile>();
      json["data"].forEach((v) {
        results.add(new ColorProfile.fromJson(v));
      });
    }
  }
}
