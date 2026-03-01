class TabItemModel {
  final String label;
  final String iconPath;
  final String? activeIconPath;
  final String? lottiePath;

  TabItemModel({
    required this.label,
    required this.iconPath,
    this.activeIconPath,
    this.lottiePath,
  });
}
