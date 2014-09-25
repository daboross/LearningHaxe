package net.daboross.hex.enemies;

import createjs.easeljs.Sprite;
import createjs.easeljs.SpriteSheet;

import net.daboross.hex.SpaceHandler;
import net.daboross.hex.util.BoundUtils;

class BasicEnemy extends Sprite {

    var space:SpaceHandler;
    var speed:Float = 5.0;
    public var radius:Int = 32;
    public var shot:Bool = false; // this will be set to true if this enemy has been shot

    public function new(space:SpaceHandler, sheet:SpriteSheet, frame:Dynamic) {
        super(sheet, frame);
        this.space = space;
    }

    public function tick() : Bool {
        if (shot) {
            return false; // we are dead
        }
        var rotationRadians:Float = Math.atan2(space.character.spaceY - this.y, space.character.spaceX - this.x);
        this.rotation = rotationRadians * 180 / Math.PI;
        x += speed * Math.cos(rotationRadians);
        y += speed * Math.sin(rotationRadians);

        var hitCharacter:Bool = BoundUtils.checkBound(x, y, radius, space.character.spaceX,
                                        space.character.spaceY, space.character.radius);
        if (hitCharacter) {
            space.character.score -= 5;
            space.character.updateLevel();
        }
        return !hitCharacter;
    }
}
