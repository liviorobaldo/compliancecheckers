import org.semanticweb.owlapi.apibinding.OWLManager;
import org.semanticweb.owlapi.model.*;
import org.semanticweb.owlapi.formats.TurtleDocumentFormat;

import java.util.*;
import java.io.*;
import java.util.Random;

public class DatasetGenerator 
{
        //Generator parameters
    
        //Define the number of times that norms are repeated. We put it in an array because we want at least 1 (but then 10, 20, etc.)
    private final static int[] numbersOfUseCases = new int[]{10,20,30};
    private final static int minSize = 10;//Define the minimum size of a sample (inclusive)
    private final static int maxSize = 50;//Define the maximum size of a sample (inclusive)
    private final static int stepSize = 10;//Define the step of samples sizes
    private final static int probability = 50;//Define percentage [0-100] of an Rexist to be generated
    
    private static File CORPUS = new File("./CORPUS");
    
        //For some of the reasoners below, we also create synthetic datasets by indexing them on the number of rules;
        //all other reasoners, instead, only index the number of facts.
        //For the former, we must also created indexed rules; we are indexing the predicates (e.g., evaluate_1, evaluate_2, etc.),
        //so we must rewrite the if-then rules for them to use the indexed predicates.
        //We take the main rules and we create copies on the INDEXED_RULES folder.
    private static File SHACL_indexedRulesFolder = new File("../SHACL/INDEXED_RULES");
    private static File DLV_indexedRulesFolder = new File("../DLV/INDEXED_RULES");
    private static File DLV2_indexedRulesFolder = new File("../ASP/DLV2/INDEXED_RULES");
    private static File Clingo_indexedRulesFolder = new File("../ASP/Clingo/INDEXED_RULES");
    private static File Proleg_indexedRulesFolder = new File("../PROLEG/INDEXED_RULES");
        //In SPINdle we have to ground the rules. The rules in SPINdle_regulative+compliance_rules.dfl are propositional.
        //So, first we generate all indexed facts, then we already duplicate the rules for the facts in each state of affair.
        //We drop the grounded rules and facts already in the corpus folder, so there is no need to create indexed rules.
    private static File SPINdleRules = new File("../SPINdle/SPINdle_regulative+compliance_rules.dfl");
    
    public static void main(String[] args) 
    {
        try 
        {
            if(args.length>0)CORPUS=new File(args[0]);
            recreateCORPUSfolder(CORPUS);
			
            while(SHACL_indexedRulesFolder.listFiles().length>0)SHACL_indexedRulesFolder.listFiles()[0].delete();
            while(DLV_indexedRulesFolder.listFiles().length>0)DLV_indexedRulesFolder.listFiles()[0].delete();
            while(DLV2_indexedRulesFolder.listFiles().length>0)DLV2_indexedRulesFolder.listFiles()[0].delete();
            while(Clingo_indexedRulesFolder.listFiles().length>0)Clingo_indexedRulesFolder.listFiles()[0].delete();
            while(Proleg_indexedRulesFolder.listFiles().length>0)Proleg_indexedRulesFolder.listFiles()[0].delete();
            
            for(int numberOfUseCases:numbersOfUseCases) 
            {
                    //We create corresponding rules for the assertions in outputFile.
                createIndexRulesFilesSHACL(SHACL_indexedRulesFolder, numberOfUseCases);
                createIndexRulesFilesDLV(DLV_indexedRulesFolder, numberOfUseCases);
                createIndexRulesFilesDLV2andClingo(DLV2_indexedRulesFolder, numberOfUseCases);
                createIndexRulesFilesDLV2andClingo(Clingo_indexedRulesFolder, numberOfUseCases);
                createIndexRulesFilesProleg(Proleg_indexedRulesFolder, numberOfUseCases);
                
                        //Generate samples
                for(int size=minSize; size<=maxSize; size+=stepSize) 
                {
                    System.out.println("Save ABoxes - numberUseCases: "+numberOfUseCases+", SIZE:"+size+", PERCENTAGE:"+probability);

                    boolean[][][] distribution = new boolean[numberOfUseCases][size][];
                    for(int i=0;i<numberOfUseCases;i++)for(int j=0;j<size;j++)distribution[i][j]=getDistribution();

                    shaclABox(CORPUS, numberOfUseCases, size, distribution);
                    aspABox(CORPUS, numberOfUseCases, size, distribution);
                    prolegABox(CORPUS, numberOfUseCases, size, distribution);
                    SPINdleABox(CORPUS, numberOfUseCases, size, distribution);
                    arg2pABox(new File(CORPUS.getAbsolutePath()+"/Arg2P/arg2pABox_Size"+size+"_Probability"+probability+".arg2p"), size, distribution);
                }
            }
        } 
        catch (Exception e) 
        {
            e.printStackTrace();
        }
    }
    
        //returns an array of random number from 0 to 100. Each represents the probability that one action really exists
    public static boolean[] getDistribution()
    {
        Random rand = new Random();
        return new boolean[]
        {
            rand.nextInt(100)<probability,
            rand.nextInt(100)<probability,
            rand.nextInt(100)<probability,
            rand.nextInt(100)<probability,
            rand.nextInt(100)<probability,
            rand.nextInt(100)<probability,
            rand.nextInt(100)<probability
        };
    }

//SHACL
    public static void createIndexRulesFilesSHACL(File indexedRulesFolder, int numbersOfUseCases)throws Exception
    {
            //We first collects all the lines in the files...
        File regulativerules = new File(indexedRulesFolder.getParentFile().getAbsolutePath()+"/regulativerules.ttl");
        File INDEXEDregulativerules = new File(indexedRulesFolder.getAbsolutePath()+"/regulativerules_"+numbersOfUseCases+".ttl");
        
        InputStream isRR = new FileInputStream(regulativerules);
        InputStreamReader isrRR = new InputStreamReader(isRR, java.nio.charset.StandardCharsets.UTF_8.name());
        BufferedReader brRR = new java.io.BufferedReader(isrRR);
        ArrayList<String> rrLines = new ArrayList<String>();
        String buffer = null;
        while((buffer=brRR.readLine())!=null)rrLines.add(buffer);
        brRR.close();
        isrRR.close();
        isRR.close();
        
            //then in the output files we put the same rules but with the relevant predicates indexed
            //(and the @prefix we put only once)
        PrintWriter pwRR = new PrintWriter(new FileWriter(INDEXEDregulativerules));
        boolean prefixesAlreadyWritten = false;
        for(int indexUseCase=0; indexUseCase<numbersOfUseCases; indexUseCase++) 
        {
            for(String line:rrLines)
            {
                if((line.indexOf("@prefix")!=-1)&&(prefixesAlreadyWritten==true))continue;
                
                line = line.replaceAll("Approve", "Approve_"+indexUseCase)
                        .replaceAll("Comment", "Comment_"+indexUseCase)
                        .replaceAll("Commission", "Commission_"+indexUseCase)
                        .replaceAll("Evaluate", "Evaluate_"+indexUseCase)
                        .replaceAll("Grant", "Grant_"+indexUseCase)
                        .replaceAll("Licence", "Licence_"+indexUseCase)
                        .replaceAll("Licensee", "Licensee_"+indexUseCase)
                        .replaceAll("Licensor", "Licensor_"+indexUseCase)
                        .replaceAll("Product", "Product_"+indexUseCase)
                        .replaceAll("Publish", "Publish_"+indexUseCase)
                        .replaceAll("Remove", "Remove_"+indexUseCase)
                        .replaceAll("Result", "Result_"+indexUseCase)
                        .replaceAll("is-licence-of", "is-licence-of_"+indexUseCase)
                        .replaceAll("is-comment-of", "is-comment-of_"+indexUseCase)
                        .replaceAll("ExceptionArt1b", "ExceptionArt1b_"+indexUseCase)
                        .replaceAll("ExceptionArt2b", "ExceptionArt2b_"+indexUseCase)
                        .replaceAll("ExceptionArt4a", "ExceptionArt4a_"+indexUseCase)
                        .replaceAll("ExceptionArt3b", "ExceptionArt3b_"+indexUseCase)
                        .replaceAll("has-result", "has-result_"+indexUseCase)
                        .replaceAll("has-receiver", "has-receiver_"+indexUseCase);

                        /**
                        //we cannot index these as they are also in compliancerules.ttl
                        .replaceAll("Prohibited", "Prohibited_"+indexUseCase)
                        .replaceAll("Permitted", "Permitted_"+indexUseCase)
                        .replaceAll("Obligatory", "Obligatory_"+indexUseCase)
                        .replaceAll("Rexist", "Rexist_"+indexUseCase);
                        .replaceAll("compensate", "compensate_"+indexUseCase)
                        .replaceAll("Violation", "Violation_"+indexUseCase)
                        .replaceAll("refer-to", "refer-to_"+indexUseCase)
                        .replaceAll("has-agent", "has-agent_"+indexUseCase)
                        .replaceAll("has-theme", "has-theme_"+indexUseCase)
                        /**/
                
                pwRR.println(line);
            }
            
            prefixesAlreadyWritten = true;
        }
        
        pwRR.close();
    }
    
