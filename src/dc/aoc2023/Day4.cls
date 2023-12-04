Class doc.aoc2023.Day4 Extends doc.aoc2023.Base
{

Parameter InputFile = "input4.txt";

ClassMethod Run() As %Integer
{
	Kill ^||valid
    Set stream=..GetInput(..#InputFile)
    Set sum=0
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
        Set line =$ZSTRIP(line,"=W") //get rid of repeat whitespaces
       	Set gameno = +$PIECE(line," ",2)
       	Set valid=1
       	Set trimmedstring = $PIECE(line,":",2) //Get interesting part of string
       	//w !,trimmedstring
       	//Write !,gameno
        Set winners = ""
        Set playnos= ""
        
       	For set = 2:1:11{  //I'm going lazy with it, it's a fixed format
       		Set winners = winners_$LISTBUILD(+$PIECE(trimmedstring," ",set))

       	}
        For set = 13:1:37{  //I'm going lazy with it, it's a fixed format
       	    Set playnos = playnos_$LISTBUILD(+$PIECE(trimmedstring," ",set))
        }

        Set matches = 0
        Write !,"gameno: "_gameno_"   Matching numbers are",!
        For i = 1:1:$LENGTH(winners){
            
            If $LISTFIND(playnos,$LISTGET(winners,i)) {Do $INCREMENT(matches)
            Write $LISTGET(winners,i),!
            }
        }
       	
       
      
        ZWrite winners
        ZWrite playnos
        If +matches {
        Set games(gameno)=2**(matches-1)
         Write "Points:"_(2**(matches-1)),!
        } Else 
        {
            Write "Points: 0",!
            Set games(gameno)=0
           
        }
    }
    Set key=""
    For	 {
	    Set key=$ORDER(games(key))
	    Quit:key=""
	    Set sum = sum+games(key)
    }
    Write !,"returning results",!

    Return sum
}

ClassMethod Run2() As %Integer
{
 
    Kill games
   
    kill cards
    Set stream=..GetInput(..#InputFile)
    Set sum=0
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
        Set line =$ZSTRIP(line,"=W") //get rid of repeat whitespaces
       	Set gameno = +$PIECE(line," ",2)
        set cards(gameno)=1
       	Set valid=1
       	Set trimmedstring = $PIECE(line,":",2) //Get interesting part of string
       	//w !,trimmedstring
       	//Write !,gameno
        Set winners = ""
        Set playnos= ""
        
       	For set = 2:1:11{  //I'm going lazy with it, it's a fixed format
       		Set winners = winners_$LISTBUILD(+$PIECE(trimmedstring," ",set))

       	}
        For set = 13:1:37{  //I'm going lazy with it, it's a fixed format
       	    Set playnos = playnos_$LISTBUILD(+$PIECE(trimmedstring," ",set))
        }

        Set matches = 0
        Write !,"gameno: "_gameno_"   Matching numbers are",!
        For i = 1:1:$LENGTH(winners){
            
            If $LISTFIND(playnos,$LISTGET(winners,i)) {Do $INCREMENT(matches)
            Write $LISTGET(winners,i),!
            }
        }
       	
    
        Set games(gameno)=matches
       
    }
    Write !,"Spooling"
    Set key=""
   
    
    
    For	 {
	    Set key=$ORDER(cards(key))
        w !,"Key is "_key
     
        Quit:key=""
        
        w !,"Cards value "_cards(key)
        Write !,"Wins value "_games(key)
        
        Set offset = games(key)
        w !,"offset value: "_(offset+key)
        //For i=1:1:wins(key){
        For i = (key+1):1:(offset+key){
            
            w !,?3,i," Adding freebie"
             w "Before "_cards(i)
             Do $INCREMENT(cards(i),cards(key)) //ugh, probably something better for this
             w "  After "_cards(i)
        }
   
    }
    Write !,"returning results",!
    Set key=""
    For	 {
	    Set key=$ORDER(cards(key))
	    Quit:key=""
	    Set sum = sum+cards(key)
    }
   
    Return sum
}

}
