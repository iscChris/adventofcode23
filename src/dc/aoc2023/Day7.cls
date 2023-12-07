Class doc.aoc2023.Day7 Extends doc.aoc2023.Base
{

Parameter InputFile = "input7.txt";

Parameter FiveKind = 1;

Parameter FourKind = 2;

Parameter FullHouse = 3;

Parameter ThreeKind = 4;

Parameter TwoPair = 5;

Parameter Pair = 6;

Parameter HighCard = 7;

ClassMethod ParseValue(line)
{
    // check count ones
    For i=1:1:5 Do $INCREMENT(handvalues($EXTRACT(line,i)))

    Set key = ""
    Set count=0
    For   {
        Set key = $ORDER(handvalues(key))
        Quit:key=""
        Do $INCREMENT(count)
    
    }
    If count=1 Quit ..#FiveKind //5kind
    If count=2 {
      
        Set firstvalue = handvalues($ORDER(handvalues("")))
        If ",2,3" [firstvalue { Quit ..#FullHouse} //Full House
        ElseIf ",1,4" [ firstvalue {  Quit ..#FourKind} //4kind
    }
    If count=3 {
        Set twos = 0
        Set key2=""
         For   {
            Set key2 = $ORDER(handvalues(key2))
            Quit:key2=""
            Do:handvalues(key2)=2 $INCREMENT(twos)
    
        } 
        If twos = 2 {
            Quit ..#TwoPair //2pair
        } Else {
            Quit ..#ThreeKind //3kind
        }
    }
    If count=4 {
        Quit ..#Pair //pair
    }
     If count=5 {
      
       Quit ..#HighCard //highcard
    }
    Quit "unknown"
}

ClassMethod ParseValue2(line)
{
    // check count ones
     // check count ones
    For i=1:1:5 Do $INCREMENT(handvalues($EXTRACT(line,i)))

    Set key = ""
    Set count=0
    For   {
        Set key = $ORDER(handvalues(key))
        Quit:key=""
        Do $INCREMENT(count)
    
    }
    If count=1 Quit ..#FiveKind //5kind
    If count=2 {
      
        Set firstvalue = handvalues($ORDER(handvalues("")))
        If ",2,3" [firstvalue { 
            If $DATA(handvalues("J")) Quit ..#FiveKind
            Quit ..#FullHouse} //Full House
        ElseIf ",1,4" [ firstvalue { 
            if $DATA(handvalues("J")) quit ..#FiveKind //Four and wild or viceversa is a five of a kind
            Quit ..#FourKind} //4kind
    }
    If count=3 {
        Set twos = 0
        Set key2=""
         For   {
            Set key2 = $ORDER(handvalues(key2))
            Quit:key2=""
            Do:handvalues(key2)=2 $INCREMENT(twos)
    
        } 
         
        If twos = 2 {
            If $DATA(handvalues("J")){
                If handvalues("J")>=2 {Quit ..#FourKind}
                Else {Quit ..#FullHouse}
            }
            Quit ..#TwoPair //2pair
        } Else {
             If $DATA(handvalues("J")){
                Quit ..#FourKind 
            }
            Quit ..#ThreeKind //3kind
        }
    }
    If count=4 {
        if $GET(handvalues("J"),0){
            quit ..#ThreeKind
        }
        Quit ..#Pair //pair
    }
     If count=5 {
        If $GET(handvalues("J"),0){
            Quit ..#Pair
        }
       Quit ..#HighCard //highcard
    }
    Quit "unknown"
}

ClassMethod Run() As %Integer
{
	Kill ^hands
    
    Set stream=..GetInput(..#InputFile)
   
    Set count=0 

    //Setup all reference globals
	While 'stream.AtEnd {
    
	    Set line=stream.ReadLine()
        set hand = $TRANSLATE($PIECE(line," ",1),"AKQJT98765432","ZYXWVUTSRQPON") //Set these to be ordered, as their values
        set bet= $PIECE(line," ",2)
        Set ^hands(hand)="" //store hand and bid
        set cardrank  =..ParseValue(hand)
        Write !,hand_"  is a "_cardrank
        s rankedcard(cardrank,hand)=bet

    }
    //2 loops, backwards through ranks, then forward through cards (lowest first)
    //This will give us our multiplier as we iterate 
    //248075409 too high
    //247778678 too low
    s rank = ""
    s count =0
    s accumulator = 0
    for   {
        s rank = $O(rankedcard(rank),-1)
        q:rank=""
        w !, "Processing rank "_rank
        set currenthand = ""
        for  {
            s currenthand = $O(rankedcard(rank,currenthand))
            q:currenthand=""
            d $INCREMENT(count)
            set winnings = rankedcard(rank,currenthand)*count
            w !,count_" "_$TRANSLATE(currenthand,"ZYXWVUTSRQPON","AKQJT98765432")_" bet "_rankedcard(rank,currenthand)_" won "_winnings
            s accumulator = accumulator + winnings
        }


    }
   


     Write !,"returning results: "_accumulator,!
    Quit accumulator
}

ClassMethod Run2() As %Integer
{
	Kill ^hands
    
    Set stream=..GetInput(..#InputFile)
   
    Set count=0 

    //Setup all reference globals
	While 'stream.AtEnd {
    
	    Set line=stream.ReadLine()
        Set hand = $TRANSLATE($PIECE(line," ",1),"AKQT98765432J","ZYXWVUTSRQPOJ") //Set these to be ordered, as their values
        Set bet= $PIECE(line," ",2)
        Set ^hands(hand)="" //store hand and bid
        Set cardrank  =..ParseValue2(hand)
        Write !,hand_"  is a "_cardrank
        Set rankedcard(cardrank,hand)=bet

    }
    //2 loops, backwards through ranks, then forward through cards (lowest first)
    //This will give us our multiplier as we iterate 
 
    Set rank = ""
    Set count =0
    Set accumulator = 0
    For   {
        Set rank = $ORDER(rankedcard(rank),-1)
        Quit:rank=""
        Write !, "Processing rank "_rank
        Set currenthand = ""
        For  {
            Set currenthand = $ORDER(rankedcard(rank,currenthand))
            Quit:currenthand=""
            Do $INCREMENT(count)
            Set winnings = rankedcard(rank,currenthand)*count
            Write !,count_" "_$TRANSLATE(currenthand,"ZYXWVUTSRQPOJ","AKQT98765432J")_" bet "_rankedcard(rank,currenthand)_" won "_winnings
            Set accumulator = accumulator + winnings
        }


    }

     Write !,"returning results: "_accumulator,!
    Quit accumulator
}

}
