import 'package:material_ui/material_ui.dart';

class TerminalLogCard extends StatefulWidget {
  final List<String> logs;
  final VoidCallback onRefresh;

  const TerminalLogCard({
    super.key,
    required this.logs,
    required this.onRefresh,
  });

  @override
  State<TerminalLogCard> createState() => _TerminalLogCardState();
}

class _TerminalLogCardState extends State<TerminalLogCard> {
  final ScrollController _scrollController = ScrollController();
  final bool _autoScroll = true;

  @override
  void didUpdateWidget(covariant TerminalLogCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_autoScroll && widget.logs.length != oldWidget.logs.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: const Color(0xFF1E222B),
            child: Row(
              children: [
                const Icon(Icons.terminal, color: Colors.greenAccent, size: 18),
                const SizedBox(width: 8),
                const Text(
                  'Node B & PBX Service Logs',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const Spacer(),
                Text(
                  'Tail: ${widget.logs.length}',
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white70, size: 16),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Reload Logs',
                  onPressed: widget.onRefresh,
                ),
              ],
            ),
          ),
          Container(
            height: 180,
            color: const Color(0xFF0F141C),
            padding: const EdgeInsets.all(12),
            child: widget.logs.isEmpty
                ? const Center(
                    child: Text(
                      'No logs captured yet.',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: widget.logs.length,
                    itemBuilder: (context, index) {
                      final line = widget.logs[index];
                      Color textColor = Colors.white70;

                      if (line.contains('[FIELD_TEST]')) {
                        textColor = Colors.lightBlueAccent;
                      } else if (line.contains('[SYSTEM]')) {
                        textColor = Colors.greenAccent;
                      } else if (line.contains('ERROR') || line.contains('FAIL')) {
                        textColor = Colors.redAccent;
                      } else if (line.contains('WARN')) {
                        textColor = Colors.amberAccent;
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(
                          line,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            color: textColor,
                            fontSize: 11,
                            height: 1.3,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
