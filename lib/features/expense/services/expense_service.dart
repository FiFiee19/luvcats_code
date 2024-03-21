import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:luvcats_app/config/constants.dart';
import 'package:luvcats_app/models/expense.dart';
import 'package:luvcats_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ExpenseServices {
  void addExpense({
    required BuildContext context,
    required String user_id,
    required String category,
    required String description,
    required double amount,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      Expense expense = Expense(
        user_id: user_id,
        category: category,
        description: description,
        amount: amount,
      );

      http.Response res = await http.post(
        Uri.parse('$url/postExpense'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: expense.toJson(),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('บันทึกสำเร็จ!')),
        );
        Navigator.pop(context);
      } else {
        throw Exception('เกิดข้อผิดพลาด');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(30),
        ),
      );
    }
  }

  Future<List<Expense>> fetchExpense(
      BuildContext context, String user_id) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final http.Response res = await http.get(
        Uri.parse('$url/getExpense/id/$user_id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
      );

      if (res.statusCode == 200) {
        List<dynamic> expenseData = jsonDecode(res.body);
        print(expenseData);
        return expenseData.map((data) {
          return Expense.fromMap(data as Map<String, dynamic>);
        }).toList();
      } else {
        throw Exception('เกิดข้อผิดพลาด');
      }
    } catch (e) {
      throw Exception('Error fetching comments: $e');
    }
  }

  //ลบStrayCat
  Future<void> deleteExpense(BuildContext context, String expenseId) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.delete(
        Uri.parse('$url/getExpense/delete/$expenseId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'authtoken': userProvider.user.token,
        },
        body: jsonEncode({
          'expenseId': expenseId,
        }),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ลบสำเร็จ!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(30),
        ),
      );
    }
  }
}
