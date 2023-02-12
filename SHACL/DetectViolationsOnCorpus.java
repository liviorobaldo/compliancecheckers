import org.apache.jena.util.iterator.*;
import java.util.*;
import java.io.*;
import org.apache.jena.rdf.model.*;
import org.apache.jena.util.FileUtils;
import org.apache.jena.ontology.*;

    //INTERESSANTE!!! QUESTI SONO DI TopBraid, NON DI JENA!
    //Ho provato ad usare quelle di Jena, ma non sono riuscito, sollevavano un vespaio di eccezioni...
import org.topbraid.jenax.util.JenaUtil;
import org.topbraid.shacl.rules.RuleUtil;

import org.topbraid.shacl.util.ModelPrinter;

public class DetectViolationsOnCorpus 
{
        //RICORDA SEMPRE: SHACL È SOLO PER VALIDARE RDF, NON OWL!!! SHACL è UN'ESTENSIONE DI RDF, NON DI OWL!!!
    public static void main(String[] args) throws Exception 
    {
        File TBoxFile = new File("licenceusecaseTBox.owl");
        File INDEXED_RULES = new File("INDEXED_RULES");
        File complianceRulesFile = new File("compliancerules.ttl");
        File CORPUS = new File("../DatasetGenerator/CORPUS/SHACL");
        File evaluationReport = new File("../DatasetGenerator/CORPUS/evaluationSHACL.txt");
        
        if(args.length>0)
        {
            TBoxFile = new File(args[0]);
            INDEXED_RULES = new File(args[1]);
            complianceRulesFile = new File(args[2]);
            CORPUS = new File(args[3]);
            evaluationReport = new File(args[4]);
        }
        
            //Load the TBox
        Model TBox = JenaUtil.createMemoryModel();
        FileInputStream fisTB = new FileInputStream(TBoxFile);
        TBox.read(fisTB, "urn:dummy", FileUtils.langTurtle);
        fisTB.close();
 
        while(evaluationReport.exists())evaluationReport.delete();
        PrintWriter pw = new PrintWriter(new FileWriter(evaluationReport));
        
        ArrayList<File> orderedFilesOnUseCases = orderFilesOnUseCases(INDEXED_RULES);
        
        boolean first=true;
        for(int i=0;i<orderedFilesOnUseCases.size();i++)
        {
            File regulativerulesFile = orderedFilesOnUseCases.get(i);
            System.out.println("Evaluating "+regulativerulesFile.getName());
        
            String indexUseCase = regulativerulesFile.getName().substring(regulativerulesFile.getName().indexOf("_")+1, regulativerulesFile.getName().indexOf(".")).trim();
            File ABox = new File(CORPUS.getAbsolutePath()+"/"+indexUseCase+"UseCases");
            
            ArrayList<File> orderedABoxFiles = orderFilesOnSize(ABox);
            for(int j=0;j<orderedABoxFiles.size();j++)
            {
                    //Start measuring the time
                long startTime = System.currentTimeMillis();

                File ABoxFile = orderedABoxFiles.get(j);
                
                    //For each ABox, we must take the regulativeRulesFile with the same number of use cases
                    //among those in the folder INDEXED_RULES.
                String numberUseCases = ABoxFile.getName();
                numberUseCases = numberUseCases.substring(numberUseCases.indexOf("_")+1, numberUseCases.indexOf("UseCases")).trim();
                File regulativeRulesFile = new File(INDEXED_RULES.getAbsolutePath()+"/regulativerules_"+numberUseCases+".ttl");

                    //Load the whole ontology (Load the ABox and add the TBox to it)
                Model ontology = JenaUtil.createMemoryModel();
                FileInputStream fisAB = new FileInputStream(ABoxFile);
                ontology.read(fisAB, "urn:dummy", FileUtils.langTurtle).add(TBox);
                fisAB.close();

                    //Inference regulative rules
                Model regulativerules = JenaUtil.createMemoryModel();
                FileInputStream fisRules = new FileInputStream(regulativeRulesFile);
                regulativerules.read(fisRules, "urn:dummy", FileUtils.langTurtle);
                fisRules.close();
                Model inferredModel = RuleUtil.executeRules(ontology, regulativerules, null, null).add(ontology);

                //System.out.println(ModelPrinter.get().print(inferredModel));

                Model complianceRules = JenaUtil.createMemoryModel();
                fisRules = new FileInputStream(complianceRulesFile);
                complianceRules.read(fisRules, "urn:dummy", FileUtils.langTurtle);
                fisRules.close();
                inferredModel = RuleUtil.executeRules(inferredModel, complianceRules, null, null).add(inferredModel);

                long stopTime = System.currentTimeMillis();
                double time = (((double)(stopTime-startTime))/1000);

                //System.out.println(ModelPrinter.get().print(inferredModel));

                Resource Violation = inferredModel.getResource("http://www.licenceusecaseonto.org/Violation");
                Property rdfType = inferredModel.getProperty("http://www.w3.org/1999/02/22-rdf-syntax-ns#type");
                Property referTo = inferredModel.getProperty("http://www.licenceusecaseonto.org/refer-to");
                List<Resource> violations = inferredModel.listSubjectsWithProperty(rdfType, Violation).toList();
                int counterViolations = 1;

                if(first==true)
                {
                    j--;
                    first=false;
                    continue;
                }
                
                System.out.println("\t...on "+ABoxFile.getName());
                pw.println("------------------------------------------------------------------------------------------------------------------------------------------------");
                pw.println(violations.size()+" violations found for dataset "+ABoxFile.getAbsolutePath());
                pw.println("TIME: "+time+"s");
                for(Resource v:violations)
                {
                    pw.println();
                    pw.println("\tViolation #"+counterViolations);counterViolations++;


                    Resource violated = inferredModel.listObjectsOfProperty(v, referTo).next().asResource();
                    pw.println("\t\tRESOURCE NAME: "+violated);
                    pw.println("\t\tRESOURCE CLASSES:");


                    List<RDFNode> classesOfViolated = inferredModel.listObjectsOfProperty(violated, rdfType).toList();
                    for(RDFNode classOfViolated:classesOfViolated)
                    {
                        if(classOfViolated.toString().indexOf("NamedIndividual")!=-1)continue;
                        pw.println("\t\t\t"+classOfViolated);

                        if(classOfViolated.toString().indexOf("Remove")!=-1)
                            pw.println("\t\t\tFORBIDDEN PUBLISH: "+getAssociatedPublishing(inferredModel, violated));
                    }
                }
                pw.flush();
            }
        }
    }
    
