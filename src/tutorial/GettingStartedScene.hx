package tutorial;

import ceramic.Text;
import tutorial.RotateVisualComponent;
import ceramic.Quad;
import ceramic.Scene;
import ceramic.Color;

using ceramic.VisualTransition;

class GettingStartedScene extends Scene {
	override function create() {
		log.debug('Hello!');

		var text = new Text();
		text.color = Color.WHITE;
		text.content = 'Hello World';
		text.pointSize = 48;
		text.anchor(0.5, 0.5);
		text.pos(screen.width * 0.5, screen.height * 0.5);

		// Display a yellow square
		var quad = new Quad();
		quad.size(200, 200);
		quad.color = Color.CORNFLOWERBLUE;
		quad.anchor(0.5, 0.5);
		quad.pos(width * 0.5, height * 0.5);
		add(quad);

		// Create a component
		var rotateVisual = new RotateVisualComponent();

		// Attach the component to the entity under the key: 'rotateVisual'
		quad.component('rotateVisual', rotateVisual);

		// Get the component instance attached to the entity
		var fetchedComponent:RotateVisualComponent;
		fetchedComponent = cast quad.component('rotateVisual');
		log.info('fetched component is ${fetchedComponent}');

		// Or
		// create an entity with a static component
		var rotQuad = new RotatingQuad();
		rotQuad.size(400, 400);
		rotQuad.color = Color.PALEGOLDENROD;
		rotQuad.anchor(0.5, 0.5);
		rotQuad.pos(width * 0.5, height * 0.5);
		add(rotQuad);

		// access the component directly
		rotQuad.rotateVisual.duration = 1;
		rotQuad.rotateVisual.pause = 0.6;
	}

	/**
	 * Some custom `fadeIn()` implementation inside a scene.
	 * 
	 * Can also override `fadeOut()` by inverting the shift in color.
	 */
	override function fadeIn(done:() -> Void) {
		// Create a black opaque overlay
		var overlayQuad = new Quad();
		overlayQuad.size(width, height);
		overlayQuad.color = Color.BLACK;
		overlayQuad.alpha = 1;

		// You might want to set a `depth` to ensure
		// this overlay will be above your other visuals
		// added in `create()` method.
		overlayQuad.depth = 1;

		add(overlayQuad);

		// Transition this overlay to fully transparent
		overlayQuad.transition(0.5, overlayQuad -> {
			overlayQuad.alpha = 0;
		}).onceComplete(this, () -> {
			// Fade-in has finished, so we
			// can call the done() callback
			done();

			// Overlay is not needed anymore
			overlayQuad.destroy();
			overlayQuad = null;
		});
	}
}
