package uk.ac.kcl.cch.ncse.util;

import java.io.File;

public class FileUtil {

	public static void createDirectoriesIfNecessary(File target){
		createParents(target.getParentFile());
	}
	
	private static void createParents(File dir){
		if(!dir.exists()){
			createParents(dir.getParentFile());
			dir.mkdir();
		}
	}
	
	
	public static String makeRelative(String root, String child){
		if(!child.startsWith(root))
			throw new IllegalArgumentException("Cannot make "+child+" relative to "+root+".");
		
		return child.substring(root.length());
	}
	
}
