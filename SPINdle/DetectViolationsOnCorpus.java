import java.io.*;
import java.util.ArrayList;

import spindle.ReasonerMain;

public class DetectViolationsOnCorpus 
{
    public static void main(String[] args) throws Exception 
    {
        File CORPUS = new File("../DatasetGenerator/CORPUS/SPINdle");
        if(args.length>0)CORPUS=new File(args[0]);
        
            //We order the files according to the size
        ArrayList<File> temp = new ArrayList<File>();
        for(File ABoxFile:CORPUS.listFiles())if(ABoxFile.getName().indexOf("Size")!=-1)temp.add(ABoxFile);
        ArrayList<File> orderedFiles = new ArrayList<File>();
        while(temp.isEmpty()==false)
        {
            int min=0;
            for(int i=1;i<temp.size();i++)
            {
                String nmin = temp.get(min).getName();
                int smin = Integer.parseInt(nmin.substring(nmin.indexOf("Size")+4, nmin.indexOf("_",nmin.indexOf("Size"))));
                String ni = temp.get(i).getName();
                int si = Integer.parseInt(ni.substring(ni.indexOf("Size")+4, ni.indexOf("_",ni.indexOf("Size"))));
                if(si<smin)min=i;
            }
            orderedFiles.add(temp.remove(min));
        }
        
        boolean repeatFirst = true;
        for(int i=0;i<orderedFiles.size();i++)
        {
            File ABoxFile = orderedFiles.get(i);
			
            String path = ABoxFile.getAbsolutePath();
            path = path.substring(path.indexOf("..\\"), path.length());
            System.out.println("------------------------------------------------------------------------------------------------------------------------------------------------");
            if(repeatFirst==false)System.out.println("FILE: "+path+"\n");
            else System.out.println("FILE: ignore this\n");		
            ReasonerMain.main(new String[]{path});
            if(repeatFirst==true)
            {
                repeatFirst=false;
                i--;
            }
        }
    }
}
