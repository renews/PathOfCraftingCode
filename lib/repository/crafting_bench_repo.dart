import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../crafting/mod.dart';
import '../crafting/item/item.dart';
import 'mod_repo.dart';

class CraftingBenchRepository {

  CraftingBenchRepository._privateConstructor();
  static final CraftingBenchRepository instance = CraftingBenchRepository._privateConstructor();

  Map<String, List<CraftingBenchOption>> craftingBenchOptionsMap;
  List<CraftingBenchOption> craftingBenchOptions;

  Future<bool> initialize() async {
    craftingBenchOptions = List();
    craftingBenchOptionsMap = Map();
    var data = await rootBundle.loadString('data_repo/crafting_bench_options.json');
    var jsonList = json.decode(data);
    jsonList.forEach((data) {
      CraftingBenchOption craftingBenchOption = CraftingBenchOption.fromJson(data);
      craftingBenchOptions.add(craftingBenchOption);
      if (craftingBenchOptionsMap[craftingBenchOption.benchGroup] == null) {
        craftingBenchOptionsMap[craftingBenchOption.benchGroup] = List();
      }
      craftingBenchOptionsMap[craftingBenchOption.benchGroup].add(craftingBenchOption);
    });
    return true;
  }

  Map<String, List<CraftingBenchOption>> getCraftingOptionsForItem(Item item) {
    Map<String, List<CraftingBenchOption>> optionsMap = Map();
    for (CraftingBenchOption option in craftingBenchOptions) {
      if (option.itemClasses.contains(item.itemClass)) {
        if (optionsMap[option.benchGroup] == null) {
          optionsMap[option.benchGroup] = List();
        }
        optionsMap[option.benchGroup].add(option);
      }
    }
    return optionsMap;
  }
}

class CraftingBenchOption {
  String benchGroup;
  int benchTier;
  List<String> itemClasses;
  Mod mod;

  CraftingBenchOption({
    this.benchGroup,
    this.benchTier,
    this.itemClasses,
    this.mod,
  });

  factory CraftingBenchOption.fromJson(Map<String, dynamic> json) {
    String modId = json['mod_id'];
    Mod mod = ModRepository.instance.getModById(modId);
    return CraftingBenchOption(
      benchGroup: json['bench_group'],
      benchTier: json['bench_tier'],
      itemClasses: List<String>.from(json['item_classes']),
      mod: mod,
    );
  }
}