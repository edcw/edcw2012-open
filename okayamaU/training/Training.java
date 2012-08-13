package training;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;

import search.SearchTotal;

import detect.Detection;

public class Training {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		Training t = new Training();
		TrainingSentence[] ts = t.getTrainingSentences();

		SearchTotal.setCache(100000);
		SearchTotal.inCache();

		Detection d = new Detection();

		StringBuilder senf = new StringBuilder(500000);
		StringBuilder wordf = new StringBuilder(500000);

		for (TrainingSentence s: ts) {
			d.searchTotalNumber(s);
			senf.append(d.makeFeatureForSentence(s, true));

			boolean isE = false;
			boolean[] isEs = s.getIsErrors();
			for (boolean e: isEs) {
				isE |= e;
			}

			if (isE) {
				wordf.append(d.makeFeatureForWords(s, true));
			}
		}

		SearchTotal.outCache();

		File file = new File("svm_training_data_sentence.txt");
		try {
			PrintWriter pw = new PrintWriter(file);
			pw.print(senf);
			pw.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}

		file = new File("svm_training_data_word.txt");
		try {
			PrintWriter pw = new PrintWriter(file);
			pw.print(wordf);
			pw.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}

	}


	public TrainingSentence[] getTrainingSentences() {
		ArrayList<TrainingSentence> ts = new ArrayList<TrainingSentence>(306);
		try {
			FileReader in = new FileReader("training_data.txt");
			BufferedReader br = new BufferedReader(in);
			String line;
			String tf;
			while ((line = br.readLine()) != null) {
				if ((tf = br.readLine()) == null)
						break;

				if (line.length() == 0)
					break;

				ts.add(new TrainingSentence(line.split(" "), tfToBool(tf)));
			}

			br.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return (TrainingSentence[]) ts.toArray(new TrainingSentence[0]);
	}

	public boolean[] tfToBool (String str) {
		String[] token = str.split(" ");

		boolean[] bs = new boolean[token.length];

		for (int i = 0; i < token.length; i++) {
			bs[i] = !token[i].equals("t");
		}

		return bs;
	}

	Training () {

	}
}
