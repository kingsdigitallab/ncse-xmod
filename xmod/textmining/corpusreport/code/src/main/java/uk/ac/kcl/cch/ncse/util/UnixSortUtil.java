package uk.ac.kcl.cch.ncse.util;

import java.io.File;
import java.io.IOException;

public class UnixSortUtil {
	
	public static void sort(File in, File out) throws IOException, InterruptedException{
		sort(in, out, "");
	}
	
	public static void sort(File in, File out, String args) throws IOException, InterruptedException{
		Process p1 = Runtime.getRuntime().exec("sort "+args+" "+in.getAbsolutePath()+" -o "+out.getAbsolutePath());
		ProcessUtil.drainInBackground(p1);
		p1.waitFor();
	}
	
}
