

import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/%20caculator.dart';

void main(){
  group('CalCulator',(){
    test('Should return 5 when adding 3 and 5', (){
      final calculaor = Calculator();

      //Act
      final result = calculaor.add(2, 3);

      //Asset
      expect(result, 5);
    });

    test("Should return 0 when adding 0 and 0", (){
      //Arrange
      final calculator = Calculator();
      //Act

      final result = calculator.add(0, 0);

      //Assert
      expect(result, 0);
    });
  });


}