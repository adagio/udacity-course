// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:task_05_stateful_widgets/unit.dart';

/// Converter Screen where users can input amounts to convert.
///
/// Currently, it just displays a list of mock units.
///
class ConverterScreen extends StatefulWidget {
  /// This [Category]'s name.
  final String name;

  /// Color for this [Category].
  final Color color;

  /// Units for this [Category].
  final List<Unit> units;

  /// This [ConverterScreen] requires the name, color, and units to not be null.
  const ConverterScreen({
    @required this.name,
    @required this.color,
    @required this.units,
  })
      : assert(name != null),
        assert(color != null),
        assert(units != null);

  @override
  /*State<StatefulWidget> createState() {

  }*/
  _ConverterScreenState createState() => _ConverterScreenState();

}

class _ConverterScreenState extends State<ConverterScreen> {

  @override
  Widget build(BuildContext context) {
    // Here is just a placeholder for a list of mock units
    // Once the build() function is inside the State object,
    // you'll have to reference this using `widget.units`
    final unitWidgets = widget.units.map((Unit unit) {
      return Container(
        color: widget.color,
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              unit.name,
              style: Theme.of(context).textTheme.headline,
            ),
            Text(
              'Conversion: ${unit.conversion}',
              style: Theme.of(context).textTheme.subhead,
            ),
          ],
        ),
      );
    }).toList();

    return ListView(
      children: unitWidgets,
    );
  }

}
