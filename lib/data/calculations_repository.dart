class CalculationsRepository {
  CalculationResults calculate({
    double integrationStep = 0.01,
    Damper damper = Damper.none,
    Variant variant = Variant.first,
  }) {
    const double wingArea = 201.45;
    const double wingChord = 5.285;
    const double planeWeight = 73000;
    const double center = 0.24;
    const double momentOfInertia = 660000;

    const double flightDuration = 20;
    const double displayStep = 0.5;
    const double ks = 0.112;
    const double kwz = 1;
    const double twz = 0.7;
    const double xv = -17.86;

    double v;
    double p;

    const double gravity = 9.81;
    const double m = planeWeight / gravity;

    double cy;
    double cay;
    double cdby;
    double cx;
    double mz;
    double mwzz;
    double mazm;
    double maz;
    double mdbz;

    switch (variant) {
      case Variant.first:
        {
          v = 97.2;
          p = 0.119;

          cy = -0.255;
          cay = 5.78;
          cdby = 0.2865;
          cx = 0.046;
          mz = 0.2;
          mwzz = -13;
          mazm = -3.8;
          maz = -1.83;
          mdbz = -0.96;

          break;
        }
      case Variant.second:
        {
          v = 190;
          p = 0.0636;

          cy = -0.28;
          cay = 5.9;
          cdby = 0.2865;
          cx = 0.033;
          mz = 0.22;
          mwzz = -13.4;
          mazm = -4.0;
          maz = -1.95;
          mdbz = -0.92;

          break;
        }
      case Variant.third:
        {
          v = 250;
          p = 0.0372;

          cy = -0.32;
          cay = 6.3;
          cdby = 0.2635;
          cx = 0.031;
          mz = 0.27;
          mwzz = -15.5;
          mazm = -5.2;
          maz = -2.69;
          mdbz = -0.92;

          break;
        }
    }

    double elapsedTime = 0;
    double displayTime = 0;

    final double sigmany =
        (maz / cay) + (p * wingArea * wingChord * mwzz / (2 * m));
    final double cybal = 2 * planeWeight / (wingArea * p * v * v);
    final double abal = 57.3 * ((cybal - cy) / cay);

    final CalculationResults results = CalculationResults(
      cybal,
      abal,
      -57.3 * ((mz + (maz * abal / 57.3) + cybal * (center - 0.24)) / mdbz),
      -57.3 * sigmany * cybal / mdbz,
    );

    final double c1 = -(mwzz * wingArea * wingChord * wingChord * p * v) /
        (momentOfInertia * 2);
    final double c2 =
        -(maz * wingArea * wingChord * p * v * v) / (momentOfInertia * 2);
    final double c3 =
        -(mdbz * wingArea * wingChord * p * v * v) / (momentOfInertia * 2);
    final double c4 = ((cay + cx) * wingArea * p * v) / (m * 2);
    final double c5 = -(mazm * wingArea * wingChord * wingChord * p * v) /
        (momentOfInertia * 2);
    final double c9 = (cdby * wingArea * p * v) / (m * 2);
    final double c16 = v / (57.3 * gravity);

    final List<double> x = List.filled(5, 0);
    final List<double> y = List.filled(5, 0);

    while (elapsedTime < flightDuration) {
      for (int a = 0; a <= (flightDuration / integrationStep); a++) {
        double dvd;

        switch (damper) {
          case Damper.none:
            {
              dvd = 0;
              break;
            }
          case Damper.type_1:
            {
              dvd = kwz * y[1];
              break;
            }
          case Damper.type_2:
            {
              dvd = kwz * y[1] - y[4] / twz;
              break;
            }
        }

        double dv = ks * xv + dvd;

        x[0] = y[1];
        x[1] = -c1 * y[1] - c2 * y[3] - c5 * x[3] - c3 * dv;
        x[2] = c4 * y[3] + c9 * dv;
        x[3] = x[0] - x[2];
        double ny = c16 * x[2];

        for (int j = 0; j < 5; j++) {
          y[j] = y[j] + x[j] * integrationStep;
        }

        if (elapsedTime >= displayTime) {
          results.t.add(elapsedTime);
          results.xb.add(xv);
          results.dv.add(dv);
          results.y2.add(y[2]);
          results.y3.add(y[3]);
          results.ny.add(ny);
          displayTime = displayTime + displayStep;
        }
        elapsedTime = elapsedTime + integrationStep;
      }
    }

    return results;
  }
}

enum Damper {
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
  final List<double> t = [];
  final List<double> xb = [];
  final List<double> dv = [];
  final List<double> y2 = [];
  final List<double> y3 = [];
  final List<double> ny = [];

  final double cybal, abal, dvbal, dnyv;

  CalculationResults(
    this.cybal,
    this.abal,
    this.dvbal,
    this.dnyv,
  );
}
