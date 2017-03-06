package arm;

class ToggleFlash extends armory.Trait {
    public function new() {
        super();
        
        notifyOnUpdate(function() {
            if (!armory.system.Input.down && armory.system.Input.started2) {
                object.visible = !object.visible;
            }
        });
    }
}
