package net.daboross.hex;

import createjs.easeljs.SpriteSheet;
import createjs.easeljs.Ticker;
import createjs.easeljs.Sprite;

import net.daboross.hex.SpaceHandler;
import net.daboross.hex.enemies.BasicEnemy;
import net.daboross.hex.bounding.BoundUtils;

typedef Point = {x:Float, y:Float};

class Populator {

    private static inline var ENEMY_SPAWN = 3 * 1000;

    private var enemies:List<BasicEnemy> = new List();
    private var nextSpawn:Float = 0;
    private var space:SpaceHandler;
    private var sheet:SpriteSheet;

    public function new(space:SpaceHandler, sheet:SpriteSheet) {
        this.space = space;
        this.sheet = sheet;
    }

    public function tick() {
        var time:Float = Ticker.getTime(true);
        if (time > nextSpawn) {
            nextSpawn = time + ENEMY_SPAWN;
            trace("Spawning!");
            var sprite:BasicEnemy = new BasicEnemy(space, sheet, 0);
            var pos:Point = getRandomPosition();
            sprite.x = pos.x;
            sprite.y = pos.y;
            space.spaceContainer.addChild(sprite);
            enemies.add(sprite);
        }
        var dead:List<BasicEnemy> = new List();
        for (enemy in enemies) {
            enemy.tick();
            if (BoundUtils.checkBound(enemy.x, enemy.y, enemy.radius,
                space.character.spaceX, space.character.spaceY, space.character.radius)) {
                dead.add(enemy);
            }
        }
        for (enemy in dead) {
            enemies.remove(enemy);
            space.spaceContainer.removeChild(enemy);
        }
    }

    private function getRandomPosition() : Point {
        var side:Int = Std.random(4);
        var posOnSide:Float = 500 - Math.random() * 1000;
        var x:Float;
        var y:Float;
        switch (Std.random(4)) {
            case 0:
                // North
                x = posOnSide;
                y = -500;
            case 1:
                // East
                x = 500;
                y = posOnSide;
            case 2:
                // South
                x = posOnSide;
                y = 500;
            case 3:
                // West
                x = -500;
                y = posOnSide;
            default:
                throw "Error: Invalid number returned from Std.random()";
        }
        x += space.character.spaceX;
        y += space.character.spaceY;
        return {x:x, y:y};
    }
}
