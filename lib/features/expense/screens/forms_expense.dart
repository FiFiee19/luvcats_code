import 'package:flutter/material.dart';
import 'package:luvcats_app/features/expense/services/expense_service.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:luvcats_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class FormsExpense extends StatefulWidget {
  const FormsExpense({
    Key? key,
  }) : super(key: key);

  @override
  State<FormsExpense> createState() => _FormsExpenseState();
}

class _FormsExpenseState extends State<FormsExpense> {
  final GlobalKey<FormState> expenseFormKey = GlobalKey<FormState>();
  final ExpenseServices expenseServices = ExpenseServices();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  int? selectedOption;
  final List<String> listcategory = [
    'อาหาร',
    'ยาและการรักษา',
    'อาบน้ำตัดขน',
    'ของใช้อื่นๆ',
  ];

  void addExpense() async {
    if (expenseFormKey.currentState!.validate()) {
      final UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      final String userId = userProvider.user.id;

      if (selectedOption == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('กรุณาเลือกประเภทค่าใช้จ่าย'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      expenseServices.addExpense(
          user_id: userId,
          context: context,
          category: categoryController.text,
          description: descriptionController.text,
          amount: double.parse(amountController.text));
    }
  }

  List<Widget> radioList() {
    return listcategory.asMap().entries.map((entry) {
      int index = entry.key;
      String category = entry.value;
      return ListTile(
        title: Text(category),
        leading: Radio(
          value: index,
          groupValue: selectedOption,
          onChanged: (int? value) {
            setState(() {
              selectedOption = value;
              categoryController.text = listcategory[value!];
            });
          },
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    if (mounted) {
      categoryController.dispose();
      descriptionController.dispose();
      amountController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('บันทึกค่าใช้จ่าย'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: expenseFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Divider(),
              const Text('ประเภทค่าใช้จ่าย',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ...radioList(),
              const Divider(),
              const SizedBox(height: 20),
              const Text(
                'อธิบายเพิ่มเติม',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: TextFormField(
                  controller: descriptionController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'กรุณากรอกอธิบายเพิ่มเติม';
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'อธิบายเพิ่มเติม',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.black38,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              const Text(
                'จำนวนเงิน',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: TextFormField(
                  controller: amountController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'กรุณากรอกจำนวนเงิน';
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'จำนวนเงิน',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.black38,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'บันทึก',
                onTap: () {
                  addExpense();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
