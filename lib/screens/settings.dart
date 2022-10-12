import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trabalho_final/daos/WeightGoalDao.dart';
import 'package:trabalho_final/models/WeightGoal.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  final title = const Text("Settings");

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextStyle textStyle = const TextStyle(fontSize: 24, color: Colors.white);

  final TextEditingController _weightGoalController = TextEditingController();
  late WeightGoalDao dao;
  String weightGoal = "";

  @override
  void initState() {
    super.initState();
    dao = WeightGoalDao();
    getWeightGoal();
  }

  getWeightGoal() async {
    final result = await dao.read();
    setState(() {
      weightGoal = result.weightGoal;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(700, 1400));
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                Navigator.pushNamed(context, "/");
              }),
          title: widget.title,
        ),
        body: Container(
            color: Colors.black87,
            width: ScreenUtil().setWidth(700),
            height: ScreenUtil().setHeight(1400),
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Row(
                children: [
                  const Text("Weight Goal: ",
                      style: TextStyle(fontSize: 24, color: Colors.white)),
                  Text("${weightGoal == "" ? "--" : weightGoal} kg",
                      style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  const Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        openWeightGoalDialog();
                      },
                      child: Text("${weightGoal == "" ? "Set" : "Edit"} Goal",
                          style: const TextStyle(fontSize: 18)))
                ],
              )
            ])));
  }

  Future openWeightGoalDialog() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("${weightGoal == "" ? "Set" : "Edit"} Goal"),
              content: TextField(
                decoration: const InputDecoration(
                    hintText: "Weight Goal (kg)",
                    labelText: "Weight Goal (kg)"),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
                ],
                controller: _weightGoalController,
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      if (_weightGoalController.text.isNotEmpty) {
                        WeightGoal newWeightGoal =
                            WeightGoal(weightGoal: _weightGoalController.text);

                        if (weightGoal == "") {
                          dao.insertWeightGoal(newWeightGoal);
                          setState(() {
                            weightGoal = _weightGoalController.text;
                          });
                          Navigator.pop(context, newWeightGoal);
                        } else {
                          dao.updateWeightGoal(_weightGoalController.text);
                          setState(() {
                            weightGoal = _weightGoalController.text;
                          });
                          Navigator.pop(context, newWeightGoal);
                        }
                      }
                    },
                    child: const Text("SUBMIT"))
              ],
            ));
  }
}
