import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NFCReaderScreen extends StatefulWidget {
  const NFCReaderScreen({super.key});

  @override
  State<NFCReaderScreen> createState() => _NFCReaderScreenState();
}

class _NFCReaderScreenState extends State<NFCReaderScreen> {
  String _tagId = "";
  String _payload = "";
  bool _tagDetected = false;
  String _statusMessage = "Ready to scan NFC tag...";
  bool _isNFCAvailable = false; 

  @override
  void initState() {
    super.initState();
    _checkNFCAvailability();
  }

  Future<void> _checkNFCAvailability() async {
    try {
      bool isAvailable = await NfcManager.instance.isAvailable();
      setState(() {
        _isNFCAvailable = isAvailable;
        if (!isAvailable) {
          _statusMessage = "این قابلیت در شبیه‌ساز یا دستگاه شما ممکن نیست";
        }
      });
    } catch (e) {
      setState(() {
        _isNFCAvailable = false;
        _statusMessage = "این قابلیت در شبیه‌ساز یا دستگاه شما ممکن نیست";
      });
    }
  }

  void _scanNFC() async {
    if (!_isNFCAvailable) return;

    setState(() {
      _tagDetected = false;
      _statusMessage = "Hold your device near an NFC tag...";
    });

    try {
      NfcManager.instance.startSession(
        pollingOptions: {
          NfcPollingOption.iso14443,
          NfcPollingOption.iso15693,
        },
        onDiscovered: (NfcTag tag) async {
          final Map<String, dynamic> tagData = Map<String, dynamic>.from(tag.data as Map);
          String detectedId = "N/A";
          String payloadData = "No text payload found";

          if (tagData.containsKey('nfca')) {
            final nfca = Map<dynamic, dynamic>.from(tagData['nfca'] as Map);
            if (nfca.containsKey('identifier')) {
              detectedId = (nfca['identifier'] as List<dynamic>)
                  .map((e) => e.toRadixString(16).padLeft(2, '0').toUpperCase())
                  .join(':');
            }
          } else if (tagData.containsKey('mifare')) {
            final mifare = Map<dynamic, dynamic>.from(tagData['mifare'] as Map);
            if (mifare.containsKey('identifier')) {
              detectedId = (mifare['identifier'] as List<dynamic>)
                  .map((e) => e.toRadixString(16).padLeft(2, '0').toUpperCase())
                  .join(':');
            }
          }

          if (tagData.containsKey('ndef')) {
            final ndef = Map<dynamic, dynamic>.from(tagData['ndef'] as Map);
            if (ndef.containsKey('cachedMessage')) {
              final cachedMessage = Map<dynamic, dynamic>.from(ndef['cachedMessage'] as Map);
              if (cachedMessage.containsKey('records')) {
                final records = cachedMessage['records'] as List<dynamic>;
                if (records.isNotEmpty) {
                  final firstRecord = Map<dynamic, dynamic>.from(records.first as Map);
                  if (firstRecord.containsKey('payload')) {
                    final payloadList = firstRecord['payload'] as List<dynamic>;
                    payloadData = String.fromCharCodes(payloadList.cast<int>());
                  }
                }
              }
            }
          }

          setState(() {
            _tagDetected = true;
            _tagId = detectedId;
            _payload = payloadData;
            _statusMessage = "Scan successful!";
          });
          NfcManager.instance.stopSession();
        },
      ).catchError((e) {
        setState(() {
          _statusMessage = "Error: $e";
        });
        NfcManager.instance.stopSession();
      });
    } catch (e) {
      setState(() {
        _statusMessage = "Failed to start NFC session: $e";
      });
    }
  }

  void _simulateNFCTag() {
    setState(() {
      _tagDetected = true;
      _tagId = "04:A1:2B:C3:D4:E5:F6";
      _payload = "Welcome to Sensor Dashboard App (NFC Demo)";
      _statusMessage = "NFC Tag Detected (Simulated)";
    });
  }

  @override
  void dispose() {
    try {
      NfcManager.instance.stopSession();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NFC Reader"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.contactless, 
                size: 110, 
                color: _tagDetected ? Colors.green : Colors.blueGrey
              ),
              const SizedBox(height: 25),
              
              Text(
                _statusMessage, 
                style: const TextStyle(fontSize: 15, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),

              if (_tagDetected) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green, width: 1.5)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "NFC Tag Detected", 
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18)
                      ),
                      const Divider(color: Colors.green),
                      const SizedBox(height: 8),
                      Text("Tag ID: $_tagId", style: const TextStyle(fontFamily: 'monospace', fontSize: 15, color: Colors.white)),
                      const SizedBox(height: 8),
                      Text("Payload: $_payload", style: const TextStyle(fontSize: 15, color: Colors.white)),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 40),
              
              if (_isNFCAvailable)
                ElevatedButton.icon(
                  onPressed: _scanNFC,
                  icon: const Icon(Icons.search),
                  label: const Text("Start Live NFC Scan"),
                )
              else ...[
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: _simulateNFCTag,
                  icon: const Icon(Icons.developer_mode),
                  label: const Text("Simulate NFC Tag (Demo)"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber, 
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
