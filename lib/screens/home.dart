import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';
import 'package:trabalho_final/daos/WeightGoalDao.dart';
import 'package:trabalho_final/models/Weight.dart';
import 'package:trabalho_final/daos/WeightDao.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final title = const Text("Weight Tracker");
  late WeightDao dao;
  late WeightGoalDao weightGoalDao;
  List<Weight> weights = [];
  String weightGoal = "";

  @override
  void initState() {
    super.initState();
    dao = WeightDao();
    weightGoalDao = WeightGoalDao();
    getAllWeights();
    getWeightGoal();
  }

  getAllWeights() async {
    final result = await dao.readAll();
    setState(() {
      weights = result;
    });
  }

  getWeightGoal() async {
    final result = await weightGoalDao.read();
    setState(() {
      weightGoal = result.weightGoal;
    });
  }

  getMaxWeight() {
    return List.generate(weights.length, (index) {
      return double.parse(weights[index].weight);
    }).reduce(max);
  }

  Widget summaryItem(itemTitle, itemValue) {
    final title = Text(itemTitle,
        style: const TextStyle(fontSize: 16, color: Colors.white));
    final value = Text(itemValue,
        style: const TextStyle(
            fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold));
    return SizedBox(
        width: ScreenUtil().setWidth(220),
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.black54, borderRadius: BorderRadius.circular(10)),
            child: Column(children: [
              Container(
                  padding: const EdgeInsets.only(bottom: 5), child: title),
              Container(padding: const EdgeInsets.all(1), child: value),
            ])));
  }

  Widget summaryWidget() {
    Weight currentWeight = weights.isEmpty
        ? Weight(date: "", weight: "")
        : weights[weights.length - 1];
    return SizedBox(
        width: ScreenUtil().setWidth(700),
        height: ScreenUtil().setHeight(300),
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  summaryItem("Current",
                      "${currentWeight.weight == "" ? "--" : currentWeight.weight} kg"),
                  summaryItem(
                      "Goal", "${weightGoal == "" ? "--" : weightGoal} kg"),
                  summaryItem(
                      "Diff",
                      (weightGoal == "" || currentWeight.weight == "")
                          ? "-- kg"
                          : "${double.parse(weightGoal) - double.parse(currentWeight.weight)} kg"),
                ]),
              ]),
            ],
          ),
        ));
  }

  Widget graph() {
    final List<Feature> features = [
      Feature(
        title: "Weight",
        color: Colors.purple,
        data: List.generate(weights.length, (index) {
          return double.parse(weights[index].weight) /
              (10 * getMaxWeight() - 9 * double.parse(weights[index].weight));
        }),
      ),
      Feature(
        title: "Goal",
        color: Colors.green,
        data: List.generate(weights.length, (index) {
          return weightGoal == ""
              ? 0
              : double.parse(weightGoal) /
                  (10 * getMaxWeight() - 9 * double.parse(weightGoal));
        }),
      ),
    ];

    return Container(
        color: Colors.transparent,
        width: ScreenUtil().setWidth(700),
        height: ScreenUtil().setHeight(829.5),
        child: Column(children: [
          Container(
              padding: const EdgeInsets.only(left: 10, right: 20, bottom: 60),
              child: LineGraph(
                features: features,
                size: const Size(380, 420),
                labelX: List.generate(weights.length, (_) {
                  return "";
                }),
                labelY: const [''],
                graphColor: Colors.white,
              )),
        ]));
  }

  Widget footer() {
    return Container(
        height: ScreenUtil().setHeight(135),
        padding: const EdgeInsets.only(left: 16),
        alignment: Alignment.bottomLeft,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Created by:",
                  style: TextStyle(fontSize: 14, color: Colors.white)),
              Text("Rodrigo Pires",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              Text("Welber Bernadino",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ]));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(700, 1400));
    return Scaffold(
        appBar: AppBar(
          leading: Container(
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.all(0),
              child: const Icon(Icons.trending_down)),
          title: title,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/list");
                },
                icon: const Icon(Icons.list)),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/settings");
                },
                icon: const Icon(Icons.settings))
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
              color: Colors.black87,
              child: Stack(children: [
                Column(
                  children: [summaryWidget(), graph(), footer()],
                ),
              ])),
        ));
  }
}
