# 1: First Steps

> Source: *Applied Event-Related Potential Data Analysis* (Steven J. Luck), `Full.pdf`, PDF pages 14-33. Text is a mechanical page-by-page extraction, not a summary. Consult the PDF for figures and layout.

<!-- source_pdf=Full.pdf pdf_page=14 source_page_label="1" source_url="" -->

## PDF page 14

- Source page label: 1
- LibreTexts source: not printed on page

CHAPTER OVERVIEW
1: First Steps
 Learning Objectives
In this chapter, you will learn to:
Install the EEGLAB and ERPLAB and download the data for the exercises
Load EEG and ERP data
Plot EEG waveforms and spectra
Plot ERP waveforms and scalp maps
Update the Matlab PATH when you install or update EEGLAB/ERPLAB
This chapter is designed to provide key background knowledge you’ll need for the rest of the book. We’ll begin by describing the
goals of this book and the background knowledge you should have. Then we’ll show you how to install the software and download
some data, followed by a few exercises so that you can learn the basics of the EEGLAB and ERPLAB software packages that will
be used throughout the book.
1.1: Getting Started
1.2: Installing the Software and Downloading the Data
1.3: Exercise- Loading an EEG File
1.4: Exercise - Viewing Continuous EEG Waveforms
1.5: Exercise - Viewing EEG Spectra
1.6: Exercise- Loading ERPs and Plotting ERP Waveforms
1.7: Exercise- Plotting ERP Scalp Maps
1.8: Finding the Right Routine in EEGLAB and ERPLAB
1.9: Understanding the Matlab Path
1.10: Key Takeaways and References
This page titled 1: First Steps is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck directly on the
LibreTexts platform.
1

<!-- source_pdf=Full.pdf pdf_page=15 source_page_label="1.1.1" source_url="https://socialsci.libretexts.org/@go/page/135674" -->

## PDF page 15

- Source page label: 1.1.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/135674

1.1: Getting Started
This section of Chapter 1 provides some important background information that you need to know to make effective use of this
book. The whole book will make much more sense if you read this section first!
The Goal of This Book
The primary goal of this book is to help students and researchers learn how to process and analyze event-related potentials (ERPs).
My other ERP book (Luck, 2014) focuses on providing a conceptual understanding of ERPs, and the present book focuses on
applying those concepts to real data. Theory is important, but there is no substitute for loading up real data—with all its warts and
complexities—and figuring out how to go from a gigabyte of raw EEG files to a set of statistical analyses and figures that are ready
for publication.
At its essence, this book is a set of data processing and analysis exercises that are wrapped in explanatory text. ERP analysis
involves a million decisions, such as whether to filter before versus after artifact rejection and what measurement window to use
for quantifying the amplitude of an ERP component. The exercises in this book are designed to give you experience making
choices that will lead to the most robust and valid conclusions. In theory, you could read the book without doing the exercises, but
that would be like trying to learn painting from a textbook without ever picking up a paintbrush. So fire up your computer and get
ready to process some data!
I waited until now to write this book because I needed two things: 1) Free software that anyone can use to do the exercises, and 2) a
large public dataset with multiple different ERP paradigms. Both are now available. The free software consists of ERPLAB
Toolbox and its companion EEGLAB Toolbox, and the large public dataset is the ERP CORE (Compendium of Open Resources
and Experiments).
ERPLAB and EEGLAB
ERPLAB (Lopez-Calderon & Luck, 2014) is a Matlab toolbox that my lab produces with a grant from the National Institutes of
Health (NIH). ERPLAB works in tandem with another NIH-supported Matlab toolbox called EEGLAB, which is developed under
the leadership of Arno Delorme and Scott Makeig at UCSD (Delorme & Makeig, 2004). EEGLAB takes care of several important
EEG preprocessing steps, and ERPLAB allows you to create and analyze averaged ERP waveforms. The good news is that both of
these toolboxes are free. The bad news is that Matlab is not free, and you will need it to run EEGLAB and ERPLAB. However,
most institutions provide reduced-cost Matlab licenses, and the student version is even less expensive. Matlab has become the
lingua franca of cognitive neuroscience, and it’s well worth the investment.
The ERP Core
The ERP CORE is a set of six classic ERP paradigms that have been optimized to isolate seven widely-studied ERP components
(N170, mismatch negativity, N400, P3b, N2pc, error-related negativity, and lateralized readiness potential). Emily Kappenman and
I created the ERP CORE to provide a set of “reference” data that could be used by a large set of researchers for a wide range of
purposes. The public resource includes the experimental control scripts, data from 40 neurotypical young adults, and the
EEGLAB/ERPLAB processing scripts. If you’d like to know how to obtain a robust N400, you can download our N400
experimental control script to see how it’s done. If you’d like to see how to professionally analyze the error-related negativity
(ERN), you can download our ERN processing scripts. If you’ve just put together your own EEG recording system and you’d like
to see if everything is working, you can run or more of our paradigms and compare your data with our data (including quantitative
metrics of data quality).
The ERP CORE is particularly useful for this book because it provides data from many different paradigms, and yet the data are
similarly formatted for each paradigm. That way you can see how to process many different types of data, but you won’t have to
deal with superficial differences between data sets (e.g., differences in file naming conventions). Although you can download the
ERP CORE files directly from the ERP CORE site, you should instead download the data using the links provided within this book
for each exercise, which provide a more streamlined set of files.
1.1.1 https://socialsci.libretexts.org/@go/page/135674

