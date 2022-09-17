/// Line chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class PointsLineChart extends StatelessWidget {
  final List<charts.Series<dynamic, double>> seriesList;
  final bool animate;

  const PointsLineChart(this.seriesList, {Key? key, required this.animate}) : super(key: key);

  /// Creates a [LineChart] with sample data and no transition.
  factory PointsLineChart.withSampleData(List<LinearSales> list) {
    return  PointsLineChart(
      _createSampleData(list),
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return  charts.LineChart(
        seriesList,
        animate: animate,
        defaultRenderer:  charts.LineRendererConfig(includePoints: true));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, double>> _createSampleData(List<LinearSales> sales) {
    final List<LinearSales> data = sales;

    return [
      charts.Series<LinearSales, double>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        measureFn: (LinearSales sales, _) => sales.event,
        domainFn: (LinearSales sales, _) => sales.data,
        data: data,
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final double event;
  final double data;

  LinearSales(this.event, this.data);
}