import 'package:openfoodfacts/model/NutrientLevels.dart';
import 'package:openfoodfacts/model/Nutriments.dart';
import 'package:openfoodfacts/model/UserAgent.dart';
import 'package:openfoodfacts/openfoodfacts.dart';

class User {
  late String userId;
  late String password;
}

// class ProductResult {
//   late int status;
//   late String barcode;
//   late String statusVerbose;
//   late Product product;
// }

class Product {
  late String barcode;
  late String productName;
  late OpenFoodFactsLanguage lang;
  late String quantity;
  late String servingSize;

  late String brands;
  late List<String> brandTags;

  late String imgSmallUrl;
  //late ImageList selectedImages;

  late List<Ingredient> ingredients;
  late String ingredientsText;

  late Nutriments nutriments;
  late NutrimentsLevel nutrimentLevels;
  late String nutrimentEnergyUnit;
  late String nutrimentDataPer;

  late String nutriscore;

  late Additives additives;

  late String categories;
  late List<String> categoriesTags;

  late List<String> labelsTags;
  late List<String> miscTags;
  late List<String> stateTags;
  late List<String> tracesTags;
}

class Nutriments {
  //--- For a serving of 100g ----
  late double salt;
  late double fiber;
  late double sugars;
  late double fat;
  late double saturatedFat;
  late double proteins;
  late double carbohydrates;
  late double energy;

  late int novaGroup;

//---- Per recommanded serving ----
  late double saltServing;
  late double sugarServing;
  late double fatServing;
  late double saturatedFatServing;
  late double proteinsServing;
  late double carbohydratesServing;
  late double energyServing;

  late int novaGroupServing;
}

class ProductSearchQueryConfigurations {
  late OpenFoodFactsLanguage language;
  late List<ProductField> fields;
  late List<Parameter> parametersList;
}

class Status {
  late final status; // to be completed
  late String error;
  late String statusVerbose;
  late int imageId;
}

enum Level { LOW, MODERATE, HIGH, UNDEFINED }

class NutrimentsLevel {
  late String NUTRIENT_SUGARS;
  late String NUTRIENT_FAT;
  late String NUTRIENT_SATURATED_FAT;
  late String NUTRIENT_SALT;

  late Map<String, Level> levels;
}
