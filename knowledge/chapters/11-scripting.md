# 11: EEGLAB and ERPLAB Scripting

> Source: *Applied Event-Related Potential Data Analysis* (Steven J. Luck), `Full.pdf`, PDF pages 301-340. Text is a mechanical page-by-page extraction, not a summary. Consult the PDF for figures and layout.

<!-- source_pdf=Full.pdf pdf_page=301 source_page_label="1" source_url="" -->

## PDF page 301

- Source page label: 1
- LibreTexts source: not printed on page

CHAPTER OVERVIEW
11: EEGLAB and ERPLAB Scripting
 Learning Objectives
In this chapter, you will learn to:
Use the Matlab command line to execute EEGLAB and ERPLAB routines.
Efficiently move back and forth between scripts and the GUI to have the best of both worlds.
Use the EEG and ERP histories to see the commands that correspond to the EEGLAB and ERPLAB procedures that you
run from the GUI.
Create simple scripts by copying commands from the EEG and ERP histories into a text file.
Use variables to define paths in a way that avoids problems and makes it easy to move your scripts and data to new
locations.
Use loops so that you can efficiently repeat a set of processing steps on the data from multiple participants.
Read from and write to spreadsheets and text files to increase the power and flexibility of your scripts.
Create an entire processing pipeline that begins with the raw EEG and ends with amplitude and latency scores that are
ready for statistical analysis.
Implement good programming practices that will minimize errors and increase the readability of your code.
You can do a lot with the EEGLAB and ERPLAB GUIs. However, you will eventually grow tired of all the pointing and clicking,
especially the seventh time you reanalyze the data from an experiment (and believe me, you will be lucky if it’s only seven times).
It’s straightforward to write Matlab scripts that automate almost every processing step. Scripts can also help you avoid the errors
that inevitably arise in the thousands of clicks required to conduct every processing step for every participant. Better yet, scripts can
allow you to implement new or modified processing steps, making your research more innovative. Scripts also play an important
role in open science: When you publish a paper, you can make your data and scripts available (e.g., using the Open Science
Framework), and then the world can see exactly how you processed the data and can exactly reproduce your analysis methods.
These are the reasons why this whole chapter is devoted to scripting.
11.1: Data for This Chapter
11.2: Expected Background Knowledge
11.3: Bugs as an Opportunity for Growth
11.4: Design of the N170 Experiment
11.5: Exercise- The Matlab Command Line and the EEG Variable
11.6: Exercise- The ALLEEG Variable and Redrawing the GUI
11.7: Exercise- EEG.history and eegh
11.8: Exercise- From the Command Line to a Script
11.9: Exercise- Using a Variable for the Path
11.10: Exercise- Loops
11.11: Exercise- Looping Through Data from Multiple Participants
11.12: Rapid Cycling Between Coding and Testing
11.13: Exercise- Referencing with a Script
11.14: Exercise- Improving the Referencing Script
11.15: Exercise- Preprocessing the EEG and Using a Spreadsheet to Store Subject-Specific Information
11.16: Exercise- Building an Entire EEG Processing Pipeline
11.17: Exercise- Averaging with a Custom aSME Time Window
11.18: Exercise- Scoring Amplitudes and Latencies and Performing Statistical Analyses
1

<!-- source_pdf=Full.pdf pdf_page=302 source_page_label="2" source_url="" -->

## PDF page 302

- Source page label: 2
- LibreTexts source: not printed on page

11.19: Key Takeaways and References
This page titled 11: EEGLAB and ERPLAB Scripting is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
2

<!-- source_pdf=Full.pdf pdf_page=303 source_page_label="11.1.1" source_url="https://socialsci.libretexts.org/@go/page/137725" -->

## PDF page 303

- Source page label: 11.1.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137725

11.1: Data for This Chapter
The data we’ll be using for the exercises in this chapter can be found in the Chapter_11 folder in the master folder:
https://doi.org/10.18115/D50056.
This page titled 11.1: Data for This Chapter is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck
directly on the LibreTexts platform.
11.1.1 https://socialsci.libretexts.org/@go/page/137725

<!-- source_pdf=Full.pdf pdf_page=304 source_page_label="11.2.1" source_url="https://socialsci.libretexts.org/@go/page/87989" -->

## PDF page 304

- Source page label: 11.2.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87989

11.2: Expected Background Knowledge
This chapter is designed for individuals all levels of prior experience, including people who have very little programming
experience, people with substantial experience in other languages but little or no Matlab programming experience, and people who
already know how to program in Matlab and just want to learn how to use EEGLAB and ERPLAB routines. I’m not actually a very
experienced Matlab programmer myself, but I have a lot of experience with other languages.
Learning how to write scripts may seem daunting if you’ve never done any serious computer programming before. Fortunately,
EEGLAB and ERPLAB have a history feature that make it fairly easy to write simple scripts for automating your analyses. Every
time you run a routine from the GUI, the equivalent script command is saved in the history. To begin writing a script, you simply
go through all the steps in the GUI, and then copy the commands from the history into a script file. You’ll usually need to make a
few minor modifications to the commands, and then you need to add a little bit of general Matlab code so that your script can
automatically loop through all your participants. But that’s the essence of creating automated EEGLAB/ERPLAB scripts. In fact,
that’s exactly the process I used to create the example scripts for this book.
The scripts you’ll write to automate your EEGLAB/ERPLAB analyses will be pretty simple, but you do need to understand some
basic programming concepts, especially variables, arrays, and loops. I’m not going to explain these concepts, so you will need to
do a little preparation before starting this chapter. When someone without a lot of programming experience joins my lab, I typically
have them take the online Introduction to Programming with MATLAB course offered on Coursera. Then, I have them work
through a great book called Matlab for Behavioral Scientists (Rosenbaum et al., 2014). If you already have a lot of experience with
other programming languages, but you haven’t programmed in Matlab, I recommend getting any of the books that provide a
general introduction to Matlab so you can learn its specific syntax and its unusual but powerful approach to matrix operations.
This page titled 11.2: Expected Background Knowledge is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven
J Luck directly on the LibreTexts platform.
11.2.1 https://socialsci.libretexts.org/@go/page/87989

<!-- source_pdf=Full.pdf pdf_page=305 source_page_label="11.3.1" source_url="https://socialsci.libretexts.org/@go/page/87990" -->

## PDF page 305

- Source page label: 11.3.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87990

11.3: Bugs as an Opportunity for Growth
No matter how much prior experience you have, you need to be prepared for some frustration in this chapter. First, mistakes and
bugs are inevitable in programming. As I’ve said before, you need to think of mistakes and problems as opportunities for learning.
In fact, I encourage you to play with the example scripts in this chapter, changing them to see how they work or to try new things.
You’ll get lots of error messages, but that’s actually part of the reason for playing. And that’s why I wrote the Troubleshooting
Guide in Appendix 2.
I made literally hundreds of mistakes while creating the example scripts in this chapter, and I can’t count how many times I heard
Matlab’s error sound. Most of these mistakes were small and easily fixed. But others were more conceptual and took some time to
understand and remedy. In this chapter, I’ll describe some of my mistakes, how I discovered them, and how I solved them. I want
to both show you that making mistakes is part of the process and give you some insights into troubleshooting approaches. There are
probably still some mistakes in the scripts for this chapter. If you see something that doesn’t quite make sense, it could well be an
error on my part.
As you go through the chapter, keep in mind that there are millions of small details about Matlab and EEGLAB that I don’t
mention. If I provided every possible detail, this chapter would have turned into an entire book, and it probably would have
required several volumes. I wanted to keep the chapter reasonably brief, so I’m counting on you to draw inferences from what you
see and to figure some things out for yourself. This will be a little frustrating at times, but you’ll learn a lot more this way. When
you have questions, do what I did hundreds of times while writing this chapter: Google it. Or ask someone with more experience.
Or post a question via email to the EEGLAB or ERPLAB listservs. And don’t forget about the Troubleshooting Guide in Appendix
2.
Once you’ve completed the exercises in this chapter, you should take a look at the example scripts in the previous chapters. They
include examples of specific processing steps and options that aren’t covered in the present chapter. You can also find lots of
examples of EEGLAB/ERPLAB scripts online, and you may have labmates or colleagues who can provide example scripts.
However, I have an important rule about this: you should never apply someone else’s script to your own data unless you fully
understand every line of code in that script. People often violate this rule, and they end up with garbage (and often don’t realize it).
This page titled 11.3: Bugs as an Opportunity for Growth is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
11.3.1 https://socialsci.libretexts.org/@go/page/87990

<!-- source_pdf=Full.pdf pdf_page=306 source_page_label="11.4.1" source_url="https://socialsci.libretexts.org/@go/page/87991" -->

## PDF page 306

- Source page label: 11.4.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87991

11.4: Design of the N170 Experiment
This section will provide a brief overview of the experimental design and main results from the ERP CORE N170 experiment,
which was based on a prior study by Rossion and Caharel (2011). The N170 is typically found to be larger for faces than for almost
any class of non-face stimuli. In this experiment, cars were used as the non-face stimuli. We also presented phase-scrambled faces
and cars, which contain the same low-level information as the faces and the cars but without the higher-level features that are
essential for discriminating between the broader classes of faces and cars.
Figure 11.1. Experimental paradigm and results from the ERP CORE N170 experiment. (A) Example sequence of stimuli.
Participants were instructed to press one of two buttons to indicate whether a given stimulus was intact (face or car) or scrambled
(scrambled face or scrambled car). (B) Grand average ERP waveforms for car and face stimuli, averaged overall all 37 participants.
(C) Grand average N170 difference wave, which was created by subtracting the car ERP waveform from the face ERP waveform.
(D) Grand average ERP waveforms for faces, scrambled faces, and the difference between faces and scrambled faces. (E) Grand
average ERP waveforms for cars, scrambled cars, and the difference between cars and scrambled cars. All waveforms show data
from PO8 referenced to the average of all channels.
The N170 effect is largely independent of what task the participants are performing, but it can be helpful to have participants
perform some kind of task to keep them alert and attentive. In this experiment, participants were instructed to discriminate whether
a given stimulus was an intact image or a scrambled image. Specifically, they pressed one button for faces and cars and another
button for scrambled faces and scrambled cars. These four stimulus classes were presented in random order. Stimulus duration was
300 ms, and a blank interstimulus interval of 1100-1300 ms occurred between stimuli.
We used 40 different face images, 40 different car images, and scrambled versions of each of these images. Each of the 160 images
was presented once. A different event code was used for each of the 160 images, as indicated in Table 11.1.
11.4.1 https://socialsci.libretexts.org/@go/page/87991

<!-- source_pdf=Full.pdf pdf_page=307 source_page_label="11.4.2" source_url="https://socialsci.libretexts.org/@go/page/87991" -->

## PDF page 307

- Source page label: 11.4.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87991

Table 11.1. Event codes for the ERP CORE N170 experiment.
Event Code
Stimuli Faces 1 –40
Cars 41–80
Scrambled Faces 101–140
Scrambled Cars 141–180
Accuracy Event Code
Responses correct 201
incorrect 202
Of the 40 participants who were tested, three had to be excluded because of artifacts. The grand average waveforms from the
remaining 37 participants are shown for the face and car stimuli in Figure 11.1.B. Note that, for the sake of simplicity, the exercises
in the present chapter include only Subjects 1-10. Subject 5 was one of the excluded subjects, so the final analyses in this chapter
are based on the data from only 9 participants.
As illustrated in Figure 11.1.B, the peak of the N170 was slightly greater (more negative) for faces than for cars. The main
difference between the waveforms appeared to be a faster onset latency for the faces. However, this means that the amplitude was
greater for faces than for cars between approximately 110 and 150 ms. This is illustrated in the faces-minus-cars difference wave
shown in Figure 11.1.C. When I first saw these results, I thought we had done something wrong. However, this pattern is actually
quite common in N170 experiments.
When you compare the ERPs elicited by faces and cars, it’s possible that any differences in the waveforms could be a result of
differences in low-level features (e.g., luminance, spatial frequency) that are not actually important in perceiving whether a
stimulus is a face or a car. This is why the experiment included phase-scrambled face and car images, which contain the same low-
level features as the faces and cars but do not contain the higher-level features that we used to determine whether an image is a face
or a car.
Figure 11.1.D shows the ERPs elicited by the faces and the scrambled faces, along with the faces-minus-scrambled-faces difference
wave. This difference wave is designed to subtract out any brain activity related to the low-level features shared by faces and
scrambled faces. You can see a nice N170 in this difference wave. Figure 11.1.E shows the corresponding waveforms for cars,
scrambled cars, and the cars-minus-scrambled-cars difference. You can again see an N170, but it’s smaller and later than the N170
in the faces-minus-scrambled-faces difference wave.
This page titled 11.4: Design of the N170 Experiment is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
11.4.2 https://socialsci.libretexts.org/@go/page/87991

<!-- source_pdf=Full.pdf pdf_page=308 source_page_label="11.5.1" source_url="https://socialsci.libretexts.org/@go/page/87992" -->

## PDF page 308

- Source page label: 11.5.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87992