<!-- source_pdf=Full.pdf pdf_page=16 source_page_label="1.1.2" source_url="https://socialsci.libretexts.org/@go/page/135674" -->

## PDF page 16

- Source page label: 1.1.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/135674

Scripting
EEGLAB has a graphical user interface (GUI) that allows you to process data by pointing and clicking, and ERPLAB works as a
plugin to EEGLAB. Many people use EEGLAB and ERPLAB entirely through the GUI. With the exception of the last chapter, all
the exercises in this book use the GUI.
However, you can achieve a lot of additional power and flexibility by writing Matlab scripts, which are text files that specify each
processing operation with a line of code. Scripts allow you to automate the EEG and ERP processing steps, which is a huge time-
saver (especially when your mentor or a reviewer makes you reprocess all of your data). If you already know how to write Matlab
scripts, then you’ll find it straightforward to write scripts with the EEGLAB and ERPLAB routines. If you don’t know Matlab but
you have some significant experience in one or more other programming languages, you’ll be able to pick up Matlab pretty quickly
(although it has a few quirks that you’ll need to learn).
If you don’t have much programming experience, EEGLAB and ERPLAB provide a good starting point for you to learn. Every
operation that you perform in the EEGLAB/ERPLAB GUI corresponds to a line of code, and every time you perform an EEGLAB
or ERPLAB operation in the GUI, that line of code is saved to a history. You can grab these lines of code from the history, paste
them into a text file, and voila! You have a script!
To get real power and flexibility, however, you also need to learn a little bit about the Matlab programming language. Chapter 11 is
devoted to teaching you how to write EEGLAB/ERPLAB scripts. It’s designed for people at all levels of prior programming
experience. However, it does assume that you know some basic programming concepts (e.g., variables, loops). If you want to learn
scripting—which is an incredibly useful skill—I recommend taking a Matlab course and/or working through one or more Matlab
books. I particularly recommend a book called Matlab for Behavioral Scientists (Rosenbaum et al., 2014) and the online
Introduction to Programming with MATLAB course from Coursera.
I’ve also provided example scripts at the end of each chapter, showing you how to implement the GUI steps from that chapter in a
script. I find that it’s much easier to start with an example script and modify it than to write a script from scratch.
Although the chapter on scripting is the last chapter of the book, you might want to read the first half sooner than that so that you
understand the essence of EEGLAB/ERPLAB scripting. The last half of Chapter 11 uses processing steps that are covered in
Chapters 2-10, so you should probably save that half until later.
Expected Background Knowledge
This book assumes that you already have some very basic knowledge about ERPs. If you don’t, Appendix 1 provides a quick
overview. Here are some things you’ll need to know right away:
Generation of the EEG from postsynaptic potentials in cortical pyramidal cells
The 10/20 system for electrode locations
Creating averaged ERPs from single-trial EEG epochs
Artifact rejection and artifact correction
ERP peaks and components
All of these issues are briefly covered in Appendix 1, and you should read about them if they are not already familiar.
If you want additional background, I recommend the first 2 chapters in An Introduction to the ERP Technique (Luck, 2014) or a
chapter I wrote for the APA Handbook of Research Methods (Luck, 2012). Or, better yet, you can take my free online course,
Introduction to ERPs, which typically takes about 4 hours to complete. The first 2 “chapters” of the online course would be enough
to get you started and should take you less than an hour.
Much of the theory behind the analysis approaches described in this book is described in An Introduction to the ERP Technique
(Luck, 2014). If you want to become an ERP researcher, you need to understand the reasons behind the recommended processing
steps, so I recommend going back and forth between that book and the present book. You’ll see lots of places in the present book
where I point you to the relevant chapters in An Introduction to the ERP Technique.
You will also want to consult the online documentation for EEGLAB and ERPLAB if you want to understand some of the options
and parameters in the software. There are millions of details about the operation of the software that I didn’t want to repeat in this
1.1.2 https://socialsci.libretexts.org/@go/page/135674

<!-- source_pdf=Full.pdf pdf_page=17 source_page_label="1.1.3" source_url="https://socialsci.libretexts.org/@go/page/135674" -->

## PDF page 17

- Source page label: 1.1.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/135674

