package tutorial;

import ceramic.Visual;
import ceramic.Entity;
import ceramic.Component;
import ceramic.Timer;

/**
 * An example of component that creates a rotating animation with the visual attached to it
 * 
 * The class must be a subclass of Entity, that is: every component is also an entity. That said, it does not need to be a direct subclass of Entity. You could turn a Visual into a component as well because Visual also inherits from Entity.
 * 
 * When an entity is destroyed, any component attached to it will be destroyed as well
 */
class RotateVisualComponent extends Entity implements Component {
	/**
	 * The visual we attach to
	 */
	@entity var visual:Visual;

	/**
	 * The duration of each rotation
	 */
	public var duration:Float;

	/**
	 * The pause between each rotation
	 */
	public var pause:Float;

	public function new(duration:Float = 2.0, pause:Float = 1.0) {
		super();

		this.duration = duration;
		this.pause = pause;
	}

	/**
	 * Called when the component is attached to an entity
	 */
	function bindAsComponent() {
		// start rotating
		startRotation();
	}

	function startRotation() {
		// Animate rotation
		visual.tween(ELASTIC_EASE_IN_OUT, duration, 0, 360, (value, time) -> {
			visual.rotation = value;
		}) // And repeat
			.onceComplete(this, () -> {
				Timer.delay(this, pause, startRotation);
			});
	}
}
