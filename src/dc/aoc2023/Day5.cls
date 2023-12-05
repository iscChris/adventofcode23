Class doc.aoc2023.Day5 Extends doc.aoc2023.Base
{

Parameter InputFile = "input5.txt";

ClassMethod ParseSeeds(line)
{
    for i = 1:1:$L(line," "){
        set ^seeds($P(line," ",i))=""
    }
}

ClassMethod ParseSeeds2(line)
{
    For i = 1:2:$LENGTH(line," "){
        Set ^seeds($PIECE(line," ",i),$PIECE(line," ",i+1))=""
    }
}

ClassMethod storeNumber(line, mode)
{
    set source = $P(line," ",2)
    set dest = $P(line," ",1)
    set ticks = $P(line," ",3)
    w !,"source: "_source_"  dest: "_dest_"  ticks: "_ticks
   
        set @mode@(source,source+ticks,dest)=""
}

ClassMethod storeNumber2(line, mode)
{
    Set source = $PIECE(line," ",2)
    Set dest = $PIECE(line," ",1)
    Set ticks = $PIECE(line," ",3)
    Write !,"source: "_source_"  dest: "_dest_"  ticks: "_ticks
   
        Set @mode@(dest,(dest+(ticks-1)),source)=""
}

ClassMethod checkMapping(number, mode)
{
    if $DATA(@mode@(number)){
        set mappingkey=number
    }else{
        Set mappingkey = $ORDER(@mode@(number),-1)
    }
    Set limitkey = $ORDER(@mode@(mappingkey,""))
 
    If number<=limitkey {
       
        Set destvalue=$ORDER(@mode@(mappingkey,limitkey,"")) 
        Set offset = number-mappingkey
   
        Set number = destvalue+(offset) //set the value by the offset
 
        } 
       
   Quit number
}

ClassMethod Run() As %Integer
{
	k locations
    Set stream=..GetInput(..#InputFile)
    Set min=0 

    //Setup all reference globals
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
        Set line =$ZSTRIP(line,"=W") //get rid of repeat whitespaces
        if $P(line," ",1)="seeds:" d ..ParseSeeds($ZSTRIP($P(line,":",2),"<>W"))       //Pass in just the values
        If ($PIECE(line," ",1))="seed-to-soil"	{Set mode = "^seed2soil" K @mode}    //Initialise each PPG
        If ($PIECE(line," ",1))="soil-to-fertilizer"	{Set mode = "^soil2fert" Kill @mode}
        If ($PIECE(line," ",1))="fertilizer-to-water" {Set mode = "^fert2water" Kill @mode}
        If ($PIECE(line," ",1))="water-to-light" {Set mode = "^water2light" Kill @mode}
        If ($PIECE(line," ",1))="light-to-temperature" {Set mode = "^light2temp" Kill @mode}
        If ($PIECE(line," ",1))="temperature-to-humidity"	{Set mode = "^temp2humid" Kill @mode}
        If ($PIECE(line," ",1))="humidity-to-location"	{Set mode = "^humid2loc" Kill @mode}
        if $E(line)=+$E(line) d ..storeNumber(line,mode)  //If we're a number then store it
    }

    //Parse out seeds
    set count = 0
    set seedvalue=""
    for  {
    s seedvalue = $ORDER(^seeds(seedvalue))
    do $I(count)
    q:seedvalue=""
    w !,"Seed "_count_" is "_seedvalue 
    set soilvalue = ..checkMapping(seedvalue,"^seed2soil")
    Set fertvalue = ..checkMapping(soilvalue,"^soil2fert")
    Set watervalue = ..checkMapping(fertvalue,"^fert2water")
    Set lightvalue = ..checkMapping(watervalue,"^water2light")
    Set tempvalue = ..checkMapping(lightvalue,"^light2temp")
    Set humidvalue = ..checkMapping(tempvalue,"^temp2humid")
    Set locvalue = ..checkMapping(humidvalue,"^humid2loc")
    set locations(locvalue)=seedvalue
    }
   
    Write !,"returning results: "_$ORDER(locations("")),!
  
    
    Return $O(locations(""))
}

ClassMethod Run2() As %Integer
{
    
    //k ^running
    Set stream=..GetInput(..#InputFile)
    Set min=0 
    K ^seeds
    //Setup all reference globals
	While 'stream.AtEnd {
		Set line=stream.ReadLine()
        Set line =$ZSTRIP(line,"=W") //get rid of repeat whitespaces
        If $PIECE(line," ",1)="seeds:" Do ..ParseSeeds2($ZSTRIP($PIECE(line,":",2),"<>W"))       //Pass in just the values
        If ($PIECE(line," ",1))="seed-to-soil"	{Set mode = "^soil2seed" Kill @mode}    //Initialise each PPG
        If ($PIECE(line," ",1))="soil-to-fertilizer"	{Set mode = "^fert2soil" Kill @mode}
        If ($PIECE(line," ",1))="fertilizer-to-water" {Set mode = "^water2fert" Kill @mode}
        If ($PIECE(line," ",1))="water-to-light" {Set mode = "^light2water" Kill @mode}
        If ($PIECE(line," ",1))="light-to-temperature" {Set mode = "^temp2light" Kill @mode}
        If ($PIECE(line," ",1))="temperature-to-humidity"	{Set mode = "^humid2temp" Kill @mode}
        If ($PIECE(line," ",1))="humidity-to-location"	{Set mode = "^loc2humid" Kill @mode}
        If $EXTRACT(line)=+$EXTRACT(line) Do ..storeNumber2(line,mode)  //If we're a number then store it
    }
    

    //Parse out seeds
    Set startvalue=""
    set count=0
    For {
    d $INCREMENT(count)
    //Set startvalue = $ORDER(^seeds(startvalue))
    //Quit:startvalue=""
    //Set count = 0
    w !,"jobbing "_count
    q:..checkBack(count) 
    
    
    }

    
    quit ^locations
}

ClassMethod checkBack(locvalue) As %Boolean
{
   
    
   //Set ^running(startvalue,"status")="Seed "_startvalue_" is "_count_" of "_$ORDER(^seeds(startvalue,""))
   Set humidvalue = ..checkMapping(locvalue,"^loc2humid")
   Set tempvalue = ..checkMapping(humidvalue,"^humid2temp")
   Set lightvalue = ..checkMapping(tempvalue,"^temp2light")
   Set watervalue = ..checkMapping(lightvalue,"^light2water")
   Set fertvalue = ..checkMapping(watervalue,"^water2fert")
    Set soilvalue = ..checkMapping(fertvalue,"^fert2soil")
    Set seedvalue = ..checkMapping(soilvalue,"^soil2seed")
   
    w !,"seed value is "_seedvalue
    set seedbucket = $O(^seeds(seedvalue),-1)
    if seedbucket=""{
    set rangelow=0
    set rangehigh=0
    } else {
        set rangelow = seedbucket
        set rangehigh = seedbucket+($O(^seeds(seedbucket,"")))
    }

    if ((seedvalue>=rangelow)&&(seedvalue<=rangehigh)) w !,"This was an ORIGINAL"

    Set:((seedvalue>=rangelow)&&(seedvalue<=rangehigh)) ^locations=locvalue
    quit (seedvalue>=rangelow)&&(seedvalue<=rangehigh)
}

}
