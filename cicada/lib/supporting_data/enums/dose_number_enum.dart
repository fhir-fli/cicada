enum DoseNumber {
  num1,

  num2,

  num3,

  num4,

  num5,

  num6,

  num7,

  num8,

  num9,

  num10,

  num11,

  num12,

  num13,

  num14,

  num15,

  num16,

  num17,

  num18,

  num19,

  num20;

  static DoseNumber? fromString(String? string) {
    switch (string) {
      case 'Dose 1':
        return DoseNumber.num1;
      case 'Dose 2':
        return DoseNumber.num2;
      case 'Dose 3':
        return DoseNumber.num3;
      case 'Dose 4':
        return DoseNumber.num4;
      case 'Dose 5':
        return DoseNumber.num5;
      case 'Dose 6':
        return DoseNumber.num6;
      case 'Dose 7':
        return DoseNumber.num7;
      case 'Dose 8':
        return DoseNumber.num8;
      case 'Dose 9':
        return DoseNumber.num9;
      case 'Dose 10':
        return DoseNumber.num10;
      case 'Dose 11':
        return DoseNumber.num11;
      case 'Dose 12':
        return DoseNumber.num12;
      case 'Dose 13':
        return DoseNumber.num13;
      case 'Dose 14':
        return DoseNumber.num14;
      case 'Dose 15':
        return DoseNumber.num15;
      case 'Dose 16':
        return DoseNumber.num16;
      case 'Dose 17':
        return DoseNumber.num17;
      case 'Dose 18':
        return DoseNumber.num18;
      case 'Dose 19':
        return DoseNumber.num19;
      case 'Dose 20':
        return DoseNumber.num20;
      default:
        return null;
    }
  }

  static DoseNumber? fromNum(num? number) {
    switch (number) {
      case 1:
        return DoseNumber.num1;
      case 2:
        return DoseNumber.num2;
      case 3:
        return DoseNumber.num3;
      case 4:
        return DoseNumber.num4;
      case 5:
        return DoseNumber.num5;
      case 6:
        return DoseNumber.num6;
      case 7:
        return DoseNumber.num7;
      case 8:
        return DoseNumber.num8;
      case 9:
        return DoseNumber.num9;
      case 10:
        return DoseNumber.num10;
      case 11:
        return DoseNumber.num11;
      case 12:
        return DoseNumber.num12;
      case 13:
        return DoseNumber.num13;
      case 14:
        return DoseNumber.num14;
      case 15:
        return DoseNumber.num15;
      case 16:
        return DoseNumber.num16;
      case 17:
        return DoseNumber.num17;
      case 18:
        return DoseNumber.num18;
      case 19:
        return DoseNumber.num19;
      case 20:
        return DoseNumber.num20;
      default:
        return null;
    }
  }

  static DoseNumber? fromJson(Object? json) =>
      json is String ? fromString(json) : null;

  @override
  String toString() {
    switch (this) {
      case DoseNumber.num1:
        return 'Dose 1';
      case DoseNumber.num2:
        return 'Dose 2';
      case DoseNumber.num3:
        return 'Dose 3';
      case DoseNumber.num4:
        return 'Dose 4';
      case DoseNumber.num5:
        return 'Dose 5';
      case DoseNumber.num6:
        return 'Dose 6';
      case DoseNumber.num7:
        return 'Dose 7';
      case DoseNumber.num8:
        return 'Dose 8';
      case DoseNumber.num9:
        return 'Dose 9';
      case DoseNumber.num10:
        return 'Dose 10';
      case DoseNumber.num11:
        return 'Dose 11';
      case DoseNumber.num12:
        return 'Dose 12';
      case DoseNumber.num13:
        return 'Dose 13';
      case DoseNumber.num14:
        return 'Dose 14';
      case DoseNumber.num15:
        return 'Dose 15';
      case DoseNumber.num16:
        return 'Dose 16';
      case DoseNumber.num17:
        return 'Dose 17';
      case DoseNumber.num18:
        return 'Dose 18';
      case DoseNumber.num19:
        return 'Dose 19';
      case DoseNumber.num20:
        return 'Dose 20';
    }
  }

  String toJson() => toString();
}
