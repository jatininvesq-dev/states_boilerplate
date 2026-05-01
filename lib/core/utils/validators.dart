class Validators {
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Optional website: empty is valid; non-empty must start with http:// or https://.
  static String? optionalWebsiteUrl(String? value) {
    final s = (value ?? '').trim();
    if (s.isEmpty) return null;

    final lower = s.toLowerCase();
    if (!lower.startsWith('http://') && !lower.startsWith('https://')) {
      return 'Website must start with http:// or https://';
    }

    final uri = Uri.tryParse(s);
    if (uri == null) {
      return 'Please enter a valid website';
    }
    final scheme = uri.scheme.toLowerCase();
    if (scheme != 'http' && scheme != 'https') {
      return 'Please use http:// or https://';
    }
    final host = uri.host.trim().toLowerCase();
    if (host.isEmpty) {
      return 'Please enter a valid website';
    }
    final ipv4 = RegExp(
      r'^((25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(25[0-5]|2[0-4]\d|[01]?\d\d?)$',
    );
    if (ipv4.hasMatch(host)) return null;
    if (host == 'localhost') return null;
    if (!host.contains('.')) {
      return 'Please enter a valid website';
    }
    final parts = host.split('.');
    final tld = parts.last;
    if (tld.length < 2 || !RegExp(r'^[a-z0-9]+$').hasMatch(tld)) {
      return 'Please enter a valid website';
    }
    for (final p in parts) {
      if (p.isEmpty || p.length > 63) {
        return 'Please enter a valid website';
      }
    }
    return null;
  }
}
