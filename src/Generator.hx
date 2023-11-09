import Random;

class Generator {
	/**
	 * Tilemap's height
	 */
	var mapHeight:Int;

	/**
	 * Tilemap's width
	 */
	var mapWidth:Int;

	/**
	 * The actual tilemap.
	 */
	public var map:Array<Array<Int>>;

	public function new(mapHeight = 500, mapWidth = 200) {
		generateMap(mapHeight, mapWidth);
	}

	function generateMap(height:Int, width:Int) {
		mapHeight = height;
		mapWidth = width;
		map = [for (y in 0...mapHeight) [for (x in 0...mapWidth) 1]];
	}

	/**
	 * Generates a matrix of 0s and 1s representing a cave.
	 * @param length how long the cave should be (in tiles)
	 * @param roughness how much the cave can vary in width
	 * @param windiness how much the cave's path swerves
	 */
	public function generateCave(length:Int, roughness:Int, windiness:Int) {
		var startWidth = 20;
		var startHeight = 15;
		var startX = Std.int(mapWidth / 2 - startWidth / 2);
		var startY = mapHeight - startHeight - 1;

		// create first empty space at the bottom
		fillRect(startX, startY, startWidth, startHeight, 0);

		var currX = startX;
		var currY = startY;
		var currWidth = startWidth;
		var currLength = startHeight;

		// iterative part
		while (currLength < length - 20) {
			currY--; // move up 1 tile // maybe take into account startY??
			currLength++;

			var shouldChange = Random.int(0, 100);
			if (shouldChange <= roughness) {
				// random amount between -2 and 2 excluding 0
				// maybe parametrize so this also can be changed like roughness
				var amount = Random.fromArray([-2, -1, 1, 2]);
				currWidth += amount;
				// make minimum and maximum width var
				if (currWidth < 5) {
					currWidth = 5;
				} else if (currWidth > mapWidth) {
					currWidth = mapWidth;
				}
			}
			var shouldSwerve = Random.int(0, 100);
			if (shouldSwerve <= windiness) {
				// random amount between -2 and 2 excluding 0
				// maybe parametrize so this also can be changed like windiness
				var amount = Random.fromArray([-2, -1, 1, 2]);
				currX += amount;
				if (currX < 0) {
					currX = 0;
				} else if (currX > mapWidth - 5) {
					currX = mapWidth - 5;
				}
			}

			fillRect(currX, currY, currWidth, 1, 0);
		}
	}

	/**
	 * watch out, filling a rect bigger than the map enlarges the map!
	 * @param x 
	 * @param y 
	 * @param width 
	 * @param height 
	 * @param value 
	 */
	function fillRect(x:Int, y:Int, width:Int, height:Int, value:Int) {
		for (indexY in 0...height) {
			for (indexX in 0...width) {
				map[y + indexY][x + indexX] = value;
			}
		}
	}

	public function testFillRect() {
		generateMap(4, 4);

		trace('created map:
		\n${map[0]}
		\n${map[1]}
		\n${map[2]}
		\n${map[3]}
		');

		fillRect(1, 1, 4, 2, 0);

		trace('modified map:
		\n${map[0]}
		\n${map[1]}
		\n${map[2]}
		\n${map[3]}
		');
	}
}
