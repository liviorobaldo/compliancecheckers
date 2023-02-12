import java.io.*;
import java.util.*;

public class createDLV2RunFile 
{
    private static String aspRulesPath = ".\\INDEXED_RULES";
    private static String aspFactsPath = "..\\..\\DatasetGenerator\\CORPUS\\ASP";
    private static String evaluationFilePath = "..\\..\\DatasetGenerator\\CORPUS\\evaluationASP-dlv2.txt";
    private static String outputFilePath = ".\\run2.bat";
    public static void main(String[] args) 
    {
        try 
        {
            File aspRules = new File(aspRulesPath);
            File aspFacts = new File(aspFactsPath);
            File outputFile = new File(outputFilePath);
    
            while(outputFile.exists())outputFile.delete();
            PrintWriter pw = new PrintWriter(new FileWriter(outputFile));
            pw.println("del "+evaluationFilePath);
            
            ArrayList<String> filesRules = getOrderedRules(aspRules);
            for(String fileRules:filesRules)
            {
                String indexUseCase = fileRules.substring(fileRules.lastIndexOf("_")+1, fileRules.lastIndexOf(".")).trim();
                
                pw.println("python dlv2.py "+
                    aspRulesPath+"\\"+fileRules+" -f "+
                    aspFactsPath+"\\"+indexUseCase+"UseCases >> "+evaluationFilePath);
            }
            
            pw.flush();
            pw.close();
        } 
        catch(Exception e) 
        {
            e.printStackTrace();
        }
    }
    
    public static ArrayList<String> getOrderedRules(File aspRules)
    {        
        ArrayList<String> temp = new ArrayList<String>();
        for(File f:aspRules.listFiles())temp.add(f.getName());
        
        ArrayList<String> ret = new ArrayList<String>();
        while(temp.isEmpty()==false)
        {
            String indexUseCaseMin = temp.get(0).substring(temp.get(0).lastIndexOf("_")+1, temp.get(0).lastIndexOf(".")).trim();
            int imin = 0;
            for(int i=1;i<temp.size();i++)
            {
                String indexUseCase = temp.get(i).substring(temp.get(i).lastIndexOf("_")+1, temp.get(i).lastIndexOf(".")).trim();
                if(Integer.parseInt(indexUseCase)<Integer.parseInt(indexUseCaseMin))
                {
                    imin = i;
                    indexUseCaseMin = indexUseCase;
                }
            }
            
            ret.add(temp.remove(imin));
        }
        
        return ret;
    }
    /**/
}