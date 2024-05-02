package uk.ac.kcl.cch.ncse.prxml;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.TreeSet;

public class Toc {

	private Map<String, Entity> entities;
	
	public Toc(){
		entities = new TreeMap<String, Entity>();
	}
	
	void add(Entity e){
		entities.put(e.getId(), e);
	}
	
	public Set<String> getIds(){
		return new TreeSet<String>(entities.keySet());
	}
	
	public Entity get(String id){
		return entities.get(id);
	}

	public EntitySequence getEntitySequence(String id) {
		List<Entity> entities = new ArrayList<Entity>(3);
		
		Entity e = get(id);
		while(e.getContinuationFrom() != null)
			e = get(e.getContinuationFrom());
		
		for(;;){
			entities.add(e);
			String nextID = e.getContinuationTo();
			if(nextID != null)
				e = get(nextID);
			else
				break;
		}
		
		return new EntitySequence(entities);
	}

	
	public List<EntitySequence> getEntitySequences() {
		List<EntitySequence> sequences = new ArrayList<EntitySequence>();
		Set<String> processedIDs = new HashSet<String>();

		for(String id : getIds()){
			if(processedIDs.contains(id))
				continue;
			EntitySequence chain = getEntitySequence(id);
			processedIDs.addAll(chain.getIds());
			sequences.add(chain);
		}
		
		return sequences;
	}
	
}
