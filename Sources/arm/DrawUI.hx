package arm;

class DrawUI extends iron.Trait {
    public function new() {
        super();

        notifyOnInit(function() {

            iron.data.Data.getImage("ui_persp.png", function(image:kha.Image) {
                notifyOnRender2D(function(g:kha.graphics2.Graphics) {
                    var x = 40;
                    var y = iron.App.h() - image.height - 40;
                    g.drawImage(image, x, y);
                });
            });
        });
    }
}
