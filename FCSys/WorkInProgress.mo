within FCSys;
package WorkInProgress "Incomplete classes under development"
  extends Modelica.Icons.Package;
  extends FCSys.BaseClasses.Icons.PackageUnderConstruction;

  model ConditionsAdaptersPhasesIonomer
    "<html>Adapter for ionomer between <a href=\"modelica://FCSys\">FCSys</a> and <a href=\"modelica://Modelica\">Modelica</a></html>"
    extends Conditions.Adapters.Phases.BaseClasses.PartialPhase;
    extends Modelica.Icons.UnderConstruction;
    Conditions.Adapters.Species.Solid 'C19HF37O5S-';
    FCSys.WorkInProgress.ConditionsAdaptersSpeciesFluid 'H+'(redeclare package
        Data = FCSys.Characteristics.'H+'.Ionomer, redeclare package Medium =
          Modelica.Media.IdealGases.SingleGases.H2)
      annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
    // **Use model for H instead.
    Conditions.Adapters.Species.FluidNeutral H2O(redeclare package Data =
          Characteristics.H2O.Ionomer, redeclare package Medium =
          Modelica.Media.IdealGases.SingleGases.H2O)
      annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
    Conditions.Adapters.Junctions.Junction2 junction2
      annotation (Placement(transformation(extent={{60,-50},{40,-30}})));
    Modelica.Fluid.Interfaces.FluidPort_b fluidPort(redeclare final package
        Medium = Medium) "Modelica fluid port" annotation (Placement(
          transformation(extent={{70,-50},{90,-30}}), iconTransformation(extent
            ={{70,-50},{90,-30}})));
    Modelica.Electrical.Analog.Interfaces.NegativePin pin
      "Modelica electrical pin" annotation (Placement(transformation(extent={{
              70,30},{90,50}}), iconTransformation(extent={{70,30},{90,50}})));

  equation
    connect('C19HF37O5S-'.face.thermal, face.'C19HF37O5S-'.thermal) annotation
      (Line(
        points={{-8,20},{-40,20},{-40,5.55112e-16},{-80,5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));
    connect('H+'.face.normal, face.'H+'.normal) annotation (Line(
        points={{-8,-20},{-40,-20},{-40,5.55112e-16},{-80,5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));
    connect('H+'.face.thermal, face.'H+'.thermal) annotation (Line(
        points={{-8,-20},{-40,-20},{-40,5.55112e-16},{-80,5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));
    connect('H+'.pin, pin) annotation (Line(
        points={{8,-16},{60,-16},{60,40},{80,40}},
        color={0,0,255},
        smooth=Smooth.None));
    connect('H+'.heatPort, heatPort) annotation (Line(
        points={{8,-20},{40,-20},{40,5.55112e-16},{80,5.55112e-16}},
        color={191,0,0},
        smooth=Smooth.None));
    connect('C19HF37O5S-'.heatPort, heatPort) annotation (Line(
        points={{8,20},{40,20},{40,5.55112e-16},{80,5.55112e-16}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(junction2.mixturePort, fluidPort) annotation (Line(
        points={{58,-40},{80,-40}},
        color={0,127,255},
        smooth=Smooth.None));
    annotation (Placement(transformation(extent={{-10,10},{10,30}})), Icon(
          graphics={Line(
              points={{0,60},{0,-60}},
              color={0,0,0},
              smooth=Smooth.None,
              pattern=LinePattern.Dash,
              thickness=0.5),Line(
              points={{0,0},{-80,0}},
              color={127,127,127},
              smooth=Smooth.None,
              thickness=0.5),Line(
              points={{0,40},{80,40}},
              color={0,0,255},
              smooth=Smooth.None),Line(
              points={{0,0},{80,0}},
              color={191,0,0},
              smooth=Smooth.None),Line(
              points={{0,-40},{80,-40}},
              color={0,127,255},
              smooth=Smooth.None)}));
  end ConditionsAdaptersPhasesIonomer;

  model CellModelica
    "<html>Cell interfaced to components from the <a href=\"modelica://Modelica\">Modelica</a> package</html>"
    extends Modelica.Icons.Example;
    extends Modelica.Icons.UnderConstruction;
    Assemblies.Cells.Examples.Cell cell(anFP(redeclare
          FCSys.Subregions.Subregion subregions(
          each final inclX=true,
          each inclY=true,
          each graphite('incle-'=true, 'e-'(perfectMaterialDiff={{{{true,false}}}})),

          each gas(inclH2=true, inclH2O=true))))
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

    inner FCSys.Conditions.Environment environment(analysis=false)
      annotation (Placement(transformation(extent={{40,60},{60,80}})));
    Conditions.Adapters.Phases.Graphite caModelicaAdapt(A=cell.L_y[1]*cell.L_z[
          1]) annotation (Placement(transformation(extent={{20,-10},{40,10}})));
    Conditions.Adapters.Phases.Graphite anModelicaAdapt(A=cell.L_y[1]*cell.L_z[
          1])
      annotation (Placement(transformation(extent={{-20,-10},{-40,10}})));
    FCSys.WorkInProgress.TanConduct tanConduct
      annotation (Placement(transformation(extent={{10,40},{-10,60}})));
    Modelica.Blocks.Sources.Ramp loadSweep(duration=1000)
      "This is the arctangent of conductance."
      annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  equation
    connect(anModelicaAdapt.normal, cell.anFPX[1, 1]) annotation (Line(
        points={{-20,6.10623e-16},{-16,6.10623e-16},{-16,5.55112e-16},{-10,
            5.55112e-16}},
        color={0,0,0},
        thickness=0.5,
        smooth=Smooth.None));

    connect(caModelicaAdapt.normal, cell.caFPX[1, 1]) annotation (Line(
        points={{20,6.10623e-16},{16,6.10623e-16},{16,5.55112e-16},{10,
            5.55112e-16}},
        color={0,0,0},
        thickness=0.5,
        smooth=Smooth.None));

    connect(loadSweep.y, tanConduct.atanGstar) annotation (Line(
        points={{-19,70},{-6.66134e-16,70},{-6.66134e-16,61}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(tanConduct.p, caModelicaAdapt.pin) annotation (Line(
        points={{10,50},{60,50},{60,4},{40,4}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(tanConduct.n, anModelicaAdapt.pin) annotation (Line(
        points={{-10,50},{-60,50},{-60,4},{-40,4}},
        color={0,0,255},
        smooth=Smooth.None));
    annotation (experiment(StopTime=1000));
  end CellModelica;

  function plot "Create plots using FCRes"
    extends Modelica.Icons.Function;
    extends Modelica.Icons.UnderConstruction;

  algorithm
    Modelica.Utilities.System.command("loadres");

  end plot;

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
    Modelica.Electrical.Analog.Basic.Capacitor capacitor(C=1e-3) annotation (
        Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={40,-10})));
    Modelica.Electrical.Analog.Sources.ConstantVoltage constantVoltage(V=1)
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=270,
          origin={-80,-10})));
    Modelica.Electrical.Analog.Sensors.VoltageSensor voltageSensor annotation (
        Placement(transformation(
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
    Connectors.RealOutput w_V "Cell potential in volts" annotation (Placement(
          transformation(extent={{90,-20},{110,0}}), iconTransformation(extent=
              {{100,-10},{120,10}})));
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
  annotation (Commands(file="../../units.mos"
        "Establish the constants and units in the workspace (first translate a model besides Units.Evaluate).",
        file="test/check.mos"
        "Check all of FCSys using Dymola's check function."));
end WorkInProgress;
