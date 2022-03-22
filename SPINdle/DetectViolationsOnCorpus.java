import java.io.*;

import spindle.ReasonerMain;

public class DetectViolationsOnCorpus 
{
    public static void main(String[] args) throws Exception 
    {
        File CORPUS = new File("./CORPUS/SPINdle");
        if(args.length>0)CORPUS=new File(args[0]);
        
        for(File ABoxFile:CORPUS.listFiles())
        {
            String path = ABoxFile.getAbsolutePath();
            path = path.substring(path.indexOf(".\\"), path.length());
            System.out.println("------------------------------------------------------------------------------------------------------------------------------------------------");
            System.out.println("FILE: "+path+"\n");
            ReasonerMain.main(new String[]{path});
        }
    }
}
