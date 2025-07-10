import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkspaceStatusBarWidget extends StatelessWidget {
  final String selectedWorkspace;
  final List<Map<String, dynamic>> workspaces;
  final Function(String) onWorkspaceChanged;

  const WorkspaceStatusBarWidget({
    Key? key,
    required this.selectedWorkspace,
    required this.workspaces,
    required this.onWorkspaceChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF2C2C2E),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF34C759),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => _showWorkspaceSelector(context),
              child: Row(
                children: [
                  Text(
                    selectedWorkspace.isNotEmpty ? selectedWorkspace : 'No Workspace Selected',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF8E8E93),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF34C759).withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${workspaces.length} workspace${workspaces.length != 1 ? 's' : ''}',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF34C759),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showWorkspaceSelector(BuildContext widgetContext) {
    if (workspaces.isEmpty) return;
    
    showModalBottomSheet(
      context: widgetContext,
      backgroundColor: const Color(0xFF191919),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2E),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            Text(
              'Select Workspace',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            
            // Workspace list
            ...workspaces.map((workspace) {
              final workspaceName = workspace['name'] ?? 'Unknown Workspace';
              final isSelected = workspaceName == selectedWorkspace;
              
              return GestureDetector(
                onTap: () {
                  onWorkspaceChanged(workspaceName);
                  Navigator.pop(modalContext);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? const Color(0xFF007AFF).withAlpha(26)
                        : const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected 
                          ? const Color(0xFF007AFF)
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFF34C759),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF191919),
                            width: 2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              workspaceName,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            if (workspace['description'] != null)
                              Text(
                                workspace['description'],
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: const Color(0xFF8E8E93),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF007AFF),
                          size: 20,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}