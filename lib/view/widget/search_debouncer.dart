import 'dart:async';
import 'dart:ui';

class SearchDebouncer {
  final Duration delay;
  Timer? _timer;

  SearchDebouncer({required this.delay});

  void debounce(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }
}
