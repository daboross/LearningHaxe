package net.daboross.hex;

import createjs.easeljs.Sprite;
import js.html.KeyboardEvent;

import net.daboross.hex.SpaceHandler;
import net.daboross.hex.util.KeyCodes;
import net.daboross.hex.util.Keyboard;

class Character {

    public var sprite:Sprite;
    private var space:SpaceHandler;
    private var keyboard:Keyboard;
    public var spaceX:Float = 0;
    public var spaceY:Float = 0;
    private var rotation:Float = 0;
    private var xVelocity:Float = 0;
    private var yVelocity:Float = 0;
    private var rotationVelocity:Float = 0;

    public function new(space:SpaceHandler, sprite:Sprite, keyboard:Keyboard) {
        this.space = space;
        this.sprite = sprite;
        this.keyboard = keyboard;
    }

    public function updateKeys() {
        var tempY = 0;
        var tempX = 0;
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
            xVelocity += tempY * Math.cos(Math.PI / 180 * rotation);
            yVelocity += tempY * Math.sin(Math.PI / 180 * rotation);
        }

        if (tempX != 0) {
            rotationVelocity += tempX;
        }
    }

    public function tick() {
        updateKeys();

        spaceX += xVelocity;
        spaceY += yVelocity;
        rotation += rotationVelocity;
        rotation %= 360;

        xVelocity *= 0.9;
        yVelocity *= 0.9;
        rotationVelocity *= 0.9;

        sprite.x = spaceX;
        sprite.y = spaceY;
        sprite.rotation = rotation;
        trace(" spaceX = " + Std.int(spaceX) + " spaceY = " + Std.int(spaceY));
    }
}
