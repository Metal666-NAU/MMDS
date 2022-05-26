import 'dart:math';

class CalculationsRepository {
  final Random random = Random();

  CalculationResults calculate({
    double heightStabilization = 0,
    double turbulentWindVerticalSpeed = 0,
    double flightTime = 30,
    double outputInterval = 0.5,
    bool autoStabilization = false,
    double elevatingRudder = -2,
    Variant variant = Variant.first,
  }) {
    const int Q = 31;

    final List<double> x = List.filled(5, 0),
        y = List.filled(5, 0),
        t = [],
        Wy = [],
        Dv = [],
        Y3 = [],
        Y0 = [],
        Y4 = [],
        Ny = [];

    const double S = 201.45,
        ba = 5.285,
        G = 73000,
        Xt = 0.24,
        Iz = 660000,
        g = 9.81,
        m = G / g;

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
        ab = 0,
        da = 0,
        W0,
        W1,
        A1 = 0,
        A0 = 0,
        R = V / 300,
        NY = 0,
        dH = 0,
        N,
        HR,
        SUMHR,
        HN,
        c1 = -(mwzz * S * ba * ba * p * V) / (Iz * 2),
        c2 = -(maz * S * ba * p * V * V) / (Iz * 2),
        c3 = -(mdbz * S * ba * p * V * V) / (Iz * 2),
        c4 = ((Cay + Cx) * S * p * V) / (m * 2),
        c5 = -(mazm * S * ba * ba * p * V) / (Iz * 2),
        c6 = V / 57.3,
        c9 = (Cdby * S * p * V) / (m * 2),
        c16 = V / (57.3 * g);

    while (T < flightTime) {
      for (int a = 0; a <= (flightTime / DT); a++) {
        if (autoStabilization) {
          elevatingRudder = (0.1 * dH + 0.4 * x[4] + 3 * y[1]).clamp(-10, 10);
          dH = y[4] - heightStabilization;
        }

        N = 0;
        HR = 0;
        SUMHR = 0;
        HN = 0;

        for (int j = 0; j < 13; j++) {
          N += 1;

          if (N <= 12) {
            HR = random.nextDouble();
            SUMHR += HR;
          } else {
            HN = (SUMHR - 6) / 6;
          }
        }

        N = 0;
        W0 = A1 + (1.73 * sqrt(R) * HN * turbulentWindVerticalSpeed) / sqrt(DT);
        W1 = -2 * R * A1 - R * R * A0 - (2.46 * R * sqrt(R) * HN) / sqrt(DT);

        A0 += W0 * DT;
        A1 += W1 * DT;

        x[0] = y[1];
        x[1] = -c1 * y[1] - c2 * ab - c5 * x[3] - c3 * elevatingRudder;
        x[2] = c4 * ab + c9 * elevatingRudder;
        x[3] = x[0] - x[2];
        x[4] = c6 * y[2];
        NY = c16 * x[2];
        ab = y[3] + da;
        da = A0 / c6;

        for (int j = 0; j < 5; j++) {
          y[j] = y[j] + x[j] * DT;
        }

        if (T >= TD) {
          t.add(T);
          Wy.add(A0);
          Dv.add(elevatingRudder);
          Y3.add(y[3]);
          Y0.add(y[0]);
          Y4.add(y[4]);
          Ny.add(NY);

          TD += outputInterval;
        }

        T += DT;
      }
    }

    double MW1 = 0, MW2 = 0, MS1 = 0, MS2 = 0;

    for (int i = 0; i < Ny.length; i++) {
      MW1 += Ny[i];
      MW2 += Y4[i];
    }

    MW1 /= Q;
    MW2 /= Q;

    for (int i = 0; i < Ny.length; i++) {
      MS1 += (Ny[i] - MW1) * (Ny[i] - MW1);
      MS2 += (Y4[i] - MW2) * (Y4[i] - MW2);
    }

    MS1 = sqrt((MS1 - MW1) / (Q - 1));
    MS2 = sqrt((MS2 - MW1) / (Q - 1));

    double Cybal = 2 * G / (S * p * V * V),
        abal = 57.3 * ((Cybal - Cy) / Cay),
        dvbal =
            -57.3 * ((mz + (maz * abal / 57.3) + Cybal * (Xt - 0.24)) / mdbz),
        dmx1 = 1.96 * MS1 / sqrt(Q),
        ddx1 = 1.98 * MS1 * MS1 * sqrt(2 / (Q - 1)),
        dmx2 = 1.96 * MS2 / sqrt(Q),
        ddx2 = 1.98 * MS2 * MS2 * sqrt(2 / (Q - 1));

    return CalculationResults(
      time: t,
      Wy: Wy,
      Dv: Dv,
      Y3: Y3,
      Y0: Y0,
      Y4: Y4,
      Ny: Ny,
      Cybal: Cybal,
      abal: abal,
      dvbal: dvbal,
      MW1: MW1,
      MW2: MW2,
      MS1: MS1,
      MS2: MS2,
      MAX1: MW1.abs() + 2 * MS1,
      MAX2: MW2.abs() + 2 * MS2,
      Imx11: MW1 - dmx1,
      Imx12: MW1 + dmx1,
      Imx21: MW2 - dmx2,
      Imx22: MW2 + dmx2,
      Idx11: sqrt(MS1 * MS1 - ddx1 * ddx1),
      Idx12: sqrt(MS1 * MS1 + ddx1 * ddx1),
      Idx21: sqrt(MS2 * MS2 - ddx2 * ddx2),
      Idx22: sqrt(MS2 * MS2 + ddx2 * ddx2),
      Ta: 2 * pi / sqrt(c2 + c1 * c4),
    );
  }
}

enum Variant {
  first,
  second,
  third,
}

class CalculationResults {
  final List<double> time, Wy, Dv, Y3, Y0, Y4, Ny;

  final double Cybal,
      abal,
      dvbal,
      MW1,
      MW2,
      MS1,
      MS2,
      MAX1,
      MAX2,
      Imx11,
      Imx12,
      Imx21,
      Imx22,
      Idx11,
      Idx12,
      Idx21,
      Idx22,
      Ta;

  CalculationResults({
    required this.time,
    required this.Wy,
    required this.Dv,
    required this.Y3,
    required this.Y0,
    required this.Y4,
    required this.Ny,
    required this.Cybal,
    required this.abal,
    required this.dvbal,
    required this.MW1,
    required this.MW2,
    required this.MS1,
    required this.MS2,
    required this.MAX1,
    required this.MAX2,
    required this.Imx11,
    required this.Imx12,
    required this.Imx21,
    required this.Imx22,
    required this.Idx11,
    required this.Idx12,
    required this.Idx21,
    required this.Idx22,
    required this.Ta,
  });
}
