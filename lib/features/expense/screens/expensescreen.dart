import 'package:flutter/material.dart';
import 'package:luvcats_app/features/expense/screens/detail_expense.dart';
import 'package:luvcats_app/features/expense/screens/forms_expense.dart';
import 'package:luvcats_app/features/expense/services/expense_service.dart';
import 'package:luvcats_app/models/expense.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final ExpenseServices expenseService = ExpenseServices();
  List<Expense> expenses = [];
  bool isLoading = true;
  int? selectedMonth;
  int? selectedYear;
  List<Expense>? fetchedExpenses;
  List<int> years = List.generate(10, (index) => DateTime.now().year - index);
  List<String> monthNames = [
    'มกราคม',
    'กุมภาพันธ์',
    'มีนาคม',
    'เมษายน',
    'พฤษภาคม',
    'มิถุนายน',
    'กรกฎาคม',
    'สิงหาคม',
    'กันยายน',
    'ตุลาคม',
    'พฤศจิกายน',
    'ธันวาคม'
  ];
  List<Color> colorList = [
    Color.fromARGB(255, 255, 145, 228),
    Color.fromARGB(255, 255, 248, 146),
    Color.fromARGB(255, 133, 193, 249),
    Color.fromARGB(255, 160, 254, 215)
  ];

  @override
  void initState() {
    super.initState();
    selectedMonth = DateTime.now().month;
    selectedYear = DateTime.now().year;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userId = Provider.of<UserProvider>(context, listen: false).user.id;
    if (userId != null) {
      fetchExpense(userId);
    }
  }

  Future<void> fetchExpense(String userId) async {
    try {
      fetchedExpenses = await expenseService.fetchExpense(context, userId);
      if (mounted) {
        setState(() {
          expenses = fetchedExpenses!.where((expense) {
            final expenseDate = DateTime.parse(expense.createdAt!);
            return expenseDate.month == selectedMonth &&
                expenseDate.year == selectedYear;
          }).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        print("Error fetching expenses: $e");
      }
    }
  }

  Map<String, double> totalAmount(List<Expense> expenses) {
    Map<String, double> categories = {
      'อาหาร': 0,
      'ยาและการรักษา': 0,
      'อาบน้ำตัดขน': 0,
      'ของใช้อื่นๆ': 0,
    };

    for (var i in expenses) {
      if (categories.containsKey(i.category)) {
        categories[i.category] = (categories[i.category] ?? 0.0) + i.amount;
      } else {
        categories[i.category] = i.amount;
      }
    }
    return categories;
  }

  Map<String, double> calculatePercentage(Map<String, double> total) {
    double totalAmount = total.values.fold(0, (sum, element) => sum + element);
    Map<String, double> percentages = {};
    total.forEach((category, amount) {
      double percentage = (amount / totalAmount) * 100;
      percentages[category] = percentage;
    });
    return percentages;
  }

  @override
  Widget build(BuildContext context) {
    final total = totalAmount(expenses);
    final percentages = calculatePercentage(total);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'บันทึกค่าใช้จ่าย',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                final userId =
                    Provider.of<UserProvider>(context, listen: false).user.id;
                await fetchExpense(userId);
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("รวมค่าใช้จ่ายรายเดือน"),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const FormsExpense()),
                              );
                            },
                            child: Text(
                              "เพิ่มค่าใช้จ่าย",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(100, 50),
                              backgroundColor: Colors.red,
                            )),
                      ],
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    DropdownButton<String>(
                      value: selectedMonth != null
                          ? monthNames[selectedMonth! - 1]
                          : null,
                      items: monthNames
                          .map<DropdownMenuItem<String>>((String month) {
                        return DropdownMenuItem<String>(
                          value: month,
                          child: Text(month),
                        );
                      }).toList(),
                      hint: const Text(
                        'เดือน',
                        style: TextStyle(fontSize: 14),
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          selectedMonth = monthNames.indexOf(newValue!) + 1;

                          final userId =
                              Provider.of<UserProvider>(context, listen: false)
                                  .user
                                  .id;
                          if (userId != null) {
                            fetchExpense(userId);
                          }
                        });
                      },
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    DropdownButton<int>(
                      value: selectedYear,
                      items: years.map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                      hint: const Text(
                        'ปี',
                        style: TextStyle(fontSize: 14),
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          selectedYear = newValue;
                          final userId =
                              Provider.of<UserProvider>(context, listen: false)
                                  .user
                                  .id;
                          if (userId != null) {
                            fetchExpense(userId);
                          }
                        });
                      },
                    ),
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  PieChart(
                    chartType: ChartType.ring,
                    dataMap: percentages,
                    colorList: colorList,
                    chartRadius: MediaQuery.of(context).size.width / 3,
                    ringStrokeWidth: 40,
                    animationDuration: const Duration(seconds: 1),
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValues: true,
                      showChartValuesOutside: true,
                      showChartValuesInPercentage: true,
                      showChartValueBackground: false,
                    ),
                    legendOptions: const LegendOptions(
                      showLegends: true,
                      legendShape: BoxShape.rectangle,
                      legendTextStyle: TextStyle(fontSize: 12),
                      legendPosition: LegendPosition.bottom,
                      showLegendsInRow: true,
                    ),
                  ),
                  Container(
                    color: const Color.fromRGBO(201, 201, 201, 0.89),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                      child: Row(
                        children: [
                          Text('ประวัติค่าใช้จ่าย'),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: ListView.separated(
                    itemCount: total.length,
                    itemBuilder: (context, index) {
                      final category = total.keys.elementAt(index);
                      final totalAmount = total.values.elementAt(index);
                      final userId =
                          Provider.of<UserProvider>(context, listen: false)
                              .user
                              .id;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 18),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          visualDensity: const VisualDensity(vertical: -4),
                          title: Text(
                            category,
                            style: const TextStyle(fontSize: 12.0),
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailExpense(
                                          category: category,
                                          userId: userId,
                                          selectedMonth: selectedMonth!,
                                          selectedYear: selectedYear!,
                                        )),
                              );
                            },
                            child: Text(
                              '${totalAmount.toStringAsFixed(2)} บาท',
                              style: const TextStyle(
                                  fontSize: 12.0, color: Colors.red),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                  )),
                ],
              ),
            ),
    );
  }
}
