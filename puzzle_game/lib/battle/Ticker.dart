/// This classed is used as Ticker for Resolving State. After each resolved
/// tile there should be a short amount to wait for the next resolve
class Ticker {
  Stream<int> tick({int ticks}) {
    return Stream.periodic(Duration(seconds: 1), (x) => ticks - x - 1)
        .take(ticks);
  }
}