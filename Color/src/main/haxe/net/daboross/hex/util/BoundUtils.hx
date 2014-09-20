package net.daboross.hex.util;

class BoundUtils {

    public static function checkBound(firstX:Float, firstY:Float, firstRadius:Float,
            secondX:Float, secondY:Float, secondRadius:Float) : Bool {
        var maxDistance:Float = firstRadius + secondRadius;
        var distanceX:Float = firstX - secondX;
        var distanceY:Float = firstY - secondY;
        var distance:Float = Math.sqrt(distanceX * distanceX + distanceY * distanceY);
        return distance < maxDistance;
    }
}
