Class doc.aoc2023.Day9 Extends doc.aoc2023.Base
{

Parameter InputFile = "input9.txt";

ClassMethod Run() As %Integer
{
	Kill ^sequence
    
    Set stream=..GetInput(..#InputFile)
   
    Set count=0 
    
	While 'stream.AtEnd {
        d $I(count)
	    Set line=stream.ReadLine()
        do ..ParseLine(line,count)

    }

    Set accumulator = 0
    For j = 1:1:count  {
      set list = ^sequence(j)
      set accumulator = accumulator + ..FindNext(list)

    }


     Write !,"returning results: "_accumulator,!
    Quit accumulator
}

ClassMethod Run2() As %Integer
{
    Kill ^sequence
    
    Set stream=..GetInput(..#InputFile)
   
    Set count=0 
    
	While 'stream.AtEnd {
        d $I(count)
	    Set line=stream.ReadLine()
        do ..ParseLine(line,count)

    }

    Set accumulator = 0
    For j = 1:1:count  {
      set list = ^sequence(j)
      set accumulator = accumulator + ..FindPrev(list)

    }


     Write !,"returning results: "_accumulator,!
    Quit accumulator
}

ClassMethod ParseLine(line, lineno) As %Integer
{
    
    set ^sequence(lineno) = $LISTFROMSTRING(line," ")
}

ClassMethod FindNext(line) As %Integer
{
    for k = 1:1:$LL(line)-1{
        set diffs(k)=($LG(line,k+1)-$LG(line,k))
    }
    
    set diffkey = ""
    set diffcount=0
    set difflist = ""
    for  {
        s diffkey=$O(diffs(diffkey))
        q:diffkey=""
        d $I(diffcount)
        set difflist=difflist_$LB(diffs(diffkey))
    }
  
    if diffcount=1 {quit diffs(1)} 
    else {quit $LG(line,$LL(line))+(..FindNext(difflist))}
}

ClassMethod FindPrev(line) As %Integer
{
    For k = 1:1:($LISTLENGTH(line)-1){ 
        Set diffs(k)=($LISTGET(line,k+1)-$LISTGET(line,k)) 
    }
    
    Set diffkey = ""
    Set diffcount=0
    Set difflist = ""
    For  {
        Set diffkey=$ORDER(diffs(diffkey))
        Quit:diffkey=""
        Do $INCREMENT(diffcount)
        Set difflist=difflist_$LISTBUILD(diffs(diffkey))
    }
    If diffcount=1 {Quit diffs(1)} 
    Else {Quit $LISTGET(line,1)-(..FindPrev(difflist))}
}

}
