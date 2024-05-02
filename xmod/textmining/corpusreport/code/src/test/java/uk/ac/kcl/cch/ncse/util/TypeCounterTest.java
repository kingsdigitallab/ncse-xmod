package uk.ac.kcl.cch.ncse.util;

import java.util.Iterator;
import java.util.Map;

import junit.framework.TestCase;

public class TypeCounterTest extends TestCase {

	public void testCountsAndOrder(){
		TypeCounter c = new TypeCounter();
		
		c.count("a");
		c.count("b");
		c.count("c");
		c.count("d");
		
		c.count("a");
		c.count("c");
		c.count("d");

		c.count("a");
		c.count("d");
		
		assertEquals(3, c.getCount("a"));
		assertEquals(1, c.getCount("b"));
		assertEquals(2, c.getCount("c"));
		assertEquals(3, c.getCount("d"));
		
		Iterator<Map.Entry<String, Integer>> i = c.elementsSortedAccordingToFrequency().iterator();
		assertEquals("a", i.next().getKey());
		assertEquals("d", i.next().getKey());
		assertEquals("c", i.next().getKey());
		assertEquals("b", i.next().getKey());
	}
	
	public void testNumberType(){
		TypeCounter c = new TypeCounter();
		c.count("a");
		c.count("a");
		c.count("a");
		
		for(int i=0; i<100; i++)
			c.count(""+i);
		
		assertEquals(3, c.getCount("a"));
		assertEquals(100, c.getCount(TypeCounter.NUMBER));
	}
	
	public void testPunctuationType(){
		TypeCounter c = new TypeCounter();
		c.count("a");
		c.count(".");
		c.count(":");
		c.count("-");
		c.count(".,.;:,.;:,.");
		c.count("---");
		assertEquals(1, c.getCount("a"));
		assertEquals(5, c.getCount(TypeCounter.PUNCTUATION));
	}

	
	
}