    public static void shaclABox(File CORPUS, int numberOfUseCases, int size, boolean[][][] distribution)throws Exception
    {
            //Create ABox ontology.
        OWLOntologyManager manager = OWLManager.createOWLOntologyManager();
        IRI iri = IRI.create("http://www.licenceusecaseonto.org/");
        OWLOntology ontology = manager.createOntology(iri);

            //OWL Classes in the licence use case ontology
        OWLDataFactory factory = manager.getOWLDataFactory();

            //In the cycle below, we (randomly) insert the actions that Rexist.
        OWLClass rexist = factory.getOWLClass(IRI.create("http://www.licenceusecaseonto.org/Rexist"));
        OWLClass action = factory.getOWLClass(IRI.create(iri+"Action"));
        for(int indexUseCase=0; indexUseCase<numberOfUseCases; indexUseCase++)
        {
                //We create new classes in the ontology on the index.
            OWLClass approve = factory.getOWLClass(IRI.create(iri+"Approve_"+indexUseCase));
            OWLAxiom declareC = factory.getOWLDeclarationAxiom(approve);manager.addAxiom(ontology, declareC);
            OWLAxiom subclassAx = factory.getOWLSubClassOfAxiom(approve, action);manager.addAxiom(ontology, subclassAx);

            OWLClass comment = factory.getOWLClass(IRI.create(iri + "Comment_"+indexUseCase));
            declareC=factory.getOWLDeclarationAxiom(comment);manager.addAxiom(ontology, declareC);
            subclassAx = factory.getOWLSubClassOfAxiom(comment, action);manager.addAxiom(ontology, subclassAx);

            OWLClass commission = factory.getOWLClass(IRI.create(iri + "Commission_"+indexUseCase));
            declareC=factory.getOWLDeclarationAxiom(commission);manager.addAxiom(ontology, declareC);
            subclassAx = factory.getOWLSubClassOfAxiom(commission, action);manager.addAxiom(ontology, subclassAx);

            OWLClass evaluate = factory.getOWLClass(IRI.create(iri + "Evaluate_"+indexUseCase));
            declareC=factory.getOWLDeclarationAxiom(evaluate);manager.addAxiom(ontology, declareC);
            subclassAx = factory.getOWLSubClassOfAxiom(evaluate, action);manager.addAxiom(ontology, subclassAx);

            OWLClass grant = factory.getOWLClass(IRI.create(iri + "Grant_"+indexUseCase));
            declareC=factory.getOWLDeclarationAxiom(grant);manager.addAxiom(ontology, declareC);
            subclassAx = factory.getOWLSubClassOfAxiom(grant, action);manager.addAxiom(ontology, subclassAx);

            OWLClass licence = factory.getOWLClass(IRI.create(iri + "Licence_"+indexUseCase));
            declareC=factory.getOWLDeclarationAxiom(licence);manager.addAxiom(ontology, declareC);
            subclassAx = factory.getOWLSubClassOfAxiom(licence, action);manager.addAxiom(ontology, subclassAx);

            OWLClass licensee = factory.getOWLClass(IRI.create(iri + "Licensee_"+indexUseCase));
            declareC=factory.getOWLDeclarationAxiom(licensee);manager.addAxiom(ontology, declareC);
            subclassAx = factory.getOWLSubClassOfAxiom(licensee, action);manager.addAxiom(ontology, subclassAx);

            OWLClass licensor = factory.getOWLClass(IRI.create(iri + "Licensor_"+indexUseCase));
            declareC=factory.getOWLDeclarationAxiom(licensor);manager.addAxiom(ontology, declareC);
            subclassAx = factory.getOWLSubClassOfAxiom(licensor, action);manager.addAxiom(ontology, subclassAx);

            OWLClass product = factory.getOWLClass(IRI.create(iri + "Product_"+indexUseCase));
            declareC=factory.getOWLDeclarationAxiom(product);manager.addAxiom(ontology, declareC);
            subclassAx = factory.getOWLSubClassOfAxiom(product, action);manager.addAxiom(ontology, subclassAx);

            OWLClass publish = factory.getOWLClass(IRI.create(iri + "Publish_"+indexUseCase));
            declareC=factory.getOWLDeclarationAxiom(publish);manager.addAxiom(ontology, declareC);
            subclassAx = factory.getOWLSubClassOfAxiom(publish, action);manager.addAxiom(ontology, subclassAx);

            OWLClass remove = factory.getOWLClass(IRI.create(iri + "Remove_"+indexUseCase));
            declareC=factory.getOWLDeclarationAxiom(remove);manager.addAxiom(ontology, declareC);
            subclassAx = factory.getOWLSubClassOfAxiom(remove, action);manager.addAxiom(ontology, subclassAx);

            OWLClass result = factory.getOWLClass(IRI.create(iri + "Result_"+indexUseCase));
            declareC=factory.getOWLDeclarationAxiom(result);manager.addAxiom(ontology, declareC);
            subclassAx = factory.getOWLSubClassOfAxiom(result, action);manager.addAxiom(ontology, subclassAx);

            for(int i=0; i<size; i++) 
            {
                System.out.println("Creating SHACL use case: "+indexUseCase+", with size "+size);
                
                
                    /******************* Individual *******************/
                    //To make it simpler, we generate all *indexed* individuals, both the actions (approve, evaluate, etc.)
                    //and the persons or objects (licensee, licensor, result, etc.).
                    //Then, we will randomly assign "Rexist" to the six actions.

                    //Persons and objects
                OWLIndividual x = createIndividual(manager, factory, ontology, licensee, iri+"x_"+indexUseCase+"_"+i);
                OWLIndividual y = createIndividual(manager, factory, ontology, licensor, iri+"y_"+indexUseCase+"_"+i);
                OWLIndividual r = createIndividual(manager, factory, ontology, result, iri+"r_"+indexUseCase+"_"+i);
                OWLIndividual p = createIndividual(manager, factory, ontology, product, iri+"p_"+indexUseCase+"_"+i);
                OWLIndividual l = createIndividual(manager, factory, ontology, licence, iri+"l_"+indexUseCase+"_"+i);
                OWLIndividual c = createIndividual(manager, factory, ontology, comment, iri+"c_"+indexUseCase+"_"+i);
                addObjectProperty(manager, factory, ontology, iri + "is-licence-of_"+indexUseCase, l, p);

                    //TBox:Evaluate(ev) + thematic roles
                OWLIndividual ev = createIndividual(manager, factory, ontology, evaluate, iri+"ev_"+indexUseCase+"_"+i);
                addObjectProperty(manager, factory, ontology, iri + "has-agent", ev, x);
                addObjectProperty(manager, factory, ontology, iri + "has-theme", ev, p);
                addObjectProperty(manager, factory, ontology, iri + "has-result_"+indexUseCase, ev, r);

                    //TBox:Publish(epr) + thematic roles
                OWLIndividual epr = createIndividual(manager, factory, ontology, publish, iri+"epr_"+indexUseCase+"_"+i);
                addObjectProperty(manager, factory, ontology, iri + "has-agent", epr, x);
                addObjectProperty(manager, factory, ontology, iri + "has-theme", epr, r);

                    //TBox:Approve(ea) + thematic roles
                OWLIndividual ea = createIndividual(manager, factory, ontology, approve, iri+"ea_"+indexUseCase+"_"+i);
                addObjectProperty(manager, factory, ontology, iri + "has-agent", ea, y);
                addObjectProperty(manager, factory, ontology, iri + "has-theme", ea, epr);

                    //TBox:Commission(ec) + thematic roles
                OWLIndividual ec = createIndividual(manager, factory, ontology, commission, iri+"ec_"+indexUseCase+"_"+i);
                addObjectProperty(manager, factory, ontology, iri + "has-theme", ec, ev);

                    //TBox:Grant(eg) + thematic roles
                OWLIndividual eg = createIndividual(manager, factory, ontology, grant, iri+"eg_"+indexUseCase+"_"+i);
                addObjectProperty(manager, factory, ontology, iri + "has-agent", eg, y);
                addObjectProperty(manager, factory, ontology, iri + "has-theme", eg, l);
                addObjectProperty(manager, factory, ontology, iri + "has-receiver_"+indexUseCase, eg, x);

                    // TBox:Publish(epc) + thematic roles
                OWLIndividual epc = createIndividual(manager, factory, ontology, publish, iri+"epc_"+indexUseCase+"_"+i);
                addObjectProperty(manager, factory, ontology, iri + "has-agent", epc, x);
                addObjectProperty(manager, factory, ontology, iri + "has-theme", epc, c);    
                addObjectProperty(manager, factory, ontology, iri + "is-comment-of_"+indexUseCase, c, ev);

                    // TBox:Remove(er) + thematic roles
                OWLIndividual er = createIndividual(manager, factory, ontology, remove, iri+"er_"+indexUseCase+"_"+i);
                addObjectProperty(manager, factory, ontology, iri + "has-agent", er, x);
                addObjectProperty(manager, factory, ontology, iri + "has-theme", er, r);

                    //We randomly assign Rexist to the six actions
                if(distribution[indexUseCase][i][0])addIndividualToClass(manager, factory, ontology, rexist, ea);
                if(distribution[indexUseCase][i][1])addIndividualToClass(manager, factory, ontology, rexist, ec);
                if(distribution[indexUseCase][i][2])addIndividualToClass(manager, factory, ontology, rexist, ev);
                if(distribution[indexUseCase][i][3])addIndividualToClass(manager, factory, ontology, rexist, eg);
                if(distribution[indexUseCase][i][4])addIndividualToClass(manager, factory, ontology, rexist, epc);
                if(distribution[indexUseCase][i][5])addIndividualToClass(manager, factory, ontology, rexist, epr);   
                if(distribution[indexUseCase][i][6])addIndividualToClass(manager, factory, ontology, rexist, er);
            }
        }

            //We create a new subfolder in CORPUS with the index of the use case (if it was not already created 
            //in the previous calls of the function). We store the ABox there.
        File subfolder = new File(CORPUS.getAbsolutePath()+"/SHACL/"+numberOfUseCases+"UseCases");
        if(subfolder.exists()==false)subfolder.mkdir();
        File outputFile = new File(subfolder.getAbsolutePath()+"/shaclABox_"+numberOfUseCases+"UseCases_Size"+size+"_Probability"+probability+".owl");
        manager.saveOntology(ontology, new TurtleDocumentFormat(), IRI.create(outputFile.toURI()));
    }
    