    private static Resource getAssociatedPublishing(Model inferredModel, Resource violated)throws Exception
    {
        Property rdfType = inferredModel.getProperty("http://www.w3.org/1999/02/22-rdf-syntax-ns#type");
        Property hasTheme = inferredModel.getProperty("http://www.licenceusecaseonto.org/has-theme");
        RDFNode result = inferredModel.listObjectsOfProperty(violated, hasTheme).toList().get(0);
        
        //Now we have to take the Publish action with the same use-case index of the result.
        String usecaseIndex = result.asResource().getLocalName();
        usecaseIndex = usecaseIndex.substring(usecaseIndex.indexOf("_")+1, usecaseIndex.indexOf("_", usecaseIndex.indexOf("_")+1)).trim();
        
        RDFNode Publish = inferredModel.getResource("http://www.licenceusecaseonto.org/Publish_"+usecaseIndex);
        ResIterator publishIndividuals = inferredModel.listSubjectsWithProperty(rdfType, Publish);
        while(publishIndividuals.hasNext())
        {
            Resource individual = publishIndividuals.nextResource();
            
            //System.out.println(individual.asResource().getLocalName());
            
            if(inferredModel.listObjectsOfProperty(individual, hasTheme).toList().get(0)==result)
                return individual;
        }
        throw new Exception("Cannot find the publish associated with the remove.");
    }
    
//SMALL UTILITY
        //Metodo che riceve la INDEXED_RULES in input e ritorna i files con le rules ordinate sul loro indice (quello dello use case)
    public static ArrayList<File> orderFilesOnUseCases(File INDEXED_RULES)
    {
        ArrayList<File> temp = new ArrayList<File>();
        for(File f:INDEXED_RULES.listFiles())temp.add(f);
        ArrayList<File> orderedFiles = new ArrayList<File>();
        while(temp.isEmpty()==false)
        {
            int min = 0;
            String usecaseMin = temp.get(0).getName().substring(temp.get(0).getName().indexOf("_")+1, temp.get(0).getName().indexOf(".")).trim();
            for(int i=1;i<temp.size();i++)
            {
                String usecase = temp.get(i).getName().substring(temp.get(i).getName().indexOf("_")+1, temp.get(i).getName().indexOf(".")).trim();
                if(Integer.parseInt(usecase)<Integer.parseInt(usecaseMin))
                {
                    min=i;
                    usecaseMin=usecase;
                }
            }
            orderedFiles.add(temp.remove(min));
        }
        return orderedFiles;
    }
    
        //Come sopra, but this takes in input a folder "XUseCases", e.g., "10UseCases" and returns the files ordered on the size.
    public static ArrayList<File> orderFilesOnSize(File ABox)
    {
        //We order the files according to the size
        ArrayList<File> temp = new ArrayList<File>();
        for(File f:ABox.listFiles())temp.add(f);
        ArrayList<File> orderedFiles = new ArrayList<File>();
        
        while(temp.isEmpty()==false)
        {
            int min = 0;
            String sizeMin = temp.get(0).getName().substring(temp.get(0).getName().indexOf("_Size")+5, temp.get(0).getName().indexOf("_", temp.get(0).getName().indexOf("_Size")+5)).trim();
            for(int i=1;i<temp.size();i++)
            {
                String size = temp.get(i).getName().substring(temp.get(i).getName().indexOf("_Size")+5, temp.get(i).getName().indexOf("_", temp.get(i).getName().indexOf("_Size")+5)).trim();
                if(Integer.parseInt(size)<Integer.parseInt(sizeMin))
                {
                    min=i;
                    sizeMin=size;
                }
            }
            orderedFiles.add(temp.remove(min));
        }
        return orderedFiles;
    }
}