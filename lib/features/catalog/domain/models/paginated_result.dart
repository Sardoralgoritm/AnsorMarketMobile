class PaginatedResult<T> {
  const PaginatedResult({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });

  final List<T> items;
  final int totalCount;
  final int page;
  final int pageSize;

  bool get hasMore => items.length >= pageSize && (page * pageSize) < totalCount;
}