11.5: Exercise- The Matlab Command Line and the EEG Variable
A Matlab script is simply a series of Matlab commands that are stored in a text file. Running a script is equivalent to typing the
commands in the Matlab command line. So, we’re going to start by running some commands from the command line.
To start, quit EEGLAB if it’s already running. Then, type clear all on the Matlab command line (i.e., at the prompt in the Matlab
Command Window pane). This clears everything out of Matlab’s memory, which is a good thing to do when you’re first getting
started on a new task. When you clear the variables, anything that was in Matlab’s Workspace pane should disappear. Another nice
housekeeping command is clc, which clears the command window so that you’re not distracted by what happened earlier.
By the way, Matlab doesn’t do anything with a command until you hit the Return key (which may instead be labeled Enter on
your keyboard). When I say that you should type something on the Matlab command line, you should follow it with Return or
Enter. If you didn’t already press Return/Enter after clear all, do it now.
Now launch EEGLAB by typing eeglab on the command line, set the Chapter_11 folder to be the current folder, and load the
dataset named 1_N170.set into EEGLAB. You should now see a set of variables in the Workspace pane, as shown in Screenshot
11.1. This includes EEG, which EEGLAB uses to store the current dataset, and ALLEEG, which EEGLAB uses to store all of the
datasets that are available in memory. ERPLAB also creates corresponding ERP and ALLERP variables to hold the current
ERPset and all available ERPsets.
Screenshot 11.1
You can see the contents of a variable by typing its name on the command line. Let’s try it! Type EEG on the command line
(followed by the Return key, of course). Variable names in Matlab are case-sensitive, so make sure you type EEG and not eeg or
Eeg. Once you type this, the contents of the EEG variable will be shown in the Command Window. Screenshot 11.2 shows the first
few lines.
Screenshot 11.2
EEG is a complicated variable that contains many individual fields (you can learn about the details by typing help eeg_checkset
on the command line). For example, the field named EEG.setname stores the name of the dataset, which is shown in EEGLAB >
Datasets. Let’s change the name of the dataset. To do this, type EEG.setname = 'My First Custom Dataset'. (Note that the period
at the end of the sentence is not part of the command you should type. I use boldface to indicate the exact text you should type.)
Matlab will then print out the whole EEG variable again in the Command Window, and you’ll be able to see that the name has
changed.
Here are a couple important things to note about the command you just entered:
11.5.1 https://socialsci.libretexts.org/@go/page/87992

<!-- source_pdf=Full.pdf pdf_page=309 source_page_label="11.5.2" source_url="https://socialsci.libretexts.org/@go/page/87992" -->

## PDF page 309

- Source page label: 11.5.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87992

Matlab uses single quote marks to indicate literal text. If you didn’t use the quote marks and had instead typed EEG.setname =
My First Custom Dataset, Matlab would have assumed that My First Custom Dataset was a sequence of four variable names
(My, First, Custom, and Dataset). See the text box below for a hint about single quote marks.
Most Matlab commands return one or more variables, and the value of the returned variables is ordinarily printed in the
Command Window. You can suppress this by placing a semicolon at the end of the command. To see this in action, type x = 1
(followed by the Return key), and then type x = 2; (again followed by the Return key).
When you change the set name using the command line, you won’t see the new set name in the Datasets menu. The reason for
this will be explained later in this section.
You can also see the contents of a variable by double-clicking on the name of the variable in Matlab’s Workspace pane. Try double-
clicking the EEG variable in this pane. A new Variables pane should appear in Matlab, showing you the fields of the EEG variable.
One of those fields is named times, and it contains the latency in milliseconds of each time point in the dataset. Double-click it to
see its contents; a new tab will open labeled EEG.times, and you’ll see a very wide list of latency values. The EEG was sampled at
250 Hz, so the first point is 0 ms, the second point is 4 ms, the third point is 8 ms, etc.
 Single Quotes
Click on the tab for the EEG structure and take another look at the times field. Next to the times name, you should see 1 x
170750 double. The term double is used by Matlab (and many other programming languages) to refer to a number that is
stored in scientific notation (e.g., X times 10Y) using double the ordinary precision (and therefore double the amount of storage
space). The 1 x 170750 part indicates that EEG.times is an array of these double-precision numbers with 1 row and 170750
columns. If you go back to the tab for EEG.times, you’ll see that it has one row and 170750 columns (one column for each
data point in the dataset).
In the tab showing the EEG variable, you’ll see a variable named data, which is listed as 33 x 170750 double. This variable
stores the actual voltages in the dataset. It has 33 rows (one for each channel) and 170750 columns (one for each time point).
That’s a pretty natural way to store EEG data, isn’t it?
When you start writing scripts, it’s easy to get confused about the rows versus the columns of an array. I find it helpful to look
at the array in the Variables pane to remind myself which dimension is the rows and which is the columns.
Click on the tab for the EEG structure and take another look at the times field. Next to the times name, you should see 1 x 170750
double. The term double is used by Matlab (and many other programming languages) to refer to a number that is stored in
scientific notation (e.g., X times 10Y) using double the ordinary precision (and therefore double the amount of storage space). The
1 x 170750 part indicates that EEG.times is an array of these double-precision numbers with 1 row and 170750 columns. If you go
back to the tab for EEG.times, you’ll see that it has one row and 170750 columns (one column for each data point in the dataset).
In the tab showing the EEG variable, you’ll see a variable named data, which is listed as 33 x 170750 double. This variable stores
the actual voltages in the dataset. It has 33 rows (one for each channel) and 170750 columns (one for each time point). That’s a
pretty natural way to store EEG data, isn’t it?
When you start writing scripts, it’s easy to get confused about the rows versus the columns of an array. I find it helpful to look at
the array in the Variables pane to remind myself which dimension is the rows and which is the columns.
This page titled 11.5: Exercise- The Matlab Command Line and the EEG Variable is shared under a CC BY 4.0 license and was authored,
remixed, and/or curated by Steven J Luck directly on the LibreTexts platform.
11.5.2 https://socialsci.libretexts.org/@go/page/87992

<!-- source_pdf=Full.pdf pdf_page=310 source_page_label="11.6.1" source_url="https://socialsci.libretexts.org/@go/page/87993" -->

## PDF page 310

- Source page label: 11.6.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87993

11.6: Exercise- The ALLEEG Variable and Redrawing the GUI
EEGLAB can have multiple datasets stored in memory simultaneously, which you can see in the Datasets menu. The current
dataset is stored in the EEG variable. All of the datasets (including a copy of the current dataset) are stored in a variable named
ALLEEG, which is just an array of EEG variables. When you go to the Datasets menu, you’re seeing a list of the datasets stored
in ALLEEG. This is one reason why changing the name of EEG.setname didn’t cause a change in the Datasets menu. That is, we
changed the name of this field in the EEG variable, but not in the ALLEEG variable that is used for the Datasets menu.
Let’s fix that by typing ALLEEG(1) = EEG; on the command line (including the semicolon so that it doesn’t print the new value
in the Command Window). Now type ALLEEG(1).setname, and you’ll see that the first (and only) EEG structure in ALLEEG
has the new name.
However, if you look in the Datasets menu, you still won’t see the new name for the dataset. This is because the Matlab GUI
doesn’t “know” that the ALLEEG variable has changed. That is, the GUI only updates the names listed in the menu when it thinks
that something has changed. You can tell Matlab to update the EEGLAB GUI by typing eeglab redraw on the command line. Try
this, and then look at the Datasets menu. Now you should see the updated name. Note that there’s also an erplab redraw
command for updating the ERPLAB and ERPsets menus.
Now let’s see what happens when we have two datasets loaded in EEGLAB. To make the second dataset, filter the dataset you
already have loaded (EEGLAB > ERPLAB > Filter and Frequency Tools > Filters for EEG data) using a high-pass cutoff at
0.1 Hz, a low-pass cutoff at 30 Hz, and a roll-off of 12 dB/octave. Name the resulting dataset 01_N170_filt. You should now see
two datasets in the Datasets menu.
If you look at the EEG tab in the Variables pane, you will see that EEG.setname is now 01_N170_filt. This is because the EEG
variable always holds the currently active dataset (which is the filtered dataset you just created). If you look in the Variables pane,
you’ll see that ALLEEG now has a size of 1 x 2 because we have two datasets loaded. If you type ALLEEG(1).setname, you’ll
see the name of the first dataset. If you type ALLEEG(2).setname, you’ll see the name of the second dataset.
Leave these two datasets loaded for the next exercise.
This page titled 11.6: Exercise- The ALLEEG Variable and Redrawing the GUI is shared under a CC BY 4.0 license and was authored, remixed,
and/or curated by Steven J Luck directly on the LibreTexts platform.
11.6.1 https://socialsci.libretexts.org/@go/page/87993

<!-- source_pdf=Full.pdf pdf_page=311 source_page_label="11.7.1" source_url="https://socialsci.libretexts.org/@go/page/137733" -->

## PDF page 311

- Source page label: 11.7.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137733

11.7: Exercise- EEG.history and eegh
EEGLAB has a super convenient history feature, which we shamelessly copied when we created ERPLAB. Whenever you run a
routine from the EEGLAB GUI, the equivalent command text is saved in the history. The history field of the EEG variable (i.e.,
EEG.history) stores the history of the routines that were applied to that specific dataset, and you can see this history by simply
typing EEG.history on the command line. You can also get a history of everything that was done since the last time you launched
EEGLAB (which might include routines applied to many different datasets) by typing eegh on the command line.
Go to the Datasets menu and select the first dataset (which should be named My First Custom Dataset). The first dataset should
now be stored in the EEG variable, and if you type EEG.history you should see the history of the routines that were applied to this
dataset:
EEG =
pop_loadset('filename','1_N170.set','filepath','/Users/luck/Dropbox/Research/Manuscript
s/ERP_Analysis_Book/Ch_10_Scripting/Exercises/');
EEG = eeg_checkset( EEG );
EEG = eeg_checkset( EEG );
The first line is the command you used to load the dataset from a file. This is followed by two eeg_checkset commands. This
command just verifies that everything is okay in the dataset. It was run once when you first loaded the dataset, and then it was run
again when you switched from the second dataset back to the first dataset. Notice that the Matlab command that you used to change
the name of the dataset isn’t in the history. Only EEGLAB GUI operations are automatically saved in the history.
I want to pause for a minute and encourage you to appreciate what just happened. You used your mouse to load the dataset using
the EEGLAB GUI, which should have been simple and natural now that you’ve spent a lot of time using EEGLAB. And then the
history allowed you to see the actual Matlab command that was used to load the dataset. This is the same command you’ll use to
load datasets when you start writing scripts. So, you don’t need to read some opaque documentation to figure out what command to
use and how to use it. You just need to run the routine from the GUI and look at the history.
This makes scripting so much easier! And it’s not just for beginners: when I created the scripts for each chapter of this book, I first
ran the routines from the GUI so that I could get the history, which I then copied into the scripts that I was writing. I’m not sure
which of the original EEGLAB developers came up with this scheme, but it’s brilliant!
Now that I’ve gushed about how great this is, I want to note a small complication. If you look closely at the pop_loadset command
that was used to load the dataset, you’ll see that it specifies the filename ('filename', '1_N170.set') and the location of the file on
your hard drive (the path to the file, listed in the string following 'filepath'). However, the path that you can see on your computer
is not the same as the path shown above, which shows the path on my computer
('/Users/luck/Dropbox/Research/Manuscripts/ERP_Analysis_Book/Ch_10_Scripting/Exercises/').
Keep in mind that the paths you’ll see in this book won’t be the same as the paths you’ll see on your computer. And paths can be
confusing even when you’re not using this book. One of the most common problems people have when learning to write scripts is
getting the paths wrong. I often get them wrong myself. Later, I’ll show you some strategies for reducing the likelihood of having
path problems.
Now select the second dataset in the Datasets menu, and type EEG.history to see the history for that dataset:
EEG =
pop_loadset('filename','1_N170.set','filepath','/Users/luck/Dropbox/Research/Manuscript
s/ERP_Analysis_Book/Ch_10_Scripting/Exercises/');
EEG = eeg_checkset( EEG );
EEG = pop_basicfilter( EEG, 1:33 , 'Boundary', 'boundary', 'Cutoff', [ 0.1 30],
'Design', 'butter', 'Filter', 'bandpass', 'Order', 2, 'RemoveDC', 'on' ); % GUI: 10-
Jun-2021 09:49:46
EEG.setname='1_N170_filt';
11.7.1 https://socialsci.libretexts.org/@go/page/137733

<!-- source_pdf=Full.pdf pdf_page=312 source_page_label="11.7.2" source_url="https://socialsci.libretexts.org/@go/page/137733" -->

## PDF page 312

- Source page label: 11.7.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137733

EEG = eeg_checkset( EEG );
EEG = eeg_checkset( EEG );
You’ll see that the first couple lines are the same as the history for the first dataset. That’s because those commands are part of the
sequence of operations that was applied to the second dataset. Following those lines, you can see the command for filtering the
EEG. When you saved the filtered dataset, that generated an additional command for setting the new setname value.
Now type eegh to see the history for the current EEGLAB session. It should look something like this:
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG =
pop_loadset('filename','1_N170.set','filepath','/Users/luck/Dropbox/Research/Manuscript
s/ERP_Analysis_Book/Ch_10_Scripting/Exercises/');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = pop_basicfilter( EEG, 1:33 , 'Boundary', 'boundary', 'Cutoff', [ 0.1 30],
'Design', 'butter', 'Filter', 'bandpass', 'Order', 2, 'RemoveDC', 'on' ); % GUI: 10-
Jun-2021 10:08:08
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG,
1,'setname','1_N170_filt','gui','off');
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'retrieve',1,'study',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'retrieve',2,'study',0);
The first line is the command for launching EEGLAB, which returns the ALLEEG and EEG variables (which are empty initially).
It also returns a variable named CURRENTSET, which just indicates which dataset is currently active, and a variable named
ALLCOM, which stores the history.
The second line is the command for loading the first dataset from your hard drive into the EEG variable. This is followed by an
eeg_store command that adds it to the ALLEEG variable. It would be possible to replace this with ALLEEG(1) = EEG, but the
eeg_store command takes care of a few additional details (like updating the value of CURRENTSET).
The next line is for the filtering routine, which operates on the EEG variable. This is followed by a pop_newset command that
creates an entry for this new dataset in the ALLEEG variable (and sets the setname). We then have two more pop_newset
commands that correspond to you setting the first dataset to be active in the Datasets menu and then setting the second dataset to
be active in the Datasets menu.
You now know how to see the Matlab commands for all the routines you know how to run from the EEGLAB GUI. This will make
your life much easier in the following exercises, where you’ll start putting together scripts. I like to use eegh when I’m writing
scripts that will interact with the EEGLAB GUI, where it’s important to keep track of ALLEEG and CURRENTSET. But I
typically use EEG.history for scripts that run independently of the GUI, in which case I typically have only one dataset in memory
at a given time and don’t need to worry about ALLEEG.
This page titled 11.7: Exercise- EEG.history and eegh is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
11.7.2 https://socialsci.libretexts.org/@go/page/137733

