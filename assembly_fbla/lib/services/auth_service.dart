import 'dart:async';

class LocalUser {
  final String email;
  final String uid;
  LocalUser({required this.email, required this.uid});
}

class AuthService {
  final _userController = StreamController<LocalUser?>.broadcast();
  LocalUser? _currentUser;

  final Map<String, String> _users = {
    'test@test.com': 'password',
  };

  Future<LocalUser?> signUpWithEmailAndPassword(String email, String password) async {
    if (_users.containsKey(email)) {
      return null; // User already exists
    }
    _users[email] = password;
    return signInWithEmailAndPassword(email, password);
  }

  Future<LocalUser?> signInWithEmailAndPassword(String email, String password) async {
    if (_users.containsKey(email) && _users[email] == password) {
      _currentUser = LocalUser(uid: email, email: email);
      _userController.add(_currentUser);
      return _currentUser;
    }
    _userController.add(null);
    return null;
  }

  Future<void> signOut() async {
    _currentUser = null;
    _userController.add(null);
  }

  LocalUser? getCurrentUser() {
    return _currentUser;
  }

  Stream<LocalUser?> get authStateChanges => _userController.stream;

  void dispose() {
    _userController.close();
  }
}
