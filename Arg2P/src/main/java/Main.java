import java.io.*;
import java.util.*;
import it.unibo.tuprolog.argumentation.core.model.Graph;
import org.example.SolveStandardKt;

public class Main 
{
    public static void main(String[] args) 
    {
        try
        {
            File Arg2Prules = new File("regulative+compliance_rules.arg2p");
            File CORPUS = new File("CORPUS/Arg2P");

            if(args.length>0)Arg2Prules=new File(args[0]);
            if(args.length>1)CORPUS=new File(args[1]);

            InputStream is = new FileInputStream(Arg2Prules);
            InputStreamReader isr = new InputStreamReader(is);
            BufferedReader reader = new java.io.BufferedReader(isr);
            String rules = "";
            String buffer = "";
            while((buffer=reader.readLine())!=null)
                if(buffer.trim().isEmpty())continue;
                else if(buffer.trim().charAt(0)=='%')continue;
                else rules=rules+buffer+"\n";
            reader.close();
            isr.close();
            is.close();

			for(File ABoxFile:CORPUS.listFiles())
            {
                System.out.println("------------------------------------------------------------------------------------------------------------------------------------------------");
                String path = ABoxFile.getAbsolutePath();
                path = path.substring(path.indexOf("CORPUS\\Arg2P")+"CORPUS\\Arg2P".length()+1, path.length());
                System.out.println("FILE: "+path);
                System.out.println();
                System.out.flush();
            
                is = new FileInputStream(ABoxFile);
                isr = new InputStreamReader(is);
                reader = new java.io.BufferedReader(isr);
                ArrayList<String> allFacts = new ArrayList<String>();
                
                buffer = "";
                String factsTemp = "";
                int counter = 0;
                while((buffer=reader.readLine())!=null)
                {
                    if(buffer.trim().isEmpty())continue;
                    else if(buffer.trim().charAt(0)=='%')continue;
                    else 
                    {
                        if(buffer.indexOf("_"+counter)!=-1)factsTemp=factsTemp+buffer+"\n";
                        else
                        {
                            allFacts.add(factsTemp);
                            factsTemp=buffer+"\n";
                            counter++;
                        }
                    }
                }
                allFacts.add(factsTemp);//we still have one at the end...
                reader.close();
                isr.close();
                is.close();
				
                long startTime = System.currentTimeMillis();
                for(String facts:allFacts)
                {
                    SolveStandardKt.solve(rules + facts)
                    .getLabellings()
                    .stream()
                    .filter(x -> x.getLabel().equals("in"))
                    .map(x -> x.getArgument().getConclusion())
                    //.filter(x -> x.contains("obl") || x.contains("perm"))
                    //.filter(x -> x.contains("obl") || x.contains("compensate") || x.contains("perm"))
                    .filter(x -> x.contains("obl") || x.contains("violation"))
                    //.filter(x -> x.contains(""))
                    .forEach(System.out::println);
                    /**/
                }
                long stopTime = System.currentTimeMillis();
                System.out.println("Time: "+(stopTime-startTime)+"ms");
                System.out.flush();
            }
        }
        catch(Exception e)
        {
            System.out.println("Exception: "+e.getMessage());
        }
    }
}
