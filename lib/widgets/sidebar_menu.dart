import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onClose;

  const SidebarMenu({
    super.key,
    required this.isDarkMode,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(16, 12, 8, 0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search conversations...',
                    hintStyle: TextStyle(
                      color: isDarkMode ? Color(0xFF71717A) : Color(0xFFA1A1AA),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  style: TextStyle(
                    color: isDarkMode ? Color(0xFFFAFAFA) : Color(0xFF09090B),
                  ),
                ),
              ),
              SizedBox(width: 4),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: onClose,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.chevron_left,
                      color: isDarkMode ? Color(0xFFFAFAFA) : Color(0xFF09090B),
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: isDarkMode ? Color(0xFF27272A) : Color(0xFFE4E4E7),
          thickness: 1,
          height: 1,
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildConversationItem('How to use Flutter'),
              _buildConversationItem('API integration help'),
              _buildConversationItem('Dark mode implementation'),
              _buildConversationItem('State management tips'),
              _buildConversationItem('Animation best practices'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConversationItem(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? Color(0xFF27272A) : Color(0xFFE4E4E7),
            width: 1,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? Color(0xFFFAFAFA) : Color(0xFF09090B),
          fontSize: 14,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
