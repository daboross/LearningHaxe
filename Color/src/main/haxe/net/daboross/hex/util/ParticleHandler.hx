package net.daboross.hex.util;

import createjs.easeljs.Sprite;
import createjs.easeljs.SpriteSheet;

import net.daboross.hex.SpaceHandler;
import net.daboross.hex.util.Position;
import net.daboross.hex.util.TimeUtils;

typedef Particle = {endOfLife:Int, startOfFade:Int, sprite:Sprite, xVelocity:Float, yVelocity:Float};

class ParticleHandler {

    private var bulletSheet:SpriteSheet;
    private var space:SpaceHandler;
    private var particles:List<Particle> = new List();

    public function new(space:SpaceHandler, sheet:SpriteSheet) {
        this.space = space;
        this.bulletSheet = sheet;
    }

    private function variation(variation:Float) {
        return variation / 2 - Math.random() * variation;
    }

    public function addParticles(frame:Dynamic,
            position:VariatedPosition, velocity:VariatedPosition,
            angleVariation:Float,
            count:Int, life:Int, lifeVariation:Float) {
        for (i in 0...count) {
            var xVelocity:Float = velocity.x + variation(velocity.xVariation);
            var yVelocity:Float = velocity.y + variation(velocity.yVariation);
            var force:Float = Math.sqrt(xVelocity * xVelocity + yVelocity * yVelocity);
            var angle:Float = Math.acos(xVelocity / force) + variation(angleVariation);
            var finalXVelocity:Float = Math.cos(angle) * force;
            var finalYVelocity:Float = Math.sin(angle) * force;
            var endOfLife:Int = TimeUtils.getTime() + life + Std.int(variation(lifeVariation));
            var sprite:Sprite = new Sprite(bulletSheet);
            sprite.gotoAndStop(frame);
            sprite.x = position.x + variation(position.xVariation);
            sprite.y = position.y + variation(position.yVariation);
            sprite.rotation = angle * 180 / Math.PI;
            space.spaceContainer.addChild(sprite);
            var particle:Particle = {endOfLife: endOfLife, sprite: sprite,
                xVelocity: finalXVelocity, yVelocity: finalYVelocity};
            particles.add(particle);
        }
    }

    public function addParticlesWithAngle(frame:Dynamic,
            position:VariatedPosition,
            angle:Float, angleVariation:Float,
            force:Float, forceVariation:Float,
            count:Int, life:Int, lifeVariation:Float) {
        for (i in 0...count) {
            var variatedForce:Float = force + variation(forceVariation);
            var variatedAngle:Float = angle + variation(angleVariation);
            var xVelocity:Float = Math.cos(variatedAngle) * variatedForce;
            var yVelocity:Float = Math.sin(variatedAngle) * variatedForce;
            var endOfLife:Int = TimeUtils.getTime() + life + Std.int(variation(lifeVariation));
            var sprite:Sprite = new Sprite(bulletSheet);
            sprite.gotoAndStop(frame);
            sprite.x = position.x + variation(position.xVariation);
            sprite.y = position.y + variation(position.yVariation);
            sprite.rotation = variatedAngle * 180 / Math.PI;
            space.spaceContainer.addChild(sprite);
            var particle:Particle = {endOfLife: endOfLife, sprite: sprite,
                xVelocity: xVelocity, yVelocity: yVelocity};
            particles.add(particle);
        }
    }


    public function tick() {
        var dead:List<Particle> = new List();
        var time:Int = TimeUtils.getTime();
        for (particle in particles) {
            particle.sprite.x += particle.xVelocity;
            particle.sprite.y += particle.yVelocity;
            if (particle.startOfFade < time) {
                particle.sprite
            }
            if (particle.endOfLife < time) {
                dead.add(particle);
            }
        }
        for (particle in dead) {
            particles.remove(particle);
            space.spaceContainer.removeChild(particle.sprite);
        }
    }
}
