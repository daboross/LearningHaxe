package net.daboross.hex;

import createjs.easeljs.Sprite;
import createjs.easeljs.Text;
import createjs.easeljs.SpriteSheet;
import js.html.KeyboardEvent;

import net.daboross.hex.SpaceHandler;
import net.daboross.hex.util.KeyCodes;
import net.daboross.hex.util.Keyboard;

class Character extends Sprite {

    public var statusText:Text = new Text("x = 0 | y = 0", "Ubuntu Mono", "#FFF");
    public var speed:Float = 1.0;
    public var spaceX:Float = 0;
    public var spaceY:Float = 0;
    public var radius:Int = 32;
    private var space:SpaceHandler;
    private var keyboard:Keyboard;
    private var xVelocity:Float = 0;
    private var yVelocity:Float = 0;
    private var rotationVelocity:Float = 0;

    public function new(space:SpaceHandler, keyboard:Keyboard, sheet:SpriteSheet, frame:Dynamic) {
        super(sheet, frame);
        this.space = space;
        this.keyboard = keyboard;
    }

    public function updateKeys() {
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
            xVelocity += speed * tempY * Math.cos(Math.PI / 180 * rotation);
            yVelocity += speed * tempY * Math.sin(Math.PI / 180 * rotation);
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

        statusText.text = " x = " + Std.int(spaceX) + " | y = " + Std.int(spaceY);
    }
}