    public static OWLIndividual createIndividual(OWLOntologyManager manager, OWLDataFactory factory,
                                              OWLOntology ontology, OWLClass owlClass, String iri) {

        OWLIndividual individual = factory.getOWLNamedIndividual(IRI.create(iri));
        OWLAxiom axiom = factory.getOWLClassAssertionAxiom(owlClass, individual);
        manager.addAxiom(ontology, axiom);
        return individual;
    }
    
    public static void addIndividualToClass(OWLOntologyManager manager, OWLDataFactory factory,
                                              OWLOntology ontology, OWLClass owlClass, OWLIndividual individual) {

        OWLAxiom axiom = factory.getOWLClassAssertionAxiom(owlClass, individual);
        manager.addAxiom(ontology, axiom);
    }

    public static void addObjectProperty(OWLOntologyManager manager, OWLDataFactory factory,
                                         OWLOntology ontology, String propertyIRI,
                                         OWLIndividual subject, OWLIndividual object) {

        OWLObjectProperty objectProperty = factory.getOWLObjectProperty(IRI.create(propertyIRI));
        OWLAxiom axiom = factory.getOWLObjectPropertyAssertionAxiom(objectProperty, subject, object);
        manager.addAxiom(ontology, axiom);
    }

//ASP (DLV2 and Clingo)
    public static void createIndexRulesFilesDLV(File indexedRulesFolderDLV, int numbersOfUseCases)throws Exception
    {
            //We first collects all the lines in the files...
        File regulativerules = new File(indexedRulesFolderDLV.getParentFile().getAbsolutePath()+"/regulative+compliance_rules.dlv");
        File INDEXEDregulativerules = new File(indexedRulesFolderDLV.getAbsolutePath()+"/regulative+compliance_rules_"+numbersOfUseCases+".dlv");
        
        InputStream isRR = new FileInputStream(regulativerules);
        InputStreamReader isrRR = new InputStreamReader(isRR, java.nio.charset.StandardCharsets.UTF_8.name());
        BufferedReader brRR = new java.io.BufferedReader(isrRR);
        ArrayList<String> rrLines = new ArrayList<String>();
        String buffer = null;
        while((buffer=brRR.readLine())!=null)rrLines.add(buffer);
        brRR.close();
        isrRR.close();
        isRR.close();
        
            //then in the output files we put the same rules but with the relevant predicates indexed
            //(and the @prefix we put only once)
        PrintWriter pwRR = new PrintWriter(new FileWriter(INDEXEDregulativerules));
        boolean prefixesAlreadyWritten = false;
        for(int indexUseCase=0; indexUseCase<numbersOfUseCases; indexUseCase++) 
        {
            for(String line:rrLines)
            {
                if((line.indexOf("@prefix")!=-1)&&(prefixesAlreadyWritten==true))continue;
                
                line = line.replaceAll("approve", "approve_"+indexUseCase)
                        .replaceAll("comment", "comment_"+indexUseCase)
                        .replaceAll("commission", "commission_"+indexUseCase)
                        .replaceAll("evaluate", "evaluate_"+indexUseCase)
                        .replaceAll("grant", "grant_"+indexUseCase)
                        .replaceAll("licence", "licence_"+indexUseCase)
                        .replaceAll("licensee", "licensee_"+indexUseCase)
                        .replaceAll("licensor", "licensor_"+indexUseCase)
                        .replaceAll("product", "product_"+indexUseCase)
                        .replaceAll("publish", "publish_"+indexUseCase)
                        .replaceAll("remove", "remove_"+indexUseCase)
                        .replaceAll("result", "result_"+indexUseCase)                
                        /**/
                        .replaceAll("isLicenceOf", "isLicenceOf_"+indexUseCase)
                        .replaceAll("isCommentOf", "isCommentOf_"+indexUseCase)
                        .replaceAll("prohibited", "prohibited_"+indexUseCase)
                        .replaceAll("permitted", "permitted_"+indexUseCase)
                        .replaceAll("obligatory", "obligatory_"+indexUseCase)
                        .replaceAll("rexist", "rexist_"+indexUseCase)
                        .replaceAll("compensate", "compensate_"+indexUseCase)
                        .replaceAll("violation", "violation_"+indexUseCase)
                        .replaceAll("exceptionArt1b", "exceptionArt1b_"+indexUseCase)
                        .replaceAll("exceptionArt2b", "exceptionArt2b_"+indexUseCase)
                        .replaceAll("exceptionArt4a", "exceptionArt4a_"+indexUseCase)
                        .replaceAll("exceptionArt3b", "exceptionArt3b_"+indexUseCase)
                        .replaceAll("condition_1", "condition_1_"+indexUseCase)
                        .replaceAll("condition_2", "condition_2_"+indexUseCase)
                        .replaceAll("condition_3", "condition_3_"+indexUseCase)
                        .replaceAll("condition_4", "condition_4_"+indexUseCase)
                        .replaceAll("condition_5", "condition_5_"+indexUseCase)                        
                        .replaceAll("referTo", "referTo_"+indexUseCase)
                        .replaceAll("hasAgent", "hasAgent_"+indexUseCase)
                        .replaceAll("hasTheme", "hasTheme_"+indexUseCase)
                        .replaceAll("hasReceiver", "hasReceiver_"+indexUseCase)
                        .replaceAll("hasResult", "hasResult_"+indexUseCase);
                        /**/
                        
                pwRR.println(line);
            }
            
            prefixesAlreadyWritten = true;
        }
        
        pwRR.close();
    }
    