book.
Read This Now or You'll Be Sorry!
The original heading for this section was “Troubleshooting,” but that sounds way too boring, and I figured many people would skip
it. But don’t skip it! This is the most important section of this chapter.
Unless you already have years of experience with EEGLAB and ERPLAB, you’re bound to run into a few problems when you try
to complete the exercises in this book. EEGLAB and ERPLAB are professional-strength software packages designed for state-of-
the-art research, and the datasets used in the exercises are large and complex. As a result, I can’t foresee every possible problem
that might arise on your individual computer, and you’ll probably encounter error messages, results that don’t match what are
shown in the book, etc.
When you encounter one of these problems, you’ll certainly be frustrated and you might even be tempted to curse my ancestors.
But these problems are actually an important part of the learning process. When you’re analyzing your own data, you’ll run into
many of the same problems. In fact, the problems will probably be worse with your own data, because the data used in our
exercises have been carefully chosen to avoid many common problems.
So, when you run into a problem, try to look at it as an opportunity for growth. Of course, you might let out a few expletives and
need to spend a minute doing deep breathing exercises before you remember that the error message on the screen is actually a gift
in disguise. To reduce your blood pressure and help you learn the art of troubleshooting, we’ve provided a Troubleshooting Guide
in Appendix 2. I recommend skimming it now and then returning to it when you inevitably run into problems.
Here's a related but more positive piece of advice: Play! I learned the important of playing in science from one of my undergrad
mentors, Allen Neuringer. If you simply follow the exercises in this book exactly as written, you’ll certainly learn a lot. But if you
want to really understand what you’re doing, you should spend considerable time playing around with things (e.g., the various
options in the ERPLAB GUI). For example, there are many things that I say you shouldn’t do, such as applying a high-pass filter to
averaged ERP waveforms. But don’t just take my word for it – try it and see what happens.
This page titled 1.1: Getting Started is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck directly on
the LibreTexts platform.
1.1.3 https://socialsci.libretexts.org/@go/page/135674

<!-- source_pdf=Full.pdf pdf_page=18 source_page_label="1.2.1" source_url="https://socialsci.libretexts.org/@go/page/87925" -->

## PDF page 18

- Source page label: 1.2.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87925

1.2: Installing the Software and Downloading the Data
Minimum hardware and software requirements were listed previously. However, keep in mind that those are only the minimum.
You will find the exercises to be much more pleasant if you have at least 8 GB of RAM and at least a 1080p screen. If you don’t
have much free disk space, you may need to keep the data from only one or two exercises on your computer at a given time.
Installing Matlab
You will need Matlab version 2017a or later, including the Signal Processing Toolbox. The Statistics and Machine Learning
Toolbox is recommended (but is not required for any of the exercises in this book). Once you have installed Matlab, you can see
what toolboxes are installed by typing ver on the Matlab command line. If you don't have the necessary toolboxes, contact your
institution's IT support department for assistance.
Installing EEGLAB and ERPLAB
New versions of Matlab, EEGLAB, and ERPLAB are released at least once per year, and these new versions can lead to changes in
how things look (and occasionally changes in the results). To write this book, I mainly used Matlab 2017a or 2020b, EEGLAB
2020.0, and ERPLAB 8.23 on a MacBook Pro running macOS 11. However, we added some important features to ERPLAB as I
was writing, so you should use EEGLAB 2022.0 or later and ERPLAB 9.0 or later (see the Hardware and Software Requirements
section). You will probably use a different combination, so the screenshots and videos in this book may not exactly match what you
see. Newer versions of Matlab, EEGLAB, and ERPLAB will probably work fine, but I would recommend against using older
versions.
ERPLAB runs as an EEGLAB plugin, so you must install EEGLAB before installing ERPLAB. You can find the documentation
for EEGLAB, including instructions for downloading and installing, at https://sccn.ucsd.edu/wiki/EEGLAB. Make sure to install
version 2022.0 or later. Once you’ve installed it, you can launch EEGLAB by typing eeglab in the Matlab command window.
Screenshot 1.1 shows what it should look like when EEGLAB has been launched.
Screenshot 1.1
1.2.1 https://socialsci.libretexts.org/@go/page/87925

<!-- source_pdf=Full.pdf pdf_page=19 source_page_label="1.2.2" source_url="https://socialsci.libretexts.org/@go/page/87925" -->

## PDF page 19

- Source page label: 1.2.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87925

A key step in installing EEGLAB is to update the Matlab PATH (whether you are installing EEGLAB for the first time or
upgrading to a newer version). If you don’t know how to do this, or you can’t get EEGLAB to launch, you should read the
description of how the PATH works later in this chapter. If you are having trouble launching EEGLAB but the PATH isn’t the
problem, see the ERPLAB FAQ page, the EEGLAB documentation or the Troubleshooting Guide in Appendix 2.
Once you have installed EEGLAB, you can download and install ERPLAB (version 9.0 or later). The ERPLAB documentation,
including installation instructions, can be found at https://github.com/lucklab/erplab/wiki. There are two ways to install ERPLAB.
If you just want the latest major release, you can launch EEGLAB and use its built-in extensions manager by going to File >
Manage EEGLAB extensions in the EEGLAB GUI. It will pop up a window with a list of extensions; select ERPLAB and click
install/update. If you want an earlier version of ERPLAB (or if you’re a do-it-yourselfer by nature), you can download ERPLAB
at https://github.com/lucklab/erplab. Additional ERPLAB installation information can be found at
https://github.com/lucklab/erplab/wiki/Installation. Once ERPLAB has been installed and is running within EEGLAB, the
EEGLAB GUI should include an ERPLAB menu, as in Screenshot 1.2.
Screenshot 1.2
ERPLAB Installation Problems
ERPLAB is installed inside the plugins folder within the EEGLAB folder (e.g., eeglab2020_0 > plugins > ERPLAB8.30). The
most common installation problem is that ERPLAB is not located in this place. You should see a file named
eegplugin_erplab.m inside that folder (and not inside another folder). ERPLAB has a Frequently Asked Questions page with
information about solving such problems.
Another problem that occasionally arises (especially when ERPLAB is being used on a multiuser computer) is that ERPLAB
must have write access to the folder that contains the ERPLAB software. This is necessary so that ERPLAB can update a file
named memoryerp.erpm, which stores various user settings. To avoid this problem, you should install EEGLAB and
ERPLAB inside a folder that you own (e.g., your Documents folder) rather than installing it in a folder that is used by multiple
people.
Downloading Data for the Exercises
The data for the exercises are stored in a cloud storage system, and the master folder can be accessed at
https://doi.org/10.18115/D50056. This master folder contains a set of subfolders with the data for each chapter. Unfortunately, the
cloud storage system may be blocked in some countries, but I have faith that clever readers will still find a way to access the data.
The data have been released with a Creative Commons license that permits them to be copied, used, remixed, and reposted as long
as the original source is cited (see the license.txt file in each subfolder). Note that some of the folders are quite large and may take
quite a while to download.
1.2.2 https://socialsci.libretexts.org/@go/page/87925

