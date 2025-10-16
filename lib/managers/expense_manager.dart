import '../models/expense.dart';

class ExpenseManager {
  static List<Expense> expenses = [
    Expense(
      id: 'e1',
      title: 'Makan Siang',
      amount: 50000,
      category: 'Food',
      date: DateTime(2025, 9, 1),
      description: 'Di restoran',
    ),
    Expense(
      id: 'e2',
      title: 'Transport',
      amount: 30000,
      category: 'Transport',
      date: DateTime(2025, 9, 1),
      description: 'Ojek online',
    ),
    Expense(
      id: 'e3',
      title: 'Belanja Baju',
      amount: 200000,
      category: 'Shopping',
      date: DateTime(2025, 9, 2),
      description: 'Toko mall',
    ),
  ];

  // 1. Total per kategori
  static Map<String, double> getTotalByCategory(List<Expense> expenses) {
    Map<String, double> result = {};
    for (var expense in expenses) {
      result[expense.category] = (result[expense.category] ?? 0) + expense.amount;
    }
    return result;
  }

  // 2. Pengeluaran tertinggi
  static Expense? getHighestExpense(List<Expense> expenses) {
    if (expenses.isEmpty) return null;
    return expenses.reduce((a, b) => a.amount > b.amount ? a : b);
  }

  // 3. Pengeluaran bulan tertentu
  static List<Expense> getExpensesByMonth(List<Expense> expenses, int month, int year) {
    return expenses.where((expense) =>
      expense.date.month == month && expense.date.year == year
    ).toList();
  }

  // 4. Cari berdasarkan kata kunci
  static List<Expense> searchExpenses(List<Expense> expenses, String keyword) {
    String lowerKeyword = keyword.toLowerCase();
    return expenses.where((expense) =>
      expense.title.toLowerCase().contains(lowerKeyword) ||
      expense.description.toLowerCase().contains(lowerKeyword) ||
      expense.category.toLowerCase().contains(lowerKeyword)
    ).toList();
  }

  // 5. Rata-rata pengeluaran harian
  static double getAverageDaily(List<Expense> expenses) {
    if (expenses.isEmpty) return 0;
    
    double total = expenses.fold(0, (sum, expense) => sum + expense.amount);
    
    Set<String> uniqueDays = expenses.map((expense) =>
      '${expense.date.year}-${expense.date.month}-${expense.date.day}'
    ).toSet();
    
    return total / uniqueDays.length;
  }
}
