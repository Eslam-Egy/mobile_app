import 'package:material_ui/material_ui.dart';

class ConnectionBannerWidget extends StatelessWidget {
  final bool isConnected;
  final bool isLoading;
  final String serverUrl;
  final double? latencyMs;
  final VoidCallback onRetry;
  final VoidCallback onOpenSettings;

  const ConnectionBannerWidget({
    super.key,
    required this.isConnected,
    required this.isLoading,
    required this.serverUrl,
    this.latencyMs,
    required this.onRetry,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color bgColor = isConnected
        ? (isDark ? const Color(0xFF1B382B) : const Color(0xFFE8F5E9))
        : (isDark ? const Color(0xFF3E1C1C) : const Color(0xFFFFEBEE));

    final Color fgColor = isConnected
        ? (isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32))
        : (isDark ? const Color(0xFFE57373) : const Color(0xFFC62828));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          bottom: BorderSide(
            color: fgColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (isLoading)
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: fgColor,
              ),
            )
          else
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: fgColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: fgColor.withValues(alpha: 0.5),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      isConnected ? 'Host Laptop Online' : 'Laptop Host Offline',
                      style: TextStyle(
                        color: fgColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    if (latencyMs != null && isConnected) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: fgColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${latencyMs!.toStringAsFixed(1)} ms',
                          style: TextStyle(
                            color: fgColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  'Plane: Lab Wi-Fi ($serverUrl)',
                  style: TextStyle(
                    color: fgColor.withValues(alpha: 0.85),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            color: fgColor,
            tooltip: 'Retry Connection',
            onPressed: onRetry,
          ),
          IconButton(
            icon: const Icon(Icons.settings, size: 20),
            color: fgColor,
            tooltip: 'Server Settings',
            onPressed: onOpenSettings,
          ),
        ],
      ),
    );
  }
}
