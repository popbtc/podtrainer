import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/available_pod_card.dart';
import './widgets/connected_pod_card.dart';
import './widgets/empty_state_widget.dart';
import './widgets/pods_header_widget.dart';
import './widgets/scan_button_widget.dart';
import './widgets/skeleton_pod_card.dart';
import '../../widgets/custom_tab_bar.dart';

class PodsManagementScreen extends StatefulWidget {
  const PodsManagementScreen({super.key});

  @override
  State<PodsManagementScreen> createState() => _PodsManagementScreenState();
}

class _PodsManagementScreenState extends State<PodsManagementScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  late AnimationController _scanAnimationController;
  int _currentBottomIndex = 3; // Changed from 2 to 3 (Pods tab)
  bool _isScanning = false;
  bool _isLoading = true;
  bool _bluetoothEnabled = true;
  bool _permissionGranted = true;
  String? _connectingPodId;

  // Add this property to implement AutomaticKeepAliveClientMixin
  @override
  bool get wantKeepAlive => true;

  // Mock data for connected pods
  final List<Map<String, dynamic>> _connectedPods = [
    {
      "id": "pod_001",
      "name": "Training Pod Alpha",
      "signalStrength": 85,
      "batteryLevel": 78,
      "status": "connected",
      "lastConnected": DateTime.now().subtract(const Duration(minutes: 5)),
    },
    {
      "id": "pod_002",
      "name": "Training Pod Beta",
      "signalStrength": 92,
      "batteryLevel": 45,
      "status": "connected",
      "lastConnected": DateTime.now().subtract(const Duration(minutes: 12)),
    },
    {
      "id": "pod_003",
      "name": "Training Pod Gamma",
      "signalStrength": 67,
      "batteryLevel": 23,
      "status": "connected",
      "lastConnected": DateTime.now().subtract(const Duration(hours: 1)),
    },
  ];

  // Mock data for available pods
  List<Map<String, dynamic>> _availablePods = [
    {
      "id": "pod_004",
      "name": "Training Pod Delta",
      "deviceId": "BT:AA:BB:CC:DD:EE",
      "signalStrength": 72,
      "isKnownDevice": false,
    },
    {
      "id": "pod_005",
      "name": "Training Pod Echo",
      "deviceId": "BT:FF:GG:HH:II:JJ",
      "signalStrength": 58,
      "isKnownDevice": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scanAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _initializeBluetooth();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scanAnimationController.dispose();
    super.dispose();
  }

  Future<void> _initializeBluetooth() async {
    // Simulate initialization delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _startScanning() async {
    if (!_bluetoothEnabled) {
      _showBluetoothDisabledDialog();
      return;
    }

    if (!_permissionGranted) {
      _showPermissionDialog();
      return;
    }

    setState(() {
      _isScanning = true;
      _availablePods.clear();
    });

    HapticFeedback.mediumImpact();

    // Simulate scanning process
    await Future.delayed(const Duration(seconds: 1));

    // Add discovered pods gradually
    for (int i = 0; i < 3; i++) {
      await Future.delayed(const Duration(seconds: 2));
      if (_isScanning && mounted) {
        setState(() {
          _availablePods.add({
            "id": "discovered_pod_$i",
            "name": "Training Pod ${String.fromCharCode(65 + i)}",
            "deviceId":
                "BT:${i.toString().padLeft(2, '0')}:${i.toString().padLeft(2, '0')}:${i.toString().padLeft(2, '0')}:${i.toString().padLeft(2, '0')}:${i.toString().padLeft(2, '0')}",
            "signalStrength": 60 + (i * 10),
            "isKnownDevice": i == 1,
          });
        });
      }
    }

    // Simulate scan timeout
    await Future.delayed(const Duration(seconds: 25));
    if (_isScanning && mounted) {
      setState(() {
        _isScanning = false;
      });

      if (_availablePods.isEmpty) {
        _showEmptyState(EmptyStateType.scanningTimeout);
      }
    }
  }

  void _stopScanning() {
    setState(() {
      _isScanning = false;
    });
    HapticFeedback.lightImpact();
  }

  Future<void> _connectToPod(Map<String, dynamic> podData) async {
    final podId = podData['id'] as String;

    setState(() {
      _connectingPodId = podId;
    });

    HapticFeedback.lightImpact();

    // Simulate connection process
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        _connectingPodId = null;

        // Move pod from available to connected
        _availablePods.removeWhere((pod) => pod['id'] == podId);
        _connectedPods.add({
          ...podData,
          'status': 'connected',
          'batteryLevel': 85,
          'lastConnected': DateTime.now(),
        });
      });

      HapticFeedback.mediumImpact();
      _showConnectionSuccessSnackBar(podData['name'] as String);
    }
  }

  Future<void> _disconnectFromPod(Map<String, dynamic> podData) async {
    final podId = podData['id'] as String;

    setState(() {
      _connectedPods.removeWhere((pod) => pod['id'] == podId);
    });

    HapticFeedback.mediumImpact();
    _showDisconnectionSnackBar(podData['name'] as String);
  }

  Future<void> _forgetPod(Map<String, dynamic> podData) async {
    final podId = podData['id'] as String;

    setState(() {
      _connectedPods.removeWhere((pod) => pod['id'] == podId);
    });

    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${podData['name']} has been forgotten'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _connectedPods.add(podData);
            });
          },
        ),
      ),
    );
  }

  void _openPodSettings(Map<String, dynamic> podData) {
    Navigator.pushNamed(context, '/pod-settings-screen');
  }

  void _renamePod(Map<String, dynamic> podData) {
    _showRenameDialog(podData);
  }

  Future<void> _refreshPods() async {
    HapticFeedback.lightImpact();

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  int get _totalBatteryLevel {
    if (_connectedPods.isEmpty) return 0;
    final total = _connectedPods.fold<int>(
      0,
      (sum, pod) => sum + (pod['batteryLevel'] as int? ?? 0),
    );
    return (total / _connectedPods.length).round();
  }

  bool get _hasLowBattery {
    return _connectedPods.any(
      (pod) => (pod['batteryLevel'] as int? ?? 100) < 25,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CustomAppBar(
        variant: CustomAppBarVariant.standard,
        title: 'Pod Management',
      ),
      body: _isLoading ? _buildLoadingState() : _buildMainContent(),
      bottomNavigationBar: CustomBottomBar(
        variant: CustomBottomBarVariant.standard,
        currentIndex: _currentBottomIndex,
        onTap: (index) {
          setState(() {
            _currentBottomIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        PodsHeaderWidget(connectedCount: 0),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            itemCount: 3,
            itemBuilder: (context, index) => const SkeletonPodCard(),
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        // Header with stats (without battery average)
        PodsHeaderWidget(
          connectedCount: _connectedPods.length,
          hasLowBattery: _hasLowBattery,
        ),

        // Tab Bar
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          child: CustomTabBar(
            variant: CustomTabBarVariant.standard,
            controller: _tabController,
            tabs: const [
              'Connected Pods',
              'Available Pods',
            ],
          ),
        ),

        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [_buildConnectedPodsTab(), _buildAvailablePodsTab()],
          ),
        ),
      ],
    );
  }

  Widget _buildConnectedPodsTab() {
    if (_connectedPods.isEmpty) {
      return const EmptyStateWidget(type: EmptyStateType.noPodsFound);
    }

    return RefreshIndicator(
      onRefresh: _refreshPods,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        itemCount: _connectedPods.length,
        itemBuilder: (context, index) {
          final pod = _connectedPods[index];
          return ConnectedPodCard(
            podData: pod,
            onDisconnect: () => _disconnectFromPod(pod),
            onSettings: () => _openPodSettings(pod),
            onRename: () => _renamePod(pod),
            onForget: () => _forgetPod(pod),
          );
        },
      ),
    );
  }

  Widget _buildAvailablePodsTab() {
    return Column(
      children: [
        // Scan button
        ScanButtonWidget(
          isScanning: _isScanning,
          onScan: _startScanning,
          onStopScan: _stopScanning,
        ),

        // Available pods list
        Expanded(
          child: _isScanning && _availablePods.isEmpty
              ? _buildScanningState()
              : _availablePods.isEmpty
                  ? EmptyStateWidget(
                      type: EmptyStateType.noPodsFound,
                      onRetry: _startScanning,
                    )
                  : RefreshIndicator(
                      onRefresh: _refreshPods,
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        itemCount: _availablePods.length,
                        itemBuilder: (context, index) {
                          final pod = _availablePods[index];
                          final isConnecting = _connectingPodId == pod['id'];

                          return AvailablePodCard(
                            podData: pod,
                            isConnecting: isConnecting,
                            onConnect: () => _connectToPod(pod),
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _buildScanningState() {
    return Column(
      children: [
        SizedBox(height: 4.h),
        const SkeletonPodCard(),
        const SkeletonPodCard(),
        const SkeletonPodCard(),
        SizedBox(height: 2.h),
        Text(
          'Scanning for pods...',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
        ),
      ],
    );
  }

  void _showBluetoothDisabledDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bluetooth Disabled'),
        content: const Text(
          'Bluetooth is required to connect to training pods. Please enable Bluetooth in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // In a real app, this would open system settings
            },
            child: const Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'PodTrainer needs Bluetooth permission to discover and connect to training pods. Please grant permission to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _permissionGranted = true;
              });
            },
            child: const Text('Grant Permission'),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(Map<String, dynamic> podData) {
    final TextEditingController controller = TextEditingController(
      text: podData['name'] as String,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Pod'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Pod Name',
            hintText: 'Enter new pod name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  podData['name'] = controller.text.trim();
                });
                Navigator.pop(context);
                HapticFeedback.lightImpact();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showConnectionSuccessSnackBar(String podName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(child: Text('Connected to $podName')),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showDisconnectionSnackBar(String podName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'bluetooth_disabled',
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(child: Text('Disconnected from $podName')),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showEmptyState(EmptyStateType type) {
    // This would typically be handled by the EmptyStateWidget
    // but we can show additional feedback here if needed
  }
}
