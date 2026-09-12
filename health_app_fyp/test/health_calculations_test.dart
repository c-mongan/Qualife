import 'package:flutter_test/flutter_test.dart';
import 'package:health_app_fyp/BMR+BMR/components/health_calculations.dart';

void main() {
  group('BMI calculation', () {
    test('converts centimetres to metres and calculates BMI', () {
      final bmi = calculateBodyMassIndex(
        heightCentimetres: 180,
        weightKilograms: 81,
      );

      expect(bmi, closeTo(25, 0.000001));
    });

    test('rejects non-positive height and weight', () {
      expect(
        () => calculateBodyMassIndex(
          heightCentimetres: 0,
          weightKilograms: 70,
        ),
        throwsArgumentError,
      );
      expect(
        () => calculateBodyMassIndex(
          heightCentimetres: 170,
          weightKilograms: -1,
        ),
        throwsArgumentError,
      );
    });
  });

  group('BMI classification', () {
    test('uses the standard category boundaries', () {
      expect(classifyBodyMassIndex(18.49), 'Underweight');
      expect(classifyBodyMassIndex(18.5), 'Healthy');
      expect(classifyBodyMassIndex(24.99), 'Healthy');
      expect(classifyBodyMassIndex(25), 'Overweight');
      expect(classifyBodyMassIndex(29.99), 'Overweight');
      expect(classifyBodyMassIndex(30), 'Obese');
    });

    test('returns matching interpretations at category boundaries', () {
      expect(interpretBodyMassIndex(18.49), 'Your BMI score is too low.');
      expect(
        interpretBodyMassIndex(18.5),
        'You have a healthy BMI score.',
      );
      expect(interpretBodyMassIndex(25), 'You BMI score is too high.');
    });
  });

  group('basal metabolic rate calculation', () {
    test('applies the male Mifflin-St Jeor adjustment', () {
      final bmr = calculateBasalMetabolicRate(
        heightCentimetres: 180,
        weightKilograms: 85,
        ageYears: 20,
        gender: BmrGender.male,
      );

      expect(bmr, closeTo(1880.75, 0.000001));
    });

    test('applies the female Mifflin-St Jeor adjustment', () {
      final bmr = calculateBasalMetabolicRate(
        heightCentimetres: 165,
        weightKilograms: 60,
        ageYears: 30,
        gender: BmrGender.female,
      );

      expect(bmr, closeTo(1322.05, 0.000001));
    });

    test('gender adjustment differs by 166 calories', () {
      final male = calculateBasalMetabolicRate(
        heightCentimetres: 170,
        weightKilograms: 70,
        ageYears: 40,
        gender: BmrGender.male,
      );
      final female = calculateBasalMetabolicRate(
        heightCentimetres: 170,
        weightKilograms: 70,
        ageYears: 40,
        gender: BmrGender.female,
      );

      expect(male - female, 166);
    });
  });
}
