package detect;

import java.util.ArrayList;
import java.util.Arrays;

public class SentenceSE extends Sentence {

	private ArrayList<String> uniGram;
	private ArrayList<String> biGram;
	private ArrayList<String> triGram;
	private ArrayList<String> fourGram;
	private ArrayList<String> fiveGram;
	private ArrayList<String> sixGram;

	private double[] uniGramResults;
	private double[] biGramResults;
	private double[] triGramResults;
	private double[] fourGramResults;
	private double[] fiveGramResults;
	private double[] sixGramResults;

	private boolean[] isErrors;
	public int length;

	public void setIsError (boolean error, int index) {
		getIsErrors()[index] = error;
	}

	public boolean getIsError (int index) {
		return isErrors[index];
	}

	public void setIsErrors(boolean[] isErrors) {
		this.isErrors = isErrors;
	}

	public boolean[] getIsErrors() {
		return isErrors;
	}

	public String sysOut () {
		StringBuilder sb = new StringBuilder(raw);

		int index = 0;
		for (int i = 0; i < uniGram.size(); i++) {
			String w = uniGram.get(i);
			int indexOf = sb.indexOf(w, index);

			if (indexOf == -1) {
				System.err.println("fatal error!: sysOut");
				System.err.println(id);
				System.err.println(raw);

				return raw;
			}

			index = indexOf;

			if (getIsErrors()[i]) {
				String tag = errTag(true, false);
				sb.insert(index, tag);
				index += tag.length();
			}

			index += w.length();


			if (getIsErrors()[i]) {
				String tag = errTag(false, false);
				sb.insert(index, tag);
				index += tag.length();
			}
		}

		return sb.toString();
	}

	public ArrayList<String> getNGram (int n) {
		if (n == 1) {
			return uniGram;
		} else if (n == 2) {
			return biGram;
		} else if (n == 3) {
			return triGram;
		} else if (n == 4) {
			return fourGram;
		} else if (n == 5) {
			return fiveGram;
		} else if (n == 6) {
			return sixGram;
		} else {
			return null;
		}
	}

	public double[] getNGramResults (int n) {
		if (n == 1) {
			return uniGramResults;
		} else if (n == 2) {
			return biGramResults;
		} else if (n == 3) {
			return triGramResults;
		} else if (n == 4) {
			return fourGramResults;
		} else if (n == 5) {
			return fiveGramResults;
		} else if (n == 6) {
			return sixGramResults;
		} else {
			return null;
		}
	}

	/**
	 * n-gramのi番目の文字列をクエリとした検索結果数を格納する．
	 * @param n n-gram
	 * @param total 検索結果数
	 * @param i i番目
	 */
	public void setNGramTotal (int n, double total, int i) {
		if (n == 1) {
			setUniGramTotal(total, i);
		} else if (n == 2) {
			setBiGramTotal(total, i);
		} else if (n == 3) {
			setTriGramTotal(total, i);
		} else if (n == 4) {
			setFourGramTotal(total, i);
		} else if (n == 5) {
			setFiveGramTotal(total, i);
		} else if (n == 6) {
			setSixGramTotal(total, i);
		} else {
			System.err.print("setNGramTotal (" + n + ", " + total + ", " + i + ")");
		}
	}

	public void setUniGramTotal (double total, int i) {
		uniGramResults[i] = total;
	}

	public void setBiGramTotal(double total, int i) {
		biGramResults[i] = total;
	}

	public void setTriGramTotal (double total, int i) {
		triGramResults[i] = total;
	}

	public void setFourGramTotal(double total, int i) {
		fourGramResults[i] = total;
	}

	public void setFiveGramTotal(double total, int i) {
		fiveGramResults[i] = total;
	}

	public void setSixGramTotal(double total, int i) {
		sixGramResults[i] = total;
	}

	private void setNGram2 (int N, String[] words, ArrayList<String> nGram) {
		StringBuilder n = new StringBuilder(30);
		for (int i = 0; i < words.length - (N-1); i++) {
			for (int j = 0; j < N; j++) {
				n.append(words[i + j]);
				n.append(" ");
			}
			nGram.add((new String(n)).trim());
			n.setLength(0);
		}
	}

