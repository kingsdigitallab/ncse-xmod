package uk.ac.kcl.cch.ncse.frequency;

import java.io.File;
import java.util.Set;

import uk.ac.kcl.cch.ncse.util.Strings;
import uk.ac.kcl.cch.ncse.util.WordList;

public class UnknownTokenListGenerator extends TokenListGenerator {

	private Set<String> known = WordList.getKnownWords();
	
	public UnknownTokenListGenerator(File repositoryRoot, File tokenSink) {
		super(repositoryRoot, tokenSink);
	}

	@Override
	public boolean isRelevant(String token) {
		return !( 		Strings.isSingleChar(token)
					||	Strings.isNumber(token)
					||	Strings.isPunctuation(token)
					||	known.contains(token.toLowerCase()) 
		);
	}
	
}