<!-- source_pdf=Full.pdf pdf_page=313 source_page_label="11.8.1" source_url="https://socialsci.libretexts.org/@go/page/137735" -->

## PDF page 313

- Source page label: 11.8.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137735

11.8: Exercise- From the Command Line to a Script
In this exercise, we’ll see how commands that you type on the command line can be run from a script file. To start from a blank
slate, you should quit EEGLAB, type clear all on the command line, and relaunch EEGLAB. Make sure that Chapter_11 is the
current folder in Matlab, and open the file named Script1.m by double-clicking the name from Matlab’s Current Folder pane.
This script consists of three lines, which open a dataset, add it to ALLEEG, and redraw the Matlab GUI.
Copy the first line of the file into your computer’s clipboard, and then paste it onto the command line to execute the command. You
can determine whether it has successfully loaded the dataset into the EEG variable by looking at this variable in the Matlab
Workspace pane. Now paste the second line of the file onto the command line to add the dataset to ALLEEG (which you can
verify by looking at ALLEEG in the Workspace pane). Now paste the third line to the command line to update the GUI. You can
see that the dataset is now in the Datasets menu.
Let’s take a closer look at the first line: EEG = pop_loadset('filename','1_N170.set'); This is just like the first line of the
EEG.history in the previous exercise, except that it doesn’t specify the path. That’s because the 1_N170.set file is in the current
folder (which you can see in Matlab’s Current Folder pane). When you open a file but don’t specify a path, Matlab will first look in
the current folder. If it doesn’t find the file there, it will search the entire Matlab path. When you save a file but don’t specify a path,
Matlab will save it in the current folder. In the next exercise, we’ll look at a robust way to specify the path.
First, though, we’ll see how to run an actual script. In theory, you could just put a set of commands in any text file and then copy-
and-paste them onto the command line. The file would just be a way to store the commands so that you can easily reuse them. In
fact, I sometimes use script files for this purpose. But there are easier ways to execute the commands in a script file. The simplest is
just to click the Run button in the Matlab script editor. In my version of Matlab, it’s a green triangle (see Screenshot 11.3). To see
this in action, quit EEGLAB, type clear all, restart EEGLAB, and click the Run button in the editor window for Script1.m. If you
look at the EEG variable, the ALLEEG variable, and the Datasets menu, you can confirm that each line of the script has executed.
It’s just as if you had copied all three lines into the clipboard and pasted them onto the command line (but faster and easier).
Screenshot 11.3
Now let’s look at three ways that we can execute a portion of a script rather than the whole thing. The first is simple: Copy the set
of lines that you’d like to execute into the clipboard and paste them onto the command line. You’ve already done this with single
lines of code, but you can do this with multiple lines.
The other two ways are easier to demonstrate with a script that has several distinct parts, so load the script named Script2.m (e.g.,
by double-clicking on this name in the Current Folder pane). This script loads the data from Subjects 1 and 2. I’ll explain how this
script works in the next exercise. For now, we’ll just see how to execute parts of it.
Start by quitting EEGLAB, typing clear all, and restarting EEGLAB. Now, go into the text editor for Script2.m, and select the first
7 lines (by dragging your mouse over those lines; note that you can see the line numbers along the left side of the window). Now
right-click (or control-click) on the selected text, and select Evaluate Selection from the menu that pops up. (You can also see a
keyboard equivalent, which will be more convenient for using this approach in the future.) You’ll be able to see that the dataset
from Subject 1 has been loaded (e.g., in the ALLEEG variable), but we haven’t yet updated the EEGLAB GUI. To do that, select
the last line of the script (line 12, eeglab redraw) and execute it (by selecting it, right-clicking, and selecting Evaluate Selection
from the popup menu). Now the dataset should appear in the Datasets menu.
Now select and execute lines 9-12 to load the dataset for Subject 2 and update the GUI. You should now see the datasets from both
Subject 1 and Subject 2 in the Datasets menu. Note that you didn’t execute the lines of the script in order. You executed line 12
11.8.1 https://socialsci.libretexts.org/@go/page/137735

<!-- source_pdf=Full.pdf pdf_page=314 source_page_label="11.8.2" source_url="https://socialsci.libretexts.org/@go/page/137735" -->

## PDF page 314

- Source page label: 11.8.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137735

after lines 1-7 and then again after lines 9-11. This approach gives you a lot of flexibility. The lines in a script usually need to go in
a particular order to give you the desired result. For example, you can’t filter a file until after you’ve loaded it. But sometimes
you’re just using the script as a convenient place to store a bunch of commands that you might execute in some other order.
Now we’re going to look at one more way to execute commands from a script, in which we divide the script into sections and run
one section at a time. If you look at Script2.m, you’ll see that some lines begin with a % symbol. This symbol indicates that the
line is just a comment, not code that will be executed. You can also put a % symbol after a command to provide a comment about
that command.
You should also note that some of the lines begin with two consecutive % symbols. This indicates the start of a new section. If you
click anywhere within a section, the background color of that section changes. Screenshot 11.4 shows what it looks like when I
click in the last section of the script. Once you’ve highlighted a section in this way, you can run that section of code by clicking the
Run Section button in the tool bar near the top of the script editor window.
Screenshot 11.4
This page titled 11.8: Exercise- From the Command Line to a Script is shared under a CC BY 4.0 license and was authored, remixed, and/or
curated by Steven J Luck directly on the LibreTexts platform.
11.8.2 https://socialsci.libretexts.org/@go/page/137735

<!-- source_pdf=Full.pdf pdf_page=315 source_page_label="11.9.1" source_url="https://socialsci.libretexts.org/@go/page/137738" -->

## PDF page 315

- Source page label: 11.9.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137738

11.9: Exercise- Using a Variable for the Path
In this exercise, we’re going to take a closer look at Script2.m, which demonstrates how to use variables to specify the paths to
your files, which is much more robust. Make sure that Chapter_11 is still the current folder, and type pwd (which stands for print
working directory) on the command line. You should see the path for your current folder. Line 3 of Script2.m uses the pwd
command to get the path to the current folder and store it in a variable named DIR (short for directory, but we could have named it
almost anything). Run line 3 of the script (using any of the methods described in the previous exercise) and then look at the value
of DIR (by typing DIR on the command line or by double-clicking it in the Workspace pane). You’ll see that DIR is a string that
holds that path to the current folder.
Now we can use DIR as the starting point for providing paths to our Matlab commands. This is much more robust than specifying
something like C:/ERP_Analysis_Book/Ch_10_Scripting as the path. For example, if you move your data and scripts to a new
location on your computer or a new computer, using DIR as the path will still work (because the pwd command will return the new
location of the script), but specifying the path directly will now fail.
We didn’t really need to specify the paths in Script2.m, because the files were located in the current folder. Close Script2.m and
open Script2b.m, which shows a more realistic example. This new script assumes a more complicated but better organization for
your data files, in which each participant has a separate folder inside of a general data folder.
This is the organization that I generally recommend for EEG and ERP data (whether or not you use EEGLAB and ERPLAB). You
will end up with a lot of files for each participant, and this just keeps them well organized. There’s some redundancy, because I also
recommend including the Subject ID number in each filename. But this redundancy is useful because it minimizes the likelihood of
errors. Nothing about EEGLAB or ERPLAB requires this organization, but it’s used for all the scripts in this book. You can choose
a different organization, but please don’t just put all the files for all the participants into a single folder. It will seem simpler at first,
but it will make your life much more difficult in the long run. You just don’t want to have 3478 files in the same folder!
This organization means that you need a different path for each participant. In Script2b.m, we implement this by using DIR as a
base folder (the folder that contains the script) and then use this to create a variable named Subject_DIR that holds the path for the
participant we’re currently processing.
Important note: This approach assumes that Matlab’s current folder is set to be the folder that contains the script. You should make
sure this is true when you run the scripts in this book.
Line 6 of Script2b.m sets the value of Subject_DIR like this:
Subject_DIR = [DIR '/N170_Data/1/']; % Folder holding data for this subject
Putting multiple character strings inside of square brackets causes Matlab to concatenate the strings together. For example, ['ERPs'
'Are' 'Great'] is equivalent to 'ERPsAreGreat', and ['ERPs ' 'are ' 'great'] is equivalent to 'ERPs are great'. If DIR has a value
of 'C:/ERP_Analysis_Book/Ch_10_Scripting', then [DIR '/N170_Data/1/'] has a value of
'C:/ERP_Analysis_Book/Ch_10_Scripting/N170_Data/1/'.
To see this in action, run lines 3 and 6 of Script2b.m and then look at the value of Subject_DIR. This is what it looks like on my
computer:
/Users/luck/Dropbox/Research/Manuscripts/ERP_Analysis_Book/Ch_10_Scripting/Exercises/N1
70_Data/1/
This may seem like a lot of work, but I guarantee that it will make your life easier in the long run. For example, if you develop a
script for one experiment and want to use it for a second experiment, you can place a copy of the script in the folder for the second
experiment, and the script will automatically look for the data files in the correct place.
If you’re using a Windows machine, Script2b.m may not work properly because it uses slashes between folder names rather than
backslashes. You can just replace the slashes in the paths with backslashes.
This page titled 11.9: Exercise- Using a Variable for the Path is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
11.9.1 https://socialsci.libretexts.org/@go/page/137738

<!-- source_pdf=Full.pdf pdf_page=316 source_page_label="11.10.1" source_url="https://socialsci.libretexts.org/@go/page/137740" -->

## PDF page 316

- Source page label: 11.10.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137740

11.10: Exercise- Loops
In this exercise, we’ll introduce the concept of loops, which will make your life much easier by allowing you to automate the
processing of multiple participants. There are several kinds of loops, but the most common is called a for loop. It allows you to
repeat the same sequence of steps multiple times, but with one variable changing (e.g., a variable that indicates which participant
should be processed). We’re going to go through several examples in this exercise, starting simple and working our way up to a
script that processes the data from multiple participants.
As usual, let’s start by quitting EEGLAB, typing clear all, and restarting EEGLAB. Then open Script3.m by double-clicking on it
in the Current Folder pane. Run the script (e.g., by clicking the Run button) and see what it does. You should see that it prints a list
of numbers between 1 and 10. In a later script, these will be the ID numbers of our participants. Note that the number 5 is missing.
This is meant to indicate that Subject 5 is being excluded (because that subject had too many artifacts and was excluded from the
final analyses).
Now take a look at the script. The main body of the script is this:
for subject = [ 1 2 3 4 6 7 8 9 10 ]
display(subject);
end
In Matlab, a for loop begins with for and ends with end. The lines of code between the for and end lines are the body of the loop.
This body will be executed multiple times, once for each element specified in the array on the for line. The for line defines a
variable (which we’ve named subject in this example) and specifies an array of values that will be stored in this variable as we go
through the loop ([ 1 2 3 4 6 7 8 9 10 ] in this example).
In Script3.m, the body of the loop is a single line consisting of the display(subject) command, which just prints the value of the
variable named subject that we specified on the for line. Note that it’s conventional to indent the body of a loop using tabs. The
tabs are ignored by Matlab, but they make it easier to see the structure of a script. Not required, but highly recommended!
Each time we go through the loop, the variable named subject is set to a new value in the array of values following the equals sign.
When the loop starts, subject will be set to 1 (because 1 is the first value in the array). The display(subject) line will then execute,
and it will display a value of 1 because that’s the value of the subject variable. Then the end line occurs, telling Matlab to go back
to the start of the loop and set subject to the next value in the array (2). The display(subject) line will then execute, but this time it
will display a value of 2 because that’s now the value of the subject variable.
Matlab will keep repeating the loop, setting subject to 3, then to 4, then to 6, etc. There is no 5 in our array of values, so subject
will never take on that value. The array is just a list of values, and any sequence of values will work. For example, we could use [ 3
1 5 9 ] and then subject would take on that set of values in that order (3, then 1, then 5, then 9). We could even use non-integer
numbers (e.g., [ 5.23 6.1 -5.442 10021.2 ]) or character strings (e.g., [ ‘S1’ ‘S2’ ‘S3’ ‘S5’ ]). Matlab is much more flexible than
most programming languages in this regard. Spend some time playing with the array in the script so that you get a good sense of
how it works.
Now close Script3.m and open Script3b.m, which is a slightly more sophisticated version of the same set of ideas. Run the script
to see what it does. You should see a set of lines starting with this:
Processing Subject 1
Processing Subject 2
Processing Subject 3
Now look at the script. You’ll notice two main changes from the first script. First, instead of providing an explicit list of subject IDs
in the for line, we’ve defined a variable named SUB that stores this array:
SUB = [ 1 2 3 4 6 7 8 9 10 ]; %Array of subject IDs
We then specify this variable as our array in the for statement:
11.10.1 https://socialsci.libretexts.org/@go/page/137740

<!-- source_pdf=Full.pdf pdf_page=317 source_page_label="11.10.2" source_url="https://socialsci.libretexts.org/@go/page/137740" -->

## PDF page 317

- Source page label: 11.10.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137740

