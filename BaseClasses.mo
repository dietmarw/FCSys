within FCSys;
package BaseClasses "Base classes (not for direct use)"
  extends Modelica.Icons.BasesPackage;
  package Icons "Icons to annotate and represent classes"
    package BCs "Icons for boundary conditions"
      extends Modelica.Icons.Package;
      partial class Double "Icon for a two-connector boundary condition"
        //extends Names.Middle;
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
        //extends Names.Middle;
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
    end BCs;
    extends Modelica.Icons.Package;
    package Blocks "Icons for blocks (imperative or causal models)"
      extends Modelica.Icons.Package;
      partial class Continuous "Icon for a continuous-time block"
        //extends FCSys.BaseClasses.Icons.Names.Middle;
        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Rectangle(
                      extent={{-100,-100},{100,100}},
                      lineColor={0,0,127},
                      fillColor={255,255,255},
                      fillPattern=FillPattern.Solid),Text(
                      extent={{-100,-20},{100,20}},
                      textString="%name",
                      lineColor={0,0,0})}), Documentation(info="<html>
<p>
Block that has only the basic icon for an imperative
block (no declarations, no equations). Most blocks
of package Modelica.Blocks inherit directly or indirectly
from this block.
</p>
</html>"));
      end Continuous;

      partial class ContinuousShort "Short icon for a continuous block"
        extends Names.Middle;
        annotation (Icon(graphics={Rectangle(
                      extent={{-100,40},{100,-40}},
                      fillColor={255,255,255},
                      fillPattern=FillPattern.Solid,
                      lineColor={0,0,0}),Text(
                      extent={{-100,-20},{100,20}},
                      textString="%name",
                      lineColor={0,0,0})}));
      end ContinuousShort;

      partial class ContinuousShortWide
        "Short and wide icon for a continuous block"
        extends Names.Middle;
        annotation (Icon(graphics={Rectangle(
                      extent={{-120,40},{120,-40}},
                      fillColor={255,255,255},
                      fillPattern=FillPattern.Solid,
                      lineColor={0,0,0}),Text(
                      extent={{-120,-20},{120,20}},
                      textString="%name",
                      lineColor={0,0,0})}));
      end ContinuousShortWide;

      partial class Discrete "Icon for a discrete-time block"
        extends FCSys.BaseClasses.Icons.Names.Top5;
        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Rectangle(
                      extent={{-100,-100},{100,100}},
                      lineColor={0,0,127},
                      fillColor={223,223,159},
                      fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>
Block that has only the basic icon for an imperative and
discrete block (no declarations, no equations), e.g.,
from Blocks.Discrete.
</p>
</html>"));
      end Discrete;
    end Blocks;

    package Names
      "Icons labeled with the name of the class at various positions"
      extends Modelica.Icons.Package;
      partial class Top12

        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Rectangle(
                      extent={{-100,240},{100,280}},
                      fillColor={255,255,255},
                      fillPattern=FillPattern.Solid,
                      pattern=LinePattern.None),Text(
                      extent={{-100,240},{100,280}},
                      textString="%name",
                      lineColor={0,0,0})}));
      end Top12;

      partial class Top11

        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Rectangle(
                      extent={{-100,220},{100,260}},
                      fillColor={255,255,255},
                      fillPattern=FillPattern.Solid,
                      pattern=LinePattern.None),Text(
                      extent={{-100,220},{100,260}},
                      textString="%name",
                      lineColor={0,0,0})}));
      end Top11;

      partial class Top10

        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Rectangle(
                      extent={{-100,200},{100,240}},
                      fillColor={255,255,255},
                      fillPattern=FillPattern.Solid,
                      pattern=LinePattern.None),Text(
                      extent={{-100,200},{100,240}},
                      textString="%name",
                      lineColor={0,0,0})}));
      end Top10;

      partial class Top9

        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Rectangle(
                      extent={{-100,180},{100,220}},
                      fillColor={255,255,255},
                      fillPattern=FillPattern.Solid,
                      pattern=LinePattern.None),Text(
                      extent={{-100,180},{100,220}},
                      textString="%name",
                      lineColor={0,0,0})}));
      end Top9;

      partial class Top8

        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Rectangle(
                      extent={{-100,160},{100,200}},
                      fillColor={255,255,255},
                      fillPattern=FillPattern.Solid,
                      pattern=LinePattern.None),Text(
                      extent={{-100,160},{100,200}},
                      textString="%name",
                      lineColor={0,0,0})}));
      end Top8;

      partial class Top7

        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Rectangle(
                      extent={{-100,140},{100,180}},
                      fillColor={255,255,255},
                      fillPattern=FillPattern.Solid,
                      pattern=LinePattern.None),Text(
                      extent={{-100,140},{100,180}},
                      textString="%name",
                      lineColor={0,0,0})}));
      end Top7;

      partial class Top6

        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Rectangle(
                      extent={{-100,120},{100,160}},
                      fillColor={255,255,255},
                      fillPattern=FillPattern.Solid,
                      pattern=LinePattern.None),Text(
                      extent={{-100,120},{100,160}},
                      textString="%name",
                      lineColor={0,0,0})}));
      end Top6;

      partial class Top5

        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Rectangle(
                      extent={{-100,100},{100,140}},
                      fillColor={255,255,255},
                      fillPattern=FillPattern.Solid,
                      pattern=LinePattern.None),Text(
                      extent={{-100,100},{100,140}},
                      textString="%name",
                      lineColor={0,0,0})}));
      end Top5;

      partial class Top4

        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Rectangle(
                      extent={{-100,80},{100,120}},
                      fillColor={255,255,255},
                      fillPattern=FillPattern.Solid,
                      pattern=LinePattern.None),Text(
                      extent={{-100,80},{100,120}},
                      textString="%name",
                      lineColor={0,0,0})}));
      end Top4;

      partial class Top3

        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Rectangle(
                extent={{-100,60},{100,100}},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid,
                pattern=LinePattern.None), Text(
                extent={{-100,60},{100,100}},
                textString="%name",
                lineColor={0,0,0})}));
      end Top3;

      partial class Top2

        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Rectangle(
                      extent={{-100,40},{100,80}},
                      fillColor={255,255,255},
                      fillPattern=FillPattern.Solid,
                      pattern=LinePattern.None),Text(
                      extent={{-100,40},{100,80}},
                      textString="%name",
                      lineColor={0,0,0})}));
      end Top2;

      partial class Top1

        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Rectangle(
                      extent={{-100,20},{100,60}},
                      fillColor={255,255,255},
                      fillPattern=FillPattern.Solid,
                      pattern=LinePattern.None),Text(
                      extent={{-100,20},{100,60}},
                      textString="%name",
                      lineColor={0,0,0})}));
      end Top1;

      partial class Middle

        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Rectangle(
                      extent={{-100,-20},{100,20}},
                      fillColor={255,255,255},
                      fillPattern=FillPattern.Solid,
                      pattern=LinePattern.None),Text(
                      extent={{-100,-20},{100,20}},
                      textString="%name",
                      lineColor={0,0,0})}));
      end Middle;
    end Names;

    package SignalBuses "Icons for buses of signals (expandable connectors)"
      extends Modelica.Icons.Package;
      partial class Bidirectional "Icon for a signal bus"

        annotation (
          Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2},
              initialScale=0.2), graphics={Rectangle(
                      extent={{-20,2},{20,-2}},
                      lineColor={255,204,51},
                      lineThickness=0.5),Polygon(
                      points={{-80,50},{80,50},{100,30},{80,-40},{60,-50},{-60,
                  -50},{-80,-40},{-100,30},{-80,50}},
                      lineColor={0,0,0},
                      fillColor={255,204,51},
                      fillPattern=FillPattern.Solid),Ellipse(
                      extent={{-65,25},{-55,15}},
                      lineColor={0,0,0},
                      fillColor={0,0,0},
                      fillPattern=FillPattern.Solid),Ellipse(
                      extent={{-5,25},{5,15}},
                      lineColor={0,0,0},
                      fillColor={0,0,0},
                      fillPattern=FillPattern.Solid),Ellipse(
                      extent={{55,25},{65,15}},
                      lineColor={0,0,0},
                      fillColor={0,0,0},
                      fillPattern=FillPattern.Solid),Ellipse(
                      extent={{-35,-15},{-25,-25}},
                      lineColor={0,0,0},
                      fillColor={0,0,0},
                      fillPattern=FillPattern.Solid),Ellipse(
                      extent={{25,-15},{35,-25}},
                      lineColor={0,0,0},
                      fillColor={0,0,0},
                      fillPattern=FillPattern.Solid)}),
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2},
              initialScale=0.2), graphics={Polygon(
                      points={{-40,25},{40,25},{50,15},{40,-20},{30,-25},{-30,-25},
                  {-40,-20},{-50,15},{-40,25}},
                      lineColor={0,0,0},
                      fillColor={255,204,51},
                      fillPattern=FillPattern.Solid),Ellipse(
                      extent={{-32.5,7.5},{-27.5,12.5}},
                      lineColor={0,0,0},
                      fillColor={0,0,0},
                      fillPattern=FillPattern.Solid),Ellipse(
                      extent={{-2.5,12.5},{2.5,7.5}},
                      lineColor={0,0,0},
                      fillColor={0,0,0},
                      fillPattern=FillPattern.Solid),Ellipse(
                      extent={{27.5,12.5},{32.5,7.5}},
                      lineColor={0,0,0},
                      fillColor={0,0,0},
                      fillPattern=FillPattern.Solid),Ellipse(
                      extent={{-17.5,-7.5},{-12.5,-12.5}},
                      lineColor={0,0,0},
                      fillColor={0,0,0},
                      fillPattern=FillPattern.Solid),Ellipse(
                      extent={{12.5,-7.5},{17.5,-12.5}},
                      lineColor={0,0,0},
                      fillColor={0,0,0},
                      fillPattern=FillPattern.Solid),Text(
                      extent={{-150,50},{150,90}},
                      textString="%name",
                      lineColor={0,0,0})}),
          Documentation(info="<html>
<p>
This icon is designed for a <b>signal bus</b> connector.
</p>
</html>"));
      end Bidirectional;

      partial class In "Icon for a bus input"
        extends FCSys.BaseClasses.Icons.SignalBuses.Bidirectional;
        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Polygon(
                      points={{-160,40},{40,40},{-60,-160},{-160,40}},
                      smooth=Smooth.None,
                      fillColor={255,255,255},
                      fillPattern=FillPattern.Solid,
                      origin={-240,60},
                      rotation=90,
                      lineColor={255,204,51}),Rectangle(
                      extent={{-20,2},{20,-2}},
                      lineColor={255,204,51},
                      lineThickness=0.5)}), Diagram(coordinateSystem(
                preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
              graphics={Polygon(
                      points={{-42,40},{58,40},{8,-60},{-42,40}},
                      smooth=Smooth.None,
                      fillColor={255,204,51},
                      fillPattern=FillPattern.Solid,
                      origin={80,-8},
                      rotation=90,
                      lineColor={255,204,51})}));
      end In;

      partial class Out "Icon for a bus output"
        extends FCSys.BaseClasses.Icons.SignalBuses.Bidirectional;
        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Rectangle(
                      extent={{-20,2},{20,-2}},
                      lineColor={255,204,51},
                      lineThickness=0.5),Polygon(
                      points={{-160,40},{40,40},{-60,-160},{-160,40}},
                      smooth=Smooth.None,
                      fillColor={255,204,51},
                      fillPattern=FillPattern.Solid,
                      origin={120,60},
                      rotation=90,
                      lineColor={255,204,51})}), Diagram(coordinateSystem(
                preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
              graphics={Polygon(
                      points={{-10,40},{90,40},{40,140},{-10,40}},
                      lineColor={255,204,51},
                      smooth=Smooth.None,
                      origin={-178,40},
                      rotation=270,
                      fillColor={255,255,255},
                      fillPattern=FillPattern.Solid)}));
      end Out;
    end SignalBuses;

    partial class Cell "Icon for a cell"
      //extends FCSys.BaseClasses.Icons.Names.Top3;
      annotation (Icon(coordinateSystem(
            preserveAspectRatio=true,
            extent={{-100,-100},{100,100}},
            initialScale=0.1), graphics={Rectangle(
                  extent={{-100,60},{100,100}},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid,
                  pattern=LinePattern.None),Polygon(
                  points={{-4,52},{-14,42},{6,42},{16,52},{-4,52}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),Polygon(
                  points={{-10,52},{-20,42},{-14,42},{-4,52},{-10,52}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={0,0,0}),Rectangle(
                  extent={{6,42},{12,-52}},
                  fillPattern=FillPattern.Solid,
                  fillColor={0,0,0},
                  pattern=LinePattern.None),Polygon(
                  points={{16,52},{6,42},{12,42},{22,52},{16,52}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={0,0,0}),Line(
                  points={{-40,42},{-40,-52}},
                  pattern=LinePattern.None,
                  smooth=Smooth.None),Polygon(
                  points={{-46,64},{-66,44},{-46,44},{-26,64},{-46,64}},
                  lineColor={0,0,0},
                  fillColor={135,135,135},
                  fillPattern=FillPattern.Solid),Rectangle(
                  extent={{-39.6277,31.7996},{-67.912,17.6573}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  rotation=45,
                  fillColor={255,255,255},
                  origin={56.5067,67.5353}),Rectangle(
                  extent={{-14,42},{6,-52}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.VerticalCylinder,
                  fillColor={255,255,255}),Line(points={{-30,52},{32,52}},
              color={0,0,0}),Rectangle(
                  extent={{-5.21738,-5.21961},{-33.5017,-33.5041}},
                  lineColor={0,0,170},
                  fillPattern=FillPattern.HorizontalCylinder,
                  rotation=45,
                  fillColor={0,0,240},
                  origin={31.9983,69.3803}),Rectangle(
                  extent={{12,42},{52,-52}},
                  lineColor={0,0,170},
                  fillPattern=FillPattern.VerticalCylinder,
                  fillColor={0,0,240}),Polygon(
                  points={{-26,64},{-46,44},{-46,-64},{-26,-44},{-26,64}},
                  lineColor={0,0,0},
                  fillColor={95,95,95},
                  fillPattern=FillPattern.Solid),Rectangle(
                  extent={{-5.21774,-5.2196},{-33.502,-33.5042}},
                  lineColor={170,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  rotation=45,
                  fillColor={240,0,0},
                  origin={-30.001,79.3803}),Rectangle(
                  extent={{-60,42},{-20,-52}},
                  lineColor={170,0,0},
                  fillPattern=FillPattern.VerticalCylinder,
                  fillColor={240,0,0}),Rectangle(
                  extent={{-76.648,66.211},{-119.073,52.0689}},
                  lineColor={95,95,95},
                  fillPattern=FillPattern.HorizontalCylinder,
                  rotation=45,
                  fillColor={135,135,135},
                  origin={65.0166,81.3801}),Rectangle(
                  extent={{-76.648,66.211},{-119.073,52.0689}},
                  lineColor={95,95,95},
                  fillPattern=FillPattern.HorizontalCylinder,
                  rotation=45,
                  fillColor={135,135,135},
                  origin={157,81}),Rectangle(
                  extent={{26,44},{46,-64}},
                  lineColor={95,95,95},
                  fillPattern=FillPattern.VerticalCylinder,
                  fillColor={135,135,135}),Polygon(
                  points={{-26,64},{-26,52},{-30,52},{-30,60},{-26,64}},
                  smooth=Smooth.None,
                  fillColor={95,95,95},
                  fillPattern=FillPattern.Solid,
                  pattern=LinePattern.None,
                  lineColor={0,0,0}),Ellipse(
                  extent={{-44,62},{-36,58}},
                  lineColor={135,135,135},
                  fillColor={240,0,0},
                  fillPattern=FillPattern.Sphere),Ellipse(
                  extent={{36,50},{44,46}},
                  lineColor={135,135,135},
                  fillColor={0,0,240},
                  fillPattern=FillPattern.Sphere),Polygon(
                  points={{-26,64},{-26,52},{-30,52},{-40,42},{-40,-52},{-34,-52},
                {-46,-64},{-46,44},{-26,64}},
                  smooth=Smooth.None,
                  fillColor={95,95,95},
                  fillPattern=FillPattern.Solid,
                  pattern=LinePattern.None,
                  lineColor={0,0,0}),Polygon(
                  points={{66,64},{46,44},{46,-64},{66,-44},{66,64}},
                  lineColor={0,0,0},
                  fillColor={95,95,95},
                  fillPattern=FillPattern.Solid),Rectangle(
                  extent={{-20,42},{-14,-52}},
                  fillPattern=FillPattern.Solid,
                  fillColor={0,0,0},
                  pattern=LinePattern.None),Rectangle(extent={{26,44},{46,-64}},
              lineColor={0,0,0}),Rectangle(
                  extent={{-66,44},{-46,-64}},
                  lineColor={95,95,95},
                  fillPattern=FillPattern.VerticalCylinder,
                  fillColor={135,135,135}),Rectangle(extent={{-66,44},{-46,-64}},
              lineColor={0,0,0}),Line(
                  points={{-34,-52},{-46,-64}},
                  color={0,0,0},
                  smooth=Smooth.None),Polygon(
                  points={{66,74},{66,64},{46,64},{34,52},{-26,52},{-26,64},{-46,
                64},{-46,74},{66,74}},
                  smooth=Smooth.None,
                  fillPattern=FillPattern.Solid,
                  fillColor={255,255,255},
                  pattern=LinePattern.None),Polygon(
                  points={{46,64},{66,64},{46,44},{26,44},{46,64}},
                  lineColor={0,0,0},
                  smooth=Smooth.None),Polygon(
                  points={{-46,64},{-26,64},{-46,44},{-66,44},{-46,64}},
                  lineColor={0,0,0},
                  smooth=Smooth.None),Line(points={{26,42},{-40,42},{-30,52},{
              34,52}}, color={0,0,0}),Line(
                  points={{-26,64},{-26,52}},
                  color={0,0,0},
                  smooth=Smooth.None),Line(
                  points={{-40,42},{-40,-52},{26,-52}},
                  color={0,0,0},
                  smooth=Smooth.None),Text(
                  extent={{-150,60},{150,100}},
                  textString="%name",
                  lineColor={0,0,0})}), Diagram(coordinateSystem(
            preserveAspectRatio=true,
            extent={{-100,-100},{100,100}},
            initialScale=0.1)));
    end Cell;

    partial class PackageUnderConstruction
      "Overlay that indicates a package is under construction"
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Polygon(
              points={{-70,-70},{-10,50},{50,-70},{-70,-70}},
              lineColor={255,0,0},
              lineThickness=0.5,
              smooth=Smooth.None)}), Documentation(info="<html>
<p>Package developers can use this icon to indicate that the respective model is under construction.</p>
</html>"));
    end PackageUnderConstruction;

    partial class Sensor "Icon for a sensor"

      //extends FCSys.BaseClasses.Icons.Names.Top4;
      annotation (Icon(graphics={Rectangle(
                  extent={{-100,74},{100,114}},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid,
                  pattern=LinePattern.None),Ellipse(
                  extent={{-70,70},{70,-70}},
                  lineColor={0,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),Line(points={{0,70},{0,40}},
              color={0,0,0}),Line(points={{22.9,32.8},{40.2,57.3}}, color={0,0,
              0}),Line(points={{-22.9,32.8},{-40.2,57.3}}, color={0,0,0}),Line(
              points={{37.6,13.7},{65.8,23.9}}, color={0,0,0}),Line(points={{-37.6,
              13.7},{-65.8,23.9}}, color={0,0,0}),Line(points={{0,0},{9.02,28.6}},
              color={0,0,0}),Polygon(
                  points={{-0.48,31.6},{18,26},{18,57.2},{-0.48,31.6}},
                  lineColor={0,0,0},
                  fillColor={0,0,0},
                  fillPattern=FillPattern.Solid),Ellipse(
                  extent={{-5,5},{5,-5}},
                  lineColor={0,0,0},
                  fillColor={0,0,0},
                  fillPattern=FillPattern.Solid),Line(points={{0,-100},{0,-70}},
              color={0,0,127}),Text(
                  extent={{-100,74},{100,114}},
                  textString="%name",
                  lineColor={0,0,0})}));
    end Sensor;
  end Icons;

  package Utilities "Functions that implement useful algorithms"
    extends Modelica.Icons.Package;
    package Examples "Examples and tests"
      extends Modelica.Icons.ExamplesPackage;

      function TestFunctions "Test all the functions"
        extends Modelica.Icons.Function;

        output Boolean ok "true, if all tests passed";

      protected
        String strings[6];
        Integer integers[6];

      algorithm
        // Test the subpackages.
        assert(Chemistry.Examples.TestFunctions(),
          "The Chemistry subpackage failed.");
        assert(Polynomial.Examples.Testf(), "The Polynomial subpackage failed.");

        // average()
        assert(average({1,2,3}) == 2, "The average function failed.");

        // cartWrap()
        assert(cartWrap(0) == 3, "The cartWrap function failed.");
        assert(cartWrap(4) == 1, "The cartWrap function failed.");

        // countTrue()
        assert(countTrue({true,false,true}) == 2,
          "The countTrue function failed.");

        // Delta()
        assert(Delta({1,2}) == -1, "The Delta function failed.");
        for i in 1:2 loop
          assert((Delta([1, 2; 3, 4]))[i] == -1,
            "The Delta function failed on entry " + String(i) + ".");
        end for;

        // enumerate()
        for i in 1:3 loop
          assert((enumerate({true,false,true}))[i] == {1,0,2}[i],
            "The enumerate function failed on entry " + String(i) + ".");
        end for;

        // index()
        for i in 1:2 loop
          assert((index({true,false,true}))[i] == {1,3}[i],
            "The index function failed on entry " + String(i) + ".");
        end for;

        // inSign()
        assert(inSign(FCSys.BaseClasses.Side.n) == 1,
          "The inSign function failed.");
        assert(inSign(FCSys.BaseClasses.Side.p) == -1,
          "The inSign function failed.");

        // mod1()
        assert(mod1(4, 3) == 1, "The mod1 function failed.");
        assert(mod1(3, 3) == 3, "The mod1 function failed.");
        // Compare mod1() to mod():
        assert(mod(3, 3) == 0, "The mod function failed.");

        // round()
        for i in 1:5 loop
          assert((round({-1.6,-0.4,1.4,1.6,5}))[i] == {-2,0,1,2,5}[i],
            "The round function failed on entry " + String(i) + ".");
        end for;

        // Sigma()
        assert(Sigma({1,2}) == 3, "The Sigma function failed.");
        for i in 1:2 loop
          assert((Sigma([1, 2; 3, 4]))[i] == {3,7}[i],
            "The Sigma function failed on entry " + String(i) + ".");
        end for;
        // Compare Sigma() to sum():
        assert(sum([1, 2; 3, 4]) == 10, "The sum function failed.");

        ok := true;
        annotation (Documentation(info="<html><p>
  This function call will fail if any of the functions return an
  incorrect result.  It will return true if all of the functions pass.
  There are no inputs.</p></html>"));
      end TestFunctions;
    end Examples;

    package Chemistry "Functions to support chemistry"
      package Examples "Examples and tests"
        extends Modelica.Icons.ExamplesPackage;

        function TestFunctions "Test all the functions"
          extends Modelica.Icons.Function;

          output Boolean ok "true, if all tests passed";

        protected
          String strings[6];
          Integer integers[6];

        algorithm
          // charge()
          for i in 1:2 loop
            assert((charge({"H2O","e-","Hg2+2",""}))[i] == {0,-1,2,0}[i],
              "The charge function failed on entry " + String(i) + ".");
          end for;
          // Note:  As of Modelica 3.2 and Dymola 7.4, assert() doesn't accept
          // vectorized equations.

          // countElements()
          for i in 1:2 loop
            assert((countElements({"H2O","e-","C19HF37O5S",""}))[i] == {2,1,5,0}
              [i], "The countElements function failed on entry " + String(i) +
              ".");
          end for;

          // elements()
          (strings[1:6],integers[1:6]) := elements("C19HF37O5S-");
          for i in 1:6 loop
            assert(strings[i] == {"C","H","F","O","S","e-"}[i],
              "The elements function failed on entry " + String(i) + ".");
            assert(integers[i] == {19,1,37,5,1,1}[i],
              "The elements function failed on entry " + String(i) + ".");
          end for;

          // readElement()
          (strings[1],integers[1],integers[2],integers[3]) := readElement("H2");
          assert(strings[1] == "H",
            "The readElement function failed on the element output.");
          assert(integers[1] == 2,
            "The readElement function failed on the coeff output.");
          assert(integers[2] == 0,
            "The readElement function failed on the z output.");
          assert(integers[3] == 3,
            "The readElement function failed on the nextindex output.");
          (strings[1],integers[1],integers[2],integers[3]) := readElement(
            "Hg2+2");
          assert(strings[1] == "Hg",
            "The readElement function failed on the element output.");
          assert(integers[1] == 2,
            "The readElement function failed on the coeff output.");
          assert(integers[2] == 2,
            "The readElement function failed on the z output.");
          assert(integers[3] == 6,
            "The readElement function failed on the nextindex output.");

          // stoich()
          for i in 1:3 loop
            assert((stoich({"e-","H+","H2"}))[i] == {-2,-2,1}[i],
              "The stoich function failed on entry " + String(i) + ".");
          end for;
          for i in 1:4 loop
            assert((stoich({"e-","H+","O2","H2O"}))[i] == {-4,-4,-1,2}[i],
              "The stoich function failed on entry " + String(i) + ".");
          end for;

          ok := true;
          annotation (Documentation(info="<html><p>
  This function call will fail if any of the functions return an
  incorrect result.  It will return true if all of the functions pass.
  There are no inputs.</p></html>"));
        end TestFunctions;
      end Examples;
      extends Modelica.Icons.Package;
      function charge
        "Return the charge of a species based on its chemical formula"

        input String formula "Chemical formula";
        output Integer z "Charge number";

      external"C";
        annotation (Include="#include <FCSys/resources/source/C/Chemistry.c>",
            Documentation(info="<html><p>This function returns the net
  electrical charge associated with a species represented by a chemical
  formula (<code>formula</code>).  If the charge number is
  not given explicitly in the formula, then it is assumed to be zero.  A \"+\" or \"-\" without any immediately following digits is interpreted as
  a charge of +1 or -1, respectively.  If there is an error in the chemical formula,
  then 0 is returned.</p>

  <p><b>Example:</b><br>
  <code>charge(\"Hg2+2\")</code> returns 2.</p>
  </html>"));
      end charge;

      function countElements
        "Return the number of elements in a chemical formula"
        extends Modelica.Icons.Function;

        input String formula "Chemical formula";
        output Integer n "Number of elements";

      external"C";
        annotation (Include="#include <FCSys/resources/source/C/Chemistry.c>",
            Documentation(info="<html><p>This function returns the number of elements
      in a chemical formula.  Electrons are counted as an element (or rather particle)
      if the net charge is nonzero.
      </p>

      <p><b>Example:</b><br>
    <code>countElements(\"C19HF37O5S\")</code> returns 5.</p>

  <p>See the
  <a href=\"modelica://FCSys.BaseClasses.Utilities.ReadFormula\">ReadFormula</a> function
  for details about the format of the chemical formula.</p></html>"));
      end countElements;

      function elements
        "Return the symbols and coefficients of the elements in a chemical formula"
        extends Modelica.Icons.Function;

        input String formula "Chemical formula";
        output String symbols[countElements(formula)] "Symbols of the elements";
        output Integer coeffs[size(symbols, 1)] "Coefficients of the elements";
        // Note:  coeffs[countElements(formula)] would require redundant
        // computation.

      protected
        Integer z "Charge number";
        Integer z_net=0 "Net charge";
        Integer i=1 "index of element";
        Integer j=1 "index of character in formula string";
        Integer length=Modelica.Utilities.Strings.length(formula)
          "Length of formula";

      algorithm
        // Read the elements.
        while j <= length loop
          (symbols[i],coeffs[i],z,j) := readElement(formula, j);
          assert(j <> 0, "The formula is invalid.");
          z_net := z_net + z;
          if symbols[i] <> "e" then
            i := i + 1;
            // Electrons are counted below.
          end if;
        end while;

        // Add electrons according to the charge.
        if z_net <> 0 then
          symbols[i] := "e-";
          coeffs[i] := -z_net;
        end if;

        annotation (Documentation(info="<html><p>This function reads a chemical formula
  (<code>formula</code>) and returns the symbols (<code>symbols</code>)
  and coefficients (<code>coeffs</code>).  Each element
  is interpreted according to the rules in the
  <a href=\"modelica://FCSys.BaseClasses.Utilities.Chemistry.readElement\">readElement</a> function.
  Currently, <code>formula</code> may not contain parentheses or brackets.</p>

  <p>The symbols correspond to chemical/physical elements or electrons (\"e-\").
  Electrons will be listed if the charge is nonzero.</p>

  <p><b>Example:</b><br>
  <code>(symbols, coeffs) = elements(\"C19HF37O5S-\")</code> returns
  <code>symbols={\"C\", \"H\", \"F\", \"O\", \"S\", \"e-\"}</code> and <code>coeffs={19, 1, 37, 5, 1, 1}</code>.</p></html>"));
      end elements;

      function readElement
        "Return the symbol, coefficient, and charge of an element at an index in a chemical formula"

        input String formula "Chemical formula";
        input Integer startindex(min=1) = 1 "Start index";
        output String symbol "Name of element";
        output Integer coeff "Stoichiometric coefficient";
        output Integer z "Charge number";
        output Integer nextindex "index after the found element (0 if error)";

      external"C" readElement(
                formula,
                startindex,
                symbol,
                coeff,
                z,
                nextindex);
        annotation (Include="#include <FCSys/resources/source/C/Chemistry.c>",
            Documentation(info="<html><p>This function returns the <code>symbol</code>,
  stoichiometric coefficient (<code>coeff</code>), and
  electrical charge (<code>z</code>) associated with an element as it appears in a chemical
  formula (<code>formula</code>).  The <code>formula</code> string is read beginning
  at <code>startindex</code>. After any initial whitespace, which is ignored,  the
  symbol must begin with a letter and may continue with lowercase letters.  The symbol may be
  followed by a positive integer and then a charge number (both independently optional).
  If present, the charge number must begin with \"+\" or \"-\" and may be followed by optional digits.
  The <code>nextindex</code> output gives the index in the <code>formula</code> string after the symbol
  and the associated information.</p>

  <p>If the coefficient is not explicitly given, it is assumed to be one.  If the charge number is
  not given, then it is assumed to be zero.  A \"+\" or \"-\" without following digits is interpreted as
  a charge of +1 or -1, respectively.  If there is an error,
  then <code>nextindex</code> will be zero.  Both <code>startindex</code> and <code>nextindex</code> are
  one-based indices (Modelica format).</p>

  <p><b>Example:</b><br>
  <code>(symbol, coeff, z, nextindex) = ReadFormula(\"Hg2+2\")</code> returns
  <code>symbol=\"Hg\"</code>, <code>coeff=2</code>, <code>z=2</code>, and <code>nextindex=6</code>.</p>
  </html>"));
      end readElement;

      function stoich
        "Return stoichiometric coefficients of a reaction based on chemical formulas of reacting species"
        extends Modelica.Icons.Function;

        input String formulas[:] "Chemical formulas of the species";
        output Integer nu[size(formulas, 1)] "Stoichiometric coefficients";

      protected
        Integer n_species=size(formulas, 1) "Number of species";
        Integer n_elements[n_species]=countElements(formulas)
          "Number of elements within each species";
        Integer n_tot=sum(n_elements) "Total number of elements";
        String allSymbols[n_tot] "Symbols of all the elementary components";
        String symbols[n_species, max(n_elements)]
          "Symbols of the elements of each species";
        Integer coeffs[n_species, max(n_elements)]
          "Coefficients of the elements of each species";
        Integer i "index";
        Integer j=1 "index";
        Real d[n_species] "Diagonal entries of SVD";
        Real u[n_species, n_species] "1st unitary matrix of SVD";
        Real v[n_species, n_species] "2nd unitary matrix of SVD";
        Real minabs
          "Minimum magnitude of the unnormalized stoichiometric coefficients";
        Real elementCoeffs[n_species, n_tot] "Elementary coefficients";

      algorithm
        // Generate a list of all the symbols.
        for i in 1:n_species loop
          (symbols[i, 1:n_elements[i]],coeffs[i, 1:n_elements[i]]) := elements(
            formulas[i]);
          allSymbols[j:j + n_elements[i] - 1] := symbols[i, 1:n_elements[i]];
          j := j + n_elements[i];
        end for;

        // Reduce the list to a (unique) set.
        i := 1;
        while i < n_tot loop
          j := i + 1;
          while j <= n_tot loop
            if allSymbols[i] == allSymbols[j] then
              allSymbols[j] := allSymbols[n_tot];
              n_tot := n_tot - 1;
            else
              j := j + 1;
            end if;
          end while;
          i := i + 1;
        end while;
        // Note:  While loops are used since the upper bound changes.

        // Find the elementary coefficients for each species in terms of the
        // unique list of symbols.
        elementCoeffs[:, 1:n_tot] := zeros(n_species, n_tot);
        for i in 1:n_species loop
          for j in 1:n_elements[i] loop
            for k in 1:n_tot loop
              if allSymbols[k] == symbols[i, j] then
                elementCoeffs[i, k] := coeffs[i, j];
                break;
              end if;
            end for;
          end for;
        end for;

        // Perform singular value decomposition (SVD).
        assert(n_species == n_tot + 1, "The reaction is ill-posed.\n" + (if
          n_species > n_tot + 1 then
          "A species may be included more than once." else
          "A species may be missing or the wrong one has been entered."));
        (d,u,v) := Modelica.Math.Matrices.singularValues(cat(
                2,
                elementCoeffs[:, 1:n_tot],
                zeros(n_species, 1)));
        // This approach is based on [Reichert2010].

        // Extract the stoichiometric coefficients and normalize them.
        minabs := min(abs(u[:, end]));
        assert(minabs > 0, "The reaction is ill-posed.
An unrelated species may be included.");
        nu := round(u[:, end]/minabs);

        annotation (Documentation(info="<html><p>This function returns a vector of
  stoichiometric coefficients (<code>nu</code>) that balance a chemical reaction
  among the species given by a vector of chemical formulas (<code>formulas</code>).
  If the reaction is ill-posed or non-unique, then the function will fail with
  a message.  Each formula is interpreted according to the rules in the
  <a href=\"modelica://FCSys.BaseClasses.Utilities.ReadFormula\">ReadFormula</a>
  function.</p>

  <p><b>Example:</b><br>
  <code>stoich({\"e-\",\"H+\",\"O2\",\"H2O\"})</code> returns <code>{-4,-4,-1,2}</code>,
  which indicates the reaction 4e<sup>-</sup> + 4H<sup>+</sup> + O<sub>2</sub> &#8652; 2H<sub>2</sub>O.</p>
  </html>"));
      end stoich;
    end Chemistry;

    package Polynomial "Polynomial functions"
      package Examples "Examples and tests"
        extends Modelica.Icons.ExamplesPackage;

        function Testf
          "<html>Test <a href=\"modelica://FCSys.BaseClasses.Utilities.Polynomial.f\">f</a>()</html>"
          extends Modelica.Icons.Function;

          output Boolean ok "true, if all tests passed";

        algorithm
          assert(f( 2,
                    {1,2,1},
                    0) == 1 + 2*2 + 1*2^2, "The f function failed.");
          assert(f(2, zeros(0)) == 0, "The f function failed.");
          assert(f(2, {1}) == 1, "The f function failed.");
          assert(f(2, {0,0,1}) == 4, "The f function failed.");
          assert(f(2, ones(8)) == 2^8 - 1, "The f function failed.");
          assert(f( 2,
                    {1,0,0},
                    -3) == 1/8, "The f function failed.");
          // Note:  F(), dF(), df(), and d2f() are not tested here.  They can be
          // tested by simulating TestF, TestdF, Testdf, and Testd2f.

          ok := true;
          annotation (Documentation(info="<html><p>
  This function call will fail if any of the functions return an
  incorrect result.  It will return true if all of the functions pass.
  There are no inputs.</p></html>"));
        end Testf;

        model TestF
          "<html>Verify that <a href=\"modelica://FCSys.BaseClasses.Utilities.Polynomial.F\">F</a>() is correctly related to <a href=\"modelica://FCSys.BaseClasses.Utilities.Polynomial.f\">f</a>()</html>"
          // This approach is based on [Dassault2010, vol. 2, pp. 300-301].

          extends Modelica.Icons.Example;

          parameter Integer n=-1 "Power of the first polynomial term";

          Real u1=1 + time
            "Real arguments to function (must have sufficient richness)";
          parameter Real u2[:]=1:3
            "Real arguments to function (must have sufficient richness)";
          // u2 must not be time-varying.  Otherwise, there's no requirement
          // that y1 == y2.
          Real y1 "Direct result of function";
          Real y2 "Integral of derivative of y1";

        initial equation
          y2 = y1;

        equation
          y1 = F(   u1,
                    u2,
                    n);
          f(        u1,
                    u2,
                    n) = der(y2);

          assert(abs(y1 - y2) < 1e-6, "The derivative is incorrect.");
          // The simulation tolerance is set to 1e-8.
          annotation (experiment(Tolerance=1e-8), experimentSetupOutput);
        end TestF;

        model TestdF
          "<html>Verify that <a href=\"modelica://FCSys.BaseClasses.Utilities.Polynomial.dF\">dF</a>() is the correct derivative of <a href=\"modelica://FCSys.BaseClasses.Utilities.Polynomial.F\">F</a>()</html>"
          // This approach is based on [Dassault2010, vol. 2, pp. 300-301].

          extends Modelica.Icons.Example;

          parameter Integer n=-1 "Power of the first polynomial term";

          Real u1=1 + time
            "Real arguments to function (must have sufficient richness)";
          Real u2[:]=(1 + time^2)*(1:3)
            "Real arguments to function (must have sufficient richness)";
          Real y1 "Direct result of function";
          Real y2 "Integral of derivative of y1";

        initial equation
          y2 = y1;

        equation
          y1 = F(   u1,
                    u2,
                    n);
          dF(       u1,
                    u2,
                    n,
                    der(u1),
                    der(u2)) = der(y2);
          // Note:  This is equivalent to der(y1) = der(y2), but it must be
          // explicit to ensure that the translator uses the defined derivative
          // instead of the automatically derived one.

          assert(abs(y1 - y2) < 1e-6, "The derivative is incorrect.");
          // The simulation tolerance is set to 1e-8.
          annotation (experiment(Tolerance=1e-8), experimentSetupOutput);
        end TestdF;

        model Testdf
          "<html>Verify that <a href=\"modelica://FCSys.BaseClasses.Utilities.Polynomial.df\">df</a>() is the correct derivative of <a href=\"modelica://FCSys.BaseClasses.Utilities.Polynomial.f\">f</a>()</html>"
          // This approach is based on [Dassault2010, vol. 2, pp. 300-301].

          extends Modelica.Icons.Example;

          parameter Integer n=-1 "Power of the first polynomial term";

          Real u1=1 + time
            "Real arguments to function (must have sufficient richness)";
          Real u2[:]=(1 + time^2)*(1:3)
            "Real arguments to function (must have sufficient richness)";
          Real y1 "Direct result of function";
          Real y2 "Integral of derivative of y1";

        initial equation
          y2 = y1;

        equation
          y1 = f(   u1,
                    u2,
                    n);
          df(       u1,
                    u2,
                    n,
                    der(u1),
                    der(u2)) = der(y2);
          // Note:  This is equivalent to der(y1) = der(y2), but it must be
          // explicit to ensure that the translator uses the defined derivative
          // instead of the automatically derived one.

          assert(abs(y1 - y2) < 1e-6, "The derivative is incorrect.");
          // The simulation tolerance is set to 1e-8.
          annotation (experiment(Tolerance=1e-8), experimentSetupOutput);
        end Testdf;

        model Testd2f
          "<html>Verify that <a href=\"modelica://FCSys.BaseClasses.Utilities.Polynomial.d2f\">d2f</a>() is the correct derivative of <a href=\"modelica://FCSys.BaseClasses.Utilities.Polynomial.df\">df</a>()</html>"
          // This approach is based on [Dassault2010, vol. 2, pp. 300-301].

          extends Modelica.Icons.Example;

          parameter Integer n=-1 "Power of the first polynomial term";

          Real u1=1 + time
            "Real arguments to function (must have sufficient richness)";
          Real u2[:]=(1 + time^2)*(1:3)
            "Real arguments to function (must have sufficient richness)";
          Real y1 "Direct result of function";
          Real y2 "Integral of derivative of y1";

        protected
          final Real du1=der(u1) "Derivative of u1";
          final Real du2[:]=der(u2) "Derivative of u2";
          // In Dymola 7.4, it's necessary to explicitly define these intermediate
          // variables (since there are second-order derivatives).

        initial equation
          y2 = y1;

        equation
          y1 = df(  u1,
                    u2,
                    n,
                    du1,
                    du2);
          d2f(      u1,
                    u2,
                    n,
                    du1,
                    du2,
                    der(du1),
                    der(du2)) = der(y2);
          // Note:  This is equivalent to der(y1) = der(y2), but it must be
          // explicit to ensure that the translator uses the defined derivative
          // instead of the automatically derived one.

          assert(abs(y1 - y2) < 1e-6, "The derivative is incorrect.");
          // The simulation tolerance is set to 1e-8.
          annotation (experiment(Tolerance=1e-8), experimentSetupOutput);
        end Testd2f;

        model Translatef
          "<html>Evaluate the translated version of <a href=\"modelica://FCSys.BaseClasses.Utilities.Polynomial.f\">f</a>()</html>"
          extends Modelica.Icons.Example;

          output Real x1=f(
                      time,
                      {1,1,1,1},
                      0);
          // Manually check the translated model to be sure that the polynomial is
          // written in nested form (for efficiency).  In Dymola 7.4 turn on the
          // option "Generate listing of translated Modelica code in dsmodel.mof".
          // dsmodel.mof should contain:
          //     x1 := 1 + time*(1 + time*(1 + time)).
          output Real x2=f(time, ones(31));
          output Real x3=f(time, ones(32));
          // The function is only unrolled to a limited depth (currently 10th order
          // polynomial).  In Dymola 7.4 f(time, ones(31)) is implemented fully
          // recursively, but f(time, ones(32)) isn't.
          output Real x4=f(
                      time,
                      {1,1,1,1},
                      -3);
        end Translatef;
      end Examples;
      extends Modelica.Icons.Package;

      function F
        "<html>&int;<a href=\"modelica://FCSys.BaseClasses.Utilities.Polynomial.f\">f</a>()&middot;d<i>x</i> evaluated at <i>x</i> with zero integration constant</html>"
        extends Modelica.Icons.Function;

        input Real x "Argument";
        input Real a[:] "Coefficients";
        input Integer n=0
          "Power associated with the first term (before integral)";

        output Real F "Integral";

      algorithm
        F := f( x,
                a .* {if n + i == 0 then ln(x) else 1/(n + i) for i in 1:size(a,
            1)},
                n + 1) annotation (Inline=true, derivative=dF);

        annotation (Documentation(info="<html>
  <p>By definition, the partial derivative of this function with respect to <code>x</code>
  (with <code>a</code> constant)
  is <a href=\"modelica://FCSys.BaseClasses.Utilities.Polynomial.f\">f</a>().  The complete derivative,
  however, is <a href=\"modelica://FCSys.BaseClasses.Utilities.Polynomial.dF\">dF</a>().</p></html>"));
      end F;

      function dF
        "<html>Derivative of <a href=\"modelica://FCSys.BaseClasses.Utilities.Polynomial.F\">F</a>()</html>"
        extends Modelica.Icons.Function;

        input Real x "Argument";
        input Real a[:] "Coefficients";
        input Integer n=0
          "Power associated with the first term (before integral)";
        input Real dx "Derivative of argument";
        input Real da[size(a, 1)] "Derivatives of coefficients";

        output Real dF "Derivative";

      algorithm
        dF := f(x,
                a,
                n)*dx + f(
                x,
                da .* {if n + i == 0 then ln(x) else 1/(n + i) for i in 1:size(
            a, 1)},
                n + 1) annotation (Inline=true);
      end dF;

      function f
        "<html>Polynomial expressed in form: <i>f</i> = ((&hellip; + <i>a</i><sub>-1-<i>n</i></sub>)/<i>x</i> + <i>a</i><sub>-<i>n</i></sub>)/<i>x</i> + <i>a</i><sub>1-<i>n</i></sub> + <i>x</i>&middot;(<i>a</i><sub>2-<i>n</i></sub> + <i>x</i>&middot;(<i>a</i><sub>3-<i>n</i></sub> + &hellip;))</html>"
        extends Modelica.Icons.Function;

        input Real x "Argument";
        input Real a[:] "Coefficients";
        input Integer n=0 "Power of the first term";

        output Real f "Result";

      protected
        function positivePoly
          "<html>polynomial expressed in form: y = x*(a<sub>1</sub> + x*(a<sub>2</sub> + &hellip;))</html>"

          input Real x "Argument";
          input Real a[:] "Coefficients";
          output Real y "Result";

        algorithm
          y := if size(a, 1) > 0 then x*(a[1] + (if size(a, 1) > 1 then x*(a[2]
             + (if size(a, 1) > 2 then x*(a[3] + (if size(a, 1) > 3 then x*(a[4]
             + (if size(a, 1) > 4 then x*(a[5] + (if size(a, 1) > 5 then x*(a[6]
             + (if size(a, 1) > 6 then x*(a[7] + (if size(a, 1) > 7 then x*(a[8]
             + (if size(a, 1) > 8 then x*(a[9] + (if size(a, 1) > 9 then x*(a[
            10] + (if size(a, 1) > 10 then positivePoly(x, a[11:end]) else 0))
             else 0)) else 0)) else 0)) else 0)) else 0)) else 0)) else 0))
             else 0)) else 0)) else 0 annotation (Inline=true);
          // Note:  Dymola 7.4 does seem to not inline the recursive calls beyond
          // depth 1; therefore, the function is "unrolled" up to the 10th order.
          // Also, in Dymola 7.4, if this function is called from a stack of (nested)
          // functions, it seems to reduce the depth allowed for the nested
          // parentheses.  The implementation here ("unrolled" only up to the 10th
          // order) allows poly() to be called from within one other function within a
          // model.
        end positivePoly;

      algorithm
        f := (if n < 0 then (if n + size(a, 1) < 0 then x^(n + size(a, 1))
           else 1)*positivePoly(1/x, a[min(size(a, 1), -n):-1:1]) else 0) + (
          if n <= 0 and n > -size(a, 1) then a[1 - n] else 0) + (if n + size(a,
          1) > 1 then (if n > 1 then x^(n - 1) else 1)*positivePoly(x, a[1 +
          max(0, 1 - n):size(a, 1)]) else 0)
          annotation (Inline=true, derivative=df);
        // Here, Dymola 7.4 won't allow indexing via a[1 + max(0, 1 - n):end], so
        // a[1 + max(0, 1 - n):size(a, 1)] is necessary.
        annotation (Documentation(info="<html><p>For high-order polynomials, this
  is more computationally efficient than the form
  &Sigma;<i>a</i><sub><i>i</i></sub> <i>x</i><sup><i>n</i> + <i>i</i> - 1</sup>.</p>

  <p>Note that the order of the polynomial is
  <code>n + size(a, 1) - 1</code> (not <code>n</code>).</p>

  <p>The derivative of this function is
  <a href=\"modelica://FCSys.BaseClasses.Utilities.df\">df</a>().</p></html>"));
      end f;

      function df
        "<html>Derivative of <a href=\"modelica://FCSys.BaseClasses.Utilities.Polynomial.f\">f</a>()</html>"
        extends Modelica.Icons.Function;

        input Real x "Argument";
        input Real a[:] "Coefficients";
        input Integer n=0
          "Power associated with the first term (before derivative)";
        input Real dx "Derivative of argument";
        input Real da[size(a, 1)] "Derivatives of coefficients";

        output Real df "Derivative";

      algorithm
        df := f(x,
                a={(n + i - 1)*a[i] for i in 1:size(a, 1)},
                n=n - 1)*dx + f(
                x,
                da,
                n) annotation (Inline=true, derivative(order=2) = d2f);
        annotation (Documentation(info="<html>
<p>The derivative of this function is
  <a href=\"modelica://FCSys.BaseClasses.Utilities.d2f\">d2f</a>().</p></html>"));
      end df;

      function d2f
        "<html>Derivative of <a href=\"modelica://FCSys.BaseClasses.Utilities.Polynomial.df\">df</a>()</html>"
        extends Modelica.Icons.Function;

        input Real x "Argument";
        input Real a[:] "Coefficients";
        input Integer n=0
          "Power associated with the first term (before derivative)";
        input Real dx "Derivative of argument";
        input Real da[size(a, 1)] "Derivatives of coefficients";
        input Real d2x "Second derivative of argument";
        input Real d2a[size(a, 1)] "Second derivatives of coefficients";

        output Real d2f "Second derivative";

      algorithm
        d2f := sum(f(
                x,
                {a[i]*(n + i - 1)*(n + i - 2)*dx^2,(n + i - 1)*(2*da[i]*dx + a[
            i]*d2x),d2a[i]},
                n + i - 3) for i in 1:size(a, 1)) annotation (Inline=true);
      end d2f;
    end Polynomial;

    function average "Return the arithmetic mean of numbers"
      extends Modelica.Icons.Function;

      input Real u[:] "Vector of numbers";
      output Real average "Arithmetic mean";

    algorithm
      average := sum(u)/size(u, 1) annotation (Inline=true,Documentation(info="<html><p><b>Example:</b><br>
    <code>average({1,2,3})</code> returns 2.</p></html>"));
    end average;

    function cartWrap = mod1 (final den=Axis.z)
      "<html>Return the index to a Cartesian axis (1 to 3, i.e., <a href=\"modelica://FCSys.BaseClasses.Axis\">Axis.x</a> to <a href=\"modelica://FCSys.BaseClasses.Axis\">Axis.z</a>) after wrapping</html>"
      annotation (Inline=true, Documentation(info="<html><p><b>Examples:</b><br>
    <code>cartWrap(0)</code> returns 3 and <code>cartWrap(4)</code> returns 1.</p></html>"));

    function countTrue
      "<html>Return the number of <code>true</code> entries in a <code>Boolean</code> vector</html>"
      extends Modelica.Icons.Function;

      input Boolean u[:] "<html><code>Boolean</code> vector</html>";
      output Integer n "Number of true entries";

    algorithm
      n := sum(if u[i] then 1 else 0 for i in 1:size(u, 1))
        annotation (Inline=true);

      annotation (Documentation(info="<html><p><b>Example:</b><br>
    <code>countTrue({true,false,true})</code> returns 2.</p></html>"));
    end countTrue;

    function Delta
      "<html>Return the first entry of a vector minus the second (&Delta;<i><b>u</b></i>)</html>"
      extends Modelica.Icons.Function;

      input Real u[2] "Vector of size two";
      output Real Delta=u[1] - u[2] "First entry minus the second entry";

    algorithm
      Delta := u[1] - u[2] annotation (Inline=true, Documentation(info="<html><p>The translator should automatically
  vectorize (or \"matricize\") this function.  For example, <code>Delta([1,2;3,4])</code> returns <code>{-1,-1}</code>.</p></html>"));
    end Delta;

    function enumerate
      "<html>Enumerate the <code>true</code> entries in a <code>Boolean</code> vector (0 for <code>false</code> entries)</html>"
      extends Modelica.Icons.Function;

      input Boolean u[:] "<html><code>Boolean</code> vector</html>";
      output Integer enumerated[size(u, 1)]
        "Indices of the true entries (increasing order; 0 for false entries)";

    protected
      Integer count "Counter variable";

    algorithm
      count := 1;
      for i in 1:size(u, 1) loop
        if u[i] then
          enumerated[i] := count;
          count := count + 1;
        else
          enumerated[i] := 0;
        end if;
      end for;
      annotation (Inline=true,Documentation(info="<html><p><b>Example:</b><br>
  <code>enumerate({true,false,true})</code> returns <code>{1,0,2}</code>.</p></html>"));
    end enumerate;

    function index
      "<html>Return the indices of the <code>true</code> entries of a <code>Boolean</code> vector</html>"
      extends Modelica.Icons.Function;

      input Boolean u[:] "<html><code>Boolean</code> array</html>";
      output Integer indices[countTrue(u)] "Indices of the true entries";

    protected
      Integer count "Counter variable";

    algorithm
      count := 1;
      for i in 1:size(u, 1) loop
        if u[i] then
          indices[count] := i;
          count := count + 1;
        end if;
      end for;
      annotation (Inline=true,Documentation(info="<html>
  <p>The indices are 1-based (Modelica-compatible).</p>
  <p><b>Example:</b><br>
  <code>index({true,false,true})</code> returns <code>{1,3}</code>.</html>"));
    end index;

    function inSign "Sign for the direction into a side or face"
      extends Modelica.Icons.Function;

      input FCSys.BaseClasses.Side side "Side";
      output Integer sign "Sign indicating direction along the axis";

    algorithm
      sign := 3 - 2*side annotation (Inline=true);
      annotation (Inline=true,Documentation(info="<html><p><b>Examples:</b><br>
  <code>inSign(FCSys.BaseClasses.Side.n)</code> returns 1 and
  <code>inSign(FCSys.BaseClasses.Side.p)</code> returns -1.
  </html>"));
    end inSign;

    function mod1
      "Modulo operator for 1-based indexing (compatible with Modelica)"
      extends Modelica.Icons.Function;

      input Integer num "Dividend";
      input Integer den "Divisor";
      output Integer index "Remainder with 1-based indexing";

    algorithm
      index := mod(num - 1, den) + 1 annotation (Inline=true,Documentation(info
            ="<html><p><b>Examples:</b><br>
  <code>Mod(4,3)</code> returns
  1.  <code>mod1(3,3)</code> returns 3, but <code>mod(3,3)</code> returns 0 where
  <code>mod()</code> is the built-in modulo operator.</html>"));
    end mod1;

    function round
      "<html>Round a <code>Real</code> variable to the nearest integer</html>"
      extends Modelica.Icons.Function;

      input Real u "<html><code>Real</code> variable</html>";
      output Integer y "Nearest integer";

    algorithm
      y := integer(u + 0.5) annotation (Inline=true);
      annotation (Documentation(info="<html><p><b>Example:</b><br>
  <code>round(1.6)</code> returns 2 as an <code>Integer</code>.</p></html>"));
    end round;

    function Sigma
      "<html>Return the sum of the first and second entries of a vector (&Sigma;<i><b>u</b></i>)</html>"
      extends Modelica.Icons.Function;

      input Real u[2] "Vector of size two";
      output Real Sigma "Sum of the first and second entries";

    algorithm
      Sigma := u[1] + u[2] annotation (Inline=true,Documentation(info="<html><p>The translator should automatically
  vectorize (or \"matricize\") this function.  For example, <code>Sigma([1,2;3,4])</code> returns <code>{3,7}</code>.
  In contrast, <code>sum([1,2;3,4])</code> returns 10.</p></html>"));
    end Sigma;
  end Utilities;

  type Axis = enumeration(
      x "X",
      y "Y",
      z "Z") "Enumeration for Cartesian axes";
  type Orientation = enumeration(
      following "Along axis following normal axis in Cartesian coordinates",
      preceding "Along axis preceding normal axis in Cartesian coordinates")
    "Enumeration for transverse orientations across a face" annotation (
      Documentation(info="
    <html><p><code>Orientation.following</code> indicates the axis following the face-normal axis
    in Cartesian coordinates (x, y, z).
    <code>Orientation.preceding</code> indicates the axis preceding the face-normal axis
    in Cartesian coordinates (or following it twice).</p></html>"));
  type Side = enumeration(
      n "Negative",
      p "Positive (greater position along the Cartesian axis)")
    "Enumeration for sides of a region or subregion";
  annotation (Documentation(info="<html>
<p>
<b>Licensed by the Georgia Tech Research Corporation under the Modelica License 2</b><br>
Copyright 2007&ndash;2013, Georgia Tech Research Corporation.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>;
it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the
disclaimer of warranty) see <a href=\"modelica://FCSys.UsersGuide.ModelicaLicense2\">
FCSys.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\">
http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p></html>"));
end BaseClasses;