    public static void createIndexRulesFilesDLV2andClingo(File indexedRulesFolder, int numbersOfUseCases)throws Exception
    {
            //We first collects all the lines in the files...
        File regulativerules = new File(indexedRulesFolder.getParentFile().getAbsolutePath()+"/regulative+compliance_rules.asp");
        File INDEXEDregulativerules = new File(indexedRulesFolder.getAbsolutePath()+"/regulative+compliance_rules_"+numbersOfUseCases+".asp");
        
        InputStream isRR = new FileInputStream(regulativerules);
        InputStreamReader isrRR = new InputStreamReader(isRR, java.nio.charset.StandardCharsets.UTF_8.name());
        BufferedReader brRR = new java.io.BufferedReader(isrRR);
        ArrayList<String> rrLines = new ArrayList<String>();
        String buffer = null;
        while((buffer=brRR.readLine())!=null)rrLines.add(buffer);
        brRR.close();
        isrRR.close();
        isRR.close();
        
            //then in the output files we put the same rules but with the relevant predicates indexed
            //(and the @prefix we put only once)
        PrintWriter pwRR = new PrintWriter(new FileWriter(INDEXEDregulativerules));
        boolean prefixesAlreadyWritten = false;
        for(int indexUseCase=0; indexUseCase<numbersOfUseCases; indexUseCase++) 
        {
            for(String line:rrLines)
            {
                if((line.indexOf("@prefix")!=-1)&&(prefixesAlreadyWritten==true))continue;
                
                line = line.replaceAll("approve", "approve_"+indexUseCase)
                        .replaceAll("comment", "comment_"+indexUseCase)
                        .replaceAll("commission", "commission_"+indexUseCase)
                        .replaceAll("evaluate", "evaluate_"+indexUseCase)
                        .replaceAll("grant", "grant_"+indexUseCase)
                        .replaceAll("licence", "licence_"+indexUseCase)
                        .replaceAll("licensee", "licensee_"+indexUseCase)
                        .replaceAll("licensor", "licensor_"+indexUseCase)
                        .replaceAll("product", "product_"+indexUseCase)
                        .replaceAll("publish", "publish_"+indexUseCase)
                        .replaceAll("remove", "remove_"+indexUseCase)
                        .replaceAll("result", "result_"+indexUseCase)                
                        /**/
                        .replaceAll("isLicenceOf", "isLicenceOf_"+indexUseCase)
                        .replaceAll("isCommentOf", "isCommentOf_"+indexUseCase)
                        .replaceAll("prohibited", "prohibited_"+indexUseCase)
                        .replaceAll("permitted", "permitted_"+indexUseCase)
                        .replaceAll("obligatory", "obligatory_"+indexUseCase)
                        .replaceAll("rexist", "rexist_"+indexUseCase)
                        .replaceAll("compensate", "compensate_"+indexUseCase)
                        .replaceAll("violation", "violation_"+indexUseCase)
                        .replaceAll("exceptionArt1b", "exceptionArt1b_"+indexUseCase)
                        .replaceAll("exceptionArt2b", "exceptionArt2b_"+indexUseCase)
                        .replaceAll("exceptionArt4a", "exceptionArt4a_"+indexUseCase)
                        .replaceAll("exceptionArt3b", "exceptionArt3b_"+indexUseCase)
                        .replaceAll("condition_1", "condition_1_"+indexUseCase)
                        .replaceAll("condition_2", "condition_2_"+indexUseCase)
                        .replaceAll("condition_3", "condition_3_"+indexUseCase)
                        .replaceAll("condition_4", "condition_4_"+indexUseCase)
                        .replaceAll("condition_5", "condition_5_"+indexUseCase)                        
                        .replaceAll("referTo", "referTo_"+indexUseCase)
                        .replaceAll("hasAgent", "hasAgent_"+indexUseCase)
                        .replaceAll("hasTheme", "hasTheme_"+indexUseCase)
                        .replaceAll("hasReceiver", "hasReceiver_"+indexUseCase)
                        .replaceAll("hasResult", "hasResult_"+indexUseCase);
                        /**/
                        
                pwRR.println(line);
            }
            
            prefixesAlreadyWritten = true;
        }
        
        pwRR.close();
    }

