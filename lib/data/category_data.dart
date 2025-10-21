import '../models/category.dart';

class CategoryData {
  // List kategori yang bisa diakses dari mana pun
  static List<Category> categories = [
    Category(id: 1, name: 'Makanan'),
    Category(id: 2, name: 'Transportasi'),
    Category(id: 3, name: 'Hiburan'),
  ];

  static void addCategory(String name) {
    categories.add(Category(id: categories.length + 1, name: name));
  }

  static void updateCategory(int id, String newName) {
    final index = categories.indexWhere((c) => c.id == id);
    if (index != -1) {
      categories[index] = Category(id: id, name: newName);
    }
  }

  static void deleteCategory(int id) {
    categories.removeWhere((c) => c.id == id);
  }
}
