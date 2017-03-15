package arm;

import iron.math.Vec4;
import iron.system.Input;
import iron.object.Object;
import armory.trait.internal.PhysicsWorld;
import armory.trait.internal.CameraController;

@:keep
class FirstPersonController extends CameraController {

#if (!arm_physics)
	public function new() { super(); }
#else

	var head:Object;
	var locked = false;
	static inline var rotationSpeed = 2.0; 

	public function new() {
		super();

		armory.Scene.active.notifyOnInit(init);
	}
	
	function init() {
		head = object.getChild("Head");

		PhysicsWorld.active.notifyOnPreUpdate(preUpdate);
		notifyOnUpdate(update);
		notifyOnRemove(removed);
	}

	var xVec = Vec4.xAxis();
	var zVec = Vec4.zAxis();
	function preUpdate() {
		if (Input.occupied || !body.ready) return;

		if (Input.down) {
			head.transform.rotate(xVec, -Input.movementY / 250 * rotationSpeed);
			transform.rotate(zVec, -Input.movementX / 250 * rotationSpeed);
			body.syncTransform();
		}
	}

	function removed() {
		PhysicsWorld.active.removePreUpdate(preUpdate);
	}

	var dir = new Vec4();
	function update() {
		if (!body.ready) return;

		// Move head
		head.transform.loc.z = 0.1;// + Math.sin(armory.system.Time.time()) / 50.0;
		head.transform.dirty = true;

		// Move
		dir.set(0, 0, 0);
		if (moveForward) dir.add(transform.look());
		if (moveBackward) dir.add(transform.look().mult(-1));
		if (moveLeft) dir.add(transform.right().mult(-1));
		if (moveRight) dir.add(transform.right());

		// Push down
		var btvec = body.getLinearVelocity();
		body.setLinearVelocity(0.0, 0.0, btvec.z() - 1.0);

		if (moveForward || moveBackward || moveLeft || moveRight) {			
			dir.mult(3);
			body.activate();
			body.setLinearVelocity(dir.x, dir.y, btvec.z() - 1.0);
		}

		// Keep vertical
		body.setAngularFactor(0, 0, 0);
		camera.buildMatrix();
	}
#end
}
