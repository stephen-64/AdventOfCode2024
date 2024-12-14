import haxe.Exception;
import sys.io.File;

class Main 
{

    private static final wordToFind:Array<String> = ['X', 'M', 'A', 'S'];
    private static final msSearchLetters:Array<String> = ['M', 'S'];
    public static function main():Void 
    {
        var crosswordContents:String = readFile();
        var splitOnEndLine:Array<String> = crosswordContents.split("\n");
        var crossWordInArray:Array<Array<String>> = prepareCrossWordArray(splitOnEndLine);
        //Sys.println(crossWordInArray);
        parseForMagicWordCount(crossWordInArray);
    }

    private static function parseForMagicWordCount(crossWordInArray:Array<Array<String>>):Int
    {
        var count:Int = 0;
        var count2:Int = 0;
        var maxY:Int = crossWordInArray.length;
        var maxX:Int = 0;
        if (maxY > 0)
        {
            maxX = crossWordInArray[0].length;
        }
        for (y in 0...maxY)
        {
            for (x in 0...maxX)
            {
                var firstChar = wordToFind[0];
                if (crossWordInArray[y][x] == firstChar)
                {
                    count += checkNearestNeighbors(crossWordInArray, x, y, maxX, maxY, wordToFind, 1);
                }
                if (crossWordInArray[y][x] == "A")
                {
                    count2 += checkForXMASs(crossWordInArray, x, y, maxX, maxY);
                }
            }
        }
        Sys.println('The soltuion for part 1 is $count');
        Sys.println('The soltuion for part 2 is $count2');
        return count;
    }

    private static function checkNearestNeighbors(crossWordInArray:Array<Array<String>>, 
        currentX:Int, 
        currentY:Int, 
        maxX:Int, 
        maxY:Int, 
        wordToCheck:Array<String>,
        currentLetter:Int):Int
    {
        var fullMatches:Int = 0;
        var maxLength:Int = wordToCheck.length;
        for (y in currentY - 1 ... currentY + 2)
        {
            for (x in currentX - 1 ... currentX + 2)
            {
                if (x >= 0 && y >= 0 && x < maxX && y < maxY)
                {
                    var letterToCheck:Int = currentLetter;
                    if (letterToCheck < maxLength)
                    {
                        if (crossWordInArray[y][x] == wordToCheck[letterToCheck])
                        {
                            letterToCheck++;
                            var yDiff:Int = y - currentY;
                            var xDiff:Int = x - currentX;
                            var nextY:Int = y;
                            var nextX:Int = x;
                            while(letterToCheck < maxLength)
                            {
                                nextY = nextY + yDiff;
                                nextX = nextX + xDiff;
                                if (nextX >= 0 && nextY >= 0 && nextX < maxX && nextY < maxY)
                                {
                                    if (crossWordInArray[nextY][nextX] != wordToCheck[letterToCheck])
                                    {
                                        break;
                                    }
                                }
                                else
                                {
                                    break;
                                }
                                letterToCheck++;
                            }
                        }
                    }
                    if (letterToCheck == maxLength)
                    {
                        fullMatches += 1;
                    }
                }
            }
        }
        return fullMatches;
    }

    private static function checkForXMASs(crossWordInArray:Array<Array<String>>, 
        currentX:Int, 
        currentY:Int, 
        maxX:Int, 
        maxY:Int):Int
    {
        if (currentY - 1 >=0 && currentY + 1 < maxY && currentX - 1 >= 0 && currentX + 1 < maxX)
        {
            var aSurrounding:Array<String> = [];
            aSurrounding.push(crossWordInArray[currentY-1][currentX-1]);
            aSurrounding.push(crossWordInArray[currentY-1][currentX+1]);
            aSurrounding.push(crossWordInArray[currentY+1][currentX-1]);
            aSurrounding.push(crossWordInArray[currentY+1][currentX+1]);
            var mCount = 0;
            var sCount = 0;
            /**
             * Checking Diagonals to avoid cases where we would not have a MAS
             * 
             * SAMPLE:
             * 
             * S . M
             * . A .
             * M . S
             * 
             */
            if (aSurrounding[0] == aSurrounding[3] && aSurrounding[1] == aSurrounding[2])
            {
                return 0;
            }
            for (letter in aSurrounding)
            {
                if (letter == "M")
                {
                    mCount++;
                }
                else if (letter == "S")
                {
                    sCount++;
                }
            }
            if (mCount == 2 && sCount == 2)
            {
                return 1;
            }
        }
        
        return 0;
    }


    private static function prepareCrossWordArray(splitOnEndLine:Array<String>):Array<Array<String>> 
    {
        var crossWordInArray:Array<Array<String>> = new Array<Array<String>>();
        for (line in splitOnEndLine)
        {
            var charArray:Array<String> = [];
            for (char in line.split(""))
            {
                charArray.push(char);
            }
            crossWordInArray.push(charArray);
        }
        return crossWordInArray;
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