import 'package:flutter/material.dart';
import 'package:luvcats_app/features/expense/screens/detail_expense.dart';
import 'package:luvcats_app/features/expense/screens/forms_expense.dart';
import 'package:luvcats_app/features/expense/services/expense_service.dart';
import 'package:luvcats_app/models/expense.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final ExpenseServices expenseService = ExpenseServices();
  List<Expense> expenses = [];

  bool isLoading = true;
  int? selectedMonth;
  int? selectedYear;
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
    selectedMonth = DateTime.now().month; // Set to current month initially
    selectedYear = DateTime.now().year; // Set to current year initially
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ดึง userId จาก UserProvider
    final userId = Provider.of<UserProvider>(context, listen: false).user.id;
    if (userId != null) {
      fetchExpense(userId);
    }
  }

  Future<void> fetchExpense(String userId) async {
    try {
      final List<Expense> fetchedExpenses =
          await expenseService.fetchExpense(context, userId);
      if (mounted) {
        setState(() {
          // Apply filter based on selectedMonth and selectedYear
          expenses = fetchedExpenses.where((expense) {
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

  Map<String, double> aggregateAmount(List<Expense> expenses) {
    // ตั้งค่าเริ่มต้นสำหรับหมวดหมู่
    Map<String, double> aggregated = {
      'อาหาร': 0,
      'ยาและการรักษา': 0,
      'อาบน้ำตัดขน': 0,
      'ของใช้อื่นๆ': 0,
    };

    // รวมค่าใช้จ่ายตามหมวดหมู่
    for (var expense in expenses) {
      if (aggregated.containsKey(expense.category)) {
        aggregated[expense.category] =
            (aggregated[expense.category] ?? 0.0) + expense.amount;
      } else {
        // หากมีหมวดหมู่ที่ไม่ตรงกับหมวดหมู่เริ่มต้น เพิ่มเข้าไปใน aggregated
        aggregated[expense.category] = expense.amount;
      }
    }
    return aggregated;
  }

  Map<String, double> calculatePercentage(Map<String, double> aggregated) {
    double totalAmount = aggregated.values.reduce((a, b) => a + b);
    Map<String, double> percentages = {};
    aggregated.forEach((category, amount) {
      double percentage = (amount / totalAmount) * 100;
      percentages[category] = percentage;
    });
    return percentages;
  }

  @override
  Widget build(BuildContext context) {
    final aggregated = aggregateAmount(expenses);

    final percentages = calculatePercentage(aggregated);
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
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                final userId =
                    Provider.of<UserProvider>(context, listen: false).user.id;
                await fetchExpense(userId);
              },
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("รวมค่าใช้จ่ายรายเดือน"),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FormsExpense()),
                              );
                            },
                            child: Text(
                              "เพิ่มค่าใช้จ่าย",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(100, 50),
                              primary: Colors.red,
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
                          // Call fetchExpense again to update the expenses list
                          // based on the new month and year
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
                    SizedBox(
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
                  SizedBox(
                    height: 20,
                  ),
                  PieChart(
                    chartType: ChartType.ring,

                    dataMap:
                        percentages, // Use percentages instead of aggregated
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
                    // Add any other options or configurations here...
                  ),
                  Container(
                    color: Color.fromRGBO(201, 201, 201, 0.89),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 18),
                      child: Row(
                        children: [
                          Text('ประวัติค่าใช้จ่าย'),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: ListView.separated(
                    itemCount: aggregated.length,
                    itemBuilder: (context, index) {
                      final category = aggregated.keys.elementAt(index);
                      final totalAmount = aggregated.values.elementAt(index);
                      final userId =
                          Provider.of<UserProvider>(context, listen: false)
                              .user
                              .id;
                      return Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 18), // ลดระยะห่างด้านบนและล่าง
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.zero, // กำหนด contentPadding เป็น 0
                          visualDensity:
                              VisualDensity(vertical: -4), // ลดระยะห่างด้านข้าง
                          title: Text(
                            category,
                            style:
                                TextStyle(fontSize: 12.0), // ลดขนาดฟอนต์ข้อความ
                            overflow: TextOverflow
                                .ellipsis, // หากข้อความยาวเกินไปจะแสดง '...'
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
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.red), // ลดขนาดฟอนต์ข้อความ
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(),
                  )),
                ],
              ),
            ),
    );
  }
}
