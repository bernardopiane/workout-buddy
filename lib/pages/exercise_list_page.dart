import 'package:flutter/material.dart';
import 'package:workout_buddy/widgets/exercise_list_view.dart';

import '../model/exercise_filters.dart';
import '../widgets/exercise_list_sidebar.dart';

class ExerciseListPage extends StatefulWidget {
  const ExerciseListPage({super.key});

  @override
  State<ExerciseListPage> createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage> {
  ExerciseFilters filters = ExerciseFilters();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchText = "";

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchText = "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_isSearching
            ? const Text("Exercise List Page")
            : TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Search exercises...",
                  border: InputBorder.none,
                ),
                onChanged: (query) {
                  setState(() {
                    _searchText = query;
                    // You can also call a search/filter function here
                  });
                },
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      drawer: ExerciseListSidebar(
        onFilterChanged: onFilterChanged,
        activeFilters: filters,
      ),
      body: ExerciseListView(
        filters: filters,
        searchQuery: _searchText,
      ),
    );
  }

  onFilterChanged(ExerciseFilters newFilters) {
    debugPrint("Filters changed to: $newFilters");
    setState(() {
      filters = newFilters;
    });
    debugPrint("Active filters: ${filters.toString()}");
  }
}
