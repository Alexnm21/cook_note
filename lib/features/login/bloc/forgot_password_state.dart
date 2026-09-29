class ForgotPasswordState {
  final bool loading;
  final bool success;
  final String? error;

  const ForgotPasswordState({
    this.loading = false,
    this.success = false,
    this.error,
  });

  ForgotPasswordState copyWith({
    bool? loading,
    bool? success,
    String? Function()? error,
  }) {
    return ForgotPasswordState(
      loading: loading ?? this.loading,
      success: success ?? this.success,
      error: error != null ? error() : this.error,
    );
  }
}