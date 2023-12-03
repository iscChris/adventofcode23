Class doc.aoc2023.Day1 Extends doc.aoc2023.Base
{

Parameter InputFile = "input1.txt";

ClassMethod Run() As %Integer
{
    Set stream=..GetInput(..#InputFile)
    Set sum=0
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
        Set linenum=$ZSTRIP(line,"*A") //remove all alpha
        Set linesum = $EXTRACT(linenum,1)_$EXTRACT(linenum,$LENGTH(linenum))
        Set sum=sum+linesum
    }
    Return sum
}

ClassMethod FixString(string) As %String
{
	Kill ^||First
	Set ^||First($FIND(string,"one")-3,1)=""
	Set ^||First($FIND(string,"two")-3,2)=""
	Set ^||First($FIND(string,"three")-5,3)=""
	Set ^||First($FIND(string,"four")-4,4)=""
	Set ^||First($FIND(string,"five")-4,5)=""
	Set ^||First($FIND(string,"six")-3,6)=""
	Set ^||First($FIND(string,"seven")-5,7)=""
	Set ^||First($FIND(string,"eight")-5,8)=""
	Set ^||First($FIND(string,"nine")-4,9)=""

	Kill ^||Last  //Look, I'm not proud of this....
	Set ^||Last($FIND($REVERSE(string),$REVERSE("one"))-3,1)=""
	Set ^||Last($FIND($REVERSE(string),$REVERSE("two"))-3,2)=""
	Set ^||Last($FIND($REVERSE(string),$REVERSE("three"))-5,3)=""
	Set ^||Last($FIND($REVERSE(string),$REVERSE("four"))-4,4)=""
	Set ^||Last($FIND($REVERSE(string),$REVERSE("five"))-4,5)=""
	Set ^||Last($FIND($REVERSE(string),$REVERSE("six"))-3,6)=""
	Set ^||Last($FIND($REVERSE(string),$REVERSE("seven"))-5,7)=""
	Set ^||Last($FIND($REVERSE(string),$REVERSE("eight"))-5,8)=""
	Set ^||Last($FIND($REVERSE(string),$REVERSE("nine"))-4,9)=""
	
	
	Set key =$ORDER(^||First(0))
	If key'=""{
	Set firstnumber = $ORDER(^||First(key,""))
	Write "Replacing first instance "_firstnumber,!
	Set string = $EXTRACT(string,1,key)_firstnumber_$EXTRACT(string,key,*)
	}
	Set key2=$ORDER(^||Last(0))
	If key2'=""{
	Set firstnumber = $ORDER(^||Last(key2,""))
	Write "Replacing second instance "_firstnumber,!
	Set key2=($LENGTH(string))-key2
	Set string = $EXTRACT(string,1,key2)_firstnumber_$EXTRACT(string,key2,*)
	}


	Quit string
}

ClassMethod Run2(verbose = 0) As %Integer
{
    
       Set stream=..GetInput(..#InputFile)
    Set sum=0
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
        Set linenum=$ZSTRIP(..FixString(line),"*A") //remove all alpha
        Set linesum = $EXTRACT(linenum,1)_$EXTRACT(linenum,$LENGTH(linenum))
        Set sum=sum+linesum
        If verbose Write "line="_line," ","linenum="_linenum," ","linesum="_linesum," ","sum="_sum,!
    }
    Return sum
}

}
