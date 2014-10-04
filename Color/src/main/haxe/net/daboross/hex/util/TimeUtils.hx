package net.daboross.hex.util;

import createjs.easeljs.Ticker;

class TimeUtils {

    public static inline function getTime() : Int {
        return Std.int(Ticker.getTicks(true) * 1000 / 60);
    }
}
