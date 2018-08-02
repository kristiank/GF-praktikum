# GF Köögigrammatika praktikum

Koostame väikse grammatika, mille abil me saame moodustada lauseid
söögi kohta. See on traditsiooniks muutunud viis alustada GF-iga.

Praktikum vajab ainult internetiühendust ja ei vaja eraldi installitud programme.
Praktikumi tekst püüab kõik tehtu seletada otse teksti sees ja illustreerib GF-koodi 
paralleelselt Pythoni koodiga. 
Pärast praktikumi leiab iseõppija rohkem abi http://www.grammaticalframework.org/ leheküljelt.
Eesti RGLi arendatakse [GF repos](https://github.com/GrammaticalFramework/GF/tree/master/lib/src/estonian) 
aga teised sellega seotud ressursid on leitavad [GF-Estonian repositooriumis](https://github.com/GF-Estonian).


On olemas ka Pythoniprogrammeerijatele mõeldud sissejuhatus "[GF for Python programmers](https://github.com/daherb/GF-for-Python-programmers)", mis aitab maailma ümbermõtestada imperatiivsest programmeerimisviisist funktsionaalsele viisile.

Süües suureneb isu. Kes tahab midagi kasulikumat arendada, siis soovitan 
eestindada [chitchat.gf](https://github.com/michmech/chitchat). Ka on võimalik GFi grammatikaid kasutada läbi NLTK või üldse kompileerida Pythoni mooduliks.



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
aga ei oska väljendada seda maailma keeleliselt. Lisame nüüd konkreetse 
süntaksi inglise keele jaoks ehk *linearisatsioonireeglid*.



## Ingliskeelse konkreetse süntaksi sisestamine

Lisa uus konkreetne süntaks. Liiguta hiir ülevale paremasse nurka ja vajuta 
seal ilmuvale pluss-nupule *Add a concrete syntax*. Võid valikust valida 
inglise keele või *other*, pole vahet.

![Lisa konkreetne süntaks](ekraanitõmmised/02-add-concrete-syntax.png?raw=true "Lisa konkreetne süntaks")

Vali tekstirežiim ja kopeeri konkreetne süntaks failist [FoodsEng.gf](FoodsEng.gf). Vali tagasi juhendatud režiim.

Konkreetse süntaksi lähtekoodis on viga. Millest see tuleneb? Püüa see parandada.

![Viga konkreetses süntaksis](ekraanitõmmised/03-pitsa-not-part-of-abstract.png?raw=true "Viga konkreetses süntaksis")

Küsimus: kuidas oskas GF meile selle vea kätte näidata?



## Proovi järele külmkapiukse magnetitega

Isegi kui sa ei saanud viga eemaldatud, võid nüüd järele proovida 
-- vajuta nupule *Minibar* (kood kompileeritakse automaatselt).



## Kuidas see töötab? Pizza-funktsioon

Milles seisnes pitsa-viga? Sellise nimega funktsiooni polnud abstraktses 
grammatikas deklareeritud. Õige on *Pitsa* asemel *Pizza*, aga mida see funktsioon teeb?

```Haskell
Pizza = regNoun "Pizza" ;
```

Lühidalt võib öelda, et see lisab grammatika leksikonisse pizza-sõna kõik 
käändevormid, ehk käändetabeli. *Sõna* mõiste GFis ongi väga konkreetselt 
üks käändetabel. See on üks väga klassikaline viis õpetada keeli, ehk mäletad 
ladina keele tundides õpetatu?

``Pizza`` väärtuseks saab funktsiooni ``regNoun`` väljund. Funktsionaalses 
programmeerimisparadigmas jäetakse tavaliselt sulud ära funktsiooni sisendi ümber, 
aga võid mõelda sellest kui Pythonis vastava ``regNoun("Pizza")``.

Aga kuidas see funktsioon töötab?
Abstraktsest grammatikast teame juba ette, et ``Pizza`` kategooria (e tüüp) 
peab olema ``Kind``. Inglise keele konkreetsest süntaksist saame teada, et ``Kind`` 
on implementeeritud kui ``Kind = {s : Number => Str} ;``. Lihtsalt öeldes 
tähendab see käändevormide tabelit, mille veergudeks on ``Number`` 
(ehk ``Sg`` ja ``Pl``, samuti konkreetses süntaksis määratud) ja tabeliväljade 
sisuks on ``Str``, mis on GFi sisseehitatud tüüp vastavalt teiste programmeerimiskeelte *string*.
Siinkohal tuleb märkida, et ``Kind = {s : Number => Str} ;`` on keelespetsiifiline definitsioon
ja midagi ei takista meid defineerimast *sõna* teisiti mõnes teises keeles. Näiteks eesti keeles
võiks vaja minna definitsioon ``Kind = {s : Number => Case => Str} ;``, aga sellest rohkem allpool.

Täpsemalt tähendab see seda, et ``Kind`` on objekt üheainsa väljaga ``s`` ja et selle ``s``-välja 
tüüp on tabel arvust sõneni ehk ``Number => Str``.

Suur osa GFiga programmeerimisest on selliste objektide edasi-tagasi saatmine mööda 
abstraktse grammatika puustruktuuri. Mil moel seda tehakse, sõltub vaid programmeerija 
mõtelaadist ja järgitavast süntaksiteooriast, aga põhimõtteliselt ei määra GF selle 
kohta mingeid piiranguid.

Nüüd edasi. Funktsiooni parem pool ``regNoun`` on defineeritud konkreetses süntaksis järgnevalt:

```Haskell
regNoun : Str -> {s : Number => Str}  = \car -> noun car (car + "s") ;
```

Lihtsustatult ümberkirjutatuna Pythoniks, oleks see

```Python
def regNoun(car):
  return noun(car, car+"s")  
```

Kui te ei ole harjunud programmeerima funktsionaalses paradigmas, lisan siia lisaseletusi.

Funktsiooni vasak pool (``regNoun : Str -> {s : Number => Str}``) defineerib, et ``regNoun`` on funktsioon,
mis võtab sisendiks ``Str`` ja selle väljundiks on meile juba tuttav ``{s : Number => Str}``.

Funktsiooni parem pool (``\car -> noun car (car + "s")``) on nimetu lambdafunktsioon ``\`` (oma nime saab ta vasakul pool).
Nimetu funktsiooni sisend saab muutujanimeks ``car`` ja funktsiooni sisu on ``noun car (car + "s")``.

Pythonis on ka võimalik määrata muutujate tüüpe, ja tõetruum Pythoni kood oleks järgmine:

```Python
# lihtsustamaks on 'Number' järgnevas asendatud 'str' tüübiga
from typing import Dict
def regNoun(car: str) -> Dict[str, Dict[str, str]]:
  return noun(car, car+"s")  
```

Seega edastab funktsioon ``regNoun`` lihtsalt oma sisendi teisele funktsioonile 
``noun`` muutes seejuures sisendi kaheks sõneks, millest teisele lisatakse s-täht 
lõppu. Kuidas töötab aga funktsioon ``noun``?

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

``noun`` on praktiliselt võetud "worst-case" stsenaariumi funktsioon, 
sisestamaks irregulaarsete sõnade käändetabelid, nagu ``noun "mouse" "mice"``.
Kõik regulaarsed sõnad saab sisestada ühe argumendiga ``regNoun "cat"``, mis siis 
edastatakse ``noun "cat" "cats"``.

Lõppkokkuvõtteks saab siis ``Pizza`` enda väärtuseks käändetabeli sõnedega *Pizza* ja *Pizzas*:
```Haskell
Pizza = {
  s = table {
    Sg => "Pizza";
    Pl => "Pizzas"
  }
}
 ```



### Kuidas see töötab? Det-funktsioonid

Illustreerimaks objektides kantud informatsiooni edasi-tagasi saatmist 
ja kommunikatsiooni süntaksipuus, vaatame lähemalt kuidas ``det`` funktsioon töötab.

Abstraktses grammatikas on ``This``, ``That``, ``These`` ja ``Those`` funktsioonid, 
mis muudavad ``Kind`` kategooria liikmeid ``Item`` kategooria liikmeteks. Abstraktses
süntaksipuus moodustavad nad seega hargmike nagu pildil näidatud.

![abstraktne süntaksipuu](ekraanitõmmised/04-abstraktne-puu-warm-det-pizza.png?raw=true "Abstraktne süntaksipuu")

Inglise keele konkreetses süntaksis on määratleja (*determiner*) töötamine defineeritud järgmiselt

```Haskell
det : Number -> Str ->
  {s : Number => Str} -> {s : Str ; n : Number} =
    \n,det,noun -> {s = det ++ noun.s ! n ; n = n} ;
``` 

Seda koodi kasutatakse mh ``This  = det Sg "this";`` ja ``These  = det Sg "these";``. 
Kuna see kood näitlikustab üht funktsionaalse programmeerimise eripära, nimelt 
funktsiooni osalist rakendamist (*partial application*), peame seda juhtumit lähemalt vaatama.

Funktsiooni osalise rakendamise puhul ei anta funktsioonile kõiki selle argumente. Niisiis
ei rakendata funktsiooni lõpuni ja ei tagastata väärtust vaid hoopis uus funktsioon.

``det``-funktsioon ``\n,det,noun`` võtab sisendiks kolm argumenti: ``n``, ``det`` ja ``noun``.
Aga ``This`` defineerimisel ehk ``det Sg "this"`` antakse sellele ainult kaks argumenti sisendiks 
``n = Sg`` ja ``det = "this"``. Funktsionaalses programmeerimises on see tavaline, ja niiviisi moodustatakse 
uus funktsioon millel, on ainult üks sisend (``noun``).

Koodiga ``This  = det Sg "this";`` koostatakse seega järgmine funktsioon (lihtsustatult seletatud Pythoniga):

```Python
def This(noun):
  n = "Sg"
  det = "this"
  
  return {"s": (det, noun["s"][n]) }
```

ja koodiga ``These  = det Pl "these";`` koostatakse järelikult järgmine funktsioon:
```Python
def These(noun):
  n = "Pl"
  det = "these"
  
  return {"s": (det, noun["s"][n]) }
```

See funktsioon elab süntaksipuus ja kui hiljem koostatakse nt moodustaja ``These Pizza`` jaoks, 
saab funktsioon panna kõik informatsiooni kokku:

```Python
Pizza = {
  "s" : {
    "Sg" : "Pizza",
    "Pl" : "Pizzas"
  }
}

>>> These(Pizza)
{'s': ('these', 'Pizzas')}
>>> This(Pizza)
{'s': ('this', 'Pizza')}
```

Väljundiks on käändetabel, mille sisuks on kombineeritud õige informatsioon. 
Informatsioon valitakse ``n = n`` järgi elik ühilduvus arvus.



### Kuidas see töötab? Mod-funktsioon

Köögigrammatikas on ``Mod``-funktsiooni ülesanne varustada nimisõna atribuudiga ehk täiendiga.

```Haskell
Mod quality kind = {s = \\n => quality.s ++ kind.s ! n};
``` 

Koodiga koostatakse uus käändetabel, mille sisuks on argumendiks antud 'quality' 
'kind' sõned.

Lihtsustatud Pythoni variant:
```Python
def Mod(quality, kind):
  Number = ("Sg", "Pl")
  modifiedKindTables = dict()
  
  for n in Number:
    modifiedKindTables[n] = (quality["s"], kind["s"][n])
  
  return {"s": modifiedKindTables}

Pizza = {
  "s" : {
    "Sg" : "Pizza",
    "Pl" : "Pizzas"
  }
}

Warm = {
  "s" : "warm"
}

>>> Mod(Warm, Pizza)
{'s': {'Sg': ('warm', 'Pizza'), 'Pl': ('warm', 'Pizzas')}}
```

Miks tagastatakse terve käändetabel Sg ja Pl kirjetega? Sest olles süntaksi puus 
``Mod`` juures, ei oska me veel teada, mis arvuga tegu on. Seda me teame alles 
liikudes ``These`` juurde. Teisisõnu, arv on tüübi Item omadus, mitte Kind tüübi oma.

![abstraktne süntaksipuu](ekraanitõmmised/05-abstraktne-puu-det-warm-pizza-delicious.png?raw=true "Abstraktne süntaksipuu")


Tegevus: Püüa ise seletada lahti, kuidas töötab funktsioon ``Pred item quality = {s = item.s ++ copula ! item.n ++ quality.s};``.



## Eestikeelne konkreetne süntaks

Nüüd lisa veebieditorisse veel üks konkreetne süntaks eesti keele jaoks ja kopeeri sinna inglise oma.

Mida on meil vaja muuta selleks, et me saaksime eestikeelseid lauseid söögi kommenteerimiseks genereerida-sõeluda?

* koopula konstruktsiooni ei ole vaja (see pitsa **on** maitsev VS need pitsad **on** maitsvad)
* käändeid (õnneks) ei ole vaja, kõik kommentaarid kasutavad nimetavat
* arvukategooria jääb samaks
* kas ``regNoun`` on üldistatav eesti keele jaoks?
* kui mitte, saame kasutada nt ``noun "vein" "veinid"``
* eesti adjektiivid ühilduvad arvus
* kas unustasin midagi?

Proovi viia eestikeelse konkreetse süntaksi kood lõpuni.



### Koodinäiteid

Järgmised koodinäited on piisavad, et saada eestikeelse konkreetse grammatika
tööle. Sinu ülesandeks on need õigesti paigutada ja ülejäänud ingliskeelsed sõnad 
tõlkida.



#### Sõnastiku ladumine
```Haskell
Wine    = noun "vein" "veinid";
Cheese  = noun "juust" "juustud";
Italian = noun "itaaliapärane" "itaaliapärased"; -- NB! kasutame 'noun'
```



#### Adjektiivide ühildumine arvus
```Haskell
lincat
  Quality = {s : Number => Str};

lin
  Mod quality kind = {s = \\n => quality.s ! n ++ kind.s ! n};
```
Kas näed erinevust?
* Quality lineariseerimiskategooria on nüüd sama, mis Item
* ``Mod`` funktsioonis valitakse õige käändevorm välja (``.`` on projektsiooni-operaator ehk andmevälja valija. ``!`` on selektor ehk tabeliveeru valija)



#### Ilma koopulata ``Pred``
```Haskell
Pred item quality = {s = item.s ++ "on" ++ quality.s ! item.n};
```

Küsimus: mida me siinkohal kasutame, et valida omadussõna õige kääne? See on samuti üks viis, kuidas kommunikatsiooni korraldada süntaksipuus.

Siinkohal oleks paslik seletada rohkem lahti seda, kuidas abstraktse 
grammatika puu sõlmed (s.o tipud ja lehed) sisaldavad ainult funktsioone 
ning seda, et funktsioonid saavad ligi oma alampuude sõlmedes sisalduvale 
informatsioonile.

Näiteks ``These Pizza`` puhul valib ``These`` oma alampuu ``Pizza`` funktsioonilt 
väljastatud käändetabelist vaid mitmuse. Funktsioon ``Pred item quality`` valib 
mh oma alampuu ``Quality``-sõlmest välja õige informatsiooni kasutades oma 
``Item``-sõlmes sisalduvat arvu (``quality.s ! item.n``).


# Resource Grammar Library

Eelmiselt näidatud viis programmeerida ei ole jätkusuutlik mitmel põhjusel
* iga rakenduse jaoks peab kopeerima korduvaid lingvistilisi elemente sõnade morfoloogiliste kujude ja lausete konstrueerimiseks
* kõik moodustajad ei kuulu kategooriatesse (s.o kõik need sõnad, mida sisestatakse otse kuskil lause sisse, nt "on" ``{s = item.s ++ "on" ++ quality.s}``)
* kood ei ole piisavalt abstraktne ja ei ole lingvisti jaoks loetav -- nt on kategooriad defineeritud andmetüüpidena

GF-il on aastate jooksul ja uute keelte lisamisel väljakujunenud traditsioon 
eraldada need korduvad elemendid teekidesse, mida ühiselt nimetetakse 
RGLiks (*Resource Grammar Library*).

RGLi üldiseks põhimõteks on eraldada keelespetsiifilised korduvused ja 
ülekeelelised korduvused eri moodulitesse. Keelespetsiifilised on nt leksikon 
ja morfoloogia ning ülekeelelised on süntaktilised konstruktsioonid. Igal 
keelel on siiski võimalik ka keelespetsiifilisi süntaktilisi konstruktsioone lisada.

Moodulid on vastavalt ``Lexicon``, ``Paradigms`` ja ``Syntax`` (ning ``Extra``).

Tuleb välja, et RGLi juures tekkinud "traditsioon" on oma põhimõtelt väga 
sarnane UD traditsiooniga. Sellest rohkem praktikumi lõpus.

GFi moodulisüsteem on laiendatav sarnaselt objektorienteeritud paradigmale 
ja seega on nt germaani keeltel olemas ühine "protokeele" moodul. Läänemere soome 
keelte jaoks ei ole veel sellist ühist moodulit loodud, aga töö juures 
vadja keele GFiga on võimalik, et selline moodul kunagi luuakse.

RGL funktsioneerib sarnaselt rakendusliidesele (API) ja seega on iga keele 
RGLil ühised funktsiooninimetused. Üldiselt algavad kõik funktsiooninimed mk-ga. 
Näiteks ``mkN`` on funktsioon, mille väljundiks on nimisõna. ``mkV2`` väljundiks 
on kahekohaline verb. ``mkRCL`` väljundiks on relatiivlause. Ja nii edasi.

Funktsiooni(nime)d on üledefineeritud, mistõttu näiteks ``mkV2`` oskab valida 
õige ``mkV2*`` funktsiooni sõltuvalt selle sisendisse antud ja väljundist 
vajatud parameetritest. Teisiti öeldud, kuna funktsioonid representeerivad 
puu struktuuri ehk kategooriate kombineerumisi, valitakse üledefineeritud 
funktsiooniga õige struktuur sõltuvalt süntaktilistelt kategooriatest. 
Juhul kui kategooriad on valed, oskab GF kompilaator head nõu anda veateates.



# Köögigrammatika uuesti ja toetudes RGLile

Teeme inglise köögigrammatika uuesti kasutades RGLi. 
Tervikkood on antakse teile kätte, aga käime kõigepealt läbi need kohad, 
mis eelmisest koodist erinevad.

Et kasutada RGLi, on vaja importida õiged moodulid süntaksi, leksikoni 
ja morfoloogia tarbeks. 

```Haskell
concrete FoodsEng of Foods =
  open SyntaxEng, LexiconEng, ParadigmsEng in {
    --
}
```

Seejärel on vaja muuta lineariseerimises kasutatud kategooriad. Kasutame 
näiteks järgmisi kategooriaid:

```Haskell
lincat
  Comment = Utt;
  Quality = AP;
  Item = NP;
  Kind = CN;
```

Seletan kategooriaid veidike lahti. ``Utt`` (*utterance*) ehk lausung on 
diskursuse üksus, mis võib olla lause, küsimus, käsk vms. 
``Cl`` (*clause*) on ühtmoodi lause, mis väljendab mingit propositsiooni nagu nt mõni fakt "see pizza on soe". 
Lauseliike on palju aga meie siinses väikses köögigrammatikas läheb meil vaja ainult affirmatiivseid lauseid oleviku pöördes.
``AP`` (*adjective phrase*) ehk adjektiivifraas.
``NP`` (*noun phrase*) ehk noomenifraas. Noomenifraas võib koosneda mh üldnimest.
``CN`` (*common noun*) ehk üldnimi. 

Kategooriad (ehk funktsionaalse programmeerimise tüübid) on omaette teema, 
millest siinjuures rohkem juttu ei tule. Siinkohal on õige märkida vaid seda, 
et uued kategooriad on süntaksi kirjeldamiseks paremal abstraktsioonitasemel,
võimaldades koodist hõlpsamini aru saada (mis on eelduseks sujuvaks koostööks 
lingvisti ja programmeerija-keeletehnoloogi vahel).

Veel on vaja muuta lineariseerimisel kasutatud operatsioonid, et need 
vastaksid äsja spetsifitseeritud kategooriatele. Teeme seda liikudes nö
ülevalt alla, suuremast üksusest väiksema poole. Kui see suund tundub 
kummastav, võid proovida lugeda seletused altpoolt üles. Keeleõpikuidki 
on enam-vähem kahte liiki, need mis alustavad tekstist või lausest ning 
need, mis alustavad morfoloogiast ja sõna(liikide)st.

```Haskell
lin
  Pred item quality = mkUtt (mkCl item quality);
```

Predikatsiooni subjekt ja kvaliteet moodustavad lause (``mkCla`` väljastab 
lause), millest luuakse lausung (``mkUtt``).

```Haskell
lin
  Mod quality kind = mkCN quality kind;
```

Täiendiga nimisõna moodustab üldnime (``mkCN``). ``Quality`` kategooriaks 
valisime varem AP ehk adjektiivifraasi ja ``Kind`` kategooriaks on samuti 
üldnimi. Järelikult saab täiendiga nimisõna mängida samu rolle süntaksipuus, 
mis teisedki üldnimed, sest mõlemad on ``Kind``.

```Haskell
lin
  Very quality = mkAP (mkAdA "very") quality;
```

Adjektiivifraas moodustatakse omadussõnalisest määrsõnast *very* 
(*adjective-modifying adverb*) 
ja kvaliteedist (mis ju varem defineeritud kui adjektiivifraas).
Seega on seegi funktsioon rekursiivne ja saame moodustada ahelaid 
``Very Very ... Very quality``.

```Haskell
lin
  This kind = mkNP this_Det kind;
  Cheese  = mkCN (mkN "cheese");
```

``this_Det`` on juba spetsifitseeritud leksikonis, aga ``cheese`` kirje (ehk 
käändetabeli) "ehitame" ise, kasutades selleks ``mkN`` mis on varustatud 
targa paradigmavalijaga (*Smart Paradigms*). Eks hiljem vaatame, kas kõikide 
sõnade paradigmad valiti õigesti.

RGLi kasutav kood on tervenisti kirjas [FoodsEngRGL.gf failis](FoodsEngRGL.gf). 
Loo uus keel või asenda olemasolev kood failis antuga ja püüa aru saada mida 
see teeb. 
Proovi kas see töötab laitmatult *Minibar*-is.



## Eesti keele RGLiga variant

Nüüd kui oled sisestanud inglise keele koodi ja oled veendunud, et see töötab 
vähemalt sama hästi, mis meie esimese, isenikerdatud inglise keele konkreetse 
süntaksi puhul. Siis asenda vana eesti keele kood inglise RGLi kasutava koodiga
ja muuda see vastavalt eesti keele vajadustele. Seekord peaks koodi eestindamine 
olema palju lihtsam.



### Näiteid

#### Muuda moodulite nimed vastavalt eesti keelele

```Haskell
concrete FoodsEst of Foods =
  open SyntaxEst, LexiconEst, ParadigmsEst in {
    --
}
```



#### Adjektiivadverbiaal

```Haskell
lin
  Very quality = mkAP (mkAdv "väga") quality;
```

Eesti keele puhul võime kasutada adjektiivse adverbiaali asemel lihtsalt adverbiaali.



#### Asesõnad ja leksikon

```Haskell
lin
  This kind = mkNP this_Det kind;
  Cheese  = mkCN (mkN "juust");
```

Näitav määratleja this_Det on eesti leksikonis juba olemas, seda pole vaja muuta.

Sõnade puhul tuleb *Minibar*'is üle kontrollida, kas need saavad õiged käändevormid. 
Vastasel juhul peab kasutama ``mkN "juust" "juustu"`` või koguni ``mkN "juust" "juustu" "juustu"``.

