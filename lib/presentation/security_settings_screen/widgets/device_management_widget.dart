import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeviceManagementWidget extends StatefulWidget {
  const DeviceManagementWidget({super.key});

  @override
  State<DeviceManagementWidget> createState() => _DeviceManagementWidgetState();
}

class _DeviceManagementWidgetState extends State<DeviceManagementWidget> {
  final List<Map<String, dynamic>> _devices = [
{ 'name': 'iPhone 15 Pro',
'platform': 'iOS',
'location': 'San Francisco, CA',
'lastActivity': '2 minutes ago',
'isCurrent': true,
'icon': Icons.phone_iphone,
},
{ 'name': 'MacBook Pro',
'platform': 'macOS',
'location': 'San Francisco, CA',
'lastActivity': '1 hour ago',
'isCurrent': false,
'icon': Icons.laptop_mac,
},
{ 'name': 'Chrome Browser',
'platform': 'Windows',
'location': 'New York, NY',
'lastActivity': '2 days ago',
'isCurrent': false,
'icon': Icons.computer,
},
];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF191919),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF282828),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.devices,
                    color: Color(0xFFF1F1F1),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Device Management',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFF1F1F1),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  _showLoginHistoryDialog();
                },
                child: Text(
                  'View History',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF2196F3),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...List.generate(_devices.length, (index) {
            final device = _devices[index];
            return _buildDeviceCard(device, index);
          }),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(Map<String, dynamic> device, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: index == _devices.length - 1 ? 0 : 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF101010),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF282828),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF191919),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  device['icon'],
                  color: const Color(0xFFF1F1F1),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          device['name'],
                          style: GoogleFonts.inter(
                            color: const Color(0xFFF1F1F1),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (device['isCurrent'])
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50).withAlpha(26),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Current',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF4CAF50),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      device['platform'],
                      style: GoogleFonts.inter(
                        color: const Color(0xFF7B7B7B),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              if (!device['isCurrent'])
                GestureDetector(
                  onTap: () {
                    _showLogoutConfirmation(device['name']);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5252).withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.logout,
                      color: Color(0xFFFF5252),
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Color(0xFF7B7B7B),
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                device['location'],
                style: GoogleFonts.inter(
                  color: const Color(0xFF7B7B7B),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.access_time,
                color: Color(0xFF7B7B7B),
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                device['lastActivity'],
                style: GoogleFonts.inter(
                  color: const Color(0xFF7B7B7B),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(String deviceName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF191919),
        title: Text(
          'Logout Device',
          style: GoogleFonts.inter(
            color: const Color(0xFFF1F1F1),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to logout $deviceName? This will end the session on that device.',
          style: GoogleFonts.inter(
            color: const Color(0xFF7B7B7B),
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: const Color(0xFF7B7B7B)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle device logout
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5252),
              foregroundColor: const Color(0xFFFDFDFD),
            ),
            child: Text(
              'Logout',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  void _showLoginHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF191919),
        title: Text(
          'Login History',
          style: GoogleFonts.inter(
            color: const Color(0xFFF1F1F1),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLoginHistoryItem(
                'Successful Login',
                'iPhone 15 Pro',
                'San Francisco, CA',
                '2 minutes ago',
                true,
              ),
              _buildLoginHistoryItem(
                'Successful Login',
                'MacBook Pro',
                'San Francisco, CA',
                '1 hour ago',
                true,
              ),
              _buildLoginHistoryItem(
                'Failed Login Attempt',
                'Unknown Device',
                'Unknown Location',
                '2 days ago',
                false,
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFDFDFD),
              foregroundColor: const Color(0xFF141414),
            ),
            child: Text(
              'Close',
              style: GoogleFonts.inter(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginHistoryItem(
    String status,
    String device,
    String location,
    String time,
    bool isSuccessful,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF101010),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF282828),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSuccessful ? Icons.check_circle : Icons.warning,
            color: isSuccessful
                ? const Color(0xFF4CAF50)
                : const Color(0xFFFF5252),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: GoogleFonts.inter(
                    color: const Color(0xFFF1F1F1),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$device • $location',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF7B7B7B),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: GoogleFonts.inter(
              color: const Color(0xFF7B7B7B),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
