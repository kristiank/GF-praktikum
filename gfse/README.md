# Söögikommentaaride praktikum

Koostame väikse grammatika, mille abil me saame moodustada lauseid
söögi kohta.

# Alustamine

## Veebieditori avamine
1. Ava http://grammaticalframework.com/
1. vali [GF Cloud](http://cloud.grammaticalframework.org/)
1. vali [GF online editor for simple multilingual grammars](http://cloud.grammaticalframework.org/gfse/)
1. vali *Your grammars* alt *New grammar*

Oled jõudnud veebieditorisse, mis kuvab tühja abstraktset grammatikat nimega *Unnamed*.

## Abstraktse grammatika sisestamine

Muuda grammatika nimi **Unnamed** asemel **Foods**.

![Muuda grammatika nimi](ekraanitõmmised/01-rename-grammar.png?raw=true "Muuda grammatika nimi")

Vali tekstirežiim -- vajuta nupule *Text mode*

Kopeeri abstraktne grammatika failist [Foods.gf](Foods.gf).

Tutvu märkustega ja vali juhendatud režiim -- vajuta nupule *Guided mode*.

Proovi, kas kood kompileerub vigadeta -- vajuta nupule *Compile*.

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
