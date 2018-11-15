package arm;

class ToggleFlash extends iron.Trait {
    public function new() {
        super();
        
        notifyOnUpdate(function() {
        	var mouse = iron.system.Input.getMouse();
            if (!mouse.down() && mouse.started("right")) {
                object.visible = !object.visible;
            }
        });
    }
}