	//TODO 下6つを、そのうち、どうにかする。とりあえず動く。
	protected void setUniGram (String[] words) {
		uniGram = new ArrayList<String>(Arrays.asList(words));
		uniGramResults = new double[uniGram.size()];
	}

	protected void setBiGram (String[] words) {
		if (words.length < 2) {
			biGram = new ArrayList<String>(1);
			return;
		} else {
			biGram = new ArrayList<String>(words.length - 1);
			setNGram2(2, words, biGram);
			biGramResults = new double[words.length - 1];
		}
	}

	protected void setTriGram (String[] words) {
		if (words.length < 3) {
			triGram = new ArrayList<String>(1);
			return;
		} else {
			triGram = new ArrayList<String>(words.length - 2);
			setNGram2(3, words, triGram);
			triGramResults = new double[words.length - 2];
		}
	}

	protected void setFourGram (String[] words) {
		if (words.length < 4) {
			fourGram = new ArrayList<String>(1);
			return;
		} else {
			fourGram = new ArrayList<String>(words.length - 3);
			setNGram2(4, words, fourGram);
			fourGramResults = new double[words.length - 3];
		}
	}

	protected void setFiveGram (String[] words) {
		if (words.length < 5) {
			fiveGram = new ArrayList<String>(1);
			return;
		} else {
			fiveGram = new ArrayList<String>(words.length - 4);
			setNGram2(5, words, fiveGram);
			fiveGramResults = new double[words.length - 4];
		}
	}

	protected void setSixGram (String[] words) {
		if (words.length < 6) {
			sixGram = new ArrayList<String>(1);
			return;
		} else {
			sixGram = new ArrayList<String>(words.length - 5);
			setNGram2(6, words, sixGram);
			sixGramResults = new double[words.length - 5];
		}
	}

	private String[] getWords (Tree pos) {
		if (pos == null) {
			return null;
		}

		ArrayList<String> words = new ArrayList<String>();
		getWordsIter(pos, words);
		return (String[]) words.toArray(new String[0]);
	}

	private void getWordsIter (Tree pos, ArrayList<String> words) {
		if (pos.isLeaf()) {
			words.add(pos.node);
			return;
		}

		if (pos.hasLeaf()) {
			if (pos.node.equals(".") || pos.node.equals(",") ||
					pos.node.equals("''") || pos.node.equals("``") ||
					pos.node.endsWith("RB-")) {
				return;
			}

			if (pos.node.equals("POS")) {
				words.set(words.size()-1, words.get(words.size()-1) + pos.getChildNodes()[0].node);
				return;
			}

			if (pos.node.equals("RB")) {
				Tree t = pos.getChildNodes()[0];
				if (t.node.equals("n't")) {
					words.set(words.size()-1, words.get(words.size()-1) + t.node);
					return;
				}
			}

		}

		for (Tree t: pos.getChildNodes()) {
			getWordsIter(t, words);
		}
	}

	public void setPOS (String pos) {
		super.setPOS(pos);

		String[] words = getWords(posTree);
		setUniGram(words);
		setBiGram(words);
		setTriGram(words);
		setFourGram(words);
		setFiveGram(words);
		setSixGram(words);

		length = words.length;
		setIsErrors(new boolean[words.length]);
	}

	private void setWords () {
		String[] words = getWords(posTree);
		setUniGram(words);
		setBiGram(words);
		setTriGram(words);
		setFourGram(words);
		setFiveGram(words);
		setSixGram(words);

		length = words.length;
		setIsErrors(new boolean[words.length]);
	}

	public void setPosTree (edu.stanford.nlp.trees.Tree t) {
		super.setPosTree(t);
		setWords();
	}

	// とりあえず，動く
	public SentenceSE(String sentence) {
		super(sentence);
		sentence = sentence.trim();
		sentence = sentence.replaceAll("\\.|\\?|!", "");
/*
		for (int i = 0; i < sentence.length(); i++) {
			if (sentence.charAt(i) == ' ') count++;
		}
		*/

		String[] words = sentence.split(" ");
		setUniGram(words);
		setBiGram(words);
		setTriGram(words);
		setFourGram(words);
		setFiveGram(words);
		setSixGram(words);

		length = uniGram.size();
	}
}
