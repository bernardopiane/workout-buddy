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
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isSearching
              ? TextField(
                  key: const ValueKey("searchField"),
                  controller: _searchController,
                  autofocus: true,
                  style: Theme.of(context).textTheme.titleLarge,
                  decoration: InputDecoration(
                    hintText: "Search exercises...",
                    hintStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                    border: InputBorder.none,
                  ),
                  onChanged: (query) {
                    setState(() {
                      _searchText = query;
                    });
                  },
                )
              : Align(
                // Fixes the title text alignment jumping to the center
                alignment: Alignment.centerLeft,
                child: Text(
                    "Exercise List Page",
                    key: const ValueKey("pageTitle"),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
              ),
        ),
        actions: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            child: IconButton(
              key: ValueKey(_isSearching ? "closeIcon" : "searchIcon"),
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: _toggleSearch,
            ),
          ),
        ],
      ),
      drawer: SizedBox(
        // Limit the width of the sidebar to 360 dp
        width: MediaQuery.of(context).size.width > 360 ? 360 : null,
        child: ExerciseListSidebar(
          onFilterChanged: onFilterChanged,
          activeFilters: filters,
        ),
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
