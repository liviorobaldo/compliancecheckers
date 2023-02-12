import java.io.*;

public class createProlegRunFile 
{
    private static File CORPUS = new File("../DatasetGenerator/CORPUS/PROLEG");
    private static File outputFile = new File("run2.bat");
    public static void main(String[] args) 
    {
        try 
        {
            while(outputFile.exists())outputFile.delete();
            PrintWriter pw = new PrintWriter(new FileWriter(outputFile));
            writeQueriesOnFile(pw, CORPUS);  
            pw.flush();
        } 
        catch (Exception e) 
        {
            e.printStackTrace();
        }
    }
    
    public static void writeQueriesOnFile(PrintWriter pw, File CORPUS)throws Exception
    {
        for(File subdir:CORPUS.listFiles())
        {
            for(File file:subdir.listFiles())
            {
                pw.write("@echo FILE: "+file.getName()+" >> ../DatasetGenerator/CORPUS/evaluationPROLEG.txt\n");
                pw.write("@java time>time.txt\n");
                pw.write("@set /p BEFORE=<time.txt\n");
                pw.write("@del time.txt\n");

                pw.write("swipl -q -f ../DatasetGenerator/CORPUS/PROLEG/"+subdir.getName()+"/"+file.getName()+" -t goal >> ../DatasetGenerator/CORPUS/evaluationPROLEG.txt\n");
                pw.write("@java time>time.txt\n");
                pw.write("@set /p AFTER=<time.txt\n");
                pw.write("@del time.txt\n");
                pw.write("@set /a \"c=%AFTER%-%BEFORE%\"\n");
                pw.write("@echo Time: %c%ms >> ../DatasetGenerator/CORPUS/evaluationPROLEG.txt\n");
                pw.write("@echo ----------------------------------------------------------- >> ../DatasetGenerator/CORPUS/evaluationPROLEG.txt\n");
            }
        }
    }
    
    public static int getMaxIndex(File file)throws Exception
    {
        InputStream is = new FileInputStream(file);
        InputStreamReader isr = new InputStreamReader(is, java.nio.charset.StandardCharsets.UTF_8.name());
        BufferedReader br = new java.io.BufferedReader(isr);
        
        String buffer = null;
        int max = 0;
        while((buffer=br.readLine())!=null)
        {
            buffer = buffer.trim();
            if(buffer.indexOf("fact(")!=-1)
            {
                buffer = buffer.substring(buffer.lastIndexOf("_")+1, buffer.length()).trim();
                buffer = buffer.substring(0, buffer.indexOf(")")).trim();
                try{if(Integer.parseInt(buffer)>max)max=Integer.parseInt(buffer);}
                catch(Exception e){}//if there is an exception, we ignore.
            }
        }
        
        br.close();
        isr.close();
        is.close();
        return max;
    }
}
