abstract Foods = {
  flags startcat = Comment ;
  
  -- Kommentaaride koostamiseks läheb meil väikse maailma ontoloogias vaja neli kategooriat
  --  * 'Comment' on tervik lihtlause (vrd süntaksipuude 'S')
  --  * 'Kind' on meie köögimaailmas esinevad objektid
  --  * 'Item' on ühe köögimaailmas esineva objekti konkreetne mainimine
  --  * 'Quality' on objektide võimalikud kvalileedid ehk omadused
  cat
    Comment ; Kind ; Item ; Quality ;
  
  -- Kui kategooriad ('cat') on kategoriaalse grammatika "moodustajad",
  -- siis funktsioonid ('fun') on nende võimalikud kombinatsioonid e puustruktuurid
  fun
    -- Kommentaarilause koosneb asjast ja omadusest
    Pred  : Item -> Quality -> Comment ;
    
    -- Objektid (e 'Item') on mingit kindlat liiki asjad, aga et nendest rääkida saada,
    -- siis peame viitama nendest mingile kindlale üksikule juhtumile.
    -- Umbes, et "maailmas on kalu" (Kind) aga "just see kala maitseb hästi" (Item)
    This  : Kind -> Item ;
    That  : Kind -> Item ;
    These : Kind -> Item ;
    Those : Kind -> Item ;
    
    -- Siin on loetletud kõik meie köögimaailma objektide liigid
    Wine   : Kind ;
    Cheese : Kind ;
    Fish   : Kind ;
    Pizza  : Kind ;
    
    -- Modifitseerimine varustab objektile omaduse ehk kvaliteedi
    Mod : Quality -> Kind -> Kind ;
    
    -- Omadusel võib olla suurendaja (millel võib olla suurendaja jne)
    Very : Quality -> Quality ;
    
    -- Siin on loetletud kõik me köögimaailma võimalikud omadused
    Fresh, Warm, Italian,
      Expensive, Delicious, Boring : Quality ;
    -- NB! see loend on samaväärne järgmise loendiga:
    -- Fresh : Quality ;
    -- Warm  : Quality ;
    --  ... jne ...
}