for subject = SUB
This approach embodies my #1 principle of writing good code: All values used by a script should be defined as variables at the top
of the script. I’ll say more about this principle later in the chapter.
The second change to the script is that it uses the fprintf command instead of the display command to print the value of the
subject variable. The fprintf command is much more powerful and flexible. It takes a little time to learn to use it, but it’s well
worth the time. Here’s the specific version used in our script:
fprintf('Processing Subject %d\n', subject);
The first parameter in the fprintf command is a formatting string. It contains plain text that is printed by the routine, and it also
includes formatting statements for variables that appear as subsequent parameters. The %d tells the command to print a whole
number (the value of the subject variable), and the \n tells it to print a newline (a return). You can do much more than this with
fprintf, but we’re keeping it simple for now (see the fprintf documentation for details).
Once you understand how this script works, close it and open Script3c.m. If you run it, you’ll see that the output has more
information than provided by the previous script. For each iteration of the loop, it indicates how many times we’ve gone through
the loop, plus the subject’s ID. This allows us to see that the fifth subject has an ID of 6, not 5.
Look at the script to see how it works. Near the top, you’ll see that we use a Matlab function called length to define a variable
named num_subjects that stores the number of subjects in the SUB array:
num_subjects = length(SUB);
We’ve then used this new variable to define the array of values for the loop, which we’ve defined as 1:num_subjects. Type
1:num_subjects on the command line. You’ll see that it is equivalent to a list of integers between 1 and num_subjects (rather than
1 through 10, skipping 5). As a result, we’re no longer looping through the subject IDs. As a result, I’ve changed the name of the
variable in the for statement to subject_index.
Each time through the loop, we get the subject ID by finding the element in SUB that corresponds to subject_index and store it as
a text string in a variable named ID. For example, when subject_index is 5, we get the 5th element of SUB, which is 6 (because
SUB skips subject 5). SUB is an array of numbers, but as you’ll see in the next script, it’s useful to store the ID as a text string. We
therefore use a Matlab function called num2str to convert the number to a string before storing it in ID. Note that the format string
for the fprintf command uses %s to indicate that this command should print a string variable for ID.
 Why it Pays to Include Good Comments and Meaningful Variable Names in Your Scripts
When you’re in the middle of writing a script to process the data for an experiment, you will get very focused on getting the
job done. That is, you just want to script to work so that you can get to the next step of the project (and ultimately to the point
of submitting a paper for publication). However, the fastest route to a goal is not always the straightest: If you focus too much
on the immediate goal of getting the script to work, you may actually slow your progress toward the final goal of getting the
paper submitted. It really pays to take your time when writing a script and write the code in a way that will be optimal in the
long run.
In practice, this means following good coding practices that reduce the likelihood of errors, like defining all important values
as variables at the top of the script. Errors can really slow you down if you don’t realize the error until you’re near the point of
submitting the paper and now need to repeat all the analyses, change all the figures, and update the text of your paper. It’s also
important to realize that you will probably need to come back to your script many months after you’ve written it (e.g., when
you’re writing your Method section or you realize you need to reanalyze your data), and you will save yourself a lot of time if
you write your code in a way that’s easy to read later.
There are two straightforward ways of making your code more readable. The first is to use variable names that have an obvious
meaning. For example, I could have used something like ns as the name of the variable that holds the number of subjects, but
instead I used num_subjects. The second is to add lots of comments. For examples, take a look at the example scripts I created
for this chapter. Of course, these scripts were designed to be read by other people, so I put more work into that comments than
I might have for a regular script that I wasn’t planning to share. But I still include tons of comments in scripts that I don’t plan
11.10.2 https://socialsci.libretexts.org/@go/page/137740

<!-- source_pdf=Full.pdf pdf_page=318 source_page_label="11.10.3" source_url="https://socialsci.libretexts.org/@go/page/137740" -->

## PDF page 318

- Source page label: 11.10.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137740

to share. It’s a gift to my future self, because I know I will probably need to come back to those scripts after months or even
years, and the comments will make my life much easier then. And when I come back to a script with good comments, I always
try to thank my past self for the gift.
You should also keep in mind that it’s becoming more and more common to make your data and scripts available online when
you publish a paper. This means that you’re never really writing scripts just for yourself. Other researchers are going to be
looking at your scripts, so you don’t want the scripts to be embarrassing, and you want the other researchers to be able to
understand your code. If you make the code easy to understand, this increases the likelihood that the other researchers will
follow up on your research, which means that your research will have a larger impact. And aren’t you doing research so that it
has an impact?
I’ve found that people often spend a huge amount of time polishing their scripts (making them more logical and adding lots of
comments) right before they’re going to submit the paper for publication. They often find mistakes, and then they end up
having to change their figures and the statistics in their Results sections. It’s really inefficient. It makes much more sense to
write your scripts with the intent of sharing them—including clear logic and lots of comments—right from the beginning. This
takes a lot of discipline, because when you’re writing the script you just want to get the job done. But this approach will save
you a lot of time and agony in the long run.
This page titled 11.10: Exercise- Loops is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck directly
on the LibreTexts platform.
11.10.3 https://socialsci.libretexts.org/@go/page/137740

<!-- source_pdf=Full.pdf pdf_page=319 source_page_label="11.11.1" source_url="https://socialsci.libretexts.org/@go/page/137741" -->

## PDF page 319

- Source page label: 11.11.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137741

11.11: Exercise- Looping Through Data from Multiple Participants
In this exercise, we’ll get to see how loops are used to load the datasets from a set of participants. We’ll add some processing steps
that make the script more useful in the next exercise, but I wanted to keep things simple for now. To get started, quit EEGLAB,
close any open scripts, type clear all, and open Script4.m. But don’t launch EEGLAB—we’ll have the script do that!
Go ahead and run Script4.m to see what it does. It should launch EEGLAB, load the datasets for Subjects 1-10 (except Subject 5),
and refresh EEGLAB to make the datasets available in the Datasets menu.
Now let’s look at the script and see how it works. The first line of code launches EEGLAB, which creates several variables that we
will find useful (e.g., EEG and ALLEEG). The next line of code creates the DIR variable, as in the previous scripts, which holds
the location of the script (and should be the Chapter_11 folder). Then the script creates a new variable named Data_DIR, which
appends '/N170_Data/' onto the DIR variable. This gives us a path to the folder containing the single-participant data folders.
The next step is to define a variable named Dataset_filename, which has a value of '_N170.set'. We’ll eventually combine this
variable with the subject ID to get the entire filename for a given participant (e.g., 1_N170.set).
Then we define variables for the list of subjects and the number of subjects, just as in the previous example. Note that these steps
embody the principle that all values used by a script should be defined as variables at the top of the script. It’s a little extra up-front
work to do this, but it dramatically reduces the likelihood of bugs later (especially when you take a previous script and modify for a
new purpose).
The next step is to loop through the subjects. The first part of this is just like what we did in the previous script, including setting
ID to be a string with the current subject’s ID. Then the script creates a variable named Subject_DIR, which specifies the folder
that holds that data for the subject currently being processed by the loop (e.g., …/Chapter_11/N170/1/ for the first subject). We do
this by concatenating the Data_DIR variable with the ID variable and then a / character. We also create a variable named
Subject_filename by concatenating the ID variable with the Dataset_filename variable. This gives us a value of 1_N170.set for
the first subject.
We then load the dataset, using Subject_filename as the filename and Subject_DIR as the path. The dataset is stored in the EEG
variable, and our last step in the body of the loop is to add this dataset to the ALLEEG variable using the eeg_store routine. The
zero we specify as the last parameter for this routine tells it to add the new dataset to the end of ALLEEG.
After the loop finishes, eeglab redraw is called to update the EEGLAB GUI.
There are actually 40 participants in this experiment, each with a dataset. This script is a much faster way of loading these 40
datasets than using the GUI to separately load each one. Because all the key values are specified as variables at the top of the script,
you can easily find them and modify them so that you can use the same script with another experiment, assuming that the data are
organized in the same way on your computer. You’d just need to modify the list of subject IDs (the SUB variable), the name of the
folder holding the data (Data_DIR), and the base dataset name (Dataset_filename). This will be much faster and easier if you’re
consistent in how you organize the data for each experiment (see the text box below).
 Consistency
There is a famous line from the poet Ralph Waldo Emerson that is frequently misquoted as “Consistency is the hobgoblin of
little minds.” People sometimes use this incorrect version of the quote to belittle people for being consistent. However, the
actual quote is “A foolish consistency is the hobgoblin of little minds” (Emerson, 1841 p. 14; my emphasis). It’s not the least
bit foolish to be consistent about your data organization, your filenames, your variable names, etc. You will save yourself huge
amounts of time and grief by developing a good organizational strategy early in your career and then sticking to it (but with
thoughtful changes when necessary).
This page titled 11.11: Exercise- Looping Through Data from Multiple Participants is shared under a CC BY 4.0 license and was authored,
remixed, and/or curated by Steven J Luck directly on the LibreTexts platform.
11.11.1 https://socialsci.libretexts.org/@go/page/137741

<!-- source_pdf=Full.pdf pdf_page=320 source_page_label="11.12.1" source_url="https://socialsci.libretexts.org/@go/page/137742" -->

## PDF page 320

- Source page label: 11.12.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137742

11.12: Rapid Cycling Between Coding and Testing
If you think about the exercises we’ve done so far, you’ll realize that we started with an extremely simple script (Script1.m) that
simply loaded a file, improved it (Script2.m and Script2b.m), and then added a bit more functionality (Script3.m and Script4.m).
This is a good way to learn, but it’s also the way you should write your scripts. Don’t try to write 30 lines of code (or an entire
script) without doing any testing along the way. If you write a 30-line script, you will probably have 8 different errors in the script,
and it will be really hard to figure out what’s going wrong.
Instead, the best approach is to write a small amount of code, test it, debug it if necessary, and then add more code. At this point,
you should be adding only 1-3 lines of code at a time. As you gain experience, you can write more lines before testing, but even an
experienced programmer usually does some testing after every 20-40 new lines of code.
I almost put this piece of advice in a text box, but I decided that it's so important it deserves it's own section!
This page titled 11.12: Rapid Cycling Between Coding and Testing is shared under a CC BY 4.0 license and was authored, remixed, and/or
curated by Steven J Luck directly on the LibreTexts platform.
11.12.1 https://socialsci.libretexts.org/@go/page/137742

<!-- source_pdf=Full.pdf pdf_page=321 source_page_label="11.13.1" source_url="https://socialsci.libretexts.org/@go/page/137743" -->

## PDF page 321

- Source page label: 11.13.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137743

11.13: Exercise- Referencing with a Script
In this exercise, we’ll add referencing to the script from the previous exercise so that the new script is more useful. You’ll also learn
some important strategies along the way.
As you may recall, the ERP CORE data were recorded without a reference (which is possible in only a few recording systems), so
we need to use EEG Channel Operations to reference the data. We’ll also add bipolar VEOG and HEOG channels. The N170 is
traditionally referenced to the average of all sites (see Chapter 5), and that’s what we’ll do in this example.
You should already have 9 datasets loaded from the previous exercise. If you don’t, run Script4.m again. With the 10_N170 dataset
active, select EEGLAB > ERPLAB > EEG Channel operations. Clear out any equations that are already set, set the Mode to
Create new dataset, and make sure the box labeled Try to preserve channel locations is checked. Click the Reference Assistant
button, and enter the parameters shown in Screenshot 11.5.
Screenshot 11.5
The key parameter is avgchan(1:33), which tells it to use the average of all 33 channels as the reference. Then click OK, which
should fill the equations window with an equation for referencing each of the 33 channels to the average of Channels 1–33. Then
add these two equations to create bipolar HEOG and VEOG channels:
nch34 = ch31 - ch32 Label HEOG-bipolar
nch35 = ch33 - ch16 Label VEOG-bipolar
Then click Run to execute the routine. Now type eegh to see the script command for EEG Channel Operations, which begins with
EEG = pop_eegchanoperator. This command is extremely long, because it contains all 35 equations in it. There’s a better way to
do this: Instead of having this huge command, we can put all the equations in a file and pass the filename instead of the list of
equations.
 Seeing a List of the Channels in a Dataset or ERPset
When you’re using the EEGLAB/ERPLAB GUI, it’s usually pretty easy to see what channels are in a dataset or ERPset.
However, this information isn’t so obvious when you’re writing scripts. Here’s a little trick that I use quite often: If you
double-click on the name of a variable in the Workspace pain of the main Matlab window, a Variables pane will appear and
show the contents of that variable. For example, you can double-click on the EEG variable to see its contents. EEG is a
complex structure with many fields, and you can double-click on the name of a field to see the contents of that field. The
11.13.1 https://socialsci.libretexts.org/@go/page/137743

<!-- source_pdf=Full.pdf pdf_page=322 source_page_label="11.13.2" source_url="https://socialsci.libretexts.org/@go/page/137743" -->

## PDF page 322

- Source page label: 11.13.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137743