    public static void aspABox(File CORPUS, int numberOfUseCases, int size, boolean[][][] distribution)throws Exception
    {
            //For ASP, we just output lines on a text file. Again, we create the subfolder if there is not already.
        File subfolder = new File(CORPUS.getAbsolutePath()+"/ASP/"+numberOfUseCases+"UseCases");
        if(subfolder.exists()==false)subfolder.mkdir();
            
        File outputFile = new File(subfolder.getAbsolutePath()+"/aspABox_"+numberOfUseCases+"UseCases_Size"+size+"_Probability"+probability+".asp");
        PrintWriter pw = new PrintWriter(new FileWriter(outputFile));

        for(int indexUseCase=0; indexUseCase<numberOfUseCases; indexUseCase++) 
        {
            for(int i=0; i<size; i++)
            {
                System.out.println("Creating ASP use case: "+indexUseCase+", with size "+size);
                
                    /******************* Individual *******************/
                    //To make it simpler, we generate all *indexed* individuals, both the actions (approve, evaluate, etc.)
                    //and the persons or objects (licensee, licensor, result, etc.).
                    //Then, we will randomly assign "Rexist" to the six actions.
                pw.write("licensee_"+indexUseCase+"(x_"+indexUseCase+"_"+i+").\n");
                pw.write("licensor_"+indexUseCase+"(y_"+indexUseCase+"_"+i+").\n");
                pw.write("product_"+indexUseCase+"(p_"+indexUseCase+"_"+i+").\n");
                pw.write("result_"+indexUseCase+"(r_"+indexUseCase+"_"+i +").\n");
                pw.write("licence_"+indexUseCase+"(l_"+indexUseCase+"_"+i+").\n");
                pw.write("isLicenceOf_"+indexUseCase+"(l_"+indexUseCase+"_"+i+",p_"+indexUseCase+"_"+i+").\n");
                pw.write("comment_"+indexUseCase+"(c_"+indexUseCase+"_"+i+").\n");

                    //TBox:Approve(ea) + thematic roles
                pw.write("approve_"+indexUseCase+"(ea_"+indexUseCase+"_"+i+").\n");
                pw.write("hasAgent_"+indexUseCase+"(ea_"+indexUseCase+"_"+i+",y_"+indexUseCase+"_"+i+").\n");
                pw.write("hasTheme_"+indexUseCase+"(ea_"+indexUseCase+"_"+i+",epr_"+indexUseCase+"_"+i+").\n");

                    //TBox:Commission(ec) + thematic roles
                pw.write("commission_"+indexUseCase+"(ec_"+indexUseCase+"_"+i+").\n");
                pw.write("hasTheme_"+indexUseCase+"(ec_"+indexUseCase+"_"+i+",ev_"+indexUseCase+"_"+i+").\n");

                    //TBox:Evaluate(ev) + thematic roles
                pw.write("evaluate_"+indexUseCase+"(ev_"+indexUseCase+"_"+i+").\n");
                pw.write("hasAgent_"+indexUseCase+"(ev_"+indexUseCase+"_"+i+",x_"+indexUseCase+"_"+i+").\n");
                pw.write("hasTheme_"+indexUseCase+"(ev_"+indexUseCase+"_"+i+",p_"+indexUseCase+"_"+i+").\n");
                pw.write("hasResult_"+indexUseCase+"(ev_"+indexUseCase+"_"+i+",r_"+indexUseCase+"_"+i+").\n");

                    //TBox:Grant(eg) + thematic roles
                pw.write("grant_"+indexUseCase+"(eg_"+indexUseCase+"_"+i+").\n");    
                pw.write("hasAgent_"+indexUseCase+"(eg_"+indexUseCase+"_"+i+",y_"+indexUseCase+"_"+i+").\n");
                pw.write("hasReceiver_"+indexUseCase+"(eg_"+indexUseCase+"_"+i+",x_"+indexUseCase+"_"+i+").\n");
                pw.write("hasTheme_"+indexUseCase+"(eg_"+indexUseCase+"_"+i+",l_"+indexUseCase+"_"+i+").\n");

                    //TBox:Publish(epc) + thematic roles
                pw.write("publish_"+indexUseCase+"(epc_"+indexUseCase+"_"+i+").\n");
                pw.write("hasAgent_"+indexUseCase+"(epc_"+indexUseCase+"_"+i+",x_"+indexUseCase+"_"+i+").\n");
                pw.write("hasTheme_"+indexUseCase+"(epc_"+indexUseCase+"_"+i+",c_"+indexUseCase+"_"+i+").\n");
                pw.write("isCommentOf_"+indexUseCase+"(c_"+indexUseCase+"_"+i+",ev_"+indexUseCase+"_"+i+").\n");

                    //TBox:Publish(epr) + thematic roles
                pw.write("publish_"+indexUseCase+"(epr_"+indexUseCase+"_"+i+").\n");
                pw.write("hasAgent_"+indexUseCase+"(epr_"+indexUseCase+"_"+i+",x_"+indexUseCase+"_"+i+").\n");
                pw.write("hasTheme_"+indexUseCase+"(epr_"+indexUseCase+"_"+i+",r_"+indexUseCase+"_"+i+").\n");

                    //TBox:Remove(er) + thematic roles                
                pw.write("remove_"+indexUseCase+"(er_"+indexUseCase+"_"+i+").\n");
                pw.write("hasAgent_"+indexUseCase+"(er_"+indexUseCase+"_"+i+",x_"+indexUseCase+"_"+i+").\n");
                pw.write("hasTheme_"+indexUseCase+"(er_"+indexUseCase+"_"+i+",r_"+indexUseCase+"_"+i+").\n");

                    //We randomly assign Rexist to the six actions
                if(distribution[indexUseCase][i][0])pw.write("rexist_"+indexUseCase+"(ea_"+indexUseCase+"_"+i+").\n");
                if(distribution[indexUseCase][i][1])pw.write("rexist_"+indexUseCase+"(ec_"+indexUseCase+"_"+i+").\n");
                if(distribution[indexUseCase][i][2])pw.write("rexist_"+indexUseCase+"(ev_"+indexUseCase+"_"+i+").\n");
                if(distribution[indexUseCase][i][3])pw.write("rexist_"+indexUseCase+"(eg_"+indexUseCase+"_"+i+").\n");
                if(distribution[indexUseCase][i][4])pw.write("rexist_"+indexUseCase+"(epc_"+indexUseCase+"_"+i+").\n");
                if(distribution[indexUseCase][i][5])pw.write("rexist_"+indexUseCase+"(epr_"+indexUseCase+"_"+i+").\n");
                if(distribution[indexUseCase][i][6])pw.write("rexist_"+indexUseCase+"(er_"+indexUseCase+"_"+i+").\n");
            }
        }

        pw.close();
    }
    
    public static void createIndexRulesFilesProleg(File indexedRulesFolder, int numbersOfUseCases)throws Exception
    {
            //We first collects all the lines in the files...
        File regulativerules = new File(indexedRulesFolder.getParentFile().getAbsolutePath()+"/regulative+compliance_rules.pl");
        File INDEXEDregulativerules = new File(indexedRulesFolder.getAbsolutePath()+"/regulative+compliance_rules_"+numbersOfUseCases+".pl");
        
        InputStream isRR = new FileInputStream(regulativerules);
        InputStreamReader isrRR = new InputStreamReader(isRR, java.nio.charset.StandardCharsets.UTF_8.name());
        BufferedReader brRR = new java.io.BufferedReader(isrRR);
        ArrayList<String> rrLines = new ArrayList<String>();
        String buffer = null;
        while((buffer=brRR.readLine())!=null)rrLines.add(buffer);
        brRR.close();
        isrRR.close();
        isRR.close();
        
            //then in the output files we put the same rules but with the relevant predicates indexed
            //(and the @prefix we put only once)
        PrintWriter pwRR = new PrintWriter(new FileWriter(INDEXEDregulativerules));
        boolean prefixesAlreadyWritten = false;
        for(int indexUseCase=0; indexUseCase<numbersOfUseCases; indexUseCase++) 
        {
            for(String line:rrLines)
            {
                if((line.indexOf("@prefix")!=-1)&&(prefixesAlreadyWritten==true))continue;
                
                line = line.replaceAll("approve_f", "approve_f_"+indexUseCase)
                        .replaceAll("comment_f", "comment_f_"+indexUseCase)
                        .replaceAll("commission_f", "commission_f_"+indexUseCase)
                        .replaceAll("evaluate_f", "evaluate_f_"+indexUseCase)
                        .replaceAll("grant_f", "grant_f_"+indexUseCase)
                        .replaceAll("licence_f", "licence_f_"+indexUseCase)
                        .replaceAll("licensee_f", "licensee_f_"+indexUseCase)
                        .replaceAll("licensor_f", "licensor_f_"+indexUseCase)
                        .replaceAll("product_f", "product_f_"+indexUseCase)
                        .replaceAll("publish_f", "publish_f_"+indexUseCase)
                        .replaceAll("remove_f", "remove_f_"+indexUseCase)
                        .replaceAll("result_f", "result_f_"+indexUseCase)
                        .replaceAll("isLicenceOf_f", "isLicenceOf_f_"+indexUseCase)
                        .replaceAll("isCommentOf_f", "isCommentOf_f_"+indexUseCase)
                        .replaceAll("rexist_f", "rexist_f_"+indexUseCase)
                        .replaceAll("prohibited", "prohibited_"+indexUseCase)
                        .replaceAll("permitted", "permitted_"+indexUseCase)
                        .replaceAll("obligatory", "obligatory_"+indexUseCase)
                        .replaceAll("compensated", "compensated_"+indexUseCase)
                        .replaceAll("compensate", "compensate_"+indexUseCase)
                        .replaceAll("violation", "violation_"+indexUseCase)
                        .replaceAll("condition_1", "condition_1_"+indexUseCase)
                        .replaceAll("condition_2", "condition_2_"+indexUseCase)
                        .replaceAll("referTo", "referTo_"+indexUseCase)
                        .replaceAll("hasAgent_f", "hasAgent_f_"+indexUseCase)
                        .replaceAll("hasTheme_f", "hasTheme_f_"+indexUseCase)
                        .replaceAll("hasReceiver_f", "hasReceiver_f_"+indexUseCase)
                        .replaceAll("hasResult_f", "hasResult_f_"+indexUseCase)
                        .replaceAll("approve\\(", "approve_"+indexUseCase+"\\(")
                        .replaceAll("comment\\(", "comment_"+indexUseCase+"\\(")
                        .replaceAll("commission\\(", "commission_"+indexUseCase+"\\(")
                        .replaceAll("evaluate\\(", "evaluate_"+indexUseCase+"\\(")
                        .replaceAll("grant\\(", "grant_"+indexUseCase+"\\(")
                        .replaceAll("licence\\(", "licence_"+indexUseCase+"\\(")
                        .replaceAll("licensee\\(", "licensee_"+indexUseCase+"\\(")
                        .replaceAll("licensor\\(", "licensor_"+indexUseCase+"\\(")
                        .replaceAll("product\\(", "product_"+indexUseCase+"\\(")
                        .replaceAll("publish\\(", "publish_"+indexUseCase+"\\(")
                        .replaceAll("remove\\(", "remove_"+indexUseCase+"\\(")
                        .replaceAll("result\\(", "result_"+indexUseCase+"\\(")
                        .replaceAll("isLicenceOf\\(", "isLicenceOf_"+indexUseCase+"\\(")
                        .replaceAll("isCommentOf\\(", "isCommentOf_"+indexUseCase+"\\(")
                        .replaceAll("hasAgent\\(", "hasAgent_"+indexUseCase+"\\(")
                        .replaceAll("hasTheme\\(", "hasTheme_"+indexUseCase+"\\(")
                        .replaceAll("hasReceiver\\(", "hasReceiver_"+indexUseCase+"\\(")
                        .replaceAll("hasResult\\(", "hasResult_"+indexUseCase+"\\(")
                        .replaceAll("rexist\\(", "rexist_"+indexUseCase+"\\(");
                        
                pwRR.println(line);
            }
            
            prefixesAlreadyWritten = true;
        }
        
        pwRR.close();
    }
    
