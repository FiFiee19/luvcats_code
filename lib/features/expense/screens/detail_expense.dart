import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:luvcats_app/features/expense/services/expense_service.dart';
import 'package:luvcats_app/models/expense.dart';

class DetailExpense extends StatefulWidget {
  final String category;
  final String userId;
  final int selectedMonth;
  final int selectedYear;

  const DetailExpense({
    Key? key,
    required this.category,
    required this.userId,
    required this.selectedMonth,
    required this.selectedYear,
  }) : super(key: key);

  @override
  State<DetailExpense> createState() => _DetailExpenseState();
}

class _DetailExpenseState extends State<DetailExpense> {
  final ExpenseServices expenseService = ExpenseServices();
  List<Expense> expenses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExpense(widget.userId);
  }

  Future<void> fetchExpense(String userId) async {
    setState(() {
      isLoading = true;
    });

    try {
      final List<Expense> fetchedExpenses =
          await expenseService.fetchExpense(context, userId);

      final filteredExpenses = fetchedExpenses.where((expense) {
        final expenseDate = DateTime.parse(expense.createdAt!);
        return expense.category == widget.category &&
            expenseDate.month == widget.selectedMonth &&
            expenseDate.year == widget.selectedYear;
      }).toList();

      if (mounted) {
        setState(() {
          expenses = filteredExpenses;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print("Error fetching expenses: $e");
    }
  }

  void _showDeleteDialog(String expense) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text(
            'ลบโพสต์',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () async {
              await expenseService.deleteExpense(context, expense);

              if (mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('ยืนยัน'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double totalAmount =
        expenses.fold(0.0, (sum, item) => sum + item.amount);

    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดค่าใช้จ่าย: ${widget.category}'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => fetchExpense(widget.userId),
              child: Column(
                children: [
                  Container(
                    color: Color.fromRGBO(201, 201, 201, 0.89),
                    padding: EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Text(
                          '${widget.category}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                        Text(
                          'รวม ${totalAmount.toStringAsFixed(2)} บาท',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: expenses.isEmpty
                        ? Center(
                            child: Text('ไม่มีรายการค่าใช้จ่ายในหมวดหมู่นี้'))
                        : ListView.separated(
                            itemCount: expenses.length,
                            itemBuilder: (context, index) {
                              final expense = expenses[index];
                              final formattedDate = expense.createdAt != null
                                  ? DateFormat('yyyy-MM-dd').format(
                                      DateTime.parse(expense.createdAt!))
                                  : 'ไม่ทราบวันที่';
                              return ListTile(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16.0),
                                title: Text(
                                  expense.description,
                                  style: TextStyle(fontSize: 15.0),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  formattedDate,
                                  style: TextStyle(fontSize: 12.0),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize
                                      .min, // ใช้เพื่อให้ Row มีขนาดพอดีกับ children
                                  children: [
                                    Text(
                                      '${expense.amount.toStringAsFixed(2)} บาท',
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete_sharp),
                                      onPressed: () async {
                                        // รายการที่คลิกจะลบที่นี่
                                        _showDeleteDialog(expense.id!);
                                        // เรียก setState หรือใช้ State Management เช่น Provider หรือ bloc เพื่ออัพเดท UI
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => Divider(),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}