import 'dart:math';

class CalculationsRepository {
  CalculationResults calculate({
    double rudder = 10,
    double elevatingRudder = 0,
    RollDamper rollDamper = RollDamper.none,
    YawDamper yawDamper = YawDamper.none,
    Variant variant = Variant.first,
  }) {
    const double S = 201.45,
        l = 37.55,
        G = 80000,
        Ix = 250000,
        Iy = 900000,
        g = 9.81,
        mywy_ = -0.141,
        myde = 0,
        DT = 0.01,
        DD = 0.5,
        TF = 30;

    final List<double> X = List.filled(8, 0), Y = List.filled(8, 0);

    double V,
        H,
        p,
        an,
        Cy0,
        Cya,
        myB,
        mydn,
        CzB,
        mxdn,
        mxwy_,
        Czdn,
        mxwx_,
        mxB,
        mxde,
        mywx_;

    switch (variant) {
      case Variant.first:
        {
          V = 97.2;
          H = 500;
          p = 0.119;
          an = 338.36;

          Cy0 = -0.255;
          Cya = 5.78;
          myB = -0.1518;

          mydn = -0.071;
          CzB = -0.8136;
          mxdn = -0.02;
          mxwy_ = -0.151;
          Czdn = -0.16;
          mxwx_ = -0.56;

          mxB = -0.1146;
          mxde = -0.07;
          mywx_ = -0.026;

          break;
        }
      case Variant.second:
        {
          V = 190;
          H = 6400;
          p = 0.0636;
          an = 314.34;

          Cy0 = -0.28;
          Cya = 5.9;
          myB = -0.154;

          mydn = -0.0745;
          CzB = -0.928;
          mxdn = -0.0200;
          mxwy_ = -0.11;
          Czdn = -0.1662;
          mxwx_ = -0.63;

          mxB = -0.106;
          mxde = -0.0602;
          mywx_ = -0.006;

          break;
        }
      case Variant.third:
        {
          V = 250;
          H = 11300;
          p = 0.0372;
          an = 295.06;

          Cy0 = -0.32;
          Cya = 6.3;
          myB = -0.1948;

          mydn = -0.0716;
          CzB = -1.0028;
          mxdn = -0.0172;
          mxwy_ = -0.11;
          Czdn = -0.1719;
          mxwx_ = -0.65;

          mxB = -0.1146;
          mxde = -0.0472;
          mywx_ = -0.006;

          break;
        }
    }

    double KWX = 1.5,
        KWY = 2.5,
        TWX = 1.6,
        TWY = 2.5,
        TD = 0,
        T = 0,
        m = G / g,
        sigmB = myB - (CzB * p * S * l * mywy_) / (4 * m),
        Cybal = (2 * G) / (S * p * pow(V, 2)),
        abal = 57.3 * (Cybal - Cy0) / Cya;

    CalculationResults results = CalculationResults(
      a1: -(mywy_ / Iy) * S * pow(l, 2) * (p * V / 4),
      a2: -(myB / Iy) * S * l * (p * pow(V, 2) / 2),
      a3: -(mydn / Iy) * S * l * (p * pow(V, 2) / 2),
      a4: -(CzB / m) * S * (p * V / 2),
      a5: -(mxdn / Ix) * S * l * (p * pow(V, 2) / 2),
      a6: -(mxwy_ / Ix) * S * pow(l, 2) * (p * V / 4),
      a7: -(Czdn / m) * S * (p * V / 2),
      b1: (-mxwx_ / Ix) * S * pow(l, 2) * ((p * V) / 4),
      b2: -(mxB / Ix) * S * l * (p * pow(V, 2) / 2),
      b3: -(mxde / Ix) * S * l * (p * pow(V, 2) / 2),
      b4: (g / V) * cos(abal / 57.3),
      b5: -(myde / Iy) * S * l * (p * pow(V, 2) / 2),
      b6: -(mywx_ / Iy) * S * pow(l, 2) * (p * V / 4),
      b7: sin(abal / 57.3),
      Cybal: Cybal,
      abal: abal,
      Xx: ((mxB * Iy) / (myB * Ix)) *
          (1 /
              (sqrt(1 - mxwx_ / Ix) *
                  (mxwx_ / Ix) *
                  Iy *
                  S *
                  l *
                  l *
                  (p / (4 * myB)))),
    );

    for (int i = 0; i < 3000; i++) {
      if (T <= TF) {
        double DVD, DND;

        switch (rollDamper) {
          case RollDamper.none:
            {
              DVD = 0;
              break;
            }
          case RollDamper.type_1:
            {
              DVD = KWX * Y[3];
              break;
            }
          case RollDamper.type_2:
            {
              DVD = KWX * Y[3] - Y[6] / TWX;
              break;
            }
        }

        switch (yawDamper) {
          case YawDamper.none:
            {
              DND = 0;
              break;
            }
          case YawDamper.type_1:
            {
              DND = KWY * Y[1];
              break;
            }
          case YawDamper.type_2:
            {
              DND = KWY * Y[1] - Y[7] / TWY;
              break;
            }
        }

        if (T > 1.1) {
          rudder = 0;
        }

        double DE = elevatingRudder + DVD;
        double DN = rudder + DND;

        X[0] = Y[1];
        X[1] = -results.a1 * Y[1] -
            results.b6 * Y[3] -
            results.a2 * Y[4] -
            results.a3 * DN -
            results.b5 * DE;
        X[2] = Y[3];
        X[3] = -results.a6 * Y[1] -
            results.b1 * Y[3] -
            results.b2 * Y[4] -
            results.a5 * DN -
            results.b3 * DE;
        X[4] = Y[1] +
            results.b7 * Y[3] +
            results.b4 * Y[2] -
            results.a4 * Y[4] -
            results.a7 * DN;
        X[5] = -(V / 57.3) * (Y[2] - Y[4]);
        X[6] = DVD;
        X[7] = DND;

        for (int j = 0; j < 8; j++) {
          Y[j] = Y[j] + X[j] * DT;
        }

        if (T >= TD) {
          results.massY1.add(X[0]);
          results.massY3.add(X[2]);
          results.massY0.add(Y[0]);
          results.massY2.add(Y[2]);
          results.massY4.add(Y[4]);
          results.massX4.add(X[4]);
          results.time.add(T);
          results.massDES.add(elevatingRudder);
          results.massDNP.add(rudder);

          TD = TD + DD;
        }

        T = T + DT;
      }
    }

    return results;
  }
}

enum RollDamper {
  none,
  type_1,
  type_2,
}

enum YawDamper {
  none,
  type_1,
  type_2,
}

enum Variant {
  first,
  second,
  third,
}

class CalculationResults {
  final List<double> time = [],
      massDES = [],
      massDNP = [],
      massY1 = [],
      massY3 = [],
      massY0 = [],
      massY2 = [],
      massY4 = [],
      massX4 = [];

  final double a1,
      a2,
      a3,
      a4,
      a5,
      a6,
      a7,
      b1,
      b2,
      b3,
      b4,
      b5,
      b6,
      b7,
      Cybal,
      abal,
      Xx;

  CalculationResults({
    required this.a1,
    required this.a2,
    required this.a3,
    required this.a4,
    required this.a5,
    required this.a6,
    required this.a7,
    required this.b1,
    required this.b2,
    required this.b3,
    required this.b4,
    required this.b5,
    required this.b6,
    required this.b7,
    required this.Cybal,
    required this.abal,
    required this.Xx,
  });
}
