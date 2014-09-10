package net.daboross.hex;
class Util {
    public static inline function repeat(str:String, num:Int):String {
        var build:StringBuf = new StringBuf();
        for (i in 0...num) {
            build.add(str);
        }
        return build.toString();
    }
}
