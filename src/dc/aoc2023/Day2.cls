Class doc.aoc2023.Day2 Extends doc.aoc2023.Base
{

Parameter InputFile = "input2.txt";

Parameter RedLimit = 12;

Parameter GreenLimit = 13;

Parameter BlueLimit = 14;

ClassMethod Run() As %Integer
{
	Kill ^||valid
    Set stream=..GetInput(..#InputFile)
    Set sum=0
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
       	Set gameno = +$PIECE(line," ",2)
       	Set valid=1
       	Set trimmedstring = $ZSTRIP($PIECE(line,":",2),"*W") //Get interesting part of string, and remove all whitespace
       	//w !,trimmedstring
       	Write !,gameno
       	For set = 1:1:$LENGTH(trimmedstring,";"){
       		Set curset = $PIECE(trimmedstring,";",set)
       		For group = 1:1:$LENGTH(curset,","){
	       		Set groupstring = $PIECE(curset,",",group)
	       		Set value = +groupstring
	       		
	       		Set:((groupstring["red")&&(groupstring>..#RedLimit)) valid=0
	       		Set:((groupstring["green")&&(groupstring>..#GreenLimit)) valid=0
	       		Set:((groupstring["blue")&&(groupstring>..#BlueLimit)) valid=0
       		}
       	}
       	
       	Set:valid ^||valid(gameno)=""
       	Write:valid !,gameno_"is valid"
       
        
    }
    Set key=""
    For	 {
	    Set key=$ORDER(^||valid(key))
	    Quit:key=""
	    Set sum = sum+key
    }
    Write !,"returning results",!
    Return sum
}

ClassMethod Run2() As %Integer
{
    Kill ^||power
    Set stream=..GetInput(..#InputFile)
    Set sum=0
    While 'stream.AtEnd {
		Set line=stream.ReadLine()
       	Set gameno = +$PIECE(line," ",2)
       	Set valid=1
       	Set trimmedstring = $ZSTRIP($PIECE(line,":",2),"*W") //Get interesting part of string, and remove all whitespace 
       	Kill ^||sets
       	For set = 1:1:$LENGTH(trimmedstring,";"){
       		Set curset = $PIECE(trimmedstring,";",set)
       		For group = 1:1:$LENGTH(curset,","){
	       		Set groupstring = $PIECE(curset,",",group)
	       		Set value = +groupstring
	       		Set ^||sets($PIECE(groupstring,value,2),value)= "" // I love Globals!
       		}
       	}
       	Set hiRed=$ORDER(^||sets("red",""),-1), hiGreen=$ORDER(^||sets("green",""),-1), hiBlue=$ORDER(^||sets("blue",""),-1)
       	Set ^||power(gameno)=(hiRed*hiGreen)*hiBlue    
    }
    Set key=""
    For	 {
	    Set key=$ORDER(^||power(key))
	    Quit:key=""
	    Set sum = sum+^||power(key)
    }
    Return sum
}

}