screenshot below shows what I see when I first double-click on the EEG variable and then double-click on the chanlocs
(channel locations) field. This also works for ERPsets if you double-click on the ERP variable.
To see how this works, select the original version of 10_N170 from the Datasets menu and launch EEG Channel operations
again. You should still have the 35 equations from before. Near the bottom of the window, click the Save list as button to save the
list of equations as a file. Name the file equations.txt. In addition to saving the file, this command puts the filename (including the
entire path) in the File: text box. Now, select the check box labeled Send file rather than individual equations, and click Run to
execute the routine. Now when you type eegh on the command line, you should see a much shorter line of code that looks
something like this:
EEG = pop_eegchanoperator( EEG, '/Users/luck/Ch_10_Scripting/Exercises/equations.txt' ,
'ErrorMsg', 'popup', 'KeepChLoc', 'on', 'Warning', 'on' );
Let’s take a closer look at this command. We send the EEG variable as the first parameter. The routine then sends back a new
version of this variable as its output. The second parameter is the filename for the equations file (including the whole path, which
will be different on your computer). Then we have a sequence of pairs of parameters, which occur in the order parameter name,
parameter value. For example, the sequence of parameters 'ErrorMsg', 'popup' tells the routine to set the error message option to
a value of popup, which means that error messages will be delivered in popup windows. The next pair of parameters is
'KeepChLoc', 'on', which tells the routine that the option for keeping the channel locations should be on (which you had set from
the GUI by checking the box the option labeled Try to preserve channel locations). The use of pairs of parameters—one for the
name of the parameter and one for the value—makes it easier to understand what the parameters are doing. This approach is
common in Matlab scripts and functions, and it’s used extensively in EEGLAB and ERPLAB routines.
How do you know what options are available for a command like pop_eegchanoperator? You can use Matlab’s help feature.
There are several ways to access this feature. One common way is to type help pop_eegchanoperator on the command line.
Another way is to select the name of the routine in the Command Window (or in a script) and then right-click or control-click on it
to get a contextual menu, which contains a Help on Selection item. Try one of these methods to see the help for
pop_eegchanoperator. When you do this, Matlab simply shows you all of the comments (lines of text beginning with the %
character) at the top of the .m file containing the command (e.g., the pop_eegchanoperator.m file, which contains the code for this
routine and is located in a subfolder deep inside the EEGLAB folder that was created when you installed EEGLAB and ERPLAB).
This works with any command, including built-in Matlab commands like pwd and EEGLAB and ERPLAB commands like
pop_eegchanoperator.
Now it’s time for an embarrassing admission: When I looked up the help for pop_eegchanoperator, I found that it didn’t actually
list the optional parameters. In fact, it wasn’t very helpful at all. This is one of the first routines that we wrote for ERPLAB, and
I’m guessing that we hadn’t yet established a good workflow that included careful documentation of all the features of each
11.13.2 https://socialsci.libretexts.org/@go/page/137743

<!-- source_pdf=Full.pdf pdf_page=323 source_page_label="11.13.3" source_url="https://socialsci.libretexts.org/@go/page/137743" -->

## PDF page 323

- Source page label: 11.13.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137743

routine. This has now been fixed. And here’s another embarrassing admission: I’ve seen lots of shortcomings in the ERPLAB help
information as I’ve worked on this book. I don’t have a good excuse for this. I can tell you that most programmers hate writing
documentation—once the code is done, it’s not much fun to write the documentation. But that’s not a good excuse. I’m going to
add “go through all the ERPLAB help” to my list of things to do after I finish this book.
But let’s turn lemons into lemonade and use this as an opportunity to learn how to overcome unclear or missing documentation.
 Lemonade
There’s an old saying that “When life gives you lemons, make lemonade.” I prefer the snarkier version, “When life gives you
lemons, squeeze them into the open wounds of your enemies.”
When I ran into this problem with pop_eegchanoperator, I simply opened the pop_eegchanoperator.m file and looked at the
code. I didn’t have to go searching through my file system for this file. I just found pop_eegchanoperator in the Command
Window, selected it, control-clicked on it to get a contextual menu, and selected Open Selection. Give that a try to open the
pop_eegchanoperator.m file.
If you’re not an expert in Matlab scripting, you may wonder how you’re going to understand the code in the
pop_eegchanoperator.m file? You’re interested in finding out about the options, and you know that one of the options is
ErrorMsg, so it would make sense to do a search for that string in the file. If you do this, you’ll eventually find this line:
p.addParamValue('ErrorMsg', 'cw', @ischar); % cw = command window
From this line you can infer that a possible value for this parameter is 'cw', and that this will send the error messages to the
Command Window. If you search some more, you’ll find this set of lines:
if strcmpi(p.Results.ErrorMsg,'popup')
errormsgtype = 1; % open popup window
From these two lines, you can see that the 'popup' value opens a popup window. So, now you’ve learned a strategy for figuring out
how a routine works and what the options are (and I’ve learned that I need to put more effort into making sure that the ERPLAB
help information is complete).
Now that you’ve learned about the command for EEG Channel Operations, let’s add it to the script we started in the previous
exercise. Open Script4.m (if it’s not already open), and save it as MyScript4.m. Copy the pop_eegchanoperator line from eegh
history in the Command Window to the clipboard and then paste it into MyScript4.m right after the line that begins with EEG =
pop_loadset. Make sure you’ve pasted the version that uses the equations.txt file. Then save the updated MyScript4.m file. (I
always save a script before running it—if there’s an error that crashes Matlab, I don’t want to lose the new code that I just added.)
Now quit EEGLAB, type clear all, and run MyScript4.m to see it work. You should see EEGLAB launch and then lots of text
appear in the Command Window (mainly from EEG Channel Operations), including a line that says something like Processing
Subject 9 of 9, ID = 10 as each individual subject is being processed. Once the script finishes, you should plot the EEG from one
of the datasets, and then you’ll see that you now have bipolar VEOG and HEOG channels.
If you run into an error, make sure that you followed the above instructions carefully, and think about the logic of what you’re
doing. You can also consult the Troubleshooting Tips in Appendix 2. The next several sections of this chapter will require you to
make various additions to MyScript4.m, and you’ll almost certainly make at least one error at some point. When you do, feel free
to make a few unkind comments about my parentage, and then remember that errors are a big part of scripting and that one of the
goals of this book is for you to learn how to find and fix problems. Appendix 2 ends with some recommendations for writing code
in a way that reduces the likelihood of errors.
After you get the script to run correctly, I want you to spend a moment thinking about how easy it was to add the step for
referencing the data to the prior script. Once you had the basic script for looping through the participants and opening their
datasets, you just had to run EEG Channel Operations from the GUI, get the history, and copy the command from the history to the
appropriate point in the script. Done!
11.13.3 https://socialsci.libretexts.org/@go/page/137743

<!-- source_pdf=Full.pdf pdf_page=324 source_page_label="11.13.4" source_url="https://socialsci.libretexts.org/@go/page/137743" -->

## PDF page 324

- Source page label: 11.13.4
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137743

Well, not so fast. You’ll usually want to make a few changes to the command that you copied from the history. For example, the
new line of code you added to the script broke my rule about values (such as filenames) being defined as variables at the top of the
script. If you moved this script and the equations.txt file to a new folder, the script would break. The next exercise will solve this
problem and make some additional improvements.
This page titled 11.13: Exercise- Referencing with a Script is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
11.13.4 https://socialsci.libretexts.org/@go/page/137743

<!-- source_pdf=Full.pdf pdf_page=325 source_page_label="11.14.1" source_url="https://socialsci.libretexts.org/@go/page/137744" -->

## PDF page 325

- Source page label: 11.14.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137744

11.14: Exercise- Improving the Referencing Script
In this exercise, we’re going to make some improvements to the script from the previous exercise, including defining a variable for
the name of the equations file and saving the dataset to your hard drive.
Make sure that MyScript4.m is still open. At the end of the set of lines that define the other folders and filenames, add this line:
Equations_filename = [DIR 'equations.txt'];
That line will create a variable that holds the path and filename of the file with the equations. It’s really easy to make an error when
you create a variable like this. In fact, I initially made an error when I wrote that line of code. When you create a new variable for a
path and filename, you should check it first before running your script. To do this, run that one line of code. (The DIR variable
should already be set from when you ran the script earlier.) Then, type dir(Equations_filename) on the command line. The dir
command lists any files that match the variable you specify inside the parentheses. When you run this command, you should get an
error message saying that the file is not found.
Now type Equations_filename on the command line to see the value of this variable. Do you see the problem? We’re missing the
slash between the path and the filename (or a backslash on a Windows computer; see the text box below). Fix this by changing the
code to:
Equations_filename = [DIR '/equations.txt'];
Now run that line of code and then the dir(Equations_filename) command. If Equations_filename is set correctly, the dir
command should just print the name of the file (equations.txt).
Now replace the string holding the path and filename in the pop_eegchanoperator command with Equations_filename so that the
command looks like this:
EEG = pop_eegchanoperator( EEG, Equations_filename , 'ErrorMsg', 'popup', 'KeepChLoc',
'on', 'Warning', 'on' );
Quit EEGLAB, type clear all, and then save and run the updated script. It should lead to the same result as the previous version of
the script that didn’t use the Equations_filename variable, but the script is now more robust.
 Forward Slashes and Backslashes
Windows uses a backslash (\) to separate the elements of a path, whereas Mac OS, UNIX, and Linux use a forward slash (/).
Matlab is smart enough to convert to the appropriate separator for your computer. I don’t really trust it, though, so I like to use
a more explicit approach using a Matlab function named filesep. This function returns the appropriate file separator for the
computer that the script is running on. For example, I would define the variable for the equations file as [DIR filesep
'equations.txt'] rather than [DIR '/equations.txt'] or [DIR '\equations.txt']. If you type filesep on the command line, you’ll
see that it returns ‘/’ if you’re running Mac OS, UNIX, or Linux and ‘\’ if you’re running Windows.
Let’s make a couple more improvements. First, when a script is running, you don’t usually want error and warning messages to
appear as new windows that wait for you to respond. If you’re running a script overnight because it takes a long time, you don’t
want the script to be waiting for a response to a warning message when you arrive the next morning. So, let’s change 'ErrorMsg',
'popup' parameters in the pop_eegchanoperator() function to 'ErrorMsg', 'cw' so that error messages are printed in the
Command Window and change 'Warning', 'on' to 'Warning', 'off' so that warning messages aren’t printed. (But note that error
messages will still be printed.)
Now let’s make some changes that will have a more direct impact. First, we’re going to add _ref to the end of the name of the
dataset to indicate that the data have now been referenced. Type EEG.setname on the command line so that you can see what the
current setname is. If Subject 10 is the active dataset, you should see that the setname is '10_N170'. To update the setname, add the
following line to your script after the line with the pop_eegchanoperator command:
EEG.setname = [EEG.setname '_ref'];
11.14.1 https://socialsci.libretexts.org/@go/page/137744

<!-- source_pdf=Full.pdf pdf_page=326 source_page_label="11.14.2" source_url="https://socialsci.libretexts.org/@go/page/137744" -->

## PDF page 326

- Source page label: 11.14.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137744

This takes the current setname and appends _ref to the end, storing the result in the EEG.setname variable. That was pretty easy!
Note that this is right before the line with the eeg_store command, so the new setname will be stored in ALLEEG and therefore
appear in the Datasets menu once we get to the eeglab redraw command. This line of code violates my rule about using variables
to define values, because I didn’t define a variable for '_ref'. Rules are made to be broken, but only when there’s a good reason. In
this case, the '_ref' string is something that I always use, so putting it into the body of the script is unlikely to cause problems later.
Now let’s add some code for saving the referenced dataset to your hard drive, in the same folder as the original dataset. You should
first use the GUI to save the current dataset on your hard drive so that you can use the history to see the command for saving a
dataset file. Select EEGLAB > File > Save current dataset as, and use tmp.set as the filename (in the Chapter_11 folder).
Because you’re running this routine to see the history, you don’t actually need the file, and this filename will help you remember
that it’s a temporary file that you can delete at some point. Now type eegh to see the history. You should see something like this:
EEG = pop_saveset( EEG,
'filename','tmp.set','filepath','/Users/luck/Ch_10_Scripting/Exercises/');
Copy that line from the Command Window and paste it into your script after the line with the eeg_store command. But we want to
make some changes before we use it. First, we don’t want the file to be named tmp.set. I like to have the filename be the same as
the setname, but with .set on the end. To accomplish this, change the new line of code by replacing 'tmp.set' with [EEG.setname
'.set'] (which creates a string with the setname followed by .set).
We also want to change the path so that it uses the Subject_DIR variable we previously created to hold the path for this subject’s
data. To do this, replace the string that currently lists the path (which is '/Users/luck/Ch_10_Scripting/Exercises/' on my
computer but will be something else on your computer) to Subject_DIR. This line of code should now look like this:
EEG = pop_saveset( EEG, 'filename', [EEG.setname '.set'], 'filepath', Subject_DIR);
Before you run the code, I want to show you one more little trick for dealing with bugs and other kinds of errors. I probably made
an error at least 50% of the time when I added code to one of the scripts for this book. If you have a script that loops through the
data from 40 participants, it can be really annoying to have the script show an error message 40 times before it finishes. You can
usually type ctrl-C to stop the code after the first error, but that doesn’t always work. So, the first time I try out a new script, I just
try it with the data from the first participant. I do that by following the line that defines the subject IDs with another line that lists
only the first subject ID. For example, near the top of MyScript4.m, I have these two lines:
SUB = [ 1 2 3 5 6 7 8 9 10 ]; %Array of subject numbers
%SUB = [ 1 ]; %Just the first subject
The first time I run the script after making a change, I simply remove the % symbol on the second of the two lines. This overwrites
the original contents of SUB and replaces it with only the ID for Subject 1, and the loop runs only for this one subject. Once I get
the script to work for that one subject, I then put the % symbol back and run the script again.
To see this in action, add the line with SUB = [ 1 ]; (without the % symbol). Now you can run the new version of the script that
changes the setname and saves the dataset as a file. If you get an error, or it doesn't seem to work correctly, you can fix it and try
again. Once you get the script to work without any problems, you can comment out that line (i.e., add the % symbol) and run the
script again to process all the subjects.
Now you have a robust, well-designed script that loads the datasets, references the data, saves the referenced data to your hard
drive, and makes the datasets available in the EEGLAB GUI. You can now open Script4b.m to see my version of this script. It has
comments that explain each line of code.
Script4b.m also uses a slightly different version of the equations file, named Reference_Equations.txt, which reorders the
channels in addition to referencing them. The order of the channels in the original data files reflects the order of electrodes in the
BioSemi recording system we used to collect the data. This ordering is convenient for the process of placing the electrodes on the
head, but not for viewing the data. I reordered the channels so that they are in sets that go from left to right for a given line of
electrodes (e.g., F7, F3, Fz, F4, F8 for the Frontal channels).
This page titled 11.14: Exercise- Improving the Referencing Script is shared under a CC BY 4.0 license and was authored, remixed, and/or
curated by Steven J Luck directly on the LibreTexts platform.
11.14.2 https://socialsci.libretexts.org/@go/page/137744

