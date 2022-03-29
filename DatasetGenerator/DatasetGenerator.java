import org.semanticweb.owlapi.apibinding.OWLManager;
import org.semanticweb.owlapi.model.*;
import org.semanticweb.owlapi.formats.TurtleDocumentFormat;

import java.util.*;
import java.io.*;
import java.util.Random;

public class DatasetGenerator 
{
        //Generator parameters
    private final static int numOfSamples = 3;//Define the number of samples for each size
    private final static int minSize = 10;//Define here the minimum size of a sample (inclusive)
    private final static int maxSize = 50;//Define here the maximum size of a sample (inclusive)
    private final static int stepSize = 20;//Define here the step of samples sizes
    private final static int probability = 50;//Define percentage [0-100] of an Rexist to be generated
    
    private static File CORPUS = new File("./CORPUS");
    public static void main(String[] args) 
    {
        try 
        {
            if(args.length>0)CORPUS = new File(args[0]);
            recreateOUTPUTfolder(new File("./CORPUS"));
            
                //Generate samples of various sizes
            for(int sample=0; sample<numOfSamples; sample++) 
            {
                for (int size=minSize; size<=maxSize; size+=stepSize) 
                {
                    System.out.println("Save ABoxes - SIZE:"+size+", PERCENTAGE:"+probability+", SAMPLE NUMBER:"+sample);
                    
                    boolean[][] distribution = new boolean[size][];
                    for(int i=0;i<size;i++)distribution[i]=getDistribution();
                    
                    shaclABox(new File(CORPUS.getAbsolutePath()+"/SHACL/shaclABox_Size"+size+"_Probability"+probability+"_num"+sample+".owl"), size, distribution);
                    aspABox(new File(CORPUS.getAbsolutePath()+"/ASP/aspABox_Size"+size+"_Probability"+probability+"_num"+sample+".asp"), size, distribution);
                    prolegABox(new File(CORPUS.getAbsolutePath()+"/PROLEG/prolegABox_Size"+size+"_Probability"+probability+"_num"+sample+".pl"), size, distribution);
                    SPINdleABox(new File(CORPUS.getAbsolutePath()+"/SPINdle/SPINdleABox_Size"+size+"_Probability"+probability+"_num"+sample+".dfl"), size, distribution);
                    arg2pABox(new File(CORPUS.getAbsolutePath()+"/Arg2P/arg2pABox_Size"+size+"_Probability"+probability+"_num"+sample+".arg2p"), size, distribution);
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

    public static void shaclABox(File outputFile, int size, boolean[][] distribution)
    {
        try 
        {
                //Create ABox ontology.
            OWLOntologyManager manager = OWLManager.createOWLOntologyManager();
            IRI iri = IRI.create("http://www.licenceusecaseonto.org/");
            OWLOntology ontology = manager.createOntology(iri);
            
                //OWL Classes in the licence use case ontology
            OWLDataFactory factory = manager.getOWLDataFactory();
            OWLClass approve = factory.getOWLClass(IRI.create(iri+"Approve"));
            OWLClass comment = factory.getOWLClass(IRI.create(iri + "Comment"));
            OWLClass commission = factory.getOWLClass(IRI.create(iri + "Commission"));
            OWLClass evaluate = factory.getOWLClass(IRI.create(iri + "Evaluate"));
            OWLClass grant = factory.getOWLClass(IRI.create(iri + "Grant"));
            OWLClass licence = factory.getOWLClass(IRI.create(iri + "Licence"));
            OWLClass licensee = factory.getOWLClass(IRI.create(iri + "Licensee"));
            OWLClass licensor = factory.getOWLClass(IRI.create(iri + "Licensor"));
            OWLClass product = factory.getOWLClass(IRI.create(iri + "Product"));
            OWLClass publish = factory.getOWLClass(IRI.create(iri + "Publish"));
            OWLClass remove = factory.getOWLClass(IRI.create(iri + "Remove"));
            OWLClass result = factory.getOWLClass(IRI.create(iri + "Result"));

                //In the cycle below, we (randomly) insert the actions that Rexist.
            OWLClass rexist = factory.getOWLClass(IRI.create("https://www.swansea.ac.uk/law/legal-innovation-lab-wales/riolOntology#Rexist"));
            for(int i=0; i<size; i++) 
            {
                    /******************* Individual *******************/
                    //To make it simpler, we generate all *indexed* individuals, both the actions (approve, evaluate, etc.)
                    //and the persons or objects (licensee, licensor, result, etc.).
                    //Then, we will randomly assign "Rexist" to the six actions.
                    
                    //Persons and objects
                OWLIndividual x = createIndividual(manager, factory, ontology, licensee, iri + "x_" + i);
                OWLIndividual y = createIndividual(manager, factory, ontology, licensor, iri + "y_" + i);
                OWLIndividual r = createIndividual(manager, factory, ontology, result, iri + "r_" + i);
                OWLIndividual p = createIndividual(manager, factory, ontology, product, iri + "p_" + i);
                OWLIndividual l = createIndividual(manager, factory, ontology, licence, iri + "l_" + i);
                OWLIndividual c = createIndividual(manager, factory, ontology, comment, iri + "c_" + i);
                addObjectProperty(manager, factory, ontology, iri + "is-licence-of", l, p);
                
                    //TBox:Evaluate(ev) + thematic roles
                OWLIndividual ev = createIndividual(manager, factory, ontology, evaluate, iri + "ev_" + i);
                addObjectProperty(manager, factory, ontology, iri + "has-agent", ev, x);
                addObjectProperty(manager, factory, ontology, iri + "has-theme", ev, p);
                addObjectProperty(manager, factory, ontology, iri + "has-result", ev, r);
                
                    //TBox:Publish(epr) + thematic roles
                OWLIndividual epr = createIndividual(manager, factory, ontology, publish, iri + "epr_" + i);
                addObjectProperty(manager, factory, ontology, iri + "has-agent", epr, x);
                addObjectProperty(manager, factory, ontology, iri + "has-theme", epr, r);
                
                    //TBox:Approve(ea) + thematic roles
                OWLIndividual ea = createIndividual(manager, factory, ontology, approve, iri + "ea_" + i);
                addObjectProperty(manager, factory, ontology, iri + "has-agent", ea, y);
                addObjectProperty(manager, factory, ontology, iri + "has-theme", ea, epr);
                
                    //TBox:Commission(ec) + thematic roles
                OWLIndividual ec = createIndividual(manager, factory, ontology, commission, iri + "ec_" + i);
                addObjectProperty(manager, factory, ontology, iri + "has-theme", ec, ev);
                 
                    //TBox:Grant(eg) + thematic roles
                OWLIndividual eg = createIndividual(manager, factory, ontology, grant, iri + "eg_" + i);
                addObjectProperty(manager, factory, ontology, iri + "has-agent", eg, y);
                addObjectProperty(manager, factory, ontology, iri + "has-theme", eg, l);
                addObjectProperty(manager, factory, ontology, iri + "has-receiver", eg, x);
                    
                    // TBox:Publish(epc) + thematic roles
                OWLIndividual epc = createIndividual(manager, factory, ontology, publish, iri + "epc_" + i);
                addObjectProperty(manager, factory, ontology, iri + "has-agent", epc, x);
                addObjectProperty(manager, factory, ontology, iri + "has-theme", epc, c);    
                addObjectProperty(manager, factory, ontology, iri + "is-comment-of", c, ev);
            
                    // TBox:Remove(er) + thematic roles
                OWLIndividual er = createIndividual(manager, factory, ontology, remove, iri + "er_" + i);
                addObjectProperty(manager, factory, ontology, iri + "has-agent", er, x);
                addObjectProperty(manager, factory, ontology, iri + "has-theme", er, r);
                        
                    //We randomly assign Rexist to the six actions
                if(distribution[i][0])addIndividualToClass(manager, factory, ontology, rexist, ea);
                if(distribution[i][1])addIndividualToClass(manager, factory, ontology, rexist, ec);
                if(distribution[i][2])addIndividualToClass(manager, factory, ontology, rexist, ev);
                if(distribution[i][3])addIndividualToClass(manager, factory, ontology, rexist, eg);
                if(distribution[i][4])addIndividualToClass(manager, factory, ontology, rexist, epc);
                if(distribution[i][5])addIndividualToClass(manager, factory, ontology, rexist, epr);   
                if(distribution[i][6])addIndividualToClass(manager, factory, ontology, rexist, er);
            }

            // Print output to file
            manager.saveOntology(ontology, new TurtleDocumentFormat(), IRI.create(outputFile.toURI()));

        } catch (Exception e) {
            e.printStackTrace();
        }
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

    public static void aspABox(File outputFile, int size, boolean[][] distribution)
    {
        try
        {
                //For ASP, we just output lines on a text file.
                //The boolean above are needed to check which lines we already asserted.
            PrintWriter pw = new PrintWriter(new FileWriter(outputFile));

            for (int i = 0; i < size; i++) 
            {
                    /******************* Individual *******************/
                    //To make it simpler, we generate all *indexed* individuals, both the actions (approve, evaluate, etc.)
                    //and the persons or objects (licensee, licensor, result, etc.).
                    //Then, we will randomly assign "Rexist" to the six actions.
                pw.write("licensee(x_" + i +").\n");
                pw.write("licensor(y_" + i +").\n");
                pw.write("product(p_" + i +").\n");
                pw.write("result(r_" + i +").\n");
                pw.write("licence(l_" + i +").\n");
                pw.write("isLicenceOf(l_" + i + ",p_" + i + ").\n");
                pw.write("comment(c_" + i +").\n");
                        
                    //TBox:Approve(ea) + thematic roles
                pw.write("approve(ea_" + i +").\n");
                pw.write("hasAgent(ea_" + i + ",y_" + i + ").\n");
                pw.write("hasTheme(ea_" + i + ",epr_" + i + ").\n");

                    //TBox:Commission(ec) + thematic roles
                pw.write("commission(ec_" + i +").\n");
                pw.write("hasTheme(ec_" + i + ",ev_" + i + ").\n");

                    //TBox:Evaluate(ev) + thematic roles
                pw.write("evaluate(ev_" + i +").\n");
                pw.write("hasAgent(ev_" + i + ",x_" + i + ").\n");
                pw.write("hasTheme(ev_" + i + ",p_" + i + ").\n");
                pw.write("hasResult(ev_" + i + ",r_" + i + ").\n");

                    //TBox:Grant(eg) + thematic roles
                pw.write("grant(eg_" + i +").\n");    
                pw.write("hasAgent(eg_" + i + ",y_" + i + ").\n");
                pw.write("hasReceiver(eg_" + i + ",x_" + i + ").\n");
                pw.write("hasTheme(eg_" + i + ",l_" + i + ").\n");
                
                    //TBox:Publish(epc) + thematic roles
                pw.write("publish(epc_" + i +").\n");
                pw.write("hasAgent(epc_" + i + ",x_" + i + ").\n");
                pw.write("hasTheme(epc_" + i + ",c_" + i + ").\n");
                pw.write("isCommentOf(c_" + i + ",ev_" + i + ").\n");
                
                    //TBox:Publish(epr) + thematic roles
                pw.write("publish(epr_" + i +").\n");
                pw.write("hasAgent(epr_" + i + ",x_" + i + ").\n");
                pw.write("hasTheme(epr_" + i + ",r_" + i + ").\n");

                    //TBox:Remove(er) + thematic roles                
                pw.write("remove(er_" + i +").\n");
                pw.write("hasAgent(er_" + i + ",x_" + i + ").\n");
                pw.write("hasTheme(er_" + i + ",r_" + i + ").\n");
                
                    //We randomly assign Rexist to the six actions
                if(distribution[i][0])pw.write("rexist(ea_" + i + ").\n");
                if(distribution[i][1])pw.write("rexist(ec_" + i + ").\n");
                if(distribution[i][2])pw.write("rexist(ev_" + i + ").\n");
                if(distribution[i][3])pw.write("rexist(eg_" + i + ").\n");
                if(distribution[i][4])pw.write("rexist(epc_" + i + ").\n");
                if(distribution[i][5])pw.write("rexist(epr_" + i + ").\n");
                if(distribution[i][6])pw.write("rexist(er_" + i + ").\n");
            }

            pw.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public static void prolegABox(File outputFile, int size, boolean[][] distribution)
    {
        try
        {
                //For ASP, we just output lines on a text file.
                //The boolean above are needed to check which lines we already asserted.
            PrintWriter pw = new PrintWriter(new FileWriter(outputFile));
            
            pw.write(":- style_check(-singleton).\n");
            pw.write(":- discontiguous fact/1.\n");
            pw.write(":- [ \"./prolegEng2.pl\", \"./regulative+compliance_rules.pl\" ].\n");
            
            for (int i = 0; i < size; i++) 
            {
                    /******************* Individual *******************/
                    //To make it simpler, we generate all *indexed* individuals, both the actions (approve, evaluate, etc.)
                    //and the persons or objects (licensee, licensor, result, etc.).
                    //Then, we will randomly assign "Rexist" to the six actions.
                pw.write("fact(licensee_f(x_" + i +")).\n");
                pw.write("fact(licensor_f(y_" + i +")).\n");
                pw.write("fact(product_f(p_" + i +")).\n");
                pw.write("fact(result_f(r_" + i +")).\n");
                pw.write("fact(licence_f(l_" + i +")).\n");
                pw.write("fact(isLicenceOf_f(l_" + i + ",p_" + i + ")).\n");
                pw.write("fact(comment_f(c_" + i +")).\n");
                        
                    //TBox:Approve(ea) + thematic roles
                pw.write("fact(approve_f(ea_" + i +")).\n");
                pw.write("fact(hasAgent_f(ea_" + i + ",y_" + i + ")).\n");
                pw.write("fact(hasTheme_f(ea_" + i + ",epr_" + i + ")).\n");

                    //TBox:Commission(ec) + thematic roles
                pw.write("fact(commission_f(ec_" + i +")).\n");
                pw.write("fact(hasTheme_f(ec_" + i + ",ev_" + i + ")).\n");

                    //TBox:Evaluate(ev) + thematic roles
                pw.write("fact(evaluate_f(ev_" + i +")).\n");
                pw.write("fact(hasAgent_f(ev_" + i + ",x_" + i + ")).\n");
                pw.write("fact(hasTheme_f(ev_" + i + ",p_" + i + ")).\n");
                pw.write("fact(hasResult_f(ev_" + i + ",r_" + i + ")).\n");

                    //TBox:Grant(eg) + thematic roles
                pw.write("fact(grant_f(eg_" + i +")).\n");    
                pw.write("fact(hasAgent_f(eg_" + i + ",y_" + i + ")).\n");
                pw.write("fact(hasReceiver_f(eg_" + i + ",x_" + i + ")).\n");
                pw.write("fact(hasTheme_f(eg_" + i + ",l_" + i + ")).\n");
                
                    //TBox:Publish(epc) + thematic roles
                pw.write("fact(publish_f(epc_" + i +")).\n");
                pw.write("fact(hasAgent_f(epc_" + i + ",x_" + i + ")).\n");
                pw.write("fact(hasTheme_f(epc_" + i + ",c_" + i + ")).\n");
                pw.write("fact(isCommentOf_f(c_" + i + ",ev_" + i + ")).\n");
                
                    //TBox:Publish(epr) + thematic roles
                pw.write("fact(publish_f(epr_" + i +")).\n");
                pw.write("fact(hasAgent_f(epr_" + i + ",x_" + i + ")).\n");
                pw.write("fact(hasTheme_f(epr_" + i + ",r_" + i + ")).\n");

                    //TBox:Remove(er) + thematic roles                
                pw.write("fact(remove_f(er_" + i +")).\n");
                pw.write("fact(hasAgent_f(er_" + i + ",x_" + i + ")).\n");
                pw.write("fact(hasTheme_f(er_" + i + ",r_" + i + ")).\n");
                
                    //We randomly assign Rexist to the six actions
                if(distribution[i][0])pw.write("fact(rexist_f(ea_" + i + ")).\n");
                if(distribution[i][1])pw.write("fact(rexist_f(ec_" + i + ")).\n");
                if(distribution[i][2])pw.write("fact(rexist_f(ev_" + i + ")).\n");
                if(distribution[i][3])pw.write("fact(rexist_f(eg_" + i + ")).\n");
                if(distribution[i][4])pw.write("fact(rexist_f(epc_" + i + ")).\n");
                if(distribution[i][5])pw.write("fact(rexist_f(epr_" + i + ")).\n");
                if(distribution[i][6])pw.write("fact(rexist_f(er_" + i + ")).\n");
                
                    //Now we add the queries:
                pw.write("violation_ev_"+i+" :- "
                            + "write(\"\\n-------------\\n\"), "
                            + "answer(violation(viol(ev_"+i+"))).\n");
                pw.write("violation_epr_"+i+" :- "
                            + "write(\"\\n-------------\\n\"), "
                            + "answer(violation(viol(epr_"+i+"))).\n");
                pw.write("violation_epc_"+i+" :- "
                            + "write(\"\\n-------------\\n\"), "
                            + "answer(violation(viol(epc_"+i+"))).\n");
                pw.write("violation_er_"+i+" :- "
                            + "write(\"\\n-------------\\n\"), "
                            + "answer(violation(viol(ca(epr_"+i+", x_"+i+", r_"+i+")))).\n");
            }

            pw.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public static void arg2pABox(File outputFile, int size, boolean[][] distribution)
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
                if(distribution[i][0]){pw.write("f"+factCounter+" :-> rexist(ea_" + i + ").\n");factCounter++;}
                if(distribution[i][1]){pw.write("f"+factCounter+" :-> rexist(ec_" + i + ").\n");factCounter++;}
                if(distribution[i][2]){pw.write("f"+factCounter+" :-> rexist(ev_" + i + ").\n");factCounter++;}
                if(distribution[i][3]){pw.write("f"+factCounter+" :-> rexist(eg_" + i + ").\n");factCounter++;}
                if(distribution[i][4]){pw.write("f"+factCounter+" :-> rexist(epc_" + i + ").\n");factCounter++;}
                if(distribution[i][5]){pw.write("f"+factCounter+" :-> rexist(epr_" + i + ").\n");factCounter++;}
                if(distribution[i][6]){pw.write("f"+factCounter+" :-> rexist(er_" + i + ").\n");factCounter++;}
            }

            pw.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
//SPINdle è il più complesso, lo mettiamo al fondo
    private static File SPINdleRules = new File(CORPUS.getAbsolutePath()+"\\SPINdle\\SPINdle_regulative+compliance_rules.dfl");
    public static void SPINdleABox(File outputFile, int size, boolean[][] distribution)
    {
        try
        {
                //In the same folder of the outputFile, there is a file with the rules that need to be adapted.
            ArrayList<String> rules = extractRules(SPINdleRules);
            
                //For ASP, we just output lines on a text file.
                //The boolean above are needed to check which lines we already asserted.
            PrintWriter pw = new PrintWriter(new FileWriter(outputFile));

            for (int i = 0; i < size; i++) 
            {
                ArrayList<String> indexedRules = indexSPINdleRules(rules, i);
                for(String rule:indexedRules)pw.println(rule);

                    //Besides the indexed rules, we also put the actions. Indeed, these "actions" also encompasses
                    //the thematic roles, as they are propositional symbols.
                pw.write(">> Approve_ea_" + i +"\n");
                pw.write(">> Commission_ec_" + i +"\n");
                pw.write(">> Evaluate_ev_" + i +"\n");
                pw.write(">> Grant_eg_" + i +"\n");
                pw.write(">> Publish_epc_" + i +"\n");
                pw.write(">> Publish_epr_" + i +"\n");
                pw.write(">> Remove_er_" + i +"\n");
                if(distribution[i][0])pw.write(">> Rexist_ea_" + i + "\n");
                if(distribution[i][1])pw.write(">> Rexist_ec_" + i + "\n");
                if(distribution[i][2])pw.write(">> Rexist_ev_" + i + "\n");
                if(distribution[i][3])pw.write(">> Rexist_eg_" + i + "\n");
                if(distribution[i][4])pw.write(">> Rexist_epc_" + i + "\n");
                if(distribution[i][5])pw.write(">> Rexist_epr_" + i + "\n");
                if(distribution[i][6])pw.write(">> Rexist_er_" + i + "\n");
            }

            pw.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
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
    
    private static ArrayList<String> indexSPINdleRules(ArrayList<String> rules, int index)throws Exception
    {
        ArrayList<String> ret = new ArrayList<String>();
        
        for(String rule:rules)
        {
                //deontic modalities
            if(rule.indexOf("[O]:")!=-1)
                rule =  rule.substring(0, rule.indexOf("[O]:")).trim()+"_"+index+
                        "[O]: "+
                        rule.substring(rule.indexOf("[O]:")+"[O]:".length(), rule.length()).trim();
            else if(rule.indexOf("[P]:")!=-1)
                rule =  rule.substring(0, rule.indexOf("[P]:")).trim()+"_"+index+
                        "[P]: "+
                        rule.substring(rule.indexOf("[P]:")+"[P]:".length(), rule.length()).trim();
            else if(rule.indexOf(":")!=-1)//if we are here it is a rule without deontic modality. eg., "condition2:"
                rule =  rule.substring(0, rule.indexOf(":")).trim()+"_"+index+
                        ": "+
                        rule.substring(rule.indexOf(":")+":".length(), rule.length()).trim();
            
                //variables
            String[] variables = new String[]{"ev","eg","epr","epc","ea","ec","er"};
            for(String variable:variables)
            {
                while((rule.indexOf("_"+variable)!=-1)&&(rule.lastIndexOf("_"+variable)==rule.length()-("_"+variable).length()))
                    rule =  rule.substring(0, rule.lastIndexOf("_"+variable)).trim()+
                            "_"+variable+"_"+index;
                while(rule.indexOf("_"+variable+" =>")!=-1)
                    rule =  rule.substring(0, rule.indexOf("_"+variable+" =>")).trim()+
                            "_"+variable+"_"+index+" => "+
                            rule.substring(rule.indexOf("_"+variable+" =>")+("_"+variable+" =>").length(), rule.length()).trim();
                while(rule.indexOf("_"+variable+",")!=-1)
                    rule =  rule.substring(0, rule.indexOf("_"+variable+",")).trim()+
                            "_"+variable+"_"+index+", "+
                            rule.substring(rule.indexOf("_"+variable+",")+("_"+variable+",").length(), rule.length()).trim();
                while(rule.indexOf(" "+variable+"_")!=-1)
                    rule =  rule.substring(0, rule.indexOf(" "+variable+"_")).trim()+
                            " "+variable+"_"+index+"_"+
                            rule.substring(rule.indexOf(" "+variable+"_")+(" "+variable+"_").length(), rule.length()).trim();
                while(rule.indexOf(","+variable+"_")!=-1)
                    rule =  rule.substring(0, rule.indexOf(","+variable+"_")).trim()+
                            ","+variable+"_"+index+"_"+
                            rule.substring(rule.indexOf(","+variable+"_")+(","+variable+"_").length(), rule.length()).trim();
            }
            
                //Superiority relations...
            if(rule.indexOf(" > ")!=-1)
                rule =  rule.substring(0, rule.indexOf(">")).trim()+"_"+index+" "+
                        rule.substring(rule.indexOf(">"), rule.length()).trim()+"_"+index;
            
            ret.add(rule);
        }

        return ret;
    }
    
    
    private static void recreateOUTPUTfolder(File output)
    {
        File SHACL = new File(output.getAbsolutePath()+"//SHACL");
        File ASP = new File(output.getAbsolutePath()+"//ASP");
        File PROLEG = new File(output.getAbsolutePath()+"//PROLEG");
        File SPINdle = new File(output.getAbsolutePath()+"//SPINdle");
        File Arg2P = new File(output.getAbsolutePath()+"//Arg2P");
        
        for(File f:SHACL.listFiles())while(f.exists())f.delete();
        for(File f:ASP.listFiles())while(f.exists())f.delete();
        for(File f:PROLEG.listFiles())while(f.exists())f.delete();
        for(File f:SPINdle.listFiles())
            if(f.getName().compareToIgnoreCase("SPINdle_regulative+compliance_rules.dfl")!=0)
                while(f.exists())f.delete();
        for(File f:Arg2P.listFiles())while(f.exists())f.delete();
    }
}
