import 'package:flutter/material.dart';

class MuscleColumn extends StatefulWidget {
  final String title;
  final List<String>? muscles;
  final Color? chipColor;
  final Color? textColor;
  final double spacing;
  final bool animateExpansion;
  final VoidCallback? onExpansionChanged;

  const MuscleColumn({
    super.key,
    required this.title,
    required this.muscles,
    this.chipColor,
    this.textColor,
    this.spacing = 8.0,
    this.animateExpansion = true,
    this.onExpansionChanged,
  });

  @override
  State<MuscleColumn> createState() => _MuscleColumnState();
}

class _MuscleColumnState extends State<MuscleColumn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muscles = widget.muscles ?? [];

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(theme),
            const SizedBox(height: 12.0),
            if (muscles.isNotEmpty) _buildMusclesList(muscles, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      widget.title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildMusclesList(List<String> muscles, ThemeData theme) {
    final visibleMuscles = muscles.take(2).toList();
    final List<String> hiddenMuscles = muscles.length > 2 ? muscles.sublist(2) : [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: widget.spacing,
          runSpacing: widget.spacing / 2,
          children: visibleMuscles.map((muscle) => _buildChip(muscle, theme)).toList(),
        ),
        if (hiddenMuscles.isNotEmpty) ...[
          const SizedBox(height: 8.0),
          _buildExpandableSection(hiddenMuscles, theme),
        ],
      ],
    );
  }

  Widget _buildExpandableSection(List<String> hiddenMuscles, ThemeData theme) {
    return Column(
      children: [
        InkWell(
          onTap: _toggleExpansion,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isExpanded ? 'Show Less' : 'Show More (${hiddenMuscles.length})',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4.0),
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 0.5).animate(_expandAnimation),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.animateExpansion)
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: _buildHiddenMuscles(hiddenMuscles, theme),
          )
        else if (_isExpanded)
          _buildHiddenMuscles(hiddenMuscles, theme),
      ],
    );
  }

  Widget _buildHiddenMuscles(List<String> hiddenMuscles, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Wrap(
        spacing: widget.spacing,
        runSpacing: widget.spacing / 2,
        children: hiddenMuscles.map((muscle) => _buildChip(muscle, theme)).toList(),
      ),
    );
  }

  Widget _buildChip(String muscle, ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: Chip(
        label: Text(
          muscle.toUpperCase(),
          style: theme.textTheme.bodySmall?.copyWith(
            color: widget.textColor ?? theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: widget.chipColor ?? theme.colorScheme.primary,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
      ),
    );
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      widget.onExpansionChanged?.call();
    });
  }
}