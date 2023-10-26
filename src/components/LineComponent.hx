package components;

import ceramic.Visual;
import ceramic.Component;
import ceramic.Entity;

class LineComponent extends Entity implements Component {
    /**
	 * The visual we attach to
	 */
	@entity var visual:Visual;

    function bindAsComponent() {}
}