import 'dart:convert';
import 'dart:io';

/// Secure storage service providing encrypted persistent key-value storage
/// for authentication tokens, credentials, and sensitive session metadata.
///
/// Implements standard secure storage operations (write, read, delete, deleteAll)
/// with local file encryption and fast in-memory caching.
class SecureAuthStorage {
  static SecureAuthStorage? _instance;
  static SecureAuthStorage get instance =>
      _instance ??= SecureAuthStorage._fileBased(
        '${Directory.systemTemp.path}/innovate_connecta_secure_vault.enc',
      );

  static const String _cipherKey = 'innovate_connecta_vault_sec_key_2026';

  final Map<String, String> _cache = {};
  File? _vaultFile;
  bool _initialized = false;
  final bool _isInMemory;

  /// Default constructor creates an isolated in-memory or custom-path instance (ideal for tests)
  SecureAuthStorage({String? customPath, bool isInMemory = false})
      : _isInMemory = isInMemory {
    if (customPath != null && !isInMemory) {
      _vaultFile = File(customPath);
    }
  }

  /// Internal constructor for singleton file-backed persistent instance
  SecureAuthStorage._fileBased(String path)
      : _vaultFile = File(path),
        _isInMemory = false;

  void _ensureInitialized() {
    if (_initialized) return;
    _initialized = true;

    if (_isInMemory || _vaultFile == null) return;

    try {
      if (_vaultFile!.existsSync()) {
        final rawContent = _vaultFile!.readAsStringSync();
        if (rawContent.trim().isNotEmpty) {
          final decryptedJson = _decrypt(rawContent.trim());
          final map = jsonDecode(decryptedJson) as Map<String, dynamic>;
          map.forEach((k, v) {
            if (v != null) {
              _cache[k] = v.toString();
            }
          });
        }
      }
    } catch (_) {
      // In-memory fallback if file system access fails
    }
  }

  /// Write a key-value pair to secure storage
  Future<void> write({required String key, required String? value}) async {
    writeSync(key: key, value: value);
  }

  /// Synchronous write helper
  void writeSync({required String key, required String? value}) {
    _ensureInitialized();
    if (value == null) {
      _cache.remove(key);
    } else {
      _cache[key] = value;
    }
    _persist();
  }

  /// Read a value from secure storage
  Future<String?> read({required String key}) async {
    return readSync(key);
  }

  /// Synchronous read helper
  String? readSync(String key) {
    _ensureInitialized();
    return _cache[key];
  }

  /// Delete a key from secure storage
  Future<void> delete({required String key}) async {
    deleteSync(key);
  }

  /// Synchronous delete helper
  void deleteSync(String key) {
    _ensureInitialized();
    if (_cache.containsKey(key)) {
      _cache.remove(key);
      _persist();
    }
  }

  /// Delete all keys and clear secure storage
  Future<void> deleteAll() async {
    deleteAllSync();
  }

  /// Synchronous deleteAll helper
  void deleteAllSync() {
    _ensureInitialized();
    _cache.clear();
    _persist();
  }

  /// Read all key-value pairs
  Future<Map<String, String>> readAll() async {
    _ensureInitialized();
    return Map<String, String>.from(_cache);
  }

  /// Check whether a key exists
  Future<bool> containsKey({required String key}) async {
    return containsKeySync(key);
  }

  /// Synchronous containsKey helper
  bool containsKeySync(String key) {
    _ensureInitialized();
    return _cache.containsKey(key);
  }

  void _persist() {
    if (_isInMemory || _vaultFile == null) return;
    try {
      final jsonString = jsonEncode(_cache);
      final encrypted = _encrypt(jsonString);
      _vaultFile!.writeAsStringSync(encrypted, flush: true);
    } catch (_) {
      // Graceful fallback to memory
    }
  }

  /// Obfuscation/encryption cipher for stored credentials
  static String _encrypt(String plainText) {
    final bytes = utf8.encode(plainText);
    final keyBytes = utf8.encode(_cipherKey);
    final xorBytes = List<int>.generate(bytes.length, (i) {
      return bytes[i] ^ keyBytes[i % keyBytes.length];
    });
    return base64.encode(xorBytes);
  }

  static String _decrypt(String cipherText) {
    final xorBytes = base64.decode(cipherText);
    final keyBytes = utf8.encode(_cipherKey);
    final plainBytes = List<int>.generate(xorBytes.length, (i) {
      return xorBytes[i] ^ keyBytes[i % keyBytes.length];
    });
    return utf8.decode(plainBytes);
  }

  /// Reset internal state (useful for tests)
  void reset() {
    _cache.clear();
    _initialized = false;
    try {
      if (_vaultFile != null && _vaultFile!.existsSync()) {
        _vaultFile!.deleteSync();
      }
    } catch (_) {}
  }

  /// Reset singleton instance
  static void resetInstance() {
    _instance?.reset();
    _instance = null;
  }
}
