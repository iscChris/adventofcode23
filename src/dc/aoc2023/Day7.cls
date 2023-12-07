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
    // split out array into occurences
    For i=1:1:5 Do $INCREMENT(handvalues($EXTRACT(line,i)))

    Set key = ""
    Set count=0
    For   {
        Set key = $ORDER(handvalues(key))
        Quit:key=""
        Do $INCREMENT(count)
    
    }
    If count=1 Quit ..#FiveKind 
    If count=2 {
        Set firstvalue = handvalues($ORDER(handvalues(""))) //get an occurence, will either be 4A1B or 3A2B
        If ",2,3" [firstvalue { Quit ..#FullHouse} //3A2B
        ElseIf ",1,4" [ firstvalue {  Quit ..#FourKind} //4A1B
    }
    If count=3 {
        //will be AAABC or AABBC, check for the number of "2"s to see which
        Set twos = 0
        Set key2=""
         For   {
            Set key2 = $ORDER(handvalues(key2))
            Quit:key2=""
            Do:handvalues(key2)=2 $INCREMENT(twos)
    
        } 
        If twos = 2 {
            Quit ..#TwoPair //AABBC
        } Else {
            Quit ..#ThreeKind //AAABC
        }
    }
    If count=4 {
        //only 1 permutation AABCD
        Quit ..#Pair 
    }
     If count=5 {
        //only 1 permutation ABCDE
       Quit ..#HighCard //highcard
    }
    Quit "unknown"
}

ClassMethod ParseValue2(line)
{
    // as part 1, get the occurences
    For i=1:1:5 Do $INCREMENT(handvalues($EXTRACT(line,i)))

    Set key = ""
    Set count=0
    For   {
        Set key = $ORDER(handvalues(key))
        Quit:key=""
        Do $INCREMENT(count)
    
    }
    If count=1 Quit ..#FiveKind //AAAAA, this is unchanged even if it's JJJJJ
    If count=2 {
        //more possibilites now AAABB,AAAAB,AAAAJ,AAAJJ,JJJAA
        Set firstvalue = handvalues($ORDER(handvalues("")))
        If ",2,3" [firstvalue { 
            If $DATA(handvalues("J")) Quit ..#FiveKind //AAAJJ | AAJJJ
            Quit ..#FullHouse} //AAABB
        ElseIf ",1,4" [ firstvalue { 
            if $DATA(handvalues("J")) quit ..#FiveKind //AAAAJ | JJJJA
            Quit ..#FourKind} //AAAAB
    }
    If count=3 {
         //more possibilites now AAABC, AABBC, AAABJ,AABBJ,ABJJJ,AABJJ
        Set twos = 0
        Set key2=""
        For   {
            Set key2 = $ORDER(handvalues(key2))
            Quit:key2=""
            Do:handvalues(key2)=2 $INCREMENT(twos)
        } 
        //Process if there are 2 pairs     
        If twos = 2 {
            If $DATA(handvalues("J")){
                If handvalues("J")>=2 {Quit ..#FourKind} //AABJJ | ABJJJ
                Else {Quit ..#FullHouse} //AABBJ
            }
            Quit ..#TwoPair //2pair //AABBC
        } Else {
             If $DATA(handvalues("J")){
                Quit ..#FourKind  //AAABJ
            }
            Quit ..#ThreeKind //AAABC
        }
    }
    If count=4 {
          //one more possibilites now AABCD, AABCJ
        if $GET(handvalues("J"),0){
            quit ..#ThreeKind //AABCJ
        }
        Quit ..#Pair //AABCD
    }
    If count=5 {
        //one more possibity, ABCDE, ABCDJ
        If $GET(handvalues("J"),0){
            Quit ..#Pair //ABCDJ
        }
       Quit ..#HighCard //ABCDE
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
        set rankedcard(cardrank,hand)=bet

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
        Set hand = $TRANSLATE($PIECE(line," ",1),"AKQT98765432J","ZYXWVUTSRQPOJ") //Set these to be ordered, as their values.
        Set bet= $PIECE(line," ",2)
        Set ^hands(hand)="" //store hand and bid
        Set cardrank  =..ParseValue2(hand)
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
