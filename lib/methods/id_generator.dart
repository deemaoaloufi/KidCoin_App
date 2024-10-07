import 'package:uuid/uuid.dart';

class IdGenerator {
  static final Uuid _uuid = const Uuid();

  // Generate a unique ID using uuid
  static String generateId() {
    return _uuid.v4(); // Generates a version 4 (random) UUID
  }
}
