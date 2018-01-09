abstract Foods = {
  flags startcat = Comment ;
  cat
    Comment ; Item ; Kind ; Quality ;
  fun
    -- Kommentaarilause koosneb asjast ja omadusest
    Pred  : Item -> Quality -> Comment ;
    
    -- Asi (e Item) on mingit kindlat liiki objekt
    -- Selgitus maailmas on kalu (Kind), minu kala maitseb hästi (Item)
    This  : Kind -> Item ;
    That  : Kind -> Item ;
    These : Kind -> Item ;
    Those : Kind -> Item ;
    
    -- Modifitseerimine varustab objektile omaduse ehk kvaliteedi
    Mod : Quality -> Kind -> Kind ;
    
    -- Kõik maailma objektid
    Wine   : Kind ;
    Cheese : Kind ;
    Fish   : Kind ;
    Pizza  : Kind ;
    
    -- Omadusel võib olla suurendaja (millel võib olla suurendaja jne)
    Very : Quality -> Quality ;
    
    -- Kõik maailma omadused
    Fresh, Warm, Italian,
      Expensive, Delicious, Boring : Quality ;
}
