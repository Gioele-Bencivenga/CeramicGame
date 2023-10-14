package tutorial;

import ceramic.Quad;
/**
 * A quad subclass that has a statically typed component always attached to it.
 * 
 * This allows us to access the component without casting: `rotatingQuad.rotateVisual.pause = 5.0`.
 */
class RotatingQuad extends Quad {
	@component public var rotateVisual = new RotateVisualComponent();
	public function new() {
		super();
	}
}
