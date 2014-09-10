package net.daboross.hex;

import haxe.io.Eof;
import net.daboross.hex.Util;
import Sys;
import haxe.io.Input;

class Hex {
    private static var EAST_AND_WEST = "│";
    private static var NORTH_AND_SOUTH = "─";
    private static var NORTH_EAST = "┌";
    private static var NORTH_WEST = "┐";
    private static var SOUTH_EAST = "└";
    private static var SOUTH_WEST = "┘";
    private static var CENTER = " ";


    public static function main() {
        new Hex(Sys.stdin()).start();
    }

    private var input:Input;

    public function new(input:Input) {
        this.input = input;
    }

    public function start() {
        Sys.println("Hello!");
        while (true) {
            var str = "4";
            try {
                str = input.readLine();
            } catch (e:Eof) {
                break;
            }
            handleInput(str);
        }
        Sys.println("Goodbye!");
    }

    public function handleInput(str:String) {
        var number:Null<Int> = Std.parseInt(str);
        if (number == null) {
            Sys.println("Expected number, found '" + str + "'");
            return;
        }
        if (number < 2) {
            Sys.println("Expected number < 2, found '" + number + "''");
            return;
        }

        number -= 2;
        var constructedNorthAndSouth = Util.repeat(NORTH_AND_SOUTH, number * 2);
        var constructedCenter = EAST_AND_WEST + Util.repeat(CENTER, number * 2) + EAST_AND_WEST;

        Sys.println(NORTH_EAST + constructedNorthAndSouth + NORTH_WEST);
        for (i in 0...number) {
            Sys.println(constructedCenter);
        }
        Sys.println(SOUTH_EAST + constructedNorthAndSouth + SOUTH_WEST);
    }
}