<!-- source_pdf=Full.pdf pdf_page=327 source_page_label="11.14.3" source_url="https://socialsci.libretexts.org/@go/page/137744" -->

## PDF page 327

- Source page label: 11.14.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137744

11.14.3 https://socialsci.libretexts.org/@go/page/137744

<!-- source_pdf=Full.pdf pdf_page=328 source_page_label="11.15.1" source_url="https://socialsci.libretexts.org/@go/page/137745" -->

## PDF page 328

- Source page label: 11.15.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137745

11.15: Exercise- Preprocessing the EEG and Using a Spreadsheet to Store Subject-
Specific Information
As described in earlier chapters, I strongly recommend that you go through each step of EEG processing manually, looking at the
data from each step, before running a script. Actually, I don’t merely recommend it, I insist on it! This will allow you to catch
problems that would otherwise contaminate your data. It will also let you determine some subject-specific parameters, such as
which channels should be interpolated and what artifact detection parameters should be used. But if some parameters differ across
subjects, how can you use one script that processes the data from all the subjects?
The answer is to store the subject-specific parameters in a spreadsheet, and then have your script read the parameters from that
spreadsheet. This exercise is designed to show you how this works in the context of interpolating bad channels and other
preprocessing steps. The interpolation process won’t work properly if there are big voltage offsets in the data, so we’ll apply a
high-pass filter that eliminates these offsets prior to interpolation. Also, we need to figure out the 3-dimensional locations of the
electrodes, because this information is needed by the interpolation routine (which uses the distance between the to-be-interpolated
electrode and the other electrodes to compute sensible, distance-weighted values).
I’m not going to go through the process of running these routines in the GUI and looking at the history to see the corresponding
Matlab code. I assume you now understand that process, so I’ll go directly to the code. You can look up the help information for
these routines if you want a better understanding of the available options.
Start by quitting EEGLAB, typing clear all, and loading Script5.m. Let’s take a look at the script before running it. The first thing
to notice is a variable named Interpolation_filename that holds the name of an Excel file, interpolate.xlsx. This file contains
information about which channels are bad and should be interpolated. Take a look at the file in Excel (or import it into Google
Sheets or some other spreadsheet program). Here’s what you should see:
Table 11.2. Spreadsheet of information for interpolation (interpolate.xlsx).
ID Bad_Channels Ignored_Channels Channel_Names
1 [6 13] [31 32 33] C5, Oz
2 [31 32 33]
3 [25] [31 32 33] P8
4 [31 32 33]
6 [31 32 33]
7 [31 32 33]
8 [31 32 33]
9 [31 32 33]
10 [31 32 33]
The first column contains the Subject ID values (without Subject 5, who we’re still excluding). The second column indicates the
bad channels (if any) corresponding to the Subject ID values. They’re specified using square brackets so that they will be
interpreted as arrays by Matlab. You’ll see why that’s important in a bit. The next column indicates which channels should be
excluded when we compute the interpolated values (the EOG channels). Those are the same for each participant, so they could be
listed in the script, but I found it more convenient to put them into the spreadsheet. The last column shows the names of the bad
channels. This column isn’t used by the script, but it’s nice to have that information when you’re looking at the spreadsheet.
If you look closely at the contents of the cells (e.g., by looking at the Formula Bar), you’ll see that the value for each cell begins
with a single quote (except for the ID values). This tells Excel that the contents of that cell should be treated as a text string and
never interpreted as a number. I’ve found that this can avoid problems when we read the values into Matlab, because we want every
11.15.1 https://socialsci.libretexts.org/@go/page/137745

<!-- source_pdf=Full.pdf pdf_page=329 source_page_label="11.15.2" source_url="https://socialsci.libretexts.org/@go/page/137745" -->

## PDF page 329

- Source page label: 11.15.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137745

cell in a column to be the same data type. You should also note that the column labels don’t have any spaces or special characters in
them (except for the underscore character). The Matlab routine we’ll use to read the spreadsheet will use the column labels to
create new variables, so the labels need to be legal Matlab variable names.
Now look at the script again and find the line with the readtable command. This is a Matlab function that reads data from a file
into a special Table data structure. It’s a very powerful function that can read from many different file types. It uses the filename to
determine what kind of file is being read (e.g., the .xlsx filename extension is used to indicate that it’s an Excel XML file). It
creates a Table from the data file, and we’ve told it to store this Table in a variable named interpolation_parameters.
To see how this works, run the first part of the script, starting with the DIR = pwd line and going through the
interpolation_parameters = readtable(Interpolation_filename) line. Then double-click on the interpolation_parameters
variable in the Workspace pane so that you can see the contents of this variable. You’ll see that it contains the same rows and
columns that were in the spreadsheet. Now type interpolation_parameters.Bad_Channels on the command line. You’ll see a list
of the bad channels for each subject:
9×1 cell array
{'[6 13]'}
{0×0 char}
{'[25]' }
{0×0 char}
{0×0 char}
{0×0 char}
{0×0 char}
{0×0 char}
{0×0 char}
You can see that this list is in a special Matlab-specific format called a cell array. Cell arrays are a little difficult to understand and
tricky to use correctly. This is especially true for beginners, but I still often make mistakes when I try to use them. At some point
you’ll need to learn about them, because they’re very useful, but for now you can rely on code that I wrote that extracts the contents
of the interpolation_parameters table into a set of simple numeric arrays.
This code is embedded within the loop in Script5.m. Let’s execute the code, but without actually going through the whole loop. To
do this, first type subject = 1 on the command line so that the looping variable has the correct value for the first subject. Then
execute the ID = num2str(SUB(subject)) line in the body of the loop, because we’re going to need this variable. Now execute the
three lines of code beginning with table_row =. The first of these lines determines which row of the interpolation_parameters
table contains the values for this subject. The second line gets the array of bad channels for this subject and stores it in a variable
named bad_channels (which has zero elements if there are no bad channels). The third line gets the array of to-be-ignored
channels and stores it in a variable named ignored_channels. If you’re not already an experienced Matlab programmer, the code
on those lines probably looks like hieroglyphics—like I said, cell arrays are a little complicated. Once you’re more familiar with
Matlab coding, and you’ve wrapped your brain around cell arrays, you should come back to this code and figure out how it works.
But for now, you can treat it like a bit of magic that gets you the information you need.
Now you should inspect the contents of bad_channels and ignored_channels, either by typing the variable names on the
command line or looking at them in the Workspace. You’ll see that bad_channels is an array with the values 6 and 13 (the two bad
channels for Subject 1), and ignored_channels is an array with the values 31 through 33 (the three channels we will be ignoring
when computing interpolated values for the bad channels).
The next line of code does the interpolation using the pop_erplabInterpolateElectrodes function. You can see that we send the
bad_channels and ignored_channels variables to this function. But don’t run this line of code yet, because we haven’t run all of
the preceding lines in the body of the loop. Let’s take a look at those lines before we run them.
11.15.2 https://socialsci.libretexts.org/@go/page/137745

<!-- source_pdf=Full.pdf pdf_page=330 source_page_label="11.15.3" source_url="https://socialsci.libretexts.org/@go/page/137745" -->

## PDF page 330

- Source page label: 11.15.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137745

The body of the loop begins by setting some variables and loading the dataset, just as in the previous script. Then it runs a routine
called pop_erplabShiftEventCodes, which shifts all the stimulus event codes to be 26 ms later. This is necessary because there is
a fairly substantial delay between when an LCD display receives an image from the computer’s video card and when it actually
displays that image. We measured that delay using a photosensor and found that it was 26 ms. We therefore shift the event codes so
that they occur at the actual time that the stimulus appeared instead of at the time when the image was sent to the display. If you’re
using an LCD display, you must do this. If you don’t know how, contact the manufacturer of your EEG recording system.
The next step uses the pop_basicfilter function to run a bandpass filter with a bandpass of 0.1 to 30 Hz (12 dB/octave, which
corresponds to a filter order of 2 in the code). Filtering out the low frequencies is essential prior to interpolation, because otherwise
the random voltage offsets in each channel will produce a bizarre scalp distribution and the interpolation algorithm (which assumes
a smooth scalp distribution) will produce bizarre results. Note that it is a good idea to remove the DC offset before filtering
continuous EEG data, and this is implemented by specifying 'RemoveDC', 'on' when we call the pop_basicfilter function.
The next step runs the pop_chanedit function to add information about the 3D location of each electrode site based on the
electrode names. The function uses a file named standard-10-5-cap385.elp that is provided by EEGLAB. It contains a list of
standard electrode names (e.g., CPz) and their idealized locations on a spherical head. This doesn’t give you the true location for
each participant, which would require using a 3D digitization system, but it’s a good enough approximation for the interpolation
process.
The next few lines extract the information from the interpolation_parameters table and run the interpolation routine.
Finally, we reference the data and save the dataset to the hard drive (just as in the previous exercise).
Note that, for each of these processing operations, we send the dataset to the routine in the EEG variable, and then the routine
returns a modified dataset that we store in the EEG variable. In other words, the new dataset overwrites the old dataset in the EEG
variable. That’s much more efficient than storing the result of each new operation in ALLEEG. But note that keeping the
individual datasets makes sense when you’re processing the data in the GUI, because you want the flexibility of going back to a
previous dataset.
Now that we’ve looked at the code, let’s run the script, but only for the first subject. To limit it to the first subject, make sure that
the SUB = [ 1 ] line near the top isn’t commented out. Then run the script. You can now see that the script has created a new dataset
file named 1_N170_shift_filt_chanlocs_interp_ref.set in the Chapter_11 > N170_Data > 1 folder.
However, this dataset isn’t visible in the Datasets menu. Script5.m differs from the previous example scripts in that it doesn’t
make the datasets available in the EEGLAB GUI. It just does the processing and saves the results for each participant in a dataset
file. As you’ll see later in the chapter, you’ll often have a series of scripts for processing a given experiment (e.g., one for the initial
preprocessing, another for ICA, another for post-ICA EEG processing, and another for dealing with averages). Each of these scripts
will read in the files created by the previous script, so there’s often no need to make the datasets available in the GUI.
If you do want to look at the results of a given script, you’ll want a convenient way of reading in the files that were just created.
Script5.m accomplishes this by including code at the end for loading the new dataset files into ALLEEG. This makes it possible
for you to access these datasets from the EEGLAB GUI. This code is preceded by a return command, which causes the script to
terminate, so the code at the end won’t ordinarily execute when you run the script. But after you run the script, you can just select
the code at the end and run it manually (e.g., by clicking the Run Section button at the top of the script editor window). Give it a
try, and then verify that you can see the new dataset in the Datasets menu.
Plot this new dataset with EEGLAB > Plot > Channel data (scroll). Then load the original dataset (1_N170.set) for this
participant from the Chapter_11 > N170_Data > 1 folder and plot it as well. You’ll see that the new dataset is much smoother and
doesn’t have large DC offsets (because it has been bandpass filtered). And you can see some huge artifacts in the C5 and Oz
channels in the original data that are gone in the new data (because the script interpolated those channels). You should also notice
that the channels are in a more convenient order in the new dataset than in the original dataset as a result of the EEG Channel
Operations step near the end of the loop.
Now comment out the SUB = [ 1 ] line near the top of the script and run the script again to process the data from all 9 participants.
You can then select and execute the code at the end of the script for loading the new datasets into the EEGLAB GUI.
11.15.3 https://socialsci.libretexts.org/@go/page/137745

<!-- source_pdf=Full.pdf pdf_page=331 source_page_label="11.15.4" source_url="https://socialsci.libretexts.org/@go/page/137745" -->

## PDF page 331

- Source page label: 11.15.4
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137745

At this point, I’d like to remind you of some advice I gave you at the beginning of the chapter: Play! The best way to understand
how these scripts actually work is to play around with the code. If you’re not sure you understand one of the steps, try changing it
to see what happens. But don’t just do this randomly. Come up with hypotheses and test them by means of experimental
manipulations (i.e., by changing the code and seeing if the results confirm or disconfirm your hypotheses). You can also try
modifying the scripts to process your own data. Unless you’re a very experienced programmer, you probably won’t actually
understand the key points from this chapter unless you engage in this kind of active exploration. And now is a great time to play
around with the code, because the rest of the chapter assumes that you fully understand the basics and are ready to put them
together into a complete data processing pipeline.
This page titled 11.15: Exercise- Preprocessing the EEG and Using a Spreadsheet to Store Subject-Specific Information is shared under a CC BY
4.0 license and was authored, remixed, and/or curated by Steven J Luck directly on the LibreTexts platform.
11.15.4 https://socialsci.libretexts.org/@go/page/137745

<!-- source_pdf=Full.pdf pdf_page=332 source_page_label="11.16.1" source_url="https://socialsci.libretexts.org/@go/page/137746" -->

## PDF page 332

- Source page label: 11.16.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137746

