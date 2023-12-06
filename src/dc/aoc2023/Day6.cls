Class doc.aoc2023.Day6 Extends doc.aoc2023.Base
{

Parameter InputFile = "input6.txt";

ClassMethod ParseValue(line, mode, part As %Integer = 1)
{
    if part=1{
    For i = 1:1:$LENGTH($P(line,":",2)," "){//Skip first, it will be blank
        Set ^races(mode,i)=+$PIECE(line," ",i)
    }
    } else {
        set ^races(mode,1)=+$PIECE(line,":",2)
    }
}

// The difference between pt 1 and 2 is so slight, this will just do double duty

ClassMethod Run(part As %Integer = 1) As %Integer
{
	Kill ^races
    Kill ^raceresults
    Set stream=..GetInput(..#InputFile)
    Set count=0 

    //Setup all reference globals
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
        set stripcond = "=W"
        set:part=2 stripcond="*W"
        Set line =$ZSTRIP(line,stripcond) //get rid of repeat whitespaces
        if $EXTRACT(line,1,4)="Time" Do ..ParseValue($ZSTRIP(line,"<>W"),"time",part)
        if $EXTRACT(line,1,4)="Dist" Do ..ParseValue($ZSTRIP(line,"<>W"),"dist",part)
    }

    set raceno=""
    for   {
        set raceno=$ORDER(^races("time",raceno))
        q:raceno=""
        w !,"Simulating race "_raceno
        set targetdist = ^races("dist",raceno)
        Set racetime = ^races("time",raceno)
        set wins = 0
        for i=1:1:racetime {
            if ((i*1)*(racetime-i)>=targetdist) { 
                d $INCREMENT(wins)
            }
        }
        w !,"Wins counted "_wins,!
        set ^raceresults(raceno)=wins
    }

    //Parse out seeds
    Set count = 0
    Set seedvalue=""
    Set racekey = "" 
    Set racekey=$ORDER(^raceresults(racekey)) //Prime the first run
    Set count = ^raceresults(racekey)
        For   {
            Set racekey=$ORDER(^raceresults(racekey))
            Quit:racekey=""
            Set count=count*^raceresults(racekey) 
        }
     Write !,"returning results: "_count,!
    Quit count
}

}
