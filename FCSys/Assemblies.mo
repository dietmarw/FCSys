within FCSys;
package Assemblies "Combinations of regions (e.g., cells)"
  extends Modelica.Icons.Package;

  package Cells "Single-cell PEMFC models"
    extends Modelica.Icons.Package;
    package Examples "Examples"

      model Cell "<html>Isolated <code>Cell</code> model</html>"
        extends Modelica.Icons.Example;

        inner FCSys.Conditions.Environment environment
          annotation (Placement(transformation(extent={{20,20},{40,40}})));
        replaceable Cells.Cell cell "Fuel cell" annotation (
            __Dymola_choicesFromPackage=true, Placement(transformation(extent={
                  {-10,-10},{10,10}})));
        annotation (experiment(StopTime=1e-24, Tolerance=1e-06), Commands(file=
                "Resources/Scripts/Dymola/Assemblies.Cells.Examples.Cell.mos"
              "Assemblies.Cells.Examples.Cell.mos"));

      end Cell;
      extends Modelica.Icons.ExamplesPackage;

      model Polarization "Run a cell polarization"
        extends Modelica.Icons.Example;

        /* **
                 params=dict(comp=['"O2"'],
                             anStoich=[1.5, 1.1, 2],
                             caStoich=[9.5, 7.5, 12.5],
                             anRH=[0.8, 0.6, 1],
                             caRH=[0.5, 0.3, 0.7],
                             T_degC=[60, 40, 80],
                             p_kPag=[48.3, 0, 202.7]),
                             */
        inner FCSys.Conditions.Environment environment
          "Environmental conditions"
          annotation (Placement(transformation(extent={{30,32},{50,52}})));

        Conditions.TestStands.TestStand testStand(anEnd(each graphite('incle-'=
                  true, 'e-'(redeclare Modelica.Blocks.Sources.Ramp
                  materialSpec(height=10000*U.A, duration=500)))), caEnd(each
              graphite('incle-'=true, 'e-'(redeclare
                  Modelica.Blocks.Sources.Ramp materialSpec(height=-10000*U.A,
                    duration=500))))) annotation (__Dymola_choicesFromPackage=
              true, Placement(transformation(extent={{-16,-16},{16,16}})));

        replaceable Cells.Cell cell "Fuel cell" annotation (
            __Dymola_choicesFromPackage=true, Placement(transformation(extent={
                  {-10,-10},{10,10}})));
      equation

        connect(testStand.an, cell.an) annotation (Line(
            points={{-16,9.4369e-16},{-14,9.4369e-16},{-14,6.10623e-16},{-10,
                6.10623e-16}},
            color={127,127,127},
            thickness=0.5,
            smooth=Smooth.None));

        connect(cell.ca, testStand.ca) annotation (Line(
            points={{10,6.10623e-16},{14,6.10623e-16},{14,9.4369e-16},{16.2,
                9.4369e-16}},
            color={127,127,127},
            thickness=0.5,
            smooth=Smooth.None));

        connect(testStand.anPositive, cell.anPositive) annotation (Line(
            points={{-4,16},{-4,14.5},{-4,14.5},{-4,13},{-4,10},{-4,10}},
            color={240,0,0},
            thickness=0.5,
            smooth=Smooth.None));
        connect(testStand.caNegative, cell.caNegative) annotation (Line(
            points={{4,-16},{4,-14.5},{4,-14.5},{4,-13},{4,-10},{4,-10}},
            color={0,0,240},
            thickness=0.5,
            smooth=Smooth.None));
        connect(cell.anNegative, testStand.anNegative) annotation (Line(
            points={{-4,-10},{-4,-11.5},{-4,-11.5},{-4,-13},{-4,-16},{-4,-16}},

            color={240,0,0},
            thickness=0.5,
            smooth=Smooth.None));

        connect(cell.caPositive, testStand.caPositive) annotation (Line(
            points={{4,10},{4,11.5},{4,11.5},{4,13},{4,16},{4,16}},
            color={0,0,240},
            thickness=0.5,
            smooth=Smooth.None));

        annotation (Commands(file=
                "Resources/Scripts/Dymola/Assemblies.Cells.Examples.Polarization.mos"
              "Assemblies.Cells.Examples.Polarization.mos"), Diagram(graphics));
      end Polarization;

      model PolarizationPlaceholder "**temp"
        extends Modelica.Icons.Example;

        /* **
                 params=dict(comp=['"O2"'],
                             anStoich=[1.5, 1.1, 2],
                             caStoich=[9.5, 7.5, 12.5],
                             anRH=[0.8, 0.6, 1],
                             caRH=[0.5, 0.3, 0.7],
                             T_degC=[60, 40, 80],
                             p_kPag=[48.3, 0, 202.7]),
                             */
      end PolarizationPlaceholder;

      model EIS "Model for electrochemical-impedance spectroscopy"
        import FCSys;
        extends FCSys.BaseClasses.Icons.Blocks.Continuous;

        parameter Modelica.SIunits.Current zI_large_A=100
          "Large-signal current in amperes";
        Connectors.RealInput zJ_small_SI
          "Small-signal current density in SI base units" annotation (Placement(
              transformation(extent={{-110,-10},{-90,10}}), iconTransformation(
                extent={{-120,-10},{-100,10}})));
        Connectors.RealOutput w_V "Cell potential in volts" annotation (
            Placement(transformation(extent={{90,-10},{110,10}}),
              iconTransformation(extent={{100,-10},{120,10}})));
        Conditions.TestStands.TestStandEIS testStandEIS
          annotation (Placement(transformation(extent={{-16,-16},{16,16}})));
        replaceable FCSys.Assemblies.Cells.Cell cell "Fuel cell model"
          annotation (__Dymola_choicesFromPackage=true, Placement(
              transformation(extent={{-10,-10},{10,10}})));
        inner FCSys.Conditions.Environment environment(
          analysis=false,
          p=149.6*U.kPa,
          T=333.15*U.K) "Environmental conditions"
          annotation (Placement(transformation(extent={{30,32},{50,52}})));
      equation
        connect(zJ_small_SI, testStandEIS.zJ_small_SI) annotation (Line(
            points={{-100,5.55112e-16},{-40,5.55112e-16},{-40,20},{-20,20},{-16,
                16.4},{-16.7,16.7}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(testStandEIS.w_V, w_V) annotation (Line(
            points={{16.7,-16.7},{16,-16},{20,-20},{40,-20},{40,0},{70,0},{70,
                5.55112e-16},{100,5.55112e-16}},
            color={0,0,127},
            smooth=Smooth.None));

        connect(testStandEIS.caNegative, cell.caNegative) annotation (Line(
            points={{4,-16},{4,-10}},
            color={0,0,240},
            thickness=0.5,
            smooth=Smooth.None));
        connect(testStandEIS.anPositive, cell.anPositive) annotation (Line(
            points={{-4,16},{-4,10}},
            color={240,0,0},
            thickness=0.5,
            smooth=Smooth.None));
        connect(testStandEIS.an, cell.an) annotation (Line(
            points={{-16,9.4369e-16},{-10,6.10623e-16}},
            color={127,127,127},
            thickness=0.5,
            smooth=Smooth.None));
        connect(cell.anNegative, testStandEIS.anNegative) annotation (Line(
            points={{-4,-10},{-4,-16}},
            color={240,0,0},
            thickness=0.5,
            smooth=Smooth.None));
        connect(cell.caPositive, testStandEIS.caPositive) annotation (Line(
            points={{4,10},{4,16}},
            color={0,0,240},
            thickness=0.5,
            smooth=Smooth.None));
        connect(cell.ca, testStandEIS.ca) annotation (Line(
            points={{10,6.10623e-16},{16.2,6.10623e-16},{16.2,9.4369e-16}},
            color={127,127,127},
            thickness=0.5,
            smooth=Smooth.None));
        annotation (Diagram(graphics), Icon(graphics));
      end EIS;

      model EISPlaceholder
        "Placeholder model for electrochemical-impedance spectroscopy"
        extends FCSys.BaseClasses.Icons.Blocks.Continuous;

        parameter Modelica.SIunits.CurrentDensity zJ_large_SI=0.01
          "Large-signal current density in SI base units";
        Modelica.Electrical.Analog.Basic.Resistor resistor2(R=0.1) annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={10,-10})));
        Modelica.Electrical.Analog.Basic.Capacitor capacitor(C=1e-3)
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={40,-10})));
        Modelica.Electrical.Analog.Sources.ConstantVoltage constantVoltage(V=1)
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={-80,-10})));
        Modelica.Electrical.Analog.Sensors.VoltageSensor voltageSensor
          annotation (Placement(transformation(
              extent={{-10,10},{10,-10}},
              rotation=270,
              origin={70,-10})));
        Modelica.Electrical.Analog.Sources.ConstantCurrent constantCurrent(I=
              zJ_large_SI)
          annotation (Placement(transformation(extent={{-60,20},{-40,0}})));
        Modelica.Electrical.Analog.Sources.SignalCurrent signalCurrent
          annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
        Connectors.RealInput zJ_small_SI
          "Small-signal cell current density in SI base units" annotation (
            Placement(transformation(extent={{-110,40},{-90,60}}),
              iconTransformation(extent={{-120,-10},{-100,10}})));
        Connectors.RealOutput w_V "Cell potential in volts" annotation (
            Placement(transformation(extent={{90,-20},{110,0}}),
              iconTransformation(extent={{100,-10},{120,10}})));
        Modelica.Electrical.Analog.Basic.Resistor resistor1(R=0.1) annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-10,10})));
        Modelica.Electrical.Analog.Basic.Ground ground
          annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
      equation
        connect(zJ_small_SI, signalCurrent.i) annotation (Line(
            points={{-100,50},{-50,50},{-50,37}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(signalCurrent.n, constantCurrent.n) annotation (Line(
            points={{-40,30},{-30,30},{-30,10},{-40,10}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(signalCurrent.p, constantCurrent.p) annotation (Line(
            points={{-60,30},{-70,30},{-70,10},{-60,10}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(constantVoltage.p, constantCurrent.p) annotation (Line(
            points={{-80,5.55112e-16},{-80,10},{-60,10}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(voltageSensor.v, w_V) annotation (Line(
            points={{80,-10},{90,-10},{90,-10},{100,-10}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(resistor2.p, capacitor.p) annotation (Line(
            points={{10,5.55112e-16},{10,10},{40,10},{40,5.55112e-16}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(constantVoltage.n, resistor2.n) annotation (Line(
            points={{-80,-20},{-80,-30},{10,-30},{10,-20}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(capacitor.n, resistor2.n) annotation (Line(
            points={{40,-20},{40,-30},{10,-30},{10,-20}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(capacitor.n, voltageSensor.n) annotation (Line(
            points={{40,-20},{40,-30},{70,-30},{70,-20}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(capacitor.p, voltageSensor.p) annotation (Line(
            points={{40,5.55112e-16},{40,10},{70,10},{70,5.55112e-16}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(constantCurrent.n, resistor1.p) annotation (Line(
            points={{-40,10},{-20,10}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(resistor1.n, resistor2.p) annotation (Line(
            points={{5.55112e-16,10},{10,10},{10,5.55112e-16}},
            color={0,0,255},
            smooth=Smooth.None));
        connect(ground.p, voltageSensor.n) annotation (Line(
            points={{70,-40},{70,-20}},
            color={0,0,255},
            smooth=Smooth.None));
        annotation (Diagram(graphics), Icon(graphics));
      end EISPlaceholder;
    end Examples;

    model Cell "Single-cell PEMFC"
      import FCSys.BaseClasses.Utilities.average;
      extends FCSys.BaseClasses.Icons.Cell;

      // Geometric parameters
      parameter Q.Length L_y[:]={U.m}
        "<html>Lengths along the channel (L<sub>y</sub>)</html>"
        annotation (Dialog(group="Geometry"));
      parameter Q.Length L_z[:]={5*U.mm}
        "<html>Lengths across the channel (L<sub>z</sub>)</html>"
        annotation (Dialog(group="Geometry"));
      final parameter Integer n_y=size(L_y, 1)
        "Number of subregions along the channel";
      final parameter Integer n_z=size(L_z, 1)
        "Number of subregions across the channel";

      Connectors.FaceBus an[n_y, n_z] "Interface with the anode end plate"
        annotation (Placement(transformation(extent={{-90,-10},{-70,10}},
              rotation=0), iconTransformation(extent={{-110,-10},{-90,10}})));
      Connectors.FaceBus ca[n_y, n_z] "Interface with the cathode end plate"
        annotation (Placement(transformation(extent={{70,-10},{90,10}},
              rotation=0), iconTransformation(extent={{90,-10},{110,10}})));
      Connectors.FaceBus anNegative[anFP.n_x, n_z] "Negative anode fluid port"
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-60,-20}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={-40,-100})));
      Connectors.FaceBus caNegative[caFP.n_x, n_z]
        "Negative cathode fluid port" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={60,-20}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={40,-100})));
      Connectors.FaceBus anPositive[anFP.n_x, n_z] "Positive anode fluid port"
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-60,20}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={-40,100})));
      Connectors.FaceBus caPositive[caFP.n_x, n_z]
        "Positive cathode fluid port" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={60,20}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={40,100})));

      replaceable Regions.AnFPs.AnFP anFP(final L_y=L_y, final L_z=L_z)
        "Anode flow plate" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Layers"),
        Placement(transformation(extent={{-70,-10},{-50,10}})));
      replaceable Regions.AnGDLs.AnGDL anGDL(final L_y=L_y, final L_z=L_z)
        "Anode gas diffusion layer" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Layers"),
        Placement(transformation(extent={{-50,-10},{-30,10}})));
      replaceable Regions.AnCLs.AnCL anCL(final L_y=L_y, final L_z=L_z)
        "Anode catalyst layer" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Layers"),
        Placement(transformation(extent={{-30,-10},{-10,10}})));
      replaceable Regions.PEMs.PEM PEM(final L_y=L_y, final L_z=L_z)
        "Proton exchange membrane" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Layers"),
        Placement(transformation(extent={{-10,-10},{10,10}})));
      replaceable Regions.CaCLs.CaCL caCL(final L_y=L_y, final L_z=L_z)
        "Cathode catalyst layer" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Layers"),
        Placement(transformation(extent={{10,-10},{30,10}})));
      replaceable Regions.CaGDLs.CaGDL caGDL(final L_y=L_y, final L_z=L_z)
        "Cathode gas diffusion layer" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Layers"),
        Placement(transformation(extent={{30,-10},{50,10}})));
      replaceable Regions.CaFPs.CaFP caFP(final L_y=L_y, final L_z=L_z)
        "Cathode flow plate" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Layers"),
        Placement(transformation(extent={{50,-10},{70,10}})));

    protected
      outer Conditions.Environment environment "Environmental conditions";

    equation
      // Internal connections (between layers)
      connect(anFP.xPositive, anGDL.xNegative) annotation (Line(
          points={{-50,6.10623e-16},{-50,6.10623e-16}},
          color={240,0,0},
          smooth=Smooth.None,
          thickness=0.5));
      connect(anGDL.xPositive, anCL.xNegative) annotation (Line(
          points={{-30,6.10623e-16},{-30,6.10623e-16}},
          color={240,0,0},
          smooth=Smooth.None,
          thickness=0.5));
      connect(anCL.xPositive, PEM.xNegative) annotation (Line(
          points={{-10,6.10623e-16},{-10,6.10623e-16}},
          color={240,0,0},
          smooth=Smooth.None,
          thickness=0.5));
      connect(PEM.xPositive, caCL.xNegative) annotation (Line(
          points={{10,6.10623e-16},{10,6.10623e-16},{10,6.10623e-16}},
          color={0,0,240},
          smooth=Smooth.None,
          thickness=0.5));
      connect(caCL.xPositive, caGDL.xNegative) annotation (Line(
          points={{30,6.10623e-16},{30,6.10623e-16}},
          color={0,0,240},
          smooth=Smooth.None,
          thickness=0.5));
      connect(caGDL.xPositive, caFP.xNegative) annotation (Line(
          points={{50,6.10623e-16},{50,6.10623e-16}},
          color={0,0,240},
          smooth=Smooth.None,
          thickness=0.5));

      // External connections
      connect(an, anFP.xNegative) annotation (Line(
          points={{-80,5.55112e-16},{-80,5.55112e-16},{-80,6.10623e-16},{-70,
              6.10623e-16}},
          color={127,127,127},
          smooth=Smooth.None,
          thickness=0.5));

      connect(anFP.yNegative, anNegative) annotation (Line(
          points={{-60,-10},{-60,-20}},
          color={240,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      connect(anFP.yPositive, anPositive) annotation (Line(
          points={{-60,10},{-60,20}},
          color={240,0,0},
          thickness=0.5,
          smooth=Smooth.None));

      connect(caFP.xPositive, ca) annotation (Line(
          points={{70,6.10623e-16},{80,5.55112e-16}},
          color={127,127,127},
          smooth=Smooth.None,
          thickness=0.5));
      connect(caFP.yNegative, caNegative) annotation (Line(
          points={{60,-10},{60,-20}},
          color={0,0,240},
          thickness=0.5,
          smooth=Smooth.None));
      connect(caFP.yPositive, caPositive) annotation (Line(
          points={{60,10},{60,20}},
          color={0,0,240},
          thickness=0.5,
          smooth=Smooth.None));
      annotation (
        defaultComponentPrefixes="replaceable",
        Documentation(info="
    <html><p>This is a model of a single-cell proton exchange membrane fuel cell (PEMFC).  An overview
    of a PEMFC is given in the <a href=\"modelica://FCSys\">top-level documentation of FCSys</a>.</p>
    </html>"),
        Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-80,-20},{
                80,20}}), graphics),
        Icon(coordinateSystem(
            preserveAspectRatio=true,
            extent={{-100,-100},{100,100}},
            initialScale=0.1), graphics={
            Line(
              points={{-40,-58},{-40,-100}},
              color={240,0,0},
              visible=inclY,
              smooth=Smooth.None,
              thickness=0.5),
            Line(
              points={{-8,-1},{28,-1}},
              color={0,0,240},
              visible=inclX,
              thickness=0.5,
              origin={39,-92},
              rotation=90),
            Line(
              points={{-40,100},{-40,60}},
              color={240,0,0},
              visible=inclY,
              smooth=Smooth.None,
              thickness=0.5),
            Line(
              points={{-66,0},{-100,0}},
              color={127,127,127},
              visible=inclX,
              thickness=0.5),
            Line(
              points={{-8,-1},{44,-1}},
              color={0,0,240},
              visible=inclX,
              thickness=0.5,
              origin={39,56},
              rotation=90),
            Line(
              points={{100,0},{56,0}},
              color={127,127,127},
              visible=inclX,
              thickness=0.5)}),
        experiment(StopTime=120, Tolerance=1e-06));
    end Cell;

    model SimpleCell
      "Cell model with integrated catalyst and gas diffusion layers"
      extends FCSys.BaseClasses.Icons.Cell;

      // Geometric parameters
      parameter Q.Length L_y[:]={U.m}
        "<html>Lengths along the channel (L<sub>y</sub>)</html>"
        annotation (Dialog(group="Geometry"));
      parameter Q.Length L_z[:]={5*U.mm}
        "<html>Lengths across the channel (L<sub>z</sub>)</html>"
        annotation (Dialog(group="Geometry"));
      final parameter Integer n_y=size(L_y, 1)
        "Number of subregions along the channel";
      final parameter Integer n_z=size(L_z, 1)
        "Number of subregions across the channel";

      Connectors.FaceBus an[n_y, n_z] "Interface with the anode end plate"
        annotation (Placement(transformation(extent={{-70,-10},{-50,10}},
              rotation=0), iconTransformation(extent={{-110,-10},{-90,10}})));
      Connectors.FaceBus ca[n_y, n_z] "Interface with the cathode end plate"
        annotation (Placement(transformation(extent={{50,-10},{70,10}},
              rotation=0), iconTransformation(extent={{90,-10},{110,10}})));
      Connectors.FaceBus anNegative[anFP.n_x, n_z] "Negative anode fluid port"
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-40,-20}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={-40,-100})));
      Connectors.FaceBus caNegative[caFP.n_x, n_z]
        "Negative cathode fluid port" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={40,-20}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={40,-100})));
      Connectors.FaceBus anPositive[anFP.n_x, n_z] "Positive anode fluid port"
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-40,20}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={-40,100})));
      Connectors.FaceBus caPositive[caFP.n_x, n_z]
        "Positive cathode fluid port" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={40,20}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={40,100})));

      replaceable Regions.AnFPs.AnFP anFP(final L_y=L_y, final L_z=L_z)
        "Anode flow plate" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Layers"),
        Placement(transformation(extent={{-50,-10},{-30,10}})));
      FCSys.Regions.Integrated.AnCGDL anCGDL(final L_y=L_y, final L_z=L_z)
        "Anode catalyst and gas diffusion layer" annotation (Dialog(group=
              "Layers"), Placement(transformation(extent={{-30,-10},{-10,10}})));

      replaceable Regions.PEMs.PEM PEM(final L_y=L_y, final L_z=L_z)
        "Proton exchange membrane" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Layers"),
        Placement(transformation(extent={{-10,-10},{10,10}})));
      FCSys.Regions.Integrated.CaCGDL caCGDL(final L_y=L_y, final L_z=L_z)
        "Cathode catalyst and gas diffusion layer" annotation (Dialog(group=
              "Layers"), Placement(transformation(extent={{10,-10},{30,10}})));

      replaceable Regions.CaFPs.CaFP caFP(final L_y=L_y, final L_z=L_z)
        "Cathode flow plate" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Layers"),
        Placement(transformation(extent={{30,-10},{50,10}})));

    protected
      outer Conditions.Environment environment "Environmental conditions";

    equation
      // Internal connections (between layers)
      connect(anFP.xPositive, anCGDL.xNegative) annotation (Line(
          points={{-30,6.10623e-16},{-30,6.10623e-16}},
          color={240,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      connect(anCGDL.xPositive, PEM.xNegative) annotation (Line(
          points={{-10,6.10623e-16},{-10,6.10623e-16}},
          color={240,0,0},
          smooth=Smooth.None,
          thickness=0.5));
      connect(PEM.xPositive, caCGDL.xNegative) annotation (Line(
          points={{10,6.10623e-16},{16,-3.36456e-22},{10,6.10623e-16}},
          color={0,0,240},
          smooth=Smooth.None,
          thickness=0.5));
      connect(caCGDL.xPositive, caFP.xNegative) annotation (Line(
          points={{30,6.10623e-16},{26,-3.36456e-22},{36,0},{30,6.10623e-16}},
          color={0,0,240},
          thickness=0.5,
          smooth=Smooth.None));

      // External connections
      connect(an, anFP.xNegative) annotation (Line(
          points={{-60,5.55112e-16},{-60,6.10623e-16},{-50,6.10623e-16}},
          color={127,127,127},
          smooth=Smooth.None,
          thickness=0.5));
      connect(anFP.yNegative, anNegative) annotation (Line(
          points={{-40,-10},{-40,-20}},
          color={240,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      connect(anFP.yPositive, anPositive) annotation (Line(
          points={{-40,10},{-40,20}},
          color={240,0,0},
          thickness=0.5,
          smooth=Smooth.None));

      connect(caFP.xPositive, ca) annotation (Line(
          points={{50,6.10623e-16},{60,5.55112e-16}},
          color={127,127,127},
          smooth=Smooth.None,
          thickness=0.5));
      connect(caFP.yNegative, caNegative) annotation (Line(
          points={{40,-10},{40,-20}},
          color={0,0,240},
          thickness=0.5,
          smooth=Smooth.None));
      connect(caFP.yPositive, caPositive) annotation (Line(
          points={{40,10},{40,20}},
          color={0,0,240},
          thickness=0.5,
          smooth=Smooth.None));
      annotation (
        defaultComponentPrefixes="replaceable",
        defaultComponentName="cell",
        Documentation(info="<html>
    <p>This is a model of a single-cell proton exchange membrane fuel cell (PEMFC).  The catalyst layers and gas diffusion
    layers are integrated on each side to reduce the complexity of the model.  An overview
    of a PEMFC is given in the <a href=\"modelica://FCSys\">top-level documentation of FCSys</a>.</p>
    </html>"),
        Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-60,-20},{
                60,20}}), graphics),
        Icon(coordinateSystem(
            preserveAspectRatio=true,
            extent={{-100,-100},{100,100}},
            initialScale=0.1), graphics={
            Line(
              points={{-40,100},{-40,60}},
              color={240,0,0},
              visible=inclY,
              smooth=Smooth.None,
              thickness=0.5),
            Line(
              points={{-8,-1},{44,-1}},
              color={0,0,240},
              visible=inclX,
              thickness=0.5,
              origin={39,56},
              rotation=90),
            Line(
              points={{100,0},{56,0}},
              color={127,127,127},
              visible=inclX,
              thickness=0.5),
            Line(
              points={{-8,-1},{28,-1}},
              color={0,0,240},
              visible=inclX,
              thickness=0.5,
              origin={39,-92},
              rotation=90),
            Line(
              points={{-40,-58},{-40,-100}},
              color={240,0,0},
              visible=inclY,
              smooth=Smooth.None,
              thickness=0.5),
            Line(
              points={{-66,0},{-100,0}},
              color={127,127,127},
              visible=inclX,
              thickness=0.5)}));
    end SimpleCell;

    model VerySimpleCell
      "Cell model with one subregion for the GDLs, CLs, and PEM"
      extends FCSys.BaseClasses.Icons.Cell;

      // Geometric parameters
      parameter Q.Length L_y[:]={U.m}
        "<html>Lengths along the channel (L<sub>y</sub>)</html>"
        annotation (Dialog(group="Geometry"));
      parameter Q.Length L_z[:]={5*U.mm}
        "<html>Lengths across the channel (L<sub>z</sub>)</html>"
        annotation (Dialog(group="Geometry"));
      final parameter Integer n_y=size(L_y, 1)
        "Number of subregions along the channel";
      final parameter Integer n_z=size(L_z, 1)
        "Number of subregions across the channel";

      Connectors.FaceBus an[n_y, n_z] "Interface with the anode end plate"
        annotation (Placement(transformation(extent={{-50,-10},{-30,10}},
              rotation=0), iconTransformation(extent={{-110,-10},{-90,10}})));
      Connectors.FaceBus ca[n_y, n_z] "Interface with the cathode end plate"
        annotation (Placement(transformation(extent={{30,-10},{50,10}},
              rotation=0), iconTransformation(extent={{90,-10},{110,10}})));
      Connectors.FaceBus anNegative[anFP.n_x, n_z] "Negative anode fluid port"
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-20,-20}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={-40,-100})));
      Connectors.FaceBus caNegative[caFP.n_x, n_z]
        "Negative cathode fluid port" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={20,-20}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={40,-100})));
      Connectors.FaceBus anPositive[anFP.n_x, n_z] "Positive anode fluid port"
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-20,20}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={-40,100})));
      Connectors.FaceBus caPositive[caFP.n_x, n_z]
        "Positive cathode fluid port" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={20,20}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={40,100})));

      replaceable Regions.AnFPs.AnFP anFP(final L_y=L_y, final L_z=L_z)
        "Anode flow plate" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Layers"),
        Placement(transformation(extent={{-30,-10},{-10,10}})));
      Regions.Integrated.GDLMEA GDLMEA(final L_y=L_y, final L_z=L_z)
        "Gas diffusion layers and membrane electrolyte assembly" annotation (
          Dialog(group="Layers"), Placement(transformation(extent={{-10,-10},{
                10,10}})));

      replaceable Regions.CaFPs.CaFP caFP(final L_y=L_y, final L_z=L_z)
        "Cathode flow plate" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Layers"),
        Placement(transformation(extent={{10,-10},{30,10}})));

    protected
      outer Conditions.Environment environment "Environmental conditions";

    equation
      // Internal connections (between layers)
      connect(anFP.xPositive, GDLMEA.xNegative) annotation (Line(
          points={{-10,6.10623e-16},{-10,6.10623e-16}},
          color={127,127,127},
          thickness=0.5,
          smooth=Smooth.None));

      // External connections
      connect(an, anFP.xNegative) annotation (Line(
          points={{-40,5.55112e-16},{-40,6.10623e-16},{-30,6.10623e-16}},
          color={127,127,127},
          smooth=Smooth.None,
          thickness=0.5));
      connect(anFP.yNegative, anNegative) annotation (Line(
          points={{-20,-10},{-20,-20}},
          color={240,0,0},
          thickness=0.5,
          smooth=Smooth.None));
      connect(anFP.yPositive, anPositive) annotation (Line(
          points={{-20,10},{-20,20}},
          color={240,0,0},
          thickness=0.5,
          smooth=Smooth.None));

      connect(caFP.xPositive, ca) annotation (Line(
          points={{30,6.10623e-16},{40,5.55112e-16}},
          color={127,127,127},
          smooth=Smooth.None,
          thickness=0.5));
      connect(caFP.yNegative, caNegative) annotation (Line(
          points={{20,-10},{20,-20}},
          color={0,0,240},
          thickness=0.5,
          smooth=Smooth.None));
      connect(caFP.yPositive, caPositive) annotation (Line(
          points={{20,10},{20,20}},
          color={0,0,240},
          thickness=0.5,
          smooth=Smooth.None));
      connect(GDLMEA.xPositive, caFP.xNegative) annotation (Line(
          points={{10,6.10623e-16},{10,6.10623e-16},{10,6.10623e-16},{10,
              6.10623e-16}},
          color={127,127,127},
          thickness=0.5,
          smooth=Smooth.None));

      annotation (
        defaultComponentPrefixes="replaceable",
        defaultComponentName="cell",
        Documentation(info="<html>
    <p>This is a model of a single-cell proton exchange membrane fuel cell (PEMFC).  The gas diffusion
    layers and membrane electrolyte assembly are integrated to reduce complexity of the model.  An overview
    of a PEMFC is given in the <a href=\"modelica://FCSys\">top-level documentation of FCSys</a>.</p>
    </html>"),
        Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-40,-20},{
                40,20}}), graphics),
        Icon(coordinateSystem(
            preserveAspectRatio=true,
            extent={{-100,-100},{100,100}},
            initialScale=0.1), graphics={
            Line(
              points={{-40,100},{-40,60}},
              color={240,0,0},
              visible=inclY,
              smooth=Smooth.None,
              thickness=0.5),
            Line(
              points={{-8,-1},{44,-1}},
              color={0,0,240},
              visible=inclX,
              thickness=0.5,
              origin={39,56},
              rotation=90),
            Line(
              points={{100,0},{56,0}},
              color={127,127,127},
              visible=inclX,
              thickness=0.5),
            Line(
              points={{-8,-1},{28,-1}},
              color={0,0,240},
              visible=inclX,
              thickness=0.5,
              origin={39,-92},
              rotation=90),
            Line(
              points={{-40,-58},{-40,-100}},
              color={240,0,0},
              visible=inclY,
              smooth=Smooth.None,
              thickness=0.5),
            Line(
              points={{-66,0},{-100,0}},
              color={127,127,127},
              visible=inclX,
              thickness=0.5)}));
    end VerySimpleCell;
  end Cells;
  annotation (Documentation(info="
<html>
  <p><b>Licensed by the Georgia Tech Research Corporation under the Modelica License 2</b><br>
Copyright 2007&ndash;2012, Georgia Tech Research Corporation.</p>

<p><i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>;
it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the
disclaimer of warranty) see <a href=\"modelica://FCSys.UsersGuide.ModelicaLicense2\">
FCSys.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\">
http://www.modelica.org/licenses/ModelicaLicense2</a>.</i></p>
</html>"));

end Assemblies;
