package arm;

import zui.*;

class UITrait extends armory.Trait {
    
    var ui:Zui;
    var rt:kha.Image;
    var pin = "";
    var gateObject:armory.object.Object;
    var openingGate = false;

    var lastTime = 0.0;
	var frameTime = 0.0;
	var totalTime = 0.0;
	var frames = 0;
	var frameTimeAvg = 0.0;

    public function new() {
        super();

        kha.Assets.loadFont("droid_sans", function(f:kha.Font) {
            ui = new Zui({font: f, autoNotifyInput: false, scaleFactor: 2});
            armory.Scene.active.notifyOnInit(sceneInit);
        });
    }

    function sceneInit() {
        rt = kha.Image.createRenderTarget(512, 512);
        var mat:armory.data.MaterialData = cast(object, armory.object.MeshObject).materials[0];
        mat.contexts[0].textures[0] = rt; // Override diffuse texture

        notifyOnRender(render);
        notifyOnUpdate(update);
    }

    function render(g:kha.graphics4.Graphics) {

        ui.begin(rt.g2);
        if (ui.window(Id.handle(), 0, 0, 512, 512)) {
            if (ui.panel(Id.handle({selected: true}), "TERMINAL 14 ENTRANCE")) {
                ui.indent();

                ui.text(pin);
                
                ui.row([1/3, 1/3, 1/3]);
                if (ui.button("7")) { if (pin == "DENIED") { pin = ""; } pin += "7"; }
                if (ui.button("8")) { if (pin == "DENIED") { pin = ""; } pin += "8"; }
                if (ui.button("9")) { if (pin == "DENIED") { pin = ""; } pin += "9"; }

                ui.row([1/3, 1/3, 1/3]);
                if (ui.button("4")) { if (pin == "DENIED") { pin = ""; } pin += "4"; }
                if (ui.button("5")) { if (pin == "DENIED") { pin = ""; } pin += "5"; }
                if (ui.button("6")) { if (pin == "DENIED") { pin = ""; } pin += "6"; }

                ui.row([1/3, 1/3, 1/3]);
                if (ui.button("1")) { if (pin == "DENIED") { pin = ""; } pin += "1"; }
                if (ui.button("2")) { if (pin == "DENIED") { pin = ""; } pin += "2"; }
                if (ui.button("3")) { if (pin == "DENIED") { pin = ""; } pin += "3"; }

                ui.row([1/3, 2/3]);
                if (ui.button("0")) {pin += "0";}
                if (ui.button("ENTER")) {
                    if (pin == "DENIED" || pin == "VERIFIED") {
                        pin = "";
                    }
                    else if (pin == "340") {
                       pin = "VERIFIED";

                       gateObject = armory.Scene.active.getChild('GateLeft');
                       openingGate = true;  
                   }
                   else {
                       pin = "DENIED";
                   }
                }
                var tt = Std.int(frameTimeAvg * 1000);
                ui.text("fps: " + Std.int(1000 / tt) + " (" + tt + "ms)");
                ui.unindent();
            }
        }
        ui.end();

        totalTime += frameTime;
		frames++;
		if (totalTime > 1.0) {
			var t = totalTime / frames;
			frameTimeAvg = t;
			totalTime = 0;
			frames = 0;
		}
		frameTime = kha.Scheduler.realTime() - lastTime;
		lastTime = kha.Scheduler.realTime();
    }

    function update() {

        if (openingGate) {
            gateObject.transform.loc.x -= 0.03;
            gateObject.transform.dirty = true;
            gateObject.getTrait(armory.trait.internal.RigidBody).syncTransform();
            if (gateObject.transform.loc.x < -2.8) openingGate = false;
        }

        var uv = iron.math.RayCaster.getPlaneUV(cast object, armory.system.Input.x, armory.system.Input.y, iron.Scene.active.camera);
        if (uv == null) return;

        var px = Std.int(uv.x * 512);
        var py = Std.int(uv.y * 512);

        if (armory.system.Input.started) {
            ui.onMouseDown(0, px, py);
        }
        else if (armory.system.Input.released) {
            ui.onMouseUp(0, px, py);
        }
        
        if (armory.system.Input.movementX != 0 || armory.system.Input.movementY != 0) {
            ui.onMouseMove(px, py, 0, 0);
        }
    }
}
