package training;

import detect.SentenceSE;

public class TrainingSentence extends SentenceSE {

	public TrainingSentence(String sentence) {
		super(sentence);
	}
	
	public TrainingSentence(String[] words, boolean[] isError) {
		super(catWords(words));
		setUniGram(words);
		setBiGram(words);
		setTriGram(words);
		setFourGram(words);
		setFiveGram(words);
		setSixGram(words);

		length = words.length;
		setIsErrors(isError);
	}
}