    public static void prolegABox(File CORPUS, int numberOfUseCases, int size, boolean[][][] distribution)
    {
        try
        {
            File subfolder = new File(CORPUS.getAbsolutePath()+"/PROLEG/"+numberOfUseCases+"UseCases");
            if(subfolder.exists()==false)subfolder.mkdir();
            File outputFile = new File(subfolder.getAbsolutePath()+"/prolegABox_"+numberOfUseCases+"UseCases_Size"+size+"_Probability"+probability+".pl");
            PrintWriter pw = new PrintWriter(new FileWriter(outputFile));
            
            pw.write(":- style_check(-singleton).\n");
            pw.write(":- discontiguous fact/1.\n");
            pw.write(":- [ \"../../../../PROLEG/prolegEng3.pl\", \"../../../../PROLEG/INDEXED_RULES/regulative+compliance_rules_"+numberOfUseCases+".pl\" ].\n");
            
            String goal = "goal :- ";
            for(int indexUseCase=0; indexUseCase<numberOfUseCases; indexUseCase++) 
            {
                for (int i = 0; i < size; i++) 
                {
                        /******************* Individual *******************/
                        //To make it simpler, we generate all *indexed* individuals, both the actions (approve, evaluate, etc.)
                        //and the persons or objects (licensee, licensor, result, etc.).
                        //Then, we will randomly assign "Rexist" to the six actions.
                    pw.write("fact(licensee_f_"+indexUseCase+"(x_"+indexUseCase+"_" + i +")).\n");
                    pw.write("fact(licensor_f_"+indexUseCase+"(y_"+indexUseCase+"_" + i +")).\n");
                    pw.write("fact(product_f_"+indexUseCase+"(p_"+indexUseCase+"_" + i +")).\n");
                    pw.write("fact(result_f_"+indexUseCase+"(r_"+indexUseCase+"_" + i +")).\n");
                    pw.write("fact(licence_f_"+indexUseCase+"(l_"+indexUseCase+"_" + i +")).\n");
                    pw.write("fact(isLicenceOf_f_"+indexUseCase+"(l_"+indexUseCase+"_" + i + ",p_"+indexUseCase+"_" + i + ")).\n");
                    pw.write("fact(comment_f_"+indexUseCase+"(c_"+indexUseCase+"_" + i +")).\n");

                        //TBox:Approve(ea) + thematic roles
                    pw.write("fact(approve_f_"+indexUseCase+"(ea_"+indexUseCase+"_" + i +")).\n");
                    pw.write("fact(hasAgent_f_"+indexUseCase+"(ea_"+indexUseCase+"_" + i + ",y_"+indexUseCase+"_" + i + ")).\n");
                    pw.write("fact(hasTheme_f_"+indexUseCase+"(ea_"+indexUseCase+"_" + i + ",epr_"+indexUseCase+"_" + i + ")).\n");

                        //TBox:Commission(ec) + thematic roles
                    pw.write("fact(commission_f_"+indexUseCase+"(ec_"+indexUseCase+"_" + i +")).\n");
                    pw.write("fact(hasTheme_f_"+indexUseCase+"(ec_"+indexUseCase+"_" + i + ",ev_"+indexUseCase+"_" + i + ")).\n");

                        //TBox:Evaluate(ev) + thematic roles
                    pw.write("fact(evaluate_f_"+indexUseCase+"(ev_"+indexUseCase+"_" + i +")).\n");
                    pw.write("fact(hasAgent_f_"+indexUseCase+"(ev_"+indexUseCase+"_" + i + ",x_"+indexUseCase+"_" + i + ")).\n");
                    pw.write("fact(hasTheme_f_"+indexUseCase+"(ev_"+indexUseCase+"_" + i + ",p_"+indexUseCase+"_" + i + ")).\n");
                    pw.write("fact(hasResult_f_"+indexUseCase+"(ev_"+indexUseCase+"_" + i + ",r_"+indexUseCase+"_" + i + ")).\n");

                        //TBox:Grant(eg) + thematic roles
                    pw.write("fact(grant_f_"+indexUseCase+"(eg_"+indexUseCase+"_" + i +")).\n");
                    pw.write("fact(hasAgent_f_"+indexUseCase+"(eg_"+indexUseCase+"_" + i + ",y_"+indexUseCase+"_" + i + ")).\n");
                    pw.write("fact(hasReceiver_f_"+indexUseCase+"(eg_"+indexUseCase+"_" + i + ",x_"+indexUseCase+"_" + i + ")).\n");
                    pw.write("fact(hasTheme_f_"+indexUseCase+"(eg_"+indexUseCase+"_" + i + ",l_"+indexUseCase+"_" + i + ")).\n");

                        //TBox:Publish(epc) + thematic roles
                    pw.write("fact(publish_f_"+indexUseCase+"(epc_"+indexUseCase+"_" + i +")).\n");
                    pw.write("fact(hasAgent_f_"+indexUseCase+"(epc_"+indexUseCase+"_" + i + ",x_"+indexUseCase+"_" + i + ")).\n");
                    pw.write("fact(hasTheme_f_"+indexUseCase+"(epc_"+indexUseCase+"_" + i + ",c_"+indexUseCase+"_" + i + ")).\n");
                    pw.write("fact(isCommentOf_f_"+indexUseCase+"(c_"+indexUseCase+"_" + i + ",ev_"+indexUseCase+"_" + i + ")).\n");

                        //TBox:Publish(epr) + thematic roles
                    pw.write("fact(publish_f_"+indexUseCase+"(epr_"+indexUseCase+"_" + i +")).\n");
                    pw.write("fact(hasAgent_f_"+indexUseCase+"(epr_"+indexUseCase+"_" + i + ",x_"+indexUseCase+"_" + i + ")).\n");
                    pw.write("fact(hasTheme_f_"+indexUseCase+"(epr_"+indexUseCase+"_" + i + ",r_"+indexUseCase+"_" + i + ")).\n");

                        //TBox:Remove(er) + thematic roles                
                    pw.write("fact(remove_f_"+indexUseCase+"(er_"+indexUseCase+"_" + i +")).\n");
                    pw.write("fact(hasAgent_f_"+indexUseCase+"(er_"+indexUseCase+"_" + i + ",x_"+indexUseCase+"_" + i + ")).\n");
                    pw.write("fact(hasTheme_f_"+indexUseCase+"(er_"+indexUseCase+"_" + i + ",r_"+indexUseCase+"_" + i + ")).\n");

                        //We randomly assign Rexist to the six actions
                    if(distribution[indexUseCase][i][0])pw.write("fact(rexist_f_"+indexUseCase+"(ea_"+indexUseCase+"_"+i+")).\n");
                    if(distribution[indexUseCase][i][1])pw.write("fact(rexist_f_"+indexUseCase+"(ec_"+indexUseCase+"_"+i+")).\n");
                    if(distribution[indexUseCase][i][2])pw.write("fact(rexist_f_"+indexUseCase+"(ev_"+indexUseCase+"_"+i+")).\n");
                    if(distribution[indexUseCase][i][3])pw.write("fact(rexist_f_"+indexUseCase+"(eg_"+indexUseCase+"_"+i+")).\n");
                    if(distribution[indexUseCase][i][4])pw.write("fact(rexist_f_"+indexUseCase+"(epc_"+indexUseCase+"_"+i+")).\n");
                    if(distribution[indexUseCase][i][5])pw.write("fact(rexist_f_"+indexUseCase+"(epr_"+indexUseCase+"_"+i+")).\n");
                    if(distribution[indexUseCase][i][6])pw.write("fact(rexist_f_"+indexUseCase+"(er_"+indexUseCase+"_"+i+")).\n");

                        //Now we add the queries:
                    pw.write("violation_ev_"+indexUseCase+"_"+i+" :- "
                                + "write(\"\\n-------------\\n\"), "
                                + "answer(violation_"+indexUseCase+"(viol(ev_"+indexUseCase+"_"+i+"))).\n");
                    pw.write("violation_epr_"+indexUseCase+"_"+i+" :- "
                                + "write(\"\\n-------------\\n\"), "
                                + "answer(violation_"+indexUseCase+"(viol(epr_"+indexUseCase+"_"+i+"))).\n");
                    pw.write("violation_epc_"+indexUseCase+"_"+i+" :- "
                                + "write(\"\\n-------------\\n\"), "
                                + "answer(violation_"+indexUseCase+"(viol(epc_"+indexUseCase+"_"+i+"))).\n");
                    pw.write("violation_er_"+indexUseCase+"_"+i+" :- "
                                + "write(\"\\n-------------\\n\"), "
                                + "answer(violation_"+indexUseCase+"(viol(ca(epr_"+indexUseCase+"_"+i+", x_"+indexUseCase+"_"+i+", r_"+indexUseCase+"_"+i+")))).\n");

                    pw.write("violation_ev_"+indexUseCase+"_"+i+" :- !.\n");
                    pw.write("violation_epr_"+indexUseCase+"_"+i+" :- !.\n");
                    pw.write("violation_epc_"+indexUseCase+"_"+i+" :- !.\n");
                    pw.write("violation_er_"+indexUseCase+"_"+i+" :- !.\n");

                    goal = goal + "violation_ev_"+indexUseCase+"_"+i+", violation_epr_"+indexUseCase+"_"+i+", violation_epc_"+indexUseCase+"_"+i+", violation_er_"+indexUseCase+"_"+i+", ";
                }
            }

            goal = goal.trim().substring(0, goal.trim().length()-1).trim()+".\n";
            pw.write(goal);
            pw.close();
        }catch (Exception e){e.printStackTrace();}
    }
    
