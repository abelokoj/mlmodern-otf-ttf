// MLModern text with matching math (Regular and Bold).
// Compile:  typst compile --font-path otf example.typ
//      or:  typst compile --font-path ttf example.typ

#set page(width: 15cm, height: auto, margin: 1cm)
#set text(font: "MLModern", size: 12pt)
#show math.equation: set text(font: "MLModern Math")

= MLModern
Regular, #emph[italic], #strong[bold], #strong[#emph[bold italic]].

$ integral_0^infinity e^(-x^2) dif x = sqrt(pi)/2 quad sum_(i=1)^n alpha_i quad mat(1,2;3,4) $
$ bold(F) = m bold(a), quad cal(L), quad bb(R), quad omega^2 = sigma/(rho R^3) x (1-x^2) $

Kerning and ligatures: AVATAR Toy Wa Yo, office affluent difficult.

Math inside strong text uses the Bold face: #strong[the mode $omega^2 = sigma/(rho R^3)$ grows].

// Setting weight on a whole equation must be done with a show rule:
#[
  #show math.equation: set text(weight: 700)
  $ omega^2 = sigma/(rho R^3) $
]
