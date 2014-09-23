package net.daboross.hex.util;

import createjs.easeljs.Ticker;

class TimeUtils {

    public static inline function getTime() {
        return Ticker.getTicks(true) * 1000 / 60;
    }
}
