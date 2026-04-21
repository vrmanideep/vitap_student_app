import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'objectbox.g.dart';

class ObjectBox {
  late final Store store;
  static ObjectBox? _instance; // The Holy Grail safeguard against double-calls

  ObjectBox._create(this.store);

  static Future<ObjectBox> create() async {
    // 1. If Dart already opened this in the current run, return it instantly.
    if (_instance != null) {
      return _instance!;
    }

    final docsDir = await getApplicationDocumentsDirectory();
    final storePath = '${docsDir.path}${Platform.pathSeparator}objectbox';

    // 2. Check if the HomeWidget background isolate has the database locked natively.
    // We check this BEFORE trying to open it, bypassing the ObjectBox try-catch memory bug.
    if (Store.isOpen(storePath)) {
      print("=== Attaching to existing HomeWidget Isolate ===");
      final store = Store.attach(getObjectBoxModel(), storePath);
      _instance = ObjectBox._create(store);
      return _instance!;
    }

    // 3. Otherwise, open a fresh connection normally.
    print("=== Opening fresh ObjectBox connection ===");
    final store = await openStore(directory: storePath);
    _instance = ObjectBox._create(store);
    return _instance!;
  }
}