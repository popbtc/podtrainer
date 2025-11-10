import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleService {
  final FlutterReactiveBle _ble = FlutterReactiveBle();

  // UUID จาก ESP32
  final Uuid serviceUuid = Uuid.parse("12345678-1234-1234-1234-1234567890ab");
  final Uuid rgbUuid = Uuid.parse("12345678-1234-1234-1234-1234567890ac");
  final Uuid nameUuid = Uuid.parse("12345678-1234-1234-1234-1234567890ad");

  DiscoveredDevice? connectedDevice;
  QualifiedCharacteristic? rgbCharacteristic;
  QualifiedCharacteristic? nameCharacteristic;

  final StreamController<String> _dataStreamController = StreamController.broadcast();
  Stream<String> get bleDataStream => _dataStreamController.stream;

  // 🔍 สแกนหาอุปกรณ์
  Stream<DiscoveredDevice> scanForPods({String targetName = "ESP32-POD"}) {
    print("🔍 Scanning for $targetName...");
    return _ble.scanForDevices(withServices: [], scanMode: ScanMode.lowLatency).where(
          (device) => device.name == targetName,
    );
  }

  // 🔗 เชื่อมต่อ
  Future<void> connectToDevice(DiscoveredDevice device) async {
    print("🔗 Connecting to ${device.name}...");
    connectedDevice = device;

    _ble.connectToDevice(id: device.id).listen((connectionState) async {
      if (connectionState.connectionState == DeviceConnectionState.connected) {
        print("✅ Connected to ${device.name}");
        rgbCharacteristic = QualifiedCharacteristic(
          serviceId: serviceUuid,
          characteristicId: rgbUuid,
          deviceId: device.id,
        );
        nameCharacteristic = QualifiedCharacteristic(
          serviceId: serviceUuid,
          characteristicId: nameUuid,
          deviceId: device.id,
        );
        _subscribeToNotifications();
      } else if (connectionState.connectionState == DeviceConnectionState.disconnected) {
        print("❌ Disconnected from ${device.name}");
        connectedDevice = null;
      }
    });
  }

  // 📤 ส่งคำสั่ง
  Future<void> sendCommand(String command) async {
    if (rgbCharacteristic == null) {
      print("⚠️ Device not ready to write");
      return;
    }
    final value = command.codeUnits;
    await _ble.writeCharacteristicWithoutResponse(rgbCharacteristic!, value: value);
    print("📤 Sent: $command");
  }

  // 📥 Subscribe รับ notify จาก ESP32
  void _subscribeToNotifications() {
    if (rgbCharacteristic == null) return;
    _ble.subscribeToCharacteristic(rgbCharacteristic!).listen((data) {
      final message = String.fromCharCodes(data);
      print("📥 Received: $message");
      _dataStreamController.add(message);
    });
  }

  // ❌ Disconnect
  Future<void> disconnect() async {
    if (connectedDevice != null) {
      await _ble.deinitialize();
      print("🔌 Disconnected");
      connectedDevice = null;
    }
  }

  void dispose() {
    _dataStreamController.close();
  }
}
