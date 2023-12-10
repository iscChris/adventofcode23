Class doc.aoc2023.Day10 Extends doc.aoc2023.Base
{

Parameter InputFile = "input10.txt";

Parameter BottomLeftCorner = "L";

Parameter BottomRightCorner = "J";

Parameter TopLeftCorner = "F";

Parameter TopRightCorner = 7;

Parameter Vertical = "|";

Parameter Horizontal = "-";

Parameter Start = "S";

ClassMethod Run() As %Integer
{
	Kill ^map
 
    Set stream=..GetInput(..#InputFile)
   
    Set ycount=0 
    
	While 'stream.AtEnd {
        Do $INCREMENT(count)
	    Set line=stream.ReadLine()
    
        Do ..ParseLine(line,count)

    }
    Set ^mapheight=count
    Write !,"Map is "_^mapwidth_" x "_^mapheight,!
    Do ..NavigateMap()
 
    
    Quit 1
    Set accumulator = 0
    For j = 1:1:count  {
      Set list = ^sequence(j)
      Set accumulator = accumulator + ..FindNext(list)

    }


     Write !,"returning results: "_accumulator,!
    Quit accumulator
}

ClassMethod Run2() As %Integer
{
     Quit 1
}

ClassMethod ParseLine(line, y) As %Integer
{
    ZWrite line
    Write "Line length is "_$LENGTH(line)
    Set ^mapwidth = $LENGTH(line)
   For x=1:1:$LENGTH(line){
    If $EXTRACT(line,x)="S" Set ^map=x_","_y
    Set:$EXTRACT(line,x)'="." ^map(x,y)=$EXTRACT(line,x)
   }
}

ClassMethod NavigateMap()
{
    s distance =0
    set startx=$P(^map,",",1)
    set starty=$P(^map,",",2)
    set x = startx
    set y = starty
    set direction ="up"
    for  {
        w !,x,",",y," ",direction
      
        q:(distance>0)&&(x=startx)&&(y=starty)
            
               d $INCREMENT(distance)
               Set ^visited(x,y)=1
                If (direction'="down")&&$DATA(^map(x,y-1)){
                    If (^map(x,y)=..#BottomLeftCorner)||(^map(x,y)=..#BottomRightCorner)||(^map(x,y)=..#Vertical)||(^map(x,y)=..#Start){//CheckAbove
                        If (($GET(^map(x,y-1))=..#Vertical)||(^map(x,y-1)=..#TopLeftCorner)||(^map(x,y-1)=..#TopRightCorner)||(^map(x,y-1)=..#Start)){
                         
                         set y=y-1
                         set direction="up"
                         
                         continue
                        }
                    }
                }
                If (direction'="up")&&$DATA(^map(x,y+1)){
                    If (^map(x,y)=..#TopLeftCorner)||(^map(x,y)=..#TopRightCorner)||(^map(x,y)=..#Vertical)||(^map(x,y)=..#Start){//CheckBelow
                        If (($GET(^map(x,y+1))=..#Vertical)||(^map(x,y+1)=..#BottomLeftCorner)||(^map(x,y+1)'=..#BottomLeftCorner)||(^map(x,y+1)=..#Start)){
                            Set y=y+1
                            Set direction="down"
                            Continue
                        }
                    }
                }
                If (direction'="right")&&$DATA(^map(x-1,y)){ 
                    If (^map(x,y)=..#TopRightCorner)||(^map(x,y)=..#BottomRightCorner)||(^map(x,y)=..#Horizontal)||(^map(x,y)=..#Start){//CheckLeft
                        If (($GET(^map(x-1,y))=..#Horizontal)||(^map(x-1,y)=..#BottomLeftCorner)||(^map(x-1,y)=..#TopLeftCorner)||(^map(x-1,y)=..#Start)){
                            Set x=x-1
                         Set direction="left"
                            Continue
                       }
                    }
                }
                If (direction'="left")&&$DATA(^map(x+1,y)){
                    If (^map(x,y)=..#TopLeftCorner)||(^map(x,y)=..#BottomLeftCorner)||(^map(x,y)=..#Horizontal)||(^map(x,y)=..#Start){//CheckRight
                        If (($GET(^map(x+1,y))=..#Horizontal)||(^map(x+1,y)=..#BottomRightCorner)||(^map(x+1,y)=..#TopRightCorner)||(^map(x+1,y)=..#Start)){
                            Set x=x+1
                            Set direction="right"
                               Continue
                        }
                    }
                }
           
            }
  w !,"Distance travelled "_distance
  q distance
}

ClassMethod DrawMap()
{
    s ^spacesceiling=0
    K ^blanks
    For y =1:1:^mapheight {
        Write !
        set hitsomething= 0
        k ^spaces
         For x=1:1:^mapwidth {
            if $GET(^visited(x,y)," ") {
                Write $GET(^map(x,y)," ")
               d $INCREMENT(hitsomething)
            } else {
                w " "
                d $INCREMENT(^spaces(hitsomething))
                set ^blanks(x,y)="1"
            }
            }
            
            for i=1:1:hitsomething-1 {
                set ^spacesceiling=^spacesceiling+$GET(^spaces(i),0)

            }
        }
        w !,"spacesceiling is "_^spacesceiling
}

ClassMethod DrawBlanks()
{
    Set ^spacesceiling=0
    For y =1:1:^mapheight {
      w !
         For x=1:1:^mapwidth {
            If $GET(^blanks(x,y)," ") {
                Write "1"
              
             
               
            } else {
                w " "
            }
            }
            
         
        }
}

ClassMethod FindNext(line) As %Integer
{
    For k = 1:1:$LISTLENGTH(line)-1{
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
    Else {Quit $LISTGET(line,$LISTLENGTH(line))+(..FindNext(difflist))}
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
