import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

/// Custom dark-mode title bar for desktop app
/// Replaces the default Windows title bar with a custom design
class CustomTitleBar extends StatefulWidget {
  final String title;
  final bool isCompactMode;
  final VoidCallback? onCompactToggle;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final VoidCallback? onClose;

  const CustomTitleBar({
    super.key,
    required this.title,
    this.isCompactMode = false,
    this.onCompactToggle,
    this.onMinimize,
    this.onMaximize,
    this.onClose,
  });

  @override
  State<CustomTitleBar> createState() => _CustomTitleBarState();
}

class _CustomTitleBarState extends State<CustomTitleBar> with WindowListener {
  bool _isMaximized = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _updateWindowState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  Future<void> _updateWindowState() async {
    final isMax = await windowManager.isMaximized();
    setState(() {
      _isMaximized = isMax;
    });
  }

  @override
  void onWindowMaximize() {
    setState(() {
      _isMaximized = true;
    });
  }

  @override
  void onWindowUnmaximize() {
    setState(() {
      _isMaximized = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.isCompactMode ? 60 : 50,
      color: const Color(0xFF1E1E1E), // Dark gray background
      child: Row(
        children: [
          // Left side: Title and icon
          Expanded(
            child: DragToMoveArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.school,
                      color: Colors.deepPurple,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Compact mode indicator
                    if (widget.isCompactMode)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.2),
                          border: Border.all(color: Colors.amber, width: 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.fullscreen_exit,
                              size: 12,
                              color: Colors.amber,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'STUDY MODE',
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // Right side: Window control buttons
          if (!widget.isCompactMode)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Compact study mode button
                _TitleBarButton(
                  icon: Icons.fullscreen_exit,
                  tooltip: 'Compact Study Mode',
                  onPressed: widget.onCompactToggle,
                ),
                const SizedBox(width: 8),
                // Minimize button
                _TitleBarButton(
                  icon: Icons.minimize,
                  tooltip: 'Minimize',
                  onPressed: widget.onMinimize,
                ),
                const SizedBox(width: 8),
                // Maximize/Restore button
                _TitleBarButton(
                  icon: _isMaximized ? Icons.fullscreen_exit : Icons.fullscreen,
                  tooltip: _isMaximized ? 'Restore' : 'Maximize',
                  onPressed: widget.onMaximize,
                ),
                const SizedBox(width: 8),
                // Close button
                _TitleBarButton(
                  icon: Icons.close,
                  tooltip: 'Close',
                  onPressed: widget.onClose,
                  isCloseButton: true,
                ),
                const SizedBox(width: 8),
              ],
            )
          else
            // Compact mode: only show exit button
            _TitleBarButton(
              icon: Icons.fullscreen,
              tooltip: 'Exit Study Mode',
              onPressed: widget.onCompactToggle,
            ),
        ],
      ),
    );
  }
}

/// Individual title bar control button
class _TitleBarButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool isCloseButton;

  const _TitleBarButton({
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.isCloseButton = false,
  });

  @override
  State<_TitleBarButton> createState() => _TitleBarButtonState();
}

class _TitleBarButtonState extends State<_TitleBarButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Container(
            width: 40,
            height: 40,
            color: _isHovered
                ? (widget.isCloseButton
                      ? Colors.red.withValues(alpha: 0.7)
                      : Colors.white.withValues(alpha: 0.1))
                : Colors.transparent,
            child: Center(
              child: Icon(
                widget.icon,
                size: 18,
                color: widget.isCloseButton && _isHovered
                    ? Colors.white
                    : Colors.grey[300],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
