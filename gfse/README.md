# GF Köögigrammatika praktikum

Koostame väikse grammatika, mille abil me saame moodustada lauseid
söögi kohta. See on traditsiooniks muutunud viis alustada GF-iga.

Praktikum vajab ainult internetiühendust ja ei vaja eraldi installitud programme.
Praktikumi tekst püüab kõik tehtu seletada otse teksti sees. 
Pärast praktikumi leiab iseõppija rohkem abi http://www.grammaticalframework.org/ leheküljelt.


# Alustamine


## GF veebieditori avamine
1. Ava http://grammaticalframework.com/
1. vali [GF Cloud](http://cloud.grammaticalframework.org/)
1. vali [GF online editor for simple multilingual grammars](http://cloud.grammaticalframework.org/gfse/)
1. vali *Your grammars* alt *New grammar*

Oled jõudnud veebieditorisse, mis kuvab tühja abstraktset grammatikat nimega *Unnamed*.


## Abstraktse grammatika sisestamine

Muuda grammatika nimi **Unnamed** asemel **Foods**.

![Muuda grammatika nimi](ekraanitõmmised/01-rename-grammar.png?raw=true "Muuda grammatika nimi")

Vali koodisisestamiseks tekstirežiim -- vajuta nupule *Text mode*

Kopeeri abstraktne grammatika failist [Foods.gf](Foods.gf).

Tutvu märkustega ja mine tagasi juhendatud režiimile -- vajuta nupule *Guided mode*.

Proovi, kas kood kompileerub vigadeta -- vajuta nupule *Compile*.

Abstraktne grammatika kireldab terve meie väikse köögimaailma võimalused (ehk kombinatoorika), 
aga ei oska väljendada seda maailma keeleliselt. Lisame nüüd inglise keele *linearisatsioonireeglid*.

## Ingliskeelse konkreetse süntaksi sisestamine

Lisa uus konkreetne süntaks. Liiguta hiir ülevale paremasse nurka ja vajuta seal ilmuvale pluss-nupule *Add a concrete syntax*. Võid valikust valida inglise keele või *other*, pole vahet.

![Lisa konkreetne süntaks](ekraanitõmmised/02-add-concrete-syntax.png?raw=true "Lisa konkreetne süntaks")

Vali tekstirežiim ja kopeeri konkreetne süntaks failist [FoodsEng.gf](FoodsEng.gf). Vali tagasi juhendatud režiim.

Konkreetse süntaksi lähtekoodis on viga. Millest see tuleneb? Püüa see parandada.

![Viga konkreetses süntaksis](ekraanitõmmised/03-pitsa-not-part-of-abstract.png?raw=true "Viga konkreetses süntaksis")


## Proovi järele külmkapiukse magnetitega

Isegi kui sa ei saanud viga eemaldatud, võid nüüd järele proovida -- vajuta nupule *Minibar* (kood kompileeritakse automaatselt).


## Kuidas see töötab?

Milles seisnes pitsa-viga? Sellise nimega funktsiooni polnud abstraktses grammatikas deklareeritud. Õige on *Pitsa* asemel *Pizza*, aga mida see funktsioon teeb?

```Haskell
Pizza = regNoun "Pizza" ;
```

Lühidalt võib öelda, et see lisab grammatika leksikonisse pizza-sõna kõik käänded, ehk käändetabeli. Sõna mõiste GFis ongi väga konkreetselt üks käändetabel. See on üks väga klassikaline viis õpetada keeli, mäletad ladina keele tundides õpetatut?

``Pizza`` väärtuseks saab funktsiooni ``regNoun`` väljund. Funktsionaalses programmeerimisparadigmas jäetakse tavaliselt sulud ära funktsiooni sisendi ümber, aga võid mõelda sellest kui ``regNoun("Pizza")``.

Abstraktsest grammatikast teame juba ette, et ``Pizza`` kategooria (e tüüp) peab olema ``Kind``. Inglise keele konkreetsest süntaksist saame teada, et ``Kind`` on implementeeritud kui ``Kind = {s : Number => Str} ;``. Lihtsalt öeldes tähendab see käändevormide tabelit, mille veergudeks on ``Number`` (ehk ``Sg`` ja ``Pl``, samuti konkreetses süntaksis määratud) ja tabeliväljade sisuks on ``Str``, mis on GFi sisseehitatud tüüp vastavalt teiste programmeerimiskeelte *string*.
Täpsemalt tähendab see seda, et ``Kind`` on objekt üheainsa väljaga ``s`` ja et selle ``s``-välja tüüp on tabel arvust sõneni ehk ``Number => Str``.

Suur osa GFiga programmeerimisest on selliste objektide edasi-tagasi saatmine mööda abstraktse grammatika puustruktuuri. Mil moel seda tehakse, sõltub ehk programmeerija mõtelaadist ja järgitavast süntaksiteooriast, aga põhimõtteliselt ei määra GF selle kohta mingeid piiranguid.

Nüüd edasi. Funktsiooni parem pool ``regNoun`` on defineeritud konkreetses süntaksis:

```Haskell
regNoun : Str -> {s : Number => Str}  = \car -> noun car (car + "s") ;
```

Ümberkirjutatuna Pythoniks, oleks see

```Python
# lihtsustamaks on 'Number' järgnevas asendatud 'int' tüübiga
from typing import Dict
def regNoun(car: str) -> Dict[str, Dict[int, str]]:
  return noun(car, car+"s")  
```

Seega edastab funktsioon ``regNoun`` lihtsalt oma sisendi teisele funktsioonile ``noun`` muutes seejuures sisendi kaheks sõneks, millest teisele lisatakse s-täht lõppu. Kuidas töötab funktsioon ``noun``?

```Haskell
noun : Str -> Str -> {s : Number => Str}  = \man,men -> {
  s = table {
    Sg => man;
    Pl => men
  }
};
```

Pythoniks ümberkirjutatuna
```Python
# lihtsustamaks on 'Number' tüüp järgnevas asendatud 'str' tüübiga
def noun(man, men):
  return {
      "s" : {
          "Sg": man,
          "Pl": men
      }
    }
```

See on praktiliselt võetud "worst-case" stsenaariumi funktsioon, sisestamaks irregulaarseid sõnu nagu ``noun "mouse" "mice"``.
Kõik regulaarsed sõnad saab sisestada ühe argumendiga ``regNoun "cat"``.

@todo: Kas lisada seletus funktsioonile ``Mod quality kind = {s = \\n => quality.s ++ kind.s ! n};`` või ``Pred item quality = {s = item.s ++ copula ! item.n ++ quality.s};``. See illustreeriks ilusti objektide edastamist süntaksipuus...


## Eestikeelne konkreetne süntaks

Lisa veebieditorisse veel üks konkreetne süntaks ja kopeeri sinna inglise oma.

Mida on meil vaja muuta selleks, et me saaksime eestikeelseid lauseid söögi kommenteerimiseks genereerida-sõeluda?

* koopula konstruktsiooni ei ole vaja (see pitsa on maitsev VS need pitsad on maitsvad)
* käändeid (õnneks) ei ole vaja, kõik kommentaarid kasutavad nimetavat
* arvukategooria jääb samaks
* kas ``regNoun`` on üldistatav eesti keele jaoks?
* kui mitte, ajame asja ära ``noun "vein" "veinid"``
* eesti adjektiivid ühilduvad arvus
* kas unustasin midagi?

Proovi viia eestikeelse konkreetse süntaksi kood lõpuni.


### Näiteid
Ilma koopulata ``Pred``
```Haskell
Pred item quality = {s = item.s ++ "on" ++ quality.s};
```

Sõnastiku ladumine
```Haskell
Wine  = noun "vein" "veinid";
Cheese  = noun "juust" "juustud";
```


# Resource Grammar Library

Eelmiselt näidatud viis programmeerida ei ole jätkusuutlik, iga rakenduse jaoks peab kopeerima korduvaid elemente sõnade morfoloogiliste kujude ja lausete konstrueerimiseks. Ka esineb nn sünkategoreemilisi kategooriaid (kõik need sõnad, mida sisestatakse otse kuskil lause sisse, nt "on" ``{s = item.s ++ "on" ++ quality.s}``).

GF-il on aastate jooksul ja uude keelte lisamisel väljakujunenud traditsioon eraldada need korduvad elemendid teekidesse, mida ühiselt nimetetakse RGLiks (*Resource Grammar Library*).

RGLi üldiseks põhimõteks on eraldada keelespetsiifilised korduvused ja ülekeelelised korduvused moodulitesse. Keelespetsiifilised on nt leksikon ja morfoloogia ning ülekeelelised on süntaktilised konstruktsioonid. Igal keelel on siiski ka keelespetsiifilised süntaktilised konstruktsioonid võimalikud.

Moodulid on vastavalt ``Lexicon``, ``Paradigms`` ja ``Syntax`` (ning ``Extra``).

Tuleb välja, et RGLi juures tekkinud "traditsioon" on oma põhimõtelt väga sarnane UD traditsiooniga. Sellest rohkem praktikumi lõpus.

GFi moodulisüsteem on laiendatav sarnaselt objektorienteeritud paradigmale ja seega on nt germaani keeltel olemas ühine "protokeel". Läänemere soome keelte jaoks ei ole veel sellist ühist moodulit loodud, aga töö juures vadja keele GFiga on võimalik, et selline moodul varsti tekkib.

RGL funktsioneerib sarnaselt rakendusliidesele (API) ja seega on iga keele RGLil ühised funktsiooninimetused. Üldiselt algavad kõik funktsiooninimed mk-ga. Näiteks ``mkN`` on funktsioon, mille väljundiks on nimisõna. ``mkV2`` väljundiks on kahekohaline verb. ``mkRCL`` väljundiks on relatiivlause. Ja nii edasi.

Funktsioonid on üledefineeritud, mistõttu näiteks ``mkV2`` oskab valida õige ``mkV2*`` funktsiooni sõltuvalt selle sisendisse antud ja väljundist vajatud parameetritest. Teisiti öeldud, kuna funktsioonid representeerivad puu struktuuri ehk kategooriate kombineerumisi, valitakse üledefineeritud funktsiooniga õige struktuur sõltuvalt süntaktilistelt kategooriatest. Juhul kui kategooriad on valed, oskab GF kompilaator head nõu anda otse veateates.


## Köögigrammatika toetudes RGLile

Et kasutada RGLi, on vaja importida õiged moodulid süntaksi, leksikoni ja morfoloogia tarbeks.

```Haskell
concrete FoodsEng of Foods =
  open SyntaxEng, LexiconEng, ParadigmsEng in {
    --
}
```

Seejärel on vaja muuta lineariseerimises kasutatud kategooriad. @todo: lisa seletused Utt, NP jne jaoks. Miks on objektid CN (*commont noun*) aga identifitseeritavad objektid NP-fraasid?

```Haskell
  lincat
    Comment = Utt;
    Quality = AP;
    Kind = CN;
    Item = NP;
```

Veel on vaja muuta lineariseerimisel kasutatud operatsioonid, et need vastaksid äsja spetsifitseeritud kategooriatele.

```Haskell
  lin
    Pred item quality = mkUtt (mkCl item quality);
```

```Haskell
  lin
    Mod quality kind = mkCN quality kind;
```

```Haskell
  lin
    Very quality = mkAP (mkAdA "very") quality;
```

``this_Det`` spetsifitseeritud leksikonis, aga ``cheese`` kirje (ehk käändetabeli) "ehitame" ise.
```Haskell
  lin
    This kind = mkNP this_Det kind;
    Cheese  = mkCN (mkN "cheese");
```

RGL kasutav kood on tervenisti kirjas [FoodsEngRGL.gf failis](FoodsEngRGL.gf). Loo uus või asenda olemasolev kood sellega ja püüa aru saada mida see teeb. Proovi kas see töötab laitmatult *Minibar*-is.


## Eesti keele RGLiga variant

@todo: kui oled sisestanud inglise keele koodi ja oled selle akna juures, vali nüüd tekitada uus keele linearisatsioon. Inglise keele kood kopeeritakse sinna automaatselt. Muuda kõik vastavalt eesti keele vajadustele.


### Näiteid
ParadigmsEng -> ParadigmsEst
this_Det on eesti keele leksikonis olemas, seda pole vaja muuta
