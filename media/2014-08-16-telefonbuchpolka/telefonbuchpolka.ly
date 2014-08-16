\version "2.16.2"
\language "deutsch"

\header {
  title = "Telefonbuchpolka"
  composer = "Georg Kreisler (1922-2011)"
  copyright = \markup {
    \line { "© 2014" \with-url #"http://gedenkt.at" "Michael Färber."
            "Dieses Werk steht unter der Lizenz"
            \with-url #"http://creativecommons.org/licenses/by/4.0/"
            "Creative Commons Attribution 4.0 International." }
  }
  tagline = \markup { \with-url #"http://lilypond.org/web/"
    \line { "Notensatz von LilyPond" $(lilypond-version) \char ##x2014 "http://lilypond.org" }
  }

}

rechtsMelodieStrophe = \relative c' {
  e8 e d e f h,4 h8
  a' a g fis g4 r8 g
  c c h b b4 a8 a h h a as g <c e g>16 <c e g> <c e g>8 g

  % der Wein wird schön älter
  g16 r8 g16 f8 g as d, r d
  c' c b a b g r g
  g8. g16 fis8 g h d,4 d8
  e e fis fis g \times 2/3 {d''16[ e fis]} g8 g,,
}

rechtsBegleitungStrophe = \relative c' {
  <c g> <c g> r <c g> <h f>4 r
  <h f'>8 <h f'> <h f'> <h f'> <c e> <c e> r r
  <c g'> <c g'> r <c g'> <c g'>4 r8 r
  <h f'> <h f'> r <h f'> <c g'>4 r8 r

  % der Wein wird schön älter
  g'16 b, es g r2 r4
  <d as'>8 <d as'> r <d as'> <es g> es r r
  cis8. cis16 cis8 cis <d g> r r h
  c4 c h8 r r4
}

rechtsMelodieRefrainA = \relative c'' {
  g8 e a e f h, h4
  a'8 f h fis g c, c4
  c'8. c16 h8 b b a a4
}

rechtsBegleitungRefrainA = \relative c' {
  r8 <c g> r <c g> r f, r f
  r h r h e4 r
  <c g'>2 r8 c r c
}

rechtsMelodieRefrainB = \relative c'' { h8. h16 a8 as as g g4 }
rechtsBegleitungRefrainB = \relative c' { r8 f r h, h <c e> g'16 e c e }

rechtsMelodieRefrainC = \relative c'' { h8 a8 f d c c c4 }
rechtsBegleitungRefrainC = \relative c' { f4 h,4 r2 }

rechtsMelodieRefrainD = \relative c' {
  d8 d e fis g d h'4
  a8 d, c'4 h16 a g fis a g fis e
  d8 d e fis g d h'4
  a8 e fis d g4 r
}
rechtsBegleitungRefrainD = \relative c' {
  c4 c h r
  r r d r
  c c h r
  e c h g''
}

rechtsWH = \relative c' {
  \repeat unfold 2
    \partcombine \rechtsMelodieStrophe \rechtsBegleitungStrophe

  <d h'>8 <d b'> <d a'> <d g> <d h'>8 <d b'> <d a'> <d g>
  <d h'>8 <d b'> <d a'> <d as'> g4 <h es g>8 r

  \partcombine \rechtsMelodieRefrainA \rechtsBegleitungRefrainA
  \partcombine \rechtsMelodieRefrainB \rechtsBegleitungRefrainB
  \partcombine \rechtsMelodieRefrainA \rechtsBegleitungRefrainA
  \partcombine \rechtsMelodieRefrainC \rechtsBegleitungRefrainC
  \partcombine \rechtsMelodieRefrainD \rechtsBegleitungRefrainD
  \partcombine \rechtsMelodieRefrainA \rechtsBegleitungRefrainA
  \partcombine \rechtsMelodieRefrainC \rechtsBegleitungRefrainC
}

rechtsEndeA = \relative c'' {
  c8 \times 2/3 {g16 fis g} as8 g r <h f> <c e,>4
  es'8 \times 2/3 {b16 a b} ces8 b r <gis e h> <a e cis>4
  \time 3/4
  r8 <e cis a> <f d a>4 r8 <h,, f>
  \time 4/4
  r <e c g> r <e c g> r <e c g> r g
}

