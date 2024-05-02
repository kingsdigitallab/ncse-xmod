package uk.ac.kcl.cch.ncse.annie;
/*
 *  StandAloneAnnie.java
 *
 *
 * Copyright (c) 2000-2001, The University of Sheffield.
 *
 * This file is part of GATE (see http://gate.ac.uk/), and is free
 * software, licenced under the GNU Library General Public License,
 * Version 2, June1991.
 *
 * A copy of this licence is included in the distribution in the file
 * licence.html, and is also available at http://gate.ac.uk/gate/licence.html.
 *
 *  hamish, 29/1/2002
 *
 *  $Id: StandAloneAnnie.java,v 1.6 2006/01/09 16:43:22 ian Exp $
 */

import gate.Corpus;
import gate.Document;
import gate.Factory;
import gate.FeatureMap;
import gate.Gate;
import gate.ProcessingResource;
import gate.creole.ANNIEConstants;
import gate.creole.SerialAnalyserController;
import gate.util.GateException;
import gate.util.Out;

import java.io.File;
import java.net.MalformedURLException;

/**
 * Derived from StandAloneAnnie class from Gate examples.
 * 
 * This class illustrates how to use ANNIE as a sausage machine
 * in another application - put ingredients in one end (URLs pointing
 * to documents) and get sausages (e.g. Named Entities) out the
 * other end.
 * <P><B>NOTE:</B><BR>
 * For simplicity's sake, we don't do any exception handling.
 */
public class StandAloneAnnie  {

  /** The Corpus Pipeline application to contain ANNIE */
  private SerialAnalyserController annieController;

  /**
   * Initialise the ANNIE system. This creates a "corpus pipeline"
   * application that can be used to run sets of documents through
   * the extraction system.
   */
  public void initAnnie() throws GateException {
    Out.prln("Initialising ANNIE...");

    // create a serial analyser controller to run ANNIE with
    annieController =
      (SerialAnalyserController) Factory.createResource(
        "gate.creole.SerialAnalyserController", Factory.newFeatureMap(),
        Factory.newFeatureMap(), "ANNIE_" + Gate.genSym()
      );

    // load each PR as defined in ANNIEConstants
    for(int i = 0; i < ANNIEConstants.PR_NAMES.length; i++) {
      FeatureMap params = Factory.newFeatureMap(); // use default parameters
      ProcessingResource pr = (ProcessingResource)
        Factory.createResource(ANNIEConstants.PR_NAMES[i], params);

      // add the PR to the pipeline controller
      annieController.add(pr);
    } // for each ANNIE PR

    Out.prln("...ANNIE loaded");
  } // initAnnie()

  /** Tell ANNIE's controller about the corpus you want to run on */
  private void setCorpus(Corpus corpus) {
    annieController.setCorpus(corpus);
  } // setCorpus

  /** Run ANNIE */
  private void execute() throws GateException {
    annieController.execute();
  } // execute()

  

  public Document process(String plainText) throws GateException {
	  Document doc = Factory.newDocument(plainText);
	  if (plainText.length()>0){
		  process(doc);
	  }
	  return doc;
  }
  
  public void process(Document doc) throws GateException{
	  Corpus corpus = (Corpus) Factory.createResource("gate.corpora.CorpusImpl");
	  corpus.add(doc);
	  setCorpus(corpus);
	  execute();
  }
  
  
  
  	private static StandAloneAnnie annie;
	
	public static StandAloneAnnie getAnnie() throws GateException, MalformedURLException{
		if(annie==null){
			
		    Out.prln("Initialising GATE...");
		    Gate.init();

		    // Load ANNIE plugin
		    File gateHome = Gate.getGateHome();
		    File pluginsHome = new File(gateHome, "plugins");
		    Gate.getCreoleRegister().registerDirectories(new File(pluginsHome, "ANNIE").toURL());
		    Out.prln("...GATE initialised");
			
			annie = new StandAloneAnnie();
			annie.initAnnie();
		}
		return annie;
	}
	
  
  
  
} // class StandAloneAnnie
