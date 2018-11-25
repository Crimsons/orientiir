abstract class DataSource<T> {
  Future<List<T>> loadData();

  void saveData(List<T> data);
}
