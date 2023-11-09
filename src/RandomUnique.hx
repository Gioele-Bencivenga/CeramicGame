package;

/**
 * Thanks to [nicetrysean](https://github.com/nicetrysean) for the base implementation https://gist.github.com/nicetrysean/10954338
 * 
 * and to [davzrm](https://github.com/davzrm) for the improvements https://gist.github.com/nicetrysean/10954338?permalink_comment_id=3025199#gistcomment-3025199
 */
class RandomUnique {
	/**
	 * Returns a shuffled list of the range of `Int`s provided.
	 * 
	 * If parameters are `(0, 1)` will always return `0`.
	 * @param startNumber smallest number that will appear in the list
	 * @param endNumber biggest number that will appear in the list
	 * @param amountDesired? number of items we want returned from the list
	 * @return Array<Int> an array containing only 1 of every number in the range, in a random order
	 */
	public static function between(startNumber:Int = 0, endNumber:Int = 9, ?amountDesired:Int = 0):Array<Int> {
		var tempAmount:Int;
		if (amountDesired != 0) {
			tempAmount = endNumber - amountDesired;
		} else {
			tempAmount = startNumber;
		}

		var baseNumber:Array<Int> = new Array();
		var randNumber:Array<Int> = new Array();

		for (i in startNumber...endNumber) {
			baseNumber[i] = i;
		}
		var i:Int = endNumber;
		while (--i >= tempAmount) {
			var tempRandom:Int = startNumber + Math.floor(Math.random() * ((i + 1) - startNumber));
			randNumber[endNumber - (i + 1)] = baseNumber[tempRandom];
			baseNumber[tempRandom] = baseNumber[i];
		}
		return randNumber;
	}
}
