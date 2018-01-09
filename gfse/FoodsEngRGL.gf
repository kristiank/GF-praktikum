concrete FoodsEng of Foods = 
  open SyntaxEng, ParadigmsEng, LexiconEng in {

flags coding = utf8 ;

lincat
    Comment = Utt;
    Quality = AP;
    Kind = CN;
    Item = NP;

lin
    Pred item quality = mkUtt (mkCl item quality);
    Mod quality kind = mkCN quality kind;
    Very quality = mkAP (mkAdA "very") quality;
    This kind = mkNP this_Det kind;
    That kind = mkNP that_Det kind;
    These kind = mkNP these_Det kind;
    Those kind = mkNP those_Det kind;
    Wine  = mkCN (mkN "wine");
    Cheese  = mkCN (mkN "cheese");
    Fish  = mkCN (mkN "fish" "fish");
    Pizza  = mkCN (mkN "Pizza");
    Fresh  = mkAP (mkA "fresh");
    Warm  = mkAP (mkA "warm");
    Italian  = mkAP (mkA "Italian");
    Expensive  = mkAP (mkA "expensive");
    Delicious  = mkAP (mkA "delicious");
    Boring  = mkAP (mkA "boring");

param
    Number = Sg | Pl;

}
