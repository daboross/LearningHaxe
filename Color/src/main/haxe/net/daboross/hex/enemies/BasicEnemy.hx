package net.daboross.hex.enemies;

import createjs.easeljs.Sprite;
import createjs.easeljs.SpriteSheet;

import net.daboross.hex.SpaceHandler;
import net.daboross.hex.util.BoundUtils;

class BasicEnemy extends Sprite {

    var space:SpaceHandler;
    var speed:Float = 5.0;
    public var radius:Int = 32;

    public function new(space:SpaceHandler, sheet:SpriteSheet, frame:Dynamic) {
        super(sheet, frame);
        this.space = space;
    }

    public function tick() : Bool {
        var rotationRadians:Float = Math.atan2(space.character.spaceY - this.y, space.character.spaceX - this.x);
        this.rotation = rotationRadians * 180 / Math.PI;
        x += speed * Math.cos(rotationRadians);
        y += speed * Math.sin(rotationRadians);

        return !BoundUtils.checkBound(x, y, radius, space.character.spaceX,
                                        space.character.spaceY, space.character.radius);
    }
}
