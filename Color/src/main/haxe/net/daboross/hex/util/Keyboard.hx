package net.daboross.hex.util;

import createjs.easeljs.Ticker;
import js.html.KeyboardEvent;
import js.Browser;

class Keyboard {

    private var keys:Map<Int, Bool> = new Map<Int, Bool>();

    public function new() {
    }

    public function register() {
        Browser.document.onkeydown = onKeyDown;
        Browser.document.onkeyup = onKeyUp;
    }

    public function onKeyDown(e:KeyboardEvent) {
        if (e.ctrlKey || (e.keyCode >= 112 && e.keyCode <= 123)) {
            // Ignore keys modified by control key, and ignore F1-12
            return;
        }
        // Ensure that e.preventDefault isn't ever called when e.ctrlKey, so that things like page reloading work.
        // We still want to call it for other keys though, so up/down arrows don't make the page scroll.
        e.preventDefault();

        keys[e.keyCode] = true;
    }

    public function onKeyUp(e:KeyboardEvent) {
        if (e.ctrlKey || (e.keyCode >= 112 && e.keyCode <= 123)) {
            // Ignore keys modified by control key, and ignore F1-12
            return;
        }
        // Ensure that e.preventDefault isn't ever called when e.ctrlKey, so that things like page reloading work.
        // We still want to call it for other keys though, so up/down arrows don't make the page scroll.
        e.preventDefault();

        keys.remove(e.keyCode);
    }

    public function onBlur(e:js.html.Event) {
        for (key in keys.keys()) {
            keys.remove(key);
        }
    }

    public function isPressed(key:Int) {
        return keys[key];
    }
}
