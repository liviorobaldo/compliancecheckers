<p align="justify">
This folder contains the implementation of the use case as <a href="https://potassco.org/">ASP rules</a>. The use case has been implemented within the file <b>regulative+compliance_rules.asp</b>. This file contains both the regulative rules, able to infer which actions of the state of affairs are prohibited, obligatory, or permitted, and the rules for checking compliance of the derived prohibitions and obligations. In ASP, the order/priority of the rules is immaterial as the ASP reasoner looks for an answer set that satisfies all rules at once.
</p>

<p align="justify">The file <b>regulative+compliance_rules.asp</b> derives a violation for either all prohibitions that took place in the state of affairs and were not compensated <i>and</i> for all obligations that did not take place in the state of affairs and were not compensated. These violations are inserted in the returned answer set.

<p align="justify">
The state of affairs is described in one of the synthetic datasets (ABox) created by the <a href="https://github.com/liviorobaldo/compliancecheckers/tree/main/DatasetGenerator">dataset generator available on this GitHub</a>. Each ABox is a collection of ASP facts describing the state of affairs.
</p>

<p align="justify">
In order to execute ASP rules, you need to install an ASP reasoner. ASP is widely used in AI since decades, so that many ASP reasoners are freely available nowadays.</p>

<p align="justify"> 
For this experiment, we used:

<ul>
	<li>
	The clingo reasoner v5.5.1 available <a href="https://github.com/potassco/clingo/releases">at this link</a>. Clingo runs on Python, so that you first need to install <a href="https://www.python.org/">Python</a> and <a href="https://pypi.org/project/pip/">Pip</a> and then write "<i>pip install clingo</i>" on a shell. You can of course use other Python package installers in place of pip, e.g., Anaconda (see instructions <a href="https://github.com/potassco/clingo/releases">here</a>).
	</li>
	<li>
	The DLV2 reasoner available <a href="https://drive.google.com/file/d/1apzJvPM9ca8kyAAkRoM4mAbc7JEzO7UD/view">at this link</a>. In the file <b>dlv2.zip</b> that you download from this link, you will also find a Python script (<b>dlv2.py</b>) to run the reasoner on all datasets created by the generator. To execute this script, you first need to install <a href="https://www.python.org/">Python</a> (see previous point).
	</li>
</ul>
</p>

<p align="justify">
Once the reasoners are properly installed, you just run the instructions in the file <i>run.bat</i>. These will first execute a local Java file (<b>createClingoRunFile.java</b> or <b>createDLV2RunFile.java</b>) that will generate indexed copies of the file <b>regulative+compliance_rules.asp</b> within the subfolder <b>INDEXED_RULES</b> as well as a file <b>run2.bat</b> that will execute the indexed rules one by one.
</p>
