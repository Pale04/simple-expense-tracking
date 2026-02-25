import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_expense_tracking/ui/categories/categories_screen_view_model.dart';
import '../../domain_models/category.dart';
import '../../domain_models/identification_color.dart';

class CategoriesScreen extends StatefulWidget {
  final CategoriesScreenViewModel _viewModel;

  const CategoriesScreen({super.key, required CategoriesScreenViewModel viewModel}) : _viewModel = viewModel;

  @override
  State<CategoriesScreen> createState() => CategoriesScreenState();
}

class CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Colors.white
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              ),
              onPressed: () => GoRouter.of(context).pop(),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal:  14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.tonal(
              onPressed: () => {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: const Text('Add category'),
                      children: [
                        CategoryRegistrationForm(onSaveCategory: widget._viewModel.addCategory)
                      ],
                    );
                  }
                )
              }, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 10,
                children: [
                  Icon(
                      Icons.add
                  ),
                  Text('Add category'),
                ],
              )
            ),
            Divider(),
            ListenableBuilder(
              listenable: widget._viewModel,
              builder: (context, child) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: widget._viewModel.expenseCategories.length,
                    itemBuilder: (context, index) {
                      return Card.outlined(
                        clipBehavior: Clip.hardEdge,
                        margin: EdgeInsetsGeometry.only(top: 10),
                        child: InkWell(
                          splashColor: Theme.of(context).colorScheme.onTertiary,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return SimpleDialog(
                                  title: const Text('Options'),
                                  children: [
                                    SimpleDialogOption(
                                      onPressed: () {
                                        widget._viewModel.deleteCategory(widget._viewModel.expenseCategories[index].id!);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete'),
                                    )
                                  ],
                                );
                              }
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(10, 8, 14, 8),
                            child: Row (
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget._viewModel.expenseCategories[index].name,
                                  style: Theme.of(context).textTheme.labelLarge
                                ),
                                Icon(
                                  Icons.circle,
                                  color: Color(widget._viewModel.expenseCategories[index].color.hexCode),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                );
              }
            )
          ],  
        ),
      ),
    );
  }
}

class CategoryRegistrationForm extends StatefulWidget {
  final void Function (Category) _onSaveCategory;

  const CategoryRegistrationForm({super.key, required void Function (Category) onSaveCategory}) : _onSaveCategory = onSaveCategory;

  @override
  State<StatefulWidget> createState() => CategoryRegistrationFormState();
}

class CategoryRegistrationFormState extends State<CategoryRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  late IdentificationColor _selectedColor;

  @override
  void initState() {
    _selectedColor = IdentificationColor.orange;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 15),
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              validator: (value) => value == null || value.trim().isEmpty ? 'Enter a name' : null,
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Category name',
                border: OutlineInputBorder()
              )
            ),
            DropdownButtonFormField<IdentificationColor>(
              initialValue: _selectedColor,
              decoration: const InputDecoration(
                labelText: 'Color',
                border: OutlineInputBorder(),
              ),
              items: IdentificationColor.values.map((IdentificationColor color) {
                return DropdownMenuItem<IdentificationColor>(
                  value: color,
                  child: Row (
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(color.name),
                      Icon(
                        Icons.circle,
                        color: Color(color.hexCode),
                      )
                    ],
                  ),
                );
              }).toList(),
              onChanged: (selectedColor) {
                _selectedColor = selectedColor ?? _selectedColor;
              },
              validator: (value) => value == null ? 'Select a color' : null,
            ),
            FilledButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Category category = Category(name: _nameController.text, color: _selectedColor);
                  widget._onSaveCategory(category);
                  context.pop(true);
                }
              },
              child: Text('Add category'),
            )
          ],
        )
      ),
    );
  }
}