    public static void arg2pABox(File outputFile, int size, boolean[][][] distribution)
    {
        try
        {
                //For arg2p, we just output lines on a text file.
                //The boolean above are needed to check which lines we already asserted.
            PrintWriter pw = new PrintWriter(new FileWriter(outputFile));

            int factCounter = 1;
            for (int i = 0; i < size; i++) 
            {
                    /******************* Individual *******************/
                    //To make it simpler, we generate all *indexed* individuals, both the actions (approve, evaluate, etc.)
                    //and the persons or objects (licensee, licensor, result, etc.).
                    //Then, we will randomly assign "Rexist" to the six actions.
                pw.write("f"+factCounter+" :-> licensee(x_" + i +").\n");factCounter++;
                pw.write("f"+factCounter+" :-> licensor(y_" + i +").\n");factCounter++;
                pw.write("f"+factCounter+" :-> product(p_" + i +").\n");factCounter++;
                pw.write("f"+factCounter+" :-> result(r_" + i +").\n");factCounter++;
                pw.write("f"+factCounter+" :-> licence(l_" + i +").\n");factCounter++;
                pw.write("f"+factCounter+" :-> isLicenceOf(l_" + i + ",p_" + i + ").\n");factCounter++;
                pw.write("f"+factCounter+" :-> comment(c_" + i +").\n");factCounter++;
                        
                    //TBox:Approve(ea) + thematic roles
                pw.write("f"+factCounter+" :-> approve(ea_" + i +").\n");factCounter++;
                pw.write("f"+factCounter+" :-> hasAgent(ea_" + i + ",y_" + i + ").\n");factCounter++;
                pw.write("f"+factCounter+" :-> hasTheme(ea_" + i + ",epr_" + i + ").\n");factCounter++;

                    //TBox:Commission(ec) + thematic roles
                pw.write("f"+factCounter+" :-> commission(ec_" + i +").\n");factCounter++;
                pw.write("f"+factCounter+" :-> hasTheme(ec_" + i + ",ev_" + i + ").\n");factCounter++;

                    //TBox:Evaluate(ev) + thematic roles
                pw.write("f"+factCounter+" :-> evaluate(ev_" + i +").\n");factCounter++;
                pw.write("f"+factCounter+" :-> hasAgent(ev_" + i + ",x_" + i + ").\n");factCounter++;
                pw.write("f"+factCounter+" :-> hasTheme(ev_" + i + ",p_" + i + ").\n");factCounter++;
                pw.write("f"+factCounter+" :-> hasResult(ev_" + i + ",r_" + i + ").\n");factCounter++;

                    //TBox:Grant(eg) + thematic roles
                pw.write("f"+factCounter+" :-> grant(eg_" + i +").\n");factCounter++;
                pw.write("f"+factCounter+" :-> hasAgent(eg_" + i + ",y_" + i + ").\n");factCounter++;
                pw.write("f"+factCounter+" :-> hasReceiver(eg_" + i + ",x_" + i + ").\n");factCounter++;
                pw.write("f"+factCounter+" :-> hasTheme(eg_" + i + ",l_" + i + ").\n");factCounter++;
                
                    //TBox:Publish(epc) + thematic roles
                pw.write("f"+factCounter+" :-> publish(epc_" + i +").\n");factCounter++;
                pw.write("f"+factCounter+" :-> hasAgent(epc_" + i + ",x_" + i + ").\n");factCounter++;
                pw.write("f"+factCounter+" :-> hasTheme(epc_" + i + ",c_" + i + ").\n");factCounter++;
                pw.write("f"+factCounter+" :-> isCommentOf(c_" + i + ",ev_" + i + ").\n");factCounter++;
                
                    //TBox:Publish(epr) + thematic roles
                pw.write("f"+factCounter+" :-> publish(epr_" + i +").\n");factCounter++;
                pw.write("f"+factCounter+" :-> hasAgent(epr_" + i + ",x_" + i + ").\n");factCounter++;
                pw.write("f"+factCounter+" :-> hasTheme(epr_" + i + ",r_" + i + ").\n");factCounter++;

                    //TBox:Remove(er) + thematic roles                
                pw.write("f"+factCounter+" :-> remove(er_" + i +").\n");factCounter++;
                pw.write("f"+factCounter+" :-> hasAgent(er_" + i + ",x_" + i + ").\n");factCounter++;
                pw.write("f"+factCounter+" :-> hasTheme(er_" + i + ",r_" + i + ").\n");factCounter++;
                
                    //We randomly assign Rexist to the six actions
					//Here we do not change the use case number, it's always the same
                if(distribution[0][i][0]){pw.write("f"+factCounter+" :-> rexist(ea_" + i + ").\n");factCounter++;}
                if(distribution[0][i][1]){pw.write("f"+factCounter+" :-> rexist(ec_" + i + ").\n");factCounter++;}
                if(distribution[0][i][2]){pw.write("f"+factCounter+" :-> rexist(ev_" + i + ").\n");factCounter++;}
                if(distribution[0][i][3]){pw.write("f"+factCounter+" :-> rexist(eg_" + i + ").\n");factCounter++;}
                if(distribution[0][i][4]){pw.write("f"+factCounter+" :-> rexist(epc_" + i + ").\n");factCounter++;}
                if(distribution[0][i][5]){pw.write("f"+factCounter+" :-> rexist(epr_" + i + ").\n");factCounter++;}
                if(distribution[0][i][6]){pw.write("f"+factCounter+" :-> rexist(er_" + i + ").\n");factCounter++;}
            }

            pw.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
//SPINdle è il più complesso, lo mettiamo al fondo
    public static void SPINdleABox(File CORPUS, int numberOfUseCases, int size, boolean[][][] distribution)
    {
        try
        {
            File outputFile = new File(CORPUS.getAbsolutePath()+"/SPINdle/SPINdleABox_"+numberOfUseCases+"UseCases_Size"+size+"_Probability"+probability+".dfl");
                    
                //In the same folder of the outputFile, there is a file with the rules that need to be adapted.
            ArrayList<String> rules = extractRules(SPINdleRules);
            
                //For ASP, we just output lines on a text file.
                //The boolean above are needed to check which lines we already asserted.
            PrintWriter pw = new PrintWriter(new FileWriter(outputFile));

            for(int indexUseCase=0; indexUseCase<numberOfUseCases; indexUseCase++) 
            {
                for(int i=0; i<size; i++)
                {
                    ArrayList<String> indexedRules = indexSPINdleRules(rules, indexUseCase, i);
                    for(String rule:indexedRules)pw.println(rule);

                        //Besides the indexed rules, we also put the actions. Indeed, these "actions" also encompasses
                        //the thematic roles, as they are propositional symbols.
                    pw.write(">> Approve_ea_"+indexUseCase+"_"+i+"\n");
                    pw.write(">> Commission_ec_"+indexUseCase+"_"+i+"\n");
                    pw.write(">> Evaluate_ev_"+indexUseCase+"_"+i+"\n");
                    pw.write(">> Grant_eg_"+indexUseCase+"_"+i+"\n");
                    pw.write(">> Publish_epc_"+indexUseCase+"_"+i+"\n");
                    pw.write(">> Publish_epr_"+indexUseCase+"_"+i+"\n");
                    pw.write(">> Remove_er_"+indexUseCase+"_"+i+"\n");
                    if(distribution[indexUseCase][i][0])pw.write(">> Rexist_ea_"+indexUseCase+"_"+i+"\n");
                    if(distribution[indexUseCase][i][1])pw.write(">> Rexist_ec_"+indexUseCase+"_"+i+"\n");
                    if(distribution[indexUseCase][i][2])pw.write(">> Rexist_ev_"+indexUseCase+"_"+i+"\n");
                    if(distribution[indexUseCase][i][3])pw.write(">> Rexist_eg_"+indexUseCase+"_"+i+"\n");
                    if(distribution[indexUseCase][i][4])pw.write(">> Rexist_epc_"+indexUseCase+"_"+i+"\n");
                    if(distribution[indexUseCase][i][5])pw.write(">> Rexist_epr_"+indexUseCase+"_"+i+"\n");
                    if(distribution[indexUseCase][i][6])pw.write(">> Rexist_er_"+indexUseCase+"_"+i+"\n");
                }
            }

            pw.close();

        }catch (Exception e){e.printStackTrace();}
    }
  
    private static ArrayList<String> extractRules(File SPINdleRulesFile)throws Exception
    {
        InputStream is = new FileInputStream(SPINdleRulesFile);
        InputStreamReader isr = new InputStreamReader(is, java.nio.charset.StandardCharsets.UTF_8.name());
        BufferedReader br = new java.io.BufferedReader(isr);
        
        ArrayList<String> ret = new ArrayList<String>();
        
        String buffer = null;
        while((buffer=br.readLine())!=null)
        {
            if(buffer.trim().isEmpty()==true)continue;
            if(buffer.trim().charAt(0)=='#')continue;
            ret.add(buffer);
        }
        
        br.close();
        isr.close();
        is.close();
        return ret;
    }
    
    private static ArrayList<String> indexSPINdleRules(ArrayList<String> rules, int indexUseCase, int indexStateOfAffair)throws Exception
    {
        ArrayList<String> ret = new ArrayList<String>();
        
        for(String rule:rules)
        {
                //deontic modalities
            if(rule.indexOf("[O]:")!=-1)
                rule =  rule.substring(0, rule.indexOf("[O]:")).trim()+"_"+indexUseCase+"_"+indexStateOfAffair+
                        "[O]: "+
                        rule.substring(rule.indexOf("[O]:")+"[O]:".length(), rule.length()).trim();
            else if(rule.indexOf("[P]:")!=-1)
                rule =  rule.substring(0, rule.indexOf("[P]:")).trim()+"_"+indexUseCase+"_"+indexStateOfAffair+
                        "[P]: "+
                        rule.substring(rule.indexOf("[P]:")+"[P]:".length(), rule.length()).trim();
            else if(rule.indexOf(":")!=-1)//if we are here it is a rule without deontic modality. eg., "condition2:"
                rule =  rule.substring(0, rule.indexOf(":")).trim()+"_"+indexUseCase+"_"+indexStateOfAffair+
                        ": "+
                        rule.substring(rule.indexOf(":")+":".length(), rule.length()).trim();
            
                //variables
            String[] variables = new String[]{"ev","eg","epr","epc","ea","ec","er"};
            for(String variable:variables)
            {
                while((rule.indexOf("_"+variable)!=-1)&&(rule.lastIndexOf("_"+variable)==rule.length()-("_"+variable).length()))
                    rule =  rule.substring(0, rule.lastIndexOf("_"+variable)).trim()+
                            "_"+variable+"_"+indexUseCase+"_"+indexStateOfAffair;
                while(rule.indexOf("_"+variable+" =>")!=-1)
                    rule =  rule.substring(0, rule.indexOf("_"+variable+" =>")).trim()+
                            "_"+variable+"_"+indexUseCase+"_"+indexStateOfAffair+" => "+
                            rule.substring(rule.indexOf("_"+variable+" =>")+("_"+variable+" =>").length(), rule.length()).trim();
                while(rule.indexOf("_"+variable+",")!=-1)
                    rule =  rule.substring(0, rule.indexOf("_"+variable+",")).trim()+
                            "_"+variable+"_"+indexUseCase+"_"+indexStateOfAffair+", "+
                            rule.substring(rule.indexOf("_"+variable+",")+("_"+variable+",").length(), rule.length()).trim();
                while(rule.indexOf(" "+variable+"_")!=-1)
                    rule =  rule.substring(0, rule.indexOf(" "+variable+"_")).trim()+
                            " "+variable+"_"+indexUseCase+"_"+indexStateOfAffair+"_"+
                            rule.substring(rule.indexOf(" "+variable+"_")+(" "+variable+"_").length(), rule.length()).trim();
                while(rule.indexOf(","+variable+"_")!=-1)
                    rule =  rule.substring(0, rule.indexOf(","+variable+"_")).trim()+
                            ","+variable+"_"+indexUseCase+"_"+indexStateOfAffair+"_"+
                            rule.substring(rule.indexOf(","+variable+"_")+(","+variable+"_").length(), rule.length()).trim();
            }
            
                //Superiority relations...
            if(rule.indexOf(" > ")!=-1)
                rule =  rule.substring(0, rule.indexOf(">")).trim()+"_"+indexUseCase+"_"+indexStateOfAffair+" "+
                        rule.substring(rule.indexOf(">"), rule.length()).trim()+"_"+indexUseCase+"_"+indexStateOfAffair;
            
            ret.add(rule);
        }

        return ret;
    }
    
    
    private static void recreateCORPUSfolder(File CORPUS)
    {
        File SHACL = new File(CORPUS.getAbsolutePath()+"//SHACL");
        File ASP = new File(CORPUS.getAbsolutePath()+"//ASP");
        File PROLEG = new File(CORPUS.getAbsolutePath()+"//PROLEG");
        File SPINdle = new File(CORPUS.getAbsolutePath()+"//SPINdle");
        File Arg2P = new File(CORPUS.getAbsolutePath()+"//Arg2P");
        
        if(SHACL.exists()==false)SHACL.mkdir();
        if(ASP.exists()==false)ASP.mkdir();
        if(PROLEG.exists()==false)PROLEG.mkdir();
        if(SPINdle.exists()==false)SPINdle.mkdir();
        if(Arg2P.exists()==false)Arg2P.mkdir();
        
        for(File f:SHACL.listFiles())delete(f);
        for(File f:ASP.listFiles())delete(f);
        for(File f:PROLEG.listFiles())delete(f);
        for(File f:SPINdle.listFiles())delete(f);
        for(File f:Arg2P.listFiles())delete(f);
    }
    
    private static void delete(File f)
    {
        if(f.isDirectory())
        {
            while(f.listFiles().length>0)delete(f.listFiles()[0]);
            while(f.exists())f.delete();
        }
        else while(f.exists())f.delete();
    }
}