<!-- source_pdf=Full.pdf pdf_page=20 source_page_label="1.2.3" source_url="https://socialsci.libretexts.org/@go/page/87925" -->

## PDF page 20

- Source page label: 1.2.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87925

Free Data!
Once you’ve finished using this book to learn how to analyze ERP data, you should feel free to download the original data
from the ERP CORE. The CORE is a very rich dataset, and you could use it to for novel analyses that might be publishable.
Wouldn’t it be nice to publish an ERP paper without having to collect the data yourself?
This page titled 1.2: Installing the Software and Downloading the Data is shared under a CC BY 4.0 license and was authored, remixed, and/or
curated by Steven J Luck directly on the LibreTexts platform.
1.2.3 https://socialsci.libretexts.org/@go/page/87925

<!-- source_pdf=Full.pdf pdf_page=21 source_page_label="1.3.1" source_url="https://socialsci.libretexts.org/@go/page/87926" -->

## PDF page 21

- Source page label: 1.3.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87926

1.3: Exercise- Loading an EEG File
We’re now going to start a quick tour of EEGLAB and ERPLAB. In the first exercise, you’ll look at the EEG data and the averaged
ERPs from one subject in an N400 experiment that will be described in more detail in the next chapter.
If Matlab is not already running, launch it. If EEGLAB is already running, quit from EEGLAB and launch it again by typing
eeglab in the Matlab command window. (It’s usually a good idea to quit and restart EEGLAB before starting an exercise. That way,
EEGLAB will be in its default state, and what you see will better match the screenshots in this book.)
Now download the Chapter 1 folder from the master folder at https://doi.org/10.18115/D50056. Note that an underscore is used
instead of a space in the folder name. Spaces can sometimes confuse Matlab, so it’s best to use underscores or dashes instead of
spaces in your folder names and file names. But don’t use any other non-alphanumeric characters. Set Chapter_1 to be Matlab’s
current folder. The current folder is part of Matlab’s path, and it’s the first place Matlab will look for files and code. Screenshot 1.3
shows what it should look like once you’ve set the current folder. You’ll see the path to the folder and the contents of the folder.
Screenshot 1.3
There are various ways of setting the current folder, including double-clicking on a folder name within the current folder. Play
around with this a bit (Googling it if necessary using a search phrase such as “matlab current folder GUI”). You’ll be changing the
current folder frequently, so you’ll want to know how to do it efficiently.
Once you have the correct current folder, go to the EEGLAB window and select File > Load existing dataset. It will bring up a
dialog box, which should show the contents of the Chapter_1 folder. Select and open the file named 1_N400_preprocessed.set.
This file is called a dataset, which means that it contains the EEG data for one participant. You can see that it loaded correctly by
looking in EEGLAB’s Datasets menu (see Screenshot 1.4).
Screenshot 1.4
This page titled 1.3: Exercise- Loading an EEG File is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
1.3.1 https://socialsci.libretexts.org/@go/page/87926

<!-- source_pdf=Full.pdf pdf_page=22 source_page_label="1.4.1" source_url="https://socialsci.libretexts.org/@go/page/87927" -->

## PDF page 22

- Source page label: 1.4.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87927

