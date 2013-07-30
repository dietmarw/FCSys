within FCSys;
package Phases "Mixtures of species"
  extends Modelica.Icons.Package;
  // **Use __Dymola_label for incl and species tags
  model Gas "Gas phase"
    import FCSys.BaseClasses.Utilities.countTrue;
    extends FCSys.Phases.BaseClasses.EmptyPhase(final n_spec=countTrue({inclH2,
          inclH2O,inclN2,inclO2}));

    // Conditionally include species.
    parameter Boolean inclH2=false "<html>Hydrogen (H<sub>2</sub>)</html>"
      annotation (
      HideResult=true,
      choices(__Dymola_checkBox=true),
      Dialog(
        group="Species",
        __Dymola_descriptionLabel=true,
        __Dymola_joinNext=true));
    replaceable FCSys.Species.H2.Gas.Fixed H2(final n_faces) if inclH2
      constrainedby FCSys.Species.Species(
      n_faces=n_faces,
      phi(each stateSelect=if reduceTrans then StateSelect.default else
            StateSelect.prefer),
      T(stateSelect=if reduceThermal then StateSelect.default else StateSelect.prefer))
      "<html>H<sub>2</sub> model</html>" annotation (
      __Dymola_choicesFromPackage=true,
      Dialog(
        group="Species",
        __Dymola_descriptionLabel=true,
        enable=inclH2),
      Placement(transformation(extent={{-10,-10},{10,10}})));

    parameter Boolean inclH2O=false "<html>Water (H<sub>2</sub>O)</html>"
      annotation (
      HideResult=true,
      choices(__Dymola_checkBox=true),
      Dialog(
        group="Species",
        __Dymola_descriptionLabel=true,
        __Dymola_joinNext=true));
    replaceable FCSys.Species.H2O.Gas.Fixed H2O(final n_faces) if inclH2O
      constrainedby FCSys.Species.Species(
      n_faces=n_faces,
      phi(each stateSelect=if reduceTrans then StateSelect.default else
            StateSelect.prefer),
      T(stateSelect=if reduceThermal then StateSelect.default else StateSelect.prefer))
      "<html>H<sub>2</sub>O model</html>" annotation (
      __Dymola_choicesFromPackage=true,
      Dialog(
        group="Species",
        __Dymola_descriptionLabel=true,
        enable=inclH2O),
      Placement(transformation(extent={{-10,-10},{10,10}})));

    parameter Boolean inclN2=false "<html>Nitrogen (N<sub>2</sub>)</html>"
      annotation (
      HideResult=true,
      choices(__Dymola_checkBox=true),
      Dialog(
        group="Species",
        __Dymola_descriptionLabel=true,
        __Dymola_joinNext=true));
    replaceable FCSys.Species.N2.Gas.Fixed N2(final n_faces) if inclN2
      constrainedby FCSys.Species.Species(
      n_faces=n_faces,
      phi(each stateSelect=if reduceTrans then StateSelect.default else
            StateSelect.prefer),
      T(stateSelect=if reduceThermal then StateSelect.default else StateSelect.prefer))
      "<html>N<sub>2</sub> model</html>" annotation (
      __Dymola_choicesFromPackage=true,
      Dialog(
        group="Species",
        __Dymola_descriptionLabel=true,
        enable=inclN2),
      Placement(transformation(extent={{-10,-10},{10,10}})));

    parameter Boolean inclO2=false "<html>Oxygen (O<sub>2</sub>)</html>"
      annotation (
      HideResult=true,
      choices(__Dymola_checkBox=true),
      Dialog(
        group="Species",
        __Dymola_descriptionLabel=true,
        __Dymola_joinNext=true));
    replaceable FCSys.Species.O2.Gas.Fixed O2(final n_faces) if inclO2
      constrainedby FCSys.Species.Species(
      n_faces=n_faces,
      phi(each stateSelect=if reduceTrans then StateSelect.default else
            StateSelect.prefer),
      T(stateSelect=if reduceThermal then StateSelect.default else StateSelect.prefer))
      "<html>O<sub>2</sub> model</html>" annotation (
      __Dymola_choicesFromPackage=true,
      Dialog(
        group="Species",
        __Dymola_descriptionLabel=true,
        enable=inclO2),
      Placement(transformation(extent={{-10,-10},{10,10}})));

    parameter Boolean inclHOR=false "Hydrogen oxidation" annotation (
      HideResult=true,
      Dialog(group="Included reactions", compact=true),
      choices(__Dymola_checkBox=true));
    parameter Boolean inclORR=false "Oxygen reduction" annotation (
      HideResult=true,
      Dialog(group="Included reactions", compact=true),
      choices(__Dymola_checkBox=true));
    // These can't be outer parameters in Dymola 7.4.

    Conditions.Adapters.ChemicalReaction HOR(
      final m=H2.Data.m,
      n=-1,
      final n_trans=n_trans) if inclHOR
      "Adapter for the chemical contribution of H2 to the hydrogen oxidation reaction"
      annotation (Placement(transformation(extent={{-10,40},{-30,60}})));
    Conditions.Adapters.ChemicalReaction ORR[2](
      n={-1,2},
      final m={O2.Data.m,H2O.Data.m},
      each final n_trans=n_trans) if inclORR
      "Adapter for the chemical contribution of O2 and H2O to the oxygen reduction reaction"
      annotation (Placement(transformation(extent={{-10,20},{-30,40}})));
    Connectors.PhysicalBus physical if inclH2O "Connector for phase change"
      annotation (Placement(transformation(extent={{-37,3},{-17,23}}),
          iconTransformation(extent={{-61,41},{-41,61}})));
    Connectors.Reaction chemical(final n_trans=n_trans) if inclHOR or inclORR
      "Connector for a chemical reaction" annotation (Placement(transformation(
            extent={{-50,40},{-30,60}}), iconTransformation(extent={{-110,-52},
              {-90,-32}})));

    // Auxiliary variables (for analysis)
    output Q.PressureAbsolute p(stateSelect=StateSelect.never) = dalton.p
      "Total thermoynamic pressure";

  equation
    // Phase change
    connect(physical.H2O, H2O.physical) annotation (Line(
        points={{-27,13},{-8.6,5}},
        smooth=Smooth.None,
        color={38,196,52}));

    // Reactions
    // ---------
    // HOR
    connect(H2.chemical, HOR.chemical) annotation (Line(
        points={{-5,8.8},{-10,14},{-10,50},{-16,50}},
        color={255,195,38},
        smooth=Smooth.None));
    connect(HOR.reaction, chemical) annotation (Line(
        points={{-24,50},{-40,50}},
        color={255,195,38},
        smooth=Smooth.None));
    // ORR
    connect(O2.chemical, ORR[1].chemical) annotation (Line(
        points={{-5,8.8},{-10,14},{-10,30},{-16,30}},
        color={255,195,38},
        smooth=Smooth.None));
    connect(H2O.chemical, ORR[2].chemical) annotation (Line(
        points={{-5,8.8},{-10,14},{-10,30},{-16,30}},
        color={255,195,38},
        smooth=Smooth.None));
    connect(ORR[1].reaction, chemical) annotation (Line(
        points={{-24,30},{-32,30},{-32,50},{-40,50}},
        color={255,195,38},
        smooth=Smooth.None));
    connect(ORR[2].reaction, chemical) annotation (Line(
        points={{-24,30},{-32,30},{-32,50},{-40,50}},
        color={255,195,38},
        smooth=Smooth.None));

    // H2
    // --
    // Diffusive exchange
    connect(H2.dalton, dalton) annotation (Line(
        points={{3.2,-9.5},{10,-30}},
        color={47,107,251},
        smooth=Smooth.None));
    connect(H2.inertInter, inert) annotation (Line(
        points={{9.5,-3},{30,-10}},
        color={47,107,251},
        smooth=Smooth.None));

    connect(H2.inertDirect.translational, common.translational) annotation (
        Line(
        points={{5.9,-8},{20,-20}},
        color={47,107,251},
        smooth=Smooth.None));
    connect(H2.inertDirect.thermal, common.thermal) annotation (Line(
        points={{5.9,-8},{20,-20}},
        color={47,107,251},
        smooth=Smooth.None));
    // Transport
    connect(H2.faces[facesCart[Axis.x], Side.n], xNegative.H2) annotation (Line(
        points={{6.10623e-16,6.10623e-16},{-20,0},{-20,5.55112e-16},{-40,
            5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));

    connect(H2.faces[facesCart[Axis.x], Side.p], xPositive.H2) annotation (Line(
        points={{6.10623e-16,6.10623e-16},{40,5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));

    connect(H2.faces[facesCart[Axis.y], Side.n], yNegative.H2) annotation (Line(
        points={{6.10623e-16,6.10623e-16},{6.10623e-16,-40},{5.55112e-16,-40}},

        color={127,127,127},
        smooth=Smooth.None));

    connect(H2.faces[facesCart[Axis.y], Side.p], yPositive.H2) annotation (Line(
        points={{6.10623e-16,6.10623e-16},{5.55112e-16,40}},
        color={127,127,127},
        smooth=Smooth.None));

    connect(H2.faces[facesCart[Axis.z], Side.n], zNegative.H2) annotation (Line(
        points={{6.10623e-16,6.10623e-16},{20,20}},
        color={127,127,127},
        smooth=Smooth.None));
    connect(H2.faces[facesCart[Axis.z], Side.p], zPositive.H2) annotation (Line(
        points={{6.10623e-16,6.10623e-16},{-20,-20}},
        color={127,127,127},
        smooth=Smooth.None));

    // H2O
    // ---
    // Diffusive exchange
    connect(H2O.dalton, dalton) annotation (Line(
        points={{3.2,-9.5},{10,-30}},
        color={47,107,251},
        smooth=Smooth.None));
    connect(H2O.inertInter, inert) annotation (Line(
        points={{9.5,-3},{30,-10}},
        color={47,107,251},
        smooth=Smooth.None));
    connect(H2O.inertDirect.translational, common.translational) annotation (
        Line(
        points={{5.9,-8},{20,-20}},
        color={47,107,251},
        smooth=Smooth.None));
    connect(H2O.inertDirect.thermal, common.thermal) annotation (Line(
        points={{5.9,-8},{20,-20}},
        color={47,107,251},
        smooth=Smooth.None));
    // Transport
    connect(H2O.faces[facesCart[Axis.x], Side.n], xNegative.H2O) annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{-20,0},{-20,5.55112e-16},{-40,
            5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));

    connect(H2O.faces[facesCart[Axis.x], Side.p], xPositive.H2O) annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{40,5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));

    connect(H2O.faces[facesCart[Axis.y], Side.n], yNegative.H2O) annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{6.10623e-16,-40},{5.55112e-16,-40}},

        color={127,127,127},
        smooth=Smooth.None));

    connect(H2O.faces[facesCart[Axis.y], Side.p], yPositive.H2O) annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{5.55112e-16,40}},
        color={127,127,127},
        smooth=Smooth.None));

    connect(H2O.faces[facesCart[Axis.z], Side.n], zNegative.H2O) annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{20,20}},
        color={127,127,127},
        smooth=Smooth.None));
    connect(H2O.faces[facesCart[Axis.z], Side.p], zPositive.H2O) annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{-20,-20}},
        color={127,127,127},
        smooth=Smooth.None));
    // N2
    // --
    // Diffusive exchange
    connect(N2.dalton, dalton) annotation (Line(
        points={{3.2,-9.5},{10,-30}},
        color={47,107,251},
        smooth=Smooth.None));
    connect(N2.inertInter, inert) annotation (Line(
        points={{9.5,-3},{30,-10}},
        color={47,107,251},
        smooth=Smooth.None));
    connect(N2.inertDirect.translational, common.translational) annotation (
        Line(
        points={{5.9,-8},{20,-20}},
        color={47,107,251},
        smooth=Smooth.None));
    connect(N2.inertDirect.thermal, common.thermal) annotation (Line(
        points={{5.9,-8},{20,-20}},
        color={47,107,251},
        smooth=Smooth.None));

    // Transport
    connect(N2.faces[facesCart[Axis.x], Side.n], xNegative.N2) annotation (Line(
        points={{6.10623e-16,6.10623e-16},{-20,0},{-20,5.55112e-16},{-40,
            5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));

    connect(N2.faces[facesCart[Axis.x], Side.p], xPositive.N2) annotation (Line(
        points={{6.10623e-16,6.10623e-16},{40,5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));

    connect(N2.faces[facesCart[Axis.y], Side.n], yNegative.N2) annotation (Line(
        points={{6.10623e-16,6.10623e-16},{6.10623e-16,-40},{5.55112e-16,-40}},

        color={127,127,127},
        smooth=Smooth.None));

    connect(N2.faces[facesCart[Axis.y], Side.p], yPositive.N2) annotation (Line(
        points={{6.10623e-16,6.10623e-16},{5.55112e-16,40}},
        color={127,127,127},
        smooth=Smooth.None));
    connect(N2.faces[facesCart[Axis.z], Side.n], zNegative.N2) annotation (Line(
        points={{6.10623e-16,6.10623e-16},{20,20}},
        color={127,127,127},
        smooth=Smooth.None));
    connect(N2.faces[facesCart[Axis.z], Side.p], zPositive.N2) annotation (Line(
        points={{6.10623e-16,6.10623e-16},{-20,-20}},
        color={127,127,127},
        smooth=Smooth.None));

    // O2
    // --
    // Diffusive exchange
    connect(O2.dalton, dalton) annotation (Line(
        points={{3.2,-9.5},{10,-30}},
        color={47,107,251},
        smooth=Smooth.None));
    connect(O2.inertInter, inert) annotation (Line(
        points={{9.5,-3},{30,-10}},
        color={47,107,251},
        smooth=Smooth.None));
    connect(O2.inertDirect.translational, common.translational) annotation (
        Line(
        points={{5.9,-8},{20,-20}},
        color={47,107,251},
        smooth=Smooth.None));
    connect(O2.inertDirect.thermal, common.thermal) annotation (Line(
        points={{5.9,-8},{20,-20}},
        color={47,107,251},
        smooth=Smooth.None));
    // Transport
    connect(O2.faces[facesCart[Axis.x], Side.n], xNegative.O2) annotation (Line(
        points={{6.10623e-16,6.10623e-16},{-20,0},{-20,5.55112e-16},{-40,
            5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));

    connect(O2.faces[facesCart[Axis.x], Side.p], xPositive.O2) annotation (Line(
        points={{6.10623e-16,6.10623e-16},{40,5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));

    connect(O2.faces[facesCart[Axis.y], Side.n], yNegative.O2) annotation (Line(
        points={{6.10623e-16,6.10623e-16},{5.82867e-16,0},{5.82867e-16,-40},{
            5.55112e-16,-40}},
        color={127,127,127},
        smooth=Smooth.None));
    connect(O2.faces[facesCart[Axis.y], Side.p], yPositive.O2) annotation (Line(
        points={{6.10623e-16,6.10623e-16},{5.55112e-16,40}},
        color={127,127,127},
        smooth=Smooth.None));
    connect(O2.faces[facesCart[Axis.z], Side.n], zNegative.O2) annotation (Line(
        points={{6.10623e-16,6.10623e-16},{20,20}},
        color={127,127,127},
        smooth=Smooth.None));
    connect(O2.faces[facesCart[Axis.z], Side.p], zPositive.O2) annotation (Line(
        points={{6.10623e-16,6.10623e-16},{-20,-20}},
        color={127,127,127},
        smooth=Smooth.None));
    annotation (
      Documentation(info="<html>
<p>Please see the documentation of the <a href=\"modelica://FCSys.Phases.BaseClasses.EmptyPhase\">EmptyPhase</a> model.</p></html>"),

      Diagram(graphics),
      Icon(graphics));

  end Gas;

  model Graphite "Graphite phase"
    import assert = FCSys.BaseClasses.Utilities.assertEval;
    import FCSys.BaseClasses.Utilities.countTrue;
    extends FCSys.Phases.BaseClasses.EmptyPhase(final n_spec=countTrue({
          'inclC+','incle-'}));

    // **Propagate the reaction parameters.

    // Conditionally include species.
    parameter Boolean 'inclC+'=false "<html>Carbon plus (C<sup>+</sup>)</html>"
      annotation (
      HideResult=true,
      choices(__Dymola_checkBox=true),
      Dialog(
        group="Species",
        __Dymola_descriptionLabel=true,
        __Dymola_joinNext=true));
    replaceable FCSys.Species.'C+'.Graphite.Fixed 'C+'(final n_faces) if
      'inclC+' constrainedby FCSys.Species.Species(
      n_faces=n_faces,
      initMaterial=if 'incle-' and not (inclHOR or inclORR) then InitScalar.pressure
           else InitScalar.volume,
      phi(each stateSelect=if reduceTrans then StateSelect.default else
            StateSelect.prefer),
      T(stateSelect=if reduceThermal then StateSelect.default else StateSelect.prefer))
      "<html>C<sup>+</sup> model</html>" annotation (
      __Dymola_choicesFromPackage=true,
      Dialog(
        group="Species",
        __Dymola_descriptionLabel=true,
        enable='inclC+'),
      Placement(transformation(extent={{-10,-10},{10,10}})));

    parameter Boolean 'incle-'=false "<html>Electrons (e<sup>-</sup>)</html>"
      annotation (
      HideResult=true,
      choices(__Dymola_checkBox=true),
      Dialog(
        group="Species",
        __Dymola_descriptionLabel=true,
        __Dymola_joinNext=true));

    replaceable FCSys.Species.'e-'.Graphite.Fixed 'e-'(final n_faces) if
      'incle-' and not (inclHOR or inclORR) constrainedby FCSys.Species.Species(
      n_faces=n_faces,
      phi(each stateSelect=if reduceTrans then StateSelect.default else
            StateSelect.prefer),
      T(stateSelect=if reduceThermal then StateSelect.default else StateSelect.prefer))
      "<html>'e-' model</html>" annotation (
      __Dymola_choicesFromPackage=true,
      Dialog(
        group="Species",
        __Dymola_descriptionLabel=true,
        enable='incle-'),
      Placement(transformation(extent={{-10,-10},{10,10}})));

    parameter Boolean inclHOR=false "Hydrogen oxidation" annotation (
      HideResult=true,
      Dialog(group="Included reactions", compact=true),
      choices(__Dymola_checkBox=true));
    parameter Boolean inclORR=false "Oxygen reduction" annotation (
      HideResult=true,
      Dialog(group="Included reactions", compact=true),
      choices(__Dymola_checkBox=true));
    // These can't be outer parameters in Dymola 7.4.

    FCSys.Species.Reaction reaction(
      final A=A[Axis.x],
      transSubstrate=true,
      thermalSubstrate=true,
      fromCurrent=true) if inclHOR or inclORR
      "Model to determine the electrochemical reaction rate"
      annotation (Placement(transformation(extent={{20,30},{40,50}})));

    FCSys.Conditions.Adapters.ChemicalFace HOL(
      final axis=Axis.x,
      final side=Side.n,
      final A=A[Axis.x],
      final cartTrans=cartTrans,
      redeclare package Data = FCSys.Characteristics.'e-'.Gas) if inclHOR
      "Adapter for the electrical contribution of e- to the hydrogen oxidation reaction"
      annotation (Placement(transformation(extent={{-50,50},{-30,70}})));

    FCSys.Conditions.Adapters.ChemicalFace ORL(
      final axis=Axis.x,
      final side=Side.p,
      final A=A[Axis.x],
      cartTrans=cartTrans,
      redeclare package Data = FCSys.Characteristics.'e-'.Gas) if inclORR
      "Adapter for the electrical contribution of e- to the oxygen reduction reaction"
      annotation (Placement(transformation(extent={{50,50},{30,70}})));
    Conditions.Adapters.ChemicalReaction HOR(
      n=2,
      final n_trans=n_trans,
      final m='e-'.Data.m) if inclHOR
      annotation (Placement(transformation(extent={{-30,50},{-10,70}})));
    Conditions.Adapters.ChemicalReaction ORR(
      n=-4,
      final n_trans=n_trans,
      final m='e-'.Data.m) if inclORR
      annotation (Placement(transformation(extent={{30,50},{10,70}})));

    Connectors.Reaction chemical(final n_trans=n_trans) if inclHOR or inclORR
      "Connector for a chemical reaction" annotation (Placement(transformation(
            extent={{-10,60},{10,80}}), iconTransformation(extent={{-110,-52},{
              -90,-32}})));

  equation
    // Reactions
    // ---------
    // HOR
    connect(HOL.face, xNegative.'e-') annotation (Line(
        points={{-44,60},{-50,60},{-50,5.55112e-16},{-40,5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));
    connect(HOL.chemical, HOR.chemical) annotation (Line(
        points={{-36,60},{-24,60}},
        color={255,195,38},
        smooth=Smooth.None));
    connect(HOR.reaction, chemical) annotation (Line(
        points={{-16,60},{5.55112e-16,60},{5.55112e-16,70}},
        color={255,195,38},
        smooth=Smooth.None));
    // ORR
    connect(ORL.face, xPositive.'e-') annotation (Line(
        points={{44,60},{50,60},{50,5.55112e-16},{40,5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));
    connect(ORL.chemical, ORR.chemical) annotation (Line(
        points={{36,60},{24,60}},
        color={255,195,38},
        smooth=Smooth.None));
    connect(ORR.reaction, chemical) annotation (Line(
        points={{16,60},{5.55112e-16,60},{5.55112e-16,70}},
        color={255,195,38},
        smooth=Smooth.None));
    connect(reaction.reaction, chemical) annotation (Line(
        points={{30,40},{10,40},{10,60},{5.55112e-16,60},{5.55112e-16,70}},
        color={255,195,38},
        smooth=Smooth.None));
    connect(reaction.inert, 'C+'.inertDirect) annotation (Line(
        points={{30,36},{30,-8},{5.9,-8}},
        color={47,107,251},
        smooth=Smooth.None));

    // C+
    // --
    // Exchange
    connect('C+'.dalton, dalton) annotation (Line(
        points={{3.2,-9.5},{10,-30}},
        color={47,107,251},
        smooth=Smooth.None));
    connect('C+'.inertInter, inert) annotation (Line(
        points={{9.5,-3},{30,-10}},
        color={47,107,251},
        smooth=Smooth.None));

    connect('C+'.inertDirect.translational, common.translational) annotation (
        Line(
        points={{5.9,-8},{20,-20}},
        color={47,107,251},
        smooth=Smooth.None));
    connect('C+'.inertDirect.thermal, common.thermal) annotation (Line(
        points={{5.9,-8},{20,-20}},
        color={47,107,251},
        smooth=Smooth.None));

    // Transport
    connect('C+'.faces[facesCart[Axis.x], Side.n], xNegative.'C+') annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{-20,0},{-20,5.55112e-16},{-40,
            5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));

    connect('C+'.faces[facesCart[Axis.x], Side.p], xPositive.'C+') annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{20,0},{20,5.55112e-16},{40,
            5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));

    connect('C+'.faces[facesCart[Axis.y], Side.n], yNegative.'C+') annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{6.10623e-16,-40},{5.55112e-16,-40}},

        color={127,127,127},
        smooth=Smooth.None));

    connect('C+'.faces[facesCart[Axis.y], Side.p], yPositive.'C+') annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{5.55112e-16,40}},
        color={127,127,127},
        smooth=Smooth.None));

    connect('C+'.faces[facesCart[Axis.z], Side.n], zNegative.'C+') annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{20,20}},
        color={127,127,127},
        smooth=Smooth.None));
    connect('C+'.faces[facesCart[Axis.z], Side.p], zPositive.'C+') annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{-20,-20}},
        color={127,127,127},
        smooth=Smooth.None));

    // e-
    // --
    // Exchange
    connect('e-'.dalton, dalton) annotation (Line(
        points={{3.2,-9.5},{10,-30}},
        color={47,107,251},
        smooth=Smooth.None));
    connect('e-'.inertInter, inert) annotation (Line(
        points={{9.5,-3},{30,-10}},
        color={47,107,251},
        smooth=Smooth.None));
    connect('e-'.inertDirect.translational, common.translational) annotation (
        Line(
        points={{5.9,-8},{20,-20}},
        color={47,107,251},
        smooth=Smooth.None));
    connect('e-'.inertDirect.thermal, common.thermal) annotation (Line(
        points={{5.9,-8},{20,-20}},
        color={47,107,251},
        smooth=Smooth.None));
    // Transport
    connect('e-'.faces[facesCart[Axis.x], Side.n], xNegative.'e-') annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{-20,0},{-20,5.55112e-16},{-40,
            5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));

    connect('e-'.faces[facesCart[Axis.x], Side.p], xPositive.'e-') annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{20,0},{20,5.55112e-16},{40,
            5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));

    connect('e-'.faces[facesCart[Axis.y], Side.n], yNegative.'e-') annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{6.10623e-16,-40},{5.55112e-16,-40}},

        color={127,127,127},
        smooth=Smooth.None));

    connect('e-'.faces[facesCart[Axis.y], Side.p], yPositive.'e-') annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{5.55112e-16,40}},
        color={127,127,127},
        smooth=Smooth.None));

    connect('e-'.faces[facesCart[Axis.z], Side.n], zNegative.'e-') annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{20,20}},
        color={127,127,127},
        smooth=Smooth.None));
    connect('e-'.faces[facesCart[Axis.z], Side.p], zPositive.'e-') annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{-20,-20}},
        color={127,127,127},
        smooth=Smooth.None));
    annotation (
      Documentation(info="<html>
    <p>See <a href=\"modelica://FCSys.Species.'e-'.Graphite.Fixed\">Species.'e-'.Graphite.Fixed</a> for assumptions.
    For more information, see the
 <a href=\"modelica://FCSys.Phases.BaseClasses.EmptyPhase\">EmptyPhase</a> model.</p></html>"),

      Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
              100,100}}), graphics),
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
              100}}), graphics));
  end Graphite;

  model Ionomer "Ionomer phase"
    import FCSys.BaseClasses.Utilities.countTrue;
    extends FCSys.Phases.BaseClasses.EmptyPhase(final n_spec=countTrue({
          'inclC19HF37O5S-','inclH+',inclH2O}));

    parameter Q.NumberAbsolute k_EOD=5 "Independity factor between H+ and H2O";

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
    replaceable FCSys.Species.'C19HF37O5S-'.Ionomer.Fixed 'C19HF37O5S-'(final
        n_faces) if 'inclC19HF37O5S-' constrainedby FCSys.Species.Species(
      n_faces=n_faces,
      initMaterial=if 'inclH+' and not (inclHOR or inclORR) then InitScalar.pressure
           else InitScalar.volume,
      phi(each stateSelect=if reduceTrans then StateSelect.default else
            StateSelect.prefer),
      T(stateSelect=if reduceThermal then StateSelect.default else StateSelect.prefer))
      "<html>C<sub>19</sub>HF<sub>37</sub>O<sub>5</sub>S<sup>-</sup> model</html>"
      annotation (
      __Dymola_choicesFromPackage=true,
      Dialog(
        group="Species",
        __Dymola_descriptionLabel=true,
        enable='inclC19HF37O5S-'),
      Placement(transformation(extent={{-10,-10},{10,10}})));

    parameter Boolean 'inclH+'=false "<html>Protons (H<sup>+</sup>)</html>"
      annotation (
      HideResult=true,
      choices(__Dymola_checkBox=true),
      Dialog(
        group="Species",
        __Dymola_descriptionLabel=true,
        __Dymola_joinNext=true));

    replaceable FCSys.Species.'H+'.Ionomer.Fixed 'H+'(final n_faces) if
      'inclH+' and not (inclHOR or inclORR) constrainedby FCSys.Species.Species(
      n_faces=n_faces,
      n_intra=1,
      k_intra={k_EOD},
      phi(each stateSelect=if reduceTrans then StateSelect.default else
            StateSelect.prefer),
      T(stateSelect=if reduceThermal then StateSelect.default else StateSelect.prefer))
      "<html>H<sup>+</sup> model</html>" annotation (
      __Dymola_choicesFromPackage=true,
      Dialog(
        group="Species",
        __Dymola_descriptionLabel=true,
        enable='inclH+'),
      Placement(transformation(extent={{-10,-10},{10,10}})));

    parameter Boolean inclH2O=false "<html>Water (H<sub>2</sub>O)</html>"
      annotation (
      HideResult=true,
      choices(__Dymola_checkBox=true),
      Dialog(
        group="Species",
        __Dymola_descriptionLabel=true,
        __Dymola_joinNext=true));

    replaceable FCSys.Species.H2O.Ionomer.Fixed H2O(final n_faces) if inclH2O
      constrainedby FCSys.Species.Species(
      n_faces=n_faces,
      n_intra=1,
      k_intra={k_EOD},
      phi(each stateSelect=if reduceTrans then StateSelect.default else
            StateSelect.prefer),
      T(stateSelect=if reduceThermal then StateSelect.default else StateSelect.prefer))
      "<html>H<sub>2</sub>O model</html>" annotation (
      __Dymola_choicesFromPackage=true,
      Dialog(
        group="Species",
        __Dymola_descriptionLabel=true,
        enable=inclH2O),
      Placement(transformation(extent={{-10,-10},{10,10}})));

    parameter Boolean inclHOR=false "Hydrogen oxidation" annotation (
      HideResult=true,
      Dialog(group="Included reactions", compact=true),
      choices(__Dymola_checkBox=true));
    parameter Boolean inclORR=false "Oxygen reduction" annotation (
      HideResult=true,
      Dialog(group="Included reactions", compact=true),
      choices(__Dymola_checkBox=true));
    // These can't be outer parameters in Dymola 7.4.

    FCSys.Conditions.Adapters.ChemicalFace HOL(
      final axis=Axis.x,
      final side=Side.p,
      final A=A[Axis.x],
      redeclare package Data = FCSys.Characteristics.'H+'.Gas,
      cartTrans=cartTrans) if inclHOR
      "Charge layer or adapter for the electrical contribution of H+ to the hydrogen oxidation reaction"
      annotation (Placement(transformation(extent={{50,50},{30,70}})));

    FCSys.Conditions.Adapters.ChemicalFace ORL(
      final axis=Axis.x,
      final side=Side.n,
      final A=A[Axis.x],
      redeclare package Data = FCSys.Characteristics.'H+'.Gas,
      cartTrans=cartTrans) if inclORR
      "Charge layer or adapter for the electrical contribution of H+ to the oxygen reduction reaction"
      annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
    Conditions.Adapters.ChemicalReaction HOR(
      n=2,
      final n_trans=n_trans,
      final m='H+'.Data.m) if inclHOR
      annotation (Placement(transformation(extent={{30,50},{10,70}})));
    Conditions.Adapters.ChemicalReaction ORR(
      n=-4,
      final n_trans=n_trans,
      final m='H+'.Data.m) if inclORR
      annotation (Placement(transformation(extent={{-30,50},{-10,70}})));

    Connectors.PhysicalBus physical if inclH2O "Connector for phase change"
      annotation (Placement(transformation(extent={{-37,3},{-17,23}}),
          iconTransformation(extent={{-61,41},{-41,61}})));
    Connectors.Reaction chemical(final n_trans=n_trans) if inclHOR or inclORR
      "Connector for a chemical reaction" annotation (Placement(transformation(
            extent={{-10,60},{10,80}}), iconTransformation(extent={{-110,-52},{
              -90,-32}})));

  equation
    // Phase change
    connect(physical.H2O, H2O.physical) annotation (Line(
        points={{-27,13},{-8.6,5}},
        color={38,196,52},
        smooth=Smooth.None));

    // Electro-osmotic drag (EOD)
    connect('H+'.inertIntra[1], H2O.inertIntra[1]) annotation (Line(
        points={{7.9,-5.8},{10.15,-5.8},{10.15,-2.2},{10.8,-2.2},{10.8,-5.8},{
            7.9,-5.8}},
        color={47,107,251},
        smooth=Smooth.None));

    // Reactions
    // ---------
    // HOR
    connect(HOL.face, xPositive.'H+') annotation (Line(
        points={{44,60},{50,60},{50,5.55112e-16},{40,5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));
    connect(HOL.chemical, HOR.chemical) annotation (Line(
        points={{36,60},{24,60}},
        color={255,195,38},
        smooth=Smooth.None));
    connect(HOR.reaction, chemical) annotation (Line(
        points={{16,60},{5.55112e-16,60},{5.55112e-16,70}},
        color={255,195,38},
        smooth=Smooth.None));
    // ORR
    connect(ORL.face, xNegative.'H+') annotation (Line(
        points={{-44,60},{-50,60},{-50,5.55112e-16},{-40,5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));

    connect(ORL.chemical, ORR.chemical) annotation (Line(
        points={{-36,60},{-24,60}},
        color={255,195,38},
        smooth=Smooth.None));
    connect(ORR.reaction, chemical) annotation (Line(
        points={{-16,60},{5.55112e-16,60},{5.55112e-16,70}},
        color={255,195,38},
        smooth=Smooth.None));

    // C19HF37O5S-
    // -----------
    // Exchange
    connect('C19HF37O5S-'.dalton, dalton) annotation (Line(
        points={{3.2,-9.5},{10,-30}},
        color={47,107,251},
        smooth=Smooth.None));
    connect('C19HF37O5S-'.inertInter, inert) annotation (Line(
        points={{9.5,-3},{30,-10}},
        color={47,107,251},
        smooth=Smooth.None));

    connect('C19HF37O5S-'.inertDirect.translational, common.translational)
      annotation (Line(
        points={{5.9,-8},{20,-20}},
        color={47,107,251},
        smooth=Smooth.None));
    connect('C19HF37O5S-'.inertDirect.thermal, common.thermal) annotation (Line(
        points={{5.9,-8},{20,-20}},
        color={47,107,251},
        smooth=Smooth.None));
    // Transport
    connect('C19HF37O5S-'.faces[facesCart[Axis.x], Side.n], xNegative.
      'C19HF37O5S-') annotation (Line(
        points={{6.10623e-16,6.10623e-16},{-40,5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));

    connect('C19HF37O5S-'.faces[facesCart[Axis.x], Side.p], xPositive.
      'C19HF37O5S-') annotation (Line(
        points={{6.10623e-16,6.10623e-16},{6.10623e-16,5.55112e-16},{40,
            5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));

    connect('C19HF37O5S-'.faces[facesCart[Axis.y], Side.n], yNegative.
      'C19HF37O5S-') annotation (Line(
        points={{6.10623e-16,6.10623e-16},{6.10623e-16,-40},{5.55112e-16,-40}},

        color={127,127,127},
        smooth=Smooth.None));

    connect('C19HF37O5S-'.faces[facesCart[Axis.y], Side.p], yPositive.
      'C19HF37O5S-') annotation (Line(
        points={{6.10623e-16,6.10623e-16},{5.55112e-16,40}},
        color={127,127,127},
        smooth=Smooth.None));

    connect('C19HF37O5S-'.faces[facesCart[Axis.z], Side.n], zNegative.
      'C19HF37O5S-') annotation (Line(
        points={{6.10623e-16,6.10623e-16},{20,20}},
        color={127,127,127},
        smooth=Smooth.None));
    connect('C19HF37O5S-'.faces[facesCart[Axis.z], Side.p], zPositive.
      'C19HF37O5S-') annotation (Line(
        points={{6.10623e-16,6.10623e-16},{-20,-20}},
        color={127,127,127},
        smooth=Smooth.None));

    // 'H+'
    // ----
    // Exchange
    connect('H+'.dalton, dalton) annotation (Line(
        points={{3.2,-9.5},{10,-30}},
        color={47,107,251},
        smooth=Smooth.None));
    connect('H+'.inertInter, inert) annotation (Line(
        points={{9.5,-3},{30,-10}},
        color={47,107,251},
        smooth=Smooth.None));

    connect('H+'.inertDirect.translational, common.translational) annotation (
        Line(
        points={{5.9,-8},{20,-20}},
        color={47,107,251},
        smooth=Smooth.None));
    connect('H+'.inertDirect.thermal, common.thermal) annotation (Line(
        points={{5.9,-8},{20,-20}},
        color={47,107,251},
        smooth=Smooth.None));
    // Transport
    connect('H+'.faces[facesCart[Axis.x], Side.n], xNegative.'H+') annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{-40,5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));

    connect('H+'.faces[facesCart[Axis.x], Side.p], xPositive.'H+') annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{6.10623e-16,5.55112e-16},{40,
            5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));

    connect('H+'.faces[facesCart[Axis.y], Side.n], yNegative.'H+') annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{6.10623e-16,-40},{5.55112e-16,-40}},

        color={127,127,127},
        smooth=Smooth.None));

    connect('H+'.faces[facesCart[Axis.y], Side.p], yPositive.'H+') annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{5.55112e-16,40}},
        color={127,127,127},
        smooth=Smooth.None));

    connect('H+'.faces[facesCart[Axis.z], Side.n], zNegative.'H+') annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{20,20}},
        color={127,127,127},
        smooth=Smooth.None));
    connect('H+'.faces[facesCart[Axis.z], Side.p], zPositive.'H+') annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{-20,-20}},
        color={127,127,127},
        smooth=Smooth.None));

    // H2O
    // ---
    // Exchange
    connect(H2O.dalton, dalton) annotation (Line(
        points={{3.2,-9.5},{10,-30}},
        color={47,107,251},
        smooth=Smooth.None));
    connect(H2O.inertInter, inert) annotation (Line(
        points={{9.5,-3},{30,-10}},
        color={47,107,251},
        smooth=Smooth.None));

    connect(H2O.inertDirect.translational, common.translational) annotation (
        Line(
        points={{5.9,-8},{20,-20}},
        color={47,107,251},
        smooth=Smooth.None));
    connect(H2O.inertDirect.thermal, common.thermal) annotation (Line(
        points={{5.9,-8},{20,-20}},
        color={47,107,251},
        smooth=Smooth.None));
    // Transport
    connect(H2O.faces[facesCart[Axis.x], Side.n], xNegative.H2O) annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{-40,5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));

    connect(H2O.faces[facesCart[Axis.x], Side.p], xPositive.H2O) annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{40,5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));

    connect(H2O.faces[facesCart[Axis.y], Side.n], yNegative.H2O) annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{6.10623e-16,-40},{5.55112e-16,-40}},

        color={127,127,127},
        smooth=Smooth.None));

    connect(H2O.faces[facesCart[Axis.y], Side.p], yPositive.H2O) annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{5.55112e-16,40}},
        color={127,127,127},
        smooth=Smooth.None));

    connect(H2O.faces[facesCart[Axis.z], Side.n], zNegative.H2O) annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{20,20}},
        color={127,127,127},
        smooth=Smooth.None));
    connect(H2O.faces[facesCart[Axis.z], Side.p], zPositive.H2O) annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{-20,-20}},
        color={127,127,127},
        smooth=Smooth.None));
    annotation (
      Documentation(info="<html><p>Assumptions:<ol>
    <li>The water in the ionomer does not participate in the reaction (only the water vapor does).</li>
    </ol</p>
    
    <p>See <a href=\"modelica://FCSys.Species.'H+'.Ionomer.Fixed\">Species.'H+'.Ionomer.Fixed</a> 
    for additional assumptions.
    For more information, see the
 <a href=\"modelica://FCSys.Phases.BaseClasses.EmptyPhase\">EmptyPhase</a> model.</p></html>"),

      Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
              100,100}}), graphics),
      Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
              100}}), graphics));
  end Ionomer;

  model Liquid "Liquid phase"
    extends FCSys.Phases.BaseClasses.EmptyPhase(final n_spec=if inclH2O then 1
           else 0);

    // Conditionally include species.
    parameter Boolean inclH2O=false "<html>Water (H<sub>2</sub>O)</html>"
      annotation (
      HideResult=true,
      choices(__Dymola_checkBox=true),
      Dialog(
        group="Species",
        __Dymola_descriptionLabel=true,
        __Dymola_joinNext=true));
    replaceable FCSys.Species.H2O.Liquid.Fixed H2O(final n_faces) if inclH2O
      constrainedby FCSys.Species.Species(
      n_faces=n_faces,
      phi(each stateSelect=if reduceTrans then StateSelect.default else
            StateSelect.prefer),
      T(stateSelect=if reduceThermal then StateSelect.default else StateSelect.prefer))
      "<html>H<sub>2</sub>O model</html>" annotation (
      __Dymola_choicesFromPackage=true,
      Dialog(
        group="Species",
        __Dymola_descriptionLabel=true,
        enable=inclH2O),
      Placement(transformation(extent={{-10,-10},{10,10}})));

    Connectors.PhysicalBus physical if inclH2O "Connector for phase change"
      annotation (Placement(transformation(extent={{-37,3},{-17,23}}),
          iconTransformation(extent={{-61,41},{-41,61}})));

  equation
    // Phase change
    connect(physical.H2O, H2O.physical) annotation (Line(
        points={{-27,13},{-8.6,5}},
        color={38,196,52},
        smooth=Smooth.None));

    // H2O
    // ---
    // Exchange
    connect(H2O.inertInter, inert) annotation (Line(
        points={{9.5,-3},{30,-10}},
        color={47,107,251},
        smooth=Smooth.None));
    connect(H2O.dalton, dalton) annotation (Line(
        points={{3.2,-9.5},{10,-30}},
        color={47,107,251},
        smooth=Smooth.None));
    connect(H2O.inertDirect.translational, common.translational) annotation (
        Line(
        points={{5.9,-8},{20,-20}},
        color={47,107,251},
        smooth=Smooth.None));
    connect(H2O.inertDirect.thermal, common.thermal) annotation (Line(
        points={{5.9,-8},{20,-20}},
        color={47,107,251},
        smooth=Smooth.None));
    // Transport
    connect(H2O.faces[Axis.x, Side.n], xNegative.H2O) annotation (Line(
        points={{6.10623e-16,6.10623e-16},{6.10623e-16,5.55112e-16},{-40,
            5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));

    connect(H2O.faces[Axis.x, Side.p], xPositive.H2O) annotation (Line(
        points={{6.10623e-16,6.10623e-16},{40,5.55112e-16}},
        color={127,127,127},
        smooth=Smooth.None));

    connect(H2O.faces[facesCart[Axis.y], Side.n], yNegative.H2O) annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{5.55112e-16,-40}},
        color={127,127,127},
        smooth=Smooth.None));

    connect(H2O.faces[facesCart[Axis.y], Side.p], yPositive.H2O) annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{-4.87687e-22,20},{5.55112e-16,20},{
            5.55112e-16,40}},
        color={127,127,127},
        smooth=Smooth.None));

    connect(H2O.faces[facesCart[Axis.z], Side.n], zNegative.H2O) annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{20,20}},
        color={127,127,127},
        smooth=Smooth.None));
    connect(H2O.faces[facesCart[Axis.z], Side.p], zPositive.H2O) annotation (
        Line(
        points={{6.10623e-16,6.10623e-16},{-20,-20}},
        color={127,127,127},
        smooth=Smooth.None));
    annotation (
      Documentation(info="<html>
    <p>Please see the documentation of the
 <a href=\"modelica://FCSys.Phases.BaseClasses.EmptyPhase\">EmptyPhase</a> model.</p></html>"),

      Icon(graphics),
      Diagram(graphics));
  end Liquid;

  package BaseClasses "Base classes (generally not for direct use)"
    extends Modelica.Icons.BasesPackage;
    model EmptyPhase "Model for a phase with no species or reactions"
      import FCSys.BaseClasses.Utilities.index;
      // extends FCSys.BaseClasses.Icons.Names.Middle;

      parameter Integer n_spec(start=0) "Number of species"
        annotation (HideResult=true);
      inner parameter Integer n_inter=0 "**"
        annotation (Dialog(connectorSizing=true));
      inner parameter Q.NumberAbsolute k_inter[n_inter]=ones(n_inter)
        "Coupling factor for exchange with other phases";

      // Geometry
      parameter Integer n_faces(min=1, max=3) "Number of pairs of faces"
        annotation (Dialog(group="Geometry",__Dymola_label=
              "<html><i>n</i><sub>faces</sub></html>"), HideResult=true);
      // This can't be an outer parameter in Dymola 7.4.
      parameter Q.NumberAbsolute k_DT[Axis](
        each min=Modelica.Constants.small,
        each final nominal=1) = {1,1,1} if n_spec > 0
        "Scaling factor for diffusive transport" annotation (Dialog(group=
              "Geometry", __Dymola_label=
              "<html><b><i>k</i><sub>DT</sub></b></html>"));

      // Assumptions
      parameter Boolean reduceTrans=false if n_spec > 0
        "Same velocity for all species" annotation (Dialog(tab="Assumptions",
            enable=n_spec > 1), choices(__Dymola_checkBox=true));
      parameter Boolean reduceThermal=false if n_spec > 0
        "Same temperature for all species" annotation (Dialog(tab="Assumptions",
            enable=n_spec > 1), choices(__Dymola_checkBox=true));

      Connectors.Dalton dalton if n_spec > 0
        "Connector for additivity of pressure" annotation (Placement(
            transformation(extent={{0,-40},{20,-20}}), iconTransformation(
              extent={{70,-90},{90,-70}})));
      Connectors.InertInter inert[n_inter](each final n_trans=n_trans) if
        n_spec > 0
        "**Connector to directly couple velocity and temperature with other phases"
        annotation (Placement(transformation(extent={{20,-20},{40,0}}),
            iconTransformation(extent={{88,-32},{108,-52}})));
      Connectors.FaceBus xPositive if inclFaces[Axis.x] and n_spec > 0
        "Positive face along the x axis" annotation (Placement(transformation(
              extent={{30,-10},{50,10}}), iconTransformation(extent={{70,-10},{
                90,10}})));
      Connectors.FaceBus xNegative if inclFaces[Axis.x] and n_spec > 0
        "Negative face along the x axis" annotation (Placement(transformation(
              extent={{-50,-10},{-30,10}}), iconTransformation(extent={{-90,-10},
                {-70,10}})));
      Connectors.FaceBus yPositive if inclFaces[Axis.y] and n_spec > 0
        "Positive face along the y axis" annotation (Placement(transformation(
              extent={{-10,30},{10,50}}), iconTransformation(extent={{-10,90},{
                10,110}})));
      Connectors.FaceBus yNegative if inclFaces[Axis.y] and n_spec > 0
        "Negative face along the y axis" annotation (Placement(transformation(
              extent={{-10,-50},{10,-30}}), iconTransformation(extent={{-10,-94},
                {10,-74}})));
      Connectors.FaceBus zPositive if inclFaces[Axis.z] and n_spec > 0
        "Positive face along the z axis" annotation (Placement(transformation(
              extent={{-30,-30},{-10,-10}}), iconTransformation(extent={{-90,-90},
                {-70,-70}})));
      Connectors.FaceBus zNegative if inclFaces[Axis.z] and n_spec > 0
        "Negative face along the z axis" annotation (Placement(transformation(
              extent={{10,10},{30,30}}), iconTransformation(extent={{42,41},{62,
                61}})));

      outer parameter Q.Length L[Axis] if n_spec > 0 "Length" annotation (
          HideResult=true,missingInnerMessage="This model should be used within a subregion model.
");
      outer parameter Q.Area A[Axis] if n_spec > 0 "Cross-sectional area"
        annotation (HideResult=true,missingInnerMessage="This model should be used within a subregion model.
");
      // Note:  These must be public in Dymola 7.4, so HideResult is used.

      // Aliases
      Q.Velocity phi[n_trans](each stateSelect=StateSelect.prefer) = common.translational.phi
        if n_spec > 1 and reduceTrans "Velocity";
      Q.Temperature T(each stateSelect=StateSelect.prefer) = common.thermal.T
        if n_spec > 1 and reduceThermal "Temperature";
      // These make the selected states more readable.

    protected
      final inner parameter Q.Length Lprime[Axis]=k_DT .* A ./ L if n_spec > 0
        "Effective cross-sectional area per length";
      outer parameter Integer n_trans
        "Number of components of translational momentum" annotation (
          missingInnerMessage="This model should be used within a subregion model.
");
      outer parameter Integer cartTrans[:]
        "Cartesian-axis indices of the components of translational momentum"
        annotation (missingInnerMessage="This model should be used within a subregion model.
");
      outer parameter Integer facesCart[:]
        "Face-pair indices of the Cartesian axes" annotation (
          missingInnerMessage="This model should be used within a subregion model.
");
      outer parameter Boolean inclTrans[Axis]
        "true, if each component of translational momentum is included"
        annotation (missingInnerMessage="This model should be used within a subregion model.
");
      outer parameter Boolean inclFaces[Axis]
        "true, if each pairs of faces is included" annotation (
          missingInnerMessage="This model should be used within a subregion model.
");

      outer Conditions.Environment environment "Environmental conditions";
      // This component is conditional to prevent a mathematical singularity
      // when two or more empty phases (without any species included) are
      // connected.
      Connectors.InertDirectInternal common(
        final n_trans=n_trans,
        final inclTrans=reduceTrans,
        final inclThermal=reduceThermal) if n_spec > 0 and (reduceTrans or
        reduceThermal)
        "Connector to directly couple velocities and temperatures within the phase"
        annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin
              ={20,-20}), iconTransformation(extent={{-10,-10},{10,10}}, origin
              ={26,-52})));

      annotation (
        defaultComponentPrefixes="replaceable",
        defaultComponentName="phase",
        Documentation(info="<html><p>The area fill factor (<b><i>k</i></b>) is a vector which inversely scales all
    the transport coefficients (&beta;, &zeta;, &eta;, and &theta;) of all of the species
    within the phase.  It can be used to introduce minor head loss or the effects of
    porosity or tortousity.  These effects may be anisotropic.</p>

    <p>Porosity is often quoted in material data sheets (e.g.,
    [<a href=\"modelica://FCSys.UsersGuide.References\">Toray2010</a>]) as volumetric porosity.  Using the
    Bruggeman correction factor [<a href=\"modelica://FCSys.UsersGuide.References\">Weber2004</a>, p. 4696],
    the area fill factor for the solid should be set to (1 - &epsilon;)<sup>3/2</sup>
    along each axis, where &epsilon; is the volumetric porosity (or volumetric fill factor
    of the gas).<sup><a href=\"#fn1\" id=\"ref1\">1</a></sup></p>

    <hr>

    <small>
    <p id=\"fn1\">1. Note that the Bruggeman correction contradicts what one would
    expect based on geometry&mdash;that the area fill factor would be the volumetric fill factor (1 - &epsilon;)
    raised to the two-thirds power (not three halfs).<a href=\"#ref1\" title=\"Jump back to footnote 1 in the text.\">&#8629;</a></p>

</html>"),
        Icon(graphics={
            Ellipse(
              extent={{-40,100},{40,20}},
              lineColor={127,127,127},
              startAngle=30,
              endAngle=149,
              pattern=LinePattern.Dash,
              fillPattern=FillPattern.Solid,
              fillColor={225,225,225}),
            Ellipse(
              extent={{20,-4},{100,-84}},
              lineColor={127,127,127},
              startAngle=270,
              endAngle=390,
              pattern=LinePattern.Dash,
              fillPattern=FillPattern.Solid,
              fillColor={225,225,225}),
            Ellipse(
              extent={{-100,-4},{-20,-84}},
              lineColor={127,127,127},
              startAngle=149,
              endAngle=270,
              pattern=LinePattern.Dash,
              fillPattern=FillPattern.Solid,
              fillColor={225,225,225}),
            Polygon(
              points={{60,-84},{-60,-84},{-94.5,-24},{-34.5,80},{34.5,80},{94.5,
                  -24},{60,-84}},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Sphere,
              smooth=Smooth.None,
              fillColor={225,225,225},
              lineColor={0,0,0}),
            Line(
              points={{-60,-84},{60,-84}},
              color={127,127,127},
              pattern=LinePattern.Dash,
              smooth=Smooth.None),
            Line(
              points={{34.5,80},{94.5,-24}},
              color={127,127,127},
              pattern=LinePattern.Dash,
              smooth=Smooth.None),
            Line(
              points={{-34.5,80},{-94.5,-24}},
              color={127,127,127},
              pattern=LinePattern.Dash,
              smooth=Smooth.None),
            Text(
              extent={{-100,-20},{100,20}},
              textString="%name",
              lineColor={0,0,0})}),
        Diagram(graphics));
    end EmptyPhase;

  end BaseClasses;

  annotation (Documentation(info="<html><p>The graphite, ionomer, and
liquid phases can only be used with a compressible phase (gas).</p></html>"));
end Phases;
