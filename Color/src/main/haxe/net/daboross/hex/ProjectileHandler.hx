package net.daboross.hex;

import createjs.easeljs.Sprite;
import createjs.easeljs.SpriteSheet;

import net.daboross.hex.SpaceHandler;
import net.daboross.hex.util.BoundUtils;
import net.daboross.hex.util.Position;

typedef Projectile = {start:Position, sprite:Sprite, life:Int}

class ProjectileHandler {

    private var charBullets:List<Projectile> = new List();
    private var space:SpaceHandler;
    private var sheet:SpriteSheet;

    public function new(space:SpaceHandler, sheet:SpriteSheet) {
        this.space = space;
        this.sheet = sheet;
    }

    public function spawnCharBullet(start:Position) {
        var sprite:Sprite = new Sprite(sheet, 0);
        sprite.x = start.x;
        sprite.y = start.y;
        sprite.rotation = Math.atan2(start.yVelocity, start.xVelocity) * 180 / Math.PI;

        space.spaceContainer.addChild(sprite);

        var bullet:Projectile = {start:start, sprite:sprite, life:1000};
        charBullets.add(bullet);
    }

    public function spawnEnemyBullet(p:Position) {
        // TODO: Implement
    }

    public function tick() {
        var dead:List<Projectile> = new List();
        for (charBullet in charBullets) {
            charBullet.sprite.x += charBullet.start.xVelocity;
            charBullet.sprite.y += charBullet.start.yVelocity;
            var collisionX:Int = Std.int(charBullet.sprite.x);
            var collisionY:Int = Std.int(charBullet.sprite.y);
            for (enemy in space.enemies.enemies) {
                // inaccurate collision bounding box for performance, only doing more precise stuff if in range of enemy.
                if (enemy.x < collisionX + 150 && enemy.x > collisionX - 150
                    && enemy.y < collisionY + 150 && enemy.y > collisionY - 150) {
                    // TODO: Should bullets have a radius?
                    if (BoundUtils.checkBound(charBullet.sprite.x, charBullet.sprite.y, 0,
                            enemy.x, enemy.y, enemy.radius)) {
                        enemy.shot = true;
                        space.character.enemyKilled({
                            xVelocity: charBullet.start.xVelocity,
                            yVelocity:charBullet.start.yVelocity,
                            x:charBullet.sprite.x, y:charBullet.sprite.y});
                        // bullets are one use only
                        dead.add(charBullet);
                        continue;
                    }
                }
            }
            // this will kill bullets who have gone over charBullet.life distance.
            if (BoundUtils.distance(charBullet.start.x, charBullet.start.y,
                    charBullet.sprite.x, charBullet.sprite.y) > charBullet.life) {
                dead.add(charBullet);
                continue;
            }
        }
        for (charBullet in dead) {
            charBullets.remove(charBullet);
            space.spaceContainer.removeChild(charBullet.sprite);
        }
    }

}