11.16: Exercise- Building an Entire EEG Processing Pipeline
You’ve now learned the basics of scripting, so we’re ready to build an entire EEG preprocessing pipeline. This pipeline will
execute all the steps prior to averaging. It closely matches the example pipeline described in Appendix 3. Here, we’ve divided the
pipeline into five separate scripts:
Step1_pre_ICA_processing.m- Performs the initial preprocessing steps prior to ICA-based artifact correction
Step2_ICA_phase1.m- Creates an optimized dataset for the ICA decomposition
Step3_ICA_phase2.m- Performs the ICA decomposition
Step4_ICA_phase3.m- Transfers the ICA weights from the optimized dataset to the original dataset and reconstructs the data
without the artifactual ICs
Step5_post_ICA_processing.m- Performs the steps following artifact correction that are necessary prior to averaging
I encourage you to divide your EEG and ERP processing into multiple scripts in this manner. A general principle of good
programming is to divide a complex job into a set of small, independent modules. This makes each part of the job simpler and less
error-prone. It also makes it easier for you to find and fix problems. And it makes it easier for you to reuse your code for future
experiments. Ideally, none of your scripts should be more than about 200 lines long (including comments). If you find a script is
getting a little long, try to figure out how to break it up into a sequence of smaller scripts.
Step1_pre_ICA_processing.m is similar to Script5.m from the previous exercise, but with two major changes. First, interpolation
has been removed from this script and moved to a later stage, following artifact correction. Second, the new script references the
data to O2 rather than to the average of all sites. This is because using the average of all sites as a reference makes ICA complicated
(see the chapter on artifact correction). After the ICA step, we’ll re-reference to the average of all sites. By the way, I could have
used any site as the reference at this initial stage. See the following text box for more information.
 Recognizing a Conceptual Error
When I first started writing these scripts, I referenced the data to the average of all sites at the beginning of the pipeline
(because this is standard reference for the N170). I had gotten through the stage of performing the ICA decomposition, and I
started going through the data to determine which ICs should be removed (using the process described in the chapter on artifact
correction). The ICs from the first participant looked okay but not great. The time course of one of the top ICs had a lot of
weird high-frequency noise that I wasn’t seeing in the EEG. The ICs from the second participant were even worse, with the top
two ICs showing lots of high-frequency noise, and the eye movements distributed across three ICs. I was starting to get
suspicious. When I looked at the ICs for the third participant, the blinks were spread across the top four ICs, and two of them
again had a ton of weird high-frequency noise.
I then asked myself what I was doing differently from before, and then I realized that I was now referencing to the average of
all sites prior to the decomposition. I then changed the scripts to use O2 as the reference, re-ran the ICA decomposition, and
then everything worked better.
The moral of the story is that you may get occasional participants for whom the ICs don’t look great, but if you see more than
one or two, you need to think through your process and figure out what’s going wrong. The reference is one possible problem.
Another common problem is an insufficient recording duration (especially if you have >64 channels). A third common problem
is huge C.R.A.P. that hasn’t been eliminated prior to the decomposition.
Step2_ICA_phase1.m implements the procedures described in Chapter 9 for creating datasets that are optimized for the ICA
decomposition, including downsampling to 100 Hz, eliminating breaks and other periods of huge C.R.A.P., and implementing an
aggressive high-pass filter. It’s similar to one of the example scripts at the end of Chapter 9
(MMN_artifiact_correction_phase3.m). Open Step2_ICA_phase1.m and take a look at it.
One very important element of this script is that it assumes you’ve already gone through the EEG to determine the parameters that
you will use for finding huge C.R.A.P. with the Artifact rejection (continuous EEG) routine and stored these parameters in a
spreadsheet named ICA_Continuous_AR.xlsx. I’ve already done this for you. To determine these parameters, I first commented
out the part of the script that performs the continuous artifact rejection, and then I ran the code at the end of the script for loading
11.16.1 https://socialsci.libretexts.org/@go/page/137746

<!-- source_pdf=Full.pdf pdf_page=333 source_page_label="11.16.2" source_url="https://socialsci.libretexts.org/@go/page/137746" -->

## PDF page 333

- Source page label: 11.16.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137746

the datasets into the EEGLAB GUI. These datasets have been downsampled and aggressively filtered, and I wanted to see what the
artifacts looked like in these datasets because they will be used for the continuous artifact rejection. Two of the subjects had some
large C.R.A.P., and I ran the Artifact rejection (continuous EEG) routine from the GUI for these subjects to figure out the best
rejection criteria. As discussed in the chapter on artifact correction, you really need to look carefully at the data when setting these
parameters if you want ICA to work well. The spreadsheet also indicates which channels to include. I’ve left out the EOG channels
and Fp1/Fp2 so that ordinary ocular artifacts don’t get deleted. I’ve also left out any channels that will be left out of the ICA
decomposition and interpolated later. Crazy periods in these channels won’t influence the decomposition, so we don’t need to
delete them.
If you look at the code for reading these parameters from the spreadsheet, you’ll see that it’s much like the code for reading the
parameters for interpolating bad channels in the previous exercise, except that we have different columns labels in the spreadsheet.
You’ll also see that the script calls the pop_erplabDeleteTimeSegments routine to delete the periods of time during the breaks,
which also helps get rid of large C.R.A.P. Note that the parameters that control this routine are defined as variables at the top of the
script, following good programming practice.
Once you’ve looked through the script to see how it works, go ahead and run it. You’ll see that it creates a new dataset file for each
participant with _optimized at the end of the filename. You can also load the new datasets into the EEGLAB GUI by running the
bit of code at the end of the script. This allows you to see what the optimized datasets look like and make sure everything worked
properly.
Step3_ICA_phase2.m runs the ICA decomposition process on the dataset created by Step2_ICA_phase1.m. It assumes that an
Excel spreadsheet named interpolate.xlsx has already been created to indicate which channels will be interpolated after correction
has been performed and should therefore be excluded from the ICA decomposition. I’ve already created this file for you. Note that
the decomposition process is quite slow, so this script takes a long time to run.
Step4_ICA_phase3.m takes the ICA weights in the optimized dataset and transfers them back to the pre-optimization dataset. It
then removes the artifactual ICs, which are listed in a file named ICs_to_Remove.xlsx. I had to determine which ICs were
artifactual by looking at the IC scalp maps and by comparing the IC time courses with the EEG/EOG time courses (as described in
the chapter on artifact correction). To make this easier, I used the bit of code at the end of Step3_ICA_phase2.m to load the
datasets into the EEGLAB GUI.
I didn’t spend a lot of time making careful decisions about which ICs to remove (and making sure that the ICA decomposition was
truly optimal). For example, Subject 1 still has some blink activity remaining in F4 after the correction. It’s really boring to spend
many hours in a row getting the ICA perfect for a large set of participants! This is one more reason why you should do the initial
preprocessing of each participant within 48 hours of data collection. It’s a lot easier to spend the time required to optimize the ICA
when you’re only doing it for one participant at a time and don’t have to spend an entire day processing the data from 20
participants.
The last script is Step5_post_ICA_processing.m, which performs the steps following artifact correction that must be executed
prior to averaging. This includes re-referencing to the average of all sites (and putting the channels into a more useful order),
performing interpolation for any bad channels, adding an EventList, assigning events to bins with BINLISTER, epoching the data,
and performing artifact detection. The script also prints a summary of the overall proportion of trials marked for rejection in each
participant and creates an Excel file with this information broken down by bin.
Open the script and take a look. You’ll see that the first part of the script (prior to the loop) defines and opens a set of files with the
artifact detection parameters. We’ve already corrected for blinks, so we only want to flag epochs with blinks that occurred at a time
that might interfere with the perception of the stimulus. Eye movements aren’t typically an issue in this paradigm because the
stimuli are presented briefly in the center of the display, but we flag trials with eye movements that might interfere with the
perception of the stimulus (which were quite rare). We use the uncorrected bipolar channels for the blink and eye movement
detection. We also flag trials with large C.R.A.P. in any of the EEG channels (using both an absolute voltage threshold and a
moving window peak-to-peak amplitude algorithm). Each of these artifact detection routines uses a different flag so that we can
keep track of the number of trials flagged for each type of artifact.
11.16.2 https://socialsci.libretexts.org/@go/page/137746

<!-- source_pdf=Full.pdf pdf_page=334 source_page_label="11.16.3" source_url="https://socialsci.libretexts.org/@go/page/137746" -->

## PDF page 334

- Source page label: 11.16.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137746

The top portion of the script also pre-allocates a set of arrays that will be used to store the number of accepted and rejected trials for
each participant. This pre-allocation isn’t strictly necessary, but it’s good programming practice—it makes it clear what the
dimensions of the arrays are.
The body of the subject loop loads the dataset created by the previous script, interpolates any bad channels, re-references the data,
creates the EventList, runs BINLISTER, and epochs the data. These steps are pretty straightforward.
The next set of lines reads the parameters for blink detection from a spreadsheet and then runs the step function algorithm to find
blinks that occurred between -200 and +300 ms. These lines use the same “magic code” that I used to grab parameters from
spreadsheets in the previous scripts. I didn’t spend a lot of time setting the artifact detection parameters—you could do a better job
if you spent some time using the strategies described in the chapter on artifact rejection. Once the parameters have been extracted
from the spreadsheet, the artifact detection routine is called. We then repeat this process for the eye movement and C.R.A.P.
artifacts.
Each of these artifact detection steps adds to the flags set by the previous step. At the end, we save the dataset to the hard drive. It’s
now ready for averaging!
After the end of the loop, I added some code to grab information about the number of trials that were flagged for each participant.
The code demonstrates how to save this information in Matlab’s special Table format, which then makes it easy to save the
information as a spreadsheet.
As usual, the end of the script has some code after the return statement that you can use to load the datasets into the EEGLAB
GUI.
Whew! That’s a lot of code. But I hope it shows you how to break a complex sequence of processing steps into a set of relatively
simple modules. And I hope it also demonstrates the process of going back and forth between the GUI (to set various participant-
specific parameters and make sure the data look okay) and scripts (which are much faster, especially when you need to reprocess
the data multiple times).
One last thing: Once you’ve created a set of scripts that perform the different processing stages for your experiment, you can create
a “master script” that simply calls the scripts for each stage. Then you can execute all the stages by calling this one script.
This page titled 11.16: Exercise- Building an Entire EEG Processing Pipeline is shared under a CC BY 4.0 license and was authored, remixed,
and/or curated by Steven J Luck directly on the LibreTexts platform.
11.16.3 https://socialsci.libretexts.org/@go/page/137746

<!-- source_pdf=Full.pdf pdf_page=335 source_page_label="11.17.1" source_url="https://socialsci.libretexts.org/@go/page/137747" -->

## PDF page 335

- Source page label: 11.17.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137747

11.17: Exercise- Averaging with a Custom aSME Time Window
The series of scripts in the previous exercise produce a dataset for each participant that is ready for averaging. In the present
exercise, we’ll compute the averaged ERPs, including calculating aSME for a custom time window of 110-150 ms (the
measurement window for the N170). We’ll then create a grand average across participants and plot it. Finally, we’ll print a
summary of the aSME values to the Command Window.
Go ahead an open the script (Step6_averaging_and_SME.m) and take a look at it. As usual, the script begins by defining a set of
variables that will be used later in the script. It also opens a file named ERPset_files.txt. This file will be used when we make the
grand average. When we made grand averages in previous chapters, we loaded all the single-participant ERPsets into ALLERP and
then told the grand averaging routine which of these ERPsets to include the grand average. However, it’s sometimes more
convenient just to work with one ERPSet at a time, save the ERPsets as files on the hard drive, and not keep all the ERPsets loaded
in memory. In this case, we can send the grand averaging routine a list of the filenames of the ERPsets, which are themselves stored
in a text file. This is what ERPset_files.txt is used for in the present script. I could have just loaded all the ERPsets into ALLERP,
but I wanted to demonstrate this alternative approach and show you how to open a text file and write to it.
The main loop in the script begins by loading the dataset that was created by the previous script, which is all ready for averaging.
The next few lines define the custom aSME time window. This information is stored in a data structure called a DQ_spec (data
quality specification). This structure both defines the time windows prior to obtaining the data quality measures and stores the data
quality measures once they’ve been calculated. It’s a little complicated, so ERPLAB provides a routine called make_DQ_spec to
create it.
We use this routine to create a variable named custom_aSME_spec. There are potentially many different types of data quality
metrics that can be stored in a DQ_spec variable. The first metric stored in a DQ_spec structure is a measure of the baseline noise.
The second is the standard error of the mean at each individual time point. The third is the aSME. It’s possible for you to define
additional types, the most common of which is the bSME (bootstrapped SME). Here, we’re going to use aSME, but we’re going to
specific a custom time window for the aSME calculation so that we get an aSME value that corresponds to our N170 measurement
window (110–150 ms). We do this by finding out how many time windows have already been defined by default and then adding a
new one.
The next step is to call the averaging routine (pop_averager), sending it the custom_aSME_spec variable that we just created so
that it will compute the aSME for our custom time window (along with the default time windows). This routine returns an ERPset
that we store in the ERP variable. We then create a name for the ERPset and save the ERPset to a file on the hard drive. We also
save the name of this file (including the path) in the ERPset_files.txt file so that we have it when we make the grand average later.
The ERP variable includes a field named ERP.dataquality that stores the data quality metrics that were calculated during the
averaging process. The script shows how you can grab the aSME values from ERP.dataquality for the channel we will ultimately
use to score the N170 amplitude (PO8, Channel 27). For each subject, we get an array of four aSME values for this channel, one for
each of the four bins. We store this in a two-dimensional array named aSME_custom_values, which has one dimension for
subjects and another dimension for bins. The aSME data inside ERP.dataquality are stored in a 3D array with dimensions of
channels, time ranges, and bins, and we use a Matlab function called squeeze to convert this 3D array into the 1D array of values
for each bin for the current subject:
aSME_custom_values(subject,:) =
squeeze(ERP.dataquality(where_aSME).data(measurement_channel,custom_entry_index,:));
When you’re first learning to write scripts in Matlab, you’ll probably find that you frequently get confused about how arrays work
and when you need to use a function like squeeze to obtain the desired results. I still sometimes get confused, and I often make
mistakes when writing code that operates on complicated arrays. But I’ve learned how in interpret Matlab’s error messages, and I
often search the Internet for solutions. I also recommend getting a good Matlab book and spending some time learning the logic
behind how Matlab operates on arrays. As I mentioned earlier, my lab uses a book called Matlab for Behavioral Scientists
(Rosenbaum et al., 2014).
After the main loop finishes, the script makes a grand average using the filenames stored in ERPset_files.txt. It then plots the
grand average so that you can see how to script the plotting routine (pop_ploterps).
11.17.1 https://socialsci.libretexts.org/@go/page/137747