rechtsEndeB = \relative c''' {
  c8  \times 2/3 {g16 fis g} as8 g r <h f> <c e,>4
  c,8 \times 2/3 {g16 fis g} as8 g r <h f> <c e,>4
  c'8 \times 2/3 {g16 fis g} as8 g r <h f> <c e,>4
  <c, e g> <g c e> <e g c> r
}

rechts = \relative c''' {
  \time 3/4
  c8-^ \times 2/3 {g16 fis g} as8->( g) r <h f d>
  \time 4/4
  <c g e> <e,, c g> r <e c g> r <e c g> r <<g \\ g,>>

  \repeat volta 3 \rechtsWH
  \alternative {
    \rechtsEndeA
    \rechtsEndeB
  } 
}

linksStrophe = \relative c {
  c4 g d' g,
  d' g, c g
  e8 e' c e f, c' f, e
  d4 g c, c'
  
  % der Wein wird schön älter
  es8 b' b, b' f b b, b'
  f b b, b' es, b' b, b'
  es, b g es d g h d
  a c d d, g \times 2/3 {d16[ e fis]} g8 r
}

linksRefrainA = \relative c {
  c4 g d' g,
  d' g, c8 e g, e'
  e, c' g e' f, c' f e
}
linksRefrainB = \relative c { d4 g, c8 g e g }
linksRefrainC = \relative c { d4 g, c8 g c4 }

linksRefrainD = \relative c {
  a8 a' d, a' g, g' d g,
  d' fis a, fis' g4 c,16 h a g
  a8 a' d, a' g, g' d g,
  c4 d g, g,
}

linksWH = \relative c' {
  \repeat unfold 2 \linksStrophe

  % alle meine Freund stehns drin
  h8 b a g h b a g
  h8 b a as g4 g,8 r

  \linksRefrainA \linksRefrainB
  \linksRefrainA \linksRefrainC
  \linksRefrainD
  \linksRefrainA \linksRefrainC
}

linksEndeA = \relative c' {
  c8 \times 2/3 {g16 fis g} as8 g r <g g,> <g c,>4
  es'8 \times 2/3 {b16 a b} ces8 b r e, a4
  \time 3/4
  r8 a, d4 r8 g,
  \time 4/4
  c4 g c g
}

linksEndeB = \relative c' {
  \repeat unfold 3 { c8 \times 2/3 {g16 fis g} as8 g r <g g,> <g c,>4 }
  <c, c,> <c c,> <c c,> r
}

links = \relative c' {  
  c8-^ \times 2/3 {g16 fis g} as8->( g) r g,
  c4 g c g

  \repeat volta 3 \linksWH
  \alternative {
    \linksEndeA
    \linksEndeB
  } 
}



gesangStrophe = \relative c' {
  e8 e d e f4 h,8 h
  a' a g fis g4 r8 g
  c c h b b4 a8 a h h a as g4 r8 g

  % der Wein wird schön älter
  g g f g as d, r d
  c' c b a b g r g
  g8. g16 fis8 g h d,4 d8
  e c fis d g4 r8 g
}

gesang = \relative c' {
  \time 3/4
  R2.
  \time 4/4
  r2 r4 r8 g

  \repeat unfold 2 \gesangStrophe

  % alle meine Freind stehns drin
  h'8 b a g h b a g
  h b a as g4 r

  \rechtsMelodieRefrainA \rechtsMelodieRefrainB
  \rechtsMelodieRefrainA \rechtsMelodieRefrainC
  \rechtsMelodieRefrainD
  \rechtsMelodieRefrainA
  h8 a8 f d c c c8. g'16
  c8 g16 fis as8 g r h c4
  R1
  R2.
  r2 r4 r8 g,

  % -bizki, Vrbezki, Vranek
  c'8 g16 fis as8 g r h c8. g16
  c8 g16 fis as8 g r h c8. g16
  c8 g16 fis as8 g r h c4
  c c c r
}

