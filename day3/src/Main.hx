import haxe.Exception;
import sys.io.File;

class Main 
{
    private static var numberFinderRegexString:String = "\\(([0-9]*),([0-9]*)\\)";
    public static function main():Void 
    {
        var mulFinderRegexString:String = "mul\\([0-9]*,[0-9]*\\)";
        var fileContentsToScan = readFile();
        var splitContents:Array<String> = generateDataSets(fileContentsToScan, mulFinderRegexString);
        var totalPart1:Float = 0;
        for (mulInst in splitContents)
        {
            totalPart1 += performRegexMul(mulInst);
        }
        Sys.println('The total for part 1 is $totalPart1');
        var mulFinderWithDosRegexString:String = "(do\\(\\)(?!_))|(mul\\([0-9]*,[0-9]*\\))|(don't\\(\\))";
        splitContents = generateDataSets(fileContentsToScan, mulFinderWithDosRegexString);
        var totalPart2:Float = loopOverInstructionSets(splitContents);
        Sys.println('The total for part 2 is $totalPart2');
    }

    public static function loopOverInstructionSets(instructionsToParse:Array<String>):Float
    {
        var numberFinderRegex:EReg = new EReg(numberFinderRegexString, "gm");
        var runMul:Bool = true;
        var doCheckString = "do()";
        var dontCheckString = "don't()";
        var total:Float = 0;
        for (instruction in instructionsToParse)
        {
            if(runMul && numberFinderRegex.match(instruction))
            {
                total += performRegexMul(instruction);
            }
            else 
            {
                if (instruction == dontCheckString)
                {
                    runMul = false;
                }
                else if (instruction == doCheckString)
                {
                    runMul = true;
                }
            }
        }
        return total;
    }

    public static function performRegexMul(mulInstruction:String):Float 
    {
        var numberFinderRegex:EReg = new EReg(numberFinderRegexString, "gm");
        numberFinderRegex.match(mulInstruction);
        var leftNumber:Int = Std.parseInt(numberFinderRegex.matched(1));
        var rightNumber:Int = Std.parseInt(numberFinderRegex.matched(2));
        return leftNumber * rightNumber;
    }

    public static function generateDataSets(contentsToScan:String, regexPatternString:String):Array<String> 
    {
        var regexPattern:EReg = new EReg(regexPatternString, "gm");
        var matchedStrings:Array<String> = [];
        var input:String = contentsToScan;
        while(regexPattern.match(input))
        {
            matchedStrings.push(regexPattern.matched(0));
            input = regexPattern.matchedRight();
        }
        return matchedStrings;
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