1.4: Exercise - Viewing Continuous EEG Waveforms
Now let’s take a look at the EEG data that we just loaded. In the EEGLAB window, go to Plot > Channel data (scroll). This will
be your main way of visualizing EEG data. You should see a new window that looks something like Screenshot 1.5. This window is
showing the EEG data from all of the electrode sites for the first five seconds of the recording. If you click the >> button near the
bottom of the window, it will scroll rightward to show you the next 5-second period. Using the <<, <, >, and >> buttons, scan
through the file and see what the EEG looks like
If you type a number into the text box between the < and > buttons, it will go to that time point. Try typing 20 into that box (and hit
Enter/Return). You should now see the data from 20-25 seconds.
Screenshot 1.5
Now we’re going to zoom in a little closer. You should be looking at the data from 20-25 seconds; if not, type 20 into the box
between the < and > buttons. To zoom in on a shorter time period, go to the menus in the plot window and selection Settings >
Time range to display, type a 1 into the text box, and click OK. You’ll now be looking at the time period from 20-21 seconds
instead of 20-25 seconds.
Now let’s adjust the vertical zoom. If you look near the right edge of the window, you should see a vertical scale marker. On my
computer, it says 194 µV (but it might be different on your computer). This means that the vertical space indicated by the marker
corresponds to 194 µV. To zoom in closer, we need to do something a little counterintuitive: We need to use a smaller number of
µV for that marker. For example, if we use 50 µV for that same vertical space, a smaller voltage deflection will now extend over a
larger vertical range. To make this change, enter 50 into the vertical scale text box (indicated by the red box in Screenshot 1.6).
Now you’re zoomed in both in time and in amplitude.
If you look at the occipital and parietal electrode sites (e.g., O1), you can see an oscillating wave. Count the number of positive
peaks. You should see 11 peaks in this 1-second period. 11 peaks per second means that it’s an 11 Hz oscillation. This is called the
alpha wave, which was the very first feature of the human EEG to be described (Berger, 1929). Alpha waves are oscillations at
approximately 10 Hz that are largest over posterior electrode sites and are particularly large when the participant is zoned out or has
closed eyes. I like to think of alpha waves as indicating that the participant’s attention is internally focused instead of externally
focused. In most experiments, you want the subject to be alert and paying attention externally to the task, so you don’t want to see
alpha waves. However, most ERP experiments are pretty boring, so the participants are often a little sleepy and generate quite a bit
of alpha. When a participant produces a lot of alpha, we often give them a break and offer a caffeinated beverage.
1.4.1 https://socialsci.libretexts.org/@go/page/87927

<!-- source_pdf=Full.pdf pdf_page=23 source_page_label="1.4.2" source_url="https://socialsci.libretexts.org/@go/page/87927" -->

## PDF page 23

- Source page label: 1.4.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87927

Screenshot 1.6
This page titled 1.4: Exercise - Viewing Continuous EEG Waveforms is shared under a CC BY 4.0 license and was authored, remixed, and/or
curated by Steven J Luck directly on the LibreTexts platform.
1.4.2 https://socialsci.libretexts.org/@go/page/87927

<!-- source_pdf=Full.pdf pdf_page=24 source_page_label="1.5.1" source_url="https://socialsci.libretexts.org/@go/page/87928" -->

## PDF page 24

- Source page label: 1.5.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87928

1.5: Exercise - Viewing EEG Spectra
Now let’s take a closer look at the alpha wave. Close the plotting window that shows the EEG, go to the main EEGLAB GUI, and
select Plot > Channel spectra and maps. Adjust the bottom three text boxes so that they match the values shown in the left
portion of Screenshot 1.7 and then click OK. You should now see a window like that shown on the right side of Screenshot 1.7.
This routine performs a Fourier transform of the EEG, converting it from the time domain to the frequency domain (see Chapters 1
and 12 in Luck, 2014). The waveforms at the bottom of the window show the strength of each frequency in the EEG data, with one
waveform for each channel. You can see that most of the channels have a peak around 11 Hz, which is the alpha wave you saw
previously. The topograph map at the top shows how the strength at 11 Hz varies across the scalp (using interpolation to estimate
the values in between the electrode sites). You can see a big peak over the posterior electrode sites, where the alpha is largest.
Screenshot 1.7
Try playing around with the settings for this routine (e.g., getting scalp maps for different frequencies). When you’re done, close
the plotting window to prepare for the next exercise.
This page titled 1.5: Exercise - Viewing EEG Spectra is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
1.5.1 https://socialsci.libretexts.org/@go/page/87928

<!-- source_pdf=Full.pdf pdf_page=25 source_page_label="1.6.1" source_url="https://socialsci.libretexts.org/@go/page/87929" -->

## PDF page 25

- Source page label: 1.6.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87929

1.6: Exercise- Loading ERPs and Plotting ERP Waveforms
Now we’re going to load some averaged ERP data and plot the waveforms. Take a look at the ERPLAB menu inside the EEGLAB
window. ERPLAB is an EEGLAB plugin, and the ERPLAB menu is the main way you’ll access the ERPLAB functions.
Select ERPLAB > Load existing ERPset, which will bring up a dialog box showing you the contents of the current folder. Select
and open the file named 1_N400_erp.erp. An ERPset is the ERPLAB equivalent of EEGLAB’s datasets. Instead of holding EEG
data, an ERPset contains averaged ERPs. I previously created this ERPset by averaging together the trials in the EEG dataset that
you looked at in the previous exercise. We’ll see how this averaging process works later. The currently loaded ERPsets are listed in
the ERPsets menu (see Screenshot 1.8).
Screenshot 1.8
To visualize the ERP waveforms in an ERPset, go to ERPLAB > Plot ERP > Plot ERP waveforms. It will bring up a large and
complicated window that allows you to control many different plotting parameters. Click the RESET button at the bottom window
so that it uses its default parameters, and the click the PLOT button in the lower right corner of the window. You should see
something like Screenshot 1.9. (Hint: If things don’t look right when you plot a set of ERP waveforms, trying clicking the RESET
button to get rid of any custom settings that you might have been using the last time you plotted some waveforms.)
1.6.1 https://socialsci.libretexts.org/@go/page/87929

<!-- source_pdf=Full.pdf pdf_page=26 source_page_label="1.6.2" source_url="https://socialsci.libretexts.org/@go/page/87929" -->

