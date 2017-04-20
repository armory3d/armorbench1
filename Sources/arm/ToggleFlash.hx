package arm;

class ToggleFlash extends armory.Trait {
    public function new() {
        super();
        
        notifyOnUpdate(function() {
        	var mouse = armory.system.Input.getMouse();
            if (!mouse.down() && mouse.started("right")) {
                object.visible = !object.visible;
            }
        });
    }
}