gesangsSystem = \new Staff \gesang
\addlyrics {
  Ich sit -- ze gern im Wirts -- haus am wirts -- häus -- lich -- en Herd.
  Dort sitz ich wie bei mir z'haus und wer -- de nicht ge -- stert.
  Der Wein _ wird schen ält -- er, in mei -- ne Keh -- le fällt er
  der Kal -- ter -- er wird kält -- er, so wie es sich ge -- hert.

  Ich les nicht in Jour -- na -- len, ich red' mit ka -- ner Frau.
  Für die müsst ich noch zah -- len, da -- zu bin ich zu schlau.
  Wenn ich In -- spi -- ra -- tion such, Ge -- sell -- schafts -- li -- ai -- son such
  Les ich das Te -- le -- fon -- buch, da find ich das ge -- nau. _
  Al -- le mei -- ne Freind stehn's drin, und zwar auf Sei -- te V:

  Von -- drak, Vor -- tel, Vip -- la -- schil
  Voy -- tech, Voz -- zek, Vim -- la -- dil
  Vio -- ra, Vra -- bel, Vr -- ti -- lek
  Vig -- lasch, Vraz -- zeck, Vich -- na -- lek
  Vreg -- ga, Vr -- ba, Vi -- ko -- dill
  Vrab -- lic, Vutz -- emm, Vis -- ko -- cil
  Voch -- e -- dec -- ka, Vug -- ge -- lic
  Vrt -- at -- ko, Vuka -- si -- no -- witc
  Vor -- rak, Von -- dru, Vor -- li -- cek
  Vo -- ra -- lek, Vos -- mik, Vor -- lik, Vr -- ba, Vr -- tl
  Vod -- ru -- pa, Voz -- en -- i -- lek
  Vri -- nis, Vos -- ta -- rek
  Vr -- ta -- la und Vip -- la -- cil
  Vr -- za -- la und Vist -- la -- cil
  Vouk, Vud -- ip -- ka, Vi -- ce -- sal
  Vraz -- dil, Vra -- na, Vim -- me -- dall
  Vr -- biz -- ki, Vr -- bez -- ki, Vra -- nek!

  " " biz -- ki, Vr -- bez -- ki, Vra -- nek
  Va -- vir -- ka, Va -- ver -- ka, Veb -- lek
  Vo -- pal -- ka, Vo -- pel -- ka, Voij -- tek!
  Weg, weg, weg!
}
\addlyrics {
  Mei Na -- me gfallt mir nim -- mer, ich hei -- ße näm -- lich Brscht.
  Mein Freind sein Nam ist schlim -- mer, der ar -- me Kerl heißt Skrscht.
  Wir schnie _ geln die Gsicht -- er und geh _ en zum Richt -- er
  Der Richt -- er sagt das richt' er, denn ihm ist das ja wrscht!
  Ich buch -- stab -- ier mein Nam -- en dem Richt -- er sein Kom -- mis
  Und sag, schaun's bei die Dam -- en is schwer mei Stra -- te -- gie.
  Der Richt -- er war sehr freind -- lich und sagt, na ja wahr -- schein -- lich
  Ihr Na -- me ist ja pein -- lich, da hab ich Sym -- pa -- thie.
  Wie wolln Sie denn jetzt heiß -- en, da sag ich, na was glaubn Sie?
}
\addlyrics {
  Mei Frau geht mich be -- tri -- gen und glaubt dass ich nichts schmeck.
  Jeden Ab -- end tut sie lie -- gen mit'n Ble -- ta -- nek ums Eck.
  Der Ble -- ta -- nek s'a Trot -- tl, mei Frau ist a Ko -- kot -- tl.
  Sie gehn zu -- samm' ins Hot -- el, da -- mit ich's net ent -- deck.
  Doch ich habs bald be -- grif -- fen und nehm mir auf Kre -- dit
  Ein tei -- ern De -- tekt -- iv -- en was folgt auf Schritt und Tritt.
  Doch schon zwei Woch -- en nach -- her _ kommt der gro -- ße Mach -- er
  Und sagt: Dass ich net lach, Herr, der Ble -- ta -- nek is' net!
  Jetzt hal -- ten Sie sich gschwind wo an, die Frau be -- triegt Sie mit:
}

pianoPart = \new PianoStaff
<<
  \new Staff = "right" \with {
    midiInstrument = "acoustic grand"
    printPartCombineTexts = ##f
  } \rechts
  \new Staff = "left" \with {
  } { \clef bass \links }
>>



\book {
\score {
  <<
    \gesangsSystem
    \pianoPart
  >>
  \layout { indent = #0 }
  \midi {
    \context {
      \Score
      tempoWholesPerMinute = #(ly:make-moment 110 4)
    }
  }
}
  \paper { page-count = #4 }
}