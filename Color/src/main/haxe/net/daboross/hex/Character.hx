package net.daboross.hex;

import createjs.easeljs.Ticker;
import createjs.easeljs.Sprite;
import createjs.easeljs.Text;
import createjs.easeljs.SpriteSheet;

import net.daboross.hex.SpaceHandler;
import net.daboross.hex.util.KeyCodes;
import net.daboross.hex.util.Keyboard;
import net.daboross.hex.util.Position;
import net.daboross.hex.util.TimeUtils;

class Character extends Sprite {

    private static var SHOOTING_COOLDOWN = 200; // milliseconds
    public var statusText:Text = new Text(" Currently initializing stats", "15px Arbutus", "#FFF");
    public var maxLife:Int = 5;
    public var life:Int = 5;
    public var score:Int = 0;
    public var level:Int = 0;
    public var shooting:Bool = false;
    public var spaceX:Float = 0;
    public var spaceY:Float = 0;
    public var radius:Int = 32;
    private var space:SpaceHandler;
    private var keyboard:Keyboard;
    private var xVelocity:Float = 0;
    private var yVelocity:Float = 0;
    private var rotationVelocity:Float = 0;
    private var nextPossibleShot:Float = 0; // for shooting cooldown

    public function new(space:SpaceHandler, keyboard:Keyboard, sheet:SpriteSheet, frame:Dynamic) {
        super(sheet);
        this.gotoAndStop(0);
        this.space = space;
        this.keyboard = keyboard;
    }

    private function getSpeed() : Float {
        var speed:Float = 1.0 + level * 0.1;
        if (shooting) {
            speed *= 0.5;
        }
        return speed;
    }

    private function getBackwardsSpeed() : Float {
        var speed:Float = 0.3 + level * 0.07;
        if (shooting) {
            speed *= 0.5;
        }
        return speed;
    }

    public function updateKeys() {
        shooting = keyboard.isPressed(KeyCodes.SPACE_BAR);

        var tempY:Int = 0;
        var tempX:Int = 0;
        if (keyboard.isPressed(KeyCodes.UP)) {
            tempY += 1;
        }
        if (keyboard.isPressed(KeyCodes.DOWN)) {
            tempY -= 1;
        }
        if (keyboard.isPressed(KeyCodes.LEFT)) {
            tempX -= 1;
        }
        if (keyboard.isPressed(KeyCodes.RIGHT)) {
            tempX += 1;
        }

        if (tempY != 0) {
            var speed:Float;
            switch (tempY) {
                case 1: speed = getSpeed();
                case -1: speed = getBackwardsSpeed();
                default: throw "Generic Error";
            }
            xVelocity += speed * tempY * Math.cos(Math.PI / 180 * rotation);
            yVelocity += speed * tempY * Math.sin(Math.PI / 180 * rotation);
        }

        if (tempX != 0) {
            rotationVelocity += tempX * getSpeed();
        }
    }

    public function updateWeapons() {
        if (shooting) { // shooting is set in updateKeys()
            var time:Float = TimeUtils.getTime();
            if (time > nextPossibleShot) {
                nextPossibleShot = time + SHOOTING_COOLDOWN;
                var rotationRadians:Float = rotation * Math.PI / 180;
                var xVelocityUnit = Math.cos(rotationRadians);
                var yVelocityUnit = Math.sin(rotationRadians);
                var start:Position = {
                    x:spaceX + xVelocityUnit * radius,
                    y:spaceY + yVelocityUnit * radius,
                    xVelocity: xVelocityUnit * 10 + level * 0.2,
                    yVelocity: yVelocityUnit * 10 + level * 0.2
                };
                trace("Firing");
                space.projectileHandler.spawnCharBullet(start);
            }
        }
    }

    public function updateLevel() {
        if (score <= 0) {
            level = 0;
        } else {
            var newLevel:Int = Std.int(score / 35);
            if (newLevel != level) {
                maxLife += 1;
                if (life < maxLife && life > 0) {
                    life += 1;
                }
            }
            level = newLevel;
        }
    }

    public function hit(projectileRotation:Float, projectileSpeed:Float) {
        life -= 1;
        if (life <= 0) {
            score = 0;
            updateLevel();
            life = 5;
            maxLife = 5;
            space.particleHandler.addParticlesWithAngle(1,
                {x:spaceX, y:spaceY, xVariation:20, yVariation:20},
                0, 2 * Math.PI, 3, 1,
                100, 3000, 1000);
            // TODO: Full reset of everything.
        } else {
            space.particleHandler.addParticlesWithAngle(1,
                {x:spaceX - Math.cos(projectileRotation) * radius / 2,
                    y:spaceY - Math.sin(projectileRotation) * radius / 2,
                    xVariation:20, yVariation:20},
                    projectileRotation, Math.PI/2,
                    projectileSpeed, projectileSpeed / 2, 30, 500, 300);
            space.particleHandler.addParticlesWithAngle(1,
                {x:spaceX - Math.cos(projectileRotation) * radius / 2,
                    y:spaceY - Math.sin(projectileRotation) * radius / 2,
                    xVariation:20, yVariation:20},
                    projectileRotation, Math.PI/4,
                    projectileSpeed + 1, projectileSpeed / 2, 20, 500, 300);
        }
    }

    public function enemyKilled(pos:Position) {
        score += 7;
        updateLevel();

        var speed:Float = Math.sqrt(pos.xVelocity * pos.xVelocity + pos.yVelocity * pos.yVelocity);
        var projectileRotation:Float = Math.acos(pos.xVelocity / speed);
        space.particleHandler.addParticlesWithAngle(2,
            {x:pos.x, y:pos.y, xVariation:10, yVariation:10},
            0, Math.PI * 2, speed / 2, speed / 2, 30, 500, 300);
    }

    public function tick() {
        updateKeys();
        updateWeapons();

        spaceX += xVelocity;
        spaceY += yVelocity;
        rotation += rotationVelocity;
        rotation %= 360;

        xVelocity *= 0.9;
        yVelocity *= 0.9;
        rotationVelocity *= 0.9;

        statusText.text = " This game is a test, not really meant to be complete. Feel free to play though!"
                            + "\n Score: " + score
                            + "\n Level: " + level
                            + "\n Life: " + life
                            + "\n FPS: " + Math.ceil(Ticker.getFPS());
    }
}
