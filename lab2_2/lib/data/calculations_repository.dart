import 'dart:math';

class CalculationsRepository {
  CalculationResults calculate({
    double centering = 0.18,
    double elevatingRudder = 0,
    double throttle = 0,
    double wind = 0,
    Variant variant = Variant.first,
  }) {
    double S = 201.45,
        ba = 5.285,
        G = 73000,
        xt_ = 0.18,
        NY,
        Iz = 660000,
        ndv = 3,
        Ydv = 0.5,
        V = 97.2,
        H = 500,
        p = 0.1190,
        an = 338.36,
        g = 9.81,
        cy0 = -0.255,
        cya = 5.78,
        c_y = 0.2865,
        cMy = 0.0,
        cMx = 0.0,
        cxhp = 0.046,
        c_Ax = 0.286,
        Mhp,
        cx,
        wv,
        sigmav,
        sigmany,
        dny,
        mz0 = 0.20,
        mzw_ = -13.0,
        mza_ = -3.8,
        mza = -1.83,
        m_z = -0.96,
        mCyZ = -0.3166,
        P1v = -13.8,
        P1d = 7003,
        DT = 0.01,
        DD = 2,
        TF = 180,
        T = 0,
        TD = 0,
        Mzm = 0,
        Vpr;

    double dxt_, m, VV;

    List<double> X = [], Y = List.filled(6, 0);

    switch (variant) {
      case Variant.first:
        {
          break;
        }
      case Variant.second:
        {
          break;
        }
      case Variant.third:
        {
          break;
        }
    }

    m = G / g;
    cx = cxhp;
    Mhp = V / an;
    dxt_ = xt_ - 0.24;
    dny = (mza / cya) + ((p * S * ba) / (2 * m)) * mzw_;

    double cyhp = (2 * G) / (S * p * pow(V, 2));
    double agp = 57.3 * (cyhp - cy0) / cya;

    Vpr = V * (3600.0 / 1000.0) * sqrt(p / 0.1249);
    sigmav = mCyZ * (1 + cMy * (Mzm / (2 * cyhp))) - Mzm * (Mhp / (2 * cyhp));
    sigmany = mCyZ + (p * S * ba / (2 * m)) * mzw_;
    wv = (g / V) * (sqrt(2 * sigmav / sigmany));

    CalculationResults results = CalculationResults(
      C1: (-mzw_ / Iz) * S * pow(ba, 2) * ((p * V) / 2),
      C2: (-mza / Iz) * S * ba * (p * pow(V, 2) / 2),
      C3: (-m_z / Iz) * S * ba * (p * pow(V, 2) / 2),
      C4: ((cya + cxhp) / m) * S * (p * V / 2),
      C5: (-mza_ / Iz) * S * pow(ba, 2) * (p * V / 2),
      C6: V / 57.3,
      C7: g / 57.3,
      C8: ((c_Ax - cyhp) / (57.3 * m)) * S * (p * pow(V, 2) / 2),
      C9: (c_y / m) * S * (p * V / 2),
      C16: V / (57.3 * g),
      C17: ((-cya * dxt_) / Iz) * S * ba * (p * pow(V, 2) / 2),
      C18: ((-c_y * dxt_) / Iz) * S * ba * (p * pow(V, 2) / 2),
      C19: -(ndv * P1d) / (57.3 * m),
      e1: (cx + (cMx * Mhp) / 2 - (ndv * P1v) / (p * V * S)) * S * p * V / m,
      e2: (cyhp + (cMy * Mhp) / 2) * S * (57.3 * p) / m,
      e3: 57.3 * ndv * P1v * Ydv / Iz,
      agp: agp,
      cyhp: cyhp,
      dvgp: 57.3 * (mz0 + (mza * agp / 57.3) + cyhp * (xt_ - 0.24)) / m_z,
      dvny: -57.3 * dny * (cyhp / m_z),
      Tv: 2 * 3.14 / wv,
    );

    Y[0] = 97.2;
    Y[5] = 0;
    VV = 0;
    while (T <= TF) {
      //DIN
      X.add(-results.e1 * VV -
          results.C8 * Y[4] -
          results.C7 * Y[1] -
          results.C19 * throttle);
      X.add(Y[2]);
      X.add(-results.C1 * Y[2] -
          (results.C2 + results.C17) * Y[4] -
          /*results.C5 * X[4]*/ -results.e3 * VV -
          (results.C3 + results.C18) * elevatingRudder);
      X.add(results.C4 * Y[4] + results.e2 * VV + results.C9 * elevatingRudder);
      X.add(X[1] - X[3]);
      X.add(results.C6 * Y[3]);
      //X[0] - кутова земна швидкість
      //X[1] - кутове прискорення тангажу
      //X[2] - кутова швидкість тангажу
      //X[3] - швидкість зміни кута нахилу траекторії
      //X[4] - швидкість зміни кута атаки
      //X[5] - швидкість зміни висоти польоту

      VV = Y[0] - wind; // істинна повітряна швидкість

      NY = results.C16 * X[3];
      //Ellier
      for (int i = 0; i < 6; i++) {
        Y[i] = Y[i] + X[i] * DT;
      }
      if (T >= TD) {
        results.time.add(T);

        results.massY5.add(Y[5]);
        results.massVV.add(VV);
        results.massWX.add(wind);
        results.massY1.add(Y[1]);
        results.massY3.add(Y[3]);
        results.massY0.add(Y[0]);
        results.massX.add(X[0]);
        results.massDV.add(elevatingRudder);
        results.massDG.add(throttle);
        results.massNY.add(NY);

        TD = TD + DD;
      }

      T = T + DT;
    }

    return results;
  }
}

enum Variant {
  first,
  second,
  third,
}

class CalculationResults {
  final List<double> time = [],
      massNY = [],
      massWX = [],
      massVV = [],
      massY5 = [],
      massY0 = [],
      massY3 = [],
      massX = [],
      massDV = [],
      massDG = [],
      massY1 = [];

  final double C1,
      C2,
      C3,
      C4,
      C5,
      C6,
      C7,
      C8,
      C9,
      C16,
      C17,
      C18,
      C19,
      e1,
      e2,
      e3,
      agp,
      cyhp,
      dvgp,
      dvny,
      Tv;

  CalculationResults({
    required this.C1,
    required this.C2,
    required this.C3,
    required this.C4,
    required this.C5,
    required this.C6,
    required this.C7,
    required this.C8,
    required this.C9,
    required this.C16,
    required this.C17,
    required this.C18,
    required this.C19,
    required this.e1,
    required this.e2,
    required this.e3,
    required this.agp,
    required this.cyhp,
    required this.dvgp,
    required this.dvny,
    required this.Tv,
  });
}
