within FCSys;
package Conditions "Models to specify and measure operating conditions"
  extends Modelica.Icons.Package;
  // **Add notes in all models where appropriate to see the documentation in the Conditions package.
  package Examples "Examples"
    extends Modelica.Icons.ExamplesPackage;

    model FaceCondition
      "<html>Test the Conditions for the face of a subregion</html>"
      extends Modelica.Icons.Example;
      extends Modelica.Icons.UnderConstruction;
      FaceBus.Subregion subregionFaceCondition(gas(inclH2O=true, H2O(redeclare
              Face.Normal.CurrentAreic normal(source(k=0)))))
        annotation (Placement(transformation(extent={{-10,14},{10,34}})));
      Subregions.Subregion subregion(
        L={1,1,1}*U.cm,
        inclReact=false,
        inclFacesX=false,
        inclFacesY=true,
        inclFacesZ=false,
        inclTransX=false,
        inclTransY=true,
        graphite('inclC+'=true, 'C+'(V_IC=0.5*U.cc)),
        gas(inclH2O=true))
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

      inner Conditions.Environment environment
        annotation (Placement(transformation(extent={{30,30},{50,50}})));

    equation
      connect(subregion.yPositive, subregionFaceCondition.face) annotation (
          Line(
          points={{6.10623e-16,10},{-3.36456e-22,16},{6.10623e-16,16},{
              6.10623e-16,20}},
          color={127,127,127},
          thickness=0.5,
          smooth=Smooth.None));
      annotation (experiment(NumberOfIntervals=5000), Commands(file=
              "resources/scripts/Dymola/Conditions.Examples.FaceCondition.mos"));
    end FaceCondition;

    model FaceConditionPhases
      "<html>Test the Conditions for the face of a subregion with phases</html>"
      import FCSys.BaseClasses.Utilities.cartWrap;
      extends Modelica.Icons.Example;
      extends Modelica.Icons.UnderConstruction;
      // Geometric parameters
      inner parameter Q.Length L[Axis](each min=Modelica.Constants.small, start
          =ones(3)*U.cm) "<html>Length (<b>L</b>)</html>"
        annotation (Dialog(group="Geometry"));
      final inner parameter Q.Area A[Axis]={L[cartWrap(axis + 1)]*L[cartWrap(
          axis + 2)] for axis in Axis} "Cross-sectional area";

      FaceBus.Phases.Gas phaseFaceCondition(inclH2O=true, H2O(redeclare
            Face.Normal.CurrentAreic normal(source(k=0))))
        annotation (Placement(transformation(extent={{-10,14},{10,34}})));

      Subregions.Volume volume
        annotation (Placement(transformation(extent={{-16,-16},{16,16}})));
      Subregions.Phases.Gas gas(
        inclReact=false,
        inclTrans={false,true,false},
        inclH2=false,
        inclH2O=true)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

      inner Conditions.Environment environment
        annotation (Placement(transformation(extent={{30,30},{50,50}})));

    equation
      connect(gas.yPositive, phaseFaceCondition.face) annotation (Line(
          points={{6.10623e-16,10},{-3.36456e-22,16},{6.10623e-16,16},{
              6.10623e-16,20}},
          color={127,127,127},
          thickness=0.5,
          smooth=Smooth.None));

      connect(gas.inert, volume.inert) annotation (Line(
          points={{8,-8},{11,-11}},
          color={11,43,197},
          smooth=Smooth.None));
      annotation (experiment);
    end FaceConditionPhases;

    model Router "<html>Test the <code>Router<code> model</html>"
      extends Modelica.Icons.Example;

      // TODO:  Make this into a meaningful example.
      Conditions.Router router
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

    end Router;

    model AnodeAdapter "<html>Test the <code>'Adapte-'</code> model</html>"

      extends Modelica.Icons.Example;
      extends Modelica.Icons.UnderConstruction;
      // **fails check
      inner Modelica.Fluid.System system(T_ambient=293.15 + 5)
        annotation (Placement(transformation(extent={{40,70},{60,90}})));
      inner Conditions.Environment environment(T=350*U.K)
        annotation (Placement(transformation(extent={{70,72},{90,92}})));
      Subregions.SubregionNoIonomer subregion(
        L={1,1,1}*U.cm,
        inclReact=false,
        inclFacesY=false,
        inclFacesZ=false,
        gas(inclH2=true, inclH2O=true),
        graphite('inclC+'=true, 'incle-'=true),
        liquid(inclH2O=true))
        annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
      Adapters.Anode anodeAdapter(redeclare package LiquidMedium =
            Modelica.Media.CompressibleLiquids.LinearColdWater)
        annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
      Modelica.Electrical.Analog.Basic.Ground ground
        annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

      Modelica.Fluid.Vessels.ClosedVolume gasVolume(
        use_portsData=false,
        nPorts=1,
        V=1e-6,
        use_HeatTransfer=true,
        redeclare
          Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.IdealHeatTransfer
          HeatTransfer,
        redeclare package Medium = Adapters.Media.AnodeGas,
        medium(p(fixed=true),X(each fixed=true)))
        annotation (Placement(transformation(extent={{30,20},{50,40}})));
      Modelica.Fluid.Vessels.ClosedVolume liquidVolume(
        nPorts=1,
        use_HeatTransfer=true,
        redeclare
          Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.IdealHeatTransfer
          HeatTransfer,
        V=0.5e-6,
        use_portsData=false,
        redeclare package Medium =
            Modelica.Media.CompressibleLiquids.LinearColdWater,
        medium(p(fixed=true),T(fixed=true)))
        annotation (Placement(transformation(extent={{70,20},{90,40}})));

    equation
      connect(ground.p, anodeAdapter.pin) annotation (Line(
          points={{10,-20},{10,2},{-2,2}},
          color={0,0,255},
          smooth=Smooth.None));

      connect(subregion.xPositive, anodeAdapter.face) annotation (Line(
          points={{-30,6.10623e-16},{-24,-3.36456e-22},{-24,6.10623e-16},{-18,
              6.10623e-16}},
          color={127,127,127},
          thickness=0.5,
          smooth=Smooth.None));

      connect(gasVolume.heatPort, anodeAdapter.heatPort) annotation (Line(
          points={{30,30},{20,30},{20,-2},{-2,-2}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(gasVolume.ports[1], anodeAdapter.gasPort) annotation (Line(
          points={{40,20},{40,6},{-2,6}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(liquidVolume.heatPort, anodeAdapter.heatPort) annotation (Line(
          points={{70,30},{60,30},{60,-2},{-2,-2}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(anodeAdapter.liquidPort, liquidVolume.ports[1]) annotation (Line(
          points={{-2,-6},{80,-6},{80,20}},
          color={0,127,255},
          smooth=Smooth.None));
      annotation (experiment(StopTime=2e-10), Commands(file=
              "resources/scripts/Dymola/Conditions.Examples.Adapteminus.mos"));
    end AnodeAdapter;

  end Examples;

  package Adapters
    "<html>Adapters to <a href=\"modelica://Modelica\">Package Modelica</a></html>"
    extends Modelica.Icons.Package;

    model Anode
      "<html>Adapter between <a href=\"modelica://Modelica\">Modelica</a> and the face connector of a <a href=\"modelica://FCSys.Assemblies.Cells.Cell\">Cell</a>, <a href=\"modelica://FCSys.Regions.Region\">Region</a>, or <a href=\"modelica://FCSys.Subregions.Subregion\">Subregion</a></html>"
      extends FCSys.BaseClasses.Icons.Names.Top4;

      replaceable package GasMedium = Media.AnodeGas constrainedby
        Modelica.Media.Interfaces.PartialMedium "Medium model for the gas"
        annotation (choicesAllMatching=true, Dialog(group="Material properties"));
      replaceable package LiquidMedium =
          Modelica.Media.Water.ConstantPropertyLiquidWater constrainedby
        Modelica.Media.Interfaces.PartialMedium "Medium model for the liquid"
        annotation (choicesAllMatching=true, Dialog(group="Material properties"));

      Connectors.FaceBus face
        "Multi-species connector for translational momentum and heat"
        annotation (Placement(transformation(extent={{-90,-10},{-70,10}}),
            iconTransformation(extent={{-90,-10},{-70,10}})));
      Modelica.Fluid.Interfaces.FluidPort_b gasPort(redeclare final package
          Medium = GasMedium) "Modelica fluid port for the gas" annotation (
          Placement(transformation(extent={{70,50},{90,70}}),
            iconTransformation(extent={{70,50},{90,70}})));
      Modelica.Electrical.Analog.Interfaces.NegativePin pin
        "Modelica electrical pin" annotation (Placement(transformation(extent={
                {70,10},{90,30}}),iconTransformation(extent={{70,10},{90,30}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatPort
        "Modelica heat port" annotation (Placement(transformation(extent={{70,-30},
                {90,-10}}), iconTransformation(extent={{70,-30},{90,-10}})));
      Modelica.Fluid.Interfaces.FluidPort_b liquidPort(redeclare final package
          Medium = LiquidMedium) "Modelica fluid port for the liquid"
        annotation (Placement(transformation(extent={{70,-70},{90,-50}}),
            iconTransformation(extent={{70,-70},{90,-50}})));
      Phases.AnodeGas gas(redeclare final package Medium = GasMedium)
        "Gas subadapter"
        annotation (Placement(transformation(extent={{-10,30},{10,50}})));
      Phases.Graphite graphite "Graphite subadapter"
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

      Phases.Liquid liquid(redeclare final package Medium = LiquidMedium)
        "Liquid subadapter"
        annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

    equation
      connect(gas.face, face.gas) annotation (Line(
          points={{-8,40},{-40,40},{-40,5.55112e-16},{-80,5.55112e-16}},
          color={127,127,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect(gasPort, gas.fluidPort) annotation (Line(
          points={{80,60},{50,60},{50,36},{8,36}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(gas.heatPort, heatPort) annotation (Line(
          points={{8,40},{30,40},{30,-20},{80,-20}},
          color={191,0,0},
          smooth=Smooth.None));

      connect(graphite.face, face.graphite) annotation (Line(
          points={{-8,6.10623e-16},{-40,6.10623e-16},{-40,5.55112e-16},{-80,
              5.55112e-16}},
          color={127,127,127},
          smooth=Smooth.None,
          thickness=0.5));

      connect(graphite.pin, pin) annotation (Line(
          points={{8,4},{50,4},{50,20},{80,20}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(graphite.heatPort, heatPort) annotation (Line(
          points={{8,6.10623e-16},{30,6.10623e-16},{30,-20},{80,-20}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(liquid.face, face.liquid) annotation (Line(
          points={{-8,-40},{-40,-40},{-40,5.55112e-16},{-80,5.55112e-16}},
          color={127,127,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect(liquidPort, liquid.fluidPort) annotation (Line(
          points={{80,-60},{50,-60},{50,-44},{8,-44}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(liquid.heatPort, heatPort) annotation (Line(
          points={{8,-40},{30,-40},{30,-20},{80,-20}},
          color={191,0,0},
          smooth=Smooth.None));
      annotation (Icon(graphics={Line(
                  points={{0,60},{0,-60}},
                  color={0,0,0},
                  smooth=Smooth.None,
                  pattern=LinePattern.Dash,
                  thickness=0.5),Line(
                  points={{0,0},{-80,0}},
                  color={127,127,127},
                  smooth=Smooth.None,
                  thickness=0.5),Line(
                  points={{0,20},{80,20}},
                  color={0,0,255},
                  smooth=Smooth.None),Line(
                  points={{0,-20},{80,-20}},
                  color={191,0,0},
                  smooth=Smooth.None),Line(
                  points={{0,60},{80,60}},
                  color={0,127,255},
                  smooth=Smooth.None),Line(
                  points={{0,-60},{80,-60}},
                  color={0,127,255},
                  smooth=Smooth.None)}));
    end Anode;

    model Cathode
      "<html>Adapter between <a href=\"modelica://Modelica\">Modelica</a> and the face connector of a <a href=\"modelica://FCSys.Assemblies.Cells.Cell\">Cell</a>, <a href=\"modelica://FCSys.Regions.Region\">Region</a>, or <a href=\"modelica://FCSys.Subregions.Subregion\">Subregion</a></html>"
      extends FCSys.BaseClasses.Icons.Names.Top4;

      replaceable package GasMedium = Adapters.Media.CathodeGas constrainedby
        Modelica.Media.Interfaces.PartialMedium "Medium model for the gas"
        annotation (choicesAllMatching=true, Dialog(group="Material properties"));
      replaceable package LiquidMedium =
          Modelica.Media.Water.ConstantPropertyLiquidWater constrainedby
        Modelica.Media.Interfaces.PartialMedium "Medium model for the liquid"
        annotation (choicesAllMatching=true, Dialog(group="Material properties"));

      Connectors.FaceBus face
        "Multi-species connector for translational momentum and heat"
        annotation (Placement(transformation(extent={{-90,-10},{-70,10}}),
            iconTransformation(extent={{-90,-10},{-70,10}})));
      Modelica.Fluid.Interfaces.FluidPort_b gasPort(redeclare final package
          Medium = GasMedium) "Modelica fluid port for the gas" annotation (
          Placement(transformation(extent={{70,50},{90,70}}),
            iconTransformation(extent={{70,50},{90,70}})));
      Modelica.Electrical.Analog.Interfaces.NegativePin pin
        "Modelica electrical pin" annotation (Placement(transformation(extent={
                {70,10},{90,30}}),iconTransformation(extent={{70,10},{90,30}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatPort
        "Modelica heat port" annotation (Placement(transformation(extent={{70,-30},
                {90,-10}}), iconTransformation(extent={{70,-30},{90,-10}})));
      Modelica.Fluid.Interfaces.FluidPort_b liquidPort(redeclare final package
          Medium = LiquidMedium) "Modelica fluid port for the liquid"
        annotation (Placement(transformation(extent={{70,-70},{90,-50}}),
            iconTransformation(extent={{70,-70},{90,-50}})));

      Phases.CathodeGas gas(redeclare final package Medium = GasMedium)
        "Gas subadapter"
        annotation (Placement(transformation(extent={{-10,30},{10,50}})));
      Phases.Graphite graphite "Graphite subadapter"
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
      Phases.Liquid liquid(redeclare final package Medium = LiquidMedium)
        "Liquid subadapter"
        annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

    equation
      connect(gas.face, face.gas) annotation (Line(
          points={{-8,40},{-40,40},{-40,5.55112e-16},{-80,5.55112e-16}},
          color={127,127,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect(gasPort, gas.fluidPort) annotation (Line(
          points={{80,60},{50,60},{50,36},{8,36}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(gas.heatPort, heatPort) annotation (Line(
          points={{8,40},{30,40},{30,-20},{80,-20}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(graphite.face, face.graphite) annotation (Line(
          points={{-8,6.10623e-16},{-40,6.10623e-16},{-40,5.55112e-16},{-80,
              5.55112e-16}},
          color={127,127,127},
          smooth=Smooth.None,
          thickness=0.5));

      connect(graphite.pin, pin) annotation (Line(
          points={{8,4},{50,4},{50,20},{80,20}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(graphite.heatPort, heatPort) annotation (Line(
          points={{8,6.10623e-16},{30,6.10623e-16},{30,-20},{80,-20}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(liquid.face, face.liquid) annotation (Line(
          points={{-8,-40},{-40,-40},{-40,5.55112e-16},{-80,5.55112e-16}},
          color={127,127,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect(liquidPort, liquid.fluidPort) annotation (Line(
          points={{80,-60},{50,-60},{50,-44},{8,-44}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(liquid.heatPort, heatPort) annotation (Line(
          points={{8,-40},{30,-40},{30,-20},{80,-20}},
          color={191,0,0},
          smooth=Smooth.None));
      annotation (Icon(graphics={Line(
                  points={{0,60},{0,-60}},
                  color={0,0,0},
                  smooth=Smooth.None,
                  pattern=LinePattern.Dash,
                  thickness=0.5),Line(
                  points={{0,0},{-80,0}},
                  color={127,127,127},
                  smooth=Smooth.None,
                  thickness=0.5),Line(
                  points={{0,20},{80,20}},
                  color={0,0,255},
                  smooth=Smooth.None),Line(
                  points={{0,-20},{80,-20}},
                  color={191,0,0},
                  smooth=Smooth.None),Line(
                  points={{0,60},{80,60}},
                  color={0,127,255},
                  smooth=Smooth.None),Line(
                  points={{0,-60},{80,-60}},
                  color={0,127,255},
                  smooth=Smooth.None)}));
    end Cathode;

    package Phases "Adapters for material phases"
      extends Modelica.Icons.Package;

      model AnodeGas
        "<html>Adapter for PEMFC anode gas between <a href=\"modelica://FCSys\">FCSys</a> and <a href=\"modelica://Modelica\">Modelica</a></html>"
        extends BaseClasses.PartialPhase;

        replaceable package Medium = Media.AnodeGas constrainedby
          Modelica.Media.Interfaces.PartialMedium "Medium model (Modelica)"
          annotation (choicesAllMatching=true, Dialog(group=
                "Material properties"));

        Species.FluidNonionic H2(redeclare package Medium =
              Modelica.Media.IdealGases.SingleGases.H2 (referenceChoice=
                  Modelica.Media.Interfaces.PartialMedium.Choices.ReferenceEnthalpy.ZeroAt25C,
                excludeEnthalpyOfFormation=false), redeclare package Data =
              Characteristics.H2.Gas)
          annotation (Placement(transformation(extent={{-10,10},{10,30}})));
        Species.FluidNonionic H2O(redeclare package Data =
              Characteristics.H2O.Gas (referenceChoice=Modelica.Media.Interfaces.PartialMedium.Choices.ReferenceEnthalpy.ZeroAt25C,
                excludeEnthalpyOfFormation=false), redeclare final package
            Medium = Modelica.Media.IdealGases.SingleGases.H2O)
          annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
        Junctions.Junction2 junction
          annotation (Placement(transformation(extent={{60,-50},{40,-30}})));

        Modelica.Fluid.Interfaces.FluidPort_b fluidPort(redeclare final package
            Medium = Medium) "Modelica fluid port" annotation (Placement(
              transformation(extent={{70,-50},{90,-30}}), iconTransformation(
                extent={{70,-50},{90,-30}})));

      equation
        // H2
        connect(H2.face, face.H2) annotation (Line(
            points={{-8,20},{-40,20},{-40,5.55112e-16},{-80,5.55112e-16}},
            color={127,127,127},
            smooth=Smooth.None));
        connect(H2.heatPort, heatPort) annotation (Line(
            points={{8,20},{60,20},{60,5.55112e-16},{80,5.55112e-16}},
            color={191,0,0},
            smooth=Smooth.None));
        connect(H2.fluidPort, junction.purePort1) annotation (Line(
            points={{8,16},{34,16},{34,-36.2},{42,-36.2}},
            color={0,127,255},
            smooth=Smooth.None));

        // H2O
        connect(H2O.face, face.H2O) annotation (Line(
            points={{-8,-20},{-40,-20},{-40,5.55112e-16},{-80,5.55112e-16}},
            color={127,127,127},
            smooth=Smooth.None));
        connect(H2O.heatPort, heatPort) annotation (Line(
            points={{8,-20},{60,-20},{60,5.55112e-16},{80,5.55112e-16}},
            color={191,0,0},
            smooth=Smooth.None));
        connect(H2O.fluidPort, junction.purePort2) annotation (Line(
            points={{8,-24},{26,-24},{26,-44},{42,-44}},
            color={0,127,255},
            smooth=Smooth.None));

        // Mixture
        connect(junction.mixturePort, fluidPort) annotation (Line(
            points={{58,-40},{80,-40}},
            color={0,127,255},
            smooth=Smooth.None));
        annotation (Icon(graphics={Line(
                      points={{0,20},{0,-60}},
                      color={0,0,0},
                      smooth=Smooth.None,
                      pattern=LinePattern.Dash,
                      thickness=0.5),Line(
                      points={{0,0},{-80,0}},
                      color={127,127,127},
                      smooth=Smooth.None,
                      thickness=0.5),Line(
                      points={{0,0},{80,0}},
                      color={191,0,0},
                      smooth=Smooth.None),Line(
                      points={{0,-40},{80,-40}},
                      color={0,127,255},
                      smooth=Smooth.None)}));
      end AnodeGas;

      model CathodeGas
        "<html>Adapter for PEMFC cathode gas between <a href=\"modelica://FCSys\">FCSys</a> and <a href=\"modelica://Modelica\">Modelica</a></html>"
        extends BaseClasses.PartialPhase;

        replaceable package Medium = Media.CathodeGas constrainedby
          Modelica.Media.Interfaces.PartialMedium "Medium model (Modelica)"
          annotation (choicesAllMatching=true, Dialog(group=
                "Material properties"));

        Junctions.Junction3 junction(
          redeclare package Medium1 = Modelica.Media.IdealGases.SingleGases.H2O
              (referenceChoice=Modelica.Media.Interfaces.PartialMedium.Choices.ReferenceEnthalpy.ZeroAt25C,
                excludeEnthalpyOfFormation=false),
          redeclare package Medium2 = Modelica.Media.IdealGases.SingleGases.N2
              (referenceChoice=Modelica.Media.Interfaces.PartialMedium.Choices.ReferenceEnthalpy.ZeroAt25C,
                excludeEnthalpyOfFormation=false),
          redeclare package Medium3 = Modelica.Media.IdealGases.SingleGases.O2
              (referenceChoice=Modelica.Media.Interfaces.PartialMedium.Choices.ReferenceEnthalpy.ZeroAt25C,
                excludeEnthalpyOfFormation=false),
          redeclare package MixtureMedium = Medium)
          annotation (Placement(transformation(extent={{60,-50},{40,-30}})));

        Species.FluidNonionic H2O(redeclare package Data =
              Characteristics.H2O.Gas, redeclare final package Medium =
              Modelica.Media.IdealGases.SingleGases.H2O (referenceChoice=
                  Modelica.Media.Interfaces.PartialMedium.Choices.ReferenceEnthalpy.ZeroAt25C,
                excludeEnthalpyOfFormation=false))
          annotation (Placement(transformation(extent={{-10,10},{10,30}})));
        Species.FluidNonionic N2(redeclare package Data =
              Characteristics.N2.Gas, redeclare final package Medium =
              Modelica.Media.IdealGases.SingleGases.N2 (referenceChoice=
                  Modelica.Media.Interfaces.PartialMedium.Choices.ReferenceEnthalpy.ZeroAt25C,
                excludeEnthalpyOfFormation=false))
          annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
        Species.FluidNonionic O2(redeclare package Data =
              Characteristics.O2.Gas, redeclare final package Medium =
              Modelica.Media.IdealGases.SingleGases.O2 (referenceChoice=
                  Modelica.Media.Interfaces.PartialMedium.Choices.ReferenceEnthalpy.ZeroAt25C,
                excludeEnthalpyOfFormation=false))
          annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));

        Modelica.Fluid.Interfaces.FluidPort_b fluidPort(redeclare final package
            Medium = Medium) "Modelica fluid port" annotation (Placement(
              transformation(extent={{70,-50},{90,-30}}), iconTransformation(
                extent={{70,-50},{90,-30}})));

      equation
        // H2O
        connect(H2O.face, face.H2O) annotation (Line(
            points={{-8,20},{-40,20},{-40,5.55112e-16},{-80,5.55112e-16}},
            color={127,127,127},
            smooth=Smooth.None));
        connect(H2O.fluidPort, junction.purePort1) annotation (Line(
            points={{8,16},{34,16},{34,-36.2},{42,-36.2}},
            color={0,127,255},
            smooth=Smooth.None));
        connect(H2O.heatPort, heatPort) annotation (Line(
            points={{8,20},{60,20},{60,5.55112e-16},{80,5.55112e-16}},
            color={191,0,0},
            smooth=Smooth.None));

        // N2
        connect(N2.face, face.N2) annotation (Line(
            points={{-8,6.10623e-16},{-40,6.10623e-16},{-40,5.55112e-16},{-80,
                5.55112e-16}},
            color={127,127,127},
            smooth=Smooth.None));

        connect(N2.fluidPort, junction.purePort2) annotation (Line(
            points={{8,-4},{30,-4},{30,-40},{42,-40}},
            color={0,127,255},
            smooth=Smooth.None));

        connect(N2.heatPort, heatPort) annotation (Line(
            points={{8,6.10623e-16},{60,6.10623e-16},{60,5.55112e-16},{80,
                5.55112e-16}},
            color={191,0,0},
            smooth=Smooth.None));

        // O2
        connect(O2.face, face.O2) annotation (Line(
            points={{-8,-20},{-40,-20},{-40,5.55112e-16},{-80,5.55112e-16}},
            color={127,127,127},
            smooth=Smooth.None));
        connect(O2.fluidPort, junction.purePort3) annotation (Line(
            points={{8,-24},{26,-24},{26,-44},{42,-44}},
            color={0,127,255},
            smooth=Smooth.None));
        connect(O2.heatPort, heatPort) annotation (Line(
            points={{8,-20},{60,-20},{60,5.55112e-16},{80,5.55112e-16}},
            color={191,0,0},
            smooth=Smooth.None));

        // Mixture
        connect(junction.mixturePort, fluidPort) annotation (Line(
            points={{58,-40},{80,-40}},
            color={0,127,255},
            smooth=Smooth.None));
        annotation (Icon(graphics={Line(
                      points={{0,20},{0,-60}},
                      color={0,0,0},
                      smooth=Smooth.None,
                      pattern=LinePattern.Dash,
                      thickness=0.5),Line(
                      points={{0,0},{-80,0}},
                      color={127,127,127},
                      smooth=Smooth.None,
                      thickness=0.5),Line(
                      points={{0,0},{80,0}},
                      color={191,0,0},
                      smooth=Smooth.None),Line(
                      points={{0,-40},{80,-40}},
                      color={0,127,255},
                      smooth=Smooth.None)}));
      end CathodeGas;

      model Graphite
        "<html>Adapter for graphite between <a href=\"modelica://FCSys\">FCSys</a> and <a href=\"modelica://Modelica\">Modelica</a></html>"
        extends BaseClasses.PartialPhase;

        Species.'e-' 'e-'(redeclare package Data =
              Characteristics.'e-'.Graphite)
          annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));

        Species.Solid 'C+'(redeclare package Data =
              Characteristics.'C+'.Graphite)
          annotation (Placement(transformation(extent={{-10,10},{10,30}})));
        Modelica.Electrical.Analog.Interfaces.NegativePin pin
          "Modelica electrical pin" annotation (Placement(transformation(extent
                ={{70,30},{90,50}}), iconTransformation(extent={{70,30},{90,50}})));

      equation
        // C
        connect('C+'.face, face.'C+') annotation (Line(
            points={{-8,20},{-40,20},{-40,5.55112e-16},{-80,5.55112e-16}},
            color={127,127,127},
            smooth=Smooth.None));
        connect('C+'.heatPort, heatPort) annotation (Line(
            points={{8,20},{40,20},{40,5.55112e-16},{80,5.55112e-16}},
            color={191,0,0},
            smooth=Smooth.None));

        // e-
        connect('e-'.face, face.'e-') annotation (Line(
            points={{-8,-20},{-40,-20},{-40,5.55112e-16},{-80,5.55112e-16}},
            color={127,127,127},
            smooth=Smooth.None));

        connect('e-'.heatPort, heatPort) annotation (Line(
            points={{8,-20},{40,-20},{40,5.55112e-16},{80,5.55112e-16}},
            color={191,0,0},
            smooth=Smooth.None));

        connect('e-'.pin, pin) annotation (Line(
            points={{8,-16},{60,-16},{60,40},{80,40}},
            color={0,0,255},
            smooth=Smooth.None));
        annotation (Icon(graphics={Line(
                      points={{0,60},{0,-20}},
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
                      smooth=Smooth.None)}));
      end Graphite;

      model Liquid
        "<html>Adapter for liquid between <a href=\"modelica://FCSys\">FCSys</a> and <a href=\"modelica://Modelica\">Modelica</a></html>"
        extends BaseClasses.PartialPhase;

        replaceable package Medium =
            Modelica.Media.Water.ConstantPropertyLiquidWater constrainedby
          Modelica.Media.Interfaces.PartialPureSubstance
          "Medium model (Modelica)" annotation (choicesAllMatching=true, Dialog(
              group="Material properties"));

        Species.FluidNonionic H2O(redeclare package Data =
              Characteristics.H2O.Liquid, redeclare final package Medium =
              Medium)
          annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

        Modelica.Fluid.Interfaces.FluidPort_b fluidPort(redeclare final package
            Medium = Medium) "Modelica fluid port" annotation (Placement(
              transformation(extent={{70,-50},{90,-30}}), iconTransformation(
                extent={{70,-50},{90,-30}})));

      equation
        // H2O
        connect(H2O.face, face.H2) annotation (Line(
            points={{-8,6.10623e-16},{-54,6.10623e-16},{-54,5.55112e-16},{-80,
                5.55112e-16}},
            color={0,0,0},
            smooth=Smooth.None));

        connect(H2O.heatPort, heatPort) annotation (Line(
            points={{8,6.10623e-16},{40,6.10623e-16},{40,5.55112e-16},{80,
                5.55112e-16}},
            color={191,0,0},
            smooth=Smooth.None));

        connect(H2O.fluidPort, fluidPort) annotation (Line(
            points={{8,-4},{40,-4},{40,-40},{80,-40}},
            color={0,127,255},
            smooth=Smooth.None));
        annotation (Icon(graphics={Line(
                      points={{0,20},{0,-60}},
                      color={0,0,0},
                      smooth=Smooth.None,
                      pattern=LinePattern.Dash,
                      thickness=0.5),Line(
                      points={{0,0},{-80,0}},
                      color={127,127,127},
                      smooth=Smooth.None,
                      thickness=0.5),Line(
                      points={{0,-40},{80,-40}},
                      color={0,127,255},
                      smooth=Smooth.None)}));
      end Liquid;

      package BaseClasses "Base classes (not generally for direct use)"
        extends Modelica.Icons.BasesPackage;

        partial model PartialPhase
          "<html>Partial adapter for a phase between <a href=\"modelica://FCSys\">FCSys</a> and <a href=\"modelica://Modelica\">Modelica</a></html>"
          extends FCSys.BaseClasses.Icons.Names.Top3;

          Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatPort
            "Modelica heat port" annotation (Placement(transformation(extent={{
                    70,-10},{90,10}}), iconTransformation(extent={{70,-10},{90,
                    10}})));
          Connectors.FaceBus face "FCSys face connector" annotation (Placement(
                transformation(extent={{-90,-10},{-70,10}}), iconTransformation(
                  extent={{-90,-10},{-70,10}})));
          annotation (Icon(graphics={Line(
                          points={{0,0},{-80,0}},
                          color={127,127,127},
                          smooth=Smooth.None,
                          thickness=0.5),Line(
                          points={{0,0},{80,0}},
                          color={191,0,0},
                          smooth=Smooth.None)}));

        end PartialPhase;

      end BaseClasses;

    end Phases;

    package Species "Adapters for single species"
      extends Modelica.Icons.Package;

      model 'e-'
        "<html>Adapter to connect e<sup>-</sup> between <a href=\"modelica://FCSys\">FCSys</a> and <a href=\"modelica://Modelica\">Modelica</a> (electrical and heat only)</html>"
        import FCSys.BaseClasses.Utilities.inSign;

        extends BaseClasses.PartialSpecies(redeclare
            Characteristics.'e-'.Graphite Data);

        parameter Q.Area A=U.cm^2 "Area of the interface";
        parameter Side side=Side.n
          "Side of the interface w.r.t. this component";

        Modelica.Electrical.Analog.Interfaces.NegativePin pin
          "Modelica electrical pin" annotation (Placement(transformation(extent
                ={{70,30},{90,50}}), iconTransformation(extent={{70,30},{90,50}})));

      equation
        // Efforts
        Data.g(face.T, inSign(side)*face.mPhidot_0/A) = Data.z*pin.v*U.V
          "Electrical potential";

        // Conservation (no storage)
        0 = A*face.J + pin.i*U.A/Data.z "Material";
        annotation (Documentation(info="<html><p>For additional information, see the
    <a href=\"modelica://FCSys.Conditions.Adapters.Species.BaseClasses.PartialSpecies\">
    PartialSpecies</a> model.</p>
    </html>"), Icon(graphics={Line(
                      points={{0,40},{80,40}},
                      color={0,0,255},
                      smooth=Smooth.None),Line(
                      points={{0,60},{0,-20}},
                      color={0,0,0},
                      smooth=Smooth.None,
                      pattern=LinePattern.Dash)}));
      end 'e-';

      model FluidNonionic
        "<html>Adapter to connect a single nonionic fluid species between <a href=\"modelica://FCSys\">FCSys</a> and <a href=\"modelica://Modelica\">Modelica</a></html>"
        import FCSys.BaseClasses.Utilities.inSign;

        extends BaseClasses.PartialSpecies;

        parameter Q.Area A=U.cm^2 "Area of the interface";
        parameter Side side=Side.n
          "Side of the interface w.r.t. this component";

        replaceable package Medium = Modelica.Media.IdealGases.SingleGases.H2O
          constrainedby Modelica.Media.Interfaces.PartialPureSubstance
          "Medium model (Modelica)" annotation (choicesAllMatching=true, Dialog(
              group="Material properties"));

        Medium.BaseProperties medium "Base properties of the fluid";

        Modelica.Fluid.Interfaces.FluidPort_b fluidPort(redeclare final package
            Medium = Medium) "Modelica fluid port" annotation (Placement(
              transformation(extent={{70,-50},{90,-30}}), iconTransformation(
                extent={{70,-50},{90,-30}})));

      equation
        // Thermodynamic state and properties
        medium.p = fluidPort.p;
        medium.T = heatPort.T;
        medium.Xi = ones(Medium.nXi)/Medium.nXi;

        // Efforts
        face.mPhidot_0 = inSign(side)*A*fluidPort.p*U.Pa;
        medium.h = fluidPort.h_outflow;

        // Conservation (no storage)
        0 = face.J*A + (fluidPort.m_flow/medium.MM)*U.mol/U.s "Material";

        // See the partial model for additional equations.
        annotation (Documentation(info="<html><p>The electrical connector (<code>pin</code>) is only included
    if the species is ionic.</p>

<p>For additional information, see the
    <a href=\"modelica://FCSys.Conditions.Adapters.Species.BaseClasses.PartialSpecies\">
    PartialSpecies</a> model.</p>
    </html>"), Icon(graphics={Line(
                      points={{0,-40},{80,-40}},
                      color={0,127,255},
                      smooth=Smooth.None),Line(
                      points={{0,20},{0,-60}},
                      color={0,0,0},
                      smooth=Smooth.None,
                      pattern=LinePattern.Dash)}));
      end FluidNonionic;

      model Solid
        "<html>Adapter to connect a single solid species between <a href=\"modelica://FCSys\">FCSys</a> and <a href=\"modelica://Modelica\">Modelica</a> (heat only)</html>"

        extends BaseClasses.PartialSpecies;

      equation
        face.J = 0 "Closed";
        annotation (Documentation(info="<html><p>For additional information, see the
    <a href=\"modelica://FCSys.Conditions.Adapters.Species.BaseClasses.PartialSpecies\">
    PartialSpecies</a> model.</p>
    </html>"), Icon(graphics={Line(
                      points={{0,20},{0,-20}},
                      color={0,0,0},
                      smooth=Smooth.None,
                      pattern=LinePattern.Dash)}));
      end Solid;

      package BaseClasses "Base classes (not generally for direct use)"
        extends Modelica.Icons.BasesPackage;

        partial model PartialSpecies
          "<html>Partial single-species adapter between <a href=\"modelica://FCSys\">FCSys</a> and <a href=\"modelica://Modelica\">Modelica</a></html>"
          extends FCSys.BaseClasses.Icons.Names.Top3;

          replaceable package Data = Characteristics.BaseClasses.Characteristic
            "Characteristic data (FCSys)" annotation (
            Dialog(group="Material properties"),
            __Dymola_choicesAllMatching=true,
            Placement(transformation(extent={{-60,40},{-40,60}}),
                iconTransformation(extent={{-10,90},{10,110}})));

          Connectors.Face face
            "Connector for translational momentum and heat of a single species"
            annotation (Placement(transformation(extent={{-90,-10},{-70,10}}),
                iconTransformation(extent={{-90,-10},{-70,10}})));

          Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatPort
            "Modelica heat port" annotation (Placement(transformation(extent={{
                    70,-10},{90,10}}), iconTransformation(extent={{70,-10},{90,
                    10}})));

        equation
          // Efforts
          face.T = heatPort.T*U.K "Temperature";

          // Conservation (no storage)
          face.mPhidot = {0,0} "Transverse translational momentum";
          0 = face.Qdot + heatPort.Q_flow*U.W "Energy";
          // Note:  The enthalpy, kinetic energy, and electric work terms each
          // cancel since there's no material storage and the thermodynamic state
          // and electrical potential is continuous across the junction.
          annotation (
            defaultComponentName="species",
            Documentation(info="<html><p>Note that shear force is not included.</p>
  </html>"),
            Icon(graphics={Line(
                          points={{0,0},{-80,0}},
                          color={127,127,127},
                          smooth=Smooth.None),Line(
                          points={{0,0},{80,0}},
                          color={191,0,0},
                          smooth=Smooth.None)}));
        end PartialSpecies;

      end BaseClasses;

    end Species;

    package Junctions
      "<html><a href=\"modelica://Modelica\">Modelica</a> junctions between pure substances and their mixtures</html>"
      extends Modelica.Icons.Package;

      model Junction2 "Junction between two pure substances and their mixture"
        extends BaseClasses.PartialJunction;

        replaceable package Medium1 = Modelica.Media.IdealGases.SingleGases.H2
            (referenceChoice=Modelica.Media.Interfaces.PartialMedium.Choices.ReferenceEnthalpy.ZeroAt25C,
              excludeEnthalpyOfFormation=false) constrainedby
          Modelica.Media.Interfaces.PartialPureSubstance
          "<html>Medium model for the 1<sup>st</sup> pure substance</html>"
          annotation (choicesAllMatching=true, Dialog(group=
                "Material properties"));
        replaceable package Medium2 = Modelica.Media.IdealGases.SingleGases.H2O
            (referenceChoice=Modelica.Media.Interfaces.PartialMedium.Choices.ReferenceEnthalpy.ZeroAt25C,
              excludeEnthalpyOfFormation=false) constrainedby
          Modelica.Media.Interfaces.PartialPureSubstance
          "<html>Medium model for the 2<sup>nd</sup> pure substance</html>"
          annotation (choicesAllMatching=true, Dialog(group=
                "Material properties"));

        Modelica.Fluid.Interfaces.FluidPort_b purePort1(redeclare final package
            Medium = Medium1) "Fluid port for the 1st pure substance"
          annotation (Placement(transformation(extent={{70,28},{90,48}}),
              iconTransformation(extent={{70,28},{90,48}})));
        Modelica.Fluid.Interfaces.FluidPort_b purePort2(redeclare final package
            Medium = Medium2) "Fluid port for the 2nd pure substance"
          annotation (Placement(transformation(extent={{70,-50},{90,-30}}),
              iconTransformation(extent={{70,-50},{90,-30}})));

      initial equation
        // Check the number and names of substances
        assert(MixtureMedium.nS == 2,
          "The mixture medium must have exactly two substances.");
        assert(MixtureMedium.substanceNames[1] == Medium1.substanceNames[1],
          "The first substance of the mixture medium (MixtureMedium) is \"" +
          MixtureMedium.substanceNames[1] + "\",
but the first pure substance is \"" + Medium1.substanceNames[1] + "\".");
        assert(MixtureMedium.substanceNames[2] == Medium2.substanceNames[1],
          "The second substance of the mixture medium (MixtureMedium) is \"" +
          MixtureMedium.substanceNames[2] + "\",
but the second pure substance is \"" + Medium2.substanceNames[1] + "\".");

        // Check the extra properties.
        assert(MixtureMedium.nC == Medium1.nC and MixtureMedium.nC == Medium2.nC,
          "The media must all have the same number of extra properties.");
        for i in 1:MixtureMedium.nC loop
          assert(MixtureMedium.extraPropertiesNames[i] == Medium1.extraPropertiesNames[
            i], "Extra property #" + String(i) +
            " of the mixture medium (MixtureMedium) is \"" + MixtureMedium.extraPropertiesNames[
            i] + "\",
but that of the first pure substance (Medium1) is \"" + Medium1.extraPropertiesNames[
            i] + "\".");
          assert(MixtureMedium.extraPropertiesNames[i] == Medium2.extraPropertiesNames[
            i], "Extra property #" + String(i) +
            " of the mixture medium (MixtureMedium) is \"" + MixtureMedium.extraPropertiesNames[
            i] + "\",
but that of the second pure substance (Medium2) is \"" + Medium2.extraPropertiesNames[
            i] + "\".");
        end for;

      equation
        // Dalton's law (additivity of pressure)
        mixturePort.p = purePort1.p + purePort2.p;

        // Streams
        // -------
        // Enthalpy
        purePort1.h_outflow = inStream(mixturePort.h_outflow);
        purePort2.h_outflow = inStream(mixturePort.h_outflow);
        mixturePort.h_outflow = X*{inStream(purePort1.h_outflow),inStream(
          purePort2.h_outflow)};
        //
        // Extra properties
        purePort1.C_outflow = inStream(mixturePort.C_outflow);
        purePort2.C_outflow = inStream(mixturePort.C_outflow);
        mixturePort.C_outflow = X*{inStream(purePort1.C_outflow),inStream(
          purePort2.C_outflow)};

        // Mass conservation (no storage)
        0 = X[1]*mixturePort.m_flow + purePort1.m_flow "Substance 1";
        0 = X[2]*mixturePort.m_flow + purePort2.m_flow "Substance 2";
        annotation (
          defaultComponentName="junction",
          Documentation(info="<html><p>Assumptions:
  <ol>
  <li>The mixing is ideal.  If the pure substances are being combined,
  then the massic enthalpy of the mixture is the mass-weighted sum of the pure substances.
  If the mixture is being split, then each of the pure substances receives fluid
  at the same massic enthalpy.
  </li>
  <li>The mixture observes Dalton's law.  The pressure of the mixture is the sum
  of the pressures of the pure substances.
  </li>
  </ol></p></html>"),
          Icon(graphics={Line(
                      points={{0,-40},{80,-40}},
                      color={0,127,255},
                      smooth=Smooth.None),Line(
                      points={{0,40},{80,40}},
                      color={0,127,255},
                      smooth=Smooth.None)}));
      end Junction2;

      model Junction3
        "Junction between three pure substances and their mixture"
        extends BaseClasses.PartialJunction(redeclare replaceable package
            MixtureMedium = Media.CathodeGas);

        replaceable package Medium1 = Modelica.Media.IdealGases.SingleGases.H2O
            (referenceChoice=Modelica.Media.Interfaces.PartialMedium.Choices.ReferenceEnthalpy.ZeroAt25C,
              excludeEnthalpyOfFormation=false) constrainedby
          Modelica.Media.Interfaces.PartialPureSubstance
          "<html>Medium model for the 1<sup>st</sup> pure substance</html>"
          annotation (choicesAllMatching=true, Dialog(group=
                "Material properties"));
        replaceable package Medium2 = Modelica.Media.IdealGases.SingleGases.N2
            (referenceChoice=Modelica.Media.Interfaces.PartialMedium.Choices.ReferenceEnthalpy.ZeroAt25C,
              excludeEnthalpyOfFormation=false) constrainedby
          Modelica.Media.Interfaces.PartialPureSubstance
          "<html>Medium model for the 2<sup>nd</sup> pure substance</html>"
          annotation (choicesAllMatching=true, Dialog(group=
                "Material properties"));
        replaceable package Medium3 = Modelica.Media.IdealGases.SingleGases.O2
            (referenceChoice=Modelica.Media.Interfaces.PartialMedium.Choices.ReferenceEnthalpy.ZeroAt25C,
              excludeEnthalpyOfFormation=false) constrainedby
          Modelica.Media.Interfaces.PartialPureSubstance
          "<html>Medium model for the 3<sup>rd</sup> pure substance</html>"
          annotation (choicesAllMatching=true, Dialog(group=
                "Material properties"));

        Modelica.Fluid.Interfaces.FluidPort_b purePort1(redeclare final package
            Medium = Medium1) "Fluid port for the 1st pure substance"
          annotation (Placement(transformation(extent={{70,28},{90,48}}),
              iconTransformation(extent={{70,28},{90,48}})));
        Modelica.Fluid.Interfaces.FluidPort_b purePort2(redeclare final package
            Medium = Medium2) "Fluid port for the 2nd pure substance"
          annotation (Placement(transformation(extent={{70,-10},{90,10}}),
              iconTransformation(extent={{70,-10},{90,10}})));
        Modelica.Fluid.Interfaces.FluidPort_b purePort3(redeclare final package
            Medium = Medium3) "Fluid port for the 3rd pure substance"
          annotation (Placement(transformation(extent={{70,-50},{90,-30}}),
              iconTransformation(extent={{70,-50},{90,-30}})));

      initial equation
        // Check the number and names of substances
        assert(MixtureMedium.nS == 3,
          "The mixture medium must have exactly three substances.");
        assert(MixtureMedium.substanceNames[1] == Medium1.substanceNames[1],
          "The first substance of the mixture medium (MixtureMedium) is \"" +
          MixtureMedium.substanceNames[1] + "\",
but the first pure substance is \"" + Medium1.substanceNames[1] + "\".");
        assert(MixtureMedium.substanceNames[2] == Medium2.substanceNames[1],
          "The second substance of the mixture medium (MixtureMedium) is \"" +
          MixtureMedium.substanceNames[2] + "\",
but the second pure substance is \"" + Medium2.substanceNames[1] + "\".");
        assert(MixtureMedium.substanceNames[3] == Medium3.substanceNames[1],
          "The second substance of the mixture medium (MixtureMedium) is \"" +
          MixtureMedium.substanceNames[3] + "\",
but the third pure substance is \"" + Medium2.substanceNames[1] + "\".");

        // Check the extra properties.
        assert(MixtureMedium.nC == Medium1.nC and MixtureMedium.nC == Medium2.nC
           and MixtureMedium.nC == Medium3.nC,
          "The media must all have the same number of extra properties.");
        for i in 1:MixtureMedium.nC loop
          assert(MixtureMedium.extraPropertiesNames[i] == Medium1.extraPropertiesNames[
            i], "Extra property #" + String(i) +
            " of the mixture medium (MixtureMedium) is \"" + MixtureMedium.extraPropertiesNames[
            i] + "\",
but that of the first pure substance (Medium1) is \"" + Medium1.extraPropertiesNames[
            i] + "\".");
          assert(MixtureMedium.extraPropertiesNames[i] == Medium2.extraPropertiesNames[
            i], "Extra property #" + String(i) +
            " of the mixture medium (MixtureMedium) is \"" + MixtureMedium.extraPropertiesNames[
            i] + "\",
but that of the second pure substance (Medium2) is \"" + Medium2.extraPropertiesNames[
            i] + "\".");
          assert(MixtureMedium.extraPropertiesNames[i] == Medium3.extraPropertiesNames[
            i], "Extra property #" + String(i) +
            " of the mixture medium (MixtureMedium) is \"" + MixtureMedium.extraPropertiesNames[
            i] + "\",
but that of the third pure substance (Medium3) is \"" + Medium3.extraPropertiesNames[
            i] + "\".");
        end for;

      equation
        // Dalton's law (additivity of pressure)
        mixturePort.p = purePort1.p + purePort2.p + purePort3.p;

        // Streams
        // -------
        // Enthalpy
        purePort1.h_outflow = inStream(mixturePort.h_outflow);
        purePort2.h_outflow = inStream(mixturePort.h_outflow);
        purePort3.h_outflow = inStream(mixturePort.h_outflow);
        mixturePort.h_outflow = X*{inStream(purePort1.h_outflow),inStream(
          purePort2.h_outflow),inStream(purePort3.h_outflow)};
        //
        // Extra properties
        purePort1.C_outflow = inStream(mixturePort.C_outflow);
        purePort2.C_outflow = inStream(mixturePort.C_outflow);
        purePort3.C_outflow = inStream(mixturePort.C_outflow);
        mixturePort.C_outflow = X*{inStream(purePort1.C_outflow),inStream(
          purePort2.C_outflow),inStream(purePort3.C_outflow)};

        // Mass conservation (no storage)
        0 = X[1]*mixturePort.m_flow + purePort1.m_flow "Substance 1";
        0 = X[2]*mixturePort.m_flow + purePort2.m_flow "Substance 2";
        0 = X[3]*mixturePort.m_flow + purePort3.m_flow "Substance 3";
        annotation (
          defaultComponentName="junction",
          Documentation(info="<html><p>Assumptions:
  <ol>
  <li>The mixing is ideal.  If the pure substances are being combined,
  then the massic enthalpy of the mixture is the mass-weighted sum of the pure substances.
  If the mixture is being split, then each of the pure substances receives fluid
  at the same massic enthalpy.
  </li>
  <li>The mixture observes Dalton's law.  The pressure of the mixture is the sum
  of the pressures of the pure substances.
  </li>
  </ol></p></html>"),
          Icon(graphics={Line(
                      points={{0,-40},{80,-40}},
                      color={0,127,255},
                      smooth=Smooth.None),Line(
                      points={{0,40},{80,40}},
                      color={0,127,255},
                      smooth=Smooth.None),Line(
                      points={{6,0},{80,0}},
                      color={0,127,255},
                      smooth=Smooth.None)}));
      end Junction3;

      package BaseClasses "Base classes (not generally for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialJunction
          "Partial model for a junction between pure substances and their mixture"
          extends FCSys.BaseClasses.Icons.Names.Top3;

          replaceable package MixtureMedium = Media.AnodeGas constrainedby
            Modelica.Media.Interfaces.PartialMedium
            "Medium model for the mixture" annotation (choicesAllMatching=true,
              Dialog(group="Material properties"));

          Modelica.Fluid.Interfaces.FluidPort_a mixturePort(redeclare final
              package Medium = MixtureMedium) "Fluid port for the mixture"
            annotation (Placement(transformation(extent={{-90,-10},{-70,10}}),
                iconTransformation(extent={{-90,-10},{-70,10}})));

          Modelica.SIunits.MassFraction X[MixtureMedium.nX]
            "Mass fractions within the mixture";

        equation
          // Mass fractions
          X = if MixtureMedium.fixedX then MixtureMedium.reference_X else if
            MixtureMedium.reducedX then cat(
                    1,
                    inStream(mixturePort.Xi_outflow),
                    1 - sum(X[1:MixtureMedium.nXi])) else inStream(mixturePort.Xi_outflow);
          X = if MixtureMedium.reducedX then cat(
                    1,
                    mixturePort.Xi_outflow,
                    1 - sum(X[1:MixtureMedium.nXi])) else mixturePort.Xi_outflow;
          annotation (defaultComponentName="junction", Icon(graphics={Line(
                          points={{-80,0},{0,0}},
                          color={0,127,255},
                          smooth=Smooth.None),Line(
                          points={{0,-40},{0,40}},
                          color={0,127,255},
                          smooth=Smooth.None),Ellipse(
                          extent={{-6,6},{6,-6}},
                          lineColor={0,127,255},
                          fillColor={255,255,255},
                          fillPattern=FillPattern.Solid)}));
        end PartialJunction;

      end BaseClasses;

    end Junctions;

    package Media
      "<html><a href=\"modelica://Modelica.Media\">Modelica media</a> models to interface with the <a href=\"modelica://FCSys.Assemblies.Cells.Cell\">fuel cell</a></html>"
      extends Modelica.Icons.MaterialPropertiesPackage;

      package AnodeGas "Gas mixture for PEMFC anode (H2 and H2O)"
        extends Modelica.Media.IdealGases.Common.MixtureGasNasa(
          mediumName="AnodeGas",
          data={Modelica.Media.IdealGases.Common.SingleGasesData.H2,Modelica.Media.IdealGases.Common.SingleGasesData.H2O},

          fluidConstants={Modelica.Media.IdealGases.Common.FluidData.H2,
              Modelica.Media.IdealGases.Common.FluidData.H2O},
          substanceNames={"H2","H2O"},
          reference_X=fill(1/nX, nX),
          referenceChoice=Modelica.Media.Interfaces.PartialMedium.Choices.ReferenceEnthalpy.ZeroAt25C,

          excludeEnthalpyOfFormation=false);

        annotation (Documentation(info="<html>

</html>"));

      end AnodeGas;

      package CathodeGas "Gas mixture for PEMFC cathode (H2O, N2, and O2)"
        extends Modelica.Media.IdealGases.Common.MixtureGasNasa(
          mediumName="CathodeGas",
          data={Modelica.Media.IdealGases.Common.SingleGasesData.H2O,Modelica.Media.IdealGases.Common.SingleGasesData.N2,
              Modelica.Media.IdealGases.Common.SingleGasesData.O2},
          fluidConstants={Modelica.Media.IdealGases.Common.FluidData.H2O,
              Modelica.Media.IdealGases.Common.FluidData.N2,Modelica.Media.IdealGases.Common.FluidData.O2},

          substanceNames={"H2O","N2","O2"},
          reference_X=fill(1/nX, nX),
          referenceChoice=Modelica.Media.Interfaces.PartialMedium.Choices.ReferenceEnthalpy.ZeroAt25C,

          excludeEnthalpyOfFormation=false);

        annotation (Documentation(info="<html>

</html>"));

      end CathodeGas;

    end Media;

  end Adapters;

  package TestStands "Test stands"
    extends Modelica.Icons.Package;
    extends FCSys.BaseClasses.Icons.PackageUnderConstruction;
    model TestProfile "Cell test profile"
      extends Modelica.Icons.Example;
      extends BaseClasses.PartialTestStandNoIO;
      annotation (structurallyIncomplete=true, Diagram(coordinateSystem(
              preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
            graphics));

    end TestProfile;

    model Replay
      "Regenerate signals recorded from HNEI's Greenlight FC test stand"
      extends FCSys.BaseClasses.Icons.Blocks.ContinuousShort;

      parameter Integer n(final min=1) = 1 "index of the data set";
      parameter Boolean terminateMaxTime=true
        "Terminate at maximum time of source data"
        annotation (Dialog(compact=true), choices(__Dymola_checkBox=true));

      Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
        tableOnFile=true,
        extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
        tableName="data" + String(n),
        fileName="FCSys/test/LOOCV/data.mat",
        columns=2:19,
        smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
        "Block to load and replay data" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,80})));
      Connectors.RealOutputBus y "Output signals as a bus" annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,-110}),iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,-50})));

    protected
      Modelica.Blocks.Math.Add sumAnMFC annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-14,30})));
      Modelica.Blocks.Math.Add sumCaMFC annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={14,30})));

      Modelica.Blocks.Math.Gain from_V(k=U.V) annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-152,0})));
      Modelica.Blocks.Math.Gain 'from1_%'(k=U.'%') annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-134,-30})));
      Modelica.Blocks.Math.Gain 'from2_%'(k=U.'%') annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-114,0})));
      Blocks.UnitConversions.From_kPag from1_kPag annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-94,-30})));
      Blocks.UnitConversions.From_kPag from2_kPag annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-74,0})));
      Blocks.UnitConversions.From_kPag from3_kPag annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-54,-30})));
      Blocks.UnitConversions.From_kPag from4_kPag annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-34,0})));
      Modelica.Blocks.Math.Gain from1_LPM(k=U.L/U.min) annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-14,-30})));
      Modelica.Blocks.Math.Gain from2_LPM(k=U.L/U.min) annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={14,0})));
      Blocks.UnitConversions.From_degC from1_degC annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={32,-30})));
      Blocks.UnitConversions.From_degC from2_degC annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={52,0})));
      Blocks.UnitConversions.From_degC from3_degC annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={72,-30})));
      Blocks.UnitConversions.From_degC from4_degC annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={92,0})));
      Blocks.UnitConversions.From_degC from5_degC annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={112,-30})));
      Blocks.UnitConversions.From_degC from6_degC annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={132,0})));
      Modelica.Blocks.Math.Gain from_A(k=U.A) annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={152,-30})));

      Connectors.RealOutputInternal v(final unit="l2.m/(N.T2)")
        "CVM Cell 1 Voltage" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-152,-60})));
      Connectors.RealOutputInternal RHAnFPNegX(
        final unit="1",
        displayUnit="%",
        final min=0) "Anode inlet RH" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-134,-60})));
      Connectors.RealOutputInternal RHCaFPNegX(
        final unit="1",
        displayUnit="%",
        final min=0) "Cathode inlet RH" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-114,-60})));
      Connectors.RealOutputInternal p_anFPNegY(final unit="m/(l.T2)")
        "Pressure anode inlet" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-94,-60})));
      Connectors.RealOutputInternal p_anFPPosY(final unit="m/(l.T2)", final min
          =0) "Pressure anode outlet" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-74,-60})));
      Connectors.RealOutputInternal p_caFPNegY(final unit="m/(l.T2)")
        "Pressure cathode inlet" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-54,-60})));
      Connectors.RealOutputInternal p_caFPPosY(final unit="m/(l.T2)", final min
          =0) "Pressure anode outlet" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-34,-60})));
      Connectors.RealOutputInternal Vdot_anFPNegY_H2(final unit="l3/T")
        "Flow anode H2 MFC" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-14,-60})));
      Connectors.RealOutputInternal Vdot_caFPNegY_air(final unit="l3/T")
        "Flow cathode H2 MFC" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={14,-60})));
      Connectors.RealOutputInternal T_anFPNegY(
        final unit="l2.m/(N.T2)",
        displayUnit="K",
        final min=0) "Temperature anode inlet" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={32,-60})));
      Connectors.RealOutputInternal T_anFPPosY(
        final unit="l2.m/(N.T2)",
        displayUnit="K",
        final min=0) "Temperature anode outlet" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={52,-60})));
      Connectors.RealOutputInternal T_caFPNegY(
        final unit="l2.m/(N.T2)",
        displayUnit="K",
        final min=0) "Temperature cathode inlet" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={72,-60})));
      Connectors.RealOutputInternal T_caFPPosY(
        final unit="l2.m/(N.T2)",
        displayUnit="K",
        final min=0) "Temperature cathode outlet" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={92,-60})));
      Connectors.RealOutputInternal T_anFPX(
        final unit="l2.m/(N.T2)",
        displayUnit="K",
        final min=0) "Temperature end plate anode" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={112,-60})));
      Connectors.RealOutputInternal T_caFPX(
        final unit="l2.m/(N.T2)",
        displayUnit="K",
        final min=0) "Temperature end plate cathode" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={132,-60})));
      Connectors.RealOutputInternal I(final unit="N/T") "Measured load"
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={152,-60})));

    equation
      //  Terminate as desired
      if terminateMaxTime then
        when time > combiTimeTable.t_max then
          terminate("The end of the data has been reached.");
        end when;
      end if;

      // Connections from source to unit conversion
      connect(from_V.u, combiTimeTable.y[1]) annotation (Line(
          points={{-152,12},{-152,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));

      connect('from1_%'.u, combiTimeTable.y[2]) annotation (Line(
          points={{-134,-18},{-134,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));

      connect('from2_%'.u, combiTimeTable.y[3]) annotation (Line(
          points={{-114,12},{-114,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(from1_kPag.u, combiTimeTable.y[4]) annotation (Line(
          points={{-94,-19},{-94,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(from2_kPag.u, combiTimeTable.y[5]) annotation (Line(
          points={{-74,11},{-74,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(from3_kPag.u, combiTimeTable.y[6]) annotation (Line(
          points={{-54,-19},{-54,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(from4_kPag.u, combiTimeTable.y[7]) annotation (Line(
          points={{-34,11},{-34,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sumAnMFC.u1, combiTimeTable.y[8]) annotation (Line(
          points={{-8,42},{-8,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sumAnMFC.u2, combiTimeTable.y[9]) annotation (Line(
          points={{-20,42},{-20,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sumCaMFC.u1, combiTimeTable.y[10]) annotation (Line(
          points={{20,42},{20,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(sumCaMFC.u2, combiTimeTable.y[11]) annotation (Line(
          points={{8,42},{8,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(from1_degC.u, combiTimeTable.y[12]) annotation (Line(
          points={{32,-19},{32,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(from2_degC.u, combiTimeTable.y[13]) annotation (Line(
          points={{52,11},{52,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(from3_degC.u, combiTimeTable.y[14]) annotation (Line(
          points={{72,-19},{72,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(from4_degC.u, combiTimeTable.y[15]) annotation (Line(
          points={{92,11},{92,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(from5_degC.u, combiTimeTable.y[16]) annotation (Line(
          points={{112,-19},{112,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(from6_degC.u, combiTimeTable.y[17]) annotation (Line(
          points={{132,11},{132,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(from_A.u, combiTimeTable.y[18]) annotation (Line(
          points={{152,-18},{152,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));

      // Connections from unit conversion to internal outputs
      connect(v, from_V.y) annotation (Line(
          points={{-152,-60},{-152,-11}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(RHAnFPNegX, 'from1_%'.y) annotation (Line(
          points={{-134,-60},{-134,-41}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(RHCaFPNegX, 'from2_%'.y) annotation (Line(
          points={{-114,-60},{-114,-11}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(p_anFPNegY, from1_kPag.y) annotation (Line(
          points={{-94,-60},{-94,-41}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(p_anFPPosY, from2_kPag.y) annotation (Line(
          points={{-74,-60},{-74,-11}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(p_caFPNegY, from3_kPag.y) annotation (Line(
          points={{-54,-60},{-54,-41}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(p_caFPPosY, from4_kPag.y) annotation (Line(
          points={{-34,-60},{-34,-11}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(Vdot_anFPNegY_H2, from1_LPM.y) annotation (Line(
          points={{-14,-60},{-14,-50.5},{-14,-41},{-14,-41}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(Vdot_caFPNegY_air, from2_LPM.y) annotation (Line(
          points={{14,-60},{14,-35.5},{14,-11},{14,-11}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T_anFPNegY, from1_degC.y) annotation (Line(
          points={{32,-60},{32,-50.5},{32,-41},{32,-41}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T_anFPPosY, from2_degC.y) annotation (Line(
          points={{52,-60},{52,-11}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T_caFPNegY, from3_degC.y) annotation (Line(
          points={{72,-60},{72,-41}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T_caFPPosY, from4_degC.y) annotation (Line(
          points={{92,-60},{92,-11}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T_anFPX, from5_degC.y) annotation (Line(
          points={{112,-60},{112,-41}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T_caFPX, from6_degC.y) annotation (Line(
          points={{132,-60},{132,-11}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(I, from_A.y) annotation (Line(
          points={{152,-60},{152,-41}},
          color={0,0,127},
          smooth=Smooth.None));

      // Summations
      connect(sumAnMFC.y, from1_LPM.u) annotation (Line(
          points={{-14,19},{-14,9.75},{-14,9.75},{-14,0.5},{-14,-18},{-14,-18}},

          color={0,0,127},
          smooth=Smooth.None));

      connect(sumCaMFC.y, from2_LPM.u) annotation (Line(
          points={{14,19},{14,17.25},{14,17.25},{14,15.5},{14,12},{14,12}},
          color={0,0,127},
          smooth=Smooth.None));

      // Connections from internal outputs to public output
      connect(v, y.v) annotation (Line(
          points={{-152,-60},{-152,-80},{5.55112e-16,-80},{5.55112e-16,-110}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(RHAnFPNegX, y.RHAnFPNegX) annotation (Line(
          points={{-134,-60},{-134,-80},{5.55112e-16,-80},{5.55112e-16,-110}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(RHCaFPNegX, y.RHCaFPNegX) annotation (Line(
          points={{-114,-60},{-114,-80},{5.55112e-16,-80},{5.55112e-16,-110}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(p_anFPNegY, y.p_anFPNegY) annotation (Line(
          points={{-94,-60},{-94,-80},{5.55112e-16,-80},{5.55112e-16,-110}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(p_anFPPosY, y.p_anFPPosY) annotation (Line(
          points={{-74,-60},{-74,-80},{5.55112e-16,-80},{5.55112e-16,-110}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(p_caFPNegY, y.p_caFPNegY) annotation (Line(
          points={{-54,-60},{-54,-80},{5.55112e-16,-80},{5.55112e-16,-110}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(p_caFPPosY, y.p_caFPPosY) annotation (Line(
          points={{-34,-60},{-34,-80},{5.55112e-16,-80},{5.55112e-16,-110}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(Vdot_anFPNegY_H2, y.Vdot_anFPNegY_H2) annotation (Line(
          points={{-14,-60},{-14,-80},{5.55112e-16,-80},{5.55112e-16,-110}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(Vdot_caFPNegY_air, y.Vdot_caFPNegY_air) annotation (Line(
          points={{14,-60},{14,-80},{5.55112e-16,-80},{5.55112e-16,-110}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T_anFPNegY, y.T_anFPNegY) annotation (Line(
          points={{32,-60},{32,-80},{5.55112e-16,-80},{5.55112e-16,-110}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T_anFPPosY, y.T_anFPPosY) annotation (Line(
          points={{52,-60},{52,-80},{5.55112e-16,-80},{5.55112e-16,-110}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T_caFPNegY, y.T_caFPNegY) annotation (Line(
          points={{72,-60},{72,-80},{5.55112e-16,-80},{5.55112e-16,-110}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T_caFPPosY, y.T_caFPPosY) annotation (Line(
          points={{92,-60},{92,-80},{5.55112e-16,-80},{5.55112e-16,-110}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T_anFPX, y.T_anFPX) annotation (Line(
          points={{112,-60},{112,-80},{5.55112e-16,-80},{5.55112e-16,-110}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(T_caFPX, y.T_caFPX) annotation (Line(
          points={{132,-60},{132,-80},{5.55112e-16,-80},{5.55112e-16,-110}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(I, y.I) annotation (Line(
          points={{152,-60},{152,-80},{5.55112e-16,-80},{5.55112e-16,-110}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-180,
                -100},{180,100}}), graphics), experiment(StopTime=15481,
            Algorithm="Euler"));
    end Replay;

    package BaseClasses "Base classes (not generally for direct use)"
      extends Modelica.Icons.BasesPackage;
      partial model PartialTestStand "Partial cell test stand"
        extends FCSys.BaseClasses.Icons.Names.Top9;
        extends Modelica.Icons.UnderConstruction;
        final parameter Integer n_x_an=1
          "<html>Number of subregions along the through-cell axis in anode FP (<i>n</i><sub>x an</sub>)</html>";
        final parameter Integer n_x_ca=1
          "<html>Number of subregions along the through-cell axis in anode FP (<i>n</i><sub>x ca</sub>)</html>";
        final parameter Integer n_y=1
          "<html>Number of subregions along the channel (<i>n</i><sub>y</sub>)</html>";
        final parameter Integer n_z=1
          "<html>Number of subregions across the channel (<i>n</i><sub>z</sub>)</html>";

        parameter Boolean inclIO=false "true, if input and output are included"
          annotation (HideResult=true, choices(__Dymola_checkBox=true));

        Connectors.FaceBus anEnd[n_y, n_z] "Anode end plate" annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-160,0}),iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={-160,0})));
        Connectors.FaceBus caEnd[n_y, n_z] "Cathode end plate" annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={160,0}), iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={162,0})));
        Connectors.FaceBus anSource[n_x_an, n_z] "Anode source" annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-40,-160}), iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={-40,-160})));
        Connectors.FaceBus anSink[n_x_an, n_z] "Anode sink" annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-40,160}), iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={-40,160})));
        Connectors.FaceBus caSource[n_x_ca, n_z] "Cathode source" annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={40,-160}),iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={40,160})));
        Connectors.FaceBus caSink[n_x_ca, n_z] "Cathode sink" annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={40,160}), iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={40,-160})));

        Conditions.FaceBus.SubregionFlows anEndCondition[n_y, n_z](each
            graphite('inclC+'=true, 'incle-'=true)) annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={-136,0})));
        Conditions.FaceBus.SubregionFlows caEndCondition[n_y, n_z](each
            graphite('inclC+'=true, 'incle-'=true)) annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={136,0})));
        Conditions.FaceBus.SubregionFlows anSourceCondition[n_x_an, n_z](each
            gas(inclH2=true, inclH2O=true)) annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-40,-136})));
        Conditions.FaceBus.SubregionFlows anSinkCondition[n_x_an, n_z](each gas(
              inclH2=true, inclH2O=true)) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=180,
              origin={-40,136})));
        Conditions.FaceBus.SubregionFlows caSourceCondition[n_x_ca, n_z](each
            gas(
            inclH2O=true,
            inclN2=true,
            inclO2=true)) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={40,-136})));
        Conditions.FaceBus.SubregionFlows caSinkCondition[n_x_ca, n_z](each gas(
            inclH2O=true,
            inclN2=true,
            inclO2=true)) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=180,
              origin={40,136})));
        Connectors.RealInputBus u[n_y, n_z] if inclIO annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=315,
              origin={-160,160}), iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=315,
              origin={-166,166})));
        Connectors.RealOutputBus y[n_y, n_z] if inclIO annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=315,
              origin={160,-160}), iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=315,
              origin={166,-166})));
        replaceable FCSys.Conditions.FaceBusPair.Subregion current[n_y, n_z](
            graphite('inclC+'=true, 'incle-'=true)) if inclIO constrainedby
          Conditions.FaceBusPair.Subregion(graphite('inclC+'=true, 'incle-'=
                true))
          annotation (Placement(transformation(extent={{-140,20},{-120,40}})));

      equation
        connect(anSourceCondition.face, anSource) annotation (Line(
            points={{-40,-140},{-40,-160}},
            color={127,127,127},
            thickness=0.5,
            smooth=Smooth.None));

        connect(anSinkCondition.face, anSink) annotation (Line(
            points={{-40,140},{-40,160}},
            color={127,127,127},
            thickness=0.5,
            smooth=Smooth.None));

        connect(caSourceCondition.face, caSource) annotation (Line(
            points={{40,-140},{40,-160}},
            color={127,127,127},
            thickness=0.5,
            smooth=Smooth.None));

        connect(caSinkCondition.face, caSink) annotation (Line(
            points={{40,140},{40,160}},
            color={127,127,127},
            thickness=0.5,
            smooth=Smooth.None));

        connect(caEndCondition.face, caEnd) annotation (Line(
            points={{140,3.65701e-16},{140,5.55112e-16},{160,5.55112e-16}},
            color={127,127,127},
            thickness=0.5,
            smooth=Smooth.None));
        connect(current.positive, caEnd) annotation (Line(
            points={{-120,30},{150,30},{150,5.55112e-16},{160,5.55112e-16}},
            color={127,127,127},
            thickness=0.5,
            smooth=Smooth.None));

        connect(current.negative, anEnd) annotation (Line(
            points={{-140,30},{-150,30},{-150,5.55112e-16},{-160,5.55112e-16}},

            color={127,127,127},
            thickness=0.5,
            smooth=Smooth.None));

        connect(u, current.u) annotation (Line(
            points={{-160,160},{-130,130},{-130,35}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));
        connect(voltage.negative, anEndCondition.face) annotation (Line(
            points={{120,-30},{-150,-30},{-150,1.23436e-15},{-140,1.23436e-15}},

            color={127,127,127},
            thickness=0.5,
            smooth=Smooth.None));

        connect(caEnd, voltage.positive) annotation (Line(
            points={{160,5.55112e-16},{150,5.55112e-16},{150,-30},{140,-30}},
            color={127,127,127},
            thickness=0.5,
            smooth=Smooth.None));

        connect(voltage.y, y) annotation (Line(
            points={{130,-40},{130,-140},{160,-160}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        connect(anEndCondition.face, anEnd) annotation (Line(
            points={{-140,1.23436e-15},{-140,5.55112e-16},{-160,5.55112e-16}},
            color={127,127,127},
            thickness=0.5,
            smooth=Smooth.None));
        annotation (
          defaultComponentName="testStand",
          Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-160,-160},
                  {160,160}}), graphics),
          Icon(coordinateSystem(preserveAspectRatio=true,extent={{-160,-160},{
                  160,160}}), graphics={Rectangle(
                      extent={{-160,160},{160,-160}},
                      lineColor={191,191,191},
                      fillColor={255,255,255},
                      fillPattern=FillPattern.Backward),Rectangle(extent={{-160,
                160},{160,-160}}, lineColor={0,0,0})}));
      end PartialTestStand;

      partial model PartialTestStandNoIO
        "Partial cell test stand without inputs/outputs"
        extends FCSys.BaseClasses.Icons.Names.Top9;

        final parameter Integer n_x_an=1
          "<html>Number of subregions along the through-cell axis in anode FP (<i>n</i><sub>x an</sub>)</html>";
        final parameter Integer n_x_ca=1
          "<html>Number of subregions along the through-cell axis in anode FP (<i>n</i><sub>x ca</sub>)</html>";
        final parameter Integer n_y=1
          "<html>Number of subregions along the channel (<i>n</i><sub>y</sub>)</html>";
        final parameter Integer n_z=1
          "<html>Number of subregions across the channel (<i>n</i><sub>z</sub>)</html>";

        Conditions.FaceBus.SubregionFlows anEnd[n_y, n_z](each graphite(
            'inclC+'=true,
            'incle-'=true,
            'e-'(redeclare Face.Normal.CurrentAreic normal(redeclare
                  Modelica.Blocks.Sources.Ramp source(height=U.A/U.cm^2,
                    duration=50))))) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-30,0})));
        Conditions.FaceBus.SubregionFlows caEnd[n_y, n_z](each graphite(
            'inclC+'=true,
            'incle-'=true,
            'e-'(redeclare Face.Normal.CurrentAreic normal(redeclare
                  Modelica.Blocks.Sources.Ramp source(height=U.A/U.cm^2,
                    duration=50))))) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={30,0})));
        Conditions.FaceBus.SubregionFlows anSource[n_x_an, n_z](each gas(inclH2
              =true, inclH2O=true)) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=180,
              origin={-20,-30})));
        Conditions.FaceBus.SubregionFlows anSink[n_x_an, n_z](each gas(inclH2=
                true,inclH2O=true)) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-20,30})));
        Conditions.FaceBus.SubregionFlows caSource[n_x_ca, n_z](each gas(
            inclH2O=true,
            inclN2=true,
            inclO2=true)) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=180,
              origin={20,-30})));
        Conditions.FaceBus.SubregionFlows caSink[n_x_ca, n_z](each gas(
            inclH2O=true,
            inclN2=true,
            inclO2=true)) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={20,30})));

        inner Environment environment
          annotation (Placement(transformation(extent={{50,20},{70,40}})));
        annotation (
          defaultComponentName="testStand",
          Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},
                  {100,100}}), graphics),
          Icon(coordinateSystem(preserveAspectRatio=true,extent={{-160,-160},{
                  160,160}}), graphics));

      end PartialTestStandNoIO;

    end BaseClasses;

  end TestStands;

  package ChemicalBus
    "<html>Conditions for the <a href=\"modelica://FCSys.Connectors.ChemicalBus\">ChemicalBus</a> connector</html>"
    extends Modelica.Icons.Package;

    model Gas "Condition for gas"

      extends BaseClasses.NullPhase;

      // Conditionally include species.
      parameter Boolean inclH2=false "<html>Hydrogen (H<sub>2</sub>)</html>"
        annotation (
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          __Dymola_joinNext=true));

      Chemical.Species H2(
        final inclTransX=inclTransX,
        final inclTransY=inclTransY,
        final inclTransZ=inclTransZ,
        redeclare FCSys.Characteristics.H2.Gas Data) if inclH2 "Model"
        annotation (Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          enable=inclH2), Placement(transformation(extent={{-10,-10},{10,10}})));

      parameter Boolean inclH2O=false "<html>Water (H<sub>2</sub>O)</html>"
        annotation (
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          __Dymola_joinNext=true));

      Chemical.Species H2O(
        final inclTransX=inclTransX,
        final inclTransY=inclTransY,
        final inclTransZ=inclTransZ,
        redeclare FCSys.Characteristics.H2O.Gas Data) if inclH2O "Model"
        annotation (Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          enable=inclH2O), Placement(transformation(extent={{-10,-10},{10,10}})));

      parameter Boolean inclN2=false "<html>Nitrogen (N<sub>2</sub>)</html>"
        annotation (
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          __Dymola_joinNext=true));

      Chemical.Species N2(
        final inclTransX=inclTransX,
        final inclTransY=inclTransY,
        final inclTransZ=inclTransZ,
        redeclare FCSys.Characteristics.N2.Gas Data) if inclN2 "Model"
        annotation (Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          enable=inclN2), Placement(transformation(extent={{-10,-10},{10,10}})));

      parameter Boolean inclO2=false "<html>Oxygen (O<sub>2</sub>)</html>"
        annotation (
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          __Dymola_joinNext=true));

      Chemical.Species O2(
        final inclTransX=inclTransX,
        final inclTransY=inclTransY,
        final inclTransZ=inclTransZ,
        redeclare FCSys.Characteristics.O2.Gas Data) if inclO2 "Model"
        annotation (Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          enable=inclO2), Placement(transformation(extent={{-10,-10},{10,10}})));

    equation
      // Note:  It would be helpful if Modelica allowed elements of expandable
      // connectors to be named by the contents of a string variable and the
      // name of an instance of a model was accessible through a string (like
      // %name is expanded to be the name of the instance of the model).  Then,
      // the connection equations that follow could be generic.

      // H2
      connect(H2.chemical, chemical.H2) annotation (Line(
          points={{6.10623e-16,-4},{5.55112e-16,-40}},
          color={239,142,1},
          smooth=Smooth.None));
      connect(u.H2, H2.u) annotation (Line(
          points={{-110,5.55112e-16},{-110,0},{-11,0},{-11,6.10623e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect(H2.y, y.H2) annotation (Line(
          points={{11,6.10623e-16},{11,0},{110,0},{110,5.55112e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

      // H2O
      connect(H2O.chemical, chemical.H2O) annotation (Line(
          points={{6.10623e-16,-4},{5.55112e-16,-40}},
          color={239,142,1},
          smooth=Smooth.None));
      connect(u.H2O, H2O.u) annotation (Line(
          points={{-110,5.55112e-16},{-110,0},{-11,0},{-11,6.10623e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect(H2O.y, y.H2O) annotation (Line(
          points={{11,6.10623e-16},{11,0},{110,0},{110,5.55112e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

      // N2
      connect(N2.chemical, chemical.N2) annotation (Line(
          points={{6.10623e-16,-4},{5.55112e-16,-40}},
          color={239,142,1},
          smooth=Smooth.None));
      connect(u.N2, N2.u) annotation (Line(
          points={{-110,5.55112e-16},{-110,0},{-11,0},{-11,6.10623e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect(N2.y, y.N2) annotation (Line(
          points={{11,6.10623e-16},{11,0},{110,0},{110,5.55112e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

      // O2
      connect(O2.chemical, chemical.O2) annotation (Line(
          points={{6.10623e-16,-4},{5.55112e-16,-40}},
          color={239,142,1},
          smooth=Smooth.None));
      connect(u.O2, O2.u) annotation (Line(
          points={{-110,5.55112e-16},{-110,0},{-11,0},{-11,6.10623e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect(O2.y, y.O2) annotation (Line(
          points={{11,6.10623e-16},{11,0},{110,0},{110,5.55112e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end Gas;

    model Graphite "Condition for graphite"

      extends BaseClasses.NullPhase;

      // Conditionally include species.
      parameter Boolean 'inclC+'=false
        "<html>Carbon plus (C<sup>+</sup>)</html>" annotation (
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          __Dymola_joinNext=true));

      Chemical.Species 'C+'(
        final inclTransX=inclTransX,
        final inclTransY=inclTransY,
        final inclTransZ=inclTransZ,
        redeclare FCSys.Characteristics.'C+'.Graphite Data) if 'inclC+' "Model"
        annotation (Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          enable='inclC+'), Placement(transformation(extent={{-10,-10},{10,10}})));

      parameter Boolean 'incle-'=false "<html>Electrons (e<sup>-</sup>)</html>"
        annotation (
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          __Dymola_joinNext=true));

      Chemical.Species 'e-'(
        final inclTransX=inclTransX,
        final inclTransY=inclTransY,
        final inclTransZ=inclTransZ,
        redeclare FCSys.Characteristics.'e-'.Graphite Data) if 'incle-' "Model"
        annotation (Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          enable='incle-'), Placement(transformation(extent={{-10,-10},{10,10}})));

    equation
      // C+
      connect('C+'.chemical, chemical.'C+') annotation (Line(
          points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
          color={239,142,1},
          smooth=Smooth.None));
      connect(u.'C+', 'C+'.u) annotation (Line(
          points={{-110,5.55112e-16},{-110,0},{-11,0},{-11,6.10623e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect('C+'.y, y.'C+') annotation (Line(
          points={{11,6.10623e-16},{11,0},{110,0},{110,5.55112e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

      // e-
      connect('e-'.chemical, chemical.'e-') annotation (Line(
          points={{6.10623e-16,-4},{5.55112e-16,-40}},
          color={239,142,1},
          smooth=Smooth.None));
      connect(u.'e-', 'e-'.u) annotation (Line(
          points={{-110,5.55112e-16},{-110,0},{-11,0},{-11,6.10623e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect('e-'.y, y.'e-') annotation (Line(
          points={{11,6.10623e-16},{11,0},{110,0},{110,5.55112e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

    end Graphite;

    model Ionomer "Condition for ionomer"

      extends BaseClasses.NullPhase;

      // Conditionally include species.
      parameter Boolean 'inclC19HF37O5S-'=false
        "<html>Nafion sulfonate (C<sub>19</sub>HF<sub>37</sub>O<sub>5</sub>S<sup>-</sup>)</html>"
        annotation (
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          __Dymola_joinNext=true));

      Chemical.Species 'C19HF37O5S-'(
        final inclTransX=inclTransX,
        final inclTransY=inclTransY,
        final inclTransZ=inclTransZ,
        redeclare FCSys.Characteristics.'C19HF37O5S-'.Ionomer Data) if
        'inclC19HF37O5S-' "Model" annotation (Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          enable='inclC19HF37O5S-'), Placement(transformation(extent={{-10,-10},
                {10,10}})));
      parameter Boolean 'inclH+'=false "<html>Protons (H<sup>+</sup>)</html>"
        annotation (
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          __Dymola_joinNext=true));

      Chemical.Species 'H+'(
        final inclTransX=inclTransX,
        final inclTransY=inclTransY,
        final inclTransZ=inclTransZ,
        redeclare FCSys.Characteristics.'H+'.Ionomer Data) if 'inclH+' "Model"
        annotation (Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          enable='inclH+'), Placement(transformation(extent={{-10,-10},{10,10}})));
      parameter Boolean inclH2O=false "<html>Water (H<sub>2</sub>O)</html>"
        annotation (
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          __Dymola_joinNext=true));

      Chemical.Species H2O(
        final inclTransX=inclTransX,
        final inclTransY=inclTransY,
        final inclTransZ=inclTransZ,
        redeclare FCSys.Characteristics.H2O.Gas Data) if inclH2O "Model"
        annotation (Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          enable=inclH2O), Placement(transformation(extent={{-10,-10},{10,10}})));

    equation
      // C19HF37O5S-
      connect('C19HF37O5S-'.chemical, chemical.'C19HF37O5S-') annotation (Line(
          points={{6.10623e-16,-4},{5.55112e-16,-40}},
          color={239,142,1},
          smooth=Smooth.None));
      connect(u.'C19HF37O5S-', 'C19HF37O5S-'.u) annotation (Line(
          points={{-110,5.55112e-16},{-110,0},{-11,0},{-11,6.10623e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect('C19HF37O5S-'.y, y.'C19HF37O5S-') annotation (Line(
          points={{11,6.10623e-16},{11,0},{110,0},{110,5.55112e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

      // H+
      connect('H+'.chemical, chemical.'H+') annotation (Line(
          points={{6.10623e-16,-4},{5.55112e-16,-40}},
          color={239,142,1},
          smooth=Smooth.None));
      connect(u.'H+', 'H+'.u) annotation (Line(
          points={{-110,5.55112e-16},{-110,0},{-11,0},{-11,6.10623e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect('H+'.y, y.'H+') annotation (Line(
          points={{11,6.10623e-16},{11,0},{110,0},{110,5.55112e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

      // H2O
      connect(H2O.chemical, chemical.H2O) annotation (Line(
          points={{6.10623e-16,-4},{5.55112e-16,-40}},
          color={239,142,1},
          smooth=Smooth.None));
      connect(u.H2O, H2O.u) annotation (Line(
          points={{-110,5.55112e-16},{-110,0},{-11,0},{-11,6.10623e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect(H2O.y, y.H2O) annotation (Line(
          points={{11,6.10623e-16},{11,0},{110,0},{110,5.55112e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

    end Ionomer;

    model Liquid "Condition for liquid"

      extends BaseClasses.NullPhase;

      // Conditionally include species.
      parameter Boolean inclH2O=false "<html>Water (H<sub>2</sub>O)</html>"
        annotation (
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          __Dymola_joinNext=true));

      Chemical.Species H2O(
        final inclTransX=inclTransX,
        final inclTransY=inclTransY,
        final inclTransZ=inclTransZ,
        redeclare FCSys.Characteristics.H2O.Liquid Data) if inclH2O "Model"
        annotation (Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          enable=inclH2O), Placement(transformation(extent={{-10,-10},{10,10}})));

    equation
      // H2O
      connect(H2O.chemical, chemical.H2O) annotation (Line(
          points={{6.10623e-16,-4},{5.55112e-16,-40}},
          color={239,142,1},
          smooth=Smooth.None));
      connect(u.H2O, H2O.u) annotation (Line(
          points={{-110,5.55112e-16},{-110,0},{-11,0},{-11,6.10623e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect(H2O.y, y.H2O) annotation (Line(
          points={{11,6.10623e-16},{11,0},{110,0},{110,5.55112e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

    end Liquid;

    package BaseClasses "Base classes (not generally for direct use)"
      extends Modelica.Icons.BasesPackage;

      model NullPhase "Empty condition for a phase (no species)"
        extends FCSys.Conditions.BaseClasses.Icons.Single;

        parameter Boolean inclTransX=true "X" annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Axes with translational momentum included", compact=
                true));

        parameter Boolean inclTransY=false "Y" annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Axes with translational momentum included", compact=
                true));

        parameter Boolean inclTransZ=false "Z" annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Axes with translational momentum included", compact=
                true));

        Connectors.ChemicalIOBus chemical
          "Bus of ChemicalInput and ChemicalOutput connectors of multiple species"
          annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

        Connectors.RealInputBus u "Bus of inputs to specify conditions"
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-110,0})));

        Connectors.RealOutputBus y "Bus of measurement outputs" annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={110,0})));
        annotation (Diagram(graphics));

      end NullPhase;

    end BaseClasses;
    annotation (Documentation(info="<html><p>All of the submodels for the individual species in
  <a href=\"modelica://FCSys.Conditions.ChemicalBus.Gas\">Gas</a>,
  <a href=\"modelica://FCSys.Conditions.ChemicalBus.Graphite\">Graphite</a>,
  <a href=\"modelica://FCSys.Conditions.ChemicalBus.Ionomer\">Ionomer</a>, and
  <a href=\"modelica://FCSys.Conditions.ChemicalBus.Liquid\">Liquid</a> models
  are instances of the <a href=\"modelica://FCSys.Conditions.Chemical.Species\">Conditions.Chemical.Species</a>
  model rather than <a href=\"modelica://FCSys.Conditions.Chemical.Reaction\">Conditions.Chemical.Reaction</a>).
  That means that the subconnectors in the
  (<code>chemical</code> connectors of the models in this package are
  <a href=\"modelica://FCSys.Connectors.ChemicalOutput\">ChemicalOutput</a> connectors
  (rather than <a href=\"modelica://FCSys.Connectors.ChemicalInput\">ChemicalInput</a>).</p></html>"));

  end ChemicalBus;

  package Chemical
    "<html>Conditions for a <a href=\"modelica://FCSys.Connectors.ChemicalInput\">ChemicalInput</a> connector</html>"
    extends Modelica.Icons.Package;

    model Reaction
      "<html>Condition for a <a href=\"modelica://FCSys.Connectors.ChemicalInput\">ChemicalInput</a> connector (e.g., as in a <a href=\"modelica://FCSys.Subregions.Reaction\">Reaction</a> model)</html>"
      import FCSys.BaseClasses.Utilities.countTrue;
      extends BaseClasses.PartialConditions;

      Connectors.ChemicalInput chemical(final n_trans=countTrue({inclTransX,
            inclTransY,inclTransZ}))
        "Connector to exchange material while advecting translational momentum and enthalpy, with characteristic data as input"
        annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

    equation
      connect(material.chemical, chemical) annotation (Line(
          points={{-64,26},{-64,-30},{5.55112e-16,-30},{5.55112e-16,-40}},
          color={239,142,1},
          smooth=Smooth.None));
      connect(translationalX.chemical, chemical) annotation (Line(
          points={{-32,14},{-32,-30},{5.55112e-16,-30},{5.55112e-16,-40}},
          color={239,142,1},
          smooth=Smooth.None));
      connect(translationalY.chemical, chemical) annotation (Line(
          points={{6.10623e-16,2},{6.10623e-16,-30},{5.55112e-16,-30},{
              5.55112e-16,-40}},
          color={239,142,1},
          smooth=Smooth.None));

      connect(translationalZ.chemical, chemical) annotation (Line(
          points={{32,-10},{32,-30},{5.55112e-16,-30},{5.55112e-16,-40}},
          color={239,142,1},
          smooth=Smooth.None));
      connect(fluid.chemical, chemical) annotation (Line(
          points={{64,-24},{64,-30},{0,-30},{0,-40},{5.55112e-16,-40}},
          color={239,142,1},
          smooth=Smooth.None));
      annotation (Documentation(info="<html>
<p>See the <a href=\"modelica://FCSys.Conditions.Chemical.BaseClasses.PartialConditions\">PartialConditions</a>
model.</p>
</html>"));
    end Reaction;

    model Species
      "<html>Condition for a <a href=\"modelica://FCSys.Connectors.ChemicalInput\">ChemicalOutput</a> connector (e.g., as in a <a href=\"modelica://FCSys.Subregions.Species\">Species</a> model)</html>"
      import FCSys.BaseClasses.Utilities.countTrue;
      extends BaseClasses.PartialConditions;

      replaceable package Data = Characteristics.BaseClasses.Characteristic
        constrainedby Characteristics.BaseClasses.Characteristic
        "Characteristic data" annotation (
        __Dymola_choicesAllMatching=true,
        Dialog(group="Material properties"),
        Placement(transformation(extent={{-60,40},{-40,60}}),
            iconTransformation(extent={{-10,90},{10,110}})));

      Connectors.ChemicalSpecies chemical(final n_trans=countTrue({inclTransX,
            inclTransY,inclTransZ}))
        "Connector to exchange material while advecting translational momentum and enthalpy, with characteristic data as output"
        annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

      Properties properties(final n_trans=n_trans,final Data=Data) annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={0,-56})));

    protected
      final parameter Integer n_trans=countTrue({inclTransX,inclTransY,
          inclTransZ}) "Number of components of translational momentum";

      model Properties "Apply material data to a ChemicalOutput connector"
        extends FCSys.BaseClasses.Icons.Blocks.ContinuousShort;
        replaceable package Data = Characteristics.BaseClasses.Characteristic
          constrainedby Characteristics.BaseClasses.Characteristic
          "Characteristic data" annotation (
          __Dymola_choicesAllMatching=true,
          Dialog(group="Material properties"),
          Placement(transformation(extent={{-60,40},{-40,60}}),
              iconTransformation(extent={{-10,90},{10,110}})));
        parameter Integer n_trans
          "Number of components of translational momentum";

        Connectors.ChemicalSpecies chemical(final n_trans=n_trans)
          "Connector to exchange material while advecting translational momentum and enthalpy, with characteristic data as output"
          annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

      equation
        // Material data
        chemical.formula = Data.formula;
        chemical.m = Data.m;

        // Zero flows
        chemical.Ndot = 0;
        chemical.mPhidot = zeros(n_trans);
        chemical.Hdot = 0;

      end Properties;

    equation
      connect(material.chemical, chemical) annotation (Line(
          points={{-64,26},{-64,-30},{5.55112e-16,-30},{5.55112e-16,-40}},
          color={239,142,1},
          smooth=Smooth.None));
      connect(translationalX.chemical, chemical) annotation (Line(
          points={{-32,14},{-32,-30},{5.55112e-16,-30},{5.55112e-16,-40}},
          color={239,142,1},
          smooth=Smooth.None));
      connect(translationalY.chemical, chemical) annotation (Line(
          points={{6.10623e-16,2},{6.10623e-16,-30},{5.55112e-16,-30},{
              5.55112e-16,-40}},
          color={239,142,1},
          smooth=Smooth.None));

      connect(translationalZ.chemical, chemical) annotation (Line(
          points={{32,-10},{32,-30},{5.55112e-16,-30},{5.55112e-16,-40}},
          color={239,142,1},
          smooth=Smooth.None));
      connect(fluid.chemical, chemical) annotation (Line(
          points={{64,-24},{64,-30},{0,-30},{0,-40},{5.55112e-16,-40}},
          color={239,142,1},
          smooth=Smooth.None));

      connect(properties.chemical, chemical) annotation (Line(
          points={{9.89443e-16,-52},{0,-52},{0,-40},{5.55112e-16,-40}},
          color={239,142,1},
          smooth=Smooth.None));
      annotation (Documentation(info="<html>
<p>See the <a href=\"modelica://FCSys.Conditions.Chemical.BaseClasses.PartialConditions\">PartialConditions</a>
model.</p>
</html>"));
    end Species;

    package Material "Conditions for additivity of volume"
      extends Modelica.Icons.Package;

      model PotentialPerTemperature
        "Specify quotient of potential and temperature (measure current)"
        extends BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.PotentialPerTemperature,

          u(final unit="1"),
          final y(final unit="N/T") = chemical.Ndot);

      equation
        chemical.muPerT = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="amagat");
      end PotentialPerTemperature;

      model Current
        "Specify current (measure quotient of potential and temperature)"
        extends BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.Current,
          u(final unit="N/T"),
          final y(final unit="1") = chemical.muPerT);

      equation
        chemical.Ndot = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="amagat");
      end Current;

      model Custom "Custom expressions"
        extends BaseClasses.PartialCondition(final conditionType=BaseClasses.ConditionType.Custom,
            y=chemical.Ndot);

        Real x=chemical.muPerT "Expression to which the condition is applied"
          annotation (Dialog(group="Specification"));

      equation
        x = u_final;
        annotation (
          defaultComponentPrefixes="replaceable",
          defaultComponentName="amagat",
          Documentation(info="<html><p>The expression to which the condition is applied (<code>x</code>)
    must involve <code>face.T</code> and/or <code>face.Qdot</code>.</p></html>"));
      end Custom;

      package BaseClasses "Base classes (not generally for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialCondition "Partial model of a material condition"
          extends Chemical.BaseClasses.PartialCondition;

          constant ConditionType conditionType "Type of condition";
          // Note:  This is included so that the type of condition is recorded with
          // the results.

        equation
          // Zero values of other flows
          chemical.mPhidot = zeros(n_trans) "Force";
          chemical.Hdot = 0 "Enthalpy flow rate";
          annotation (defaultComponentName="volumeCondition");
        end PartialCondition;

        type ConditionType = enumeration(
            PotentialPerTemperature
              "Specify quotient of potential and temperature (measure current)",

            Current
              "Specify current (measure quotient of potential and temperature)",

            Custom "Custom expressions") "Types of conditions";

      end BaseClasses;

    end Material;

    package Translational "Translational conditions"
      extends Modelica.Icons.Package;
      model Velocity "Specify velocity (measure force)"
        extends BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.Velocity,
          u(final unit="l/T"),
          final y(final unit="l.m/T2") = chemical.mPhidot[transAxes[axis]]);

      equation
        chemical.phi[transAxes[axis]] = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="translational");
      end Velocity;

      model Custom "Custom expressions"
        extends BaseClasses.PartialCondition(final conditionType=BaseClasses.ConditionType.Custom,
            y=chemical.mPhidot[transAxes[axis]]);

        Real x=chemical.phi[transAxes[axis]]
          "Expression to which the condition is applied"
          annotation (Dialog(group="Specification"));

      equation
        x = u_final;
        annotation (
          defaultComponentPrefixes="replaceable",
          defaultComponentName="translational",
          Documentation(info="<html><p>The expression to which the condition is applied (<code>x</code>)
    must involve <code>face.T</code> and/or <code>face.Qdot</code>.</p></html>"));
      end Custom;

      package BaseClasses "Base classes (not generally for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialCondition
          "Partial model for a translational condition"
          import FCSys.BaseClasses.Utilities.enumerate;
          import FCSys.BaseClasses.Utilities.index;
          extends Chemical.BaseClasses.PartialCondition;

          parameter Axis axis=Axis.x "Axis" annotation (HideResult=true);

          constant ConditionType conditionType "Type of condition";
          // Note:  This is included so that the type of condition is recorded with
          // the results.

        protected
          final parameter Integer cartAxes[n_trans]=index({inclTransX,
              inclTransY,inclTransZ})
            "Cartesian-axis indices of the components of translational momentum";
          final parameter Integer transAxes[Axis]=enumerate({inclTransX,
              inclTransY,inclTransZ})
            "Translational-momentum-component indices of the Cartesian axes";

        equation
          // Zero values of other flows
          chemical.Ndot = 0 "Current";
          for i in 1:n_trans loop
            if cartAxes[i] <> axis then
              chemical.mPhidot[i] = 0 "Force along the other axes";
            end if;
          end for;
          chemical.Hdot = 0 "Enthalpy flow rate";
          annotation (defaultComponentName="translationalCondition");
        end PartialCondition;

        type ConditionType = enumeration(
            Velocity "Specify velocity (measure force)",
            Custom "Custom expressions") "Types of conditions";

      end BaseClasses;

    end Translational;

    package Fluid "Fluid conditions"
      extends Modelica.Icons.Package;

      model EnthalpyMassic
        "Specify massic enthalpy (measure enthalpy flow rate)"
        extends BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.EnthalpyMassic,
          u(final unit="l2/T2"),
          final y(final unit="l2.m/T3") = chemical.Hdot);

      equation
        chemical.hbar = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="fluid");
      end EnthalpyMassic;

      model Custom "Custom expressions"
        extends BaseClasses.PartialCondition(final conditionType=BaseClasses.ConditionType.Custom,
            y=chemical.Hdot);

        Real x=chemical.hbar "Expression to which the condition is applied"
          annotation (Dialog(group="Specification"));

      equation
        x = u_final;
        annotation (
          defaultComponentPrefixes="replaceable",
          defaultComponentName="fluid",
          Documentation(info="<html><p>The expression to which the condition is applied (<code>x</code>)
    must involve <code>face.T</code> and/or <code>face.Qdot</code>.</p></html>"));
      end Custom;

      package BaseClasses "Base classes (not generally for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialCondition "Partial model for a fluid condition"
          extends Chemical.BaseClasses.PartialCondition;

          constant ConditionType conditionType "Type of condition";
          // Note:  This is included so that the type of condition is recorded with
          // the results.

        equation
          // Zero values of other flows
          chemical.Ndot = 0 "Current";
          chemical.mPhidot = zeros(n_trans) "Force";
          annotation (defaultComponentName="fluid");
        end PartialCondition;

        type ConditionType = enumeration(
            EnthalpyMassic
              "Specify massic enthalpy (measure enthalpy flow rate)",
            Custom "Custom expressions") "Types of conditions";

      end BaseClasses;

    end Fluid;

    package BaseClasses "Base classes (not generally for direct use)"
      extends Modelica.Icons.BasesPackage;
      partial model PartialConditions
        "<html>Condition for a <a href=\"modelica://FCSys.Connectors.ChemicalInput\">ChemicalInput</a> connector (e.g., as in a <a href=\"modelica://FCSys.Subregions.Reaction\">Reaction</a> model), with efforts by default</html>"
        extends FCSys.Conditions.BaseClasses.Icons.Single;

        // Included components of translational momentum
        parameter Boolean inclTransX=true "X" annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Axes with translational momentum included", compact=
                true));

        parameter Boolean inclTransY=false "Y" annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Axes with translational momentum included", compact=
                true));

        parameter Boolean inclTransZ=false "Z" annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Axes with translational momentum included", compact=
                true));

        // Conditions
        replaceable Material.PotentialPerTemperature material(source(k(start=0)))
          constrainedby Material.BaseClasses.PartialCondition(
          final inclTransX=inclTransX,
          final inclTransY=inclTransY,
          final inclTransZ=inclTransZ) "Material" annotation (
          __Dymola_choicesFromPackage=true,
          Dialog(group="Conditions"),
          Placement(transformation(extent={{-74,20},{-54,40}})));
        replaceable FCSys.Conditions.Chemical.Translational.Velocity
          translationalX(source(k(start=0))) if inclTransX constrainedby
          Conditions.Chemical.Translational.BaseClasses.PartialCondition(
          final inclTransX=inclTransX,
          final inclTransY=inclTransY,
          final inclTransZ=inclTransZ,
          final axis=Axis.x) "X-axis translational" annotation (
          __Dymola_choicesFromPackage=true,
          Dialog(group="Conditions",enable=inclTransX),
          Placement(transformation(extent={{-42,8},{-22,28}})));
        replaceable FCSys.Conditions.Chemical.Translational.Velocity
          translationalY(source(k(start=0))) if inclTransY constrainedby
          Conditions.Chemical.Translational.BaseClasses.PartialCondition(
          final inclTransX=inclTransX,
          final inclTransY=inclTransY,
          final inclTransZ=inclTransZ,
          final axis=Axis.y) "Y-axis translational" annotation (
          __Dymola_choicesFromPackage=true,
          Dialog(group="Conditions",enable=inclTransY),
          Placement(transformation(extent={{-10,-4},{10,16}})));
        replaceable FCSys.Conditions.Chemical.Translational.Velocity
          translationalZ(source(k(start=0))) if inclTransZ constrainedby
          Conditions.Chemical.Translational.BaseClasses.PartialCondition(
          final inclTransX=inclTransX,
          final inclTransY=inclTransY,
          final inclTransZ=inclTransZ,
          final axis=Axis.z) "Z-axis translational" annotation (
          __Dymola_choicesFromPackage=true,
          Dialog(group="Conditions",enable=inclTransZ),
          Placement(transformation(extent={{22,-16},{42,4}})));
        replaceable Fluid.EnthalpyMassic fluid(source(k(start=0)))
          constrainedby Fluid.BaseClasses.PartialCondition(
          final inclTransX=inclTransX,
          final inclTransY=inclTransY,
          final inclTransZ=inclTransZ) "Fluid" annotation (
          __Dymola_choicesFromPackage=true,
          Dialog(group="Conditions"),
          Placement(transformation(extent={{54,-30},{74,-10}})));

        Connectors.RealInputBus u
          "Input bus for values of specified conditions" annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-110,0}), iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-110,0})));
        Connectors.RealOutputBus y "Output bus of measurements" annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={110,0}),iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={110,0})));

      equation
        // Material
        connect(u.material, material.u) annotation (Line(
            points={{-110,5.55112e-16},{-110,0},{-88,0},{-88,30},{-75,30}},
            color={0,0,127},
            smooth=Smooth.None), Text(
            string="%first",
            index=-1,
            extent={{-2,3},{-2,3}}));
        connect(material.y, y.material) annotation (Line(
            points={{-53,30},{90,30},{90,5.55112e-16},{110,5.55112e-16}},
            color={0,0,127},
            smooth=Smooth.None), Text(
            string="%second",
            index=1,
            extent={{2,3},{2,3}}));

        // X-axis translational
        connect(u.translationalX, translationalX.u) annotation (Line(
            points={{-110,5.55112e-16},{-110,0},{-88,0},{-88,18},{-43,18}},
            color={0,0,127},
            smooth=Smooth.None), Text(
            string="%first",
            index=-1,
            extent={{-2,3},{-2,3}}));
        connect(translationalX.y, y.translationalX) annotation (Line(
            points={{-21,18},{90,18},{90,5.55112e-16},{110,5.55112e-16}},
            color={0,0,127},
            smooth=Smooth.None), Text(
            string="%second",
            index=1,
            extent={{2,3},{2,3}}));

        // Y-axis translational

        connect(u.translationalY, translationalY.u) annotation (Line(
            points={{-110,5.55112e-16},{-110,0},{-88,0},{-88,6},{-11,6}},
            color={0,0,127},
            smooth=Smooth.None), Text(
            string="%first",
            index=-1,
            extent={{-2,3},{-2,3}}));
        connect(translationalY.y, y.translationalY) annotation (Line(
            points={{11,6},{90,6},{90,5.55112e-16},{110,5.55112e-16}},
            color={0,0,127},
            smooth=Smooth.None), Text(
            string="%second",
            index=1,
            extent={{2,3},{2,3}}));

        // Z-axis translational
        connect(u.translationalZ, translationalZ.u) annotation (Line(
            points={{-110,5.55112e-16},{-110,0},{-88,0},{-88,-6},{21,-6}},
            color={0,0,127},
            smooth=Smooth.None), Text(
            string="%first",
            index=-1,
            extent={{-2,3},{-2,3}}));
        connect(translationalZ.y, y.translationalZ) annotation (Line(
            points={{43,-6},{90,-6},{90,5.55112e-16},{110,5.55112e-16}},
            color={0,0,127},
            smooth=Smooth.None), Text(
            string="%second",
            index=1,
            extent={{2,3},{2,3}}));

        // Fluid
        connect(u.fluid, fluid.u) annotation (Line(
            points={{-110,5.55112e-16},{-110,0},{-88,0},{-88,-20},{53,-20}},
            color={0,0,127},
            smooth=Smooth.None), Text(
            string="%first",
            index=-1,
            extent={{-2,3},{-2,3}}));
        connect(fluid.y, y.fluid) annotation (Line(
            points={{75,-20},{90,-20},{90,5.55112e-16},{110,5.55112e-16}},
            color={0,0,127},
            smooth=Smooth.None), Text(
            string="%second",
            index=1,
            extent={{2,3},{2,3}}));
        annotation (Documentation(info="<html>
  <p>If the source of an internal specification is redeclared to a block besides
  <a href=\"modelica://Modelica.Blocks.Sources.Constant\">Modelica.Blocks.Sources.Constant</a>,
  then the related condition must be redeclared as well.  For example, use:<br>
  <code>redeclare Conditions.Chemical.Material.Current material(redeclare Modelica.Blocks.Sources.Ramp source)</code><br>
  rather than simply:<br>
  <code>material(redeclare Modelica.Blocks.Sources.Ramp source)</code></p>
  </html>"));
      end PartialConditions;

      partial model PartialCondition "Partial model of a condition"
        import FCSys.BaseClasses.Utilities.countTrue;
        extends FCSys.Conditions.BaseClasses.Icons.Single;

        parameter Boolean inclTransX=true "X" annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Axes with translational momentum included", compact=
                true));

        parameter Boolean inclTransY=false "Y" annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Axes with translational momentum included", compact=
                true));

        parameter Boolean inclTransZ=false "Z" annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Axes with translational momentum included", compact=
                true));

        parameter Boolean internal=true "Use internal specification"
          annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Specification"));

        replaceable Modelica.Blocks.Sources.Constant source if internal
          constrainedby Modelica.Blocks.Interfaces.SO
          "Source of internal specification" annotation (
          __Dymola_choicesFromPackage=true,
          Dialog(group="Specification",enable=internal),
          Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-70,30})));
        Connectors.RealInput u if not internal "Value of specified condition"
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-110,0})));

        Connectors.RealOutput y "Measurement expression" annotation (Dialog(
              group="Measurement"), Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={110,0}), iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={110,0})));
        Connectors.ChemicalInput chemical(final n_trans=n_trans)
          "Connector to exchange material while advecting translational momentum and enthalpy, with characteristic data as input"
          annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

      protected
        final parameter Integer n_trans=countTrue({inclTransX,inclTransY,
            inclTransZ}) "Number of components of translational momentum";

        Connectors.RealOutputInternal u_final
          "Final value of specified condition" annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-20,0})));

      equation
        connect(source.y, u_final) annotation (Line(
            points={{-59,30},{-40,30},{-40,5.55112e-16},{-20,5.55112e-16}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(u, u_final) annotation (Line(
            points={{-110,5.55112e-16},{-88,0},{-66,1.11022e-15},{-66,
                5.55112e-16},{-20,5.55112e-16}},
            color={0,0,127},
            smooth=Smooth.None));

      end PartialCondition;

    end BaseClasses;

  end Chemical;

  package Inert
    "<html>Conditions for a <a href=\"modelica://FCSys.Connectors.Inert\">Inert</a> or <a href=\"modelica://FCSys.Connectors.InertInternal\">InertInternal</a> connector</html>"
    extends Modelica.Icons.Package;

    model Species
      "<html>Condition for a <a href=\"modelica://FCSys.Connectors.Inert\">Inert</a> or <a href=\"modelica://FCSys.Connectors.InertInternal\">InertInternal</a> connector (e.g., as in a <a href=\"modelica://FCSys.Subregions.Species\">Species</a> model), with efforts by default</html>"
      import FCSys.BaseClasses.Utilities.countTrue;
      extends FCSys.Conditions.BaseClasses.Icons.Single;

      // Included components of translational momentum
      parameter Boolean inclTransX=true "X" annotation (
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(group="Axes with translational momentum included", compact=true));

      parameter Boolean inclTransY=false "Y" annotation (
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(group="Axes with translational momentum included", compact=true));

      parameter Boolean inclTransZ=false "Z" annotation (
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(group="Axes with translational momentum included", compact=true));

      // Included subconnectors
      parameter Boolean inclTranslational=true "Translational" annotation (
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(group="Included subconnectors",compact=true));
      parameter Boolean inclThermal=true "Thermal" annotation (
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(group="Included subconnectors",compact=true));

      // Conditions
      replaceable Translational.Velocity translationalX(source(k(start=0))) if
        inclTransX constrainedby Translational.BaseClasses.PartialCondition(
        final inclTransX=inclTransX,
        final inclTransY=inclTransY,
        final inclTransZ=inclTransZ,
        final axis=Axis.x) "X-axis translational" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Conditions",enable=inclTransX),
        Placement(transformation(extent={{-58,8},{-38,28}})));
      replaceable Translational.Velocity translationalY(source(k(start=0))) if
        inclTransY constrainedby Translational.BaseClasses.PartialCondition(
        final inclTransX=inclTransX,
        final inclTransY=inclTransY,
        final inclTransZ=inclTransZ,
        final axis=Axis.y) "Y-axis translational" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Conditions",enable=inclTransY),
        Placement(transformation(extent={{-26,-4},{-6,16}})));
      replaceable Translational.Velocity translationalZ(source(k(start=0))) if
        inclTransZ constrainedby Translational.BaseClasses.PartialCondition(
        final inclTransX=inclTransX,
        final inclTransY=inclTransY,
        final inclTransZ=inclTransZ,
        final axis=Axis.z) "Z-axis translational" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Conditions",enable=inclTransZ),
        Placement(transformation(extent={{6,-16},{26,4}})));
      replaceable Thermal.Temperature thermal(source(k(start=298.15*U.K)))
        constrainedby Thermal.BaseClasses.PartialCondition(
        final inclTransX=inclTransX,
        final inclTransY=inclTransY,
        final inclTransZ=inclTransZ) "Thermal" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Conditions"),
        Placement(transformation(extent={{38,-30},{58,-10}})));

      Connectors.RealInputBus u "Input bus for values of specified conditions"
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-110,0}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-112,0})));
      Connectors.RealOutputBus y "Output bus of measurements" annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={110,0}),iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={110,0})));

      Connectors.InertInternal inert(
        final n_trans=countTrue({inclTransX,inclTransY,inclTransZ}),
        inclTranslational=inclTranslational,
        inclThermal=inclThermal)
        "Single-species connector for translational momentum and heat"
        annotation (Placement(transformation(extent={{-10,-50},{10,-30}}),
            iconTransformation(extent={{-10,-50},{10,-30}})));

    equation
      // X-axis translational
      connect(translationalX.translational, inert.translational) annotation (
          Line(
          points={{-48,14},{-48,-30},{5.55112e-16,-30},{5.55112e-16,-40}},
          color={127,127,127},
          smooth=Smooth.None));
      connect(u.translationalX, translationalX.u) annotation (Line(
          points={{-110,5.55112e-16},{-110,0},{-90,0},{-90,18},{-59,18}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-2,3},{-2,3}}));
      connect(translationalX.y, y.translationalX) annotation (Line(
          points={{-37,18},{90,18},{90,5.55112e-16},{110,5.55112e-16}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{2,3},{2,3}}));

      // Y-axis translational
      connect(translationalY.translational, inert.translational) annotation (
          Line(
          points={{-16,2},{-16,-30},{0,-30},{0,-40},{5.55112e-16,-40}},
          color={127,127,127},
          smooth=Smooth.None));

      connect(u.translationalY, translationalY.u) annotation (Line(
          points={{-110,5.55112e-16},{-110,0},{-90,0},{-90,6},{-27,6}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-2,3},{-2,3}}));
      connect(translationalY.y, y.translationalY) annotation (Line(
          points={{-5,6},{90,6},{90,5.55112e-16},{110,5.55112e-16}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{2,3},{2,3}}));

      // Z-axis translational
      connect(translationalZ.translational, inert.translational) annotation (
          Line(
          points={{16,-10},{16,-30},{5.55112e-16,-30},{5.55112e-16,-40}},
          color={127,127,127},
          smooth=Smooth.None));
      connect(u.translationalZ, translationalZ.u) annotation (Line(
          points={{-110,5.55112e-16},{-110,0},{-90,0},{-90,-6},{5,-6}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-2,3},{-2,3}}));
      connect(translationalZ.y, y.translationalZ) annotation (Line(
          points={{27,-6},{90,-6},{90,5.55112e-16},{110,5.55112e-16}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{2,3},{2,3}}));

      // Thermal
      connect(thermal.thermal, inert.thermal) annotation (Line(
          points={{48,-24},{48,-30},{0,-30},{0,-40},{5.55112e-16,-40}},
          color={127,127,127},
          smooth=Smooth.None));
      connect(u.thermal, thermal.u) annotation (Line(
          points={{-110,5.55112e-16},{-110,0},{-90,0},{-90,-20},{37,-20}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-2,3},{-2,3}}));
      connect(thermal.y, y.thermal) annotation (Line(
          points={{59,-20},{90,-20},{90,5.55112e-16},{110,5.55112e-16}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{2,3},{2,3}}));
      annotation (Documentation(info="<html>
  <p>If the source of an internal specification is redeclared to a block besides
  <a href=\"modelica://Modelica.Blocks.Sources.Constant\">Modelica.Blocks.Sources.Constant</a>,
  then the related condition must be redeclared as well.  For example, use:<br>
  <code>redeclare Conditions.Inert.Translational.Force translationalX(redeclare Modelica.Blocks.Sources.Ramp source)</code><br>
  rather than simply:<br>
  <code>translationalX(redeclare Modelica.Blocks.Sources.Ramp source)</code></p>
  </html>"));
    end Species;

    model SpeciesFlow
      "<html>Condition for a <a href=\"modelica://FCSys.Connectors.Inert\">Inert</a> or <a href=\"modelica://FCSys.Connectors.InertInternal\">InertInternal</a> connector (e.g., as in a <a href=\"modelica://FCSys.Subregions.Species\">Species</a> model), with efforts by default</html>"

      extends Species(
        redeclare Translational.Force translationalX(source(k(start=0))),
        redeclare Translational.Force translationalY(source(k(start=0))),
        redeclare Translational.Force translationalZ(source(k(start=0))),
        redeclare Thermal.HeatRate thermal(source(k(start=0))));
      annotation (defaultComponentName="species",Documentation(info="<html>
<p>See the <a href=\"modelica://FCSys.Conditions.Inert.Species\">Species</a>
model.</p>
</html>"));

    end SpeciesFlow;

    package Translational "Translational conditions"
      extends Modelica.Icons.Package;
      model Velocity "Specify velocity (measure force)"
        extends BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.Velocity,
          u(final unit="l/T"),
          final y(final unit="l.m/T2") = translational.mPhidot[transAxes[axis]]);

      equation
        translational.phi[transAxes[axis]] = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="translational");
      end Velocity;

      model Force "Specify force (measure velocity)"
        extends BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.Force,
          u(final unit="l.m/T2"),
          final y(final unit="l/T") = translational.phi[transAxes[axis]]);

      equation
        translational.mPhidot[transAxes[axis]] = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="translational");
      end Force;

      model Custom "Custom expressions"
        extends BaseClasses.PartialCondition(final conditionType=BaseClasses.ConditionType.Custom,
            y=translational.mPhidot[transAxes[axis]]);

        Real x=translational.phi[transAxes[axis]]
          "Expression to which the condition is applied"
          annotation (Dialog(group="Specification"));

      equation
        x = u_final;
        annotation (
          defaultComponentPrefixes="replaceable",
          defaultComponentName="translational",
          Documentation(info="<html><p>The expression to which the condition is applied (<code>x</code>)
    must involve <code>face.T</code> and/or <code>face.Qdot</code>.</p></html>"));
      end Custom;

      package BaseClasses "Base classes (not generally for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialCondition
          "Partial model for a translational condition"
          import FCSys.BaseClasses.Utilities.enumerate;
          import FCSys.BaseClasses.Utilities.index;
          extends FCSys.Conditions.Inert.BaseClasses.PartialCondition;

          parameter Axis axis=Axis.x "Axis" annotation (HideResult=true);

          constant ConditionType conditionType "Type of condition";
          // Note:  This is included so that the type of condition is recorded with
          // the results.

          Connectors.Translational translational(final n_trans=n_trans)
            "Connector to exchange translational momentum"
            annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

        protected
          final parameter Integer cartAxes[n_trans]=index({inclTransX,
              inclTransY,inclTransZ})
            "Cartesian-axis indices of the components of translational momentum";
          final parameter Integer transAxes[Axis]=enumerate({inclTransX,
              inclTransY,inclTransZ})
            "Translational-momentum-component indices of the Cartesian axes";

        equation
          // Zero values of other flows
          for i in 1:n_trans loop
            if cartAxes[i] <> axis then
              translational.mPhidot[i] = 0 "Force along the other axes";
            end if;
          end for;
          annotation (defaultComponentName="translationalCondition");
        end PartialCondition;

        type ConditionType = enumeration(
            Velocity "Specify velocity (measure force)",
            Force "Specify force (measure velocity)",
            Custom "Custom expressions") "Types of conditions";

      end BaseClasses;

    end Translational;

    package Thermal "Thermal conditions"
      extends Modelica.Icons.Package;

      model Temperature "Specify temperature (measure heat flow rate)"
        extends BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.Temperature,
          u(final unit="l2.m/(N.T2)", displayUnit="K"),
          source(k(start=298.15*U.K)),
          final y(final unit="l2.m/T3") = thermal.Qdot);

      equation
        thermal.T = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="thermal");
      end Temperature;

      model HeatRate "Specify heat flow rate (measure temperature)"
        extends BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.HeatRate,
          u(final unit="l2.m/T3"),
          final y(
            final unit="l2.m/(N.T2)",
            displayUnit="K") = thermal.T);

      equation
        thermal.Qdot = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="thermal");
      end HeatRate;

      model Custom "Custom expressions"
        extends BaseClasses.PartialCondition(final conditionType=BaseClasses.ConditionType.Custom,
            y=thermal.Qdot);

        Real x=thermal.T "Expression to which the condition is applied"
          annotation (Dialog(group="Specification"));

      equation
        x = u_final;
        annotation (
          defaultComponentPrefixes="replaceable",
          defaultComponentName="thermal",
          Documentation(info="<html><p>The expression to which the condition is applied (<code>x</code>)
    must involve <code>face.T</code> and/or <code>face.Qdot</code>.</p></html>"));
      end Custom;

      package BaseClasses "Base classes (not generally for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialCondition "Partial model for a thermal condition"
          extends FCSys.Conditions.Inert.BaseClasses.PartialCondition;

          constant ConditionType conditionType "Type of condition";
          // Note:  This is included so that the type of condition is recorded with
          // the results.

          Connectors.ThermalDiffusion thermal "Connector to exchange heat"
            annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
          annotation (defaultComponentName="thermal", Diagram(graphics={Text(
                          extent={{-8,-32},{8,-36}},
                          lineColor={0,0,0},
                          fillColor={255,255,255},
                          fillPattern=FillPattern.Solid,
                          textString="thermal")}));

        end PartialCondition;

        type ConditionType = enumeration(
            Temperature "Specify temperature (measure heat flow rate)",
            HeatRate "Specify heat flow rate (measure temperature)",
            Custom "Custom expressions") "Types of conditions";

      end BaseClasses;

    end Thermal;

    package BaseClasses "Base classes (not generally for direct use)"
      extends Modelica.Icons.BasesPackage;
      partial model PartialCondition "Partial model of a condition"
        import FCSys.BaseClasses.Utilities.countTrue;
        extends FCSys.Conditions.BaseClasses.Icons.Single;

        parameter Boolean inclTransX=true "X" annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Axes with translational momentum included", compact=
                true));

        parameter Boolean inclTransY=false "Y" annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Axes with translational momentum included", compact=
                true));

        parameter Boolean inclTransZ=false "Z" annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Axes with translational momentum included", compact=
                true));

        parameter Boolean internal=true "Use internal specification"
          annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Specification"));

        replaceable Modelica.Blocks.Sources.Constant source if internal
          constrainedby Modelica.Blocks.Interfaces.SO
          "Source of internal specification" annotation (
          __Dymola_choicesFromPackage=true,
          Dialog(group="Specification",enable=internal),
          Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-70,30})));
        Connectors.RealInput u if not internal "Value of specified condition"
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-110,0})));

        Connectors.RealOutput y "Measurement expression" annotation (Dialog(
              group="Measurement"), Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={110,0}), iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={110,0})));

      protected
        final parameter Integer n_trans=countTrue({inclTransX,inclTransY,
            inclTransZ}) "Number of components of translational momentum";

        Connectors.RealOutputInternal u_final
          "Final value of specified condition" annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-20,0})));

      equation
        connect(source.y, u_final) annotation (Line(
            points={{-59,30},{-40,30},{-40,5.55112e-16},{-20,5.55112e-16}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(u, u_final) annotation (Line(
            points={{-110,5.55112e-16},{-88,0},{-66,1.11022e-15},{-66,
                5.55112e-16},{-20,5.55112e-16}},
            color={0,0,127},
            smooth=Smooth.None));

      end PartialCondition;

    end BaseClasses;

  end Inert;

  package InertDalton
    "<html>Conditions for a <a href=\"modelica://FCSys.Connectors.InertDalton\">InertDalton</a> connector</html>"
    extends Modelica.Icons.Package;

    model Species
      "<html>Condition for a <a href=\"modelica://FCSys.Connectors.InertDalton\">InertDalton</a> connector (e.g., as in a <a href=\"modelica://FCSys.Subregions.Species\">Species</a> model), with efforts by default</html>"
      import FCSys.BaseClasses.Utilities.countTrue;
      extends FCSys.Conditions.BaseClasses.Icons.Single;

      // Included components of translational momentum
      parameter Boolean inclTransX=true "X" annotation (
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(group="Axes with translational momentum included", compact=true));

      parameter Boolean inclTransY=false "Y" annotation (
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(group="Axes with translational momentum included", compact=true));

      parameter Boolean inclTransZ=false "Z" annotation (
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(group="Axes with translational momentum included", compact=true));

      // Conditions
      replaceable Dalton.Volume dalton(source(k(start=U.cc))) constrainedby
        Dalton.BaseClasses.PartialCondition(
        final inclTransX=inclTransX,
        final inclTransY=inclTransY,
        final inclTransZ=inclTransZ) "Dalton" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Conditions"),
        Placement(transformation(extent={{-74,20},{-54,40}})));
      replaceable Translational.Velocity translationalX(source(k(start=0))) if
        inclTransX constrainedby Translational.BaseClasses.PartialCondition(
        final inclTransX=inclTransX,
        final inclTransY=inclTransY,
        final inclTransZ=inclTransZ,
        final axis=Axis.x) "X-axis translational" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Conditions",enable=inclTransX),
        Placement(transformation(extent={{-42,8},{-22,28}})));
      replaceable Translational.Velocity translationalY(source(k(start=0))) if
        inclTransY constrainedby Translational.BaseClasses.PartialCondition(
        final inclTransX=inclTransX,
        final inclTransY=inclTransY,
        final inclTransZ=inclTransZ,
        final axis=Axis.y) "Y-axis translational" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Conditions",enable=inclTransY),
        Placement(transformation(extent={{-10,-4},{10,16}})));
      replaceable Translational.Velocity translationalZ(source(k(start=0))) if
        inclTransZ constrainedby Translational.BaseClasses.PartialCondition(
        final inclTransX=inclTransX,
        final inclTransY=inclTransY,
        final inclTransZ=inclTransZ,
        final axis=Axis.z) "Z-axis translational" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Conditions",enable=inclTransZ),
        Placement(transformation(extent={{22,-16},{42,4}})));
      replaceable Thermal.Temperature thermal(source(k(start=298.15*U.K)))
        constrainedby Thermal.BaseClasses.PartialCondition(
        final inclTransX=inclTransX,
        final inclTransY=inclTransY,
        final inclTransZ=inclTransZ) "Thermal" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Conditions"),
        Placement(transformation(extent={{54,-30},{74,-10}})));

      Connectors.RealInputBus u "Input bus for values of specified conditions"
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-110,0}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-110,0})));
      Connectors.RealOutputBus y "Output bus of measurements" annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={110,0}),iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={110,0})));

      Connectors.InertDalton inert(final n_trans=countTrue({inclTransX,
            inclTransY,inclTransZ}))
        "Single-species connector for translational momentum and heat, with additivity of pressure"
        annotation (Placement(transformation(extent={{-10,-50},{10,-30}}),
            iconTransformation(extent={{-10,-50},{10,-30}})));

    equation
      // Dalton
      connect(dalton.inert, inert) annotation (Line(
          points={{-64,26},{-64,-30},{5.55112e-16,-30},{5.55112e-16,-40}},
          color={11,43,197},
          smooth=Smooth.None));
      connect(u.dalton, dalton.u) annotation (Line(
          points={{-110,5.55112e-16},{-110,0},{-88,0},{-88,30},{-75,30}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-2,3},{-2,3}}));
      connect(dalton.y, y.dalton) annotation (Line(
          points={{-53,30},{90,30},{90,5.55112e-16},{110,5.55112e-16}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{2,3},{2,3}}));

      // X-axis translational
      connect(translationalX.inert, inert) annotation (Line(
          points={{-32,14},{-32,-30},{5.55112e-16,-30},{5.55112e-16,-40}},
          color={11,43,197},
          smooth=Smooth.None));
      connect(u.translationalX, translationalX.u) annotation (Line(
          points={{-110,5.55112e-16},{-110,0},{-88,0},{-88,18},{-43,18}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-2,3},{-2,3}}));
      connect(translationalX.y, y.translationalX) annotation (Line(
          points={{-21,18},{90,18},{90,5.55112e-16},{110,5.55112e-16}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{2,3},{2,3}}));

      // Y-axis translational
      connect(translationalY.inert, inert) annotation (Line(
          points={{6.10623e-16,2},{6.10623e-16,-30},{5.55112e-16,-30},{
              5.55112e-16,-40}},
          color={11,43,197},
          smooth=Smooth.None));

      connect(u.translationalY, translationalY.u) annotation (Line(
          points={{-110,5.55112e-16},{-110,0},{-88,0},{-88,6},{-11,6}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-2,3},{-2,3}}));
      connect(translationalY.y, y.translationalY) annotation (Line(
          points={{11,6},{90,6},{90,5.55112e-16},{110,5.55112e-16}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{2,3},{2,3}}));

      // Z-axis translational
      connect(translationalZ.inert, inert) annotation (Line(
          points={{32,-10},{32,-30},{5.55112e-16,-30},{5.55112e-16,-40}},
          color={11,43,197},
          smooth=Smooth.None));
      connect(u.translationalZ, translationalZ.u) annotation (Line(
          points={{-110,5.55112e-16},{-110,0},{-88,0},{-88,-6},{21,-6}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-2,3},{-2,3}}));
      connect(translationalZ.y, y.translationalZ) annotation (Line(
          points={{43,-6},{90,-6},{90,5.55112e-16},{110,5.55112e-16}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{2,3},{2,3}}));

      // Thermal
      connect(thermal.inert, inert) annotation (Line(
          points={{64,-24},{64,-30},{0,-30},{0,-40},{5.55112e-16,-40}},
          color={11,43,197},
          smooth=Smooth.None));
      connect(u.thermal, thermal.u) annotation (Line(
          points={{-110,5.55112e-16},{-110,0},{-88,0},{-88,-20},{53,-20}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-2,3},{-2,3}}));
      connect(thermal.y, y.thermal) annotation (Line(
          points={{75,-20},{90,-20},{90,5.55112e-16},{110,5.55112e-16}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{2,3},{2,3}}));
      annotation (Documentation(info="<html>
  <p>If the source of an internal specification is redeclared to a block besides
  <a href=\"modelica://Modelica.Blocks.Sources.Constant\">Modelica.Blocks.Sources.Constant</a>,
  then the related condition must be redeclared as well.  For example, use:<br>
  <code>redeclare Conditions.InertDalton.Dalton.Pressure dalton(redeclare Modelica.Blocks.Sources.Ramp source)</code><br>
  rather than simply:<br>
  <code>dalton(redeclare Modelica.Blocks.Sources.Ramp source)</code></p>
  </html>"));
    end Species;

    model SpeciesFlow
      "<html>Condition for a <a href=\"modelica://FCSys.Connectors.InertDalton\">InertDalton</a> connector (e.g., as in a <a href=\"modelica://FCSys.Subregions.Species\">Species</a> model), with flows by default</html>"

      extends Species(
        redeclare Dalton.Pressure dalton(source(k(start=-U.atm))),
        redeclare Translational.Force translationalX(source(k(start=0))),
        redeclare Translational.Force translationalY(source(k(start=0))),
        redeclare Translational.Force translationalZ(source(k(start=0))),
        redeclare Thermal.HeatRate thermal(source(k(start=0))));
      annotation (defaultComponentName="species",Documentation(info="<html>
<p>See the <a href=\"modelica://FCSys.Conditions.InertDalton.Species\">Species</a>
model.</p>
</html>"));

    end SpeciesFlow;

    package Dalton "Conditions for additivity of volume"
      extends Modelica.Icons.Package;

      model Volume "Specify volume (measure pressure)"
        extends BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.Volume,
          u(final unit="l3"),
          final y(final unit="m/(l.T2)") = inert.p);

      equation
        inert.V = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="dalton");
      end Volume;

      model Pressure "Specify pressure (measure volume)"
        extends BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.Pressure,
          u(final unit="m/(l.T2)"),
          final y(final unit="l3") = inert.V);

      equation
        inert.p = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="dalton");
      end Pressure;

      model Custom "Custom expressions"
        extends BaseClasses.PartialCondition(final conditionType=BaseClasses.ConditionType.Custom,
            y=inert.p);

        Real x=inert.V "Expression to which the condition is applied"
          annotation (Dialog(group="Specification"));

      equation
        x = u_final;
        annotation (
          defaultComponentPrefixes="replaceable",
          defaultComponentName="dalton",
          Documentation(info="<html><p>The expression to which the condition is applied (<code>x</code>)
    must involve <code>face.T</code> and/or <code>face.Qdot</code>.</p></html>"));
      end Custom;

      package BaseClasses "Base classes (not generally for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialCondition
          "Partial model of a volume/pressure condition"
          extends FCSys.Conditions.InertDalton.BaseClasses.PartialCondition;

          constant ConditionType conditionType "Type of condition";
          // Note:  This is included so that the type of condition is recorded with
          // the results.

        equation
          // Zero values of other flows
          inert.mPhidot = zeros(n_trans) "Force";
          inert.Qdot = 0 "Heat flow rate";
          annotation (defaultComponentName="volumeCondition");
        end PartialCondition;

        type ConditionType = enumeration(
            Volume "Specify volume (measure pressure)",
            Pressure "Specify pressure (measure volume)",
            Custom "Custom expressions") "Types of conditions";

      end BaseClasses;

    end Dalton;

    package Translational "Translational conditions"
      extends Modelica.Icons.Package;
      model Velocity "Specify velocity (measure force)"
        extends BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.Velocity,
          u(final unit="l/T"),
          final y(final unit="l.m/T2") = inert.mPhidot[transAxes[axis]]);

      equation
        inert.phi[transAxes[axis]] = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="translational");
      end Velocity;

      model Force "Specify force (measure velocity)"
        extends BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.Force,
          u(final unit="l.m/T2"),
          final y(final unit="l/T") = inert.phi[transAxes[axis]]);

      equation
        inert.mPhidot[transAxes[axis]] = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="translational");
      end Force;

      model Custom "Custom expressions"
        extends BaseClasses.PartialCondition(final conditionType=BaseClasses.ConditionType.Custom,
            y=inert.mPhidot[transAxes[axis]]);

        Real x=inert.phi[transAxes[axis]]
          "Expression to which the condition is applied"
          annotation (Dialog(group="Specification"));

      equation
        x = u_final;
        annotation (
          defaultComponentPrefixes="replaceable",
          defaultComponentName="translational",
          Documentation(info="<html><p>The expression to which the condition is applied (<code>x</code>)
    must involve <code>face.T</code> and/or <code>face.Qdot</code>.</p></html>"));
      end Custom;

      package BaseClasses "Base classes (not generally for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialCondition
          "Partial model for a translational condition"
          import FCSys.BaseClasses.Utilities.enumerate;
          import FCSys.BaseClasses.Utilities.index;
          extends FCSys.Conditions.InertDalton.BaseClasses.PartialCondition;

          parameter Axis axis=Axis.x "Axis" annotation (HideResult=true);

          constant ConditionType conditionType "Type of condition";
          // Note:  This is included so that the type of condition is recorded with
          // the results.

        protected
          final parameter Integer cartAxes[n_trans]=index({inclTransX,
              inclTransY,inclTransZ})
            "Cartesian-axis indices of the components of translational momentum";
          final parameter Integer transAxes[Axis]=enumerate({inclTransX,
              inclTransY,inclTransZ})
            "Translational-momentum-component indices of the Cartesian axes";

        equation
          // Zero values of other flows
          inert.p = 0 "Pressure";
          for i in 1:n_trans loop
            if cartAxes[i] <> axis then
              inert.mPhidot[i] = 0 "Force along the other axes";
            end if;
          end for;
          inert.Qdot = 0 "Heat flow rate";
          annotation (defaultComponentName="translationalCondition");
        end PartialCondition;

        type ConditionType = enumeration(
            Velocity "Specify velocity (measure force)",
            Force "Specify force (measure velocity)",
            Custom "Custom expressions") "Types of conditions";

      end BaseClasses;

    end Translational;

    package Thermal "Thermal conditions"
      extends Modelica.Icons.Package;

      model Temperature "Specify temperature (measure heat flow rate)"
        extends BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.Temperature,
          u(final unit="l2.m/(N.T2)", displayUnit="K"),
          source(k(start=298.15*U.K)),
          final y(final unit="l2.m/T3") = inert.Qdot);

      equation
        inert.T = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="thermal");
      end Temperature;

      model HeatRate "Specify heat flow rate (measure temperature)"
        extends BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.HeatRate,
          u(final unit="l2.m/T3"),
          final y(
            final unit="l2.m/(N.T2)",
            displayUnit="K") = inert.T);

      equation
        inert.Qdot = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="thermal");
      end HeatRate;

      model Custom "Custom expressions"
        extends BaseClasses.PartialCondition(final conditionType=BaseClasses.ConditionType.Custom,
            y=inert.Qdot);

        Real x=inert.T "Expression to which the condition is applied"
          annotation (Dialog(group="Specification"));

      equation
        x = u_final;
        annotation (
          defaultComponentPrefixes="replaceable",
          defaultComponentName="thermal",
          Documentation(info="<html><p>The expression to which the condition is applied (<code>x</code>)
    must involve <code>face.T</code> and/or <code>face.Qdot</code>.</p></html>"));
      end Custom;

      package BaseClasses "Base classes (not generally for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialCondition "Partial model for a thermal condition"
          extends FCSys.Conditions.InertDalton.BaseClasses.PartialCondition;

          constant ConditionType conditionType "Type of condition";
          // Note:  This is included so that the type of condition is recorded with
          // the results.

        equation
          // Zero values of other flows
          inert.p = 0 "Pressure";
          inert.mPhidot = zeros(n_trans) "Force";
          annotation (defaultComponentName="thermal");
        end PartialCondition;

        type ConditionType = enumeration(
            Temperature "Specify temperature (measure heat flow rate)",
            HeatRate "Specify heat flow rate (measure temperature)",
            Custom "Custom expressions") "Types of conditions";

      end BaseClasses;

    end Thermal;

    package BaseClasses "Base classes (not generally for direct use)"
      extends Modelica.Icons.BasesPackage;
      partial model PartialCondition "Partial model of a condition"
        import FCSys.BaseClasses.Utilities.countTrue;
        extends FCSys.Conditions.BaseClasses.Icons.Single;

        parameter Boolean inclTransX=true "X" annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Axes with translational momentum included", compact=
                true));

        parameter Boolean inclTransY=false "Y" annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Axes with translational momentum included", compact=
                true));

        parameter Boolean inclTransZ=false "Z" annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Axes with translational momentum included", compact=
                true));

        parameter Boolean internal=true "Use internal specification"
          annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Specification"));

        replaceable Modelica.Blocks.Sources.Constant source if internal
          constrainedby Modelica.Blocks.Interfaces.SO
          "Source of internal specification" annotation (
          __Dymola_choicesFromPackage=true,
          Dialog(group="Specification",enable=internal),
          Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-70,30})));
        Connectors.RealInput u if not internal "Value of specified condition"
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-110,0})));

        Connectors.RealOutput y "Measurement expression" annotation (Dialog(
              group="Measurement"), Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={110,0}), iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={110,0})));
        Connectors.InertDalton inert(final n_trans=n_trans)
          "Connector for translational momentum and heat, with additivity of pressure"
          annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

      protected
        final parameter Integer n_trans=countTrue({inclTransX,inclTransY,
            inclTransZ}) "Number of components of translational momentum";

        Connectors.RealOutputInternal u_final
          "Final value of specified condition" annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-20,0})));

      equation
        connect(source.y, u_final) annotation (Line(
            points={{-59,30},{-40,30},{-40,5.55112e-16},{-20,5.55112e-16}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(u, u_final) annotation (Line(
            points={{-110,5.55112e-16},{-88,0},{-66,1.11022e-15},{-66,
                5.55112e-16},{-20,5.55112e-16}},
            color={0,0,127},
            smooth=Smooth.None));

      end PartialCondition;

    end BaseClasses;

  end InertDalton;

  package FaceBus
    "<html>Conditions for a <a href=\"modelica://FCSys.Connectors.FaceBus\">FaceBus</a> connector (e.g., as in a <a href=\"modelica://FCSys.Regions.Region\">Region</a> or <a href=\"modelica://FCSys.Subregions.Subregion\">Subregion</a> model)</html>"

    extends Modelica.Icons.Package;

    model Subregion
      "<html>Conditions for a <a href=\"modelica://FCSys.Connectors.FaceBus\">FaceBus</a> connector, with efforts by default</html>"

      extends FCSys.Conditions.BaseClasses.Icons.Single;

      Phases.Gas gas "Gas" annotation (Dialog(group="Phases",
            __Dymola_descriptionLabel=true), Placement(transformation(extent={{
                -10,-10},{10,10}})));

      Phases.Graphite graphite "Graphite" annotation (Dialog(group="Phases",
            __Dymola_descriptionLabel=true), Placement(transformation(extent={{
                -10,-10},{10,10}})));

      Phases.Ionomer ionomer "Ionomer" annotation (Dialog(group="Phases",
            __Dymola_descriptionLabel=true), Placement(transformation(extent={{
                -10,-10},{10,10}})));

      Phases.Liquid liquid "Liquid" annotation (Dialog(group="Phases",
            __Dymola_descriptionLabel=true), Placement(transformation(extent={{
                -10,-10},{10,10}})));

      Connectors.FaceBus face
        "Connector for translational momentum and heat of multiple species"
        annotation (Placement(transformation(extent={{-10,-50},{10,-30}}),
            iconTransformation(extent={{-10,-50},{10,-30}})));
      Connectors.RealInputBus u "Bus of inputs to specify conditions"
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-110,0})));

      Connectors.RealOutputBus y "Output bus of measurements" annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={110,0})));

    equation
      // Gas
      connect(gas.face, face.gas) annotation (Line(
          points={{6.10623e-16,-4},{8.60423e-16,-40},{5.55112e-16,-40}},
          color={127,127,127},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None));

      connect(u.gas, gas.u) annotation (Line(
          points={{-110,5.55112e-16},{-10,5.55112e-16},{-10,6.10623e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect(gas.y, y.gas) annotation (Line(
          points={{10,6.10623e-16},{110,6.10623e-16},{110,5.55112e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

      // Graphite
      connect(graphite.face, face.graphite) annotation (Line(
          points={{6.10623e-16,-4},{8.60423e-16,-40},{5.55112e-16,-40}},
          color={127,127,127},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None));

      connect(u.graphite, graphite.u) annotation (Line(
          points={{-110,5.55112e-16},{-10,5.55112e-16},{-10,6.10623e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect(graphite.y, y.graphite) annotation (Line(
          points={{10,6.10623e-16},{110,6.10623e-16},{110,5.55112e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

      // Ionomer
      connect(ionomer.face, face.ionomer) annotation (Line(
          points={{6.10623e-16,-4},{-4.87687e-22,-4},{-4.87687e-22,-40},{
              5.55112e-16,-40}},
          color={127,127,127},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None));
      connect(u.ionomer, ionomer.u) annotation (Line(
          points={{-110,5.55112e-16},{-10,5.55112e-16},{-10,6.10623e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect(ionomer.y, y.ionomer) annotation (Line(
          points={{10,6.10623e-16},{110,6.10623e-16},{110,5.55112e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

      // Liquid
      connect(liquid.face, face.liquid) annotation (Line(
          points={{6.10623e-16,-4},{-4.87687e-22,-4},{-4.87687e-22,-40},{
              5.55112e-16,-40}},
          color={127,127,127},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None));
      connect(u.liquid, liquid.u) annotation (Line(
          points={{-110,5.55112e-16},{-10,5.55112e-16},{-10,6.10623e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect(liquid.y, y.liquid) annotation (Line(
          points={{10,6.10623e-16},{110,6.10623e-16},{110,5.55112e-16}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));
      annotation (Diagram(graphics));
    end Subregion;

    model SubregionFlows
      "<html>Conditions for a <a href=\"modelica://FCSys.Connectors.FaceBus\">FaceBus</a> connector, with flows by default</html>"

      extends FaceBus.Subregion(
        gas(
          H2(
            redeclare replaceable Face.Material.Current material(source(k(start
                    =0))),
            redeclare replaceable Face.Transverse.Force transverse1(source(k(
                    start=0))),
            redeclare replaceable Face.Transverse.Force transverse2(source(k(
                    start=0))),
            redeclare replaceable Face.Thermal.HeatRate thermal(source(k(start=
                      0)))),
          H2O(
            redeclare replaceable Face.Material.Current material(source(k(start
                    =0))),
            redeclare replaceable Face.Transverse.Force transverse1(source(k(
                    start=0))),
            redeclare replaceable Face.Transverse.Force transverse2(source(k(
                    start=0))),
            redeclare replaceable Face.Thermal.HeatRate thermal(source(k(start=
                      0)))),
          N2(
            redeclare replaceable Face.Material.Current material(source(k(start
                    =0))),
            redeclare replaceable Face.Transverse.Force transverse1(source(k(
                    start=0))),
            redeclare replaceable Face.Transverse.Force transverse2(source(k(
                    start=0))),
            redeclare replaceable Face.Thermal.HeatRate thermal(source(k(start=
                      0)))),
          O2(
            redeclare replaceable Face.Material.Current material(source(k(start
                    =0))),
            redeclare replaceable Face.Transverse.Force transverse1(source(k(
                    start=0))),
            redeclare replaceable Face.Transverse.Force transverse2(source(k(
                    start=0))),
            redeclare replaceable Face.Thermal.HeatRate thermal(source(k(start=
                      0))))),
        graphite('C+'(
            redeclare replaceable Face.Material.Current material(source(k(start
                    =0))),
            redeclare replaceable Face.Transverse.Force transverse1(source(k(
                    start=0))),
            redeclare replaceable Face.Transverse.Force transverse2(source(k(
                    start=0))),
            redeclare replaceable Face.Thermal.HeatRate thermal(source(k(start=
                      0)))), 'e-'(
            redeclare replaceable Face.Material.Current material(source(k(start
                    =0))),
            redeclare replaceable Face.Transverse.Force transverse1(source(k(
                    start=0))),
            redeclare replaceable Face.Transverse.Force transverse2(source(k(
                    start=0))),
            redeclare replaceable Face.Thermal.HeatRate thermal(source(k(start=
                      0))))),
        ionomer(
          'C19HF37O5S-'(
            redeclare replaceable Face.Material.Current material(source(k(start
                    =0))),
            redeclare replaceable Face.Transverse.Force transverse1(source(k(
                    start=0))),
            redeclare replaceable Face.Transverse.Force transverse2(source(k(
                    start=0))),
            redeclare replaceable Face.Thermal.HeatRate thermal(source(k(start=
                      0)))),
          'H+'(
            redeclare replaceable Face.Material.Current material(source(k(start
                    =0))),
            redeclare replaceable Face.Transverse.Force transverse1(source(k(
                    start=0))),
            redeclare replaceable Face.Transverse.Force transverse2(source(k(
                    start=0))),
            redeclare replaceable Face.Thermal.HeatRate thermal(source(k(start=
                      0)))),
          H2O(
            redeclare replaceable Face.Material.Current material(source(k(start
                    =0))),
            redeclare replaceable Face.Transverse.Force transverse1(source(k(
                    start=0))),
            redeclare replaceable Face.Transverse.Force transverse2(source(k(
                    start=0))),
            redeclare replaceable Face.Thermal.HeatRate thermal(source(k(start=
                      0))))),
        liquid(H2O(
            redeclare replaceable Face.Material.Current material(source(k(start
                    =0))),
            redeclare replaceable Face.Transverse.Force transverse1(source(k(
                    start=0))),
            redeclare replaceable Face.Transverse.Force transverse2(source(k(
                    start=0))),
            redeclare replaceable Face.Thermal.HeatRate thermal(source(k(start=
                      0))))));
      annotation (Documentation(info="<html>
  <p>If the source of an internal specification is redeclared to a block besides
  <a href=\"modelica://Modelica.Blocks.Sources.Constant\">Modelica.Blocks.Sources.Constant</a>,
  then the related condition must be redeclared as well.  For example, use:<br>
  <code>gas(H2O(redeclare Conditions.Face.Material.Current material(redeclare Modelica.Blocks.Sources.Ramp source)))</code><br>
  rather than simply:<br>
  <code>gas(H2O(material(redeclare Modelica.Blocks.Sources.Ramp source)))</code></p>
  </html>"), defaultComponentName="subregion");

    end SubregionFlows;

    package Phases
      "<html>Conditions for the <a href=\"modelica://FCSys.Connectors.FaceBus\">FaceBus</a> connector (e.g., as in a <a href=\"modelica://FCSys.Subregions.Phase\">Phase</a> model)</html>"
      extends Modelica.Icons.Package;

      model Gas "Condition for gas"

        extends BaseClasses.NullPhase;

        // Conditionally include species.
        parameter Boolean inclH2=false "<html>Hydrogen (H<sub>2</sub>)</html>"
          annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));

        Face.Species H2 if inclH2 "Conditions" annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclH2), Placement(transformation(extent={{-10,-10},{10,10}})));

        parameter Boolean inclH2O=false "<html>Water (H<sub>2</sub>O)</html>"
          annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));

        Face.Species H2O if inclH2O "Conditions" annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclH2O), Placement(transformation(extent={{-10,-10},{10,10}})));

        parameter Boolean inclN2=false "<html>Nitrogen (N<sub>2</sub>)</html>"
          annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));

        Face.Species N2 if inclN2 "Conditions" annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclN2), Placement(transformation(extent={{-10,-10},{10,10}})));

        parameter Boolean inclO2=false "<html>Oxygen (O<sub>2</sub>)</html>"
          annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));

        Face.Species O2 if inclO2 "Conditions" annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclO2), Placement(transformation(extent={{-10,-10},{10,10}})));

      equation
        // H2
        connect(H2.face, face.H2) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.H2, H2.u) annotation (Line(
            points={{-100,5.55112e-16},{-100,0},{-10,0},{-10,6.10623e-16}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));
        connect(H2.y, y.H2) annotation (Line(
            points={{10,6.10623e-16},{10,0},{100,0},{100,5.55112e-16}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        // H2O
        connect(H2O.face, face.H2O) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.H2O, H2O.u) annotation (Line(
            points={{-100,5.55112e-16},{-100,0},{-10,0},{-10,6.10623e-16}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));
        connect(H2O.y, y.H2O) annotation (Line(
            points={{10,6.10623e-16},{10,0},{100,0},{100,5.55112e-16}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        // N2
        connect(N2.face, face.N2) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.N2, N2.u) annotation (Line(
            points={{-100,5.55112e-16},{-100,0},{-10,0},{-10,6.10623e-16}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));
        connect(N2.y, y.N2) annotation (Line(
            points={{10,6.10623e-16},{10,0},{100,0},{100,5.55112e-16}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        // O2
        connect(O2.face, face.O2) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.O2, O2.u) annotation (Line(
            points={{-100,5.55112e-16},{-100,0},{-10,0},{-10,6.10623e-16}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));
        connect(O2.y, y.O2) annotation (Line(
            points={{10,6.10623e-16},{10,0},{100,0},{100,5.55112e-16}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));
        annotation (Diagram(graphics));
      end Gas;

      model Graphite "Condition for graphite"

        extends BaseClasses.NullPhase;

        // Conditionally include species.
        parameter Boolean 'inclC+'=false
          "<html>Carbon plus (C<sup>+</sup>)</html>" annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));

        Face.Species 'C+' if 'inclC+' "Conditions" annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable='inclC+'), Placement(transformation(extent={{-10,-10},{10,10}})));

        parameter Boolean 'incle-'=false
          "<html>Electrons (e<sup>-</sup>)</html>" annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));

        Face.Species 'e-' if 'incle-' "Conditions" annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable='incle-'), Placement(transformation(extent={{-10,-10},{10,10}})));

      equation
        // C+
        connect('C+'.face, face.'C+') annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.'C+', 'C+'.u) annotation (Line(
            points={{-100,5.55112e-16},{-100,0},{-10,0},{-10,6.10623e-16}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));
        connect('C+'.y, y.'C+') annotation (Line(
            points={{10,6.10623e-16},{10,0},{100,0},{100,5.55112e-16}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        // e-
        connect('e-'.face, face.'e-') annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.'e-', 'e-'.u) annotation (Line(
            points={{-100,5.55112e-16},{-100,0},{-10,0},{-10,6.10623e-16}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));
        connect('e-'.y, y.'e-') annotation (Line(
            points={{10,6.10623e-16},{10,0},{100,0},{100,5.55112e-16}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

      end Graphite;

      model Ionomer "Condition for ionomer"

        extends BaseClasses.NullPhase;

        // Conditionally include species.
        parameter Boolean 'inclC19HF37O5S-'=false
          "<html>Nafion sulfonate minus (C<sub>19</sub>HF<sub>37</sub>O<sub>5</sub>S<sup>-</sup>)</html>"
          annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));

        Face.Species 'C19HF37O5S-' if 'inclC19HF37O5S-' "Conditions"
          annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable='inclC19HF37O5S-'), Placement(transformation(extent={{-10,-10},
                  {10,10}})));

        parameter Boolean 'inclH+'=false "<html>Protons (H<sup>+</sup>)</html>"
          annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));

        Face.Species 'H+' if 'inclH+' "Conditions" annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable='inclH+'), Placement(transformation(extent={{-10,-10},{10,10}})));

        parameter Boolean inclH2O=false "<html>Water (H<sub>2</sub>O)</html>"
          annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));

        Face.Species H2O if inclH2O "Conditions" annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclH2O), Placement(transformation(extent={{-10,-10},{10,10}})));

      equation
        // C19HF37O5S-
        connect('C19HF37O5S-'.face, face.'C19HF37O5S-') annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.'C19HF37O5S-', 'C19HF37O5S-'.u) annotation (Line(
            points={{-100,5.55112e-16},{-100,0},{-10,0},{-10,6.10623e-16}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));
        connect('C19HF37O5S-'.y, y.'C19HF37O5S-') annotation (Line(
            points={{10,6.10623e-16},{10,0},{100,0},{100,5.55112e-16}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        // H+
        connect('H+'.face, face.'H+') annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.'H+', 'H+'.u) annotation (Line(
            points={{-100,5.55112e-16},{-100,0},{-10,0},{-10,6.10623e-16}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));
        connect('H+'.y, y.'H+') annotation (Line(
            points={{10,6.10623e-16},{10,0},{100,0},{100,5.55112e-16}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        // H2O
        connect(H2O.face, face.H2O) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.H2O, H2O.u) annotation (Line(
            points={{-100,5.55112e-16},{-100,0},{-10,0},{-10,6.10623e-16}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));
        connect(H2O.y, y.H2O) annotation (Line(
            points={{10,6.10623e-16},{10,0},{100,0},{100,5.55112e-16}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

      end Ionomer;

      model Liquid "Condition for liquid"

        extends BaseClasses.NullPhase;

        // Conditionally include species.
        parameter Boolean inclH2O=false "<html>Water (H<sub>2</sub>O)</html>"
          annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));

        Face.Species H2O if inclH2O "Conditions" annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclH2O), Placement(transformation(extent={{-10,-10},{10,10}})));

      equation
        // H2O
        connect(H2O.face, face.H2O) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.H2O, H2O.u) annotation (Line(
            points={{-100,5.55112e-16},{-100,0},{-10,0},{-10,6.10623e-16}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));
        connect(H2O.y, y.H2O) annotation (Line(
            points={{10,6.10623e-16},{10,0},{100,0},{100,5.55112e-16}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));
        annotation (Diagram(graphics));
      end Liquid;

      package BaseClasses "Base classes (not generally for direct use)"
        extends Modelica.Icons.BasesPackage;
        model NullPhase "Empty condition for a phase (no species)"
          extends FCSys.Conditions.BaseClasses.Icons.Single;

          Connectors.FaceBus face
            "Multi-species connector for translational momentum and heat"
            annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
          Connectors.RealInputBus u
            "Input bus for values of specified conditions" annotation (
              Placement(transformation(
                extent={{-10,-10},{10,10}},
                rotation=0,
                origin={-100,0}), iconTransformation(
                extent={{-10,-10},{10,10}},
                rotation=0,
                origin={-100,0})));

          Connectors.RealOutputBus y "Output bus of measurements" annotation (
              Placement(transformation(
                extent={{-10,-10},{10,10}},
                rotation=0,
                origin={100,0}),iconTransformation(
                extent={{-10,-10},{10,10}},
                rotation=0,
                origin={100,0})));

        end NullPhase;

      end BaseClasses;

    end Phases;

  end FaceBus;

  package Face
    "<html>Conditions for a <a href=\"modelica://FCSys.Connectors.Face\">Face</a> connector (e.g., as in a <a href=\"modelica://FCSys.Subregions.Species\">Species</a> model)</html>"
    model Species
      "<html>Conditions for a <a href=\"modelica://FCSys.Connectors.Face\">Face</a> connector</html>"

      extends FCSys.Conditions.BaseClasses.Icons.Single;

      replaceable Material.Pressure material(source(k(start=U.atm)))
        constrainedby Material.BaseClasses.PartialCondition "Material"
        annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Conditions"),
        Placement(transformation(extent={{-58,10},{-38,30}})));
      replaceable Transverse.Velocity transverse1(final orientation=Orientation.preceding,
          source(k(start=0))) constrainedby
        Transverse.BaseClasses.PartialCondition
        "<html>1<sup>st</sup> transverse</html>" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Conditions"),
        Placement(transformation(extent={{-26,-2},{-6,18}})));
      replaceable Transverse.Velocity transverse2(final orientation=Orientation.following,
          source(k(start=0))) constrainedby
        Transverse.BaseClasses.PartialCondition
        "<html>2<sup>nd</sup> transverse</html>" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Conditions"),
        Placement(transformation(extent={{6,-18},{26,2}})));
      replaceable Thermal.Temperature thermal(source(k(start=298.15*U.K)))
        constrainedby Thermal.BaseClasses.PartialCondition "Thermal"
        annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Conditions"),
        Placement(transformation(extent={{38,-30},{58,-10}})));
      // Note:  In Dymola 7.4, the value of k must be specified here instead
      // of at the lower level (e.g., Thermal.Temperature) so that the source
      // subcomponent can be replaced by blocks that don't contain the
      // parameter k.

      Connectors.Face face
        "Single-species connector for translational momentum and heat"
        annotation (Placement(transformation(extent={{-10,-50},{10,-30}}),
            iconTransformation(extent={{-10,-50},{10,-30}})));

      Connectors.RealInputBus u "Input bus for values of specified conditions"
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-100,0}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={-100,0})));

      Connectors.RealOutputBus y "Output bus of measurements" annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={100,0}),iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={100,0})));

    equation
      // Normal
      connect(material.face, face) annotation (Line(
          points={{-48,16},{-48,-30},{0,-30},{0,-40},{5.55112e-16,-40}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));
      connect(u.normal, material.u) annotation (Line(
          points={{-100,5.55112e-16},{-80,5.55112e-16},{-80,20},{-59,20}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(material.y, y.normal) annotation (Line(
          points={{-37,20},{80,20},{80,0},{100,0},{100,5.55112e-16}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));

      // 1st transverse
      connect(transverse1.face, face) annotation (Line(
          points={{-16,4},{-16,-30},{0,-30},{0,-40},{5.55112e-16,-40}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));
      connect(u.transverse1, transverse1.u) annotation (Line(
          points={{-100,5.55112e-16},{-80,5.55112e-16},{-80,8},{-27,8}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(transverse1.y, y.transverse1) annotation (Line(
          points={{-5,8},{80,8},{80,5.55112e-16},{100,5.55112e-16}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));

      // 2nd transverse
      connect(transverse2.face, face) annotation (Line(
          points={{16,-12},{16,-30},{0,-30},{0,-40},{5.55112e-16,-40}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));
      connect(u.transverse2, transverse2.u) annotation (Line(
          points={{-100,5.55112e-16},{-80,5.55112e-16},{-80,-8},{5,-8}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(transverse2.y, y.transverse2) annotation (Line(
          points={{27,-8},{80,-8},{80,0},{100,0},{100,5.55112e-16}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));

      // Thermal
      connect(thermal.face, face) annotation (Line(
          points={{48,-24},{48,-30},{0,-30},{0,-40},{5.55112e-16,-40}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));
      connect(u.thermal, thermal.u) annotation (Line(
          points={{-100,5.55112e-16},{-80,5.55112e-16},{-80,-20},{37,-20}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(thermal.y, y.thermal) annotation (Line(
          points={{59,-20},{80,-20},{80,0},{100,0},{100,5.55112e-16}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%second",
          index=1,
          extent={{6,3},{6,3}}));
      annotation (Documentation(info="<html>
  <p>If the source of an internal specification is redeclared to a block besides
  <a href=\"modelica://Modelica.Blocks.Sources.Constant\">Modelica.Blocks.Sources.Constant</a>,
  then the related condition must be redeclared as well.  For example, use:<br>
  <code>redeclare Conditions.Face.Material.Pressure material(redeclare Modelica.Blocks.Sources.Ramp source)</code><br>
  rather than simply:<br>
  <code>material(redeclare Modelica.Blocks.Sources.Ramp source)</code></p>
  </html>"));
    end Species;
    extends Modelica.Icons.Package;

    package Material "Material conditions"
      extends Modelica.Icons.Package;

      model Pressure "Specify pressure (measure current)"
        extends BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.Pressure,
          u(final unit="m/(l.T2)"),
          final y(final unit="N/T") = face.Ndot);

      equation
        face.p = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="normal");
      end Pressure;

      model Current "Specify current (measure pressure)"
        extends BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.Current,
          u(final unit="N/T"),
          final y(final unit="m/(l.T2)") = face.p);

      equation
        face.Ndot = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="normal");
      end Current;

      model Custom "Custom expressions"
        extends BaseClasses.PartialCondition(final conditionType=BaseClasses.ConditionType.Custom,
            y=face.Ndot);

        Real x=face.p "Expression to which the condition is applied"
          annotation (Dialog(group="Specification"));

      equation
        x = u_final;
        annotation (
          defaultComponentPrefixes="replaceable",
          defaultComponentName="normal",
          Documentation(info="<html><p>The expression to which the condition is applied (<code>x</code>)
    must involve <code>face.p</code> and/or <code>face.Ndot</code>.</p></html>"));
      end Custom;

      package BaseClasses "Base classes (not generally for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialCondition "Partial model for a normal condition"
          extends Face.BaseClasses.PartialCondition;

          constant ConditionType conditionType "Type of condition";
          // Note:  This is included so that the type of condition is recorded with
          // the results.

        equation
          // No flows of other quantities
          face.mPhidot = {0,0}
            "Translational momentum in transverse directions";
          face.Qdot = 0 "Heat";
          annotation (defaultComponentName="normal");
        end PartialCondition;

        type ConditionType = enumeration(
            Pressure "Specify pressure (measure current)",
            Current "Specify current (measure pressure)",
            Custom "Custom expressions") "Types of conditions";

      end BaseClasses;

    end Material;

    package Transverse "Transverse translational conditions"
      extends Modelica.Icons.Package;

      model Velocity "Specify velocity (measure shear force)"
        extends BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.Velocity,
          u(final unit="l/T"),
          final y(final unit="l.m/T2") = face.mPhidot[orientation]);

      equation
        face.phi[orientation] = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="transverse");
      end Velocity;

      model Force "Specify shear force (measure velocity)"
        extends BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.Force,
          u(final unit="l.m/T2"),
          final y(final unit="l/T") = face.phi[orientation]);

      equation
        face.mPhidot[orientation] = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="transverse");
      end Force;

      model Custom "Custom expressions"
        extends BaseClasses.PartialCondition(final conditionType=BaseClasses.ConditionType.Custom,
            y=face.mPhidot[orientation]);

        Real x=face.phi[orientation]
          "Expression to which the condition is applied"
          annotation (Dialog(group="Specification"));

      equation
        x = u_final;
        annotation (
          defaultComponentPrefixes="replaceable",
          defaultComponentName="normal",
          Documentation(info="<html><p>The expression to which the condition is applied (<code>x</code>)
    must involve <code>face.phi[orientation]</code> and/or <code>face.mPhidot[orientation]</code>.</p></html>"));
      end Custom;

      package BaseClasses "Base classes (not generally for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialCondition
          "Partial model for a transverse translational condition"
          import FCSys.BaseClasses.Utilities.mod1;
          extends Face.BaseClasses.PartialCondition;

          parameter Orientation orientation=Orientation.preceding
            "Orientation of translational momentum";

          constant ConditionType conditionType "Type of condition";
          // Note:  This is included so that the type of condition is recorded with
          // the results.

        equation
          // No flows of other quantities
          face.Ndot = 0 "Material";
          face.mPhidot[mod1(orientation + 1, 2)] = 0
            "Translational momentum in the other transverse direction";
          face.Qdot = 0 "Heat";
          annotation (defaultComponentName="transverse");
        end PartialCondition;

        type ConditionType = enumeration(
            Velocity "Specify velocity (measure shear force)",
            Force "Specify shear force (measure velocity)",
            Custom "Custom expressions") "Types of conditions";

      end BaseClasses;

    end Transverse;

    package Thermal "Thermal conditions"
      extends Modelica.Icons.Package;

      model Temperature "Specify temperature (measure heat flow rate)"
        extends Thermal.BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.Temperature,
          u(final unit="l2.m/(N.T2)", displayUnit="K"),
          final y(unit="l2.m/T3") = face.Qdot);

      equation
        face.T = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="thermal");
      end Temperature;

      model HeatRate "Specify heat flow rate (measure temperature)"
        extends Thermal.BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.HeatRate,
          u(final unit="l2.m/T3"),
          final y(
            final unit="l2.m/(N.T2)",
            displayUnit="K") = face.T);

      equation
        face.Qdot = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="thermal");
      end HeatRate;

      model Custom "Custom expressions"
        extends BaseClasses.PartialCondition(final conditionType=BaseClasses.ConditionType.Custom,
            y=face.Qdot);

        Real x=face.T "Expression to which the condition is applied"
          annotation (Dialog(group="Specification"));

      equation
        x = u_final;
        annotation (
          defaultComponentPrefixes="replaceable",
          defaultComponentName="thermal",
          Documentation(info="<html><p>The expression to which the condition is applied (<code>x</code>)
    must involve <code>face.T</code> and/or <code>face.Qdot</code>.</p></html>"));
      end Custom;

      package BaseClasses "Base classes (not generally for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialCondition "Partial model for a thermal condition"
          extends Face.BaseClasses.PartialCondition;

          constant ConditionType conditionType "Type of condition";
          // Note:  This is included so that the type of condition is recorded with
          // the results.

        equation
          // No flows of other quantities
          face.Ndot = 0 "Material";
          face.mPhidot = {0,0}
            "Translational momentum in transverse directions";
          annotation (defaultComponentName="thermal");
        end PartialCondition;

        type ConditionType = enumeration(
            Temperature "Specify temperature (measure heat flow rate)",
            HeatRate "Specify heat flow rate (measure temperature)",
            Custom "Custom expressions") "Types of conditions";

      end BaseClasses;

    end Thermal;

    package BaseClasses "Base classes (not generally for direct use)"
      extends Modelica.Icons.BasesPackage;

      partial model PartialCondition
        "Partial model to specify and measure conditions on a connector"
        extends FCSys.Conditions.BaseClasses.Icons.Single;

        parameter Boolean internal=true "Use internal specification"
          annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Specification"));

        replaceable Modelica.Blocks.Sources.Constant source if internal
          constrainedby Modelica.Blocks.Interfaces.SO
          "Source of internal specification" annotation (
          __Dymola_choicesFromPackage=true,
          Dialog(group="Specification",enable=internal),
          Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-70,30})));

        Connectors.RealInput u if not internal "Value of specified condition"
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-110,0})));

        Connectors.RealOutput y "Measurement expression" annotation (Dialog(
              group="Measurement"), Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={110,0}), iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={110,0})));

        Connectors.Face face
          "Connector to transport translational momentum and heat of a single species"
          annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

      protected
        Connectors.RealOutputInternal u_final
          "Final value of specified condition" annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-20,0})));

      equation
        connect(u, u_final) annotation (Line(
            points={{-110,5.55112e-16},{-62,-4.87687e-22},{-62,5.55112e-16},{-20,
                5.55112e-16}},
            color={0,0,127},
            smooth=Smooth.None));

        connect(source.y, u_final) annotation (Line(
            points={{-59,30},{-40,30},{-40,5.55112e-16},{-20,5.55112e-16}},
            color={0,0,127},
            smooth=Smooth.None));
        annotation (Icon(graphics));
      end PartialCondition;

    end BaseClasses;

  end Face;

  package FaceBusPair
    "<html>Conditions for a <a href=\"modelica://FCSys.Connectors.FaceBus\">FaceBus</a> connector (e.g., as in a <a href=\"modelica://FCSys.Regions.Region\">Region</a> or <a href=\"modelica://FCSys.Subregions.Subregion\">Subregion</a> model)</html>"

    extends Modelica.Icons.Package;

    model Subregion
      "<html>Conditions for a pair of <a href=\"modelica://FCSys.Connectors.FaceBus\">FaceBus</a> connectors, with efforts by default</html>"

      extends FCSys.Conditions.BaseClasses.Icons.Single;

      Phases.Gas gas "Gas" annotation (Dialog(group="Phases",
            __Dymola_descriptionLabel=true), Placement(transformation(extent={{
                -10,-10},{10,10}})));

      Phases.Graphite graphite "Graphite" annotation (Dialog(group="Phases",
            __Dymola_descriptionLabel=true), Placement(transformation(extent={{
                -10,-10},{10,10}})));

      Phases.Ionomer ionomer "Ionomer" annotation (Dialog(group="Phases",
            __Dymola_descriptionLabel=true), Placement(transformation(extent={{
                -10,-10},{10,10}})));

      Phases.Liquid liquid "Liquid" annotation (Dialog(group="Phases",
            __Dymola_descriptionLabel=true), Placement(transformation(extent={{
                -10,-10},{10,10}})));

      Connectors.FaceBus negative
        "Negative-side multi-species connector for translational momentum and heat"
        annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
            iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-100,0})));
      Connectors.FaceBus positive
        "Positive-side multi-species connector for translational momentum and heat"
        annotation (Placement(transformation(extent={{90,-10},{110,10}}),
            iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=90,
            origin={100,0})));
      Connectors.RealInputBus u "Bus of inputs to specify conditions"
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,50}), iconTransformation(
            extent={{-10,-10},{10,10}},
            origin={0,50},
            rotation=270)));

      Connectors.RealOutputBus y "Output bus of measurements" annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,-50}), iconTransformation(
            extent={{-10,-10},{10,10}},
            origin={0,-50},
            rotation=270)));

    equation
      // Gas
      connect(gas.negative, negative.gas) annotation (Line(
          points={{-10,6.10623e-16},{-100,5.55112e-16}},
          color={127,127,127},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None));
      connect(gas.positive, positive.gas) annotation (Line(
          points={{10,6.10623e-16},{100,5.55112e-16}},
          color={127,127,127},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None));
      connect(u.gas, gas.u) annotation (Line(
          points={{5.55112e-16,50},{6.10623e-16,5}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect(gas.y, y.gas) annotation (Line(
          points={{6.10623e-16,-5},{5.55112e-16,-5},{5.55112e-16,-50}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

      // Graphite
      connect(graphite.negative, negative.graphite) annotation (Line(
          points={{-10,6.10623e-16},{-100,5.55112e-16}},
          color={127,127,127},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None));
      connect(graphite.positive, positive.graphite) annotation (Line(
          points={{10,6.10623e-16},{100,5.55112e-16}},
          color={127,127,127},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None));
      connect(u.graphite, graphite.u) annotation (Line(
          points={{5.55112e-16,50},{6.10623e-16,5}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect(graphite.y, y.graphite) annotation (Line(
          points={{6.10623e-16,-5},{5.55112e-16,-5},{5.55112e-16,-50}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

      // Ionomer
      connect(ionomer.negative, negative.ionomer) annotation (Line(
          points={{-10,6.10623e-16},{-100,5.55112e-16}},
          color={127,127,127},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None));
      connect(ionomer.positive, positive.ionomer) annotation (Line(
          points={{10,6.10623e-16},{100,5.55112e-16}},
          color={127,127,127},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None));
      connect(u.ionomer, ionomer.u) annotation (Line(
          points={{5.55112e-16,50},{6.10623e-16,5}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect(ionomer.y, y.ionomer) annotation (Line(
          points={{6.10623e-16,-5},{5.55112e-16,-5},{5.55112e-16,-50}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

      // Liquid
      connect(liquid.negative, negative.liquid) annotation (Line(
          points={{-10,6.10623e-16},{-100,5.55112e-16}},
          color={127,127,127},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None));
      connect(liquid.positive, positive.liquid) annotation (Line(
          points={{10,6.10623e-16},{100,5.55112e-16}},
          color={127,127,127},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None));
      connect(u.liquid, liquid.u) annotation (Line(
          points={{5.55112e-16,50},{6.10623e-16,5}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect(liquid.y, y.liquid) annotation (Line(
          points={{6.10623e-16,-5},{5.55112e-16,-5},{5.55112e-16,-50}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));
      annotation (Icon(graphics));
    end Subregion;

    model SubregionFlow
      "<html>Conditions for a pair of <a href=\"modelica://FCSys.Connectors.FaceBus\">FaceBus</a> connectors, with flows by default</html>"

      extends Subregion(
        gas(
          H2(
            redeclare replaceable FacePair.Material.Current material(source(k(
                    start=0))),
            redeclare replaceable FacePair.Transverse.Force transverse1(source(
                  k(start=0))),
            redeclare replaceable FacePair.Transverse.Force transverse2(source(
                  k(start=0))),
            redeclare replaceable FacePair.Thermal.HeatRate thermal(source(k(
                    start=0)))),
          H2O(
            redeclare replaceable FacePair.Material.Current material(source(k(
                    start=0))),
            redeclare replaceable FacePair.Transverse.Force transverse1(source(
                  k(start=0))),
            redeclare replaceable FacePair.Transverse.Force transverse2(source(
                  k(start=0))),
            redeclare replaceable FacePair.Thermal.HeatRate thermal(source(k(
                    start=0)))),
          N2(
            redeclare replaceable FacePair.Material.Current material(source(k(
                    start=0))),
            redeclare replaceable FacePair.Transverse.Force transverse1(source(
                  k(start=0))),
            redeclare replaceable FacePair.Transverse.Force transverse2(source(
                  k(start=0))),
            redeclare replaceable FacePair.Thermal.HeatRate thermal(source(k(
                    start=0)))),
          O2(
            redeclare replaceable FacePair.Material.Current material(source(k(
                    start=0))),
            redeclare replaceable FacePair.Transverse.Force transverse1(source(
                  k(start=0))),
            redeclare replaceable FacePair.Transverse.Force transverse2(source(
                  k(start=0))),
            redeclare replaceable FacePair.Thermal.HeatRate thermal(source(k(
                    start=0))))),
        graphite('C+'(
            redeclare replaceable FacePair.Material.Current material(source(k(
                    start=0))),
            redeclare replaceable FacePair.Transverse.Force transverse1(source(
                  k(start=0))),
            redeclare replaceable FacePair.Transverse.Force transverse2(source(
                  k(start=0))),
            redeclare replaceable FacePair.Thermal.HeatRate thermal(source(k(
                    start=0)))), 'e-'(
            redeclare replaceable FacePair.Material.Current material(source(k(
                    start=0))),
            redeclare replaceable FacePair.Transverse.Force transverse1(source(
                  k(start=0))),
            redeclare replaceable FacePair.Transverse.Force transverse2(source(
                  k(start=0))),
            redeclare replaceable FacePair.Thermal.HeatRate thermal(source(k(
                    start=0))))),
        ionomer(
          'C19HF37O5S-'(
            redeclare replaceable FacePair.Material.Current material(source(k(
                    start=0))),
            redeclare replaceable FacePair.Transverse.Force transverse1(source(
                  k(start=0))),
            redeclare replaceable FacePair.Transverse.Force transverse2(source(
                  k(start=0))),
            redeclare replaceable FacePair.Thermal.HeatRate thermal(source(k(
                    start=0)))),
          'H+'(
            redeclare replaceable FacePair.Material.Current material(source(k(
                    start=0))),
            redeclare replaceable FacePair.Transverse.Force transverse1(source(
                  k(start=0))),
            redeclare replaceable FacePair.Transverse.Force transverse2(source(
                  k(start=0))),
            redeclare replaceable FacePair.Thermal.HeatRate thermal(source(k(
                    start=0)))),
          H2O(
            redeclare replaceable FacePair.Material.Current material(source(k(
                    start=0))),
            redeclare replaceable FacePair.Transverse.Force transverse1(source(
                  k(start=0))),
            redeclare replaceable FacePair.Transverse.Force transverse2(source(
                  k(start=0))),
            redeclare replaceable FacePair.Thermal.HeatRate thermal(source(k(
                    start=0))))),
        liquid(H2O(
            redeclare replaceable FacePair.Material.Current material(source(k(
                    start=0))),
            redeclare replaceable FacePair.Transverse.Force transverse1(source(
                  k(start=0))),
            redeclare replaceable FacePair.Transverse.Force transverse2(source(
                  k(start=0))),
            redeclare replaceable FacePair.Thermal.HeatRate thermal(source(k(
                    start=0))))));
      annotation (defaultComponentName="subregion");

    end SubregionFlow;

    package Phases
      "<html>Conditions for the <a href=\"modelica://FCSys.Connectors.FaceBus\">FaceBus</a> connector (e.g., as in a <a href=\"modelica://FCSys.Subregions.Phase\">Phase</a> model)</html>"
      extends Modelica.Icons.Package;

      model Gas "Condition for gas"

        extends BaseClasses.NullPhase;

        // Conditionally include species.
        parameter Boolean inclH2=false "<html>Hydrogen (H<sub>2</sub>)</html>"
          annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));

        FacePair.Species H2 if inclH2 "Conditions" annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclH2), Placement(transformation(extent={{-10,-10},{10,10}})));

        parameter Boolean inclH2O=false "<html>Water (H<sub>2</sub>O)</html>"
          annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));

        FacePair.Species H2O if inclH2O "Conditions" annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclH2O), Placement(transformation(extent={{-10,-10},{10,10}})));

        parameter Boolean inclN2=false "<html>Nitrogen (N<sub>2</sub>)</html>"
          annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));

        FacePair.Species N2 if inclN2 "Conditions" annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclN2), Placement(transformation(extent={{-10,-10},{10,10}})));

        parameter Boolean inclO2=false "<html>Oxygen (O<sub>2</sub>)</html>"
          annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));

        FacePair.Species O2 if inclO2 "Conditions" annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclO2), Placement(transformation(extent={{-10,-10},{10,10}})));

      equation
        // H2
        connect(H2.negative, negative.H2) annotation (Line(
            points={{-10,6.10623e-16},{-10,5.55112e-16},{-100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(H2.positive, positive.H2) annotation (Line(
            points={{10,6.10623e-16},{10,5.55112e-16},{100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.H2, H2.u) annotation (Line(
            points={{5.55112e-16,50},{6.10623e-16,5}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        connect(H2.y, y.H2) annotation (Line(
            points={{6.10623e-16,-5},{-4.87687e-22,-50},{-4.87687e-22,-50},{
                5.55112e-16,-50}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        // H2O
        connect(H2O.negative, negative.H2O) annotation (Line(
            points={{-10,6.10623e-16},{-10,5.55112e-16},{-100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(H2O.positive, positive.H2O) annotation (Line(
            points={{10,6.10623e-16},{10,5.55112e-16},{100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.H2O, H2O.u) annotation (Line(
            points={{5.55112e-16,50},{6.10623e-16,5}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        connect(H2O.y, y.H2O) annotation (Line(
            points={{6.10623e-16,-5},{-4.87687e-22,-50},{-4.87687e-22,-50},{
                5.55112e-16,-50}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        // N2
        connect(N2.negative, negative.N2) annotation (Line(
            points={{-10,6.10623e-16},{-10,5.55112e-16},{-100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(N2.positive, positive.N2) annotation (Line(
            points={{10,6.10623e-16},{10,5.55112e-16},{100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.N2, N2.u) annotation (Line(
            points={{5.55112e-16,50},{6.10623e-16,5}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        connect(N2.y, y.N2) annotation (Line(
            points={{6.10623e-16,-5},{-4.87687e-22,-50},{-4.87687e-22,-50},{
                5.55112e-16,-50}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        // O2
        connect(O2.negative, negative.O2) annotation (Line(
            points={{-10,6.10623e-16},{-10,5.55112e-16},{-100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(O2.positive, positive.O2) annotation (Line(
            points={{10,6.10623e-16},{10,5.55112e-16},{100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.O2, O2.u) annotation (Line(
            points={{5.55112e-16,50},{6.10623e-16,5}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        connect(O2.y, y.O2) annotation (Line(
            points={{6.10623e-16,-5},{5.55112e-16,-50}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));
        annotation (Diagram(graphics));
      end Gas;

      model Graphite "Condition for graphite"

        extends BaseClasses.NullPhase;

        // Conditionally include species.
        parameter Boolean 'inclC+'=false
          "<html>Carbon plus (C<sup>+</sup>)</html>" annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));

        FacePair.Species 'C+' if 'inclC+' "Conditions" annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable='inclC+'), Placement(transformation(extent={{-10,-10},{10,10}})));

        parameter Boolean 'incle-'=false
          "<html>Electrons (e<sup>-</sup>)</html>" annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));

        FacePair.Species 'e-' if 'incle-' "Conditions" annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable='incle-'), Placement(transformation(extent={{-10,-10},{10,10}})));

      equation
        // C+
        connect('C+'.negative, negative.'C+') annotation (Line(
            points={{-10,6.10623e-16},{-10,5.55112e-16},{-100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect('C+'.positive, positive.'C+') annotation (Line(
            points={{10,6.10623e-16},{10,5.55112e-16},{100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.'C+', 'C+'.u) annotation (Line(
            points={{5.55112e-16,50},{6.10623e-16,5}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        connect('C+'.y, y.'C+') annotation (Line(
            points={{6.10623e-16,-5},{-4.87687e-22,-50},{-4.87687e-22,-50},{
                5.55112e-16,-50}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        // e-
        connect('e-'.negative, negative.'e-') annotation (Line(
            points={{-10,6.10623e-16},{-10,5.55112e-16},{-100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect('e-'.positive, positive.'e-') annotation (Line(
            points={{10,6.10623e-16},{10,5.55112e-16},{100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.'e-', 'e-'.u) annotation (Line(
            points={{5.55112e-16,50},{6.10623e-16,5}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        connect('e-'.y, y.'e-') annotation (Line(
            points={{6.10623e-16,-5},{-4.87687e-22,-50},{-4.87687e-22,-50},{
                5.55112e-16,-50}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

      end Graphite;

      model Ionomer "Condition for ionomer"

        extends BaseClasses.NullPhase;

        // Conditionally include species.
        parameter Boolean 'inclC19HF37O5S-'=false
          "<html>Nafion sulfonate minus (C<sub>19</sub>HF<sub>37</sub>O<sub>5</sub>S<sup>-</sup>)</html>"
          annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));

        FacePair.Species 'C19HF37O5S-' if 'inclC19HF37O5S-' "Conditions"
          annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable='inclC19HF37O5S-'), Placement(transformation(extent={{-10,-10},
                  {10,10}})));

        parameter Boolean 'inclH+'=false "<html>Protons (H<sup>+</sup>)</html>"
          annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));

        FacePair.Species 'H+' if 'inclH+' "Conditions" annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable='inclH+'), Placement(transformation(extent={{-10,-10},{10,10}})));

        parameter Boolean inclH2O=false "<html>Water (H<sub>2</sub>O)</html>"
          annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));

        FacePair.Species H2O if inclH2O "Conditions" annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclH2O), Placement(transformation(extent={{-10,-10},{10,10}})));

      equation
        // C19HF37O5S-
        connect('C19HF37O5S-'.negative, negative.'C19HF37O5S-') annotation (
            Line(
            points={{-10,6.10623e-16},{-10,5.55112e-16},{-100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect('C19HF37O5S-'.positive, positive.'C19HF37O5S-') annotation (
            Line(
            points={{10,6.10623e-16},{10,5.55112e-16},{100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.'C19HF37O5S-', 'C19HF37O5S-'.u) annotation (Line(
            points={{5.55112e-16,50},{6.10623e-16,5}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        connect('C19HF37O5S-'.y, y.'C19HF37O5S-') annotation (Line(
            points={{6.10623e-16,-5},{5.55112e-16,-50}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        // H+
        connect('H+'.negative, negative.'H+') annotation (Line(
            points={{-10,6.10623e-16},{-10,5.55112e-16},{-100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect('H+'.positive, positive.'H+') annotation (Line(
            points={{10,6.10623e-16},{10,5.55112e-16},{100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.'H+', 'H+'.u) annotation (Line(
            points={{5.55112e-16,50},{6.10623e-16,5}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        connect('H+'.y, y.'H+') annotation (Line(
            points={{6.10623e-16,-5},{5.55112e-16,-50}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        // H2O
        connect(H2O.negative, negative.H2O) annotation (Line(
            points={{-10,6.10623e-16},{-10,5.55112e-16},{-100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(H2O.positive, positive.H2O) annotation (Line(
            points={{10,6.10623e-16},{10,5.55112e-16},{100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.H2O, H2O.u) annotation (Line(
            points={{5.55112e-16,50},{6.10623e-16,5}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        connect(H2O.y, y.H2O) annotation (Line(
            points={{6.10623e-16,-5},{5.55112e-16,-50}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

      end Ionomer;

      model Liquid "Condition for liquid"

        extends BaseClasses.NullPhase;

        // Conditionally include species.
        parameter Boolean inclH2O=false "<html>Water (H<sub>2</sub>O)</html>"
          annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));

        FacePair.Species H2O if inclH2O "Conditions" annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclH2O), Placement(transformation(extent={{-10,-10},{10,10}})));

      equation
        // H2O
        connect(H2O.negative, negative.H2O) annotation (Line(
            points={{-10,6.10623e-16},{-10,5.55112e-16},{-100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(H2O.positive, positive.H2O) annotation (Line(
            points={{10,6.10623e-16},{10,5.55112e-16},{100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.H2O, H2O.u) annotation (Line(
            points={{5.55112e-16,50},{5.55112e-16,4},{6.10623e-16,4},{
                6.10623e-16,5}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));
        connect(H2O.y, y.H2O) annotation (Line(
            points={{6.10623e-16,-5},{6.10623e-16,-4},{5.55112e-16,-4},{
                5.55112e-16,-50}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

      end Liquid;

      package BaseClasses "Base classes (not generally for direct use)"
        extends Modelica.Icons.BasesPackage;
        model NullPhase "Empty condition for a phase (no species)"
          extends FCSys.Conditions.BaseClasses.Icons.Double;

          Connectors.FaceBus negative
            "Negative-side multi-species connector for translational momentum and heat"
            annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
                iconTransformation(extent={{-110,-10},{-90,10}})));
          Connectors.FaceBus positive
            "Positive-side multi-species connector for translational momentum and heat"
            annotation (Placement(transformation(extent={{90,-10},{110,10}}),
                iconTransformation(extent={{90,-10},{110,10}})));
          Connectors.RealInputBus u
            "Input bus for values of specified conditions" annotation (
              Placement(transformation(
                extent={{-10,-10},{10,10}},
                rotation=270,
                origin={0,50}), iconTransformation(
                extent={{-10,-10},{10,10}},
                rotation=270,
                origin={0,50})));

          Connectors.RealOutputBus y "Output bus of measurements" annotation (
              Placement(transformation(
                extent={{-10,-10},{10,10}},
                rotation=270,
                origin={0,-50}),iconTransformation(
                extent={{-10,-10},{10,10}},
                rotation=270,
                origin={0,-50})));
          annotation (Icon(graphics));

        end NullPhase;

      end BaseClasses;

    end Phases;

  end FaceBusPair;

  package FacePair
    "<html>Conditions for a pair of <a href=\"modelica://FCSys.Connectors.Face\">Face</a> connectors (e.g., as in a <a href=\"modelica://FCSys.Subregions.Species\">Species</a> model)</html>"
    extends Modelica.Icons.Package;
    model Species
      "<html>Conditions for a pair of <a href=\"modelica://FCSys.Connectors.Face\">Face</a> connectors</html>"

      extends FCSys.Conditions.BaseClasses.Icons.Double;

      replaceable Material.Pressure material(source(k(start=U.atm)))
        constrainedby Normal.BaseClasses.PartialCondition "Material"
        annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Conditions"),
        Placement(transformation(extent={{-58,10},{-38,30}})));
      replaceable Transverse.Velocity transverse1(final orientation=Orientation.preceding,
          source(k(start=0))) constrainedby
        Transverse.BaseClasses.PartialCondition
        "<html>1<sup>st</sup> transverse</html>" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Conditions"),
        Placement(transformation(extent={{-26,-2},{-6,18}})));
      replaceable Transverse.Velocity transverse2(final orientation=Orientation.following,
          source(k(start=0))) constrainedby
        Transverse.BaseClasses.PartialCondition
        "<html>2<sup>nd</sup> transverse</html>" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Conditions"),
        Placement(transformation(extent={{6,-18},{26,2}})));
      replaceable Thermal.Temperature thermal(source(k(start=298.15*U.K)))
        constrainedby Thermal.BaseClasses.PartialCondition "Thermal"
        annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Conditions"),
        Placement(transformation(extent={{38,-30},{58,-10}})));
      // Note:  In Dymola 7.4, the value of k must be specified here instead
      // of at the lower level (e.g., Thermal.Temperature) so that the source
      // subcomponent can be replaced by blocks that don't contain the
      // parameter k.

      Connectors.Face negative
        "Negative-side single-species connector for translational momentum and heat"
        annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
            iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=180,
            origin={-100,0})));

      Connectors.Face positive
        "Positive-side single-species connector for translational momentum and heat"
        annotation (Placement(transformation(extent={{90,-10},{110,10}}),
            iconTransformation(extent={{90,-10},{110,10}})));

      Connectors.RealInputBus u "Input bus for values of specified conditions"
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,50}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,50})));

      Connectors.RealOutputBus y "Output bus of measurements" annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,-50}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,-50})));

    equation
      // Normal
      connect(negative, normal.negative) annotation (Line(
          points={{-100,5.55112e-16},{-80,5.55112e-16},{-80,20},{-58,20}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));
      connect(normal.positive, positive) annotation (Line(
          points={{-38,20},{80,20},{80,5.55112e-16},{100,5.55112e-16}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));
      connect(u.normal, normal.u) annotation (Line(
          points={{5.55112e-16,50},{5.55112e-16,30},{-48,30},{-48,25}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,3},{-5,3}}));
      connect(normal.y, y.normal) annotation (Line(
          points={{-48,15},{-48,-30},{5.55112e-16,-30},{5.55112e-16,-50}},
          color={0,0,127},
          smooth=Smooth.None));

      // 1st transverse
      connect(negative, transverse1.negative) annotation (Line(
          points={{-100,5.55112e-16},{-80,5.55112e-16},{-80,8},{-26,8}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));
      connect(transverse1.positive, positive) annotation (Line(
          points={{-6,8},{80,8},{80,5.55112e-16},{100,5.55112e-16}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));
      connect(u.transverse1, transverse1.u) annotation (Line(
          points={{5.55112e-16,50},{5.55112e-16,30},{-16,30},{-16,13}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,3},{-5,3}}));
      connect(transverse1.y, y.transverse1) annotation (Line(
          points={{-16,3},{-16,-30},{5.55112e-16,-30},{5.55112e-16,-50}},
          color={0,0,127},
          smooth=Smooth.None));

      // 2nd transverse
      connect(negative, transverse2.negative) annotation (Line(
          points={{-100,5.55112e-16},{-80,5.55112e-16},{-80,-8},{6,-8}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));
      connect(transverse2.positive, positive) annotation (Line(
          points={{26,-8},{80,-8},{80,0},{100,0},{100,5.55112e-16}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));
      connect(u.transverse2, transverse2.u) annotation (Line(
          points={{5.55112e-16,50},{5.55112e-16,30},{16,30},{16,-3}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,3},{-5,3}}));
      connect(transverse2.y, y.transverse2) annotation (Line(
          points={{16,-13},{16,-30},{5.55112e-16,-30},{5.55112e-16,-50}},
          color={0,0,127},
          smooth=Smooth.None));

      // Thermal
      connect(negative, thermal.negative) annotation (Line(
          points={{-100,5.55112e-16},{-80,5.55112e-16},{-80,-20},{38,-20}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));
      connect(thermal.positive, positive) annotation (Line(
          points={{58,-20},{80,-20},{80,0},{100,0},{100,5.55112e-16}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));
      connect(u.thermal, thermal.u) annotation (Line(
          points={{5.55112e-16,50},{5.55112e-16,30},{48,30},{48,-15}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-5,3},{-5,3}}));
      connect(thermal.y, y.thermal) annotation (Line(
          points={{48,-25},{48,-30},{5.55112e-16,-30},{5.55112e-16,-50}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Documentation(info="<html>
  <p>If the source of an internal specification is redeclared to a block besides
  <a href=\"modelica://Modelica.Blocks.Sources.Constant\">Modelica.Blocks.Sources.Constant</a>,
  then the related condition must be redeclared as well.  For example, use:<br>
  <code>redeclare Conditions.FacePair.Material.Pressure material(redeclare Modelica.Blocks.Sources.Ramp source)</code><br>
  rather than simply:<br>
  <code>material(redeclare Modelica.Blocks.Sources.Ramp source)</code></p>
  </html>"));
    end Species;

    package Normal "Normal translational conditions"
      extends Modelica.Icons.Package;

      model CurrentAreic
        "Specify areic current (measure normal force), with conservation of material"
        extends BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.CurrentAreic,
          u(final unit="N/(l2.T)"),
          final y(final unit="l.m/T2") = negative.mPhidot_0 + positive.mPhidot_0);

      equation
        negative.J = u_final;
        annotation (
          defaultComponentPrefixes="replaceable",
          defaultComponentName="normal",
          Documentation(info="<html>
  <p>Assumptions:
  <ol>
  <li>The conservation of material is applied with the assumption that the cross sectional areas of the two
  interfaces are equal.</li>
  </ol></html>"));
      end CurrentAreic;

      model Force
        "Specify normal force (measure areic current), with conservation of material"
        extends BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.Force,
          u(final unit="l.m/T2"),
          final y(final unit="N/(l2.T)") = negative.J);

      equation
        negative.mPhidot_0 + positive.mPhidot_0 = u_final;
        annotation (
          defaultComponentPrefixes="replaceable",
          defaultComponentName="normal",
          Documentation(info="<html>
  <p>Assumptions:
  <ol>
  <li>The conservation of material is applied with the assumption that the cross sectional areas of the two
  interfaces are equal.</li>
  </ol></html>"));
      end Force;

      model Custom "Custom expressions"
        extends BaseClasses.PartialCondition(final conditionType=BaseClasses.ConditionType.Custom,
            y=negative.mPhidot_0 + positive.mPhidot_0);

        Real x=negative.J "Expression to which the condition is applied"
          annotation (Dialog(group="Specification"));

      equation
        x = u_final;
        annotation (
          defaultComponentPrefixes="replaceable",
          defaultComponentName="normal",
          Documentation(info="<html><p>The expression to which the condition is applied (<code>x</code>)
    must involve <code>face.J</code> and/or <code>face.mPhidot_0</code>.</p></html>"));
      end Custom;

      package BaseClasses "Base classes (not generally for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialCondition "Partial model for a normal condition"
          extends FacePair.BaseClasses.PartialCondition;

          constant ConditionType conditionType "Type of condition";
          // Note:  This is included so that the type of condition is recorded with
          // the results.

        equation
          // Conservation of material
          negative.mPhidot_0 = positive.mPhidot_0;

          // No flows of other quantities
          // ----------------------------
          // Translational momentum in transverse directions
          negative.mPhidot = {0,0};
          positive.mPhidot = {0,0};
          //
          // Heat
          negative.Qdot = 0;
          positive.Qdot = 0;
          annotation (defaultComponentName="normal");
        end PartialCondition;

        type ConditionType = enumeration(
            CurrentAreic "Specify areic current (measure force)",
            Force "Specify force (measure areic current)",
            Custom "Custom expressions") "Types of conditions";

      end BaseClasses;

    end Normal;

    package Transverse "Transverse translational conditions"
      extends Modelica.Icons.Package;

      model Velocity
        "Specify velocity difference (measure shear force), with conversation of translational momentum"
        extends BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.Velocity,
          u(final unit="l/T"),
          final y(final unit="l.m/T2") = negative.mPhidot[orientation]);

      equation
        negative.phi[orientation] - positive.phi[orientation] = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="transverse");
      end Velocity;

      model Force
        "Specify shear force (measure velocity difference), with conversation of translational momentum"
        extends BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.Force,
          u(final unit="l.m/T2"),
          final y(final unit="l/T") = negative.phi[orientation] - positive.phi[
            orientation]);

      equation
        negative.mPhidot[orientation] = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="transverse");
      end Force;

      model Custom "Custom expressions"
        extends BaseClasses.PartialCondition(final conditionType=BaseClasses.ConditionType.Custom,
            y=negative.mPhidot[orientation]);

        Real x=negative.phi[orientation] - positive.phi[orientation]
          "Expression to which the condition is applied"
          annotation (Dialog(group="Specification"));

      equation
        x = u_final;
        annotation (
          defaultComponentPrefixes="replaceable",
          defaultComponentName="normal",
          Documentation(info="<html><p>The expression to which the condition is applied (<code>x</code>)
    must involve <code>face.phi[orientation]</code> and/or <code>face.mPhidot[orientation]</code>.</p></html>"));
      end Custom;

      package BaseClasses "Base classes (not generally for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialCondition
          "Partial model for a transverse translational condition"
          import FCSys.BaseClasses.Utilities.mod1;
          extends FacePair.BaseClasses.PartialCondition;

          parameter Orientation orientation=Orientation.preceding
            "Orientation of translational momentum";

          constant ConditionType conditionType "Type of condition";
          // Note:  This is included so that the type of condition is recorded with
          // the results.

        equation
          // Conservation of translational momentum in the present transverse direction
          0 = negative.mPhidot[orientation] + positive.mPhidot[orientation];

          // No flows of other quantities
          // ----------------------------
          // Translational momentum in normal direction
          negative.mPhidot_0 = 0;
          positive.mPhidot_0 = 0;
          //
          // Translational momentum in the other transverse direction
          negative.mPhidot[mod1(orientation + 1, 2)] = 0;
          positive.mPhidot[mod1(orientation + 1, 2)] = 0;
          //
          // Heat
          negative.Qdot = 0;
          positive.Qdot = 0;
          annotation (defaultComponentName="transverse");
        end PartialCondition;

        type ConditionType = enumeration(
            Velocity "Specify velocity difference (measure shear force)",
            Force "Specify shear force (measure velocity difference)",
            Custom "Custom expressions") "Types of conditions";

      end BaseClasses;

    end Transverse;

    package Thermal "Thermal conditions"
      extends Modelica.Icons.Package;

      model Temperature
        "Specify temperature difference (measure heat flow rate), with conversation of energy"
        extends Thermal.BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.Temperature,
          u(final unit="l2.m/(N.T2)", displayUnit="K"),
          final y(unit="l2.m/T3") = negative.Qdot);

      equation
        negative.T - positive.T = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="thermal");
      end Temperature;

      model HeatRate
        "Specify heat flow rate (measure temperature difference), with conversation of energy"
        extends Thermal.BaseClasses.PartialCondition(
          final conditionType=BaseClasses.ConditionType.HeatRate,
          u(final unit="l2.m/T3"),
          final y(
            final unit="l2.m/(N.T2)",
            displayUnit="K") = negative.T - positive.T);

      equation
        negative.Qdot = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="thermal");
      end HeatRate;

      model Custom
        "Apply condition to a custom expression, with conversation of energy"
        extends BaseClasses.PartialCondition(final conditionType=BaseClasses.ConditionType.Custom,
            y=negative.Qdot);

        Real x=negative.T - positive.T
          "Expression to which the condition is applied"
          annotation (Dialog(group="Specification"));

      equation
        x = u_final;
        annotation (
          defaultComponentPrefixes="replaceable",
          defaultComponentName="thermal",
          Documentation(info="<html><p>The expression to which the condition is applied (<code>x</code>)
    must involve <code>face.T</code> and/or <code>face.Qdot</code>.</p></html>"));
      end Custom;

      package BaseClasses "Base classes (not generally for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialCondition "Partial model for a thermal condition"
          extends FacePair.BaseClasses.PartialCondition;

          constant ConditionType conditionType "Type of condition";
          // Note:  This is included so that the type of condition is recorded with
          // the results.

        equation
          // Conservation of energy (no storage)
          0 = negative.Qdot + positive.Qdot;

          // No flows of other quantities
          // ----------------------------
          // Translational momentum in normal direction
          negative.mPhidot_0 = 0;
          positive.mPhidot_0 = 0;
          //
          // Translational momentum in transverse directions
          negative.mPhidot = {0,0};
          positive.mPhidot = {0,0};
          annotation (defaultComponentName="thermal");
        end PartialCondition;

        type ConditionType = enumeration(
            Temperature
              "Specify temperature difference (measure heat flow rate)",
            HeatRate "Specify heat flow rate (measure temperature difference)",

            Custom "Custom expressions") "Types of conditions";

      end BaseClasses;

    end Thermal;

    package BaseClasses "Base classes (not generally for direct use)"
      extends Modelica.Icons.BasesPackage;

      partial model PartialCondition
        "Partial model to specify and measure conditions on a pair of connectors"
        extends FCSys.Conditions.BaseClasses.Icons.Double;

        parameter Boolean internal=true "Use internal specification"
          annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Specification"));

        replaceable Modelica.Blocks.Sources.Constant source if internal
          constrainedby Modelica.Blocks.Interfaces.SO
          "Source of internal specification" annotation (
          __Dymola_choicesFromPackage=true,
          Dialog(group="Specification",enable=internal),
          Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={40,20})));

        Connectors.RealInput u if not internal "Value of specified condition"
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={0,50})));

        Connectors.RealOutput y "Measurement expression" annotation (Dialog(
              group="Measurement"), Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={0,-50}), iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={0,-50})));

        Connectors.Face negative
          "Negative-side connector to transport translational momentum and heat of a single species"
          annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
        Connectors.Face positive
          "Positive-side connector to transport translational momentum and heat of a single species"
          annotation (Placement(transformation(extent={{90,-10},{110,10}})));

      protected
        Connectors.RealOutputInternal u_final
          "Final value of specified condition" annotation (Placement(
              transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={0,-20})));

      equation
        connect(u, u_final) annotation (Line(
            points={{5.55112e-16,50},{0,0},{0,-20},{5.55112e-16,-20}},
            color={0,0,127},
            smooth=Smooth.None));

        connect(source.y, u_final) annotation (Line(
            points={{40,9},{40,0},{0,0},{0,-20},{5.55112e-16,-20}},
            color={0,0,127},
            smooth=Smooth.None));
        annotation (Icon(graphics));
      end PartialCondition;

    end BaseClasses;

  end FacePair;

  model Router "Connect two pairs of faces to pass through or cross over"
    extends FCSys.BaseClasses.Icons.Names.Top3;
    parameter Boolean crossOver=false "Cross over (otherwise, pass through)"
      annotation (choices(__Dymola_checkBox=true));
    Connectors.FaceBus negative1 "Negative face 1" annotation (Placement(
          transformation(extent={{-90,-50},{-70,-30}}, rotation=0),
          iconTransformation(extent={{-90,-50},{-70,-30}})));
    Connectors.FaceBus positive1 "Positive face 1" annotation (Placement(
          transformation(extent={{70,-50},{90,-30}}, rotation=0),
          iconTransformation(extent={{70,-50},{90,-30}})));
    Connectors.FaceBus negative2 "Negative face 2" annotation (Placement(
          transformation(extent={{-90,30},{-70,50}}, rotation=0),
          iconTransformation(extent={{-90,30},{-70,50}})));
    Connectors.FaceBus positive2 "Positive face 2" annotation (Placement(
          transformation(extent={{70,30},{90,50}}, rotation=0),
          iconTransformation(extent={{70,30},{90,50}})));

  equation
    if crossOver then
      connect(negative1, positive2) annotation (Line(
          points={{-80,-40},{-40,-40},{0,0},{40,40},{80,40}},
          color={127,127,127},
          smooth=Smooth.Bezier,
          thickness=0.5,
          pattern=LinePattern.Dash));
      connect(negative2, positive1) annotation (Line(
          points={{-80,40},{-80,40},{-40,40},{0,0},{40,-40},{80,-40}},
          color={127,127,127},
          smooth=Smooth.Bezier,
          thickness=0.5,
          pattern=LinePattern.Dash));
    else
      // Pass-through
      connect(negative1, positive1) annotation (Line(
          points={{-80,-40},{-80,-40},{80,-40}},
          color={127,127,127},
          thickness=0.5));
      connect(negative2, positive2) annotation (Line(
          points={{-80,40},{-80,40},{80,40}},
          color={127,127,127},
          thickness=0.5));
    end if;
    annotation (Documentation(info="<html>
<p>This model acts as a connection switch.
It has a single parameter, <code>crossOver</code>.</p>

<p>If <code>crossOver</code> is
set to <code>false</code>, then
the router will be in the pass-through mode.  In that case,
<code>negative1</code> is connected to <code>positive1</code> and <code>negative2</code>
is connected to <code>positive2</code>, as shown by Figure 1a.</p>

<p>If <code>crossOver</code> is set to <code>true</code>, then the router will be in cross-over mode.  In that case, <code>negative1</code> is connected to <code>positive2</code>
and <code>negative2</code> is
connected to <code>positive1</code>, as shown by Figure 1b.</p>

    <table border=\"0\" cellspacing=\"0\" cellpadding=\"2\" align=center>
      <tr align=center>
        <td align=center width=120>
          <img src=\"modelica://FCSys/resources/documentation/Conditions/Router/PassThrough.png\">
<br><b>a:</b>  Pass-through
        </td>
        <td align=center>
          <img src=\"modelica://FCSys/resources/documentation/Conditions/Router/CrossOver.png\">
<br><b>b:</b>  Cross-over
        </td>
      </tr>
      <tr align=center>
        <td colspan=2 align=center>Figure 1: Modes of connection.</td>
      </tr>
    </table>
</html>"), Icon(graphics={
          Line(
            points={{-80,40},{-40,40},{0,0},{40,-40},{80,-40}},
            color={127,127,127},
            thickness=0.5,
            visible=crossOver,
            smooth=Smooth.Bezier),
          Line(
            points={{-80,40},{80,40}},
            color={127,127,127},
            visible=not crossOver,
            smooth=Smooth.None,
            thickness=0.5),
          Line(
            points={{-80,-40},{80,-40}},
            color={127,127,127},
            visible=not crossOver,
            smooth=Smooth.None,
            thickness=0.5),
          Line(
            points={{-80,-40},{-40,-40},{0,0},{40,40},{80,40}},
            color={127,127,127},
            thickness=0.5,
            visible=crossOver,
            smooth=Smooth.Bezier)}));
  end Router;

  record Environment "Environmental properties for a model"
    extends FCSys.BaseClasses.Icons.Names.Top3;

    // Store the values of the base constants and units.
    final constant U.Bases.Base baseUnits=U.base "Base constants and units";

    parameter Boolean analysis=false "Include optional variables for analysis"
      annotation (choices(__Dymola_checkBox=true));

    parameter Q.PressureAbsolute p(nominal=U.atm) = 1*U.atm "Pressure";
    parameter Q.TemperatureAbsolute T(nominal=300*U.K) = 298.15*U.K
      "Temperature";
    parameter Q.NumberAbsolute RH(displayUnit="%") = 1 "Relative humidity";
    parameter Q.NumberAbsolute n_O2_dry(
      final max=1,
      displayUnit="%") = 0.208
      "<html>Dry gas O<sub>2</sub> fraction (<i>n</i><sub>O2 dry</sub>)</html>";
    // Value from http://en.wikipedia.org/wiki/Oxygen
    parameter Q.Acceleration a[Axis]={0,Modelica.Constants.g_n*U.m/U.s^2,0}
      "Acceleration due to body forces";
    // The gravity component is positive because it's added to the transient
    // term in the Species model.
    parameter Real E[Axis]={0,0,0} "Electric field";
    // **PotentiaLineic
    final parameter Q.NumberAbsolute n_H2O(
      final max=1,
      displayUnit="%") = 0.2
      "<html>Gas H<sub>2</sub>O fraction (<i>n</i><sub>H2O</sub>)</html>";
    // TODO:  Cast this in terms of relative humidity.
    annotation (
      defaultComponentName="environment",
      defaultComponentPrefixes="inner",
      missingInnerMessage="
Your model is using an outer \"environment\" record, but an inner \"environment\"
record is not defined.  For simulation, drag FCSys.Conditions.Environment into
your model to specify global conditions and defaults.  Otherwise the default
settings will be used.
",
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
              100}}), graphics={
          Rectangle(
            extent={{-120,60},{120,100}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Text(
            extent={{-120,60},{120,100}},
            textString="%name",
            lineColor={0,0,0}),
          Rectangle(
            extent={{-80,60},{80,-100}},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            pattern=LinePattern.None),
          Rectangle(
            extent={{-70,50},{70,-98}},
            lineColor={255,255,255},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={170,170,255}),
          Rectangle(
            extent={{-72,-60},{72,-100}},
            fillPattern=FillPattern.Solid,
            fillColor={255,255,255},
            pattern=LinePattern.None,
            lineColor={0,0,0}),
          Line(points={{-70,-60},{70,-60}}, color={0,0,0}),
          Line(points={{-40,-20},{-10,-50},{40,0}}, color={0,0,0}),
          Ellipse(
            extent={{32,8},{48,-8}},
            pattern=LinePattern.None,
            lineColor={255,255,255},
            fillColor={50,50,50},
            fillPattern=FillPattern.Sphere),
          Line(points={{-66,-90},{-36,-60}}, color={0,0,0}),
          Line(points={{2,-90},{32,-60}}, color={0,0,0}),
          Line(points={{36,-90},{66,-60}}, color={0,0,0}),
          Line(points={{-32,-90},{-2,-60}}, color={0,0,0}),
          Rectangle(
            extent={{70,50},{76,-60}},
            fillPattern=FillPattern.Solid,
            fillColor={255,255,255},
            pattern=LinePattern.None,
            lineColor={0,0,0}),
          Rectangle(
            extent={{-76,50},{-70,-60}},
            fillPattern=FillPattern.Solid,
            fillColor={255,255,255},
            pattern=LinePattern.None,
            lineColor={0,0,0}),
          Rectangle(
            extent={{-80,60},{80,-100}},
            lineColor={0,0,0},
            pattern=LinePattern.Dash)}));

  end Environment;

  package BaseClasses "Base classes (not generally for direct use)"
    extends Modelica.Icons.BasesPackage;

    package Icons "Icons for conditions"
      extends Modelica.Icons.Package;
      partial class Double "Icon for a two-connector boundary condition"
        // extends Names.Middle;
        annotation (Icon(graphics={Rectangle(
                      extent={{-100,40},{100,-40}},
                      fillColor={255,255,255},
                      fillPattern=FillPattern.Solid,
                      pattern=LinePattern.None),Line(
                      points={{-100,40},{100,40}},
                      pattern=LinePattern.None,
                      smooth=Smooth.None),Line(
                      points={{-100,-40},{-100,40}},
                      color={0,0,0},
                      smooth=Smooth.None,
                      pattern=LinePattern.Dash),Text(
                      extent={{-150,-20},{150,20}},
                      textString="%name",
                      lineColor={0,0,0}),Line(
                      points={{-100,-40},{100,-40}},
                      pattern=LinePattern.None,
                      smooth=Smooth.None),Line(
                      points={{100,-40},{100,40}},
                      color={0,0,0},
                      smooth=Smooth.None,
                      pattern=LinePattern.Dash)}));

      end Double;

      partial class Single "Icon for a single-connector boundary condition"
        // extends Names.Middle;
        annotation (Icon(graphics={
              Rectangle(
                extent={{-100,40},{100,-40}},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid,
                pattern=LinePattern.None),
              Line(
                points={{-100,-40},{-100,40},{100,40},{100,-40}},
                pattern=LinePattern.None,
                smooth=Smooth.None),
              Line(
                points={{-100,-40},{100,-40}},
                color={0,0,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dash),
              Text(
                extent={{-100,-20},{100,20}},
                textString="%name",
                lineColor={0,0,0})}));

      end Single;

    end Icons;

  end BaseClasses;
  annotation (Documentation(info="<html>
  <p>The <a href=\"modelica://FCSys.Conditions.Chemical\">Chemical</a>,
  <a href=\"modelica://FCSys.Conditions.ChemicalBus\">ChemicalBus</a>, 
  <a href=\"modelica://FCSys.Conditions.InertDalton\">InertDalton</a>, <a href=\"modelica://FCSys.Conditions.Face\">Face</a>, and
  <a href=\"modelica://FCSys.Conditions.FaceBus\">FaceBus</a> packages contain models to specify conditions on the
  connectors with the same names (<a href=\"modelica://FCSys.Connectors.ChemicalInput\">ChemicalInput</a> or
  <a href=\"modelica://FCSys.Connectors.ChemicalOutput\">ChemicalOutput</a>, <a href=\"modelica://FCSys.Connectors.Inert\">Inert</a> or
  <a href=\"modelica://FCSys.Connectors.InertInternal\">InertInternal</a>,
  <a href=\"modelica://FCSys.Connectors.InertDalton\">InertDalton</a>, <a href=\"modelica://FCSys.Conditions.Face\">Face</a>, and
  <a href=\"modelica://FCSys.Connectors.FaceBus\">FaceBus</a>).
  The <a href=\"modelica://FCSys.Conditions.FaceDifferential\">FacePair</a> and
  <a href=\"modelica://FCSys.Conditions.FaceBusPair\">FaceBusPair</a> packages contain models
  for pairs of <a href=\"modelica://FCSys.Conditions.Face\">Face</a> and
  <a href=\"modelica://FCSys.Connectors.FaceBus\">FaceBus</a> connectors.  Each model is given the same name as the
  model from the <a href=\"modelica://FCSys.Subregions\">Subregions</a> package that it may be used to represent.  For
  example, the model to interface with the <a href=\"modelica://FCSys.Conditions.Face\">Face</a> connector
  is named <a href=\"modelica://FCSys.Conditions.Face.Species\">Species</a> (in the
  <a href=\"modelica://FCSys.Conditions.Face\">Conditions.Face</a> package).</p>
</html>"));

end Conditions;
