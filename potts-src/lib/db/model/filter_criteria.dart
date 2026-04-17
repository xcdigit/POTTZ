enum FilterType {
  EQ('eq');
  final String value;
  const FilterType(this.value);
}
class FilterCriteria {
  String name;
  FilterType type;
  dynamic value;
  FilterCriteria(this.name, this.type, this.value);
}