import java.io.File;
import com.aliasi.util.Files;

import com.aliasi.classify.ConfusionMatrix;
import com.aliasi.classify.DynamicLMClassifier;
import com.aliasi.classify.LMClassifier;
import com.aliasi.classify.ClassifierEvaluator;
import com.aliasi.classify.JointClassification;
import com.aliasi.util.AbstractExternalizable;

import java.io.IOException;

public class ClassifyNews {

    private static File TRAINING_DIR 
        = new File("../../data/fourNewsGroups/4news-train");

    private static File TESTING_DIR 
        =  new File("../../data/fourNewsGroups/4news-test");

    private static String[] CATEGORIES 
        = { "soc.religion.christian",
            "talk.religion.misc",
            "alt.atheism",
            "misc.forsale" };
    
    private static int NGRAM_SIZE = 6;

    public static void main(String[] args) 
        throws ClassNotFoundException, IOException {
        
        DynamicLMClassifier classifier 
            = DynamicLMClassifier.createNGramProcess(CATEGORIES,NGRAM_SIZE);

        for(int i=0; i<CATEGORIES.length; ++i) {
            File classDir = new File(TRAINING_DIR,CATEGORIES[i]);
            if (!classDir.isDirectory()) {
                System.out.println("Could not find training directory=" 
                                   + classDir);
                System.out.println("Have you unpacked 4 newsgroups?");
            }

            String[] trainingFiles = classDir.list();
            for (int j = 0; j < trainingFiles.length; ++j) {
                File file = new File(classDir,trainingFiles[j]);
                String text = Files.readFromFile(file);
                System.out.println("Training on " + CATEGORIES[i] + "/" + trainingFiles[j]);
                classifier.train(CATEGORIES[i],text);
            }
        }
        //compiling
        System.out.println("Compiling");
        LMClassifier compiledClassifier 
            = (LMClassifier) AbstractExternalizable.compile(classifier);

        //testing 
        //ConfusionMatrix confMatrix = new ConfusionMatrix();
        ClassifierEvaluator evaluator = new ClassifierEvaluator(compiledClassifier,CATEGORIES);
        for(int i = 0; i < CATEGORIES.length; ++i) {
            File classDir = new File(TESTING_DIR,CATEGORIES[i]);
            String[] testingFiles = classDir.list();
            for (int j=0; j<testingFiles.length;  ++j) {
                String text = Files.readFromFile(new File(classDir,testingFiles[j]));
                System.out.print("Testing on " + CATEGORIES[i] + "/" + testingFiles[j] + " ");
                evaluator.addCase(CATEGORIES[i],text);
                JointClassification jc = 
                    compiledClassifier.classify(text);
                String bestCategory = jc.bestCategory();
                String details = jc.toString();
                System.out.println("Got best category of: " + bestCategory);
                System.out.println(jc.toString());
                System.out.println("---------------");
            }
        }
        ConfusionMatrix confMatrix = evaluator.confusionMatrix();
        System.out.println("Total Accuracy: " + confMatrix.totalAccuracy());
    }
}
