List uniqueList(List mixedList) {
  return Set.from(mixedList).toList();
}

String unitNameToTitle(String unitName) {
  return unitName.split("-")[1].trim().toUpperCase();
}
