package uk.ac.kcl.cch.ncse.prxml;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * A sequence of Entity objects. 
 * Allows to represent articles made up of multiple parts.
 * 
 * @author patrick
 */
public class EntitySequence implements Iterable<Entity>{

	private List<Entity> entities;
	
	public EntitySequence(List<Entity> entities){
		this.entities = entities;
	}

	public Iterator<Entity> iterator() {
		return entities.iterator();
	}
	
	public List<String> getIds(){
		List<String> ids = new ArrayList<String>(entities.size());
		for(Entity e : entities)
			ids.add(e.getId());
		return ids;
	}
	
	@Override
	public String toString(){
		StringBuilder b = new StringBuilder();
		for(Entity e : entities)
			b.append(e.getId()).append(" ");
		b.deleteCharAt(b.length()-1);
		return b.toString();
	}
	
	/**
	 * @return full id -- may be too long for use in filenames.
	 */
	public String getCompoundId(){
		StringBuilder b = new StringBuilder();
		for(Entity e : entities)
			b.append(e.getId()).append("_");
		b.deleteCharAt(b.length()-1);
		return b.toString();
	}
	
	/**
	 * @return short id for use in filenames.
	 */
	public String getShortId(){
		if(entities.size()==0)
			return "empty";
		Entity e = entities.get(0);
		return e.getId();
	}
	
	public int getFirstPage(){
		if(entities.size()==0)
			return 0;
		else
			return entities.get(0).getPage();
	}
}
