Class doc.aoc2023.Day3 Extends doc.aoc2023.Base
{

Parameter InputFile = "input3.txt";

ClassMethod Run() As %Integer
{
	Kill ^||schematic
	Kill ^accum
	Set accumcount=0
    Set stream=..GetInput(..#InputFile)
    Set sum=0
    Set lineno =1
    Set linelengthcache=0
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		Set line=$ZSTRIP(line,"*W")
		Set linelengthcache=$LENGTH(line)
		For i = 1:1:$LENGTH(line){
			Set ^||schematic(i,lineno)=$EXTRACT(line,i) //get the X and Y right
		}
		Do $INCREMENT(lineno)
	}
    
    For y = 1:1:(lineno-1) { //Ignore the blank line, sue me
	For x = 1:1:linelengthcache {
		Set accum=0
		If ..ParseNumber(x,y,1,.accum) Set ^accum($INCREMENT(accumcount))=accum
	}     
    }
    
    
    Set key = ""
    For   {
	Set key = $ORDER(^accum(key))
	Quit:key=""
	Set sum = sum+^accum(key)
	    
    }
    ZWrite ^accum
    Write !,"sum is "_sum,!
    Return sum
}

ClassMethod isNumber(string As %String) As %Boolean
{
	Quit +string=string
}

ClassMethod ParseNumber(x As %Integer, y As %Integer, first As %Boolean, ByRef accumul As %String) As %Status
{
	
	If ($DATA(^||schematic(x+1,y))) && (..isNumber(^||schematic(x+1,y))) {
		Set found = ..ParseNumber(x+1,y,0,.accumul)} 
	Else {
		Set accumul=""
		Set found = 0
	}
	
	If ('..isNumber(^||schematic(x,y))) Quit 0 //If I'm not a number, I'm not good

	If first&&$DATA(^||schematic(x-1,y))&&(..isNumber(^||schematic(x-1,y))) Quit 0 //If I'm first and the left position has a number, I'm in the middle
	
	If 'found {
	Set valid = 0 
	If first {  //check column to the left

		If (($GET(^||schematic(x-1,y-1),".")'=".") ||
		     ($GET(^||schematic(x-1,y),".")'=".") || //Don't need to check if left is a number, because we already quit out
	 	      ($GET(^||schematic(x-1,y+1),".")'=".")
		){
			Set found= 1
		}	
	}
		
	If (($GET(^||schematic(x,y-1),".")'=".") ||
		     //($GET(^||schematic(x,y),".")=".") ||
	 	      ($GET(^||schematic(x,y+1),".")'=".") ||
	 	      ($GET(^||schematic(x+1,y-1),".")'=".") ||
		     (($GET(^||schematic(x+1,y),".")'=".")&&$DATA(^||schematic(x+1,y))&&'..isNumber(^||schematic(x+1,y)) )||
	 	      ($GET(^||schematic(x+1,y+1),".")'=".")
		){
		
			Set found= 1
		}	
	}
		Set accumul = ^||schematic(x,y)_accumul

	Quit found
}

ClassMethod Run2() As %Integer
{
	Kill ^||schematic
	Kill ^||accum
	Set accumcount=0
    	Set stream=..GetInput(..#InputFile)
    	Set sum=0,lineno =1,linelengthcache=0
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
		Set line=$ZSTRIP(line,"*W")
		Set linelengthcache=$LENGTH(line)
		For i = 1:1:$LENGTH(line){
			Set ^||schematic(i,lineno)=$EXTRACT(line,i) //get the X and Y right
		}
		Do $INCREMENT(lineno)
	}
    
    For y = 1:1:(lineno-1) { //Ignore the blank line, sue me
	For x = 1:1:linelengthcache {
		Set accum=0
		Set gearratio= ..ParseStar(x,y)
		If gearratio > 0 {Set ^||accumul($INCREMENT(accumcount))= gearratio
		}
	}     
    }
    
    
    Set key = ""
    For   {
	Set key = $ORDER(^||accumul(key))
	Quit:key=""
	Set sum = ^||accumul(key)+sum
	    
    }

    Write !,"sum is "_sum,!
    Return sum
}

ClassMethod ParseStar(x As %Integer, y As %Integer) As %Integer
{
	If ^||schematic(x,y)'="*" Quit 0
	 

	Set neighbourcount=0
	
	//Get sum of occupied digit locations above
	Set topcheck = (..isNumber($GET(^||schematic(x-1,y-1),"."))) +
		      		     (..isNumber($GET(^||schematic(x,y-1),"."))) +
	 	      		     (..isNumber($GET(^||schematic(x+1,y-1),".")))
	 	      
	If (topcheck ){
		If (topcheck=2)&&'(..isNumber($GET(^||schematic(x,y-1),"."))) {
			//if middle is blank, then we have 2 numbers split apart
			Set neighbours($INCREMENT(neighbourcount))=..FetchNumber(x-1,y-1)
			Set neighbours($INCREMENT(neighbourcount))=..FetchNumber(x+1,y-1)
		}Else {
			//scan from left to right until we get a number
			If ..isNumber($GET(^||schematic(x-1,y-1),".")) { Set neighbours($INCREMENT(neighbourcount))=..FetchNumber(x-1,y-1)}
			ElseIf..isNumber($GET(^||schematic(x,y-1),".")) {  Set neighbours($INCREMENT(neighbourcount))=..FetchNumber(x,y-1)}
			ElseIf..isNumber($GET(^||schematic(x+1,y-1),".")) {Set neighbours($INCREMENT(neighbourcount))=..FetchNumber(x+1,y-1)}
		}
      }
	 	      
	//Get sum of occupied digit locations below
	Set bottomcheck = (..isNumber($GET(^||schematic(x-1,y+1),"."))) +
		      			      (..isNumber($GET(^||schematic(x,y+1),"."))) +
	 	                         (..isNumber($GET(^||schematic(x+1,y+1),".")))
	 	      
	If (bottomcheck ){
		If (bottomcheck=2)&&'(..isNumber($GET(^||schematic(x,y+1),"."))) {
			 //if middle is blank, then we have 2 numbers split apart
			Set neighbours($INCREMENT(neighbourcount))=..FetchNumber(x-1,y+1)
			Set neighbours($INCREMENT(neighbourcount))=..FetchNumber(x+1,y+1)
		}Else {
			//scan from left to right until we get a number
			If ..isNumber($GET(^||schematic(x-1,y+1),".")) {Set neighbours($INCREMENT(neighbourcount))=..FetchNumber(x-1,y+1)}
			ElseIf..isNumber($GET(^||schematic(x,y+1),".")) {Set neighbours($INCREMENT(neighbourcount))=..FetchNumber(x,y+1)}
			ElseIf..isNumber($GET(^||schematic(x+1,y+1),".")) {Set neighbours($INCREMENT(neighbourcount))=..FetchNumber(x+1,y+1)}
		}
	 }
 	      
	If ..isNumber($GET(^||schematic(x-1,y),".")){Set neighbours($INCREMENT(neighbourcount))=..FetchNumber(x-1,y)} //Left neighbour
	If ..isNumber($GET(^||schematic(x+1,y),".")){Set neighbours($INCREMENT(neighbourcount))=..FetchNumber(x+1,y)} //Right neighbour
	
	If neighbourcount=2 { 
	 	Quit neighbours(1)*neighbours(2)
	}
	Quit 0 //If anything other than 2 neighbours, then it's just a no-op
}

ClassMethod FetchNumber(x As %Integer, y As %Integer) As %Integer
{
	If $GET(^||schematic(x,y),".")="." Quit "." //If I don't start on a digit, I'm not a number

	For   {	
		Quit:'..isNumber($GET(^||schematic(x-1,y),".")) //Go back until the previous digit is not a number
		Set x=x-1
	}
	Set int ="" //Now I'm at the first digit, append digits until the next char is not a digit
	For {
		Set int = int_$GET(^||schematic(x,y))
		Set x=x+1
		Quit:'..isNumber($GET(^||schematic(x,y),"."))
	}
	Quit int
}

}
