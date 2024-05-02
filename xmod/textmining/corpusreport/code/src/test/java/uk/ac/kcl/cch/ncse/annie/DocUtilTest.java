package uk.ac.kcl.cch.ncse.annie;

import gate.Document;
import gate.util.GateException;

import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import junit.framework.TestCase;
import uk.ac.kcl.cch.ncse.report.Box;

public class DocUtilTest extends TestCase {

	public void testGetEntities() throws MalformedURLException, GateException{
		String text = 	"Mr. Sherlock Holmes, who was usually very late in the mornings, " +
						"save upon those not infrequent occasions when he was up all night, " +
						"was seated at the breakfast table.  I stood upon the hearth-rug " +
						"and picked up the stick which our visitor had left behind him the " +
						"night before.  It was a fine, thick piece of wood, bulbous-headed, " +
						"of the sort which is known as a \"Penang lawyer.\"  Just under the " +
						"head was a broad silver band nearly an inch across.  \"To James " +
						"Mortimer, M.R.C.S., from his friends of the C.C.H.,\" was engraved " +
						"upon it, with the date \"1884.\"  It was just such a stick as the " +
						"old-fashioned family practitioner used to carry--dignified, solid, " +
						"and reassuring.\n" +
						"\"Well, Watson, what do you make of it?\n\"+" +
						"Holmes was sitting with his back to me, and I had given him no " +
						"sign of my occupation.";

		Document doc = StandAloneAnnie.getAnnie().process(text);
		
		// 4, 12 -- Sherlock
		Box b = new Box(4,12,"TESTBOX");
		List<Box> boxes = new ArrayList<Box>();
		boxes.add(b);
		DocUtil.addBoxInfo(doc, boxes);
		
		Set<EntityAndBoundingBox> people = DocUtil.getEntities(doc, "Person");
		Set<String> thePersons = new TreeSet<String>();
		for(EntityAndBoundingBox eab : people){
			thePersons.add(eab.entity);
			if(eab.entity.equals(""))
				assertEquals("TESTBOX;", eab.box);
		}
		
		assertTrue("Expected person was not found.", thePersons.contains("Mr. Sherlock Holmes"));
		assertTrue("Expected person was not found.", thePersons.contains("James Mortimer"));
		assertTrue("Expected person was not found.", thePersons.contains("Watson"));
		assertTrue("Expected person was not found.", thePersons.contains("Holmes"));
		
		
		
	}
	
}
