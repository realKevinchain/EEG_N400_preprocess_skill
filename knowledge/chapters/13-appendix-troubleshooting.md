# 13: Appendix 2: Troubleshooting Guide

> Source: *Applied Event-Related Potential Data Analysis* (Steven J. Luck), `Full.pdf`, PDF pages 346-363. Text is a mechanical page-by-page extraction, not a summary. Consult the PDF for figures and layout.

<!-- source_pdf=Full.pdf pdf_page=346 source_page_label="1" source_url="" -->

## PDF page 346

- Source page label: 1
- LibreTexts source: not printed on page

CHAPTER OVERVIEW
13: Appendix 2: Troubleshooting Guide
Overview
Computers can be maddening. No matter how much we test ERPLAB, we still get occasional bug reports. There can also be bugs
in EEGLAB, in Matlab, or in your operating system. Even if there isn’t a bug, EEGLAB, ERPLAB, you might encounter a
problem because you specify an incorrect setting or leave out a necessary step. And if you’re writing your own scripts, you’re
likely to introduce your own bugs. I can’t tell you how much time I spent troubleshooting problems when I was writing this book!
As I mentioned in Chapter 1, you should look at these problems as an opportunity for working on your general problem-solving
skills. Indeed, I find that troubleshooting computer problems is like a microcosm of science. You generate hypotheses, you collect
data to test those hypotheses, and you make sure that you can replicate both the problem and the solution.
In this Troubleshooting Guide, I’ve provided a variety of hints and strategies for solving the most common types of problems
you’re like to encounter. This includes both specific strategies for issues that often arise in Matlab, EEGLAB, and ERPLAB, along
with general strategies for solving computer problems and debugging computer programs. I’ve also provided some exercises to
help you learn to interpret Matlab’s error messages and to monitor the operation of a script while it’s running.
13.1: A2.1 The First Step
13.2: A2.2 Some Basic Solutions
13.3: A2.3 Taking a Scientific Approach
13.4: A2.4 Deciphering Matlab’s Error Messages
13.5: A2.5 Debugging Scripts by Performing Experiments and Collecting Data
13.6: A2.6 Avoiding Bugs in Your Scripts with Good Programming Practices
13.7: A2.7 References
This page titled 13: Appendix 2: Troubleshooting Guide is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven
J Luck directly on the LibreTexts platform.
1

<!-- source_pdf=Full.pdf pdf_page=347 source_page_label="13.1.1" source_url="https://socialsci.libretexts.org/@go/page/137510" -->

## PDF page 347

- Source page label: 13.1.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137510

13.1: A2.1 The First Step
Here’s something that should be obvious but often isn’t: When you run into a problem you can’t easily solve, you should read
the documentation and online help. Over half of the “bug reports” we get for ERPLAB aren’t bugs at all but are simple
misunderstandings. These misunderstandings typically arise when someone starts using ERPLAB without spending the time to go
through our tutorial, when someone tries to use a complicated feature without first reading the documentation for that feature, or
when someone encounters a common issue but hasn’t consulted our Frequently Asked Questions page. In tech support, these are
called RTFM problems. Google RTFM if this is an unfamiliar term and you’d like a quick smile.
Here are the main sources of EEGLAB and ERPLAB information:
EEGLAB: Online Documentation, Frequently Asked Questions
ERPLAB: Online documentation, Frequently Asked Questions, Tutorial
You can also often find solutions by typing something like ERPLAB binlister or EEGLAB ICA into a search engine. You can
also post questions to email list for EEGLAB or the email list for ERPLAB. But please don’t send me a personal email—I don’t
have the bandwidth to provide individualized tech support for everyone who uses ERPLAB.
This page titled 13.1: A2.1 The First Step is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck
directly on the LibreTexts platform.
13.1.1 https://socialsci.libretexts.org/@go/page/137510

<!-- source_pdf=Full.pdf pdf_page=348 source_page_label="13.2.1" source_url="https://socialsci.libretexts.org/@go/page/137494" -->

## PDF page 348

- Source page label: 13.2.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137494

