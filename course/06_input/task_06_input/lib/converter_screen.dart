// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'unit.dart';

const _padding = EdgeInsets.all(16.0);

/// [ConverterScreen] where users can input amounts to convert in one [Unit]
/// and retrieve the conversion in another [Unit] for a specific [Category].
///
/// While it is named ConverterRoute, a more apt name would be ConverterScreen,
/// because it is responsible for the UI at the route's destination.
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
  })  : assert(name != null),
        assert(color != null),
        assert(units != null);

  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  // Set some variables, such as for keeping track of the user's input
  // value and units
  Unit _fromValue;
  Unit _toValue;
  double _inputValue;
  String _convertedValue = '';
  List <DropdownMenuItem> _unitMenuItems;
  bool _showValidationError = false;

  // TODO: Determine whether you need to override anything, such as initState()

  @override void initState() {
    super.initState();
    _createDropdownMenuItems();
    _setDefaults();
  }

  // TODO: Add other helper functions. We've given you one, _format()

  void _setDefaults() {
    setState(() {
      _fromValue = widget.units[0];
      _toValue = widget.units[1];
    });
  }

  void _createDropdownMenuItems() {

    var newItems = <DropdownMenuItem>[];

    for ( var unit in widget.units ) {
      newItems.add(DropdownMenuItem(
        value: unit.name,
        child: Container(
          child: Text(
            unit.name,
            // // //
          )
        )
      ));
    }

    setState( () {
      _unitMenuItems = newItems;
    });

  }

  /// Clean up conversion; trim trailing zeros, e.g. 5.500 -> 5.5, 10.0 -> 10
  String _format(double conversion) {
    var outputNum = conversion.toStringAsPrecision(7);
    if (outputNum.contains('.') && outputNum.endsWith('0')) {
      var i = outputNum.length - 1;
      while (outputNum[i] == '0') {
        i -= 1;
      }
      outputNum = outputNum.substring(0, i + 1);
    }
    if (outputNum.endsWith('.')) {
      return outputNum.substring(0, outputNum.length - 1);
    }
    return outputNum;
  }

  Widget _createDropdown( String currentValue, ValueChanged<dynamic> onChanged) {
    return Container(
      child: DropdownButton(
        value: currentValue,
        items: _unitMenuItems,
        onChanged: onChanged)
    );
  }

  Unit _getUnit(String unitName) {
    return widget.units.firstWhere(
      (Unit unit) {
        return unit.name == unitName;
      },
      orElse: null
    );
  }
  
  void _updateConversion() {
    setState( () {
      _convertedValue = _format(_inputValue * ( _toValue.conversion / _fromValue.conversion ) );
    });
  }

  void _updateFromConversion(dynamic unitName) {
    setState(() {
      _fromValue = _getUnit(unitName);
    });
    if ( _inputValue != null ) {
      _updateConversion();
    }
  }

  void _updateToConversion(dynamic unitName) {
    setState(() {
      _toValue = _getUnit(unitName);
    });
    if ( _inputValue != null ) {
      _updateConversion();
    }
  }

  void _updateInputValue(String input) {
    setState(() {
      if (input == null || input.isEmpty) {
        _convertedValue = '';
      } else {
        // Even though we are using the numerical keyboard, we still have to check
        // for non-numerical input such as '5..0' or '6 -3'
        try {
          final inputDouble = double.parse(input);
          _showValidationError = false;
          _inputValue = inputDouble;
          _updateConversion();
        } on Exception catch (e) {
          print('Error: $e');
          _showValidationError = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    // TODO: Create the 'input' group of widgets. This is a Column that
    // includes the output value, and 'from' unit [Dropdown].

    final input = Padding(
      padding: _padding,
      child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: 'Input',
            ),
            keyboardType: TextInputType.number,
            onChanged: _updateInputValue,
          ),
          _createDropdown(_fromValue.name, _updateFromConversion)
        ],
      ),
    );

    // TODO: Create a compare arrows icon.

    final arrows = RotatedBox(
      quarterTurns: 1,
      child: Icon(
        Icons.compare_arrows,
        size: 40.0,
      ),
    );

    // TODO: Create the 'output' group of widgets. This is a Column that

    final output = Padding(
      padding: _padding,
      child: Column(
        children: <Widget>[
          Text(
            _convertedValue,
          ),
          _createDropdown(_toValue.name, _updateToConversion)
        ],
      ),
    );

    // TODO: Return the input, arrows, and output widgets, wrapped in

    return Column(
      children: <Widget>[
        input,
        arrows,
        output
      ],
    );

    // TODO: Delete the below placeholder code
    /*
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
    */

  }
}
