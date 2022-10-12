import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trabalho_final/models/Weight.dart';
import 'package:intl/intl.dart';

class AddWeight extends StatefulWidget {
  const AddWeight({super.key});
  static const routeName = "/add";
  final Text title = const Text("New weight entry");
  final EdgeInsets padding = const EdgeInsets.all(16);

  @override
  State<AddWeight> createState() => _AddWeightState();
}

class _AddWeightState extends State<AddWeight> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _weightController = TextEditingController();

  DateTime currentDate = DateTime.now();
  late DateTime selectedDate;
  late String weight;
  late String errorMessage;

  @override
  void initState() {
    super.initState();

    selectedDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    weight = "";
    errorMessage = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: widget.title),
        body: Container(
            color: Colors.black87,
            child: Padding(
                padding: widget.padding,
                child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Date: ",
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white)),
                              Text(
                                  "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, "0")}-${selectedDate.day.toString().padLeft(2, "0")}",
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              const Spacer(),
                              Container(
                                  padding: const EdgeInsets.all(0),
                                  width: ScreenUtil().setWidth(250),
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        DateTime? newDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: selectedDate,
                                                firstDate: DateTime(2020),
                                                lastDate: currentDate);
                                        if (newDate == null) return;
                                        setState(() => selectedDate = newDate);
                                      },
                                      child: const Text("Select Date",
                                          style: TextStyle(fontSize: 18))))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Weight: ",
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white)),
                              Text("${weight == "" ? "--" : weight} kg",
                                  style: const TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              const Spacer(),
                              Container(
                                  padding: const EdgeInsets.all(0),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        openWeightDialog();
                                      },
                                      child: const Text("Select Weight",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white))))
                            ],
                          ),
                          const Spacer(),
                          Column(children: [
                            Text(
                              errorMessage,
                              style: const TextStyle(
                                  fontSize: 24, color: Colors.red),
                            ),
                            Container(
                                width: ScreenUtil().setWidth(700),
                                height: ScreenUtil().setHeight(150),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: ElevatedButton(
                                    child: const Text("Submit",
                                        style: TextStyle(fontSize: 24)),
                                    onPressed: () {
                                      if (weight == "") {
                                        setState(() {
                                          errorMessage =
                                              "Please input a weight";
                                        });
                                        return;
                                      }
                                      Weight newWeight = Weight(
                                          date: DateFormat('yyyy-MM-dd')
                                              .format(selectedDate),
                                          weight: weight);
                                      Navigator.pop(context, newWeight);
                                    }))
                          ])
                        ])))));
  }

  Future openWeightDialog() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Select Weight"),
              content: TextField(
                decoration: const InputDecoration(
                    hintText: "Weight", labelText: "Weight"),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
                ],
                controller: _weightController,
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        weight = _weightController.text;
                        errorMessage = "";
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("SUBMIT"))
              ],
            ));
  }
}
