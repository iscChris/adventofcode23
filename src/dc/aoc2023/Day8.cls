Class doc.aoc2023.Day8 Extends doc.aoc2023.Base
{

Parameter InputFile = "input8.txt";

ClassMethod Run() As %Integer
{
	Kill ^map
    
    Set stream=..GetInput(..#InputFile)
   
    Set count=0 
    Set instructions=stream.ReadLine() //store the path here
    set ^maps = instructions
    Set null=stream.ReadLine() //There's a blank line, it's hacky but just skip over it
    //Setup all reference globals
	While 'stream.AtEnd {
    
	    Set line=stream.ReadLine()
        set node = $P(line," ",1) //first string is node name
        //cheating ahed, the keys are fixed width, so will just $E them out
        //this would need to be changed if the keys were variable length
        //or just a different length.
        set left = $E(line,8,10)
        set right = $E(line,13,15)
        w !,"Node "_node_"  LEFT: "_left_"  RIGHT: "_right
        set ^maps(node,"L")=left
        set ^maps(node,"R")=right

    }

    s rank = ""
    s count =0
    s accumulator = 0
    set currentnode = "AAA"
    for   {
      
      
      s realcount = (count#($L(^maps)))+1
      s instruction = $E(^maps,realcount)
      s currentnode =^maps(currentnode,instruction)
      s count=$I(count)
      q:currentnode="ZZZ"
      w !, count,?10,currentnode,?20,instruction,?23,realcount
      
    }

     Write !,"returning results: "_count,!
    Quit count
}

ClassMethod Run2() As %Integer
{
    Kill ^ghostmaps
    kill ^ghostindex
    Kill ^foundnodes
    
    Set stream=..GetInput(..#InputFile)
   
    Set count=0 
    Set instructions=stream.ReadLine() //store the path here
    set ^ghostmaps = instructions
    Set null=stream.ReadLine() //There's a blank line, it's hacky but just skip over it
    //Setup all reference globals
	While 'stream.AtEnd {
    
	    Set line=stream.ReadLine()
        set node = $P(line," ",1) //first string is node name
        if $E(node,3)="A" set ^ghostindex(node)="" //Get all starting points
        //cheating ahed, the keys are fixed width, so will just $E them out
        //this would need to be changed if the keys were variable length
        //or just a different length.
        set left = $E(line,8,10)
        set right = $E(line,13,15)
        w !,"Node "_node_"  LEFT: "_left_"  RIGHT: "_right
        set ^maps(node,"L")=left
        set ^maps(node,"R")=right

    }

    s rank = ""
    s count =0
    s accumulator = 0

    set aKey = ""
    set aCount = 0
    for   {
        set aKey=$O(^ghostindex(aKey))
        q:aKey=""
        d $INCREMENT(aCount)

    }
    w !,"There are "_aCount_" nodes that start with A (or Z)"
    
    set nodekey=""
    for   {
        set count = 0
    set nodekey=$O(^ghostindex(nodekey))
    quit:nodekey=""
    w !,"nodekey "_nodekey
    set startnode=nodekey
    set currentnode=nodekey
    for   {
    
      s realcount = (count#($L(^maps)))+1
      s instruction = $E(^maps,realcount)
      s currentnode =^maps(currentnode,instruction)
      s count=$I(count)
      if $E(currentnode,3)="Z" {
      
        s ^foundnodes(startnode)=count
        }
        q:$DATA(^foundnodes(startnode))
      
    }
    }
    W !
    zw ^foundnodes
    
    set foundkey=$O(^foundnodes(""))
    set gcd = ^foundnodes(foundkey)
    
    for  {
        set foundkey=$O(^foundnodes(foundkey))
        q:foundkey=""
        set oldgcd=gcd
        set gcd=..GreatestCommonDivisor(gcd,^foundnodes(foundkey))
    }
    w !,"GCD is "_gcd
    //compare smallest and biggest, and we should be ok?
    set largekey=$O(^foundnodes("")) //prime the first one
    set largenumber=^foundnodes(largekey)
    set lcm = largenumber
    for  {
    set largekey=$O(^foundnodes(largekey))
    quit:largekey=""
    set largestnumber = ^foundnodes(largekey)
    w !,"Comparing "_lcm_" and "_largestnumber
    set lcm = (lcm*largestnumber)/..GreatestCommonDivisor(lcm,largestnumber)
    }
    w !,"LCM is "_lcm

     Write !,"returning results: "_count,!
    Quit count
}

ClassMethod GreatestCommonDivisor(a, b) As %Integer
{
    
    for    {
        if a>b {set a = a-b}
        else {set b = b-a}
        quit:a=b
    }
    quit a
}

}