13.2: A2.2 Some Basic Solutions
Resetting and Restarting
If restarting EEGLAB doesn’t work, I try restarting Matlab. Again, this is especially useful when I’m encountering a weird
problem. If that doesn’t work, I try resetting ERPLAB’s working memory. This is a file that ERPLAB uses to store your current
settings. The problem you’re having might be a side effect of one of your settings, or the settings may have become corrupted, so
clearing the settings sometimes helps. To do this, select EEGLAB > ERPLAB > Settings > ERPLAB Memory Settings > Reset
ERPLAB’s working memory.
And if restarting Matlab and resetting ERPLAB’s working memory doesn’t work, and the problem is really odd, I try restarting my
computer. But that’s very rare. And just like I restart EEGLAB on a regular basis to prevent problems, I recommend restarting your
computer once a week or so. If the weird problem persists, you might try moving to a different computer to see if that solves the
problem.
Finally, you can try uninstalling and reinstalling EEGLAB and ERPLAB. Although rare, it is possible that the code has been
corrupted. I recently encountered a case of a user who reported that one of the ERPLAB dialog boxes was missing some buttons,
and she found that reinstalling ERPLAB solved the problem.
Missing Channel Locations or Data Quality Metrics in Datasets or ERPsets
Are your channel locations or data quality metrics missing from a dataset or ERPset? The most common reason for this is that you
have applied EEG Channel Operations, ERP Channel Operations, or ERP Bin Operations to your data.
When you apply EEG or ERP Channel Operations, ERPLAB may not be able to figure out the location information for your new
channel. For example, when you create a new channel, how can ERPLAB know the 3-D location of this new channel? Indeed, if
you create a channel that is the average of several electrode sites, it doesn’t really have a location. There is a box you can check in
the GUI labeled Try to preserve location information, and it can preserve the channel locations in many cases (e.g., when you re-
reference your data). But it uses a fairly simple algorithm, and it may strip out your previous channel location information if the
algorithm can’t figure out a sensible set of locations.
A similar issue arises for the data quality metrics that are computed during averaging. If you modify the channels using ERP
Channel Operations or modify the bins using ERP Bin Operations to your data, ERPLAB has no way of knowing whether the
data quality metrics are still valid. For example, if you create a new bin with a difference wave or an average of two prior bins,
what is the data quality for this new bin? There may be analytic solutions for some cases, but these solutions would require many
assumptions. As a result, ERPLAB strips out the data quality information from the ERPset that is created when you run ERP
Channel Operations or ERP Bin Operations. Our logic in stripping out the channel location information or data quality metrics
in these situations is that we’d rather eliminate the information than provide you with incorrect or misleading information.
Solutions to Miscellaneous Common Problems
Make sure the MATLAB PATH is set correctly (especially if you’re having problems right after installing a new version). See
the section describing the Matlab PATH near the end of Chapter 1 for more details.
If you don’t see ERPLAB in the EEGLAB GUI, make sure that ERPLAB is installed inside the plugins folder within the
EEGLAB folder (e.g., eeglab2020_0 > plugins > ERPLAB8.30). You should see a file named eegplugin_erplab.m inside that
folder (and not inside another folder).
Make sure you’re using the right version of Matlab, EEGLAB, ERPLAB.
Some ERPLAB functions (e.g., filtering) require the Matlab Signal Processing Toolbox. You may need to install this toolbox. If
you purchased Matlab yourself, you may need to buy this toolbox from The Mathworks. If you obtained Matlab through your
institution, ask your IT group how to get this toolbox.
If EEGLAB/ERPLAB/Matlab doesn’t seem to respond to the mouse or keyboard, you may have a window hidden somewhere
that’s waiting for input. For example, if you open the GUI for filtering, and then you look at another window, the filtering GUI
may be waiting for input, and nothing else will work right until you close the filtering GUI. In general, “figures” can be left
open without interfering with other operations, but dialog boxes cannot.
13.2.1 https://socialsci.libretexts.org/@go/page/137494

<!-- source_pdf=Full.pdf pdf_page=349 source_page_label="13.2.2" source_url="https://socialsci.libretexts.org/@go/page/137494" -->

## PDF page 349

- Source page label: 13.2.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137494

If you load an EEG dataset and try to view the EEG data with EEGLAB > Plot > Channel data (scroll), but some or all of the
channels appear to be missing, the DC offset of the EEG signal is probably shifting the EEG outside of the range that is visible
in the plotting window. To solve this, select Display > Remove DC offset in the plotting window.
If you have trouble plotting ERP waveforms, click the RESET button in the plotting GUI to get rid of custom settings.
EEGLAB also has a routine for extracting epochs from the continuous EEG (EEGLAB > Tools > Extract epochs), but do not
use it!!! Instead, use ERPLAB > Extract bin-based epochs.
Don’t forget to read the Frequently Asked Questions (FAQ) pages for both EEGLAB and ERPLAB.
Also, EEGLAB and ERPLAB often print information in the command window that can help you figure out why things aren’t
working properly.
This page titled 13.2: A2.2 Some Basic Solutions is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
13.2.2 https://socialsci.libretexts.org/@go/page/137494

<!-- source_pdf=Full.pdf pdf_page=350 source_page_label="13.3.1" source_url="https://socialsci.libretexts.org/@go/page/137499" -->

## PDF page 350

- Source page label: 13.3.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137499

