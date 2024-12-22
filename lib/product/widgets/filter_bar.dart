import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class FilterBar extends StatelessWidget {
  final String? selectedCategory;
  final String sortOrder;
  final List<Map<String, String>> categories;
  final Function(String?) onCategoryChanged;
  final Function(String) onSortOrderChanged;

  const FilterBar({
    Key? key,
    required this.selectedCategory,
    required this.sortOrder,
    required this.categories,
    required this.onCategoryChanged,
    required this.onSortOrderChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Category',
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                border: OutlineInputBorder(),
              ),
              value: selectedCategory,
              items: [
                DropdownMenuItem<String>(
                  value: null,
                  child: Text('All Categories'),
                ),
                ...categories.map((category) => DropdownMenuItem<String>(
                      value: category['value'],
                      child: Text(category['display']!),
                    )),
              ],
              onChanged: onCategoryChanged,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Sort by Price',
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                border: OutlineInputBorder(),
              ),
              value: sortOrder,
              items: [
                DropdownMenuItem<String>(
                  value: 'asc',
                  child: Text('Price: Lowest'),
                ),
                DropdownMenuItem<String>(
                  value: 'desc',
                  child: Text('Price: Highest'),
                ),
              ],
              onChanged: (value) => onSortOrderChanged(value!),
            ),
          ),
        ],
      ),
    );
  }
}
