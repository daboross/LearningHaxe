package net.daboross.hex;

import createjs.easeljs.SpriteSheet;
import createjs.easeljs.Ticker;
import createjs.easeljs.Sprite;
import createjs.easeljs.Point;

import net.daboross.hex.SpaceHandler;
import net.daboross.hex.enemies.BasicEnemy;


class EnemyHandler {

    private static var DISTANCE_FROM_CHARACTER = 500;

    private var enemies:List<BasicEnemy> = new List();
    private var nextSpawn:Float = 0;
    private var space:SpaceHandler;
    private var sheet:SpriteSheet;

    public function new(space:SpaceHandler, sheet:SpriteSheet) {
        this.space = space;
        this.sheet = sheet;
    }

    /**
     * Gets time between enemey spawns, given the current level.
     */
    private inline function getEnemySpawnTime() {
        return 3 * 1000 + 0.2 * space.character.level;
    }

    private function getNextEnemy() {
        if (space.character.level < 3) {
            js.Browser.window.console.log(sheet);
            return new BasicEnemy(space, sheet, 0);
        } else if (space.character.level < 5) {
            if (Math.random() > 0.7) {
                return new BasicEnemy(space, sheet, 0);
            } else {
                // TODO: Future enemies
                return new BasicEnemy(space, sheet, 1);
            }
        };
        // TODO: Future level enemies
        return new BasicEnemy(space, sheet, 2);
    }

    public function tick() {
        var time:Float = Ticker.getTime(true);
        if (time > nextSpawn) {
            nextSpawn = time + getEnemySpawnTime();
            trace("Spawning");
            var sprite:BasicEnemy = getNextEnemy();
            var pos:Point = getRandomPosition();
            sprite.x = pos.x;
            sprite.y = pos.y;
            space.spaceContainer.addChild(sprite);
            enemies.add(sprite);
        }
        var dead:List<BasicEnemy> = new List();
        for (enemy in enemies) {
            var alive:Bool = enemy.tick();
            if (!alive) {
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
        var posOnSide:Float = DISTANCE_FROM_CHARACTER - Math.random() * DISTANCE_FROM_CHARACTER * 2;
        var x:Float;
        var y:Float;
        switch (Std.random(4)) {
            case 0:
                // North
                x = posOnSide;
                y = -DISTANCE_FROM_CHARACTER;
            case 1:
                // East
                x = DISTANCE_FROM_CHARACTER;
                y = posOnSide;
            case 2:
                // South
                x = posOnSide;
                y = DISTANCE_FROM_CHARACTER;
            case 3:
                // West
                x = -DISTANCE_FROM_CHARACTER;
                y = posOnSide;
            default:
                throw "Error: Invalid number returned from Std.random()";
        }
        x += space.character.spaceX;
        y += space.character.spaceY;
        return new Point(x, y);
    }
}
