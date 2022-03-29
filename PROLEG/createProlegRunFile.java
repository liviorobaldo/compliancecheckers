
import java.io.*;

public class createProlegRunFile 
{
    private static File CORPUSproleg = new File("./CORPUS/PROLEG");
    private static File outputFile = new File("run.bat");
    public static void main(String[] args) 
    {
        try 
        {
            PrintWriter pw = new PrintWriter(new FileWriter(outputFile));
            
            //pw.write("echo off\n");
            pw.write("cd ./CORPUS\n");
            pw.write("del evaluationPROLEG.txt\n");
            pw.write("cd ..\n");
            pw.write("echo off\n");
            
            for(File file:CORPUSproleg.listFiles())writeQueriesOnFile(pw, file);

            pw.write("exit");            
            pw.flush();
        } 
        catch (Exception e) 
        {
            e.printStackTrace();
        }
    }
    
    public static void writeQueriesOnFile(PrintWriter pw, File file)throws Exception
    {
        //pw.write("echo on\n");
        pw.write("echo FILE: "+file.getName()+" >> ./CORPUS/evaluationPROLEG.txt\n");
        //pw.write("echo off\n");
        pw.write("java time>time.txt\n");
        pw.write("set /p BEFORE=<time.txt\n");
        pw.write("del time.txt\n");

        int max = getMaxIndex(file);
        while(max>=0)
        {
            pw.write("swipl -q -f ./CORPUS/PROLEG/"+file.getName()+" -t violation_ev_"+max+" >> ./CORPUS/evaluationPROLEG.txt\n");
            pw.write("swipl -q -f ./CORPUS/PROLEG/"+file.getName()+" -t violation_epr_"+max+" >> ./CORPUS/evaluationPROLEG.txt\n");
            pw.write("swipl -q -f ./CORPUS/PROLEG/"+file.getName()+" -t violation_epc_"+max+" >> ./CORPUS/evaluationPROLEG.txt\n");
            pw.write("swipl -q -f ./CORPUS/PROLEG/"+file.getName()+" -t violation_er_"+max+" >> ./CORPUS/evaluationPROLEG.txt\n");
            max--;
        }
        pw.write("java time>time.txt\n");
        pw.write("set /p AFTER=<time.txt\n");
        pw.write("del time.txt\n");
        pw.write("set /a \"c=%AFTER%-%BEFORE%\"\n");
        pw.write("echo Time: %c%ms >> ./CORPUS/evaluationPROLEG.txt\n");
        pw.write("echo ----------------------------------------------------------- >> ./CORPUS/evaluationPROLEG.txt\n");
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
