import 'package:flutter/material.dart';
import 'package:simple_expense_tracking/ui/summary_screen/summary_screen_view_model.dart';

class SummaryScreen extends StatefulWidget {
  final SummaryScreenViewModel _viewModel;

  const SummaryScreen({super.key, required SummaryScreenViewModel viewModel}) : _viewModel = viewModel;

  @override
  State<StatefulWidget> createState() => SummaryScreenState();
}

class SummaryScreenState extends State<SummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          Card(
            color: Theme.of(context).colorScheme.secondaryContainer,
            elevation: 4,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6,
                children: [
                  Text(
                    'Total spent',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  ListenableBuilder(
                    listenable: widget._viewModel,
                    builder: (context, child) {
                      return RichText(
                        text: TextSpan(
                          text: "\$${widget._viewModel.totalSpent.toString()} ",
                          style: Theme.of(context).textTheme.displaySmall,
                          children: [
                            TextSpan(
                              text: widget._viewModel.currency,
                              style: Theme.of(context).textTheme.titleLarge,
                            )
                          ]
                        ),
                      );
                    }
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}