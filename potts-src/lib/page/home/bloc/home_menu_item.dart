enum MenuType {
  None(),
  All(),
  Menu(),
  Setting();
}

class MenuItem {
  // 菜单索引
  int index;
  // 菜单图标
  String icon;
  // 菜单标题
  String? title;
  // 菜单路由
  String? route;
  // 菜单类型
  MenuType type = MenuType.None;
  // 菜单可视
  bool visiable = true;
  // 选中状态
  bool isSelected = false;
  // 赵士淞 - 始
  // 底部显示
  bool bottomDisplay = false;
  // 赵士淞 - 终
  // 父节点
  MenuItem? parent = null;
  // 子节点
  List<MenuItem>? children;

  MenuItem({required this.index, required this.icon, this.title, this.route});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    MenuItem result = MenuItem(
        index: json['index'],
        icon: json['icon'],
        title: json['title'],
        route: json['route']);
    if (json['type'] != null) {
      if (json['type'] == 'Setting') {
        result.type = MenuType.Setting;
      } else if (json['type'] == 'Menu') {
        result.type = MenuType.Menu;
      } else {
        result.type = MenuType.None;
      }
    }
    if (json['visiable'] != null) {
      result.visiable = json['visiable'];
    }
    // 赵士淞 - 始
    if (json['bottomDisplay'] != null) {
      result.bottomDisplay = json['bottomDisplay'];
    }
    // 赵士淞 - 终
    if (json['children'] != null) {
      List children = json['children'] as List;
      children.forEach((element) {
        result.add(MenuItem.fromJson(element));
      });
    }
    return result;
  }

  void _setParent(MenuItem menuItem) {
    this.parent = menuItem;
  }

  void add(MenuItem menuItem) {
    menuItem._setParent(this);
    if (children == null) {
      children = [];
    }
    children!.add(menuItem);
  }
}
