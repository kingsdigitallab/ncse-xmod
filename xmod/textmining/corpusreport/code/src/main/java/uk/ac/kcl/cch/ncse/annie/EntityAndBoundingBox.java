package uk.ac.kcl.cch.ncse.annie;

public class EntityAndBoundingBox implements Comparable<EntityAndBoundingBox>{

	public final String entity;
	public final String box;
	
	public EntityAndBoundingBox(String e, String b){
		entity = e;
		box = b;
	}
	
	@Override
	public boolean equals(Object obj) {
		if(obj instanceof EntityAndBoundingBox){
			EntityAndBoundingBox other = (EntityAndBoundingBox) obj;
			return entity.equals(other.entity) && box.equals(other.box);
		}
		else 
			return false;
	}
	
	@Override
	public int hashCode() {
		return entity.hashCode() + 3 * box.hashCode();
	}

	public int compareTo(EntityAndBoundingBox o) {
		int c = entity.compareTo(o.entity);
		if(c==0){
			return box.compareTo(o.box);
		}
		return c;
	}
	
	@Override
	public String toString() {
		return entity+"\t"+box;
	}
	
}
