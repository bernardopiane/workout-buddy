import 'package:flutter/material.dart';

const defaultPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);

const LinearGradient primaryGradient = LinearGradient(
  begin: Alignment.topLeft, // Corresponds to 135deg
  end: Alignment.bottomRight, // Corresponds to 135deg
  colors: [
    Color(0xFF667EEA), // #667eea
    Color(0xFF764BA2), // #764ba2
  ],
);

const LinearGradient secondaryGradient = LinearGradient(
  begin: Alignment.topLeft, // Corresponds to 135deg
  end: Alignment.bottomRight, // Corresponds to 135deg
  colors: [
    Color(0xFFF093FB), // #f093fb
    Color(0xFFF5576C), // #f5576c
  ],
);
