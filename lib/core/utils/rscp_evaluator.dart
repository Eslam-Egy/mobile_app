class RscpEvaluator {
  static String getQualityLabel(double rscpDbm) {
    if (rscpDbm >= -70) return 'Excellent (Near Antenna)';
    if (rscpDbm >= -85) return 'Good (Lab Room)';
    if (rscpDbm >= -100) return 'Fair (Obstructed)';
    return 'Poor (Cell Edge / Hallway)';
  }

  static double normalizeProgress(double rscpDbm) {
    // Maps -115 dBm -> 0.0, -40 dBm -> 1.0
    final clamped = rscpDbm.clamp(-115.0, -40.0);
    return (clamped + 115.0) / 75.0;
  }
}
