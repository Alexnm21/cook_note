extension MapExtension<K, V> on Map<K, V> {
  /// Devuelve un nuevo mapa sin las entradas que tienen valores nulos
  Map<K, V> withoutNulls() {
    return Map.fromEntries(
      entries.where((entry) => entry.value != null),
    );
  }
}