## PDF page 26

- Source page label: 1.6.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87929

Screenshot 1.9
This ERPset contains ERPs for two different bins (experimental conditions), labeled “All Unrelated, Correct” and “All Related,
Correct”. There is a separate waveform for each electrode site for each of the two bins.
If you click an electrode label (like FP1 for the waveforms in the upper left corner), it will pop up a new window with a blown-up
version of the waveforms for that electrode site. The plotting GUI is a little twitchy and a little slow. If it doesn’t pop up the
window after a second or two, try again (but wait a second before trying again or you’ll end up with multiple windows open). Also,
you only need to click once; if you double-click the electrode label, you may end up with an extra copy of the blown-up window.
Play around with this a bit, and close the plotting windows when you’re done.
The GUI that controls the plotting has a lot of options. For example, you select the show standard error option, it will show the
standard error of the mean at each time point as a semitransparent cloud around the waveform. Play around with the options in this
window so that you get a sense of what you can do.
Making High-Quality Figures
Although ERPLAB’s tool for plotting ERP waveforms has a lot of options, it’s not designed to create publication-quality
figures. To make nice figures for papers, posters, or presentations, you can plot the waveforms with this tool and then select
File > Save As… from the plotting window. I recommend saving the plot in a vector format, such as PDF or SVG. In my lab,
we save the files in SVG format and then load these files into a graphics program called Affinity Designer (which is like
Adobe Illustrator, but easier to use and much less expensive).
Save As… gives you a lot of other file format options, including several bitmap formats (e.g., .bmp, .jpg, .tif). I recommend
against using bitmap formats, because they’re difficult to edit and look terrible when blown up. If you don’t know the
difference between vector and bitmap formats, you should search for “vector versus bitmap” in your favorite search engine. It’s
an important distinction when you’re trying to plot ERP waveforms.
You can also plot the waveforms by going to ERPLAB > ERP Viewer (see Screenshot 1.10). Give it a try. This tool ordinarily
shows you one waveform at a time (although you can overlay multiple waveforms by checking the boxes labeled all. You can scan
1.6.2 https://socialsci.libretexts.org/@go/page/87929

<!-- source_pdf=Full.pdf pdf_page=27 source_page_label="1.6.3" source_url="https://socialsci.libretexts.org/@go/page/87929" -->

## PDF page 27

- Source page label: 1.6.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87929

through different bins and channels by clicking the arrow buttons next to Bin and Channel. If you click the box labeled Adjust
measurement time by clicking with the mouse on the desired latency (near the left side of the window), you can click a point on
the waveform and see the amplitude and latency at that point. This tool also provide a convenient way of overlaying waveforms
from different files.
Screenshot 1.10
This page titled 1.6: Exercise- Loading ERPs and Plotting ERP Waveforms is shared under a CC BY 4.0 license and was authored, remixed,
and/or curated by Steven J Luck directly on the LibreTexts platform.
1.6.3 https://socialsci.libretexts.org/@go/page/87929

<!-- source_pdf=Full.pdf pdf_page=28 source_page_label="1.7.1" source_url="https://socialsci.libretexts.org/@go/page/87930" -->

## PDF page 28

- Source page label: 1.7.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87930

1.7: Exercise- Plotting ERP Scalp Maps
As a last step in our quick tour of EEGLAB and ERPLAB, we’re going to plot a topographic map (aka scalp map) of the ERPs.
Select ERPLAB > Plot ERP > Plot Scalp maps, which will bring up a dialog box that lets you control the plotting parameters.
Enter 1 into the text box at the upper left labeled Bin(s) to plot (so that it plots bin 1) and enter 400 into the text box labeled
Latencies to plot in ms (so that it plots the voltage at 400 ms). Then check the box labeled display color scale box near the right
edge of the window. Finally, click the PLOT button in the lower right corner. You should see something like Screenshot 1.11.
Screenshot 1.11
Each little dot on the head is one of the electrode sites. The coloring indicates the voltage at each point on the scalp (using
interpolation to fill in the values between electrodes). The scale along the right side indicates what amplitude (in microvolts) is
indicated by a particular color.
This page titled 1.7: Exercise- Plotting ERP Scalp Maps is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck.
1.7.1 https://socialsci.libretexts.org/@go/page/87930

<!-- source_pdf=Full.pdf pdf_page=29 source_page_label="1.8.1" source_url="https://socialsci.libretexts.org/@go/page/108196" -->

## PDF page 29

- Source page label: 1.8.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108196

1.8: Finding the Right Routine in EEGLAB and ERPLAB
The fact that ERPLAB works as an EEGLAB plugin has many advantages. However, it occasionally produces some complications.
For example, when you are first learning to use EEGLAB and ERPLAB, you will probably find that you occasionally look in the
wrong menu. For example, it’s natural to go to the File menu when you want to load an ERP data file or the Plot menu when you
want to plot an ERP waveform. However, all ERP-related routines are in the ERPLAB menu (e.g., ERPLAB > Load Existing
ERPset and ERPLAB > Plot > Plot ERP Waveforms).
To make things even more complicated, we’ve added several routines for processing EEG data to the ERPLAB menu (e.g.,
ERPLAB > EEG Channel Operations). We created these routines for several reasons. In some cases, EEGLAB just didn’t have a
piece of functionality that we needed. In other cases, we wanted to create improved versions of functionality that was already
present in EEGLAB. And in a few cases, the needs of typical ERP analysis required somewhat different versions of existing
EEGLAB functions. To keep ERPLAB modular, all of these new or updated EEG functions are accessed from the ERPLAB menu.
To help you find what you’re looking for and use the appropriate routines, Figure 1.1 shows the key menus and indicates which
EEGLAB functions should be replaced by ERPLAB functions.
Figure 1.1. Key menus from the EEGLAB GUI. You will use the ERPLAB menu for all ERP-related operations and the other
menus for EEG-related operations. For example, you will use the File menu to import and open EEG files (“datasets”), but ERP
files (“ERPsets”) are loaded from the ERPLAB menu. Similarly, you will use the Plot menu to plot EEG data, but ERPLAB > Plot
to plot ERP data. Also, some EEGLAB functions cannot be used in conjunction with ERPLAB (the study functions and the
Extract epochs function), and other functions will work but are not recommended because analogous functions are available in the
ERPLAB menu (e.g., filtering and re-referencing).
This page titled 1.8: Finding the Right Routine in EEGLAB and ERPLAB is shared under a CC BY 4.0 license and was authored, remixed, and/or
curated by Steven J Luck directly on the LibreTexts platform.
1.8.1 https://socialsci.libretexts.org/@go/page/108196

<!-- source_pdf=Full.pdf pdf_page=30 source_page_label="1.9.1" source_url="https://socialsci.libretexts.org/@go/page/135804" -->

## PDF page 30

- Source page label: 1.9.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/135804

1.9: Understanding the Matlab Path
Now that you’ve had a chance to play around with EEGLAB and ERPLAB a bit, I want to discuss a vitally important concept, the
PATH. Many of the problems that Matlab beginners encounter are a result of not understanding and appropriately setting the PATH.
If you’re already quite familiar with the Matlab PATH, you can skip this section.
Simply put, the Matlab’s PATH defines where it will look for code and other files. When you type eeglab into the Matlab command
window to launch EEGLAB, the only reason that Matlab knows where to find the EEGLAB code on your computer is that you (or
someone) set the PATH to include the location of the files containing the EEGLAB code. And if you’re reading this section because
you’re having a problem getting EEGLAB to run, there’s a good chance that you’re having a PATH problem.
As you know, your computer’s file system is divided into a set of folders (also called directories). The folders are hierarchically
organized: You have a main folder for each drive, and those folders contain sub-folders, which contain sub-sub-folders, etc. The
location of a file can be expressed concisely as something like
D:\books\ERP_Analysis_Book\Exercises\Chapter_2\1_N400_erp.erp (on a Windows system) or
/Users/luck/Documents/books/ERP_Analysis_Book/Exercises/Chapter_2/1_N400_erp.erp (on a Mac or Linux system). To
make life complicated, DOS and Windows use backslashes to separate the names of the folders, whereas Mac and Linux use
forward slashes.
The location of a single file, when expressed this way, is the path to the file. But note that I’m using lower case to refer to the path
for a single file. I use upper case to refer to Matlab’s PATH, which consists of a list of multiple paths. This list defines where
Matlab will look for code and other files. But note: Matlab will first look in the current folder (indicated by the blue arrow in
Figure 1.2) before looking in the folders defined by the PATH.
Let’s take a look at the PATH on your computer. In the main Matlab window, click on the icon labeled Set Path (circled in red
Figure 1.2, but note that it might be somewhere else in your version of Matlab). This should cause a new window appear, like the
one shown at the bottom of Figure 1.2.
You should see the main folder for EEGLAB in the PATH. If you recently installed EEGLAB, it should be at the top. If you’re
having trouble getting EEGLAB to launch, make sure you have the EEGLAB path in your PATH. To add the EEGLAB folder to
your PATH, click on Add Folder…, navigate to the location of the EEGLAB folder that you downloaded when you installed
EEGLAB, and add it to the PATH. It’s also possible that the path is incorrect (e.g., because the folder was moved after the PATH
was set). If you already have EEGLAB in your PATH but you don’t know how to verify that the path is correct, you can delete the
existing EEGLAB path (including all the subfolders) using the Remove button and then add the path again using Add Folder…
1.9.1 https://socialsci.libretexts.org/@go/page/135804

<!-- source_pdf=Full.pdf pdf_page=31 source_page_label="1.9.2" source_url="https://socialsci.libretexts.org/@go/page/135804" -->

## PDF page 31

- Source page label: 1.9.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/135804

Figure 1.2. Setting the PATH in Matlab. To set the PATH, you click on the Set Path icon in the main Matlab window (circled in red
here). This brings up the dialog box. Note that the current folder is indicated by the blue arrow. You can click on Add Folder… to
add a new folder to the PATH. You can also remove items from the PATH using the Remove button. Make sure to click Save so
that the PATH is saved for future Matlab session. Note that this might look different on your computer.
When you’re done updating the PATH, click Save and then Close. If you click the Close button without saving, the updated PATH
will work, but it will be forgotten when you quit from Matlab. You need to click Save before you click Close if you want Matlab to
remember the path when you launch it again in the future.
Now let’s talk in a little more detail about how the PATH works. A complicated package like EEGLAB or ERPLAB is divided into
tons of individual files (often called .m files because the filename ends in .m). When you type eeglab in the Matlab command
window, Matlab searches the path for a file named matlab.m, and then it executes the code in this file. The code in the eeglab.m
file calls many other functions, such as eeg_checkset(). The code for a given function is typically stored in a separate .m file. When
Matlab needs to call eeg_checkset(), it therefore looks for it in a file named eeg_checkset.m. Where does Matlab look to find this
file? In the folders defined by the PATH, of course. The eeg_checkset.m file is actually located in a subfolder within the main
EEGLAB folder. This is why there are actually many EEGLAB subfolders in your PATH.
When you add a new folder to the PATH, you would ordinarily click on Add with Subfolders… to make sure that all the
subfolders within the new folder are in your path. However, EEGLAB is smart enough that it will automatically add the subfolders
when you click Add Folder…
Here’s the key takeaway from what we’ve discussed so far: Almost every command and function in Matlab is stored in a .m
file, and when you try to execute a command or function, Matlab searches the PATH to find it. If Matlab tells you that it
can’t find a function or a .m file, this almost always means that you don’t have the PATH set correctly.
Another problem that can arise is that there might be two different .m files with the same name in your path. For example, if you
install a new version of EEGLAB on your computer, and you add the folder containing this version to your PATH without
removing the old path, Matlab might execute the wrong version. So, make sure to clean out the old folder (and any subfolders)
using the Remove button when installing a new version.
It's also possible that you have another package (e.g., FieldTrip or PsychToolbox) in your PATH that defines a function with the
same name as one of the EEGLAB functions. For example, both EEGLAB and FieldTrip could have a function named
PlotEEGWaveforms, which would be stored in a file named PlotEEGWaveforms.m. You would then have two identical files in
1.9.2 https://socialsci.libretexts.org/@go/page/135804

<!-- source_pdf=Full.pdf pdf_page=32 source_page_label="1.9.3" source_url="https://socialsci.libretexts.org/@go/page/135804" -->

## PDF page 32

- Source page label: 1.9.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/135804

your PATH. Which file will Matlab use when it tries to call the PlotEEGWaveforms function? The answer is simple: It searches
the folder in the order that they’re listed in the PATH, and it stops searching once it finds a match.
Yet another common problem is that the path to a folder may have one or more spaces, such as D:\books\ERP Analysis
Book\Exercises. That’s usually not a problem, but sometimes Matlab will interpret such a path as being three separate things
(D:\books\ERP and Analysis and Book\Exercises). If this happens, you can usually solve the problem either by using underscores
instead of spaces or by enclosing the path in single quotes (e.g., 'D:\books\ERP Analysis Book\Exercises').
If you want more information, Matlab’s online documentation provides a detailed description of how the PATH works.
This page titled 1.9: Understanding the Matlab Path is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
1.9.3 https://socialsci.libretexts.org/@go/page/135804

<!-- source_pdf=Full.pdf pdf_page=33 source_page_label="1.10.1" source_url="https://socialsci.libretexts.org/@go/page/108197" -->

## PDF page 33

- Source page label: 1.10.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108197

1.10: Key Takeaways and References
Key Takeaways
This book focuses on applied ERP data analysis, using the open source EEGLAB and ERPLAB analysis packages. The
packages are free, but they require Matlab to run.
Most of the analysis examples are from the ERP CORE, a set of 6 standardized ERP experiments.
You will almost certainly run into technical problems, but a major goal of the book is for you to learn to solve these problems.
Appendix 2 provides a Troubleshooting Guide that will teach you some useful principles for solving technical problems.
Because ERPLAB is an EEGLAB plugin, you may have trouble figuring out where to find the routines you need and
determining whether to use an EEGLAB routine or an ERPLAB routine. You can refer to Figure 1.1 to help you find what
you’re looking for.
References
Berger, H. (1929). Ueber das Elektrenkephalogramm des Menschen. Archives Fur Psychiatrie Nervenkrankheiten, 87, 527–570.
Delorme, A., & Makeig, S. (2004). EEGLAB: an open source toolbox for analysis of single-trial EEG dynamics including
independent component analysis. Journal of Neuroscience Methods, 134, 9–21.
Lopez-Calderon, J., & Luck, S. J. (2014). ERPLAB: An open-source toolbox for the analysis of event-related potentials. Frontiers
in Human Neuroscience, 8, 213. https://doi.org/10.3389/fnhum.2014.00213
Luck, S. J. (2012). Event-related potentials. In H. Cooper, P. M. Camic, D. L. Long, A. T. Panter, D. Rindskopf, & K. J. Sher (Eds.),
APA Handbook of Research Methods in Psychology: Volume 1, Foundations, Planning, Measures, and Psychometrics (pp. 523–
546). American Psychological Association.
Luck, S. J. (2014). An Introduction to the Event-Related Potential Technique, Second Edition. MIT Press.
Rosenbaum, D. A., Vaughan, J., & Wyble, B. (2014). MATLAB for Behavioral Scientists (2nd Edition). Routledge.
This page titled 1.10: Key Takeaways and References is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
1.10.1 https://socialsci.libretexts.org/@go/page/108197
