import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../domain_models/category.dart';
import '../../domain_models/expense.dart';

class StatisticsDoughnutChart extends StatelessWidget {
  final List<Expense> _expensesList;

  const StatisticsDoughnutChart({super.key, required List<Expense> expensesList}) : _expensesList = expensesList;

  @override
  StatelessElement createElement() {
    _generateChartData();
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = _generateChartData();

    return SfCircularChart(
      legend: Legend(
        isVisible: true,
        isResponsive: true,
        overflowMode: LegendItemOverflowMode.wrap
      ),
      series: [
        DoughnutSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (data, _) => data.categoryName,
          yValueMapper: (data, _) => data.totalSpent,
          dataLabelSettings: DataLabelSettings(
            isVisible : true,
            overflowMode: OverflowMode.shift,
            labelPosition: ChartDataLabelPosition.outside
          )
        )
      ],
    );
  }

  List<ChartData> _generateChartData() {
    final List<ChartData> chartData = List.empty(growable: true);
    final Map<int, double> categoriesWithTotals = {};
    final Map<int, Category> categories = {};

    for (Expense expense in _expensesList) {
      if (!categoriesWithTotals.containsKey(expense.category.id)) {
        categoriesWithTotals[expense.category.id!] = 0;
        categories[expense.category.id!] = expense.category;
      }
      categoriesWithTotals[expense.category.id!] = categoriesWithTotals[expense.category.id!]! + expense.amount;
    }
    
    for (MapEntry<int, Category> category in categories.entries) {
      chartData.add(ChartData(category.value.name, categoriesWithTotals[category.key]!));
    }

    return chartData;
  }
}

class ChartData {
  final String categoryName;
  final double totalSpent;
  ChartData(this.categoryName, this.totalSpent);
}