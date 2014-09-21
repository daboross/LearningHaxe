package net.daboross.hex.util;

class BoundUtils {

    public static function checkBound(firstX:Float, firstY:Float, firstRadius:Float,
            secondX:Float, secondY:Float, secondRadius:Float) : Bool {
        var maxDistance:Float = firstRadius + secondRadius;
        var distance:Float = distance(firstX, firstY, secondX, secondY);
        return distance < maxDistance;
    }

    public static inline function distance(x1:Float, y1:Float, x2:Float, y2:Float) {
        var distanceX:Float = x1 - x2;
        var distanceY:Float = y1 - y2;
        return Math.sqrt(distanceX * distanceX + distanceY * distanceY);
    }
}
