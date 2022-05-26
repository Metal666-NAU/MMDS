import 'dart:math';

class CalculationsRepository {
  final Random random = Random();

  CalculationResults calculate({
    double elevatingRudder = -2,
    bool autoStabilization = false,
    double pilotGain = 1,
    double latentReactionTime = 1,
    double T2 = 1,
    double T3 = 0.15,
    Variant variant = Variant.first,
  }) {
    const int Q = 41;

    final List<double> x = List.filled(10, 0),
        y = List.filled(10, 0),
        t = [],
        Dx = [],
        Dv = [],
        Y0 = [],
        Y4 = [],
        Ny = [];

    const double S = 201.45,
        ba = 5.285,
        G = 73000,
        Xt = 0.24,
        Iz = 660000,
        g = 9.81,
        m = G / g,
        TGZAD = 5,
        T1 = 1.1;

    double V, H0, p, an, Cy, Cay, Cdby, Cx, mz, mwzz, mazm, maz, mdbz;

    switch (variant) {
      case Variant.first:
        {
          V = 97.2;
          H0 = 500;
          p = 0.119;
          an = 338.36;

          Cy = -0.255;
          Cay = 5.78;
          Cdby = 0.2865;
          Cx = 0.046;
          mz = 0.2;
          mwzz = -13;
          mazm = -3.8;
          maz = -1.83;
          mdbz = -0.96;

          break;
        }
      case Variant.second:
        {
          V = 190;
          H0 = 6400;
          p = 0.0636;
          an = 314.34;

          Cy = -0.28;
          Cay = 5.9;
          Cdby = 0.2865;
          Cx = 0.033;
          mz = 0.22;
          mwzz = -13.4;
          mazm = -4;
          maz = -1.95;
          mdbz = -0.92;

          break;
        }
      case Variant.third:
        {
          V = 250;
          H0 = 11300;
          p = 0.0372;
          an = 295.06;

          Cy = -0.32;
          Cay = 6.3;
          Cdby = 0.2635;
          Cx = 0.031;
          mz = 0.27;
          mwzz = -15.5;
          mazm = -5.2;
          maz = -2.69;
          mdbz = -0.92;

          break;
        }
    }

    double T = 0,
        DT = 0.01,
        TD = 0,
        TF = 20,
        DD = 0.5,
        KS = 0.112,
        NY,
        XV = -17.86,
        F11,
        F12,
        F21,
        F22,
        DX,
        kx,
        DTG,
        c1 = -(mwzz * S * ba * ba * p * V) / (Iz * 2),
        c2 = -(maz * S * ba * p * V * V) / (Iz * 2),
        c3 = -(mdbz * S * ba * p * V * V) / (Iz * 2),
        c4 = ((Cay + Cx) * S * p * V) / (m * 2),
        c5 = -(mazm * S * ba * ba * p * V) / (Iz * 2),
        c6 = V / 57.3,
        c9 = (Cdby * S * p * V) / (m * 2),
        c16 = V / (57.3 * g),
        Cybal = 2 * G / (S * p * V * V),
        abal = 57.3 * ((Cybal - Cy) / Cay),
        dvbal =
            -57.3 * ((mz + (maz * abal / 57.3) + Cybal * (Xt - 0.24)) / mdbz),
        Xsbal = dvbal / KS,
        N = 0,
        U1 = 0,
        U2 = 0,
        U21 = 0,
        U22 = 0,
        XSH = 0,
        NDT = latentReactionTime / DT;

    while (T < TF) {
      for (int a = 0; a <= (TF / DT); a++) {
        if (autoStabilization) {
          F11 = 16 - dvbal;
          F12 = -29 - dvbal;
          F21 = 156 - Xsbal;
          F22 = -250 - Xsbal;
          kx = (Xsbal - 20) / 120;

          DX = XSH.clamp(F22, F21);
          elevatingRudder = (KS * (1 - kx) * DX + y[1]).clamp(F12, F11);
        } else {
          elevatingRudder = -2;
          DX = XV;
        }

        x[0] = y[1];
        x[1] = -c1 * y[1] - c2 * y[3] - c5 * x[3] - c3 * elevatingRudder;
        x[2] = c4 * y[3] + c9 * elevatingRudder;
        x[3] = x[0] - x[2];
        x[4] = c6 * y[2];
        NY = c16 * x[2];

        if (++N >= NDT) {
          DTG = y[0] - TGZAD;
          U1 = DTG;
          N = 0;
        }

        x[5] = U21;
        U21 = (pilotGain * T1 * U1 - y[5]) / T2;
        x[6] = (pilotGain * U1 - y[6]) / T2;
        U22 = y[6];
        U2 = U21 + U22;

        x[7] = (U2 - y[7]) / T3;
        XSH = y[7];

        for (int j = 0; j < 10; j++) {
          y[j] = y[j] + x[j] * DT;
        }

        if (T >= TD) {
          t.add(T);
          Dx.add(DX);
          Dv.add(elevatingRudder);
          Y0.add(y[0]);
          Y4.add(y[4]);
          Ny.add(NY);

          TD += DD;
        }

        T += DT;
      }
    }

    return CalculationResults(
      time: t,
      Dx: Dx,
      Dv: Dv,
      Y0: Y0,
      Y4: Y4,
      Ny: Ny,
      Cybal: Cybal,
      abal: abal,
      dvbal: dvbal,
      Xsbal: Xsbal,
    );
  }
}

enum Variant {
  first,
  second,
  third,
}

class CalculationResults {
  final List<double> time, Dx, Dv, Y0, Y4, Ny;

  final double Cybal, abal, dvbal, Xsbal;

  CalculationResults({
    required this.time,
    required this.Dx,
    required this.Dv,
    required this.Y0,
    required this.Y4,
    required this.Ny,
    required this.Cybal,
    required this.abal,
    required this.dvbal,
    required this.Xsbal,
  });
}
