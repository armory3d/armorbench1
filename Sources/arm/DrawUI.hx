package arm;

class DrawUI extends armory.Trait {
    public function new() {
        super();

        notifyOnInit(function() {

            kha.Assets.loadImage("ui_persp", function(image:kha.Image) {
                notifyOnRender2D(function(g:kha.graphics2.Graphics) {
                    var x = 40;
                    var y = armory.App.h() - image.height - 40;
                    g.drawImage(image, x, y);
                });
            });
        });
    }
}