13.3: A2.3 Taking a Scientific Approach
You’re a scientist, right? This means that you’ve been trained to develop and test hypotheses. That’s exactly what you do when
you’re troubleshooting and debugging. That is, you need to come up with a hypothesis about the nature of the problem and then
figure out how to test that hypothesis. This section will flesh out the scientific approach to finding and fixing problems with
ERPLAB and EEGLAB.
The Importance of Replication
If you really want to understand a problem, you first need to make sure that you can replicate it. Does it persist after you restart
Matlab? Do you get the same problem on a different computer?
Also, once you think you’ve found the solution, you should make sure that you can make the problem reappear and then disappear
again. For example, imagine that a part of ERPLAB keeps crashing when you try to run a particular processing step, and you try 12
different things to make it stop crashing. And you finally get it to work after installing a new version of EEGLAB. Was the
EEGLAB version really the problem? After all, you probably updated the PATH when you installed the new version of EEGLAB,
so perhaps the PATH was the problem. If you want to be sure that it was a version problem, you should try going back to the
previous version and seeing if ERPLAB crashes again. And then you should verify that updating the version again eliminates the
crash. In experimental psychology, this is often called the ABAB experimental design.
In many cases, you don’t actually care whether you fully understand the problem, and this ABAB approach is unnecessary. Once
the program is no longer crashing, you may not care what was causing the crash. But in other cases it’s really important to
understand the problem. For example, imagine that you’re writing a script, and you find that you can get your script to run by
sending some parameter that you don’t really understand when calling an ERPLAB function. Do you really trust that you’ve now
solved the problem? In this kind of situation, the ABAB approach is usually worth the time and effort.
Start with a Literature Review
When you’re designing an ERP experiment, you already know that it’s important to read the relevant literature so that you know
what has already been done in your research area and so that you can learn about useful methods for answering your scientific
question. Without the necessary background knowledge, you probably won’t have a good hypothesis and probably won’t design a
good experiment.
When troubleshooting or debugging, the analog is to read the documentation, do the tutorials, and scan the frequently asked
questions page. If you don’t take these steps first, you’re likely to waste a lot of time pursuing bogus hypotheses about the source
of the problem and trying solutions that are unlikely to work.
Carefully Observe the World and then Develop a Hypothesis
You were probably taught the “scientific method” when you were in elementary school. In the usual version, a scientist observes
the world, develops a hypothesis, and then conducts an experiment to test the hypothesis. This is a gross mischaracterization of
how science actually works (see, e.g., Feyerabend, 1993). However, this oversimplification is useful for troubleshooting and
debugging, especially insofar as it proposes that you should carefully observe the world in the process of developing your
hypothesis about the source of the problem.
In the context of software troubleshooting, this means that you should look carefully at the inputs and outputs. The main inputs are
the data that are being processed and the parameters that are specified (either the settings in the GUI or the values that are being
sent to a function in a script). The main outputs are the messages printed in Matlab’s command window (including but not limited
to error messages) and the output data that are created. I particularly recommend taking a careful look at the parameters and the
error messages (because the data are usually so complicated that you need a hypothesis before knowing what to look for).
Matlab error messages often appear to be written in a language that you don’t speak (Programmerese). But if you spend enough
time looking at the messages, you may find that you know enough of the words to glean some valuable information. You may be
able to get some insight by typing the key part of the message into a search engine, enclosed in double quotes and preceded by
matlab. For example, if you get the error message character Vector Is Not Terminated Properly, you can type this into Google:
13.3.1 https://socialsci.libretexts.org/@go/page/137499

<!-- source_pdf=Full.pdf pdf_page=351 source_page_label="13.3.2" source_url="https://socialsci.libretexts.org/@go/page/137499" -->

## PDF page 351

- Source page label: 13.3.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137499

matlab "character Vector Is Not Terminated Properly". A later section of this appendix provides more detailed information
about how to decipher Matlab’s error messages.
The error message will tell you which lines of code generated the error message, both in your script and inside a function you were
calling when the problem occurred. This is a major clue. You can then open the code for the function and see what was happening
in that function. But keep this in mind: The actual problem in the code may have been several lines before the problem was
detected, so you should look at that whole section of code.
Once you’ve done your careful observation, you should be able to develop a hypothesis.
Run Experiments and Collect New Data to Refine and Test Your Hypothesis
Now it’s time to test your hypothesis. Sometimes this is trivial: You hypothesize that you need to update your version of EEGLAB,
and you then see if updating EEGLAB solves the problem. But in other cases, your hypothesis does not specify the solution, but is
instead a more general hypothesis, such as which part of the code is the problem or which variable might not be set properly. In
these cases, you need to figure out how to test your hypothesis.
The method for testing your hypothesis will, of course, depend on the nature of your hypothesis. However, there are two general
strategies, which are analogous to recording versus manipulating brain activity. That is, you can examine the representations that
your code produces (e.g., values of variables, output files) at various steps in processing, or you can attempt to modify the
operation of the code (e.g., by changing the inputs or by turning off various parts of the code). I’ll say more about these options in a
later section.
Science is Social!
One of the main shortcomings of the elementary school version of the scientific method is that it does not treat science as a deeply
human, social activity. Much of science is driven by vanity, competition, and cooperation. I wouldn’t recommend vanity or
competition when you’re troubleshooting or debugging, but cooperation is extremely valuable. More specifically, if you get stuck,
get advice from other people. This could be a more experienced EEGLAB/ERPLAB/Matlab person in your lab or your department.
Or it could be some stranger on the Internet. (The part of the Internet inhabited by programmers and scientists is much kinder and
more helpful than most other parts.)
Often, your question has already been answered. EEGLAB has an extremely active listserv, which you can join. You can then
search the archive to see if your question has already come up. ERPLAB also has a listserv with a searchable archive. If you don’t
see an answer to your question, post it to the listserv.
If you’re writing a script and having a problem with a built-in Matlab function, or you’re having a problem figuring out the right
syntax, you can probably find an answer on the Internet. The two best sources of answers are the resources provided by Matlab and
the StackOverflow forum. I usually just type something like this into Google: Matlab “sorting a list”. I probably did that 300
times while writing this book!
Rubber Duck Debugging
If you can’t find the solution to your problem online, it might be time to ask a colleague. However, you might not have an
appropriate colleague, or you might not want to bother anyone. In these cases, you can try something called rubber duck
debugging. This concept comes from the observation that when you go to ask someone for help, the process of explaining the
problem to that person often leads you to realize the answer. So, you really just need to try explaining the problem. Instead of
taking up someone else’s time with this, you can just explain the problem to a rubber duck (Thomas & Hunt, 2019). Of course, it
doesn’t need to be a rubber duck. It can be a plant, your dog, a photo of Einstein, etc. You can even try writing an email to an
imaginary friend explaining the problem. The key is to describe the problem carefully in natural language. I like this approach so
much that I bought rubber ducks for everyone in my lab (Figure A2.1).
13.3.2 https://socialsci.libretexts.org/@go/page/137499

