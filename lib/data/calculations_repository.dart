class CalculationsRepository {
  //final int Q = 41;

  CalculationResults calculate({
    double integrationStep = 0.01,
    Damper damper = Damper.none,
  }) {
    final List<double> x = [];
    final List<double> y = [];

    const double wingArea = 201.45;
    const double wingChord = 5.285;
    const double planeWeight = 73000;
    const double center = 0.24;
    const double momentOfInertia = 660000;

    const double v = 97.2;
    //const double h0 = 500;
    const double p = 0.119;
    //const double an = 338.36;
    const double gravity = 9.81;

    const double cy = -0.255;
    const double cay = 5.78;
    const double cdby = 0.2865;
    const double cx = 0.046;
    const double mz = 0.2;
    const double mwzz = -13;
    const double mazm = -3.8;
    const double maz = -1.83;
    const double mdbz = -0.96;
    const double m = planeWeight / gravity;
    const double flightDuration = 20;
    const double displayStep = 0.5;
    const double ks = 0.112;
    const double kwz = 1;
    const double twz = 0.7;
    const double xv = -17.86;

    double elapsedTime = 0;
    double displayTime = 0;

    int aa = 0;

    const double sigmany =
        (maz / cay) + (p * wingArea * wingChord * mwzz / (2 * m));
    const double cybal = 2 * planeWeight / (wingArea * p * v * v);
    const double abal = 57.3 * ((cybal - cy) / cay);

    final CalculationResults results = CalculationResults(
      cybal,
      abal,
      -57.3 * ((mz + (maz * abal / 57.3) + cybal * (center - 0.24)) / mdbz),
      -57.3 * sigmany * cybal / mdbz,
    );

    const double c1 = -(mwzz * wingArea * wingChord * wingChord * p * v) /
        (momentOfInertia * 2);
    const double c2 =
        -(maz * wingArea * wingChord * p * v * v) / (momentOfInertia * 2);
    const double c3 =
        -(mdbz * wingArea * wingChord * p * v * v) / (momentOfInertia * 2);
    const double c4 = ((cay + cx) * wingArea * p * v) / (m * 2);
    const double c5 = -(mazm * wingArea * wingChord * wingChord * p * v) /
        (momentOfInertia * 2);
    const double c9 = (cdby * wingArea * p * v) / (m * 2);
    const double c16 = v / (57.3 * gravity);

    for (int i = 0; i < 5; i++) {
      x[i] = 0;
      y[i] = 0;
    }

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
          results.t[aa] = elapsedTime;
          results.xb[aa] = xv;
          results.dv[aa] = dv;
          results.y2[aa] = y[2];
          results.y3[aa] = y[3];
          results.ny[aa] = ny;
          displayTime = displayTime + displayStep;
          aa++;
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
