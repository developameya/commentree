enum AppState {
  initial,
  loading,
  success,
  error;

  static AppState? getAppStateFromString(String status) {
    for (var element in AppState.values) {
      if (element.toString() == status) {
        return element;
      }
    }
    return null;
  }
}
