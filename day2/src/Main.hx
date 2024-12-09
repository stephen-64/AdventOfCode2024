import haxe.Exception;
import sys.io.File;

typedef NuclearValuesWithSafety = {numberList:List<Int>, safe:Bool, skipSafe:Bool};

private enum NumberState 
{
    negative;
    zero;
    positive;
    start;
}

class Main 
{
    public static function main():Void 
    {
        var nuclearValues:Array<NuclearValuesWithSafety> = new Array<NuclearValuesWithSafety>();
        var userFile:String = readFile();
        var rowByRowFile:Array<String> = userFile.split('\n');

        for (row in rowByRowFile)
        {   
            if (row != "")
            {
                var numbers = row.split(' ');
                var numberList:List<Int> = new List<Int>();
                var safe:Bool = true;
                var skipSafe:Bool = true;
                var singleSkip:Bool = true;
                var currentNumberState:NumberState = NumberState.start;
                for (number in 0...numbers.length)
                {
                    var currentNumber:Int = Std.parseInt(numbers[number]);
                    numberList.add(currentNumber);
                    if (number < numbers.length -1)
                    {
                        var difference:Int = Std.parseInt(numbers[number]) - Std.parseInt(numbers[number + 1]);
                        var absDistance:Float = Math.abs(difference);
                        if (absDistance > 3)
                        {
                            safe = false;
                            if (singleSkip)
                            {

                            }
                        }
                        var numberState:NumberState = isNegative(difference);
                        if (currentNumberState == NumberState.start)
                        {
                            currentNumberState = numberState;
                        }
                        if (currentNumberState != numberState)
                        {
                            safe = false;
                            if (singleSkip)
                            {

                            }
                        }
                    }
                }
                nuclearValues.push({numberList: numberList, safe: safe, skipSafe: skipSafe});
            }
        }

        var safeCount:Int = 0;
        var skipSafeCount:Int = 0;
        for (entry in nuclearValues)
        {
            if (entry.safe)
            {
                safeCount += 1;
            }
            if (entry.skipSafe)
            {
                skipSafeCount += 1;
            }
        }

        Sys.println('The number of safe entries is $safeCount');
        Sys.println('The number of safe entries with a skip is $skipSafeCount');
    }

    private static function isNegative(numberToCheck:Int):NumberState
    {
        var numberState:Int = 1 + (numberToCheck >> 31) - (-numberToCheck >> 31);
        switch (numberState)
        {
            case 0:
                return NumberState.negative;
            case 2:
                return NumberState.positive;
            default:
                return NumberState.zero;
        }
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