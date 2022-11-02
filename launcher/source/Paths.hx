package;

/**
 * Class of paths
 */
class Paths
{
	/**
	 * Redirects to `'assets/sounds/' + file` 
	 */
	static public function Sounds(file):String
	{
		return 'assets/sounds/' + file;
	}

	/**
	 * Redirects to `'assets/music/' + file` 
	 */
	static public function Music(file):String
	{
		return 'assets/music/' + file;
	}

	/**
	 * Redirects to `'assets/prompts/' + file` 
	 */
	static public function Prompts(file):String
	{
		return 'assets/prompts/' + file;
	}

	/**
	 * Redirects to `'assets/images/' + file` 
	 */
	static public function Images(file):String
	{
		return 'assets/images/' + file;
	}
}
