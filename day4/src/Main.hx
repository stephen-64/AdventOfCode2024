import haxe.Exception;
import sys.io.File;

class Main 
{
    public static function main():Void 
    {
        
    }

    private static function readFile():String
    {
        var userInput:Array<String> = Sys.args();
        if (userInput.length != 1)
        {
            Sys.println("You didn't include the input files");
            throw new Exception("You broke it");
        }

        var inputFileName:String = userInput[0];
        return File.getContent(inputFileName);
    }
}