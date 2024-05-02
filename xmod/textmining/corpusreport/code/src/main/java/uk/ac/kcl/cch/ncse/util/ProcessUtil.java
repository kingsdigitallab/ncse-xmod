package uk.ac.kcl.cch.ncse.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;


public class ProcessUtil {

	public static void drainInBackground(final Process p) {
		Drainer out = new Drainer(p.getInputStream());
		out.start();
		Drainer err = new Drainer(p.getErrorStream());
		err.start();
	}
	
	private static class Drainer extends Thread{
		private InputStream is;
		public Drainer(InputStream is){
			this.is = is;
		}
		@Override
		public void run() {
			BufferedReader r = new BufferedReader(new InputStreamReader(is));
			String line = null;
			try {
				while((line=r.readLine())!=null){
					System.err.println(line);
				}
			} 
			catch (IOException e) {
				e.printStackTrace();
			}
		}
	}
	
}
