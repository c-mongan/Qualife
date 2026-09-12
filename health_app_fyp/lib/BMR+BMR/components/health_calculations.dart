import 'dart:math';

enum BmrGender {
  male,
  female,
}

double calculateBodyMassIndex({
  required num heightCentimetres,
  required num weightKilograms,
}) {
  if (heightCentimetres <= 0 || weightKilograms <= 0) {
    throw ArgumentError('Height and weight must be greater than zero.');
  }

  return weightKilograms / pow(heightCentimetres / 100, 2);
}

String classifyBodyMassIndex(double bmi) {
  if (bmi >= 30) {
    return 'Obese';
  }
  if (bmi >= 25) {
    return 'Overweight';
  }
  if (bmi >= 18.5) {
    return 'Healthy';
  }
  return 'Underweight';
}

String interpretBodyMassIndex(double bmi) {
  if (bmi < 18.5) {
    return 'Your BMI score is too low.';
  }
  if (bmi >= 25) {
    return 'You BMI score is too high.';
  }
  return 'You have a healthy BMI score.';
}

double calculateBasalMetabolicRate({
  required num heightCentimetres,
  required num weightKilograms,
  required num ageYears,
  required BmrGender gender,
}) {
  final genderAdjustment = gender == BmrGender.male ? 5 : -161;
  return 9.99 * weightKilograms +
      6.25 * heightCentimetres -
      4.92 * ageYears +
      genderAdjustment;
}
