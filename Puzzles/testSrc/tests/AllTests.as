package tests 
{
	import asunit.framework.TestSuite;
	
	/**
	 * ...
	 * @author Sean Snyder
	 */
	public class AllTests extends TestSuite 
	{
		
		public function AllTests() 
		{
			super();
            addTest(new TestGameConfig());
			addTest(new TestMenuButton());
			addTest(new TestLevelProvider());
			addTest(new TestLevelGenerator());
			addTest(new TestLevel());
		}
		
	}

}