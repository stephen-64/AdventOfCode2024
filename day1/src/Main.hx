import sys.io.File;

using StringTools;

typedef UserListPairs = {leftList:Array<Int>, rightList:Array<Int>};


class Main 
{

    public static function main():Void
    {
        var userInput:Array<String> = Sys.args();
        if (userInput.length != 1)
        {
            Sys.println("You didn't include the input files");
            return;
        }

        var inputFileName:String = userInput[0];

        var userFile:String = File.getContent(inputFileName);

        var listPair:UserListPairs = {leftList: new Array<Int>(), rightList: new Array<Int>()};

        for (line in userFile.split("\n"))
        {
            var useLeft:Bool = true; 
            for(number in line.split(" "))
            {
                if (number.length > 0)
                {
                    if(useLeft)
                    {
                        listPair.leftList.push(Std.parseInt(number));
                        useLeft = false;
                    }
                    else 
                    {
                        listPair.rightList.push(Std.parseInt(number));
                    }
                }
            }
        }

        listPair.leftList.sort(Main.sorting);
        listPair.rightList.sort(Main.sorting);

        if (listPair.leftList.length != listPair.rightList.length)
        {
            Sys.println("Something has gone horribly wrong and the input is not valid");
            return;
        }

        var total:Float = 0;

        for (listItem in 0...listPair.leftList.length)
        {
            var max:Float = Math.max(listPair.leftList[listItem], listPair.rightList[listItem]);
            var min:Float = Math.min(listPair.leftList[listItem], listPair.rightList[listItem]);
            total += max - min;
        }

        Sys.println('The solution for Part 1 was: $total');

        total = 0;

        for (leftListItem in listPair.leftList)
        {
            var mult:Int = 0;
            for (rightListItem in listPair.rightList)
            {
                if (leftListItem == rightListItem)
                {
                    mult += 1;
                }
            }
            total += leftListItem * mult;
        }

        Sys.println('The solution for Part 2 was: $total');

        return;
    }

    public static function sorting(a:Int, b:Int):Int
    {
        return a - b;
    }
}