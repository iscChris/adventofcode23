Class doc.aoc2023.Base
{

Parameter Folder = "/irisdev/app/data/";

ClassMethod GetInput(fn) As %Stream.FileCharacter
{
   
    Set fn=..#Folder_fn
    Set stream = ##Class(%Stream.FileCharacter).%New()
    Set sc=stream.LinkToFile(fn)
    Return stream
}

}
