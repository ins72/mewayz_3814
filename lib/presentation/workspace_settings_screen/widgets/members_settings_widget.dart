import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class MembersSettingsWidget extends StatefulWidget {
  final VoidCallback onChanged;

  const MembersSettingsWidget({
    super.key,
    required this.onChanged,
  });

  @override
  State<MembersSettingsWidget> createState() => _MembersSettingsWidgetState();
}

class _MembersSettingsWidgetState extends State<MembersSettingsWidget> {
  final List<Member> _members = [
    Member(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        role: 'Owner',
        avatarUrl:
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        joinedAt: DateTime.now().subtract(const Duration(days: 30)),
        isActive: true),
    Member(
        id: '2',
        name: 'Jane Smith',
        email: 'jane@example.com',
        role: 'Admin',
        avatarUrl:
            'https://images.unsplash.com/photo-1494790108755-2616b639009c?w=150&h=150&fit=crop&crop=face',
        joinedAt: DateTime.now().subtract(const Duration(days: 15)),
        isActive: true),
    Member(
        id: '3',
        name: 'Bob Johnson',
        email: 'bob@example.com',
        role: 'Editor',
        avatarUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
        joinedAt: DateTime.now().subtract(const Duration(days: 7)),
        isActive: false),
  ];

  final List<String> _roles = ['Owner', 'Admin', 'Editor', 'Viewer'];
  bool _selectAll = false;
  final Set<String> _selectedMembers = {};

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildInviteSection(),
          const SizedBox(height: 24),
          _buildMembersHeader(),
          const SizedBox(height: 16),
          _buildMembersList(),
          const SizedBox(height: 24),
          _buildBulkActions(),
        ]));
  }

  Widget _buildHeader() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('Team Members',
          style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryText)),
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
              color: AppTheme.accent.withAlpha(26),
              borderRadius: BorderRadius.circular(12)),
          child: Text('${_members.length} members',
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.accent))),
    ]);
  }

  Widget _buildInviteSection() {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Invite New Members',
              style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText)),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
                child: TextFormField(
                    decoration: InputDecoration(
                        hintText: 'Enter email address',
                        prefixIcon: const Icon(Icons.email,
                            color: AppTheme.secondaryText),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: AppTheme.border)),
                        filled: true,
                        fillColor: AppTheme.primaryBackground),
                    style: GoogleFonts.inter(
                        fontSize: 16, color: AppTheme.primaryText))),
            const SizedBox(width: 12),
            Container(
                decoration: BoxDecoration(
                    color: AppTheme.primaryBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.border)),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                        value: 'Editor',
                        items: _roles.map((role) {
                          return DropdownMenuItem(
                              value: role, child: Text(role));
                        }).toList(),
                        onChanged: (value) {
                          widget.onChanged();
                        },
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        style: GoogleFonts.inter(
                            fontSize: 14, color: AppTheme.primaryText),
                        dropdownColor: AppTheme.surface))),
            const SizedBox(width: 12),
            ElevatedButton(
                onPressed: () {
                  // TODO: Implement invite functionality
                  widget.onChanged();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryAction,
                    foregroundColor: AppTheme.primaryBackground,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: Text('Invite',
                    style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w500))),
          ]),
        ]));
  }

  Widget _buildMembersHeader() {
    return Row(children: [
      Checkbox(
          value: _selectAll,
          onChanged: (value) {
            setState(() {
              _selectAll = value ?? false;
              if (_selectAll) {
                _selectedMembers.addAll(_members.map((m) => m.id));
              } else {
                _selectedMembers.clear();
              }
            });
          }),
      const SizedBox(width: 8),
      Text('Select All',
          style:
              GoogleFonts.inter(fontSize: 14, color: AppTheme.secondaryText)),
      const Spacer(),
      IconButton(
          onPressed: () {
            // TODO: Implement filter functionality
          },
          icon: const Icon(Icons.filter_list, color: AppTheme.secondaryText)),
      IconButton(
          onPressed: () {
            // TODO: Implement sort functionality
          },
          icon: const Icon(Icons.sort, color: AppTheme.secondaryText)),
    ]);
  }

  Widget _buildMembersList() {
    return Column(
        children: _members.map((member) => _buildMemberCard(member)).toList());
  }

  Widget _buildMemberCard(Member member) {
    final isSelected = _selectedMembers.contains(member.id);

    return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: isSelected ? AppTheme.accent : AppTheme.border,
                width: isSelected ? 2 : 1)),
        child: Row(children: [
          Checkbox(
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value ?? false) {
                    _selectedMembers.add(member.id);
                  } else {
                    _selectedMembers.remove(member.id);
                  }
                });
              }),
          const SizedBox(width: 12),
          CircleAvatar(
              radius: 24,
              backgroundColor: AppTheme.primaryBackground,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: CustomImageWidget(
                      imageUrl: member.avatarUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover))),
          const SizedBox(width: 16),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(children: [
                  Text(member.name,
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryText)),
                  const SizedBox(width: 8),
                  Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: member.isActive
                              ? AppTheme.success
                              : AppTheme.secondaryText)),
                ]),
                const SizedBox(height: 4),
                Text(member.email,
                    style: GoogleFonts.inter(
                        fontSize: 14, color: AppTheme.secondaryText)),
                const SizedBox(height: 4),
                Text('Joined ${_formatDate(member.joinedAt)}',
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppTheme.secondaryText)),
              ])),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: _getRoleColor(member.role).withAlpha(26),
                  borderRadius: BorderRadius.circular(12)),
              child: Text(member.role,
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _getRoleColor(member.role)))),
          const SizedBox(width: 12),
          PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppTheme.secondaryText),
              color: AppTheme.surface,
              onSelected: (value) {
                _handleMemberAction(member, value);
              },
              itemBuilder: (context) => [
                    PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit Role',
                            style: GoogleFonts.inter(
                                color: AppTheme.primaryText))),
                    PopupMenuItem(
                        value: 'remove',
                        child: Text('Remove',
                            style: GoogleFonts.inter(color: AppTheme.error))),
                  ]),
        ]));
  }

  Widget _buildBulkActions() {
    if (_selectedMembers.isEmpty) return const SizedBox.shrink();

    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border)),
        child: Row(children: [
          Text('${_selectedMembers.length} selected',
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryText)),
          const Spacer(),
          OutlinedButton(
              onPressed: () {
                // TODO: Implement bulk role change
                widget.onChanged();
              },
              style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryText,
                  side: const BorderSide(color: AppTheme.border),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
              child: Text('Change Role',
                  style: GoogleFonts.inter(
                      fontSize: 14, fontWeight: FontWeight.w500))),
          const SizedBox(width: 12),
          OutlinedButton(
              onPressed: () {
                // TODO: Implement bulk remove
                widget.onChanged();
              },
              style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.error,
                  side: const BorderSide(color: AppTheme.error),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
              child: Text('Remove',
                  style: GoogleFonts.inter(
                      fontSize: 14, fontWeight: FontWeight.w500))),
        ]));
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Owner':
        return AppTheme.warning;
      case 'Admin':
        return AppTheme.accent;
      case 'Editor':
        return AppTheme.success;
      case 'Viewer':
        return AppTheme.secondaryText;
      default:
        return AppTheme.secondaryText;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else {
      return 'Today';
    }
  }

  void _handleMemberAction(Member member, String action) {
    switch (action) {
      case 'edit':
        // TODO: Implement edit role dialog
        break;
      case 'remove':
        // TODO: Implement remove member
        break;
    }
    widget.onChanged();
  }
}

class Member {
  final String id;
  final String name;
  final String email;
  final String role;
  final String avatarUrl;
  final DateTime joinedAt;
  final bool isActive;

  Member({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.avatarUrl,
    required this.joinedAt,
    required this.isActive,
  });
}