<!-- source_pdf=Full.pdf pdf_page=352 source_page_label="13.3.3" source_url="https://socialsci.libretexts.org/@go/page/137499" -->

## PDF page 352

- Source page label: 13.3.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137499

Figure A2.1. Rubber ducks for debugging. They’re always happy to listen to you talk about your code, and they never judge you.
This page titled 13.3: A2.3 Taking a Scientific Approach is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
13.3.3 https://socialsci.libretexts.org/@go/page/137499

<!-- source_pdf=Full.pdf pdf_page=353 source_page_label="13.4.1" source_url="https://socialsci.libretexts.org/@go/page/137501" -->

## PDF page 353

- Source page label: 13.4.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137501

13.4: A2.4 Deciphering Matlab’s Error Messages
As noted in the previous section, Matlab’s error messages are often helpful when you’re developing a hypothesis about the cause of
your problem. In this section, we’ll do some exercises that are designed to help you learn how to decipher these messages.
Before we do the exercises, we need to divide software problems into three categories:
A syntax error occurs when the script contains information that is not legal Matlab code. Often, this is a result of a typo (e.g., a
missing comma). When you run a script, Matlab first checks for syntax errors, and the script won’t even start running if a
syntax error is detected. Instead, an error message is printed in the command window.
A runtime error occurs when the code, while legal in its syntax, produces some kind of problem that causes the script to
terminate with an error message in the command window. For example, if the script tries to open a file with a specific name, but
no file with that name exists in the PATH, the script will terminate with an error message.
A logical error occurs when the program runs to completion without an error message, but the result is incorrect. This usually
means that the code in the script does not correctly implement the desired processing steps, but it sometimes means that the
input data violate the assumptions of the script.
Note that only syntax errors and runtime errors produce error messages. Logical errors are usually the most difficult to diagnose
and solve.
Now it’s time to try some exercises. These exercises require scripts and data in the Appendix_2 folder in the master folder:
https://doi.org/10.18115/D50056.
Exercise A2.1: A Syntax Error
Launch EEGLAB, make Appendix_2 the current folder, and double-click on Test_Case_1.m in the Current Folder panel of the
Matlab GUI. This should open the script in the Matlab editor. It’s a very simple script, but it has a bug. Click the Run button in the
editor window to run the script. You should see the following error message in the Command Window:
Error: File: Test_Case_1.m Line: 3 Column: 30
Character vector is not terminated properly.
This message tells you where in the script it detected a problem (Line 3, Column 30), and it tells you the nature of the problem
("Character vector is not terminated properly"). However, the nature of the problem is described in Programmerese, so you might
not understand what the error message means.
However, at least it tells you what line was running when the error message was generated (Line 3). Take a look at Line 3 of the
Test_Case_1.m script. This line is trying to open a dataset named 1_N170.set. Notice that the text '1_N170.set); is underlined in
red. This is Matlab’s way of telling you that it think this part of the code is a syntax error. If you hover your mouse over this part of
the code, some more Programmerese pops up, saying "A quoted character vector is unterminated." Even if you don’t fully
understand this message, you should be able to infer that there is some problem with the termination of the filename, 1_N170.set.
This filename is specified as a text string, and Matlab text strings need to be enclosed in single quote characters (e.g.,
'1_N170.set'). Otherwise Matlab doesn’t know where the string starts and stops. In this script, we are missing the single quote that
terminates the string. That’s what Matlab means when it tells you "Character vector is not terminated properly". This is a very
common error that I made at least a dozen times when preparing the scripts in this book.
Try adding a single quote mark after .set in the script. You’ll see that the red underline disappears from under this string. Now try
running the script. Voila! No more error message.
If you can’t figure out an error message in this way, try Googling it (e.g., with the search phrase matlab "character Vector Is Not
Terminated Properly"). When I did this, I found a page on stackallflow.com that proposed a good solution.
Exercise A2.2: A More Subtle Syntax Error
Close Test_Case_1.m and double-click on Test_Case_2.m to load it in the Matlab editor. Click the Run button in the editor
window to run the script. You should see the following error message in the Command Window:
13.4.1 https://socialsci.libretexts.org/@go/page/137501

<!-- source_pdf=Full.pdf pdf_page=354 source_page_label="13.4.2" source_url="https://socialsci.libretexts.org/@go/page/137501" -->

## PDF page 354

- Source page label: 13.4.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137501

File: Test_Case_2.m Line: 4 Column: 26
Invalid expression. When calling a function or indexing a variable, use parentheses.
Otherwise, check for mismatched delimiters.
Take a look at Line 4 of the script. The error message says that this is an "Invalid expression" — not very informative.
Do you see anything marked as problematic by Matlab in the editor window? If you look very closely, you’ll see that a right square
bracket near the middle of the line is underlined in red, as is a right parenthesis near the end of the line. Matlab isn’t sure which one
of these is the source of the problem, so you now have two hypotheses to examine.
When there are problems with square brackets or parentheses (which Matlab calls “delimiters”), this usually means that they’re not
paired properly. That is, every left bracket needs a corresponding right bracket. To fix a problem like this, you need to make sure
that each delimiter has a pair and that both delimiters are in the correct places. If you look closely at Line 4, you’ll see that there is
a left parenthesis that is correctly paired with the underlined right parenthesis.
But if you look at the square brackets, you’ll see that there are two right brackets and only one left bracket. This means you need to
figure out if we are missing a left bracket or if we have a right bracket that shouldn’t be there. In this case, the problem is an extra
right bracket. Try deleting the underlined right bracket. You should see that the red underlines disappear, including the one under
the right parenthesis. Now try running the script. It should now run properly.
Exercise A2.3: A Simple Runtime Error
Close Test_Case_2.m, double-click on Test_Case_3.m, and click the Run button to run the script. You should see the following
error message in the Command Window:
Unrecognized function or variable 'EGG'.
Error in Test_Case_3 (line 4)
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EGG, 0 );
This error message is actually reasonably easy to understand: There is a variable named EGG on Line 4 that isn’t recognized.
There are usually two possible explanations for this kind of problem. The first is that the variable is defined in the wrong part of the
program, so it hasn’t yet been defined when Matlab tries to execute Line 4. You can just search for the variable to see if it’s defined
later. The second common explanation is a simple typo. In this case, it’s pretty clear that variable is supposed to be named EEG,
not EGG. If you change the name to EEG and run the script, you’ll find that the problem has been eliminated.
Note that Matlab doesn’t underline any of the code in the script when it detects this error. That’s because it’s a runtime error rather
than a syntax error. In other words, Line 4 is perfectly legitimate Matlab code when considered in isolation. It’s only a problem in
the context of the rest of the code (i.e., because no variable named EGG has been defined on lines that execute before Line 4).
Exercise A2.4: A Slightly More Complicated Runtime Error
Close Test_Case32.m, double-click on Test_Case_4.m, and run the script. You should see the following error message in the
Command Window:
Error using load
Unable to find file or directory
'/Users/luck/Dropbox/Research/Manuscripts/ERP_Analysis_Book/Appendix_2_Troubleshooting/
Exercises1_N170.set'.
Error in pop_loadset (line 139)
TMPVAR = load('-mat', filename);
Error in Test_Case_4 (line 7)
EEG = pop_loadset('filename', Dataset_filename );
This error message is a little more complicated. The script calls an EEGLAB function named pop_loadset, and Matlab actually
detected the error while pop_loadset was executing. The error message therefore tells you what line of pop_loadset was running
when the error was detected, along with the line of Test_Case_4.m that called pop_loadset.
13.4.2 https://socialsci.libretexts.org/@go/page/137501

