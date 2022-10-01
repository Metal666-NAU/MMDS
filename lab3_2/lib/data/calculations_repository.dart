import 'dart:math';

class CalculationsRepository {
  final Random random = Random();

  CalculationResults calculate({
    double targetHeight = 600,
    ManagementLaw managementLaw = ManagementLaw.none,
  }) {
    final List<double> x = List.filled(9, 0),
        y = List.filled(9, 0),
        t = [],
        Dv = [],
        Y0 = [],
        Y3 = [],
        Y6 = [],
        Ny = [];

    const double S = 201.45,
        ba = 5.285,
        G1 = 73000,
        G2 = 68000,
        Xt = 0.24,
        Xtc = 0.3,
        Iz1 = 660000,
        Iz2 = 650000,
        g = 9.81,
        m1 = G1 / g,
        m2 = G2 / g,
        V = 97.2,
        H0 = 600,
        p = 0.119,
        an = 338.36,
        Cy = -0.255,
        Cay = 5.78,
        Cdby = 0.2865,
        Cx = 0.13,
        mz = 0.2,
        mwzz = -13.0,
        mazm = -3.8,
        maz = -1.83,
        mdbz = -0.96,
        Tv = 8.16,
        L = 10,
        kn = 0.1,
        knt = 0.5,
        kv = 1,
        ks = 0.002,
        T1 = 20,
        T2 = 20;

    double T = 0,
        DT = 0.01,
        TD = 0,
        TF = 90,
        DD = 1,
        DV = -2,
        Cybal1 = 2 * G1 / (S * p * V * V),
        abal1 = 57.3 * ((Cybal1 - Cy) / Cay),
        dvbal1 =
            -57.3 * ((mz + maz * abal1 / 57.3 + Cybal1 * (Xt - 0.24)) / mdbz),
        Cybal2 = 2 * G2 / (S * p * V * V),
        abal2 = 57.3 * ((Cybal2 - Cy) / Cay),
        dvbal2 =
            -57.3 * ((mz + maz * abal2 / 57.3 + Cybal2 * (Xt - 0.24)) / mdbz),
        avant = 0.3,
        az = 0,
        dvz = 0,
        DH = 0,
        sigma = 0,
        c101 = -(mwzz * S * ba * ba * p * V) / (Iz1 * 2),
        c102 = -(maz * S * ba * p * V * V) / (Iz1 * 2),
        c103 = -(mdbz * S * ba * p * V * V) / (Iz1 * 2),
        c104 = (Cay + Cx) * S * p * V / (m1 * 2),
        c105 = -(mazm * S * ba * ba * p * V) / (Iz1 * 2),
        c106 = V / 57.3,
        c109 = Cdby * S * p * V / (m1 * 2),
        c116 = V / (57.3 * g),
        c120 = 57.3 * Cy * S * ba * p * V * V / (2 * Iz1),
        c201 = -(mwzz * S * ba * ba * p * V) / (Iz2 * 2),
        c202 = -(maz * S * ba * p * V * V) / (Iz2 * 2),
        c203 = -(mdbz * S * ba * p * V * V) / (Iz2 * 2),
        c204 = (Cay + Cx) * S * p * V / (m2 * 2),
        c205 = -(mazm * S * ba * ba * p * V) / (Iz2 * 2),
        c206 = V / 57.3,
        c209 = Cdby * S * p * V / (m2 * 2),
        c216 = V / (57.3 * g),
        c220 = 57.3 * Cy * S * ba * p * V * V / (2 * Iz2),
        NY,
        DX,
        dabal,
        ddvbal,
        c1,
        c2,
        c3,
        c4,
        c5,
        c6,
        c9,
        c16,
        c20,
        kts;

    y[6] = H0;

    while (T < TF) {
      dabal = 0;
      ddvbal = 0;
      DX = 0;
      c1 = c101;
      c2 = c102;
      c3 = c103;
      c4 = c104;
      c5 = c105;
      c6 = c106;
      c9 = c109;
      c16 = c116;
      c20 = c120;

      if (T >= 2 && T < Tv) {
        kts = (Xtc - Xt) / L;
        DX = y[5] * kts;
      } else if (T >= Tv) {
        dabal = abal1 - abal2;
        ddvbal = dvbal1 - dvbal2;
        DX = 0.0;
        c1 = c201;
        c2 = c202;
        c3 = c203;
        c4 = c204;
        c5 = c205;
        c6 = c206;
        c9 = c209;
        c16 = c216;
        c20 = c220;
      }

      x[0] = y[1];
      x[1] = -c1 * y[1] - c2 * az - c5 * x[3] - c3 * dvz + c20 * DX;
      x[2] = c4 * az + c9 * dvz;
      x[3] = x[0] - x[2];
      az = y[3] + dabal;
      dvz = DV + ddvbal;
      x[4] = y[5];
      x[5] = avant;
      x[6] = c6 * y[2];
      NY = c16 * x[2];
      x[7] = y[0] - y[7] / T1;
      x[8] = kn * DH + knt * x[6];
      DH = y[6] - targetHeight;

      switch (managementLaw) {
        case ManagementLaw.none:
          {
            break;
          }
        case ManagementLaw.first:
          {
            sigma = kn * DH;

            break;
          }
        case ManagementLaw.second:
          {
            sigma = kn * DH + knt * x[6];

            break;
          }
        case ManagementLaw.third:
          {
            sigma = kn * DH + kv * y[0];

            break;
          }
        case ManagementLaw.fourth:
          {
            sigma = kn * DH + kv * x[7];

            break;
          }
        case ManagementLaw.fifth:
          {
            sigma = kn * DH + knt * x[6] + ks * DH / c6;

            break;
          }
        case ManagementLaw.sixth:
          {
            sigma = x[8] + y[8] / T2;

            break;
          }
        case ManagementLaw.seventh:
          {
            sigma = kn * DH + kv * x[7] / T2;

            break;
          }
      }

      if (managementLaw != ManagementLaw.none) {
        DV = sigma + y[1];
      }

      for (int i = 0; i < 9; i++) {
        y[i] = y[i] + x[i] * DT;
      }

      if (T >= TD) {
        t.add(T);
        Dv.add(DV);
        Y0.add(y[0]);
        Y3.add(y[3]);
        Y6.add(y[6]);
        Ny.add(NY);

        TD += DD;
      }

      T += DT;
    }

    return CalculationResults(
      time: t,
      Y6: Y6,
      Cybal1: Cybal1,
      Cybal2: Cybal2,
      abal1: abal1,
      abal2: abal2,
      dvbal1: dvbal1,
      dvbal2: dvbal2,
      c101: c101,
      c102: c102,
      c103: c103,
      c104: c104,
      c105: c105,
      c106: c106,
      c109: c109,
      c116: c116,
      c120: c120,
      c201: c201,
      c202: c202,
      c203: c203,
      c204: c204,
      c205: c205,
      c206: c206,
      c209: c209,
      c216: c216,
      c220: c220,
    );
  }
}

enum ManagementLaw {
  none,
  first,
  second,
  third,
  fourth,
  fifth,
  sixth,
  seventh,
}

enum Variant {
  first,
  second,
  third,
}

class CalculationResults {
  final List<double> time, Y6;

  final double Cybal1,
      Cybal2,
      abal1,
      abal2,
      dvbal1,
      dvbal2,
      c101,
      c102,
      c103,
      c104,
      c105,
      c106,
      c109,
      c116,
      c120,
      c201,
      c202,
      c203,
      c204,
      c205,
      c206,
      c209,
      c216,
      c220;

  CalculationResults({
    required this.time,
    required this.Y6,
    required this.Cybal1,
    required this.Cybal2,
    required this.abal1,
    required this.abal2,
    required this.dvbal1,
    required this.dvbal2,
    required this.c101,
    required this.c102,
    required this.c103,
    required this.c104,
    required this.c105,
    required this.c106,
    required this.c109,
    required this.c116,
    required this.c120,
    required this.c201,
    required this.c202,
    required this.c203,
    required this.c204,
    required this.c205,
    required this.c206,
    required this.c209,
    required this.c216,
    required this.c220,
  });
}
