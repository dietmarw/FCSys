within FCSys;
package BCs "Models for boundary conditions"
  extends Modelica.Icons.SourcesPackage;

  // TODO:  Recheck this package, fix errors and warnings.

  package Examples "Examples and tests"
    extends Modelica.Icons.ExamplesPackage;
    model Defaults "<html>Test the <code>Defaults</code> model</html>"
      extends Modelica.Icons.Example;

      // TODO:  Make this into a meaningful example.
      FCSys.BCs.Defaults defaults
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    end Defaults;

    model FaceBC "<html>Test the BCs for the face of a subregion</html>"
      extends Modelica.Icons.Example;

      FCSys.BCs.FaceBus.Subregion subregionFaceBC(gas(inclH2O=true, H2O(
            redeclare FCSys.BCs.Face.Material.Current material,
            inviscidX=false,
            inviscidZ=false)))
        annotation (Placement(transformation(extent={{-10,14},{10,34}})));
      Subregions.Subregion subregion(
        L={1,1,1}*U.cm,
        inclReact=false,
        inclXFaces=false,
        inclYFaces=true,
        inclZFaces=false,
        inclLinX=false,
        inclLinY=true,
        graphite(inclC=true, C(V_IC=0.5*U.cm^3)),
        gas(inclH2O=true, H2O(
            xNegative(thermoOpt=ThermoOpt.ClosedAdiabatic, inviscidY=true),
            xPositive(thermoOpt=ThermoOpt.ClosedAdiabatic, inviscidY=true),
            zNegative(inviscidY=true),
            zPositive(inviscidY=true),
            yPositive(
              thermoOpt=ThermoOpt.OpenDiabatic,
              inviscidX=false,
              inviscidZ=false))))
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

      inner BCs.Defaults defaults
        annotation (Placement(transformation(extent={{30,30},{50,50}})));
    equation
      connect(subregion.yPositive, subregionFaceBC.face) annotation (Line(
          points={{6.10623e-16,10},{-3.36456e-22,16},{6.10623e-16,16},{
              6.10623e-16,20}},
          color={127,127,127},
          thickness=0.5,
          smooth=Smooth.None));

      annotation (
        experiment(StopTime=0.0015, NumberOfIntervals=5000),
        experimentSetupOutput,
        Commands(file="resources/scripts/Dymola/BCs.Examples.FaceBC.mos"));
    end FaceBC;

    model FaceBCPhases
      "<html>Test the BCs for the face of a subregion with phases</html>"
      extends Modelica.Icons.Example;

      // Geometric parameters
      inner parameter Q.Length L[Axis](each min=Modelica.Constants.small,start=
            ones(3)*U.cm) "<html>Length (<b>L</b>)</html>"
        annotation (Dialog(group="Geometry"));
      final inner parameter Q.Area A[Axis]={L[cartWrap(axis + 1)]*L[cartWrap(
          axis + 2)] for axis in Axis} "Cross-sectional area";

      FCSys.BCs.FaceBus.Phases.Gas phaseFaceBC(
        inclH2O=true,
        H2O(thermoOpt=ThermoOpt.OpenDiabatic, redeclare
            FCSys.BCs.Face.Material.Current material),
        axis=FCSys.BaseClasses.Axis.y)
        annotation (Placement(transformation(extent={{-10,14},{10,34}})));
      Subregions.Volume volume
        annotation (Placement(transformation(extent={{-16,-16},{16,16}})));
      FCSys.Subregions.Phases.Gas gas(
        inclReact=false,
        inclLinX=false,
        inclLinY=true,
        inclH2=false,
        inclH2O=true,
        H2O(
          xNegative(thermoOpt=ThermoOpt.ClosedAdiabatic, inviscidY=true),
          xPositive(thermoOpt=ThermoOpt.ClosedAdiabatic, inviscidY=true),
          yPositive(thermoOpt=ThermoOpt.OpenDiabatic),
          zNegative(inviscidY=true),
          zPositive(inviscidY=true)))
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

      inner BCs.Defaults defaults
        annotation (Placement(transformation(extent={{30,30},{50,50}})));
    equation
      connect(gas.yPositive, phaseFaceBC.face) annotation (Line(
          points={{6.10623e-16,10},{-3.36456e-22,16},{6.10623e-16,16},{
              6.10623e-16,20}},
          color={127,127,127},
          thickness=0.5,
          smooth=Smooth.None));

      connect(gas.inert, volume.inert) annotation (Line(
          points={{8,-8},{11,-11}},
          color={72,90,180},
          smooth=Smooth.None));
      annotation (
        experiment(StopTime=0.003),
        experimentSetupOutput,
        Diagram(graphics));
    end FaceBCPhases;

    model Router "<html>Test the <code>Router<code> model</html>"
      extends Modelica.Icons.Example;

      // TODO:  Make this into a meaningful example.
      FCSys.BCs.Router router
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    end Router;

    model Adapteminus "<html>Test the <code>'Adapte-'</code> model</html>"

      extends Modelica.Icons.Example;
      extends Modelica.Icons.UnderConstruction;

      FCSys.BCs.Adapters.Subregion 'adapte-'
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
      Temp ground
        annotation (Placement(transformation(extent={{30,0},{50,20}})));
      Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T
          =298.15)
        annotation (Placement(transformation(extent={{50,-30},{30,-10}})));
      Subregions.Subregion subregion(
        L={1,1,1}*U.cm,
        inclReact=false,
        inclYFaces=false,
        inclZFaces=false,
        gas(inclH2O=false),
        graphite('incle-'=true,'e-'(
            xNegative(thermoOpt=ThermoOpt.ClosedAdiabatic),
            xPositive(thermoOpt=ThermoOpt.OpenDiabatic),
            yNegative(inviscidX=true),
            yPositive(inviscidX=true),
            zNegative(inviscidX=true),
            zPositive(inviscidX=true))))
        annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

      inner BCs.Defaults defaults(T=350*U.K)
        annotation (Placement(transformation(extent={{60,40},{80,60}})));
    equation
      connect(ground.p, 'adapte-'.pin) annotation (Line(
          points={{40,20},{20,20},{20,4},{10,4}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(fixedTemperature.port, 'adapte-'.port) annotation (Line(
          points={{30,-20},{20,-20},{20,-4},{10,-4}},
          color={191,0,0},
          smooth=Smooth.None));

      connect(subregion.xPositive, 'adapte-'.face) annotation (Line(
          points={{-30,6.10623e-16},{-20,-3.36456e-22},{-20,6.10623e-16},{-10,
              6.10623e-16}},
          color={127,127,127},
          thickness=0.5,
          smooth=Smooth.None));

      annotation (
        experiment(StopTime=2e-10),
        experimentSetupOutput,
        Commands(file="resources/scripts/Dymola/BCs.Examples.Adapteminus.mos"));
    end Adapteminus;

    model AdaptFluid "<html>Test the <code>FluidAdapt</code> model</html>"
      // **Need to nest the AdaptBusH2 to subregion level (currently only phase level).
      // **check that heat is transferred.
      extends Modelica.Icons.Example;

      FCSys.BCs.Adapters.Phases.Gas adaptH2(redeclare package Medium =
            Modelica.Media.IdealGases.SingleGases.H2)
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
      Modelica.Fluid.Vessels.ClosedVolume volume(
        use_portsData=false,
        nPorts=1,
        redeclare package Medium = Modelica.Media.IdealGases.SingleGases.H2 (
              referenceChoice=Modelica.Media.Interfaces.PartialMedium.Choices.ReferenceEnthalpy.ZeroAt25C,
              excludeEnthalpyOfFormation=false),
        V=1e-6,
        use_HeatTransfer=true,
        redeclare model HeatTransfer =
            Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.IdealHeatTransfer,
        medium(p(fixed=true), T(fixed=true)))
        annotation (Placement(transformation(extent={{22,10},{42,30}})));
      inner Modelica.Fluid.System system(T_ambient=293.15 + 5)
        annotation (Placement(transformation(extent={{40,70},{60,90}})));
      FCSys.Subregions.Subregion subregion(
        L={1,1,1}*U.cm,
        inclReact=false,
        inclYFaces=false,
        inclZFaces=false,
        gas(
          inclH2=true,
          inclH2O=false,
          H2(xPositive(thermoOpt=ThermoOpt.OpenDiabatic), xNegative(final
                thermoOpt=ThermoOpt.ClosedAdiabatic))))
        annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

      inner BCs.Defaults defaults(analysis=true, T=293.15*U.K)
        annotation (Placement(transformation(extent={{70,70},{90,90}})));

    equation
      connect(adaptH2.fluidPort, volume.ports[1]) annotation (Line(
          points={{10,4},{32,4},{32,10}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(subregion.xPositive, adaptH2.face) annotation (Line(
          points={{-20,6.10623e-16},{-16,-3.36456e-22},{-16,6.10623e-16},{-10,
              6.10623e-16}},
          color={127,127,127},
          thickness=0.5,
          smooth=Smooth.None));

      connect(volume.heatPort, adaptH2.heatPort) annotation (Line(
          points={{22,20},{16,20},{16,-4},{10,-4}},
          color={191,0,0},
          smooth=Smooth.None));
      annotation (
        experiment,
        experimentSetupOutput,
        Commands(file="resources/scripts/Dymola/BCs.Examples.FluidAdapt.mos"),
        Diagram(graphics));
    end AdaptFluid;

  end Examples;

  package Adapters "Adapters to Package Modelica"
    extends Modelica.Icons.Package;






    model Subregion
      "<html>Adapter between <a href=\"modelica://Modelica\">Modelica</a> and the face connector of a <a href=\"modelica://FCSys.Assemblies.Cells.Cell\">Cell</a>, <a href=\"modelica://FCSys.Regions.Region\">Region</a>, or <a href=\"modelica://FCSys.Subregions.Subregion\">Subregion</a></html>"
      extends FCSys.BaseClasses.Icons.Names.Top4;

      replaceable package GasMedium = FCSys.BCs.Adapters.Media constrainedby
        Modelica.Media.Interfaces.PartialMedium "Medium model for the gas"
        annotation (choicesAllMatching=true);
      replaceable package LiquidMedium = Modelica.Media.Water.WaterIF97_R1pT
        constrainedby Modelica.Media.Interfaces.PartialMedium
        "Medium model for the liquid" annotation (choicesAllMatching=true);

      FCSys.Connectors.FaceBus face
        "Multi-species connector for material, linear momentum, and heat"
        annotation (Placement(transformation(extent={{-90,-10},{-70,10}}),
            iconTransformation(extent={{-90,-10},{-70,10}})));
      Modelica.Fluid.Interfaces.FluidPort_b gasPort(redeclare final GasMedium
          Medium) "Modelica fluid port for the gas" annotation (Placement(
            transformation(extent={{70,50},{90,70}}), iconTransformation(extent
              ={{70,50},{90,70}})));
      Modelica.Electrical.Analog.Interfaces.NegativePin pin
        "Modelica electrical pin" annotation (Placement(transformation(extent={
                {70,10},{90,30}}), iconTransformation(extent={{70,10},{90,30}})));
      Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatPort
        "Modelica heat port" annotation (Placement(transformation(extent={{70,-30},
                {90,-10}}),iconTransformation(extent={{70,-30},{90,-10}})));
      Modelica.Fluid.Interfaces.FluidPort_b liquidPort(redeclare final
          LiquidMedium Medium) "Modelica fluid port for the liquid" annotation
        (Placement(transformation(extent={{70,-70},{90,-50}}),
            iconTransformation(extent={{70,-70},{90,-50}})));
      Phases.Graphite graphite "Graphite subadapter"
        annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

      Phases.Gas gas(final Medium=GasMedium) "Gas subadapter"
        annotation (Placement(transformation(extent={{-10,30},{10,50}})));
      Phases.Liquid liquid(final Medium=LiquidMedium) "Liquid subadapter"
        annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
    equation
      connect(graphite.face, face.graphite) annotation (Line(
          points={{-8,6.10623e-16},{-40,6.10623e-16},{-40,4.44089e-16},{-80,
              4.44089e-16}},
          color={127,127,127},
          smooth=Smooth.None,
          thickness=0.5));

      connect(graphite.pin, pin) annotation (Line(
          points={{8,4},{50,4},{50,20},{80,20}},
          color={0,0,255},
          smooth=Smooth.None));
      connect(graphite.port, heatPort) annotation (Line(
          points={{8,-4},{30,-4},{30,-20},{80,-20}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(gasPort, gas.fluidPort) annotation (Line(
          points={{80,60},{50,60},{50,44},{8,44}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(liquidPort, liquid.fluidPort) annotation (Line(
          points={{80,-60},{50,-60},{50,-36},{8,-36}},
          color={0,127,255},
          smooth=Smooth.None));
      connect(liquid.heatPort, heatPort) annotation (Line(
          points={{8,-44},{30,-44},{30,-20},{80,-20}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(gas.heatPort, heatPort) annotation (Line(
          points={{8,36},{30,36},{30,-20},{80,-20}},
          color={191,0,0},
          smooth=Smooth.None));
      connect(liquid.face, face.liquid) annotation (Line(
          points={{-8,-40},{-40,-40},{-40,4.44089e-16},{-80,4.44089e-16}},
          color={127,127,127},
          thickness=0.5,
          smooth=Smooth.None));
      connect(gas.face, face.gas) annotation (Line(
          points={{-8,40},{-40,40},{-40,4.44089e-16},{-80,4.44089e-16}},
          color={127,127,127},
          thickness=0.5,
          smooth=Smooth.None));

      annotation (Icon(graphics={
            Line(
              points={{0,60},{0,-60}},
              color={0,0,0},
              smooth=Smooth.None,
              pattern=LinePattern.Dash,
              thickness=0.5),
            Line(
              points={{0,0},{-80,0}},
              color={127,127,127},
              smooth=Smooth.None,
              thickness=0.5),
            Line(
              points={{0,20},{80,20}},
              color={0,0,255},
              smooth=Smooth.None),
            Line(
              points={{0,-20},{80,-20}},
              color={191,0,0},
              smooth=Smooth.None),
            Line(
              points={{0,60},{80,60}},
              color={0,127,255},
              smooth=Smooth.None),
            Line(
              points={{0,-60},{80,-60}},
              color={0,127,255},
              smooth=Smooth.None)}), Diagram(graphics));
    end Subregion;


    package Phases "Adapters for phases"
      extends Modelica.Icons.Package;
      model Gas
        "<html>Adapter for H<sub>2</sub> between <a href=\"modelica://FCSys\">FCSys</a> and <a href=\"modelica://Modelica\">Modelica</a></html>"
        extends FCSys.BaseClasses.Icons.Names.Top3;
        FCSys.BCs.Adapters.Species.Fluid H2(redeclare final package Medium =
              Modelica.Media.IdealGases.SingleGases.H2 (referenceChoice=
                  Modelica.Media.Interfaces.PartialMedium.Choices.ReferenceEnthalpy.ZeroAt25C,
                excludeEnthalpyOfFormation=false))
          annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
        Modelica.Fluid.Interfaces.FluidPort_b fluidPort(redeclare final package
            Medium = Medium) "Modelica fluid port" annotation (Placement(
              transformation(extent={{70,30},{90,50}}), iconTransformation(
                extent={{70,30},{90,50}})));
        Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatPort
          "Modelica heat port" annotation (Placement(transformation(extent={{70,
                  -50},{90,-30}}), iconTransformation(extent={{70,-50},{90,-30}})));
        Connectors.FaceBus face "FCSys face connector" annotation (Placement(
              transformation(extent={{-90,-10},{-70,10}}), iconTransformation(
                extent={{-90,-10},{-70,10}})));
      equation
        connect(H2.fluidPort, fluidPort) annotation (Line(
            points={{8,4},{40,4},{40,40},{80,40}},
            color={0,127,255},
            smooth=Smooth.None));

        connect(H2.heatPort, heatPort) annotation (Line(
            points={{8,-4},{40,-4},{40,-40},{80,-40}},
            color={191,0,0},
            smooth=Smooth.None));
        connect(H2.face.material, face.H2.material) annotation (Line(
            points={{-8,6.10623e-16},{-54,6.10623e-16},{-54,5.55112e-16},{-80,
                5.55112e-16}},
            color={127,127,127},
            smooth=Smooth.None));

        connect(H2.face.thermal, face.H2.thermal) annotation (Line(
            points={{-8,6.10623e-16},{-54,6.10623e-16},{-54,5.55112e-16},{-80,
                5.55112e-16}},
            color={127,127,127},
            smooth=Smooth.None));

        annotation (Diagram(graphics), Icon(graphics={
              Line(
                points={{0,40},{0,-40}},
                color={0,0,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dash,
                thickness=0.5),
              Line(
                points={{0,0},{-80,0}},
                color={127,127,127},
                smooth=Smooth.None,
                thickness=0.5),
              Line(
                points={{0,40},{80,40}},
                color={0,0,255},
                smooth=Smooth.None),
              Line(
                points={{0,-40},{80,-40}},
                color={191,0,0},
                smooth=Smooth.None)}));
        connect(H2.fluidPort, fluidPort) annotation (Line(
            points={{8,4},{40,4},{40,40},{80,40}},
            color={0,127,255},
            smooth=Smooth.None));
        connect(heatPort, H2.heatPort) annotation (Line(
            points={{80,-40},{40,-40},{40,-4},{8,-4}},
            color={191,0,0},
            smooth=Smooth.None));
      end Gas;

      model Graphite
        "<html>Electrical adapter between <a href=\"modelica://FCSys\">FCSys</a> and <a href=\"modelica://Modelica\">Modelica</a> with bus connector</html>"
        extends FCSys.BaseClasses.Icons.Names.Top3;

        FCSys.Connectors.FaceBus face
          "Connector for material, linear momentum, and heat" annotation (
            Placement(transformation(extent={{-90,-10},{-70,10}}),
              iconTransformation(extent={{-90,-10},{-70,10}})));
        Modelica.Electrical.Analog.Interfaces.NegativePin pin
          "Modelica electrical pin" annotation (Placement(transformation(extent
                ={{70,30},{90,50}}), iconTransformation(extent={{70,30},{90,50}})));
        FCSys.BCs.Adapters.Species.'e-' 'e-'
          annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));

        Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port
          "Modelica heat port" annotation (Placement(transformation(extent={{70,
                  -50},{90,-30}}), iconTransformation(extent={{70,-50},{90,-30}})));
        Species.Solid C
          annotation (Placement(transformation(extent={{-10,10},{10,30}})));
      equation
        connect(C.face.thermal, face.C.thermal) annotation (Line(
            points={{-8,20},{-40,20},{-40,5.55112e-16},{-80,5.55112e-16}},
            color={127,127,127},
            smooth=Smooth.None));

        connect('e-'.face.material, face.'e-'.material) annotation (Line(
            points={{-8,-20},{-40,-20},{-40,5.55112e-16},{-80,5.55112e-16}},
            color={127,127,127},
            smooth=Smooth.None));

        connect('e-'.face.thermal, face.'e-'.thermal) annotation (Line(
            points={{-8,-20},{-40,-20},{-40,5.55112e-16},{-80,5.55112e-16}},
            color={127,127,127},
            smooth=Smooth.None));

        connect('e-'.pin, pin) annotation (Line(
            points={{8,-16},{50,-16},{50,40},{80,40}},
            color={0,0,255},
            smooth=Smooth.None));

        annotation (Icon(graphics={
              Line(
                points={{0,40},{0,-40}},
                color={0,0,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dash,
                thickness=0.5),
              Line(
                points={{0,0},{-80,0}},
                color={127,127,127},
                smooth=Smooth.None,
                thickness=0.5),
              Line(
                points={{0,40},{80,40}},
                color={0,0,255},
                smooth=Smooth.None),
              Line(
                points={{0,-40},{80,-40}},
                color={191,0,0},
                smooth=Smooth.None)}), Diagram(graphics));
        connect('e-'.port, port) annotation (Line(
            points={{8,-24},{30,-24},{30,-40},{80,-40}},
            color={191,0,0},
            smooth=Smooth.None));
        connect(C.port, port) annotation (Line(
            points={{8,16},{30,16},{30,-40},{80,-40}},
            color={191,0,0},
            smooth=Smooth.None));
      end Graphite;

      model Liquid
        "<html>Adapter for H<sub>2</sub> between <a href=\"modelica://FCSys\">FCSys</a> and <a href=\"modelica://Modelica\">Modelica</a></html>"
        extends FCSys.BaseClasses.Icons.Names.Top3;
        FCSys.BCs.Adapters.Species.Fluid H2(redeclare final package Medium =
              Modelica.Media.IdealGases.SingleGases.H2 (referenceChoice=
                  Modelica.Media.Interfaces.PartialMedium.Choices.ReferenceEnthalpy.ZeroAt25C,
                excludeEnthalpyOfFormation=false))
          annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
        Modelica.Fluid.Interfaces.FluidPort_b fluidPort(redeclare final package
            Medium = Medium) "Modelica fluid port" annotation (Placement(
              transformation(extent={{70,30},{90,50}}), iconTransformation(
                extent={{70,30},{90,50}})));
        Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatPort
          "Modelica heat port" annotation (Placement(transformation(extent={{70,
                  -50},{90,-30}}), iconTransformation(extent={{70,-50},{90,-30}})));
        Connectors.FaceBus face "FCSys face connector" annotation (Placement(
              transformation(extent={{-90,-10},{-70,10}}), iconTransformation(
                extent={{-90,-10},{-70,10}})));
      equation
        connect(H2.fluidPort, fluidPort) annotation (Line(
            points={{8,4},{40,4},{40,40},{80,40}},
            color={0,127,255},
            smooth=Smooth.None));

        connect(H2.heatPort, heatPort) annotation (Line(
            points={{8,-4},{40,-4},{40,-40},{80,-40}},
            color={191,0,0},
            smooth=Smooth.None));
        connect(H2.face.material, face.H2.material) annotation (Line(
            points={{-8,6.10623e-16},{-54,6.10623e-16},{-54,5.55112e-16},{-80,
                5.55112e-16}},
            color={0,0,0},
            smooth=Smooth.None));

        connect(H2.face.thermal, face.H2.thermal) annotation (Line(
            points={{-8,6.10623e-16},{-54,6.10623e-16},{-54,5.55112e-16},{-80,
                5.55112e-16}},
            color={127,127,127},
            smooth=Smooth.None));

        annotation (Diagram(graphics), Icon(graphics={
              Line(
                points={{0,40},{0,-40}},
                color={0,0,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dash,
                thickness=0.5),
              Line(
                points={{0,0},{-80,0}},
                color={127,127,127},
                smooth=Smooth.None,
                thickness=0.5),
              Line(
                points={{0,40},{80,40}},
                color={0,0,255},
                smooth=Smooth.None),
              Line(
                points={{0,-40},{80,-40}},
                color={191,0,0},
                smooth=Smooth.None)}));
        connect(H2.fluidPort, fluidPort) annotation (Line(
            points={{8,4},{40,4},{40,40},{80,40}},
            color={0,127,255},
            smooth=Smooth.None));
        connect(heatPort, H2.heatPort) annotation (Line(
            points={{80,-40},{40,-40},{40,-4},{8,-4}},
            color={191,0,0},
            smooth=Smooth.None));
      end Liquid;
    end Phases;

    package Species "Adapters for Species"
      model Solid
        "**<html>Adapter to connect a <a href=\"modelica://Modelica.Electrical.Analog.Interfaces.Pin\">Modelica electrical pin</a> to the <a href=\"modelica://FCSys.Subregions.Species.'e-'\">electron</a> species in <a href=\"modelica://FCSys\">FCSys</a></html>"
        import Data = FCSys.Characteristics.'e-'.Graphite;

        extends FCSys.BaseClasses.Icons.Names.Top3;

        FCSys.Connectors.Face face(
          axis=Axis.x,
          final thermoOpt=ThermoOpt.OpenDiabatic,
          final inviscidX=true,
          final inviscidY=true,
          final inviscidZ=true)
          "Connector for material, linear momentum, and heat of a single species"
          annotation (Placement(transformation(extent={{-90,-10},{-70,10}}),
              iconTransformation(extent={{-90,-10},{-70,10}})));
        // Note:  The axis doesn't matter since transverse linear momentum
        // isn't included.
        Modelica.Electrical.Analog.Interfaces.NegativePin pin
          "Modelica electrical pin" annotation (Placement(transformation(extent
                ={{70,30},{90,50}}), iconTransformation(extent={{70,30},{90,50}})));

        Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port
          "Modelica heat port" annotation (Placement(transformation(extent={{70,
                  -50},{90,-30}}), iconTransformation(extent={{70,-50},{90,-30}})));
      equation
        // Efforts
        Data.g(face.thermal.T, Data.p_Tv(face.thermal.T, 1/face.material.rho))
          = Data.z*pin.v*U.V "Electrochemical potential";
        face.thermal.T = port.T*U.K "Temperature";

        // Conservation (no storage)
        0 = face.material.Ndot + pin.i*U.A/Data.z "Material";
        0 = face.thermal.Qdot + port.Q_flow*U.W "Energy";
        // There is no electrical work since electrons are not stored and there
        // is no potential difference.

        annotation (
          Documentation(info="<html><p>Note that transverse linear momentum is not included.</p>
  </html>"),
          Icon(graphics={
              Line(
                points={{0,40},{0,-40}},
                color={0,0,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dash),
              Line(
                points={{0,0},{-80,0}},
                color={127,127,127},
                smooth=Smooth.None),
              Line(
                points={{0,40},{80,40}},
                color={0,0,255},
                smooth=Smooth.None),
              Line(
                points={{0,-40},{80,-40}},
                color={191,0,0},
                smooth=Smooth.None)}),
          Diagram(graphics));
      end Solid;
      extends Modelica.Icons.Package;




      model 'e-'
        "<html>Adapter to connect a <a href=\"modelica://Modelica.Electrical.Analog.Interfaces.Pin\">Modelica electrical pin</a> to the <a href=\"modelica://FCSys.Subregions.Species.'e-'\">electron</a> species in <a href=\"modelica://FCSys\">FCSys</a></html>"
        import Data = FCSys.Characteristics.'e-'.Graphite;

        extends FCSys.BaseClasses.Icons.Names.Top3;

        FCSys.Connectors.Face face(
          axis=Axis.x,
          final thermoOpt=ThermoOpt.OpenDiabatic,
          final inviscidX=true,
          final inviscidY=true,
          final inviscidZ=true)
          "Connector for material, linear momentum, and heat of a single species"
          annotation (Placement(transformation(extent={{-90,-10},{-70,10}}),
              iconTransformation(extent={{-90,-10},{-70,10}})));
        // Note:  The axis doesn't matter since transverse linear momentum
        // isn't included.
        Modelica.Electrical.Analog.Interfaces.NegativePin pin
          "Modelica electrical pin" annotation (Placement(transformation(extent
                ={{70,30},{90,50}}), iconTransformation(extent={{70,30},{90,50}})));

        Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port
          "Modelica heat port" annotation (Placement(transformation(extent={{70,
                  -50},{90,-30}}), iconTransformation(extent={{70,-50},{90,-30}})));
      equation
        // Efforts
        Data.g(face.thermal.T, Data.p_Tv(face.thermal.T, 1/face.material.rho))
          = Data.z*pin.v*U.V "Electrochemical potential";
        face.thermal.T = port.T*U.K "Temperature";

        // Conservation (no storage)
        0 = face.material.Ndot + pin.i*U.A/Data.z "Material";
        0 = face.thermal.Qdot + port.Q_flow*U.W "Energy";
        // There is no electrical work since electrons are not stored and there
        // is no potential difference.

        annotation (
          Documentation(info="<html><p>Note that transverse linear momentum is not included.</p>
  </html>"),
          Icon(graphics={
              Line(
                points={{0,40},{0,-40}},
                color={0,0,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dash),
              Line(
                points={{0,0},{-80,0}},
                color={127,127,127},
                smooth=Smooth.None),
              Line(
                points={{0,40},{80,40}},
                color={0,0,255},
                smooth=Smooth.None),
              Line(
                points={{0,-40},{80,-40}},
                color={191,0,0},
                smooth=Smooth.None)}),
          Diagram(graphics));
      end 'e-';

      model Fluid
        "<html>Fluid adapter between <a href=\"modelica://FCSys\">FCSys</a> and <a href=\"modelica://Modelica\">Modelica</a></html>"
        extends FCSys.BaseClasses.Icons.Names.Top3;

        replaceable package Medium = Modelica.Media.Interfaces.PartialMedium (
              final nXi=0) "Medium model" annotation (choicesAllMatching=true);

        Medium.BaseProperties medium "Base properties of the fluid";

        FCSys.Connectors.Face face(
          axis=Axis.x,
          final thermoOpt=ThermoOpt.OpenDiabatic,
          final inviscidX=true,
          final inviscidY=true,
          final inviscidZ=true) "FCSys face connector" annotation (Placement(
              transformation(extent={{-90,-10},{-70,10}}), iconTransformation(
                extent={{-90,-10},{-70,10}})));

        // Note:  The axis doesn't matter since the mechanical subconnectors
        // aren't included.
        Modelica.Fluid.Interfaces.FluidPort_b fluidPort(redeclare final package
            Medium = Medium) "Modelica fluid port" annotation (Placement(
              transformation(extent={{70,30},{90,50}}), iconTransformation(
                extent={{70,30},{90,50}})));
        Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatPort
          "Modelica heat port" annotation (Placement(transformation(extent={{70,
                  -50},{90,-30}}), iconTransformation(extent={{70,-50},{90,-30}})));

      equation
        // Thermodynamic state and properties
        medium.p = fluidPort.p;
        medium.T = heatPort.T;
        medium.Xi = ones(Medium.nXi)/Medium.nXi;

        // Effort variables
        face.material.rho = (medium.d/medium.MM)*U.mol/U.m^3;
        face.thermal.T = heatPort.T*U.K;
        medium.h = fluidPort.h_outflow;

        // Conservation (no storage)
        0 = face.material.Ndot + (fluidPort.m_flow/medium.MM)*U.mol/U.s
          "Material";
        0 = face.thermal.Qdot + heatPort.Q_flow*U.W "Energy";
        // Note:  The enthalpy and kinetic energy terms cancel since there is no
        // material storage and the thermodynamic state is continuous across the
        // junction.

        annotation (
          Documentation(info="<html><p>Note that transverse linear momentum is not included.</p>
  </html>"),
          Icon(graphics={
              Line(
                points={{0,40},{0,-40}},
                color={0,0,0},
                smooth=Smooth.None,
                pattern=LinePattern.Dash),
              Line(
                points={{0,0},{-80,0}},
                color={127,127,127},
                smooth=Smooth.None),
              Line(
                points={{0,40},{80,40}},
                color={0,127,255},
                smooth=Smooth.None),
              Line(
                points={{0,-40},{80,-40}},
                color={191,0,0},
                smooth=Smooth.None)}),
          Diagram(graphics));
      end Fluid;
    end Species;

    package Media "Modelica media models to interface with FCSys"
      extends Modelica.Icons.MaterialPropertiesPackage;

      package AnodeGas "Gas mixture for a PEMFC's anode (H2 and H2O)"
        extends Modelica.Media.IdealGases.Common.MixtureGasNasa(
          mediumName="AnodeGas",
          data={Modelica.Media.IdealGases.Common.SingleGasesData.H2,Modelica.Media.IdealGases.Common.SingleGasesData.H2O},

          fluidConstants={Modelica.Media.IdealGases.Common.FluidData.H2,
              Modelica.Media.IdealGases.Common.FluidData.H2O},
          substanceNames={"Hydrogen","Water"},
          reference_X=fill(1/nX, nX));

        annotation (Documentation(info="<html>

</html>"));
      end AnodeGas;

      package CathodeGas "Gas mixture for a PEMFC's cathode (H2O, N2, and O2)"
        extends Modelica.Media.IdealGases.Common.MixtureGasNasa(
          mediumName="CathodeGas",
          data={Modelica.Media.IdealGases.Common.SingleGasesData.H2O,Modelica.Media.IdealGases.Common.SingleGasesData.N2,
              Modelica.Media.IdealGases.Common.SingleGasesData.O2},
          fluidConstants={Modelica.Media.IdealGases.Common.FluidData.H2O,
              Modelica.Media.IdealGases.Common.FluidData.N2,Modelica.Media.IdealGases.Common.FluidData.O2},

          substanceNames={"Water","Nitrogen","Oxygen,"},
          reference_X=fill(1/nX, nX));

        annotation (Documentation(info="<html>

</html>"));
      end CathodeGas;
    end Media;
  end Adapters;

  package TestStands "Test stands"
    extends Modelica.Icons.Package;
    extends FCSys.BaseClasses.Icons.PackageUnderConstruction;
    model TestProfile "Test profile"
      extends Modelica.Icons.Example;
      extends FCSys.BCs.TestStands.BaseClasses.PartialTestStandNoIO;
      /*(
    anEndBC(each graphite(inclC=true, 'incle-'=true)),
    anSourceBC(each gas(inclH2=true, inclH2O=true)),
    anSinkBC(each gas(inclH2=true, inclH2O=true)),
    caEndBC(each graphite('incle-'=true)),
    caSourceBC(each gas(
        inclH2O=true,
        inclN2=true,
        inclO2=true)),
    caSinkBC(each graphite(inclC=true, 'incle-'=true)));
*/

      annotation (
        defaultComponentName="testStand",
        defaultComponentPrefixes="replaceable",
        Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                {100,100}}),graphics));
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
        fileName="FCSys/tests/LOOCV/data.mat",
        columns=2:19,
        smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
        "Block to load and replay data" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,80})));
      FCSys.Connectors.RealOutputBus y "Output signals as a bus" annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,-100}),iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,-40})));

    protected
      Modelica.Blocks.Math.Add sumAnMFC annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-14,30})));
      Modelica.Blocks.Math.Add sumCaMFC annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={14,30})));

      Modelica.Blocks.Math.Gain unit1(k=U.V) annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-152,0})));
      Modelica.Blocks.Math.Gain unit2(k=U.'%') annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-134,-30})));
      Modelica.Blocks.Math.Gain unit3(k=U.'%') annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-114,0})));
      FCSys.BCs.BaseClasses.RealFunction unit4(y=unit4.u*U.kPa + U.atm)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-94,-30})));
      FCSys.BCs.BaseClasses.RealFunction unit5(y=unit5.u*U.kPa + U.atm)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-74,0})));
      FCSys.BCs.BaseClasses.RealFunction unit6(y=unit6.u*U.kPa + U.atm)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-54,-30})));
      FCSys.BCs.BaseClasses.RealFunction unit7(y=unit7.u*U.kPa + U.atm)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-34,0})));
      Modelica.Blocks.Math.Gain unit8(k=U.L/U.min) annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-14,-30})));
      Modelica.Blocks.Math.Gain unit9(k=U.L/U.min) annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={14,0})));
      FCSys.BCs.BaseClasses.RealFunction unit10(y=(unit10.u + 273.15)*U.K)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={32,-30})));
      FCSys.BCs.BaseClasses.RealFunction unit11(y=(unit11.u + 273.15)*U.K)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={52,0})));
      FCSys.BCs.BaseClasses.RealFunction unit12(y=(unit12.u + 273.15)*U.K)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={72,-30})));
      FCSys.BCs.BaseClasses.RealFunction unit13(y=(unit13.u + 273.15)*U.K)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={92,0})));
      FCSys.BCs.BaseClasses.RealFunction unit14(y=(unit14.u + 273.15)*U.K)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={112,-30})));
      FCSys.BCs.BaseClasses.RealFunction unit15(y=(unit15.u + 273.15)*U.K)
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={132,0})));
      Modelica.Blocks.Math.Gain unit16(k=U.A) annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={152,-30})));

      FCSys.Connectors.RealOutputInternal Deltamu(final unit="l2.m/(N.T2)")
        "CVM Cell 1 Voltage" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-152,-60})));
      FCSys.Connectors.RealOutputInternal RHAnFPNegX(
        final unit="1",
        displayUnit="%",
        final min=0) "Anode inlet RH" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-134,-60})));
      FCSys.Connectors.RealOutputInternal RHCaFPNegX(
        final unit="1",
        displayUnit="%",
        final min=0) "Cathode inlet RH" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-114,-60})));
      FCSys.Connectors.RealOutputInternal p_anFPNegY(final unit="m/(l.T2)")
        "Pressure anode inlet" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-94,-60})));
      FCSys.Connectors.RealOutputInternal p_anFPPosY(final unit="m/(l.T2)",
          final min=0) "Pressure anode outlet" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-74,-60})));
      FCSys.Connectors.RealOutputInternal p_caFPNegY(final unit="m/(l.T2)")
        "Pressure cathode inlet" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-54,-60})));
      FCSys.Connectors.RealOutputInternal p_caFPPosY(final unit="m/(l.T2)",
          final min=0) "Pressure anode outlet" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-34,-60})));
      FCSys.Connectors.RealOutputInternal Vdot_anFPNegY_H2(final unit="l3/T")
        "Flow anode H2 MFC" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-14,-60})));
      FCSys.Connectors.RealOutputInternal Vdot_caFPNegY_air(final unit="l3/T")
        "Flow cathode H2 MFC" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={14,-60})));
      FCSys.Connectors.RealOutputInternal T_anFPNegY(
        final unit="l2.m/(N.T2)",
        displayUnit="K",
        final min=0) "Temperature anode inlet" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={32,-60})));
      FCSys.Connectors.RealOutputInternal T_anFPPosY(
        final unit="l2.m/(N.T2)",
        displayUnit="K",
        final min=0) "Temperature anode outlet" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={52,-60})));
      FCSys.Connectors.RealOutputInternal T_caFPNegY(
        final unit="l2.m/(N.T2)",
        displayUnit="K",
        final min=0) "Temperature cathode inlet" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={72,-60})));
      FCSys.Connectors.RealOutputInternal T_caFPPosY(
        final unit="l2.m/(N.T2)",
        displayUnit="K",
        final min=0) "Temperature cathode outlet" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={92,-60})));
      FCSys.Connectors.RealOutputInternal T_anFPX(
        final unit="l2.m/(N.T2)",
        displayUnit="K",
        final min=0) "Temperature end plate anode" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={112,-60})));
      FCSys.Connectors.RealOutputInternal T_caFPX(
        final unit="l2.m/(N.T2)",
        displayUnit="K",
        final min=0) "Temperature end plate cathode" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={132,-60})));
      FCSys.Connectors.RealOutputInternal J(final unit="N/T") "Measured load"
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
      connect(unit1.u, combiTimeTable.y[1]) annotation (Line(
          points={{-152,12},{-152,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(unit2.u, combiTimeTable.y[2]) annotation (Line(
          points={{-134,-18},{-134,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(unit3.u, combiTimeTable.y[3]) annotation (Line(
          points={{-114,12},{-114,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(unit4.u, combiTimeTable.y[4]) annotation (Line(
          points={{-94,-20},{-94,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(unit5.u, combiTimeTable.y[5]) annotation (Line(
          points={{-74,10},{-74,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(unit6.u, combiTimeTable.y[6]) annotation (Line(
          points={{-54,-20},{-54,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(unit7.u, combiTimeTable.y[7]) annotation (Line(
          points={{-34,10},{-34,50},{-1.44329e-15,50},{-1.44329e-15,69}},
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
      connect(unit10.u, combiTimeTable.y[12]) annotation (Line(
          points={{32,-20},{32,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(unit11.u, combiTimeTable.y[13]) annotation (Line(
          points={{52,10},{52,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(unit12.u, combiTimeTable.y[14]) annotation (Line(
          points={{72,-20},{72,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(unit13.u, combiTimeTable.y[15]) annotation (Line(
          points={{92,10},{92,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(unit14.u, combiTimeTable.y[16]) annotation (Line(
          points={{112,-20},{112,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(unit15.u, combiTimeTable.y[17]) annotation (Line(
          points={{132,10},{132,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(unit16.u, combiTimeTable.y[18]) annotation (Line(
          points={{152,-18},{152,50},{-1.44329e-15,50},{-1.44329e-15,69}},
          color={0,0,127},
          smooth=Smooth.None));

      // Connections from unit conversion to internal outputs
      connect(Deltamu, unit1.y) annotation (Line(
          points={{-152,-60},{-152,-11}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(RHAnFPNegX, unit2.y) annotation (Line(
          points={{-134,-60},{-134,-41}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(RHCaFPNegX, unit3.y) annotation (Line(
          points={{-114,-60},{-114,-11}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(p_anFPNegY, unit4.y) annotation (Line(
          points={{-94,-60},{-94,-40}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(p_anFPPosY, unit5.y) annotation (Line(
          points={{-74,-60},{-74,-10}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(p_caFPNegY, unit6.y) annotation (Line(
          points={{-54,-60},{-54,-40}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(p_caFPPosY, unit7.y) annotation (Line(
          points={{-34,-60},{-34,-10}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(Vdot_anFPNegY_H2, unit8.y) annotation (Line(
          points={{-14,-60},{-14,-50.5},{-14,-41},{-14,-41}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(Vdot_caFPNegY_air, unit9.y) annotation (Line(
          points={{14,-60},{14,-35.5},{14,-11},{14,-11}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T_anFPNegY, unit10.y) annotation (Line(
          points={{32,-60},{32,-50},{32,-40},{32,-40}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T_anFPPosY, unit11.y) annotation (Line(
          points={{52,-60},{52,-10}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T_caFPNegY, unit12.y) annotation (Line(
          points={{72,-60},{72,-40}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T_caFPPosY, unit13.y) annotation (Line(
          points={{92,-60},{92,-10}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T_anFPX, unit14.y) annotation (Line(
          points={{112,-60},{112,-40}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T_caFPX, unit15.y) annotation (Line(
          points={{132,-60},{132,-10}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(J, unit16.y) annotation (Line(
          points={{152,-60},{152,-41}},
          color={0,0,127},
          smooth=Smooth.None));

      // Summations
      connect(sumAnMFC.y, unit8.u) annotation (Line(
          points={{-14,19},{-14,9.75},{-14,9.75},{-14,0.5},{-14,-18},{-14,-18}},

          color={0,0,127},
          smooth=Smooth.None));

      connect(sumCaMFC.y, unit9.u) annotation (Line(
          points={{14,19},{14,17.25},{14,17.25},{14,15.5},{14,12},{14,12}},
          color={0,0,127},
          smooth=Smooth.None));

      // Connections from internal outputs to public output
      connect(Deltamu, y.Deltamu) annotation (Line(
          points={{-152,-60},{-152,-80},{5.55112e-16,-80},{5.55112e-16,-100}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(RHAnFPNegX, y.RHAnFPNegX) annotation (Line(
          points={{-134,-60},{-134,-80},{5.55112e-16,-80},{5.55112e-16,-100}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(RHCaFPNegX, y.RHCaFPNegX) annotation (Line(
          points={{-114,-60},{-114,-80},{5.55112e-16,-80},{5.55112e-16,-100}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(p_anFPNegY, y.p_anFPNegY) annotation (Line(
          points={{-94,-60},{-94,-80},{5.55112e-16,-80},{5.55112e-16,-100}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(p_anFPPosY, y.p_anFPPosY) annotation (Line(
          points={{-74,-60},{-74,-80},{5.55112e-16,-80},{5.55112e-16,-100}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(p_caFPNegY, y.p_caFPNegY) annotation (Line(
          points={{-54,-60},{-54,-80},{5.55112e-16,-80},{5.55112e-16,-100}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(p_caFPPosY, y.p_caFPPosY) annotation (Line(
          points={{-34,-60},{-34,-80},{5.55112e-16,-80},{5.55112e-16,-100}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(Vdot_anFPNegY_H2, y.Vdot_anFPNegY_H2) annotation (Line(
          points={{-14,-60},{-14,-80},{5.55112e-16,-80},{5.55112e-16,-100}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(Vdot_caFPNegY_air, y.Vdot_caFPNegY_air) annotation (Line(
          points={{14,-60},{14,-80},{5.55112e-16,-80},{5.55112e-16,-100}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T_anFPNegY, y.T_anFPNegY) annotation (Line(
          points={{32,-60},{32,-80},{5.55112e-16,-80},{5.55112e-16,-100}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T_anFPPosY, y.T_anFPPosY) annotation (Line(
          points={{52,-60},{52,-80},{5.55112e-16,-80},{5.55112e-16,-100}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T_caFPNegY, y.T_caFPNegY) annotation (Line(
          points={{72,-60},{72,-80},{5.55112e-16,-80},{5.55112e-16,-100}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T_caFPPosY, y.T_caFPPosY) annotation (Line(
          points={{92,-60},{92,-80},{5.55112e-16,-80},{5.55112e-16,-100}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(T_anFPX, y.T_anFPX) annotation (Line(
          points={{112,-60},{112,-80},{5.55112e-16,-80},{5.55112e-16,-100}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(T_caFPX, y.T_caFPX) annotation (Line(
          points={{132,-60},{132,-80},{5.55112e-16,-80},{5.55112e-16,-100}},
          color={0,0,127},
          smooth=Smooth.None));

      connect(J, y.J) annotation (Line(
          points={{152,-60},{152,-80},{5.55112e-16,-80},{5.55112e-16,-100}},
          color={0,0,127},
          smooth=Smooth.None));

      annotation (
        Commands(file="tests/LOOCV/LOOCV.mos"
            "Perform leave-one-out cross validation on the cell model"),
        Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-180,-100},
                {180,100}}),graphics),
        experiment(StopTime=15481, Algorithm="Euler"),
        experimentSetupOutput);
    end Replay;

    package BaseClasses "Base classes (not for direct use)"
      extends Modelica.Icons.BasesPackage;
      partial model PartialTestStand "Partial test stand"
        extends FCSys.BaseClasses.Icons.Names.Top9;
        final parameter Integer n_x_an=1
          "<html>Number of subregions along the through-cell axis in anode FP (<i>n</i><sub>x an</sub>)</html>";
        final parameter Integer n_x_ca=1
          "<html>Number of subregions along the through-cell axis in anode FP (<i>n</i><sub>x ca</sub>)</html>";
        final parameter Integer n_y=1
          "<html>Number of subregions along the channel (<i>n</i><sub>y</sub>)</html>";
        final parameter Integer n_z=1
          "<html>Number of subregions across the channel (<i>n</i><sub>z</sub>)</html>";

        parameter Boolean inclIO=false "true, if input and output are included"
          annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true));

        FCSys.Connectors.FaceBus anEnd[n_y, n_z] "Anode end plate" annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-160,0}), iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={-160,0})));
        FCSys.Connectors.FaceBus caEnd[n_y, n_z] "Cathode end plate"
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={160,0}),iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={162,0})));
        FCSys.Connectors.FaceBus anSource[n_x_an, n_z] "Anode source"
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-40,-160}),iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={-40,-160})));
        FCSys.Connectors.FaceBus anSink[n_x_an, n_z] "Anode sink" annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-40,160}),iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={-40,160})));
        FCSys.Connectors.FaceBus caSource[n_x_ca, n_z] "Cathode source"
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={40,-160}), iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={40,160})));
        FCSys.Connectors.FaceBus caSink[n_x_ca, n_z] "Cathode sink" annotation
          (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={40,160}),iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={40,-160})));

        FCSys.BCs.FaceBus.SubregionClosed anEndBC[n_y, n_z](each final axis=
              FCSys.BaseClasses.Axis.x, each graphite(inclC=true, 'incle-'=true))
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={-136,0})));
        FCSys.BCs.FaceBus.SubregionClosed caEndBC[n_y, n_z](each final axis=
              FCSys.BaseClasses.Axis.x, each graphite(inclC=true, 'incle-'=true))
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={136,0})));
        FCSys.BCs.FaceBus.SubregionClosed anSourceBC[n_x_an, n_z](each final
            axis=FCSys.BaseClasses.Axis.y, each gas(inclH2=true, inclH2O=true))
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-40,-136})));
        FCSys.BCs.FaceBus.SubregionClosed anSinkBC[n_x_an, n_z](each final axis
            =FCSys.BaseClasses.Axis.y, each gas(inclH2=true, inclH2O=true))
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=180,
              origin={-40,136})));
        FCSys.BCs.FaceBus.SubregionClosed caSourceBC[n_x_ca, n_z](each final
            axis=FCSys.BaseClasses.Axis.y, each gas(
            inclH2O=true,
            inclN2=true,
            inclO2=true)) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={40,-136})));
        FCSys.BCs.FaceBus.SubregionClosed caSinkBC[n_x_ca, n_z](each final axis
            =FCSys.BaseClasses.Axis.y, each gas(
            inclH2O=true,
            inclN2=true,
            inclO2=true)) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=180,
              origin={40,136})));
        FCSys.Connectors.RealInputBus u[n_y, n_z] if inclIO annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=315,
              origin={-160,160})));
        FCSys.Connectors.RealOutputBus y[n_y, n_z] if inclIO annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=315,
              origin={160,-160})));
        replaceable FCSys.BCs.FaceBusDifferential.Subregion current[n_y, n_z](
            each final axis=FCSys.BaseClasses.Axis.x, graphite(
            inclC=true,
            C(thermoOpt=ThermoOpt.ClosedAdiabatic),
            'incle-'=true,
            'e-'(thermoOpt=ThermoOpt.OpenDiabatic))) if inclIO constrainedby
          FCSys.BCs.FaceBusDifferential.Subregion(graphite(
            inclC=true,
            C(thermoOpt=ThermoOpt.ClosedAdiabatic),
            'incle-'=true,
            'e-'(thermoOpt=ThermoOpt.OpenDiabatic)))
          annotation (Placement(transformation(extent={{-140,20},{-120,40}})));

        replaceable FCSys.Sensors.FaceBusDifferential.Subregion voltage[n_y,
          n_z](each final axis=FCSys.BaseClasses.Axis.x) if inclIO
          annotation (Placement(transformation(extent={{120,-40},{140,-20}})));
      equation

        connect(anSourceBC.face, anSource) annotation (Line(
            points={{-40,-140},{-40,-160}},
            color={127,127,127},
            thickness=0.5,
            smooth=Smooth.None));

        connect(anSinkBC.face, anSink) annotation (Line(
            points={{-40,140},{-40,160}},
            color={127,127,127},
            thickness=0.5,
            smooth=Smooth.None));

        connect(caSourceBC.face, caSource) annotation (Line(
            points={{40,-140},{40,-160}},
            color={127,127,127},
            thickness=0.5,
            smooth=Smooth.None));

        connect(caSinkBC.face, caSink) annotation (Line(
            points={{40,140},{40,160}},
            color={127,127,127},
            thickness=0.5,
            smooth=Smooth.None));

        connect(caEndBC.face, caEnd) annotation (Line(
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
            points={{-160,160},{-130,130},{-130,34}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));
        connect(voltage.negative, anEndBC.face) annotation (Line(
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

        connect(anEndBC.face, anEnd) annotation (Line(
            points={{-140,1.23436e-15},{-140,5.55112e-16},{-160,5.55112e-16}},
            color={127,127,127},
            thickness=0.5,
            smooth=Smooth.None));
        annotation (
          defaultComponentName="testStand",
          Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,-160},
                  {160,160}}), graphics),
          Icon(coordinateSystem(preserveAspectRatio=true, extent={{-160,-160},{
                  160,160}}), graphics={Rectangle(
                      extent={{-160,160},{160,-160}},
                      lineColor={191,191,191},
                      fillColor={255,255,255},
                      fillPattern=FillPattern.Backward),Rectangle(extent={{-160,
                160},{160,-160}}, lineColor={0,0,0})}));
      end PartialTestStand;

      partial model PartialTestStandNoIO "Partial test stand"
        extends FCSys.BaseClasses.Icons.Names.Top9;
        final parameter Integer n_x_an=1
          "<html>Number of subregions along the through-cell axis in anode FP (<i>n</i><sub>x an</sub>)</html>";
        final parameter Integer n_x_ca=1
          "<html>Number of subregions along the through-cell axis in anode FP (<i>n</i><sub>x ca</sub>)</html>";
        final parameter Integer n_y=1
          "<html>Number of subregions along the channel (<i>n</i><sub>y</sub>)</html>";
        final parameter Integer n_z=1
          "<html>Number of subregions across the channel (<i>n</i><sub>z</sub>)</html>";

        FCSys.BCs.FaceBus.SubregionClosed anEnd[n_y, n_z](each final axis=FCSys.BaseClasses.Axis.x,
            each graphite(
            inclC=true,
            'incle-'=true,
            'e-'(redeclare FCSys.BCs.Face.Material.Current material, redeclare
                Modelica.Blocks.Sources.Ramp materialSpec(height=1*U.A,
                  duration=50)))) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-30,0})));
        FCSys.BCs.FaceBus.SubregionClosed caEnd[n_y, n_z](each final axis=FCSys.BaseClasses.Axis.x,
            each graphite(
            inclC=true,
            'incle-'=true,
            'e-'(redeclare FCSys.BCs.Face.Material.Current material, redeclare
                Modelica.Blocks.Sources.Ramp materialSpec(height=-1*U.A,
                  duration=50)))) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={30,0})));
        FCSys.BCs.FaceBus.SubregionClosed anSource[n_x_an, n_z](each final axis
            =FCSys.BaseClasses.Axis.y, each gas(inclH2=true, inclH2O=true))
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=180,
              origin={-20,-30})));
        FCSys.BCs.FaceBus.SubregionClosed anSink[n_x_an, n_z](each final axis=
              FCSys.BaseClasses.Axis.y,each gas(inclH2=true, inclH2O=true))
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={-20,30})));
        FCSys.BCs.FaceBus.SubregionClosed caSource[n_x_ca, n_z](each final axis
            =FCSys.BaseClasses.Axis.y, each gas(
            inclH2O=true,
            inclN2=true,
            inclO2=true)) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=180,
              origin={20,-30})));
        FCSys.BCs.FaceBus.SubregionClosed caSink[n_x_ca, n_z](each final axis=
              FCSys.BaseClasses.Axis.y,each gas(
            inclH2O=true,
            inclN2=true,
            inclO2=true)) annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=0,
              origin={20,30})));

        inner Defaults defaults
          annotation (Placement(transformation(extent={{50,20},{70,40}})));
      equation

        annotation (
          defaultComponentName="testStand",
          Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                  {100,100}}), graphics),
          Icon(coordinateSystem(preserveAspectRatio=true, extent={{-160,-160},{
                  160,160}}), graphics));
      end PartialTestStandNoIO;
    end BaseClasses;
  end TestStands;

  package ChemicalBus
    "<html>BCs for the <a href=\"modelica://FCSys.Connectors.ChemicalBus\">ChemicalBus</a> connector</html>"
    extends Modelica.Icons.Package;

    model Gas "BC for gas"

      extends BaseClasses.NullPhase;

      // Conditionally include species.
      parameter Boolean inclH2=false "<html>Hydrogen (H<sub>2</sub>)</html>"
        annotation (
        Evaluate=true,
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          __Dymola_joinNext=true));
      Chemical.Species H2(
        final inclLinX=inclLinX,
        final inclLinY=inclLinY,
        final inclLinZ=inclLinZ,
        redeclare package Data = FCSys.Characteristics.H2.Gas) if inclH2
        "Model" annotation (Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          enable=inclH2), Placement(transformation(extent={{-10,-10},{10,10}})));

      parameter Boolean inclH2O=false "<html>Water (H<sub>2</sub>O)</html>"
        annotation (
        Evaluate=true,
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          __Dymola_joinNext=true));
      Chemical.Species H2O(
        final inclLinX=inclLinX,
        final inclLinY=inclLinY,
        final inclLinZ=inclLinZ,
        redeclare package Data = FCSys.Characteristics.H2O.Gas) if inclH2O
        "Model" annotation (Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          enable=inclH2O), Placement(transformation(extent={{-10,-10},{10,10}})));

      parameter Boolean inclN2=false "<html>Nitrogen (N<sub>2</sub>)</html>"
        annotation (
        Evaluate=true,
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          __Dymola_joinNext=true));
      Chemical.Species N2(
        final inclLinX=inclLinX,
        final inclLinY=inclLinY,
        final inclLinZ=inclLinZ,
        redeclare package Data = FCSys.Characteristics.N2.Gas) if inclN2
        "Model" annotation (Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          enable=inclN2), Placement(transformation(extent={{-10,-10},{10,10}})));

      parameter Boolean inclO2=false "<html>Oxygen (O<sub>2</sub>)</html>"
        annotation (
        Evaluate=true,
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          __Dymola_joinNext=true));
      Chemical.Species O2(
        final inclLinX=inclLinX,
        final inclLinY=inclLinY,
        final inclLinZ=inclLinZ,
        redeclare package Data = FCSys.Characteristics.O2.Gas) if inclO2
        "Model" annotation (Dialog(
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
          points={{-5.08852e-16,-4},{5.55112e-16,-40}},
          color={208,104,0},
          smooth=Smooth.None));
      connect(u.H2, H2.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,14},{-5.08852e-16,14},{-5.08852e-16,
              4}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

      // H2O
      connect(H2O.chemical, chemical.H2O) annotation (Line(
          points={{-5.08852e-16,-4},{5.55112e-16,-40}},
          color={208,104,0},
          smooth=Smooth.None));
      connect(u.H2O, H2O.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,14},{-5.08852e-16,14},{-5.08852e-16,
              4}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

      // N2
      connect(N2.chemical, chemical.N2) annotation (Line(
          points={{-5.08852e-16,-4},{5.55112e-16,-40}},
          color={208,104,0},
          smooth=Smooth.None));
      connect(u.N2, N2.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,14},{-5.08852e-16,14},{-5.08852e-16,
              4}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

      // O2
      connect(O2.chemical, chemical.O2) annotation (Line(
          points={{-5.08852e-16,-4},{5.55112e-16,-40}},
          color={208,104,0},
          smooth=Smooth.None));
      connect(u.O2, O2.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,14},{-5.08852e-16,14},{-5.08852e-16,
              4}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

    end Gas;

    model Graphite "BC for graphite"

      extends BaseClasses.NullPhase;

      // Conditionally include species.
      parameter Boolean inclC=false "Carbon (C)" annotation (
        Evaluate=true,
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          __Dymola_joinNext=true));
      Chemical.Species C(
        final inclLinX=inclLinX,
        final inclLinY=inclLinY,
        final inclLinZ=inclLinZ,
        redeclare package Data = FCSys.Characteristics.C.Graphite) if inclC
        "Model" annotation (Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          enable=inclC), Placement(transformation(extent={{-10,-10},{10,10}})));

      parameter Boolean 'incle-'=false "<html>Electrons (e<sup>-</sup>)</html>"
        annotation (
        Evaluate=true,
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          __Dymola_joinNext=true));
      Chemical.Species 'e-'(
        final inclLinX=inclLinX,
        final inclLinY=inclLinY,
        final inclLinZ=inclLinZ,
        redeclare package Data = FCSys.Characteristics.'e-'.Graphite) if
        'incle-' "Model" annotation (Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          enable='incle-'), Placement(transformation(extent={{-10,-10},{10,10}})));

    equation
      // C
      connect(C.chemical, chemical.C) annotation (Line(
          points={{-5.08852e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
          color={208,104,0},
          smooth=Smooth.None));
      connect(u.C, C.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,14},{-5.08852e-16,14},{-5.08852e-16,
              4}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

      // e-
      connect('e-'.chemical, chemical.'e-') annotation (Line(
          points={{-5.08852e-16,-4},{5.55112e-16,-40}},
          color={208,104,0},
          smooth=Smooth.None));
      connect(u.'e-', 'e-'.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,14},{-5.08852e-16,14},{-5.08852e-16,
              4}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

    end Graphite;

    model Ionomer "BC for ionomer"

      extends BaseClasses.NullPhase;

      // Conditionally include species.
      parameter Boolean inclC19HF37O5S=false
        "<html>Nafion sulfonate (C<sub>19</sub>HF<sub>37</sub>O<sub>5</sub>S)</html>"
        annotation (
        Evaluate=true,
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          __Dymola_joinNext=true));
      Chemical.Species C19HF37O5S(
        final inclLinX=inclLinX,
        final inclLinY=inclLinY,
        final inclLinZ=inclLinZ,
        redeclare package Data = FCSys.Characteristics.C19HF37O5S.Solid) if
        inclC19HF37O5S "Model" annotation (Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          enable=inclC19HF37O5S), Placement(transformation(extent={{-10,-10},{
                10,10}})));
      parameter Boolean inclH2O=false "<html>Water (H<sub>2</sub>O)</html>"
        annotation (
        Evaluate=true,
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          __Dymola_joinNext=true));
      Chemical.Species H2O(
        final inclLinX=inclLinX,
        final inclLinY=inclLinY,
        final inclLinZ=inclLinZ,
        redeclare package Data = FCSys.Characteristics.H2O.Gas) if inclH2O
        "Model" annotation (Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          enable=inclH2O), Placement(transformation(extent={{-10,-10},{10,10}})));
      parameter Boolean 'inclH+'=false "<html>Protons (H<sup>+</sup>)</html>"
        annotation (
        Evaluate=true,
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          __Dymola_joinNext=true));
      Chemical.Species 'H+'(
        final inclLinX=inclLinX,
        final inclLinY=inclLinY,
        final inclLinZ=inclLinZ,
        redeclare package Data = FCSys.Characteristics.'H+'.Solid) if 'inclH+'
        "Model" annotation (Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          enable='inclH+'), Placement(transformation(extent={{-10,-10},{10,10}})));

    equation
      // C19HF37O5S
      connect(C19HF37O5S.chemical, chemical.C19HF37O5S) annotation (Line(
          points={{-5.08852e-16,-4},{5.55112e-16,-40}},
          color={208,104,0},
          smooth=Smooth.None));
      connect(u.C19HF37O5S, C19HF37O5S.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,14},{-5.08852e-16,14},{-5.08852e-16,
              4}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

      // H2O
      connect(H2O.chemical, chemical.H2O) annotation (Line(
          points={{-5.08852e-16,-4},{5.55112e-16,-40}},
          color={208,104,0},
          smooth=Smooth.None));
      connect(u.H2O, H2O.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,14},{-5.08852e-16,14},{-5.08852e-16,
              4}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

      // H+
      connect('H+'.chemical, chemical.'H+') annotation (Line(
          points={{-5.08852e-16,-4},{5.55112e-16,-40}},
          color={208,104,0},
          smooth=Smooth.None));
      connect(u.'H+', 'H+'.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,14},{-5.08852e-16,14},{-5.08852e-16,
              4}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

    end Ionomer;

    model Liquid "BC for liquid"

      extends BaseClasses.NullPhase;

      // Conditionally include species.
      parameter Boolean inclH2O=false "<html>Water (H<sub>2</sub>O)</html>"
        annotation (
        Evaluate=true,
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          __Dymola_joinNext=true));
      Chemical.Species H2O(
        final inclLinX=inclLinX,
        final inclLinY=inclLinY,
        final inclLinZ=inclLinZ,
        redeclare package Data = FCSys.Characteristics.H2O.Liquid) if inclH2O
        "Model" annotation (Dialog(
          group="Species",
          __Dymola_descriptionLabel=true,
          enable=inclH2O), Placement(transformation(extent={{-10,-10},{10,10}})));

    equation
      // H2O
      connect(H2O.chemical, chemical.H2O) annotation (Line(
          points={{-5.08852e-16,-4},{5.55112e-16,-40}},
          color={208,104,0},
          smooth=Smooth.None));
      connect(u.H2O, H2O.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,14},{-5.08852e-16,14},{-5.08852e-16,
              4}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

    end Liquid;

    package BaseClasses "Base classes (not for direct use)"
      extends Modelica.Icons.BasesPackage;

      model NullPhase "Empty BC for a phase (no species)"
        extends FCSys.BaseClasses.Icons.BCs.Single;

        parameter Boolean inclLinX=true "X" annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Axes with linear momentum included", compact=true));
        parameter Boolean inclLinY=false "Y" annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Axes with linear momentum included", compact=true));
        parameter Boolean inclLinZ=false "Z" annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Axes with linear momentum included", compact=true));

        FCSys.Connectors.ChemicalBus chemical
          "Multi-species connector for material"
          annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

        FCSys.Connectors.RealInputBus u "Bus of inputs to specify conditions"
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={0,40})));

      end NullPhase;
    end BaseClasses;
  end ChemicalBus;

  package Chemical
    "<html>BCs for the <a href=\"modelica://FCSys.Connectors.ChemicalOutput\">ChemicalOutput</a> connector</html>"
    extends Modelica.Icons.Package;

    model Species
      "<html>BCs for the <a href=\"modelica://FCSys.Connectors.ChemicalOutput\">ChemicalOutput</a> connector</html>"

      import FCSys.BCs.Chemical.BaseClasses.BCTypeMaterial;
      import FCSys.BCs.Chemical.BaseClasses.BCTypeMechanical;
      import FCSys.BCs.Chemical.BaseClasses.BCTypeFluid;
      extends FCSys.BaseClasses.Icons.BCs.Single;

      replaceable package Data =
          FCSys.Characteristics.BaseClasses.Characteristic constrainedby
        FCSys.Characteristics.BaseClasses.Characteristic
        "Characteristic data of the species" annotation (
          __Dymola_choicesAllMatching=true, Placement(transformation(extent={{-60,
                40},{-40,60}}), iconTransformation(extent={{-10,90},{10,110}})));

      // Material
      parameter BCTypeMaterial material=BCTypeMaterial.PotentialElectrochemicalPerTemperature
        "Type of BC"
        annotation (Dialog(group="Material", __Dymola_descriptionLabel=true));
      parameter Boolean internalMaterial=true "Use internal specification"
        annotation (
        Evaluate=true,
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Material",
          __Dymola_descriptionLabel=true,
          __Dymola_joinNext=true));
      replaceable Modelica.Blocks.Sources.Constant materialSpec(k(start=Data.g(
              298.15*U.K)/(298.15*U.K))) if internalMaterial constrainedby
        Modelica.Blocks.Interfaces.SO "Internal specification" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(
          group="Material",
          __Dymola_descriptionLabel=true,
          enable=internalMaterial),
        Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-90,10})));

      // X component of linear momentum
      parameter Boolean inclLinX=true "Include" annotation (
        Evaluate=true,
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="X component of linear momentum",
          __Dymola_descriptionLabel=true,
          compact=true));
      parameter BCTypeMechanical linXBC=BCTypeMechanical.Velocity "Type of BC"
        annotation (Dialog(
          group="X component of linear momentum",
          enable=inclLinX,
          __Dymola_descriptionLabel=true));
      parameter Boolean internalLinX=true "Use internal specification"
        annotation (
        Evaluate=true,
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="X component of linear momentum",
          enable=inclLinX,
          __Dymola_descriptionLabel=true,
          __Dymola_joinNext=true));
      replaceable Modelica.Blocks.Sources.Constant linXSpec(k(start=0)) if
        inclLinX and internalLinX constrainedby Modelica.Blocks.Interfaces.SO
        "Internal specification" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(
          group="X component of linear momentum",
          __Dymola_descriptionLabel=true,
          enable=inclLinX and internalLinX),
        Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-50,10})));

      // Y component of linear momentum
      parameter Boolean inclLinY=false "Include" annotation (
        Evaluate=true,
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Y component of linear momentum",
          __Dymola_descriptionLabel=true,
          compact=true));
      parameter BCTypeMechanical linYBC=BCTypeMechanical.Velocity "Type of BC"
        annotation (Dialog(
          group="Y component of linear momentum",
          enable=inclLinY,
          __Dymola_descriptionLabel=true));
      parameter Boolean internalLinY=true "Use internal specification"
        annotation (
        Evaluate=true,
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Y component of linear momentum",
          enable=inclLinY,
          __Dymola_descriptionLabel=true,
          __Dymola_joinNext=true));
      replaceable Modelica.Blocks.Sources.Constant linYSpec(k(start=0)) if
        inclLinY and internalLinY constrainedby Modelica.Blocks.Interfaces.SO
        "Internal specification" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(
          group="Y component of linear momentum",
          enable=inclLinY and internalLinY,
          __Dymola_descriptionLabel=true,
          enable=internalLinY),
        Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={30,10})));

      // Z component of linear momentum
      parameter Boolean inclLinZ=false "Include" annotation (
        Evaluate=true,
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Z component of linear momentum",
          __Dymola_descriptionLabel=true,
          compact=true));
      parameter BCTypeMechanical linZBC=BCTypeMechanical.Velocity "Type of BC"
        annotation (Dialog(
          group="Z component of linear momentum",
          enable=inclLinZ,
          __Dymola_descriptionLabel=true));
      parameter Boolean internalLinZ=true "Use internal specification"
        annotation (
        Evaluate=true,
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Z component of linear momentum",
          enable=inclLinZ,
          __Dymola_descriptionLabel=true,
          __Dymola_joinNext=true));
      replaceable Modelica.Blocks.Sources.Constant linZSpec(k(start=0)) if
        inclLinZ and internalLinZ constrainedby Modelica.Blocks.Interfaces.SO
        "Internal specification" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(
          group="Z component of linear momentum",
          enable=inclLinZ and internalLinZ,
          __Dymola_descriptionLabel=true,
          enable=internalLinZ),
        Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-10,10})));

      // Enthalpy
      parameter BCTypeMechanical fluidBC=BCTypeFluid.EnthalpyMassic
        "Type of BC"
        annotation (Dialog(group="Enthalpy", __Dymola_descriptionLabel=true));
      parameter Boolean internalFluid=true "Use internal specification"
        annotation (
        Evaluate=true,
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Enthalpy",
          __Dymola_descriptionLabel=true,
          __Dymola_joinNext=true));
      replaceable Modelica.Blocks.Sources.Constant fluidSpec(k(start=Data.h()/
              Data.m)) if internalFluid constrainedby
        Modelica.Blocks.Interfaces.SO "Internal specification" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(
          group="Enthalpy",
          __Dymola_descriptionLabel=true,
          enable=internalFluid),
        Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={70,10})));

      FCSys.Connectors.ChemicalOutput chemical(
        final n_lin=n_lin,
        final formula=Data.formula,
        final m=Data.m)
        "Single-species connector for material, with advection of linear momentum and enthalpy"
        annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
      FCSys.Connectors.RealInputBus u "Bus of inputs to specify conditions"
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,60}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,40})));

    protected
      final parameter Integer n_lin=countTrue({inclLinX,inclLinY,inclLinZ})
        "Number of components of linear momentum" annotation (Evaluate=true);

      FCSys.Connectors.RealInputInternal u_material(final unit=if material ==
            BCTypeMaterial.PotentialElectrochemicalPerTemperature then "1"
             else "N/T") if not internalMaterial "Material signal" annotation (
          Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-70,30}),iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,40})));
      FCSys.Connectors.RealInputInternal u_lin_x(final unit="l/T") if not
        internalLinX and inclLinX
        "Signal for the x component of linear momentum" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-30,30}),iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,40})));
      FCSys.Connectors.RealInputInternal u_lin_y(final unit="l/T") if not
        internalLinY and inclLinY
        "Signal for the y component of linear momentum" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={10,30}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,40})));
      FCSys.Connectors.RealInputInternal u_lin_z(final unit="l/T") if not
        internalLinZ and inclLinZ
        "Signal for the z component of linear momentum" annotation (Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={50,30}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,40})));
      FCSys.Connectors.RealInputInternal u_fluid(final unit="l2/T2") if not
        internalFluid "Fluid signal" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={90,30}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,40})));
      FCSys.Connectors.RealInputInternal u_material_int
        "Internal material signal" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={-70,-20}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,40})));
      FCSys.Connectors.RealInputInternal u_lin_int[n_lin]
        "Internal mechanical signal" annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={10,-20}),iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,40})));
      FCSys.Connectors.RealInputInternal u_fluid_int "Internal fluid signal"
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={90,-20}),iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,40})));

    equation
      // Material
      if material == BCTypeMaterial.PotentialElectrochemicalPerTemperature then
        chemical.muPerT = u_material_int;
      else
        chemical.Ndot = u_material_int;
      end if;

      // X component of linear momentum
      if inclLinX then
        //  if linXBC == BCTypeMechanical.Velocity then
        chemical.phi[1] = u_lin_int[1];
        //  end if;
      end if;

      // Y component of linear momentum
      if inclLinY then
        //  if linYBC == BCTypeMechanical.Velocity then
        chemical.phi[2] = u_lin_int[2];
        //  end if;
      end if;

      // Z component of linear momentum
      if inclLinZ then
        //  if linZBC == BCTypeMechanical.Velocity then
        chemical.phi[3] = u_lin_int[3];
        //  end if;
      end if;

      // Enthalpy
      //  if fluidBC== BCTypeFluid.EnthalpyMassic then
      chemical.hbar = u_fluid_int;
      //  end if;

      connect(u.material, u_material) annotation (Line(
          points={{5.55112e-16,60},{5.55112e-16,40},{-70,40},{-70,30}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(u.linX, u_lin_x) annotation (Line(
          points={{5.55112e-16,60},{5.55112e-16,40},{-30,40},{-30,30}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(u.linY, u_lin_y) annotation (Line(
          points={{5.55112e-16,60},{5.55112e-16,40},{10,40},{10,30}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(u.linZ, u_lin_z) annotation (Line(
          points={{5.55112e-16,60},{5.55112e-16,40},{50,40},{50,30}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(u.fluid, u_fluid) annotation (Line(
          points={{5.55112e-16,60},{5.55112e-16,40},{90,40},{90,30}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));
      connect(u_material_int, u_material) annotation (Line(
          points={{-70,-20},{-70,30}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(u_lin_x, u_lin_int[1]) annotation (Line(
          points={{-30,30},{-30,-8},{10,-8},{10,-20}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(u_lin_y, u_lin_int[2]) annotation (Line(
          points={{10,30},{10,-20}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(u_lin_z, u_lin_int[3]) annotation (Line(
          points={{50,30},{50,-8},{10,-8},{10,-20}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(u_fluid, u_fluid_int) annotation (Line(
          points={{90,30},{90,-20}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(materialSpec.y, u_material_int) annotation (Line(
          points={{-90,-1},{-90,-8},{-70,-8},{-70,-20}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(linXSpec.y, u_lin_int[1]) annotation (Line(
          points={{-50,-1},{-50,-8},{10,-8},{10,-20}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(linYSpec.y, u_lin_int[2]) annotation (Line(
          points={{30,-1},{30,-8},{10,-8},{10,-20}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(linZSpec.y, u_lin_int[3]) annotation (Line(
          points={{-10,-1},{-10,-8},{10,-8},{10,-20}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(fluidSpec.y, u_fluid_int) annotation (Line(
          points={{70,-1},{70,-8},{90,-8},{90,-20}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-120,
                -100},{120,100}}), graphics), Icon(coordinateSystem(
              preserveAspectRatio=true, extent={{-120,-100},{120,100}}),
            graphics));
    end Species;

    package BaseClasses "Base classes (not for direct use)"
      extends Modelica.Icons.BasesPackage;
      type BCTypeMaterial = enumeration(
          PotentialElectrochemicalPerTemperature
            "Prescribed quotient of electrochemical potential and temperature",

          Current "Prescribed current") "Types of material BCs";

      type BCTypeMechanical = enumeration(
          Velocity "Prescribed velocity") "Types of mechanical BCs";
      type BCTypeFluid = enumeration(
          EnthalpyMassic "Prescribed massic enthalpy") "Types of fluid BCs";
    end BaseClasses;
  end Chemical;

  package InertAmagat
    "<html>BCs for the <a href=\"modelica://FCSys.Connectors.InertAmagat\">InertAmagat</a> connector</html>"
    extends Modelica.Icons.Package;

    model Phase
      "<html>BC for the <a href=\"modelica://FCSys.Connectors.InertAmagat\">InertAmagat</a> connector, e.g., of a <a href=\"modelica://FCSys.Subregions.Phases\">Phase</a> model</html>"
      extends FCSys.BaseClasses.Icons.BCs.Single;

      // Volume
      replaceable Volume.Volume volumeBC(
        final inclLinX=inclLinX,
        final inclLinY=inclLinY,
        final inclLinZ=inclLinZ) constrainedby Volume.BaseClasses.PartialBC
        "Condition" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Volume",__Dymola_descriptionLabel=true),
        Placement(transformation(extent={{-90,-14},{-70,6}})));

      // X component of linear momentum
      parameter Boolean inclLinX=true "Include" annotation (
        Evaluate=true,
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="X component of linear momentum",
          __Dymola_descriptionLabel=true,
          compact=true));
      replaceable Mechanical.Force linXBC(
        final inclLinX=inclLinX,
        final inclLinY=inclLinY,
        final inclLinZ=inclLinZ) if inclLinX constrainedby
        Mechanical.BaseClasses.PartialBC "Condition" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(
          group="X component of linear momentum",
          enable=inclLinX,
          __Dymola_descriptionLabel=true),
        Placement(transformation(extent={{-50,-14},{-30,6}})));

      // Y component of linear momentum
      parameter Boolean inclLinY=true "Include" annotation (
        Evaluate=true,
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Y component of linear momentum",
          __Dymola_descriptionLabel=true,
          compact=true));
      replaceable Mechanical.Force linYBC(
        final inclLinX=inclLinX,
        final inclLinY=inclLinY,
        final inclLinZ=inclLinZ) if inclLinY constrainedby
        Mechanical.BaseClasses.PartialBC "Condition" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(
          group="Y component of linear momentum",
          enable=inclLinY,
          __Dymola_descriptionLabel=true),
        Placement(transformation(extent={{-10,-14},{10,6}})));

      // Z component of linear momentum
      parameter Boolean inclLinZ=true "Include" annotation (
        Evaluate=true,
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Z component of linear momentum",
          __Dymola_descriptionLabel=true,
          compact=true));
      replaceable Mechanical.Force linZBC(
        final inclLinX=inclLinX,
        final inclLinY=inclLinY,
        final inclLinZ=inclLinZ) if inclLinZ constrainedby
        Mechanical.BaseClasses.PartialBC "Condition" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(
          group="Z component of linear momentum",
          enable=inclLinZ,
          __Dymola_descriptionLabel=true),
        Placement(transformation(extent={{30,-14},{50,6}})));

      // Heat
      replaceable Thermal.HeatFlowRate thermal(
        final inclLinX=inclLinX,
        final inclLinY=inclLinY,
        final inclLinZ=inclLinZ) constrainedby Thermal.BaseClasses.PartialBC
        "Condition" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Heat",__Dymola_descriptionLabel=true),
        Placement(transformation(extent={{70,-14},{90,6}})));

      FCSys.Connectors.RealInputBus u "Input bus for external signal sources"
        annotation (HideResult=not (internalVolume or internalLinX or
            internalLinY or internalLinZ or internalThermal), Placement(
            transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,40}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={2,40})));

      FCSys.Connectors.InertAmagat inert(final n_lin=countTrue({inclLinX,
            inclLinY,inclLinZ}))
        "Single-species connector for linear momentum and heat, with additivity of pressure"
        annotation (Placement(transformation(extent={{-10,-50},{10,-30}}),
            iconTransformation(extent={{-10,-50},{10,-30}})));

    equation
      // Volume
      connect(volumeBC.inert, inert) annotation (Line(
          points={{-80,-8},{-80,-20},{5.55112e-16,-20},{5.55112e-16,-40}},
          color={72,90,180},
          smooth=Smooth.None));
      connect(u.volume, volumeBC.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,20},{-80,20},{-80,6.66134e-16}},

          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));

      // X component of linear momentum
      connect(linXBC.inert, inert) annotation (Line(
          points={{-40,-8},{-40,-20},{5.55112e-16,-20},{5.55112e-16,-40}},
          color={72,90,180},
          smooth=Smooth.None));
      connect(u.linX, linXBC.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,20},{-40,20},{-40,6.66134e-16}},

          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));

      // Y component of linear momentum
      connect(linYBC.inert, inert) annotation (Line(
          points={{6.10623e-16,-8},{6.10623e-16,-20},{5.55112e-16,-20},{
              5.55112e-16,-40}},
          color={72,90,180},
          smooth=Smooth.None));
      connect(u.linY, linYBC.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,6.66134e-16},{6.10623e-16,
              6.66134e-16}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));

      // Z component of linear momentum
      connect(linZBC.inert, inert) annotation (Line(
          points={{40,-8},{40,-20},{5.55112e-16,-20},{5.55112e-16,-40}},
          color={72,90,180},
          smooth=Smooth.None));
      connect(u.linZ, linZBC.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,20},{40,20},{40,6.66134e-16}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));

      // Heat
      connect(thermal.inert, inert) annotation (Line(
          points={{80,-8},{80,-20},{5.55112e-16,-20},{5.55112e-16,-40}},
          color={72,90,180},
          smooth=Smooth.None));
      connect(u.thermal, thermal.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,20},{80,20},{80,6.66134e-16}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));

    end Phase;

    package Volume "BCs for additivity of volume"
      extends Modelica.Icons.Package;

      model Pressure "Prescribed pressure"
        extends BaseClasses.PartialBC(
          final bCType=BaseClasses.BCType.Pressure,
          u(final unit="m/(l.T2)"),
          spec(k(start=1*U.atm)));

      equation
        inert.p = u_final;
        annotation (defaultComponentPrefixes="replaceable",defaultComponentName
            ="volumeBC");
      end Pressure;

      model Volume "Prescribed volume"
        extends BaseClasses.PartialBC(
          final bCType=BaseClasses.BCType.Volume,
          u(final unit="l3"),
          spec(k(start=1*U.cm^3)));
      equation
        inert.V = u_final;
        annotation (defaultComponentPrefixes="replaceable",defaultComponentName
            ="volumeBC");
      end Volume;

      package BaseClasses "Base classes (not for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialBC "Partial model for a BC for volume"
          extends FCSys.BCs.InertAmagat.BaseClasses.PartialBC;

          constant BCType bCType "Type of BC";
          // Note:  This is included so that the type of BC is recorded with the
          // results.

        equation
          inert.mPhidot = zeros(n_lin) "No force";
          inert.Qdot = 0 "Adiabatic";
          annotation (defaultComponentName="volumeBC");
        end PartialBC;

        type BCType = enumeration(
            Volume "Volume",
            Pressure "Pressure") "Types of BCs";
      end BaseClasses;
    end Volume;

    package Mechanical "Mechanical BCs"
      extends Modelica.Icons.Package;
      model Velocity "Prescribed velocity"
        extends BaseClasses.PartialBC(final bCType=BaseClasses.BCType.Velocity,
            u(final unit="l/T"));
      equation
        inert.phi[linAxes[axis]] = u_final;
        annotation (defaultComponentPrefixes="replaceable",defaultComponentName
            ="mechanicalBC");
      end Velocity;

      model Force "Prescribed force"
        extends BaseClasses.PartialBC(final bCType=BaseClasses.BCType.Force, u(
              final unit="l.m/T2"));
      equation
        inert.mPhidot[linAxes[axis]] = u_final;
        annotation (defaultComponentPrefixes="replaceable",defaultComponentName
            ="mechanicalBC");
      end Force;

      package BaseClasses "Base classes (not for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialBC "Partial model for a mechanical BC"
          extends FCSys.BCs.InertAmagat.BaseClasses.PartialBC;

          parameter Axis axis=Axis.x "Axis" annotation (HideResult=true);

          constant BCType bCType "Type of BC";
          // Note:  This is included so that the type of BC is recorded with the
          // results.

        protected
          final parameter Integer cartAxes[n_lin]=index({inclLinX,inclLinY,
              inclLinZ})
            "Cartesian-axis indices of the axes of linear momentum";
          final parameter Integer linAxes[Axis]=enumerate({inclLinX,inclLinY,
              inclLinZ})
            "Linear momentum component indices of the Cartesian axes";

        equation
          inert.V = 0 "No volume";
          for i in 1:n_lin loop
            if cartAxes[i] <> axis then
              inert.mPhidot[i] = 0 "No force along the other axes";
            end if;
          end for;
          inert.Qdot = 0 "Adiabatic";

          annotation (defaultComponentName="mechanicalBC");
        end PartialBC;

        type BCType = enumeration(
            Velocity "Velocity",
            Force "Force") "Types of BCs";
      end BaseClasses;
    end Mechanical;

    package Thermal "Thermal BCs"
      extends Modelica.Icons.Package;

      model Temperature "Prescribed temperature"
        extends BaseClasses.PartialBC(
          final bCType=BaseClasses.BCType.Temperature,
          u(final unit="l2.m/(N.T2)", displayUnit="K"),
          spec(k(start=298.15*U.K)));
      equation
        inert.T = u_final;
        annotation (defaultComponentPrefixes="replaceable",defaultComponentName
            ="thermal");
      end Temperature;

      model HeatFlowRate "Prescribed heat flow rate"
        extends BaseClasses.PartialBC(final bCType=BaseClasses.BCType.HeatFlowRate,
            u(final unit="l2.m/T3"));
      equation
        inert.Qdot = u_final;
        annotation (defaultComponentPrefixes="replaceable",defaultComponentName
            ="thermal");
      end HeatFlowRate;

      package BaseClasses "Base classes (not for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialBC "Partial model for a thermal BC"
          extends FCSys.BCs.InertAmagat.BaseClasses.PartialBC;

          constant BCType bCType "Type of BC";
          // Note:  This is included so that the type of BC is recorded with the
          // results.

        equation
          inert.V = 0 "No volume";
          inert.mPhidot = zeros(n_lin) "No force";
          annotation (defaultComponentName="thermal");
        end PartialBC;

        type BCType = enumeration(
            Temperature "Temperature",
            HeatFlowRate "Heat flow rate") "Types of BCs";
      end BaseClasses;
    end Thermal;

    package BaseClasses "Base classes (not for direct use)"
      extends Modelica.Icons.BasesPackage;
      partial model PartialBC "Partial model for a BC"
        extends FCSys.BaseClasses.Icons.BCs.Single;

        parameter Boolean inclLinX=true "X" annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Axes with linear momentum included", compact=true));
        parameter Boolean inclLinY=false "Y" annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Axes with linear momentum included", compact=true));
        parameter Boolean inclLinZ=false "Z" annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Axes with linear momentum included", compact=true));

        parameter Boolean internal=true "Use internal specification"
          annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(__Dymola_descriptionLabel=true));

        replaceable Modelica.Blocks.Sources.Constant spec if internal
          constrainedby Modelica.Blocks.Interfaces.SO "Internal specification"
          annotation (
          __Dymola_choicesFromPackage=true,
          Dialog(__Dymola_descriptionLabel=true, enable=internal),
          Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={-30,30})));

        FCSys.Connectors.RealInput u if not internal "Value of BC" annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={0,40})));
        FCSys.Connectors.InertAmagat inert(final n_lin=n_lin)
          "Connector for linear momentum and heat, with additivity of volume"
          annotation (HideResult=true, Placement(transformation(extent={{-10,-50},
                  {10,-30}})));

      protected
        final parameter Integer n_lin=countTrue({inclLinX,inclLinY,inclLinZ})
          "Number of components of linear momentum" annotation (Evaluate=true);

        FCSys.Connectors.RealInputInternal u_final "Final value of BC"
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={0,-10})));

      equation
        connect(u, u_final) annotation (Line(
            points={{5.55112e-16,40},{5.55112e-16,27.5},{5.55112e-16,27.5},{
                5.55112e-16,15},{5.55112e-16,-10},{5.55112e-16,-10}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(spec.y, u_final) annotation (Line(
            points={{-30,19},{-30,10},{5.55112e-16,10},{5.55112e-16,-10}},
            color={0,0,127},
            smooth=Smooth.None));

      end PartialBC;
    end BaseClasses;
  end InertAmagat;

  package InertDalton
    "<html>BCs for the <a href=\"modelica://FCSys.Connectors.InertDalton\">InertDalton</a> connector</html>"
    extends Modelica.Icons.Package;

    model Species
      "<html>BC for the <a href=\"modelica://FCSys.Connectors.InertDalton\">InertDalton</a> connector, e.g., of a <a href=\"modelica://FCSys.Subregions.Species\">Species</a> model</html>"

      extends FCSys.BaseClasses.Icons.BCs.Single;

      // Pressure
      replaceable Pressure.Volume pressureBC(
        final inclLinX=inclLinX,
        final inclLinY=inclLinY,
        final inclLinZ=inclLinZ) constrainedby Pressure.BaseClasses.PartialBC
        "Condition" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Pressure", __Dymola_descriptionLabel=true),
        Placement(transformation(extent={{-90,-14},{-70,6}})));

      // X component of linear momentum
      parameter Boolean inclLinX=true "Include" annotation (
        Evaluate=true,
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="X component of linear momentum",
          __Dymola_descriptionLabel=true,
          compact=true));
      replaceable Mechanical.Force linXBC(
        final inclLinX=inclLinX,
        final inclLinY=inclLinY,
        final inclLinZ=inclLinZ) if inclLinX constrainedby
        Mechanical.BaseClasses.PartialBC "Condition" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(
          group="X component of linear momentum",
          enable=inclLinX,
          __Dymola_descriptionLabel=true),
        Placement(transformation(extent={{-50,-14},{-30,6}})));

      // Y component of linear momentum
      parameter Boolean inclLinY=true "Include" annotation (
        Evaluate=true,
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Y component of linear momentum",
          __Dymola_descriptionLabel=true,
          compact=true));
      replaceable Mechanical.Force linYBC(
        final inclLinX=inclLinX,
        final inclLinY=inclLinY,
        final inclLinZ=inclLinZ) if inclLinY constrainedby
        Mechanical.BaseClasses.PartialBC "Condition" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(
          group="Y component of linear momentum",
          enable=inclLinY,
          __Dymola_descriptionLabel=true),
        Placement(transformation(extent={{-10,-14},{10,6}})));

      // Z component of linear momentum
      parameter Boolean inclLinZ=true "Include" annotation (
        Evaluate=true,
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          group="Z component of linear momentum",
          __Dymola_descriptionLabel=true,
          compact=true));
      replaceable Mechanical.Force linZBC(
        final inclLinX=inclLinX,
        final inclLinY=inclLinY,
        final inclLinZ=inclLinZ) if inclLinZ constrainedby
        Mechanical.BaseClasses.PartialBC "Condition" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(
          group="Z component of linear momentum",
          enable=inclLinZ,
          __Dymola_descriptionLabel=true),
        Placement(transformation(extent={{30,-14},{50,6}})));

      // Heat
      replaceable Thermal.HeatFlowRate thermal(
        final inclLinX=inclLinX,
        final inclLinY=inclLinY,
        final inclLinZ=inclLinZ) constrainedby Thermal.BaseClasses.PartialBC
        "Condition" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(group="Heat", __Dymola_descriptionLabel=true),
        Placement(transformation(extent={{70,-14},{90,6}})));

      FCSys.Connectors.RealInputBus u "Input bus for external signal sources"
        annotation (HideResult=not (internalVol or internalLinX or internalLinY
             or internalLinZ or internalThermal), Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,40}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,40})));

      FCSys.Connectors.InertDalton inert(final n_lin=countTrue({inclLinX,
            inclLinY,inclLinZ}))
        "Single-species connector for linear momentum and heat, with additivity of pressure"
        annotation (Placement(transformation(extent={{-10,-50},{10,-30}}),
            iconTransformation(extent={{-10,-50},{10,-30}})));

    equation
      // Pressure
      connect(pressureBC.inert, inert) annotation (Line(
          points={{-80,-8},{-80,-20},{5.55112e-16,-20},{5.55112e-16,-40}},
          color={72,90,180},
          smooth=Smooth.None));
      connect(u.pressure, pressureBC.u) annotation (Line(
          points={{5.55112e-16,40},{0,40},{0,20},{-80,20},{-80,6.66134e-16}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));

      // X component of linear momentum
      connect(linXBC.inert, inert) annotation (Line(
          points={{-40,-8},{-40,-20},{5.55112e-16,-20},{5.55112e-16,-40}},
          color={72,90,180},
          smooth=Smooth.None));
      connect(u.linX, linXBC.u) annotation (Line(
          points={{5.55112e-16,40},{0,40},{0,20},{-40,20},{-40,6.66134e-16}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));

      // Y component of linear momentum
      connect(linYBC.inert, inert) annotation (Line(
          points={{6.10623e-16,-8},{6.10623e-16,-20},{5.55112e-16,-20},{
              5.55112e-16,-40}},
          color={72,90,180},
          smooth=Smooth.None));
      connect(u.linY, linYBC.u) annotation (Line(
          points={{5.55112e-16,40},{0,40},{0,6.66134e-16},{6.10623e-16,
              6.66134e-16}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));

      // Z component of linear momentum
      connect(linZBC.inert, inert) annotation (Line(
          points={{40,-8},{40,-20},{5.55112e-16,-20},{5.55112e-16,-40}},
          color={72,90,180},
          smooth=Smooth.None));
      connect(u.linZ, linZBC.u) annotation (Line(
          points={{5.55112e-16,40},{0,40},{0,20},{40,20},{40,6.66134e-16}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));

      // Heat
      connect(thermal.inert, inert) annotation (Line(
          points={{80,-8},{80,-20},{5.55112e-16,-20},{5.55112e-16,-40}},
          color={72,90,180},
          smooth=Smooth.None));
      connect(u.thermal, thermal.u) annotation (Line(
          points={{5.55112e-16,40},{0,40},{0,20},{80,20},{80,6.66134e-16}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));

    end Species;

    package Pressure "BCs for additivity of pressure"
      extends Modelica.Icons.Package;

      model Volume "Prescribed volume"
        extends BaseClasses.PartialBC(final bCType=BaseClasses.BCType.Volume, u(
              final unit="l3"));
      equation
        inert.V = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="pressureBC");
      end Volume;

      model Pressure "Prescribed pressure"
        extends BaseClasses.PartialBC(final bCType=BaseClasses.BCType.Pressure,
            u(final unit="m/(l.T2)"));
      equation
        inert.p = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="pressureBC");
      end Pressure;

      package BaseClasses "Base classes (not for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialBC "Partial model for a BC for pressure"
          extends FCSys.BCs.InertDalton.BaseClasses.PartialBC;

          constant BCType bCType "Type of BC";
          // Note:  This is included so that the type of BC is recorded with the
          // results.
        equation
          inert.mPhidot = zeros(n_lin) "No force";
          inert.Qdot = 0 "No heat flow";
          annotation (defaultComponentName="pressureBC");
        end PartialBC;

        type BCType = enumeration(
            Volume "Volume",
            Pressure "Pressure") "Types of BCs";
      end BaseClasses;
    end Pressure;

    package Mechanical "Mechanical BCs"
      extends Modelica.Icons.Package;
      model Velocity "Prescribed velocity"
        extends BaseClasses.PartialBC(final bCType=BaseClasses.BCType.Velocity,
            u(final unit="l/T"));
      equation
        inert.phi[linAxes[axis]] = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="mechanicalBC");
      end Velocity;

      model Force "Prescribed force"
        extends BaseClasses.PartialBC(final bCType=BaseClasses.BCType.Force, u(
              final unit="l.m/T2"));
      equation
        inert.mPhidot[linAxes[axis]] = u_final;
        annotation (defaultComponentPrefixes="replaceable",defaultComponentName
            ="mechanicalBC");
      end Force;

      package BaseClasses "Base classes (not for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialBC "Partial model for a mechanical BC"
          extends FCSys.BCs.InertDalton.BaseClasses.PartialBC;

          parameter Axis axis=Axis.x "Axis" annotation (HideResult=true);

          constant BCType bCType "Type of BC";
          // Note:  This is included so that the type of BC is recorded with the
          // results.

        protected
          final parameter Integer cartAxes[n_lin]=index({inclLinX,inclLinY,
              inclLinZ})
            "Cartesian-axis indices of the axes of linear momentum";
          final parameter Integer linAxes[Axis]=enumerate({inclLinX,inclLinY,
              inclLinZ})
            "Linear momentum component indices of the Cartesian axes";

        equation
          inert.p = 0 "No pressure";
          for i in 1:n_lin loop
            if cartAxes[i] <> axis then
              inert.mPhidot[i] = 0 "No force along the other axes";
            end if;
          end for;
          inert.Qdot = 0 "Adiabatic";

          annotation (defaultComponentName="mechanicalBC");
        end PartialBC;

        type BCType = enumeration(
            Velocity "Velocity",
            Force "Force") "Types of BCs";
      end BaseClasses;
    end Mechanical;

    package Thermal "BCs for heat"
      extends Modelica.Icons.Package;

      model Temperature "Prescribed temperature"
        extends BaseClasses.PartialBC(final bCType=BaseClasses.BCType.Temperature,
            u(final unit="l2.m/(N.T2)", displayUnit="K"));

      equation
        inert.T = u_final;
        annotation (defaultComponentPrefixes="replaceable",defaultComponentName
            ="thermal");
      end Temperature;

      model HeatFlowRate "Prescribed heat flow rate"
        extends BaseClasses.PartialBC(final bCType=BaseClasses.BCType.HeatFlowRate,
            u(final unit="l2.m/T3"));

      equation
        inert.Qdot = u_final;
        annotation (defaultComponentPrefixes="replaceable",defaultComponentName
            ="thermal");
      end HeatFlowRate;

      package BaseClasses "Base classes (not for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialBC "Partial model for a thermal BC"
          extends FCSys.BCs.InertDalton.BaseClasses.PartialBC;

          constant BCType bCType "Type of BC";
          // Note:  This is included so that the type of BC is recorded with the
          // results.

        equation
          inert.p = 0 "No pressure";
          inert.mPhidot = zeros(n_lin) "No force";
          annotation (defaultComponentName="thermal");
        end PartialBC;

        type BCType = enumeration(
            Temperature "Temperature",
            HeatFlowRate "Heat flow rate") "Types of BCs";
      end BaseClasses;
    end Thermal;

    package BaseClasses "Base classes (not for direct use)"
      extends Modelica.Icons.BasesPackage;
      partial model PartialBC "Partial model for a BC"
        extends FCSys.BaseClasses.Icons.BCs.Single;

        parameter Boolean inclLinX=true "X" annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Axes with linear momentum included", compact=true));
        parameter Boolean inclLinY=false "Y" annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Axes with linear momentum included", compact=true));
        parameter Boolean inclLinZ=false "Z" annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Axes with linear momentum included", compact=true));

        parameter Boolean internal=true "Use internal specification"
          annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(__Dymola_descriptionLabel=true));

        replaceable Modelica.Blocks.Sources.Constant spec if internal
          constrainedby Modelica.Blocks.Interfaces.SO "Internal specification"
          annotation (
          __Dymola_choicesFromPackage=true,
          Dialog(__Dymola_descriptionLabel=true, enable=internal),
          Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={-30,30})));

        FCSys.Connectors.RealInput u if not internal "Value of BC" annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={0,40})));
        FCSys.Connectors.InertDalton inert(final n_lin=n_lin)
          "Connector for linear momentum and heat, with additivity of pressure"
          annotation (HideResult=true, Placement(transformation(extent={{-10,-50},
                  {10,-30}})));

      protected
        final parameter Integer n_lin=countTrue({inclLinX,inclLinY,inclLinZ})
          "Number of components of linear momentum" annotation (Evaluate=true);

        FCSys.Connectors.RealInputInternal u_final "Final value of BC"
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={0,-10})));

      equation
        connect(u, u_final) annotation (Line(
            points={{5.55112e-16,40},{5.55112e-16,27.5},{5.55112e-16,27.5},{
                5.55112e-16,15},{5.55112e-16,-10},{5.55112e-16,-10}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(spec.y, u_final) annotation (Line(
            points={{-30,19},{-30,10},{5.55112e-16,10},{5.55112e-16,-10}},
            color={0,0,127},
            smooth=Smooth.None));

      end PartialBC;
    end BaseClasses;
  end InertDalton;

  package FaceBus
    "<html>BCs for a <a href=\"modelica://FCSys.Connectors.FaceBus\">FaceBus</a> connector</html>"
    extends Modelica.Icons.Package;

    model Subregion
      "<html>BC for a face of a <a href=\"modelica://FCSys.Regions.Region\">Region</a> or <a href=\"modelica://FCSys.Subregions.Subregion\">Subregion</a> model, with efforts by default</html>"
      extends FCSys.BaseClasses.Icons.BCs.Single;

      parameter Axis axis=Axis.x "Axis normal to the face";

      Phases.Gas gas(final axis=axis) "Gas" annotation (Dialog(group="Phases",
            __Dymola_descriptionLabel=true), Placement(transformation(extent={{
                -10,-10},{10,10}})));

      Phases.Graphite graphite(final axis=axis) "Graphite" annotation (Dialog(
            group="Phases", __Dymola_descriptionLabel=true), Placement(
            transformation(extent={{-10,-10},{10,10}})));

      Phases.Ionomer ionomer(final axis=axis) "Ionomer" annotation (Dialog(
            group="Phases", __Dymola_descriptionLabel=true), Placement(
            transformation(extent={{-10,-10},{10,10}})));

      Phases.Liquid liquid(final axis=axis) "Liquid" annotation (Dialog(group=
              "Phases", __Dymola_descriptionLabel=true), Placement(
            transformation(extent={{-10,-10},{10,10}})));

      FCSys.Connectors.FaceBus face
        "Connector for material, linear momentum, and heat of multiple species"
        annotation (Placement(transformation(extent={{-10,-50},{10,-30}}),
            iconTransformation(extent={{-10,-50},{10,-30}})));
      FCSys.Connectors.RealInputBus u "Bus of inputs to specify conditions"
        annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,40})));

    equation
      connect(gas.face, face.gas) annotation (Line(
          points={{6.10623e-16,-4},{7.35523e-16,-4},{8.60423e-16,-40},{
              5.55112e-16,-40}},
          color={127,127,127},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None));

      connect(graphite.face, face.graphite) annotation (Line(
          points={{6.10623e-16,-4},{7.35523e-16,-4},{8.60423e-16,-40},{
              5.55112e-16,-40}},
          color={127,127,127},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None));

      connect(ionomer.face, face.ionomer) annotation (Line(
          points={{6.10623e-16,-4},{8.60423e-16,-40},{5.55112e-16,-40}},
          color={127,127,127},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None));
      connect(liquid.face, face.liquid) annotation (Line(
          points={{6.10623e-16,-4},{8.60423e-16,-40},{5.55112e-16,-40}},
          color={127,127,127},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None));
      connect(u.gas, gas.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,14},{6.10623e-16,14},{
              6.10623e-16,4}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

      connect(u.graphite, graphite.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,14},{6.10623e-16,14},{
              6.10623e-16,4}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

      connect(u.ionomer, ionomer.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,14},{6.10623e-16,14},{
              6.10623e-16,4}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

      connect(u.liquid, liquid.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,14},{6.10623e-16,14},{
              6.10623e-16,4}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

      annotation (
        defaultComponentPrefixes="replaceable",
        defaultComponentName="subregionFaceBC",
        Diagram(graphics));
    end Subregion;

    model SubregionFlow
      "<html>BC for a face of a <a href=\"modelica://FCSys.Subregions.Subregion\">Region</a> or <a href=\"modelica://FCSys.Subregions.Subregion\">Subregion</a> model, with flows by default</html>"
      extends FaceBus.Subregion(
        gas(
          H2(
            redeclare replaceable Face.Material.Current material,
            redeclare replaceable Face.Mechanical.Force mechanicalX,
            redeclare replaceable Face.Mechanical.Force mechanicalY,
            redeclare replaceable Face.Mechanical.Force mechanicalZ,
            redeclare replaceable Face.Thermal.HeatFlowRate thermal),
          H2O(
            redeclare replaceable Face.Material.Current material,
            redeclare replaceable Face.Mechanical.Force mechanicalX,
            redeclare replaceable Face.Mechanical.Force mechanicalY,
            redeclare replaceable Face.Mechanical.Force mechanicalZ,
            redeclare replaceable Face.Thermal.HeatFlowRate thermal),
          N2(
            redeclare replaceable Face.Material.Current material,
            redeclare replaceable Face.Mechanical.Force mechanicalX,
            redeclare replaceable Face.Mechanical.Force mechanicalY,
            redeclare replaceable Face.Mechanical.Force mechanicalZ,
            redeclare replaceable Face.Thermal.HeatFlowRate thermal),
          O2(
            redeclare replaceable Face.Material.Current material,
            redeclare replaceable Face.Mechanical.Force mechanicalX,
            redeclare replaceable Face.Mechanical.Force mechanicalY,
            redeclare replaceable Face.Mechanical.Force mechanicalZ,
            redeclare replaceable Face.Thermal.HeatFlowRate thermal)),
        graphite(C(
            redeclare replaceable Face.Material.Current material,
            redeclare replaceable Face.Mechanical.Force mechanicalX,
            redeclare replaceable Face.Mechanical.Force mechanicalY,
            redeclare replaceable Face.Mechanical.Force mechanicalZ,
            redeclare replaceable Face.Thermal.HeatFlowRate thermal), 'e-'(
            redeclare replaceable Face.Material.Current material,
            redeclare replaceable Face.Mechanical.Force mechanicalX,
            redeclare replaceable Face.Mechanical.Force mechanicalY,
            redeclare replaceable Face.Mechanical.Force mechanicalZ,
            redeclare replaceable Face.Thermal.HeatFlowRate thermal)),
        ionomer(
          C19HF37O5S(
            redeclare replaceable Face.Material.Current material,
            redeclare replaceable Face.Mechanical.Force mechanicalX,
            redeclare replaceable Face.Mechanical.Force mechanicalY,
            redeclare replaceable Face.Mechanical.Force mechanicalZ,
            redeclare replaceable Face.Thermal.HeatFlowRate thermal),
          H2O(
            redeclare replaceable Face.Material.Current material,
            redeclare replaceable Face.Mechanical.Force mechanicalX,
            redeclare replaceable Face.Mechanical.Force mechanicalY,
            redeclare replaceable Face.Mechanical.Force mechanicalZ,
            redeclare replaceable Face.Thermal.HeatFlowRate thermal),
          'H+'(
            redeclare replaceable Face.Material.Current material,
            redeclare replaceable Face.Mechanical.Force mechanicalX,
            redeclare replaceable Face.Mechanical.Force mechanicalY,
            redeclare replaceable Face.Mechanical.Force mechanicalZ,
            redeclare replaceable Face.Thermal.HeatFlowRate thermal)));

      annotation (defaultComponentPrefixes="replaceable",defaultComponentName=
            "subregionFaceBC");
    end SubregionFlow;

    model SubregionClosed
      "<html>BC for a face of a <a href=\"modelica://FCSys.Subregions.Subregion\">Region</a> or <a href=\"modelica://FCSys.Subregions.Subregion\">Subregion</a> model, with efforts except closed by default</html>"
      extends FaceBus.Subregion(
        gas(
          H2(redeclare replaceable Face.Material.Current material),
          H2O(redeclare replaceable Face.Material.Current material),
          N2(redeclare replaceable Face.Material.Current material),
          O2(redeclare replaceable Face.Material.Current material)),
        graphite(C(redeclare replaceable Face.Material.Current material), 'e-'(
              redeclare replaceable Face.Material.Current material)),
        ionomer(
          C19HF37O5S(redeclare replaceable Face.Material.Current material),
          H2O(redeclare replaceable Face.Material.Current material),
          'H+'(redeclare replaceable Face.Material.Current material)));

      annotation (defaultComponentPrefixes="replaceable",defaultComponentName=
            "subregionFaceBC");
    end SubregionClosed;

    model SubregionClosedAdiabatic
      "<html>BC for a face of a <a href=\"modelica://FCSys.Subregions.Subregion\">Region</a> or <a href=\"modelica://FCSys.Subregions.Subregion\">Subregion</a> model, with flows except zero shear velocities by default</html>"
      extends FaceBus.Subregion(
        gas(
          H2(redeclare replaceable Face.Material.Current material, redeclare
              replaceable Face.Thermal.HeatFlowRate thermal),
          H2O(redeclare replaceable Face.Material.Current material, redeclare
              replaceable Face.Thermal.HeatFlowRate thermal),
          N2(redeclare replaceable Face.Material.Current material, redeclare
              replaceable Face.Thermal.HeatFlowRate thermal),
          O2(redeclare replaceable Face.Material.Current material, redeclare
              replaceable Face.Thermal.HeatFlowRate thermal)),
        graphite(C(redeclare replaceable Face.Material.Current material,
              redeclare replaceable Face.Thermal.HeatFlowRate thermal), 'e-'(
              redeclare replaceable Face.Material.Current material, redeclare
              replaceable Face.Thermal.HeatFlowRate thermal)),
        ionomer(
          C19HF37O5S(redeclare replaceable Face.Material.Current material,
              redeclare replaceable Face.Thermal.HeatFlowRate thermal),
          H2O(redeclare replaceable Face.Material.Current material, redeclare
              replaceable Face.Thermal.HeatFlowRate thermal),
          'H+'(redeclare replaceable Face.Material.Current material, redeclare
              replaceable Face.Thermal.HeatFlowRate thermal)));

      annotation (defaultComponentPrefixes="replaceable",defaultComponentName=
            "subregionFaceBC");
    end SubregionClosedAdiabatic;

    model SubregionAdiabatic
      "<html>BC for a face of a <a href=\"modelica://FCSys.Subregions.Subregion\">Region</a> or <a href=\"modelica://FCSys.Subregions.Subregion\">Subregion</a> model, with efforts except adiabatic by default</html>"
      extends FaceBus.Subregion(
        gas(
          H2(redeclare replaceable Face.Thermal.HeatFlowRate thermal),
          H2O(redeclare replaceable Face.Thermal.HeatFlowRate thermal),
          N2(redeclare replaceable Face.Thermal.HeatFlowRate thermal),
          O2(redeclare replaceable Face.Thermal.HeatFlowRate thermal)),
        graphite(C(redeclare replaceable Face.Thermal.HeatFlowRate thermal),
            'e-'(redeclare replaceable Face.Thermal.HeatFlowRate thermal)),
        ionomer(
          C19HF37O5S(redeclare replaceable Face.Thermal.HeatFlowRate thermal),
          H2O(redeclare replaceable Face.Thermal.HeatFlowRate thermal),
          'H+'(redeclare replaceable Face.Thermal.HeatFlowRate thermal)));

      annotation (defaultComponentPrefixes="replaceable",defaultComponentName=
            "subregionFaceBC");
    end SubregionAdiabatic;

    package Phases
      "<html>BCs for the <a href=\"modelica://FCSys.Connectors.FaceBus\">FaceBus</a> connector, e.g., of a <a href=\"modelica://FCSys.Subregions.Phase\">Phase</a> model (multi-species)</html>"
      extends Modelica.Icons.Package;

      model Gas "BC for gas"

        extends BaseClasses.NullPhase;

        // Conditionally include species.
        parameter Boolean inclH2=false "<html>Hydrogen (H<sub>2</sub>)</html>"
          annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));
        FCSys.BCs.Face.Species H2(final axis=axis) if inclH2 "Model"
          annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclH2), Placement(transformation(extent={{-10,-10},{10,10}})));

        parameter Boolean inclH2O=false "<html>Water (H<sub>2</sub>O)</html>"
          annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));
        FCSys.BCs.Face.Species H2O(final axis=axis) if inclH2O "Model"
          annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclH2O), Placement(transformation(extent={{-10,-10},{10,10}})));

        parameter Boolean inclN2=false "<html>Nitrogen (N<sub>2</sub>)</html>"
          annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));
        FCSys.BCs.Face.Species N2(final axis=axis) if inclN2 "Model"
          annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclN2), Placement(transformation(extent={{-10,-10},{10,10}})));

        parameter Boolean inclO2=false "<html>Oxygen (O<sub>2</sub>)</html>"
          annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));
        FCSys.BCs.Face.Species O2(final axis=axis) if inclO2 "Model"
          annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclO2), Placement(transformation(extent={{-10,-10},{10,10}})));

      equation
        // H2
        connect(H2.face.material, face.H2.material) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(H2.face.mechanicalX, face.H2.mechanicalX) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(H2.face.mechanicalY, face.H2.mechanicalY) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(H2.face.mechanicalZ, face.H2.mechanicalZ) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(H2.face.thermal, face.H2.thermal) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.H2, H2.u) annotation (Line(
            points={{5.55112e-16,40},{5.55112e-16,14},{6.10623e-16,14},{
                6.10623e-16,4}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        // H2O
        connect(H2O.face.material, face.H2O.material) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(H2O.face.mechanicalX, face.H2O.mechanicalX) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(H2O.face.mechanicalY, face.H2O.mechanicalY) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(H2O.face.mechanicalZ, face.H2O.mechanicalZ) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(H2O.face.thermal, face.H2O.thermal) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.H2O, H2O.u) annotation (Line(
            points={{5.55112e-16,40},{5.55112e-16,14},{6.10623e-16,14},{
                6.10623e-16,4}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        // N2
        connect(N2.face.material, face.N2.material) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(N2.face.mechanicalX, face.N2.mechanicalX) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(N2.face.mechanicalY, face.N2.mechanicalY) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(N2.face.mechanicalZ, face.N2.mechanicalZ) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(N2.face.thermal, face.N2.thermal) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.N2, N2.u) annotation (Line(
            points={{5.55112e-16,40},{5.55112e-16,14},{6.10623e-16,14},{
                6.10623e-16,4}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        // O2
        connect(O2.face.material, face.O2.material) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(O2.face.mechanicalX, face.O2.mechanicalX) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(O2.face.mechanicalY, face.O2.mechanicalY) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(O2.face.mechanicalZ, face.O2.mechanicalZ) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(O2.face.thermal, face.O2.thermal) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.O2, O2.u) annotation (Line(
            points={{5.55112e-16,40},{5.55112e-16,14},{6.10623e-16,14},{
                6.10623e-16,4}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        annotation (Diagram(graphics));
      end Gas;

      model Graphite "BC for graphite"

        extends BaseClasses.NullPhase;

        // Conditionally include species.
        parameter Boolean inclC=false "Carbon (C)" annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));
        FCSys.BCs.Face.Species C(final axis=axis,thermoOpt=ThermoOpt.ClosedDiabatic)
          if inclC "Model" annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclC), Placement(transformation(extent={{-10,-10},{10,10}})));

        parameter Boolean 'incle-'=false
          "<html>Electrons (e<sup>-</sup>)</html>" annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));
        FCSys.BCs.Face.Species 'e-'(final axis=axis) if 'incle-' "Model"
          annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable='incle-'), Placement(transformation(extent={{-10,-10},{10,10}})));

      equation
        // C
        connect(C.face.material, face.C.material) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(C.face.mechanicalX, face.C.mechanicalX) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(C.face.mechanicalY, face.C.mechanicalY) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(C.face.mechanicalZ, face.C.mechanicalZ) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(C.face.thermal, face.C.thermal) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.C, C.u) annotation (Line(
            points={{5.55112e-16,40},{5.55112e-16,14},{6.10623e-16,14},{
                6.10623e-16,4}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        // e-
        connect('e-'.face.material, face.'e-'.material) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect('e-'.face.mechanicalX, face.'e-'.mechanicalX) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect('e-'.face.mechanicalY, face.'e-'.mechanicalY) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect('e-'.face.mechanicalZ, face.'e-'.mechanicalZ) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect('e-'.face.thermal, face.H2.thermal) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.'e-', 'e-'.u) annotation (Line(
            points={{5.55112e-16,40},{5.55112e-16,14},{6.10623e-16,14},{
                6.10623e-16,4}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

      end Graphite;

      model Ionomer "BC for ionomer"

        extends BaseClasses.NullPhase;

        // Conditionally include species.
        parameter Boolean inclC19HF37O5S=false
          "<html>Nafion sulfonate (C<sub>19</sub>HF<sub>37</sub>O<sub>5</sub>S)</html>"
          annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));
        FCSys.BCs.Face.Species C19HF37O5S(final axis=axis,thermoOpt=ThermoOpt.ClosedDiabatic)
          if inclC19HF37O5S "Model" annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclC19HF37O5S), Placement(transformation(extent={{-10,-10},
                  {10,10}})));

        parameter Boolean inclH2O=false "<html>Water (H<sub>2</sub>O)</html>"
          annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));
        FCSys.BCs.Face.Species H2O(final axis=axis) if inclH2O "Model"
          annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclH2O), Placement(transformation(extent={{-10,-10},{10,10}})));

        parameter Boolean 'inclH+'=false "<html>Protons (H<sup>+</sup>)</html>"
          annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));
        FCSys.BCs.Face.Species 'H+'(final axis=axis) if 'inclH+' "Model"
          annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable='inclH+'), Placement(transformation(extent={{-10,-10},{10,10}})));

      equation
        // C19HF37O5S
        connect(C19HF37O5S.face.material, face.C19HF37O5S.material) annotation
          (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(C19HF37O5S.face.mechanicalX, face.C19HF37O5S.mechanicalX)
          annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(C19HF37O5S.face.mechanicalY, face.C19HF37O5S.mechanicalY)
          annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(C19HF37O5S.face.mechanicalZ, face.C19HF37O5S.mechanicalZ)
          annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(C19HF37O5S.face.thermal, face.C19HF37O5S.thermal) annotation (
            Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.C19HF37O5S, C19HF37O5S.u) annotation (Line(
            points={{5.55112e-16,40},{5.55112e-16,14},{6.10623e-16,14},{
                6.10623e-16,4}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        // H+
        connect('H+'.face.material, face.'H+'.material) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect('H+'.face.mechanicalX, face.'H+'.mechanicalX) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect('H+'.face.mechanicalY, face.'H+'.mechanicalY) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect('H+'.face.mechanicalZ, face.'H+'.mechanicalZ) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect('H+'.face.thermal, face.'H+'.thermal) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.'H+', 'H+'.u) annotation (Line(
            points={{5.55112e-16,40},{5.55112e-16,14},{6.10623e-16,14},{
                6.10623e-16,4}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

      end Ionomer;

      model Liquid "BC for liquid"

        extends BaseClasses.NullPhase;

        // Conditionally include species.
        parameter Boolean inclH2O=false "<html>Water (H<sub>2</sub>O)</html>"
          annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));
        FCSys.BCs.Face.Species H2O(final axis=axis) if inclH2O "Model"
          annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclH2O), Placement(transformation(extent={{-10,-10},{10,10}})));

      equation
        // H2O
        connect(H2O.face.material, face.H2O.material) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(H2O.face.mechanicalX, face.H2O.mechanicalX) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(H2O.face.mechanicalY, face.H2O.mechanicalY) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(H2O.face.mechanicalZ, face.H2O.mechanicalZ) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(H2O.face.thermal, face.H2O.thermal) annotation (Line(
            points={{6.10623e-16,-4},{1.16573e-15,-40},{5.55112e-16,-40}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.H2O, H2O.u) annotation (Line(
            points={{5.55112e-16,40},{5.55112e-16,14},{6.10623e-16,14},{
                6.10623e-16,4}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

      end Liquid;

      package BaseClasses "Base classes (not for direct use)"
        extends Modelica.Icons.BasesPackage;
        model NullPhase "Empty BC for a phase (no species)"
          extends FCSys.BaseClasses.Icons.BCs.Single;

          parameter Axis axis "Axis material to the face";

          FCSys.Connectors.FaceBus face
            "Multi-species connector for material, linear momentum, and heat"
            annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
          FCSys.Connectors.RealInputBus u "Bus of inputs to specify conditions"
            annotation (Placement(transformation(
                extent={{-10,-10},{10,10}},
                rotation=270,
                origin={0,40})));

        end NullPhase;
      end BaseClasses;
    end Phases;

    annotation (Documentation(info="<html><p>Since the connectors in
<a href=\"modelica://FCSys\">FCSys</a> are hierarchical
(see the <a href=\"modelica://FCSys.Connectors\">Connectors</a> package),
the models for the boundary conditions must be as well.  A
<a href=\"modelica://FCSys.Connectors.BaseClasses.PartialFace\">Face</a>
connector (<a href=\"modelica://FCSys.Connectors.FaceX\">FaceX</a>,
<a href=\"modelica://FCSys.Connectors.FaceY\">FaceY</a>, or
<a href=\"modelica://FCSys.Connectors.FaceZ\">FaceZ</a>)
is used in <a href=\"modelica://FCSys.Subregions.Species\">Species</a> models,
and there is a corresponding <a href=\"modelica://FCSys.BCs.Face.Species.Species\">Species
boundary condition</a> model in this package. The
<a href=\"modelica://FCSys.Connectors.FaceBus\">FaceBus</a>
connector is used in <a href=\"modelica://FCSys.Subregions.Phases\">Phase</a> models,
and there are corresponding <a href=\"modelica://FCSys.BCs.Face.Phases\">Phase
boundary condition</a> models.  The
<a href=\"modelica://FCSys.Connectors.FaceBus\">FaceBus</a> connector is nested once more
in models such as the <a href=\"modelica://FCSys.Subregions.Subregion\">Subregion</a>,
and there is a corresponding <a href=\"modelica://FCSys.BCs.Face.Subregion\">Subregion
boundary condition</a> model.
</p></html>"));
  end FaceBus;

  package Face
    "<html>BCs for a <a href=\"modelica://FCSys.Connectors.Face\">Face</a> connector, e.g., of a <a href=\"modelica://FCSys.Subregions.Species\">Species</a> model (single-species)</html>"
    model Species
      "<html>BC for a face of a <a href=\"modelica://FCSys.Subregions.Species\">Species</a> model (single-species)</html>"
      extends BaseClasses.PartialSpecies;

      parameter Axis axis "Axis normal to the face";

      // X-axis linear momentum
      parameter Boolean inviscidX=true "Inviscid" annotation (
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          compact=true,
          group="X-axis linear momentum",
          enable=axis <> 1,
          __Dymola_descriptionLabel=true));
      // Note:  Dymola 7.4 doesn't recognize enumerations in the dialog enable
      // option, e.g.,
      //     enable=axis <> Axis.x.
      // Therefore, the values of the enumerations are specified numerically.
      replaceable Mechanical.Velocity mechanicalX if axis <> Axis.x and not
        inviscidX constrainedby Mechanical.BaseClasses.PartialBC
        "Type of condition" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(
          group="X-axis linear momentum",
          enable=axis <> 1 and not inviscidX,
          __Dymola_descriptionLabel=true),
        Placement(transformation(extent={{-40,-14},{-20,6}})));

      // Y-axis linear momentum
      parameter Boolean inviscidY=true "Inviscid" annotation (
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          compact=true,
          group="Y-axis linear momentum",
          enable=axis <> 2,
          __Dymola_descriptionLabel=true));
      replaceable Mechanical.Velocity mechanicalY if axis <> Axis.y and not
        inviscidY constrainedby Mechanical.BaseClasses.PartialBC
        "Type of condition" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(
          group="Y-axis linear momentum",
          enable=axis <> 2 and not inviscidY,
          __Dymola_descriptionLabel=true),
        Placement(transformation(extent={{-10,-14},{10,6}})));

      // Z-axis linear momentum
      parameter Boolean inviscidZ=true "Inviscid" annotation (
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          compact=true,
          group="Z-axis linear momentum",
          enable=axis <> 3,
          __Dymola_descriptionLabel=true));
      replaceable Mechanical.Velocity mechanicalZ if axis <> Axis.z and not
        inviscidZ constrainedby Mechanical.BaseClasses.PartialBC
        "Type of condition" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(
          group="Z-axis linear momentum",
          enable=axis <> 3 and not inviscidZ,
          __Dymola_descriptionLabel=true),
        Placement(transformation(extent={{20,-14},{40,6}})));

      FCSys.Connectors.Face face(
        final thermoOpt=thermoOpt,
        final inviscidX=inviscidX,
        final inviscidY=inviscidY,
        final inviscidZ=inviscidZ)
        "Single-species connector for material, linear momentum, and heat"
        annotation (Placement(transformation(extent={{-10,-50},{10,-30}}),
            iconTransformation(extent={{-10,-50},{10,-30}})));

    equation
      // Material
      connect(material.material, face.material) annotation (Line(
          points={{-60,-8},{-60,-20},{5.55112e-16,-20},{5.55112e-16,-40}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));

      // X-axis linear momentum
      connect(mechanicalX.mechanical, face.mechanicalX) annotation (Line(
          points={{-30,-8},{-30,-20},{5.55112e-16,-20},{5.55112e-16,-40}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));
      connect(u.mechanicalX, mechanicalX.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,20},{-30,20},{-30,6.66134e-16}},

          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));

      // Y-axis linear momentum
      connect(mechanicalY.mechanical, face.mechanicalY) annotation (Line(
          points={{6.10623e-16,-8},{6.10623e-16,-20},{0,-20},{0,-40},{
              5.55112e-16,-40}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));

      connect(u.mechanicalY, mechanicalY.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,20},{6.10623e-16,20},{
              6.10623e-16,6.66134e-16}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));

      // Z-axis linear momentum
      connect(mechanicalZ.mechanical, face.mechanicalZ) annotation (Line(
          points={{30,-8},{30,-20},{5.55112e-16,-20},{5.55112e-16,-40}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));
      connect(u.mechanicalZ, mechanicalZ.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,20},{30,20},{30,6.66134e-16}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));

      // Heat
      connect(thermal.thermal, face.thermal) annotation (Line(
          points={{60,-8},{60,-20},{5.55112e-16,-20},{5.55112e-16,-40}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));

      annotation (Diagram(graphics));
    end Species;
    extends Modelica.Icons.Package;




    package Material "Material BCs"
      extends Modelica.Icons.Package;

      model Density "Prescribed density"

        extends BaseClasses.PartialBC(
          final bCType=BaseClasses.BCType.Density,
          u(final unit="N/l3"),
          spec(k=4*U.C/U.cm^3));

      equation
        material.rho = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="material");
      end Density;

      model Current "Prescribed current"
        extends BaseClasses.PartialBC(
          final bCType=BaseClasses.BCType.Current,
          u(final unit="N/T"),
          spec(k=0));

      equation
        material.Ndot = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="material");
      end Current;

      package BaseClasses "Base classes (not for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialBC "Partial model for a material BC"
          extends Face.BaseClasses.PartialBC;

          constant BCType bCType "Type of BC";
          // Note:  This is included so that the type of BC is recorded with the
          // results.

          FCSys.Connectors.Material material
            "Material subconnector for the face"
            annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
          annotation (defaultComponentName="material");
        end PartialBC;

        type BCType = enumeration(
            Density "Density",
            Current "Current") "Types of BCs";
      end BaseClasses;
    end Material;

    package Mechanical "Mechanical BCs"
      extends Modelica.Icons.Package;

      model Velocity "Prescribed velocity"
        extends BaseClasses.PartialBC(
          final bCType=BaseClasses.BCType.Velocity,
          u(final unit="l/T"),
          spec(k=0));

      equation
        mechanical.phi = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="mechanicalBC");
      end Velocity;

      model Force "Prescribed shear force"
        extends BaseClasses.PartialBC(
          final bCType=BaseClasses.BCType.Force,
          u(final unit="l.m/T2"),
          spec(k=0));

      equation
        mechanical.mPhidot = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="mechanicalBC");
      end Force;

      package BaseClasses "Base classes (not for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialBC "Partial model for a mechanical BC"
          extends Face.BaseClasses.PartialBC;

          constant Mechanical.BaseClasses.BCType bCType "Type of BC";
          // Note:  This is included so that the type of BC is recorded with the
          // results.

          FCSys.Connectors.MechanicalTransport mechanical
            "Mechanical subconnector for the face"
            annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
          annotation (defaultComponentName="mechanicalBC");
        end PartialBC;

        type BCType = enumeration(
            Velocity "Velocity",
            Force "Shear force") "Types of BCs";
      end BaseClasses;
    end Mechanical;

    package Thermal "Thermal BCs"
      extends Modelica.Icons.Package;

      model Temperature "Prescribed temperature"
        extends Thermal.BaseClasses.PartialBC(
          final bCType=BaseClasses.BCType.Temperature,
          u(final unit="l2.m/(N.T2)", displayUnit="K"),
          spec(k=298.15*U.K));

      equation
        thermal.T = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="thermal");
      end Temperature;

      model HeatFlowRate "Prescribed heat flow rate"
        extends Thermal.BaseClasses.PartialBC(
          final bCType=BaseClasses.BCType.HeatFlowRate,
          u(final unit="l2.m/T3"),
          spec(k=0));

      equation
        thermal.Qdot = u_final;
        annotation (
          defaultComponentPrefixes="replaceable",
          defaultComponentName="thermal",
          Diagram(graphics));
      end HeatFlowRate;

      package BaseClasses "Base classes (not for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialBC "Partial model for a thermal BC"
          extends Face.BaseClasses.PartialBC;

          constant BCType bCType "Type of BC";
          // Note:  This is included so that the type of BC is recorded with the
          // results.

          FCSys.Connectors.Thermal thermal "Thermal subconnector for the face"
            annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

          annotation (defaultComponentName="thermal");
        end PartialBC;

        type BCType = enumeration(
            Temperature "Temperature",
            HeatFlowRate "Heat flow rate") "Types of BCs";
      end BaseClasses;
    end Thermal;

    package BaseClasses "Base classes (not for direct use)"
      extends Modelica.Icons.BasesPackage;

      model PartialSpecies
        "<html>Partial BC for a face of a <a href=\"modelica://FCSys.Subregions.Species\">Species</a> model (single-species)</html>"
        extends FCSys.BaseClasses.Icons.BCs.Single;

        parameter ThermoOpt thermoOpt=ThermoOpt.OpenDiabatic
          "Options for material and thermal subconnectors" annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Assumptions",compact=true));

        // Material
        replaceable Material.Density material if thermoOpt == ThermoOpt.OpenDiabatic
          constrainedby Material.BaseClasses.PartialBC "Type of condition"
          annotation (
          __Dymola_choicesFromPackage=true,
          Dialog(
            group="Material",
            enable=thermoOpt == 3,
            __Dymola_descriptionLabel=true),
          Placement(transformation(extent={{-70,-14},{-50,6}})));

        // Heat
        replaceable Thermal.Temperature thermal if thermoOpt <> ThermoOpt.ClosedAdiabatic
          constrainedby Thermal.BaseClasses.PartialBC "Type of condition"
          annotation (
          __Dymola_choicesFromPackage=true,
          Dialog(
            group="Heat",
            enable=thermoOpt <> 1,
            __Dymola_descriptionLabel=true),
          Placement(transformation(extent={{50,-14},{70,6}})));
        // Note:  Dymola 7.4 doesn't recognize enumerations in the dialog enable
        // option, e.g.,
        //     enable=thermoOpt <> ThermoOpt.ClosedAdiabatic.
        // Therefore, the values of the enumerations are specified numerically.

        FCSys.Connectors.RealInputBus u "Input bus for external signal sources"
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={0,40}), iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={0,40})));

      equation
        // Material
        connect(u.material, material.u) annotation (Line(
            points={{5.55112e-16,40},{5.55112e-16,20},{-60,20},{-60,6.66134e-16}},

            color={0,0,127},
            smooth=Smooth.None), Text(
            string="%first",
            index=-1,
            extent={{-6,3},{-6,3}}));

        // Heat
        connect(u.thermal, thermal.u) annotation (Line(
            points={{5.55112e-16,40},{5.55112e-16,20},{60,20},{60,6.66134e-16}},

            color={0,0,127},
            smooth=Smooth.None), Text(
            string="%first",
            index=-1,
            extent={{-6,3},{-6,3}}));

      end PartialSpecies;

      partial model PartialBC "Partial model for a BC"
        extends FCSys.BaseClasses.Icons.BCs.Single;

        parameter Boolean internal=true "Use internal specification"
          annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(__Dymola_descriptionLabel=true));

        replaceable Modelica.Blocks.Sources.Constant spec if internal
          constrainedby Modelica.Blocks.Interfaces.SO "Internal specification"
          annotation (
          __Dymola_choicesFromPackage=true,
          Dialog(__Dymola_descriptionLabel=true, enable=internal),
          Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={-30,30})));

        FCSys.Connectors.RealInput u if not internal "Value of BC" annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={0,40})));

      protected
        FCSys.Connectors.RealInputInternal u_final "Final value of BC"
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={0,-10})));

      equation
        connect(u, u_final) annotation (Line(
            points={{5.55112e-16,40},{5.55112e-16,27.5},{5.55112e-16,27.5},{
                5.55112e-16,15},{5.55112e-16,-10},{5.55112e-16,-10}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(spec.y, u_final) annotation (Line(
            points={{-30,19},{-30,10},{5.55112e-16,10},{5.55112e-16,-10}},
            color={0,0,127},
            smooth=Smooth.None));

      end PartialBC;
    end BaseClasses;
  end Face;

  package FaceBusDifferential
    "<html>BCs for a pair of <a href=\"modelica://FCSys.Connectors.FaceBus\">FaceBus</a> connectors</html>"
    extends Modelica.Icons.Package;

    model Subregion
      "<html>BC for faces of a <a href=\"modelica://FCSys.Regions.Region\">Region</a> or <a href=\"modelica://FCSys.Subregions.Subregion\">Subregion</a> model, with efforts by default</html>"
      extends FCSys.BaseClasses.Icons.BCs.Double;

      parameter Axis axis=Axis.x "Axis normal to the face";

      replaceable FCSys.BCs.FaceBusDifferential.Phases.Gas gas(final axis=axis)
        "Gas" annotation (Dialog(group="Phases", __Dymola_descriptionLabel=true),
          Placement(transformation(extent={{-10,-10},{10,10}})));

      replaceable FCSys.BCs.FaceBusDifferential.Phases.Graphite graphite(final
          axis=axis) "Graphite" annotation (Dialog(group="Phases",
            __Dymola_descriptionLabel=true), Placement(transformation(extent={{
                -10,-10},{10,10}})));

      replaceable FCSys.BCs.FaceBusDifferential.Phases.Ionomer ionomer(final
          axis=axis) "Ionomer" annotation (Dialog(group="Phases",
            __Dymola_descriptionLabel=true), Placement(transformation(extent={{
                -10,-10},{10,10}})));

      FCSys.Connectors.FaceBus negative annotation (Placement(transformation(
              extent={{-110,-10},{-90,10}}), iconTransformation(extent={{-110,-10},
                {-90,10}})));
      FCSys.Connectors.RealInputBus u annotation (Placement(transformation(
            extent={{-10,-10},{10,10}},
            rotation=270,
            origin={0,40})));
      FCSys.Connectors.FaceBus positive annotation (Placement(transformation(
              extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},
                {110,10}})));
    equation
      connect(gas.negative, negative.gas) annotation (Line(
          points={{-10,6.10623e-16},{-100,0},{-100,5.55112e-16}},
          color={127,127,127},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None));

      connect(graphite.negative, negative.graphite) annotation (Line(
          points={{-10,6.10623e-16},{-100,6.10623e-16},{-100,5.55112e-16}},
          color={127,127,127},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None));

      connect(ionomer.negative, negative.ionomer) annotation (Line(
          points={{-10,6.10623e-16},{-100,5.55112e-16}},
          color={127,127,127},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None));
      connect(gas.positive, positive.gas) annotation (Line(
          points={{10,6.10623e-16},{20,0},{100,5.55112e-16}},
          color={127,127,127},
          pattern=LinePattern.None,
          thickness=0.5,
          smooth=Smooth.None));

      connect(graphite.positive, positive.graphite) annotation (Line(
          points={{10,6.10623e-16},{20,6.10623e-16},{20,5.55112e-16},{100,
              5.55112e-16}},
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
      connect(u.gas, gas.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,4},{6.10623e-16,4}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

      connect(u.graphite, graphite.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,4},{6.10623e-16,4}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

      connect(u.ionomer, ionomer.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,4},{6.10623e-16,4}},
          color={0,0,127},
          thickness=0.5,
          smooth=Smooth.None));

      annotation (
        defaultComponentPrefixes="replaceable",
        defaultComponentName="subregionFaceBC",
        Diagram(graphics));
    end Subregion;

    model SubregionFlow
      "<html>BC for faces of a <a href=\"modelica://FCSys.Regions.Region\">Region</a> or <a href=\"modelica://FCSys.Subregions.Subregion\">Subregion</a> model, with flows by default</html>"
      extends FCSys.BCs.FaceBusDifferential.Subregion(
        gas(
          H2(
            redeclare replaceable FaceDifferential.Material.Current material,
            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalX,

            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalY,

            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalZ,

            redeclare replaceable FaceDifferential.Thermal.HeatFlowRate thermal),

          H2O(
            redeclare replaceable FaceDifferential.Material.Current material,
            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalX,

            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalY,

            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalZ,

            redeclare replaceable FaceDifferential.Thermal.HeatFlowRate thermal),

          N2(
            redeclare replaceable FaceDifferential.Material.Current material,
            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalX,

            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalY,

            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalZ,

            redeclare replaceable FaceDifferential.Thermal.HeatFlowRate thermal),

          O2(
            redeclare replaceable FaceDifferential.Material.Current material,
            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalX,

            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalY,

            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalZ,

            redeclare replaceable FaceDifferential.Thermal.HeatFlowRate thermal)),

        graphite(C(
            redeclare replaceable FaceDifferential.Material.Current material,
            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalX,

            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalY,

            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalZ,

            redeclare replaceable FaceDifferential.Thermal.HeatFlowRate thermal),
            'e-'(
            redeclare replaceable FaceDifferential.Material.Current material,
            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalX,

            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalY,

            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalZ,

            redeclare replaceable FaceDifferential.Thermal.HeatFlowRate thermal)),

        ionomer(
          C19HF37O5S(
            redeclare replaceable FaceDifferential.Material.Current material,
            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalX,

            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalY,

            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalZ,

            redeclare replaceable FaceDifferential.Thermal.HeatFlowRate thermal),

          H2O(
            redeclare replaceable FaceDifferential.Material.Current material,
            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalX,

            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalY,

            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalZ,

            redeclare replaceable FaceDifferential.Thermal.HeatFlowRate thermal),

          'H+'(
            redeclare replaceable FaceDifferential.Material.Current material,
            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalX,

            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalY,

            redeclare replaceable FaceDifferential.Mechanical.Force mechanicalZ,

            redeclare replaceable FaceDifferential.Thermal.HeatFlowRate thermal)));

      annotation (defaultComponentPrefixes="replaceable",defaultComponentName=
            "subregionFaceBC");
    end SubregionFlow;

    model SubregionClosed
      "<html>BC for faces of a <a href=\"modelica://FCSys.Regions.Region\">Region</a> or <a href=\"modelica://FCSys.Subregions.Subregion\">Subregion</a> model, with efforts except closed by default</html>"
      extends FCSys.BCs.FaceBusDifferential.Subregion(
        gas(
          H2(redeclare replaceable FaceDifferential.Material.Current material),

          H2O(redeclare replaceable FaceDifferential.Material.Current material),

          N2(redeclare replaceable FaceDifferential.Material.Current material),

          O2(redeclare replaceable FaceDifferential.Material.Current material)),

        graphite(C(redeclare replaceable FaceDifferential.Material.Current
              material), 'e-'(redeclare replaceable
              FaceDifferential.Material.Current material)),
        ionomer(
          C19HF37O5S(redeclare replaceable FaceDifferential.Material.Current
              material),
          H2O(redeclare replaceable FaceDifferential.Material.Current material),

          'H+'(redeclare replaceable FaceDifferential.Material.Current material)));

      annotation (defaultComponentPrefixes="replaceable",defaultComponentName=
            "subregionFaceBC");
    end SubregionClosed;

    model SubregionClosedAdiabatic
      "<html>BC for faces of a <a href=\"modelica://FCSys.Regions.Region\">Region</a> or <a href=\"modelica://FCSys.Subregions.Subregion\">Subregion</a> model, with flows except zero shear velocities by default</html>"
      extends FCSys.BCs.FaceBusDifferential.Subregion(
        gas(
          H2(redeclare replaceable FaceDifferential.Material.Current material,
              redeclare replaceable FaceDifferential.Thermal.HeatFlowRate
              thermal),
          H2O(redeclare replaceable FaceDifferential.Material.Current material,
              redeclare replaceable FaceDifferential.Thermal.HeatFlowRate
              thermal),
          N2(redeclare replaceable FaceDifferential.Material.Current material,
              redeclare replaceable FaceDifferential.Thermal.HeatFlowRate
              thermal),
          O2(redeclare replaceable FaceDifferential.Material.Current material,
              redeclare replaceable FaceDifferential.Thermal.HeatFlowRate
              thermal)),
        graphite(C(redeclare replaceable FaceDifferential.Material.Current
              material, redeclare replaceable
              FaceDifferential.Thermal.HeatFlowRate thermal), 'e-'(redeclare
              replaceable FaceDifferential.Material.Current material,
              redeclare replaceable FaceDifferential.Thermal.HeatFlowRate
              thermal)),
        ionomer(
          C19HF37O5S(redeclare replaceable FaceDifferential.Material.Current
              material, redeclare replaceable
              FaceDifferential.Thermal.HeatFlowRate thermal),
          H2O(redeclare replaceable FaceDifferential.Material.Current material,
              redeclare replaceable FaceDifferential.Thermal.HeatFlowRate
              thermal),
          'H+'(redeclare replaceable FaceDifferential.Material.Current material,
              redeclare replaceable FaceDifferential.Thermal.HeatFlowRate
              thermal)));

      annotation (defaultComponentPrefixes="replaceable",defaultComponentName=
            "subregionFaceBC");
    end SubregionClosedAdiabatic;

    model SubregionAdiabatic
      "<html>BC for faces of a <a href=\"modelica://FCSys.Regions.Region\">Region</a> or <a href=\"modelica://FCSys.Subregions.Subregion\">Subregion</a> model, with efforts except adiabatic by default</html>"
      extends FCSys.BCs.FaceBusDifferential.Subregion(
        gas(
          H2(redeclare replaceable FaceDifferential.Thermal.HeatFlowRate
              thermal),
          H2O(redeclare replaceable FaceDifferential.Thermal.HeatFlowRate
              thermal),
          N2(redeclare replaceable FaceDifferential.Thermal.HeatFlowRate
              thermal),
          O2(redeclare replaceable FaceDifferential.Thermal.HeatFlowRate
              thermal)),
        graphite(C(redeclare replaceable FaceDifferential.Thermal.HeatFlowRate
              thermal), 'e-'(redeclare replaceable
              FaceDifferential.Thermal.HeatFlowRate thermal)),
        ionomer(
          C19HF37O5S(redeclare replaceable
              FaceDifferential.Thermal.HeatFlowRate thermal),
          H2O(redeclare replaceable FaceDifferential.Thermal.HeatFlowRate
              thermal),
          'H+'(redeclare replaceable FaceDifferential.Thermal.HeatFlowRate
              thermal)));

      annotation (defaultComponentPrefixes="replaceable",defaultComponentName=
            "subregionFaceBC");
    end SubregionAdiabatic;

    package Phases
      "<html>BCs for the <a href=\"modelica://FCSys.Connectors.FaceBus\">FaceBus</a> connector, e.g., of a <a href=\"modelica://FCSys.Subregions.Phase\">Phase</a> model (multi-species)</html>"
      extends Modelica.Icons.Package;

      model Gas "BC for gas"

        extends FCSys.BCs.FaceBusDifferential.Phases.BaseClasses.NullPhase;

        // Conditionally include species.
        parameter Boolean inclH2=false "<html>Hydrogen (H<sub>2</sub>)</html>"
          annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));
        FCSys.BCs.FaceDifferential.Species H2 if inclH2 "Model" annotation (
            Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclH2), Placement(transformation(extent={{-10,-10},{10,10}})));

        parameter Boolean inclH2O=false "<html>Water (H<sub>2</sub>O)</html>"
          annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));
        FCSys.BCs.FaceDifferential.Species H2O if inclH2O "Model" annotation (
            Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclH2O), Placement(transformation(extent={{-10,-10},{10,10}})));

        parameter Boolean inclN2=false "<html>Nitrogen (N<sub>2</sub>)</html>"
          annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));
        FCSys.BCs.FaceDifferential.Species N2 if inclN2 "Model" annotation (
            Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclN2), Placement(transformation(extent={{-10,-10},{10,10}})));

        parameter Boolean inclO2=false "<html>Oxygen (O<sub>2</sub>)</html>"
          annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));
        FCSys.BCs.FaceDifferential.Species O2 if inclO2 "Model" annotation (
            Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclO2), Placement(transformation(extent={{-10,-10},{10,10}})));

      equation
        // H2
        connect(H2.negative, negative.H2) annotation (Line(
            points={{-10,6.10623e-16},{-100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(H2.positive, positive.H2) annotation (Line(
            points={{10,6.10623e-16},{100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.H2, H2.u) annotation (Line(
            points={{5.55112e-16,40},{5.55112e-16,14},{6.10623e-16,14},{
                6.10623e-16,4}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        // H2O
        connect(H2O.negative, negative.H2O) annotation (Line(
            points={{-10,6.10623e-16},{-100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(H2O.positive, positive.H2O) annotation (Line(
            points={{10,6.10623e-16},{100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.H2O, H2O.u) annotation (Line(
            points={{5.55112e-16,40},{5.55112e-16,14},{6.10623e-16,14},{
                6.10623e-16,4}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        // N2
        connect(N2.negative, negative.N2) annotation (Line(
            points={{-10,6.10623e-16},{-100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(N2.positive, positive.N2) annotation (Line(
            points={{10,6.10623e-16},{100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.N2, N2.u) annotation (Line(
            points={{5.55112e-16,40},{5.55112e-16,14},{6.10623e-16,14},{
                6.10623e-16,4}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        // O2
        connect(O2.negative, negative.O2) annotation (Line(
            points={{-10,6.10623e-16},{-100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(O2.positive, positive.O2) annotation (Line(
            points={{10,6.10623e-16},{100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.O2, O2.u) annotation (Line(
            points={{5.55112e-16,40},{5.55112e-16,14},{6.10623e-16,14},{
                6.10623e-16,4}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

      end Gas;

      model Graphite "BC for graphite"

        extends FCSys.BCs.FaceBusDifferential.Phases.BaseClasses.NullPhase;

        // Conditionally include species.
        parameter Boolean inclC=false "Carbon (C)" annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));
        FCSys.BCs.FaceDifferential.Species C(thermoOpt=ThermoOpt.ClosedDiabatic)
          if inclC "Model" annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclC), Placement(transformation(extent={{-10,-10},{10,10}})));

        parameter Boolean 'incle-'=false
          "<html>Electrons (e<sup>-</sup>)</html>" annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));
        FCSys.BCs.FaceDifferential.Species 'e-' if 'incle-' "Model" annotation
          (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable='incle-'), Placement(transformation(extent={{-10,-10},{10,10}})));

      equation
        // C
        connect(C.negative, negative.C) annotation (Line(
            points={{-10,6.10623e-16},{-100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(C.positive, positive.C) annotation (Line(
            points={{10,6.10623e-16},{100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.C, C.u) annotation (Line(
            points={{5.55112e-16,40},{5.55112e-16,14},{6.10623e-16,14},{
                6.10623e-16,4}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        // e-
        connect('e-'.negative, negative.'e-') annotation (Line(
            points={{-10,6.10623e-16},{-100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect('e-'.positive, positive.'e-') annotation (Line(
            points={{10,6.10623e-16},{100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.'e-', 'e-'.u) annotation (Line(
            points={{5.55112e-16,40},{5.55112e-16,14},{6.10623e-16,14},{
                6.10623e-16,4}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

      end Graphite;

      model Ionomer "BC for ionomer"

        extends FCSys.BCs.FaceBusDifferential.Phases.BaseClasses.NullPhase;

        // Conditionally include species.
        parameter Boolean inclC19HF37O5S=false
          "<html>Nafion sulfonate (C<sub>19</sub>HF<sub>37</sub>O<sub>5</sub>S)</html>"
          annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));
        FCSys.BCs.FaceDifferential.Species C19HF37O5S(thermoOpt=ThermoOpt.ClosedDiabatic)
          if inclC19HF37O5S "Model" annotation (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclC19HF37O5S), Placement(transformation(extent={{-10,-10},
                  {10,10}})));

        parameter Boolean inclH2O=false "<html>Water (H<sub>2</sub>O)</html>"
          annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));
        FCSys.BCs.FaceDifferential.Species H2O if inclH2O "Model" annotation (
            Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclH2O), Placement(transformation(extent={{-10,-10},{10,10}})));

        parameter Boolean 'inclH+'=false "<html>Protons (H<sup>+</sup>)</html>"
          annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));
        FCSys.BCs.FaceDifferential.Species 'H+' if 'inclH+' "Model" annotation
          (Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable='inclH+'), Placement(transformation(extent={{-10,-10},{10,10}})));

      equation
        // C19HF37O5S
        connect(C19HF37O5S.negative, negative.C19HF37O5S) annotation (Line(
            points={{-10,6.10623e-16},{-100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(C19HF37O5S.positive, positive.C19HF37O5S) annotation (Line(
            points={{10,6.10623e-16},{100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.C19HF37O5S, C19HF37O5S.u) annotation (Line(
            points={{5.55112e-16,40},{5.55112e-16,14},{6.10623e-16,14},{
                6.10623e-16,4}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        // H2O
        connect(H2O.negative, negative.H2O) annotation (Line(
            points={{-10,6.10623e-16},{-100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(H2O.positive, positive.H2O) annotation (Line(
            points={{10,6.10623e-16},{100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.H2O, H2O.u) annotation (Line(
            points={{5.55112e-16,40},{5.55112e-16,14},{6.10623e-16,14},{
                6.10623e-16,4}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

        // H+
        connect('H+'.negative, negative.'H+') annotation (Line(
            points={{-10,6.10623e-16},{-100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect('H+'.positive, positive.'H+') annotation (Line(
            points={{10,6.10623e-16},{100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.'H+', 'H+'.u) annotation (Line(
            points={{5.55112e-16,40},{5.55112e-16,14},{6.10623e-16,14},{
                6.10623e-16,4}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

      end Ionomer;

      model Liquid "BC for liquid"

        extends FCSys.BCs.FaceBusDifferential.Phases.BaseClasses.NullPhase;

        // Conditionally include species.
        parameter Boolean inclH2O=false "<html>Water (H<sub>2</sub>O)</html>"
          annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            __Dymola_joinNext=true));
        FCSys.BCs.FaceDifferential.Species H2O if inclH2O "Model" annotation (
            Dialog(
            group="Species",
            __Dymola_descriptionLabel=true,
            enable=inclH2O), Placement(transformation(extent={{-10,-10},{10,10}})));

      equation
        // H2O
        connect(H2O.negative, negative.H2O) annotation (Line(
            points={{-10,6.10623e-16},{-100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(H2O.positive, positive.H2O) annotation (Line(
            points={{10,6.10623e-16},{100,5.55112e-16}},
            color={127,127,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
        connect(u.H2O, H2O.u) annotation (Line(
            points={{5.55112e-16,40},{5.55112e-16,14},{6.10623e-16,14},{
                6.10623e-16,4}},
            color={0,0,127},
            thickness=0.5,
            smooth=Smooth.None));

      end Liquid;

      package BaseClasses "Base classes (not for direct use)"
        extends Modelica.Icons.BasesPackage;
        model NullPhase "Empty BC for a phase (no species)"
          extends FCSys.BaseClasses.Icons.BCs.Double;

          parameter Axis axis=Axis.x "Axis normal to the face";

          FCSys.Connectors.FaceBus negative
            "Multi-species connector for material, linear momentum, and heat"
            annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
          FCSys.Connectors.FaceBus positive
            "Multi-species connector for material, linear momentum, and heat"
            annotation (Placement(transformation(extent={{90,-10},{110,10}})));

          FCSys.Connectors.RealInputBus u "Bus of inputs to specify conditions"
            annotation (Placement(transformation(
                extent={{-10,-10},{10,10}},
                rotation=270,
                origin={0,40})));

        end NullPhase;
      end BaseClasses;
    end Phases;

    annotation (Documentation(info="<html><p>The hierarchy of these
 boundary condition models is similar to that of the models in the
 <a href=\"modelica://FCSys.BCs.FaceBus\">BCs.FaceBus</a> package.
 For more information, please see the documentation in that package.</p></html>"));
  end FaceBusDifferential;

  package FaceDifferential
    "<html>BCs for a pair of <a href=\"modelica://FCSys.Connectors.Face\">Face</a> connectors</html>"

    extends Modelica.Icons.Package;

    model Species
      "<html>BC for a pair of faces of a <a href=\"modelica://FCSys.Subregions.Species\">Species</a> model (single-species)</html>"
      extends BaseClasses.PartialSpecies;

      parameter Axis axis "Axis normal to the face";

      // X-axis linear momentum
      parameter Boolean inviscidX=false "Inviscid" annotation (
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          compact=true,
          group="X-axis linear momentum",
          enable=axis <> 1,
          __Dymola_descriptionLabel=true));
      // Note:  Dymola 7.4 doesn't recognize enumerations in the dialog enable
      // option, e.g.,
      //     enable=axis <> Axis.x.
      // Therefore, the values of the enumerations are specified numerically.
      replaceable Mechanical.Velocity mechanicalX if axis <> Axis.x and not
        inviscidX constrainedby Mechanical.BaseClasses.PartialBC
        "Type of condition" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(
          group="X-axis linear momentum",
          enable=not inviscidX and axis <> 1,
          __Dymola_descriptionLabel=true),
        Placement(transformation(extent={{-40,-10},{-20,10}})));

      // Y-axis linear momentum
      parameter Boolean inviscidY=true "Inviscid" annotation (
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          compact=true,
          group="Y-axis linear momentum",
          enable=axis <> 2,
          __Dymola_descriptionLabel=true));
      replaceable Mechanical.Velocity mechanicalY if axis <> Axis.y and not
        inviscidY constrainedby Mechanical.BaseClasses.PartialBC
        "Type of condition" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(
          group="Y-axis linear momentum",
          enable=not inviscidY and axis <> 2,
          __Dymola_descriptionLabel=true),
        Placement(transformation(extent={{-10,-20},{10,0}})));

      // Z-axis linear momentum
      parameter Boolean inviscidZ=false "Inviscid" annotation (
        HideResult=true,
        choices(__Dymola_checkBox=true),
        Dialog(
          compact=true,
          group="Z-axis linear momentum",
          enable=axis <> 3,
          __Dymola_descriptionLabel=true));

      replaceable Mechanical.Velocity mechanicalZ if axis <> Axis.z and not
        inviscidZ constrainedby Mechanical.BaseClasses.PartialBC
        "Type of condition" annotation (
        __Dymola_choicesFromPackage=true,
        Dialog(
          group="Z-axis linear momentum",
          enable=not inviscidZ and axis <> 2,
          __Dymola_descriptionLabel=true),
        Placement(transformation(extent={{20,-30},{40,-10}})));

      FCSys.Connectors.Face negative(
        final axis=axis,
        final thermoOpt=thermoOpt,
        final inviscidX=inviscidX,
        final inviscidY=inviscidY,
        final inviscidZ=inviscidZ) "Negative face" annotation (Placement(
            transformation(extent={{-110,-40},{-90,-20}}), iconTransformation(
              extent={{-110,-10},{-90,10}})));
      FCSys.Connectors.Face positive(
        final axis=axis,
        final inviscidX=inviscidX,
        final inviscidY=inviscidY,
        final inviscidZ=inviscidZ) "Positive face" annotation (Placement(
            transformation(extent={{90,-40},{110,-20}}), iconTransformation(
              extent={{90,-10},{110,10}})));

    equation
      // Material
      connect(material.negative, negative.material) annotation (Line(
          points={{-70,10},{-80,10},{-80,-30},{-100,-30}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));
      connect(material.positive, positive.material) annotation (Line(
          points={{-50,10},{90,10},{90,-30},{100,-30}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));

      // X-axis linear momentum
      connect(mechanicalX.negative, negative.mechanicalX) annotation (Line(
          points={{-40,6.10623e-16},{-80,6.10623e-16},{-80,-30},{-100,-30}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));
      connect(mechanicalX.positive, positive.mechanicalX) annotation (Line(
          points={{-20,6.10623e-16},{90,6.10623e-16},{90,-30},{100,-30}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));
      connect(u.mechanicalX, mechanicalX.u) annotation (Line(
          points={{5.55112e-16,40},{0,40},{0,20},{-30,20},{-30,4}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));

      // Y-axis linear momentum
      connect(mechanicalY.negative, negative.mechanicalY) annotation (Line(
          points={{-10,-10},{-80,-10},{-80,-30},{-100,-30}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));
      connect(mechanicalY.positive, positive.mechanicalY) annotation (Line(
          points={{10,-10},{90,-10},{90,-30},{100,-30}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));
      connect(u.mechanicalY, mechanicalY.u) annotation (Line(
          points={{5.55112e-16,40},{5.55112e-16,10},{6.10623e-16,10},{
              6.10623e-16,-6}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));

      // Z-axis linear momentum
      connect(mechanicalZ.negative, negative.mechanicalZ) annotation (Line(
          points={{20,-20},{-80,-20},{-80,-30},{-100,-30}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));
      connect(mechanicalZ.positive, positive.mechanicalZ) annotation (Line(
          points={{40,-20},{90,-20},{90,-30},{100,-30}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));
      connect(u.mechanicalZ, mechanicalZ.u) annotation (Line(
          points={{5.55112e-16,40},{0,40},{0,20},{30,20},{30,-16}},
          color={0,0,127},
          smooth=Smooth.None), Text(
          string="%first",
          index=-1,
          extent={{-6,3},{-6,3}}));

      // Heat
      connect(thermal.negative, negative.thermal) annotation (Line(
          points={{50,-30},{-26,-30},{-26,-30},{-100,-30}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));
      connect(thermal.positive, positive.thermal) annotation (Line(
          points={{70,-30},{86,-30},{86,-30},{100,-30}},
          color={127,127,127},
          pattern=LinePattern.None,
          smooth=Smooth.None));

      annotation (Diagram(graphics), Icon(graphics));
    end Species;




    package Material "Material BCs"
      extends Modelica.Icons.Package;

      model Density "Prescribed density difference, with material conservation"

        extends BaseClasses.PartialBC(final bCType=BaseClasses.BCType.Density,
            u(final unit="N/L3"));

      equation
        negative.rho - positive.rho = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="material");
      end Density;

      model Current "Prescribed current, with material conservation"
        extends BaseClasses.PartialBC(final bCType=BaseClasses.BCType.Current,
            u(final unit="N/T"));

      equation
        negative.Ndot = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="material");
      end Current;

      package BaseClasses "Base classes (not for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialBC "Partial model for a material BC"
          extends FaceDifferential.BaseClasses.PartialBC;

          constant BCType bCType "Type of BC";
          // Note:  This is included so that the type of BC is recorded with the
          // results.

          FCSys.Connectors.Material negative
            "Material connector for the negative face" annotation (Placement(
                transformation(extent={{-110,-10},{-90,10}})));
          FCSys.Connectors.Material positive
            "Material connector for the positive face"
            annotation (Placement(transformation(extent={{90,-10},{110,10}})));
        equation
          0 = negative.Ndot + positive.Ndot
            "Material conservation (no storage)";
          annotation (defaultComponentName="material");
        end PartialBC;

        type BCType = enumeration(
            Density "Density difference",
            Current "Current") "Types of BCs";
      end BaseClasses;
    end Material;

    package Mechanical "Mechanical BCs"
      extends Modelica.Icons.Package;

      model Velocity
        "Prescribed shear velocity, with conservation of linear momentum"
        extends BaseClasses.PartialBC(final bCType=BaseClasses.BCType.Velocity,
            u(final unit="l/T"));
      equation
        negative.phi - positive.phi = u_final;

        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="mechanicalBC");
      end Velocity;

      model Force
        "Prescribed shear force, with conservation of linear momentum"
        extends BaseClasses.PartialBC(final bCType=BaseClasses.BCType.Force, u(
              final unit="l.m/T2"));

      equation
        negative.mPhidot = u_final;

        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="mechanicalBC");
      end Force;

      package BaseClasses "Base classes (not for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialBC "Partial model for a BC for linear momentum"
          extends FaceDifferential.BaseClasses.PartialBC;

          constant BCType bCType "Type of BC";
          // Note:  This is included so that the type of BC is recorded with the
          // results.

          FCSys.Connectors.MechanicalTransport negative
            "Linear momentum connector for the negative face" annotation (
              Placement(transformation(extent={{-110,-10},{-90,10}})));
          FCSys.Connectors.MechanicalTransport positive
            "Linear momentum connector for the positive face"
            annotation (Placement(transformation(extent={{90,-10},{110,10}})));

        equation
          0 = negative.mPhidot + positive.mPhidot
            "Conservation of linear momentum (no storage)";
          annotation (defaultComponentName="mechanicalBC");
        end PartialBC;

        type BCType = enumeration(
            Velocity "Shear velocity",
            Force "Shear force") "Types of BCs";
      end BaseClasses;
    end Mechanical;

    package Thermal "Thermal BCs"
      extends Modelica.Icons.Package;

      model Temperature
        "Prescribed temperature difference, with energy conservation"
        extends BaseClasses.PartialBC(final bCType=BaseClasses.BCType.Temperature,
            redeclare FCSys.Connectors.RealInput u(final unit="l2.m/(N.T2)",
              displayUnit="K"));

      equation
        negative.T - positive.T = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="thermal");
      end Temperature;

      model HeatRate "Prescribed heat flow rate, with energy conservation"
        extends BaseClasses.PartialBC(final bCType=BaseClasses.BCType.HeatRate,
            redeclare FCSys.Connectors.RealInput u(final unit="l2.m/T3"));

      equation
        negative.Qdot = u_final;
        annotation (defaultComponentPrefixes="replaceable",
            defaultComponentName="thermal");
      end HeatRate;

      package BaseClasses "Base classes (not for direct use)"
        extends Modelica.Icons.BasesPackage;
        partial model PartialBC "Partial model for a BC for heat"
          extends FaceDifferential.BaseClasses.PartialBC;

          constant BCType bCType "Type of BC";
          // Note:  This is included so that the type of BC is recorded with the
          // results.

          FCSys.Connectors.Thermal negative
            "Heat connector for the negative face" annotation (Placement(
                transformation(extent={{-110,-10},{-90,10}})));
          FCSys.Connectors.Thermal positive
            "Heat connector for the positive face"
            annotation (Placement(transformation(extent={{90,-10},{110,10}})));

        equation
          0 = negative.Qdot + positive.Qdot "Energy conservation (no storage)";
          annotation (defaultComponentName="thermal");
        end PartialBC;

        type BCType = enumeration(
            Temperature "Temperature difference",
            HeatRate "Heat flow rate") "Types of BCs";
      end BaseClasses;
    end Thermal;

    package BaseClasses "Base classes (not for direct use)"
      extends Modelica.Icons.BasesPackage;

      partial model PartialSpecies
        "<html>Partial BC for a pair of faces of a <a href=\"modelica://FCSys.Subregions.Species\">Species</a> model (single-species)</html>"
        extends FCSys.BaseClasses.Icons.BCs.Double;

        parameter ThermoOpt thermoOpt=ThermoOpt.OpenDiabatic
          "Options for material and thermal subconnectors" annotation (
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(group="Assumptions",compact=true));

        // Material
        replaceable Material.Density material if thermoOpt == ThermoOpt.OpenDiabatic
          constrainedby Material.BaseClasses.PartialBC "Type of condition"
          annotation (
          __Dymola_choicesFromPackage=true,
          Dialog(
            group="Material",
            enable=thermoOpt == 3,
            __Dymola_descriptionLabel=true),
          Placement(transformation(extent={{-70,0},{-50,20}})));

        // Heat
        replaceable Thermal.Temperature thermal if thermoOpt <> ThermoOpt.ClosedAdiabatic
          constrainedby Thermal.BaseClasses.PartialBC "Type of condition"
          annotation (
          __Dymola_choicesFromPackage=true,
          Dialog(
            group="Heat",
            enable=thermoOpt <> 1,
            __Dymola_descriptionLabel=true),
          Placement(transformation(extent={{50,-40},{70,-20}})));
        // Note:  Dymola 7.4 doesn't recognize enumerations in the dialog enable
        // option, e.g.,
        //     enable=thermoOpt <> ThermoOpt.ClosedAdiabatic.
        // Therefore, the values of the enumerations are specified numerically.

        Connectors.RealInputBus u "Input bus for external signal sources"
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={0,40}), iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={0,40})));

      equation
        // Material
        connect(u.material, material.u) annotation (Line(
            points={{5.55112e-16,40},{0,40},{0,20},{-60,20},{-60,14}},
            color={0,0,127},
            smooth=Smooth.None), Text(
            string="%first",
            index=-1,
            extent={{-6,3},{-6,3}}));

        // Heat
        connect(u.thermal, thermal.u) annotation (Line(
            points={{5.55112e-16,40},{0,40},{0,20},{60,20},{60,-26}},
            color={0,0,127},
            smooth=Smooth.None), Text(
            string="%first",
            index=-1,
            extent={{-6,3},{-6,3}}));

        annotation (Diagram(graphics));
      end PartialSpecies;

      partial model PartialBC "Partial model for a BC"
        extends FCSys.BaseClasses.Icons.BCs.Double;

        parameter Boolean internal=true "Use internal specification"
          annotation (
          Evaluate=true,
          HideResult=true,
          choices(__Dymola_checkBox=true),
          Dialog(__Dymola_descriptionLabel=true));

        replaceable Modelica.Blocks.Sources.Constant spec(k=0) if internal
          constrainedby Modelica.Blocks.Interfaces.SO "Internal specification"
          annotation (
          __Dymola_choicesFromPackage=true,
          Dialog(__Dymola_descriptionLabel=true, enable=internal),
          Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={-30,30})));

        FCSys.Connectors.RealInput u if not internal "Value of BC" annotation (
            Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={0,40})));

      protected
        FCSys.Connectors.RealInputInternal u_final "Final value of BC"
          annotation (Placement(transformation(
              extent={{-10,-10},{10,10}},
              rotation=270,
              origin={0,-10})));

      equation
        connect(u, u_final) annotation (Line(
            points={{5.55112e-16,40},{5.55112e-16,27.5},{5.55112e-16,27.5},{
                5.55112e-16,15},{5.55112e-16,-10},{5.55112e-16,-10}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(spec.y, u_final) annotation (Line(
            points={{-30,19},{-30,10},{5.55112e-16,10},{5.55112e-16,-10}},
            color={0,0,127},
            smooth=Smooth.None));

      end PartialBC;
    end BaseClasses;
  end FaceDifferential;

  model Router "Connect two pairs of faces to pass through or cross over"
    extends FCSys.BaseClasses.Icons.Names.Top3;
    parameter Boolean crossOver=false "Cross over (otherwise, pass through)"
      annotation (Evaluate=true,choices(__Dymola_checkBox=true));
    FCSys.Connectors.FaceBus negative1 "Negative face 1" annotation (Placement(
          transformation(extent={{-90,-50},{-70,-30}}, rotation=0),
          iconTransformation(extent={{-90,-50},{-70,-30}})));
    FCSys.Connectors.FaceBus positive1 "Positive face 1" annotation (Placement(
          transformation(extent={{70,-50},{90,-30}}, rotation=0),
          iconTransformation(extent={{70,-50},{90,-30}})));
    FCSys.Connectors.FaceBus negative2 "Negative face 2" annotation (Placement(
          transformation(extent={{-90,30},{-70,50}}, rotation=0),
          iconTransformation(extent={{-90,30},{-70,50}})));
    FCSys.Connectors.FaceBus positive2 "Positive face 2" annotation (Placement(
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
    annotation (
      Documentation(info="<html>
<p>This model acts as a connection switch.
It has a single parameter, <code>crossOver</code>.  If <code>crossOver</code> is
set to <code>false</code>, then
the router is in the pass-through mode.
In pass-through mode, shown by Figure 1a,
<code>negative1</code> is connected to <code>positive1</code> and <code>negative2</code>
is connected to <code>positive2</code>.
If <code>crossOver</code> is set to true, then the router is in cross-over mode.
In cross-over mode, shown by Figure 1b, <code>negative1</code> is connected to <code>positive2</code>
and <code>negative2</code> is
connected to <code>positive1</code>. The only equations are
those generated by the model's <code>connect</code> statements.</p>

    <table border=\"0\" cellspacing=\"0\" cellpadding=\"2\" align=center>
      <tr align=center>
        <td align=center width=120>
          <img src=\"modelica://FCSys/resources/documentation/BCs/Router/PassThrough.png\">
<br><b>a:</b>  Pass-through
        </td>
        <td align=center>
          <img src=\"modelica://FCSys/resources/documentation/BCs/Router/CrossOver.png\">
<br><b>b:</b>  Cross-over
        </td>
      </tr>
      <tr align=center>
        <td colspan=2 align=center><b>Figure 1:</b> Modes of connection.</td>
      </tr>
    </table>
</html>"),
      Icon(graphics={
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
            smooth=Smooth.Bezier)}),
      Diagram(graphics));
  end Router;

  record Defaults "Global defaults for a model"
    extends FCSys.BaseClasses.Icons.Names.Top3;

    // Store the values of the base constants and units.
    final constant U.Bases.Base base=U.base "Base constants and units";

    parameter Boolean analysis=true "Include optional variables for analysis"
      annotation (choices(__Dymola_checkBox=true));

    parameter Q.PressureAbsolute p(nominal=1*U.atm) = 1*U.atm "Pressure";
    parameter Q.TemperatureAbsolute T(nominal=298.15*U.K) = 298.15*U.K
      "Temperature";
    parameter Q.NumberAbsolute RH(displayUnit="%") = 1 "Relative humidity";
    parameter Q.NumberAbsolute x_O2_dry(
      final max=1,
      displayUnit="%") = 0.208
      "<html>Dry gas O<sub>2</sub> fraction (<i>y</i><sub>O2 dry</sub>)</html>";
    // Value from http://en.wikipedia.org/wiki/Oxygen
    parameter Q.Acceleration a[Axis]=zeros(3)
      "Acceleration of the reference frame";

    final parameter Q.NumberAbsolute x_H2O(
      final max=1,
      displayUnit="%") = 0.2
      "<html>Gas H<sub>2</sub>O fraction (<i>y</i><sub>H2O</sub>)</html>";
    // TODO:  Cast this in terms of relative humidity.

    annotation (
      defaultComponentPrefixes="inner",
      missingInnerMessage="Your model is using an outer \"defaults\" record, but an inner \"defaults\" record is not defined.
For simulation, specify global default settings by dragging FCSys.BCs.Defaults into your model.
The default global default settings will be used for the current simulation.",
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
              100}}), graphics={
          Rectangle(
            extent={{-21.2132,21.2132},{21.2131,-21.2131}},
            lineColor={127,127,127},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={225,225,225},
            origin={30,30},
            rotation=135),
          Polygon(
            points={{-60,60},{-60,-100},{60,-100},{60,30},{30,30},{30,60},{-60,
                60}},
            lineColor={127,127,127},
            smooth=Smooth.None,
            fillColor={245,245,245},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-60,60},{-60,-100},{60,-100},{60,30},{30,60},{-60,60}},
            lineColor={127,127,127},
            smooth=Smooth.None),
          Line(
            points={{-40,4},{40,4}},
            color={127,127,127},
            smooth=Smooth.None),
          Line(
            points={{-40,-20},{40,-20}},
            color={127,127,127},
            smooth=Smooth.None),
          Line(
            points={{-40,-44},{40,-44}},
            color={127,127,127},
            smooth=Smooth.None),
          Line(
            points={{-40,-68},{40,-68}},
            color={127,127,127},
            smooth=Smooth.None),
          Line(
            points={{-40,28},{26,28}},
            color={127,127,127},
            smooth=Smooth.None)}),
      Diagram(graphics));

  end Defaults;

  package BaseClasses "Base classes (not for direct use)"
    extends Modelica.Icons.BasesPackage;

    block RealFunction
      "<html>Set an output signal according to a <code>Real</code> function of an input</html>"

      extends FCSys.BaseClasses.Icons.Names.Top2;
      //extends FCSys.BaseClasses.Icons.Blocks.ContinuousShort;

      FCSys.Connectors.RealInput u "Value of Real input" annotation (Placement(
            transformation(extent={{-110,-10},{-90,10}}), iconTransformation(
              extent={{-110,-10},{-90,10}})));
      FCSys.Connectors.RealOutput y=0.0*u
        "<html>Value of <code>Real</code> output</html>" annotation (Dialog(
            group="Time varying output signal"), Placement(transformation(
              extent={{90,-10},{110,10}}, rotation=0), iconTransformation(
              extent={{90,-10},{110,10}})));

      annotation (
        Icon(coordinateSystem(
            preserveAspectRatio=true,
            extent={{-100,-100},{100,100}},
            grid={2,2}),graphics={Rectangle(
                  extent={{-100,40},{100,-40}},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid,
                  lineColor={0,0,0}),Text(
                  extent={{-100,-10},{100,10}},
                  lineColor={127,127,127},
                  textString="%y")}),
        Diagram(coordinateSystem(
            preserveAspectRatio=true,
            extent={{-100,-100},{100,100}},
            grid={2,2}),graphics),
        Documentation(info="<html>
<p>
The (time-varying) <code>Real</code> output signal of this block can be defined in its
parameter menu via variable <i>y</i>. The purpose is to support the
easy definition of <code>Real</code> expressions in a block diagram. For example,
in the y-menu the definition <code>if time &gt; 1 then 1 else 0</code> can be given in order
to produce an output signal that transitions from zero to one at time one.  Note that
<code>time</code> is a built-in variable that is always
accessible and represents the \"model time.\"
Variable <i>y</i> is both a variable and a connector.
Variable <i>u</i> is too, and it may be used in the expression for <i>y</i>.
</p>
<p>This block has been adapted from <a href=\"modelica://Modelica.Blocks.Sources.RealExpression\">Modelica.Blocks.Sources.RealExpression</a>.</p>
</html>"));
    end RealFunction;
  end BaseClasses;


end BCs;