<!-- source_pdf=Full.pdf pdf_page=355 source_page_label="13.4.3" source_url="https://socialsci.libretexts.org/@go/page/137501" -->

## PDF page 355

- Source page label: 13.4.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137501

When you get an error message like this, it probably means that you have sent some kind of invalid data to the pop_loadset
function. It’s possible that there is a bug in an EEGLAB or ERPLAB function that you are calling, but it’s much more likely that
the problem is originating in your script. However, if you can’t figure out the problem by looking at your script, you might want to
open the script for the function that your script is calling. You can do that by selecting the name of the function within your script,
right-clicking on it, and selecting Open “pop_loadset”.
I’m not actually going to reveal the problem with Test_Case_4.m here. That will be revealed in the next section.
This page titled 13.4: A2.4 Deciphering Matlab’s Error Messages is shared under a CC BY 4.0 license and was authored, remixed, and/or curated
by Steven J Luck directly on the LibreTexts platform.
13.4.3 https://socialsci.libretexts.org/@go/page/137501

<!-- source_pdf=Full.pdf pdf_page=356 source_page_label="13.5.1" source_url="https://socialsci.libretexts.org/@go/page/137514" -->

## PDF page 356

- Source page label: 13.5.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137514

13.5: A2.5 Debugging Scripts by Performing Experiments and Collecting Data
Earlier, I said that you should act like a scientist when debugging code, which include performing experiments and collecting data.
In this section, I’ll describe some simple methods for doing this.
Scripting is all about storing information in variables and applying operations to those variables (e.g., addition, subtraction). When
there is a runtime error or logical error, some variable probably has an incorrect value. A key aspect of debugging is therefore
assessing the values of the variables at different points in the execution of the script. This is much like monitoring the
representations of the brain at different time points following the onset of a stimulus while a participant performs a task.
There are a couple ways to monitor variables. The simplest is to print their values to the command window at key points during the
execution of the script. To see how this works, let’s use this approach to understand what is wrong with the Test_Case_4.m script.
Exercise A2.5: Displaying Variable Values
Open the script (if it’s not already open) and take a look at it. The goal of the script is to load a dataset named 1_N170.set that is
located in the current folder (the same folder as the script). To achieve this, we start by getting the path to the current folder with
the pwd (print working directory) function and store the result in a variable named DIR. We then concatenate this value with
‘1_N170.set’ to create the full path to the file, and we store the result in a variable named Dataset_filename. We then send
Dataset_filename to the pop_loadset function. But we’re getting an error message indicating that Matlab can’t find the file that
we’ve specified in this manner.
To figure out the source of the error, let’s examine the values of the DIR and Dataset_filename variables. To accomplish this, add
the following two lines to the script, right after line 5 (i.e., after the lines of code that set the values of these variables):
display(DIR);
display(Dataset_filename);
These commands will display the values of the DIR and Dataset_filename variables to the Command Window. To see this, run the
script. You should see the same error message in the Command Window as before, but prior to that you should see something like
this:
DIR =
'/Users/luck/ERP_Analysis_Book/Appendix_2_Troubleshooting/Exercises'
Dataset_filename =
'/Users/luck/ERP_Analysis_Book/Appendix_2_Troubleshooting/Exercises1_N170.set'
The value of DIR will be different on your computer because your current folder is not the same as mine. However, if you look
closely at it, it should be correct.
If you look at the value of Dataset_filename, you should see the error: there is no slash (or backslash) between Exercises and
1_N170.set. In other words, the script is telling Matlab to look for a file named Exercises1_N170.set instead of a file named
1_N170.set inside the Exercises folder.
To fix this problem, change Line 5 from this:
Dataset_filename = [DIR '1_N170.set'];
to this:
Dataset_filename = [DIR filesep '/' '1_N170.set'];
(but use '\' instead of '/' if you are on a Windows machine). Now run the code. You will see that the Dataset_filename variable now
has a slash (or backslash) between the folder name and the file name, and everything now works correctly.
By the way, I recommend learning how to use the fprintf command to display the values of variables. It’s much more powerful
than the display command. It’s explained briefly in Chapter 10, and you can Google it to find more details. Very worth knowing!
13.5.1 https://socialsci.libretexts.org/@go/page/137514

<!-- source_pdf=Full.pdf pdf_page=357 source_page_label="13.5.2" source_url="https://socialsci.libretexts.org/@go/page/137514" -->

## PDF page 357

- Source page label: 13.5.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137514

Exercise A2.6: The Workspace Pane and the Variables Pane
Once a script has stopped running, you can see the valuable of a variable by simply typing the name of the variable in the Matlab
command window. Try this by typing Dataset_filename. You can also see the value of a variable by looking at the Workspace pane
in the Matlab GUI (which is probably at the right side of the GUI). This pane should look something like Screenshot A2.1.
Screenshot A2.1
This pane shows all the variables that Matlab knows about. For example, I currently have four datasets loaded, and the fourth
dataset is currently active, so CURRENTSET has a value of 4. For more complicated variables, the dimensions of the variable are
shown instead of the value. For example, ALLEEG is a data structure that holds all of the datasets, and it is listed as a 1x4 struct
to indicate that it is a structure that is 1 row high by 4 columns wide (because I have 4 datasets loaded).
You can see that the Workspace pane in Screenshot A2.1 also contains the DIR and Dataset_filename variables that were created
by the last script I ran, Test_Case_4.m. You should also have these variables listed; if you don’t, run Test_Case_4.m again (after
fixing the bug). The strings stored in these variables are too long to be seen well in the Workspace pane, but Matlab has a Variables
pane that you can use to inspect variables more carefully.
To see this, double-click on the Dataset_filename variable in the Workspace pane. You should see the Variables pane open up in
the Matlab GUI (probably above the command window). It should look something like Screenshot A2.2.
Screenshot A2.2
The value of the Dataset_filename variable is now shown (in the little box with “1” to the left and “1” to the right). However, the
box is too small to see much of the variable. If you place your mouse over the right edge of the box with the “1” above the variable
value and drag rightward, the box will expand, and you’ll be able to see the whole variable (as in Screenshot A2.3).
Screenshot A2.3
If you’ve fixed the bug in Test_Case_4.m, you should be able to see the slash (or backslash) between Exercises and 1_N170.set.
This might seem like a lot of work to see the contents of a variable, but once you’re practiced at this approach, it will become very
efficient. Also, it’s a great way to look at more complex variables.
13.5.2 https://socialsci.libretexts.org/@go/page/137514

<!-- source_pdf=Full.pdf pdf_page=358 source_page_label="13.5.3" source_url="https://socialsci.libretexts.org/@go/page/137514" -->

## PDF page 358

- Source page label: 13.5.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137514

For example, double-click on the EEG variable in the Workspace. The Variables pane should now look something like Screenshot
A2.4. You can easily see the various fields of this complex data structure, such as the number of channels (the nbchan field) and
the number of time points (the pnts field). The actual voltage values are stored in the data field, and you can see that this field is 33
rows high (one row for each of the 33 channels) and 170750 columns wide (one column for each of the 170750 time points).
Double-click on the data field, and now you can see the actual voltage values for each combination of channel and time point. Try
double-clicking on other fields as well to get a sense of what information is held in the EEG variable.
Screenshot A2.4
Exercise A2.7: Interrupting a Script to View Variable Values
The Workspace and Variables panes are great ways to see the values of variables, but you can ordinarily use this approach only
after a script is finished. But Matlab also contains a debugger that allows you to pause the operation of a script at various times so
that you can examine the values of the variables at those times.
To see this in action, load the Test_Case_5.m script. This script is much more complicated than the previous test cases, but it is
actually a simplified version of the Step1_pre_ICA_processing.m script from Chapter 10. It loops through the data from the first
five subjects in the N170 experiment, loading each subject’s dataset, filtering it, adding channel location information, renaming it,
and then saving the new dataset to the disk.
There isn’t a bug in this script, but let’s imagine that there was a problem and that you suspected that the problem arose in the loop
that starts on Line 14 and ends on Line 32. If you just start running the script, you won’t be able to inspect the values of the
variables using the Workspace and Variable panes until the script ends. However, you can set a breakpoint that causes the program
to pause at the end of each time the program runs through the loop.
To set a breakpoint at a given line, you simply click the corresponding line number in the editor window for the script (but make
sure that the script has been saved first if you’ve made any changes). For example, Screenshot A2.5 shows what happened when I
clicked on the 32 corresponding to the line number for the end statement at the end of the loop (Line 32). This line number is now
highlighted in a red box.
13.5.3 https://socialsci.libretexts.org/@go/page/137514

<!-- source_pdf=Full.pdf pdf_page=359 source_page_label="13.5.4" source_url="https://socialsci.libretexts.org/@go/page/137514" -->

## PDF page 359

- Source page label: 13.5.4
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137514

Screenshot A2.5
Go ahead and click on the line number for Line 32 in the Test_Case_5.m script. It should now have a red box around it, as in
Screenshot A2.5. Now run the script. You should see that the script runs, printing a bunch of information in the command window.
However, it has only run through the loop once and has paused. You can tell that it has paused because the command window
prompt is now K>> instead of just >>. You can also see a green arrow next to the end statement in the editor window for the script.
And if you look at the Workspace, you can see that the subject variable (which loops from 1 to 5 in this script) is set to 1.
Now let’s look at the current value of the EEG data structure. You may already be showing EEG in the Variables pane, in which
case you are looking at the current value of this variable. If it’s not already showing, you can double-click EEG in the Workspace
pane to look at it in the Variables pane. You can see that the set name has been correctly updated to 1_N170_filt_chanlocs
(although seeing the full name of this field may require double-clicking on the setname field in the Variable pane.
You can resume execution of the script by clicking the Continue button in the toolbar along the top of the editor window for
Test_Case_5.m. When you do that, the script resumes and runs through the loop one more time. If you now look at the value of the
setname field of EEG in the Variables pane, you’ll see that it has been updated to 2_N170_filt_chanlocs. You can click the Stop
button in the editor window’s toolbar to quit from the script.
This feature of Matlab is very useful for debugging. You can read more about it in the Matlab documentation for breakpoints. Other
related tools are described in Matlab’s general debugging documentation.
This page titled 13.5: A2.5 Debugging Scripts by Performing Experiments and Collecting Data is shared under a CC BY 4.0 license and was
authored, remixed, and/or curated by Steven J Luck directly on the LibreTexts platform.
13.5.4 https://socialsci.libretexts.org/@go/page/137514

<!-- source_pdf=Full.pdf pdf_page=360 source_page_label="13.6.1" source_url="https://socialsci.libretexts.org/@go/page/137517" -->

## PDF page 360

- Source page label: 13.6.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137517

13.6: A2.6 Avoiding Bugs in Your Scripts with Good Programming Practices
The first step in debugging a script is to get in a time machine, go back to the moment when you started writing the script, and tell
yourself that you’re now wasting a huge amount of time trying to debug the script. “Please,” you should tell your earlier self,
“follow good programming practices while writing this script so that I won’t need to waste so much time. I’m even busier now than
I was when I first wrote the script.”
If you don’t have a time machine, you should resolve to follow good programming practices from now on. It will take a little more
time now, but you will be giving a great gift to your future self. As Ben Franklin famously said, “An ounce of prevention is worth a
pound of cure.”
This section contains a set of good programming practices that I find to be particularly relevant for scientists who are analyzing
EEG/ERP data in Matlab and are relatively new to coding.
Rapid cycling between coding and testing
Perhaps the most common mistake that novice coders make is trying to write an entire script without doing any testing along the
way. If you write a 30-line script, you will probably have 8 different errors in the script, and it will be really hard to figure out
what’s going wrong.
As I mentioned before, the best approach is to write a small amount of code, test it, debug it if necessary, and then add more code.
When you’re new to programming, this might be only 1-3 lines of code at a time. As you gain experience, you can write more lines
before testing, but even an experienced programmer usually does some testing after every 20-40 new lines of code.
Define all values as variables at the top of the script
If you’ve already read the chapter on scripting, you’ll know that this is my #1 principle of writing good code. For example, in the
N170 experiment that is the focus of the chapter, we analyzed the data from subjects 1-10, but leaving out subject t. When we
looped through the subjects, we needed a line of code like this:
for subject = [ 1 2 3 4 6 7 8 9 10 ] # Note that 5 is missing from this list
Imagine that we need to loop through the subjects in three different parts of the script (e.g., once for pre-ICA EEG processing, once
for post-ICA EEG processing, and once for ERP processing). We could just repeat that same loop in each of these three different
parts of the script. But now imagine that, a year after we’ve analyzed the data, we get reviews back from a journal and a reviewer
wants us to reanalyze the data without excluding subject 5. Now we need to find all the parts of the script with this loop and modify
them. Will we remember that we had three loops? There’s a good chance that we will have forgotten and won’t find all three of
them. As a result, we will have a bug. And we will either end up with the wrong result or waste hours of time trying to find the
problem.
To avoid this problem, you should always, always, ALWAYS use a variable at the top of the script to define a list like this. Here’s
an example:
% This line is in the top section of the script
SUB = [ 1 2 3 5 6 7 8 9 10 ]; % Array of subject IDs, excluding subject 5
% This is how we use the list later in the script
for subject = SUB
The same principle applies to individual numbers (e.g., the number of subjects) and strings (e.g., a filename).
Even if you understand and appreciate this advice, it’s easy to ignore it by saying to yourself, “This script is just a few lines. I don’t
need to worry about putting the values into variables at the top.” Most long scripts start as short scripts, and this is just being
shortsighted. So, at the risk of repeating myself, you should always, always, ALWAYS use a variable at the top of the script to
define values.
Note that zeros and ones can be an exception to this rule when they are being used more conceptually. For example, zero and one
are sometimes used to mean TRUE and FALSE. Or you might do something like this:
13.6.1 https://socialsci.libretexts.org/@go/page/137517

<!-- source_pdf=Full.pdf pdf_page=361 source_page_label="13.6.2" source_url="https://socialsci.libretexts.org/@go/page/137517" -->

## PDF page 361

- Source page label: 13.6.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137517

% This line is in the top section of the script
SUB = [ 1 2 3 5 6 7 8 9 10 ]; % Array of subject IDs, excluding subject 5
num_subjects = length(SUB); % Number of subjects
% This is how we use the list later in the script
for subject_num = 1:num_subjects
subject = SUB(subject_num);
% More code here to process the data from this subject
end
Make your code readable
The reality of science is that you will often start a script, come back to it a few weeks later to finish it, but then modify it 18 months
later (after you get the reviews for a manuscript). And someone else may get a copy of your script and modify it for their own
studies. If the code isn’t easily readable, bugs are likely to be introduced at these times. Here are a few simple things you can make
your code more readable:
Include lots of internal documentation in your scripts. It’s a great gift to your future self.
Define all values as variables at the top, as noted before, but also make sure there is a comment indicating the purpose of each
variable
Divide your code into small, modular sections (or separate functions), with a comment at the beginning of each section or
function that explains what that section or function does
Use intrinsically meaningful variable names (e.g., num_subjects instead of ns) and function names (e.g., ploterps instead of
npbd). I wasted a couple hours one night in my first year of graduate school because someone had used the name npbd for a
function that plotted ERP waveforms, and I’m still bitter…
You can find more discussion of the importance of readability in the scripting chapter.
Make your code modular
If you have a single script that is more than 200 lines long, it should probably be broken into a sequence of multiple scripts. It’s a
lot harder to find problems in a long script than in a short script. And it’s a lot easier to introduce problems into a long script (e.g.,
by adding code to the wrong section). For example, the EEG/ERP processing pipeline in Chapter 10 consists of a series of 7 scripts.
In the ERP CORE experiments, we had about 20 different scripts for each individual experiment.
Make your code portable by using relative paths
Almost all EEG/ERP processing scripts need to access files via a path. The worst way to handle this is something like this (for
loading a dataset):
EEG = pop_loadset('filename',
'/Users/luck/ERP_Analysis_Book/Appendix_2_Troubleshooting/Exercises/1_N170.set');
This violates the principle of defining all values at the top of the script. A better, but still problematic, approach is this:
% Variables defined at the top of the script
Data_DIR = '/Users/luck/ERP_Analysis_Book/Appendix_2_Troubleshooting/Exercises/';
setname = '1_N170.set';
% Loading the data later in the script
EEG = pop_loadset('filename', setname, 'filepath', Data_DIR);
The problem with this approach is that it will break if you switch to a different computer, move your data to a different location, or
share your script with someone else.
A better approach is to determine the path from the location of the script (assuming that the script is kept with the data):
Data_DIR = pwd; %Current folder (where the script should be located)
Chapter 10 describes this in much more detail.
13.6.2 https://socialsci.libretexts.org/@go/page/137517

<!-- source_pdf=Full.pdf pdf_page=362 source_page_label="13.6.3" source_url="https://socialsci.libretexts.org/@go/page/137517" -->

## PDF page 362

- Source page label: 13.6.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137517

Code review
It is becoming very common (and sometimes required) for researchers to post their data analysis code online along with their data
when publishing a paper. That way, other researchers can verify that they get the same results with your data and can use your code
in their own studies. I think this is a wonderful trend.
When you realize that other people will be looking at and running your code, this tends to increase the pressure to make sure that
the code actually works correctly. In theory, you should already be highly motivated to make sure that your code works, because
your findings depend on code that works correctly. But public scrutiny is often an even stronger motivator.
A really good way to make sure that your code works correctly is to use code review. This is just a fancy term for having someone
else go through your code to make sure it’s correct. Of course, code review is a lot easier and more effective if you’ve made your
code readable and portable. The person who reviews your code will also likely have suggestions for making your code even more
readable and will provide a good test of whether your code is portable (i.e., whether it works on the reviewer’s computer).
This page titled 13.6: A2.6 Avoiding Bugs in Your Scripts with Good Programming Practices is shared under a CC BY 4.0 license and was
authored, remixed, and/or curated by Steven J Luck directly on the LibreTexts platform.
13.6.3 https://socialsci.libretexts.org/@go/page/137517

<!-- source_pdf=Full.pdf pdf_page=363 source_page_label="13.7.1" source_url="https://socialsci.libretexts.org/@go/page/137521" -->

## PDF page 363

- Source page label: 13.7.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137521

13.7: A2.7 References
Feyerabend, P. (1993). Against Method (3rd ed.). Verso.
Thomas, D., & Hunt, A. (2019). The Pragmatic Programmer: Your journey to mastery, 20th Anniversary Edition. Addison-Wesley
Professional.
This page titled 13.7: A2.7 References is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck directly
on the LibreTexts platform.
13.7.1 https://socialsci.libretexts.org/@go/page/137521