<!-- source_pdf=Full.pdf pdf_page=336 source_page_label="11.17.2" source_url="https://socialsci.libretexts.org/@go/page/137747" -->

## PDF page 336

- Source page label: 11.17.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137747

Finally, the script prints out the custom aSME values that we saved in the variable named aSME_custom_values for each
participant. It also prints the mean across participants for each bin, along with the RMS (root mean square). The RMS is like the
mean, but it does a better job of capturing how the noise level from the individual participants will impact the variability in N170
amplitude scores across participants, the effect size, and the statistical power (see Luck et al., 2021). I recommend taking a look at
the aSME values for each participant and then looking at their EEG and ERPs to see if you can understand why some participants
have worse (larger) aSME values than others.
The aSME quantifies the data quality for the mean voltage within a given time window, so it’s most directly useful when you’re
scoring amplitude using the mean voltage (which is how we scored N170 amplitude in the ERP CORE paper). If you’re using some
other scoring method (e.g., peak amplitude, fractional peak latency), you need to use a more complicated method called
bootstrapping to obtain the SME values. You’ll also need to use bootstrapping if you’ll be obtaining scores from difference waves
or if you apply any other kind of processing to the ERP data after averaging but before scoring (e.g., filtering or channel
operations). ERPLAB currently requires scripting to compute bootstrapped SME values, and of the example scripts at the end of
Chapter 10 demonstrate how to do this. Chapter 10 also contains a script that demonstrates how to obtain behavioral data.
This page titled 11.17: Exercise- Averaging with a Custom aSME Time Window is shared under a CC BY 4.0 license and was authored, remixed,
and/or curated by Steven J Luck directly on the LibreTexts platform.
11.17.2 https://socialsci.libretexts.org/@go/page/137747

<!-- source_pdf=Full.pdf pdf_page=337 source_page_label="11.18.1" source_url="https://socialsci.libretexts.org/@go/page/137748" -->

## PDF page 337

- Source page label: 11.18.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137748

11.18: Exercise- Scoring Amplitudes and Latencies and Performing Statistical
Analyses
This exercise demonstrates the final stages of processing, in which we obtain amplitude and/or latency scores from each participant
and perform statistical analyses. There are many ways we could analyze the N170 data, but here we will look at three simple
approaches.
In the first approach, we’ll measure the mean amplitude in the N170 latency range (110-150 ms) for the faces and cars in the left-
hemisphere and right-hemisphere electrode clusters. We’ll then perform a 2 ´ 2 ANOVA with factors of stimulus type (face vs. car)
and electrode hemisphere (left vs. right). The N170 is typically larger for faces than for cars, and this effect is usually larger in the
right hemisphere than in the left hemisphere. As a result, we would expect a main effect of stimulus type and a stimulus type ´
electrode hemisphere interaction. You’ll need to perform this statistical analysis using your own statistics package.
Any differences between the faces and the cars in the first analysis could reflect differences in low-level features (e.g., luminance,
spatial frequency) rather than differences between the face and car categories per se. To address this possibility, the experiment also
presented phase-scrambled face and car images, which contain the same low-level features as the faces and cars but are
unrecognizable as faces or cars. In our second analysis, we’ll make a face-minus-scrambled-face difference wave and a car-minus-
scrambled-car difference wave. The ERP activity directly attributable to the low-level features should be subtracted away in these
difference waves, and any differences between the two difference waves can be attributed to higher-level features.
The third analysis will be just like the second analysis, except that it will be performed on the peak latency of the N170 rather than
the mean amplitude. Because peaks are easily distorted by high-frequency noise, we’ll apply a stronger low-pass filter to the data
prior to measuring the peak latency.
Important: For the second and third analyses, the scripts will perform a paired t test comparing the two difference waves (only for
the right-hemisphere electrode cluster). This uses a Matlab function called ttest, which is a part of the Statistics and Machine
Learning Toolbox. You can see if you have that toolbox by typing ver on the Matlab command line. If you don’t have that toolbox,
you can just delete (or comment out) those lines of the script.
Go ahead an open the script (Step7_scoring.m) and take a look at it. As usual, the script begins by defining a set of variables that
will be used later in the script. It also opens a couple files that we’ll use to store the names of the ERPset files. We’ll send these
files to the Measurement Tool so that it knows which ERPsets to use for scoring the ERPs (just like we did with the grand
averaging routine in the previous exercise).
The main loop loads the ERPsets created by the script in the previous exercise. It then uses ERP Channel Operations (the
pop_erpchanoperator routine) to create a left-hemisphere cluster channel and a right-hemisphere cluster channel. This is pretty
simple, so we just send the equations directly in the script rather than saving them in a file.
The next step is to create the difference waves using ERP Bin Operations (the pop_binoperator routine). It sends a file named
BinOps_Diff.txt that contains the equations for making the difference waves. The channel and bin operations create updated
versions of the ERP variable, and we save this ERPset to the hard drive. We also save the name of the ERPset in a file named
Measurement_files.txt.
Then we apply a low-pass filter with a half-amplitude cutoff at 15 Hz and a slope of 48 dB/octave, which help us measure the peak
latency more precisely. The resulting ERPset is saved to the hard drive, and the name of the ERPset is saved in a file named
Measurement_15Hz_files.txt.
After we loop through all the subjects, we close the two files that are used to store the ERPset filenames. Then we start the first
analysis stage, in which we obtain the mean amplitude scores from the parent waveforms. This is achieved by calling the
pop_geterpvalues routine, which is the script equivalent of the Measurement Tool. We send it the name of the file that holds the
names of all the unfiltered ERPsets that we created in the loop so that it knows which ERPsets should be measured. We also send it
the start and end times of the measurement window (110 and 150 ms, which are the values recommended in the ERP CORE paper).
We also send two arrays, one containing a list of the bins that we want to measure (Bins 1-4, which contain the parent waveforms)
and one containing a list of the channels that we want to measure (35 and 36, the left- and right-hemisphere cluster channels).
11.18.1 https://socialsci.libretexts.org/@go/page/137748

<!-- source_pdf=Full.pdf pdf_page=338 source_page_label="11.18.2" source_url="https://socialsci.libretexts.org/@go/page/137748" -->

## PDF page 338

- Source page label: 11.18.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137748

There are also some parameters that you should recognize from using the GUI version of the Measurement Tool. Finally, we tell it
the name of the text file that it should use for saving the amplitude scores (MeanAmp.txt).
Go ahead and run the script, and you’ll see that it creates the MeanAmp.txt file, with one line for each subject and one column for
each of our 8 measurements (4 bins ´ 2 channels). Load these data into a statistical package. We’re going to ignore the bins for the
scrambled stimuli and perform a 2 ´ 2 ANOVA with factors of stimulus type (face vs. car) and electrode hemisphere (left vs. right).
If you run the analysis, you should get something like the ANOVA table shown in Table 11.3.
Table 11.3. ANOVA table for the first N170 analysis (from JASP).
Cases Sum of Squares df Mean Square F p
Hemisphere 3.228 1 3.228 1.552 0.248
Residuals 16.639 8 2.080
StimType 43.727 1 43.727 62.393 < .001
Residuals 5.607 8 0.701
Hemisphere ´
2.180 1 2.180 3.485 0.099
StimType
Residuals 5.004 8 0.625
As predicted, the greater N170 amplitude for the faces than for the cars led to a significant main effect of stimulus type. The effect
was somewhat greater in the right-hemisphere cluster than in the left-hemisphere cluster, but the stimulus type ´ electrode
hemisphere interaction did not reach significance. We have only 9 participants, so this probably just reflects low power.
The next part of the script obtains the mean amplitude scores from the difference waves. This time, however, it doesn’t save the
scores in a file. Instead, we use the 'SendtoWorkspace', 'on' option to save the scores in a variable named ERP_MEASURES in
the Matlab workspace. This variable is a 3-dimensional array with dimensions of bin, channel, and subject. For example,
ERP_MEASURES(2, 1, 7) is the score for the second bin, the first channel, and the seventh subject. The script grabs these values
and stores them in two one-dimensional arrays, one for the faces-minus-scrambled-faces bin and one for the cars-minus-scrambled-
cars bin. The one dimension is subject, so each of these arrays has 9 values.
We then send these two arrays to the ttest function like this:
[h,p,ci,stats] = ttest(faces_minus_scrambled_meanamp, cars_minus_scrambled_meanamp);
The function returns four variables: h is a 1 if the effect was significant and 0 otherwise (assuming an alpha of .05); p is the p value
from the test; ci is the 95% confidence interval for the difference between the two means; and stats holds the actual t value along
with the degrees of freedom. This routine can be used to perform a paired t test or a one-sample t test. The ttest2 function can be
used for an independent-samples t test, which you would use to compare two groups of subjects. After the script calls the ttest
function, it uses fprintf to print the results in the Command Window. As you can see by looking at your Command Window, there
was a significant difference in amplitude between the faces-minus-scrambled-faces and cars-minus-scrambled-cars difference
waves.
The last part of the script measures the peak latency of the N170 instead of the mean amplitude. It uses a wider measurement
window (which is often needed for latency measures), and it performs the measurements from the more aggressively filtered
ERPsets. The script then calls the ttest function and prints the results in the Command Window. The peak latency was significantly
earlier for the faces-minus-scrambled-faces waveform than for the cars-minus-scrambled-cars waveform (consistent with Figures
11.1D and 11.1E).
This is the last script for this chapter. You’ve now gone through every major step of EEG and ERP processing, all the way from
reading in the raw EEG to conducting a statistical analysis. Congratulations!
But remember, you should go back and forth between scripts and the GUI rather than relying solely on scripts. For example, you
should use the Viewer option in the Measurement Tool to look at the scores alongside each averaged ERP waveform to verify that
11.18.2 https://socialsci.libretexts.org/@go/page/137748

<!-- source_pdf=Full.pdf pdf_page=339 source_page_label="11.18.3" source_url="https://socialsci.libretexts.org/@go/page/137748" -->

## PDF page 339

- Source page label: 11.18.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137748

the measurement process is working properly. However, the script is also useful, because it makes it easier to repeat the processing
if you need to make a change somewhere earlier in the pipeline. Also, if you make your scripts and data available when you publish
a paper, other researchers can see exactly how you implemented each step of processing rather than relying on the relatively brief
and vague description of the processing that is typically provided in a Method section.
Scripting is a skill that takes a long time to master, and you may initially wonder if it’s worthwhile. It may seem like it’s faster to do
everything in the GUI than to spend hours debugging scripts that do the same thing. But in the long run, scripting is incredibly
useful, and you will get faster with experience. You’ll still make lots of mistakes—I certainly do!—but you’ll be able to find and
fix them much more rapidly once you have more experience.
This page titled 11.18: Exercise- Scoring Amplitudes and Latencies and Performing Statistical Analyses is shared under a CC BY 4.0 license and
was authored, remixed, and/or curated by Steven J Luck directly on the LibreTexts platform.
11.18.3 https://socialsci.libretexts.org/@go/page/137748

<!-- source_pdf=Full.pdf pdf_page=340 source_page_label="11.19.1" source_url="https://socialsci.libretexts.org/@go/page/137749" -->

## PDF page 340

- Source page label: 11.19.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137749

11.19: Key Takeaways and References
Key Takeaways
The process of creating a script typically involves running the processing steps in the EEGLAB/ERPLAB GUI, copying the
commands from the history into a script, and adding a loop.
You will save yourself a lot of time and pain in the long run by using intrinsically meaningful variable names, including lots of
comments, and defining all key values as variables at the top of the script.
It’s almost always better to write a sequence of relatively simple scripts rather than one large script that does everything. This
makes errors less likely, makes errors easier to find, and gives you more flexibility.
You should make extensive use of the GUI the first time your process the data from a given participant. This allows you to
detect problems in the data, set participant-specific parameters (e.g., for artifact rejection and correction), and make sure that
everything is working properly. Once you’ve gone through the data in this manner, you should reprocess the data with your
scripts (which helps avoids errors that can occur in manual processing).
You can learn a lot by getting example scripts from other people, but don’t apply those scripts to your own data unless you fully
understand every line of code.
References
Emerson, R. W. (1841). Self-Reliance. Lulu Press.
Luck, S. J., Stewart, A. X., Simmons, A. M., & Rhemtulla, M. (2021). Standardized measurement error: A universal metric of data
quality for averaged event-related potentials. Psychophysiology, 58, e13793. https://doi.org/10.1111/psyp.13793
Rosenbaum, D. A., Vaughan, J., & Wyble, B. (2014). MATLAB for Behavioral Scientists (2nd Edition). Routledge.
Rossion, B., & Caharel, S. (2011). ERP evidence for the speed of face categorization in the human brain: Disentangling the
contribution of low-level visual cues from face perception. Vision Research, 51(12), 1297–1311.
https://doi.org/10.1016/j.visres.2011.04.003
This page titled 11.19: Key Takeaways and References is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven
J Luck directly on the LibreTexts platform.
11.19.1 https://socialsci.libretexts.org/@go/page/137749
