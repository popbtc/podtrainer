import 'dart:async'; // ✅ ต้องมี
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:podtrainer/core/ble_service.dart';
import 'package:permission_handler/permission_handler.dart';



class PodsManagementScreen extends StatefulWidget {
  const PodsManagementScreen({Key? key}) : super(key: key);

  @override
  State<PodsManagementScreen> createState() => _PodsManagementScreenState();
}

class _PodsManagementScreenState extends State<PodsManagementScreen> {
  final BleService _bleService = BleService();
  final List<DiscoveredDevice> _foundDevices = [];
  bool _isScanning = false;
  DiscoveredDevice? _connectedDevice;
  StreamSubscription<DiscoveredDevice>? _scanSubscription;

  @override
  void initState() {
    super.initState();
    _checkPermissionsBeforeScan();
    _startScan();
  }
  Future<void> _checkPermissionsBeforeScan() async {
    final locationStatus = await Permission.locationWhenInUse.status;
    final bluetoothScanStatus = await Permission.bluetoothScan.status;
    final bluetoothConnectStatus = await Permission.bluetoothConnect.status;

    if (locationStatus.isGranted &&
        bluetoothScanStatus.isGranted &&
        bluetoothConnectStatus.isGranted) {
      _startScan();
    } else {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/permission-request');
      }
    }
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _bleService.dispose();
    super.dispose();
  }

  // 🔍 เริ่มสแกนหา ESP32-POD
  void _startScan() {
    setState(() {
      _isScanning = true;
      _foundDevices.clear();
    });

    _scanSubscription = _bleService.scanForPods().listen((device) {
      setState(() {
        // ป้องกันซ้ำ
        if (!_foundDevices.any((d) => d.id == device.id)) {
          _foundDevices.add(device);
        }
      });
    }, onDone: () {
      setState(() => _isScanning = false);
    });
  }

  Future<void> _connectToDevice(DiscoveredDevice device) async {
    await _bleService.connectToDevice(device);
    setState(() => _connectedDevice = device);
  }

  Future<void> _disconnect() async {
    await _bleService.disconnect();
    setState(() => _connectedDevice = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pods Management"),
        actions: [
          IconButton(
            icon: Icon(_isScanning ? Icons.stop : Icons.refresh),
            onPressed: _isScanning ? null : _startScan,
          )
        ],
      ),
      body: _isScanning
          ? const Center(child: CircularProgressIndicator())
          : _connectedDevice != null
          ? _buildConnectedView()
          : _buildAvailablePods(),
    );
  }

  // 📋 แสดงอุปกรณ์ที่เจอ
  Widget _buildAvailablePods() {
    if (_foundDevices.isEmpty) {
      return const Center(child: Text("No pods found"));
    }

    return ListView.builder(
      itemCount: _foundDevices.length,
      itemBuilder: (context, index) {
        final device = _foundDevices[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(device.name.isNotEmpty ? device.name : "Unknown device"),
            subtitle: Text(device.id),
            trailing: ElevatedButton(
              onPressed: () => _connectToDevice(device),
              child: const Text("Connect"),
            ),
          ),
        );
      },
    );
  }

  // 🔗 แสดงหน้าควบคุมเมื่อเชื่อมต่อแล้ว
  Widget _buildConnectedView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("✅ Connected to ${_connectedDevice?.name ?? 'Unknown'}"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _bleService.sendCommand("RED"),
            child: const Text("RED"),
          ),
          ElevatedButton(
            onPressed: () => _bleService.sendCommand("GREEN"),
            child: const Text("GREEN"),
          ),
          ElevatedButton(
            onPressed: () => _bleService.sendCommand("BLUE"),
            child: const Text("BLUE"),
          ),
          ElevatedButton(
            onPressed: () => _bleService.sendCommand("OFF"),
            child: const Text("OFF"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _disconnect,
            child: const Text("Disconnect"),
          ),
        ],
      ),
    );
  }
}
