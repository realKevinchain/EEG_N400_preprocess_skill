# 2: Processing One Participant in the ERP CORE N400 Experiment

> Source: *Applied Event-Related Potential Data Analysis* (Steven J. Luck), `Full.pdf`, PDF pages 34-70. Text is a mechanical page-by-page extraction, not a summary. Consult the PDF for figures and layout.

<!-- source_pdf=Full.pdf pdf_page=34 source_page_label="1" source_url="" -->

## PDF page 34

- Source page label: 1
- LibreTexts source: not printed on page

CHAPTER OVERVIEW
2: Processing the Data from One Participant in the ERP CORE N400 Experiment
 Learning Objectives
In this chapter, you will learn to:
Load EEG data
Create an EVENTLIST, which stores information about events such as stimuli and responses
Assign events to bins with BINLISTER
A bin is a set of ERP waveforms, one for each channel, that were created by averaging together a set of trials
Parse the continuous EEG into a series of discrete epochs (e.g., from -200 to +800 ms relative to stimulus onset) and
perform baseline correction
Perform simple artifact rejection
Compute and plot averaged ERP waveforms
Filter EEG and ERP data
Make difference waves
This chapter goes through a simple example experiment so you can see the basic steps involved in processing the data from a single
participant. The experiment is from the ERP CORE (Kappenman et al., 2021), and it is designed to isolate the N400 component
that is elicited when a word is semantically unrelated to a previous word (e.g., SHOE when it’s preceded by TREE instead of by
SOCK).
We’ll go through the most basic EEG processing steps (e.g., epoching, baseline correction, artifact detection) and create averaged
ERPs for a single participant. In the next chapter, we’ll process additional participants, measure the N400 amplitude, and do a
simple statistical analysis. The details of these steps will be described in later chapters, along with important details about how
Matlab, EEGLAB, and ERPLAB work. These two chapters are designed for you to get the big picture of how the data are
processed and learn the basics of using EEGLAB and ERPLAB. You can also find an overview of an entire EEG processing
pipeline in Appendix 3.
If you’re already experienced with ERPLAB, you can just skim through this chapter. But if you don’t have much ERPLAB
experience, you’ll want to download the data and do each data processing exercise. Remember, you’ll probably run into some error
messages or other technical snags, but don’t get discouraged. An important implicit goal of this book is for you to learn how to
troubleshoot technical problems. See the troubleshooting tips in Appendix 2 if you have problems.
2.1: Data For This Chapter
2.2: Design of the N400 Experiment
2.3: Exercise - Looking at the EEG and the Event Codes
2.4: Exercise- Filtering Out Low-Frequency Drifts from the EEG
2.5: Exercise- Creating an EventList
2.6: Exercise- Assigning Events to Bins with BINLISTER
2.7: Exercise- Epoching and Baseline Correction
2.8: Exercise- Artifact Detection
2.9: Exercise- Averaged ERPs
2.10: Exercise- Data Quality
2.11: Review of Processing Steps
2.12: A Simple Matlab Script
2.13: Key Takeaways and References
1

<!-- source_pdf=Full.pdf pdf_page=35 source_page_label="2" source_url="" -->

## PDF page 35

- Source page label: 2
- LibreTexts source: not printed on page

This page titled 2: Processing the Data from One Participant in the ERP CORE N400 Experiment is shared under a CC BY 4.0 license and was
authored, remixed, and/or curated by Steven J Luck directly on the LibreTexts platform.
2

<!-- source_pdf=Full.pdf pdf_page=36 source_page_label="2.1.1" source_url="https://socialsci.libretexts.org/@go/page/87932" -->

## PDF page 36

- Source page label: 2.1.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87932

2.1: Data For This Chapter
This chapter, like every subsequent chapter in this book, is filled with exercises. Processing real data is the best way to learn ERP
data analysis! Your first step in each chapter will therefore be to download the data for the exercises in that chapter.
The N400 data we’ll be using for the exercises in this chapter can be found in the Chapter_2 folder in the master folder:
https://doi.org/10.18115/D50056. In this chapter, we’ll be looking at the data from only one of the 40 participants (Subject #6). Go
ahead and download this folder and all its contents (and make sure to name the folder Chapter_2).
I recommend organizing the data for the various chapters of the book on your computer just as they're organized online, with a
separate folder for each chapter.
This page titled 2.1: Data For This Chapter is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck
directly on the LibreTexts platform.
2.1.1 https://socialsci.libretexts.org/@go/page/87932

<!-- source_pdf=Full.pdf pdf_page=37 source_page_label="2.2.1" source_url="https://socialsci.libretexts.org/@go/page/87933" -->

## PDF page 37

- Source page label: 2.2.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87933

2.2: Design of the N400 Experiment
Before we look at the data, let’s consider the design of the ERP CORE N400 experiment. As illustrated in Figure 2.1.A, the
experiment involved a sequence of trials, each of which consisted of a prime word followed by a target word. The participants’ task
was to press one of two buttons on each trial to indicate whether the target was semantically related or semantically unrelated to the
preceding prime word. For example, they would press the related button for CHAIR preceded by TABLE and the unrelated button
for SPIDER preceded by RAKE. Additional methodological details can be found in Kappenman et al. (2021).
Hundreds of previous studies have shown that a word will elicit a larger N400 component if it is unrelated to a previously
established semantic context than if it is related to that context (Kutas, 1997; Swaab et al., 2012), so we expected to see a larger
N400 on unrelated trials than on related trials. Figure 2.1.B shows the ERP waveforms, recorded at the CPz electrode site (where
the N400 is typically largest) and averaged over all 40 of the original participants (a grand average). In these waveforms, the N400
is a negative-going wave for the unrelated targets that is present from approximately 200-600 ms and is added onto the positive
voltage that is ordinarily present during this time period.
Figure 2.1. Experimental paradigm and results from the ERP CORE N400 experiment. (A) On each trial, subjects saw a prime
word drawn in red and a target word drawn in green. The task was to press one of two buttons following each target word to
indicate whether the target was semantically related or semantically unrelated to the preceding prime word. (B) ERP waveforms
elicited by the target words, averaged over all 40 participants in the original study. (C) Difference wave created by subtracting the
waveform on the related trials from the waveform on the unrelated trials.
It is often useful to subtract away everything that is in common to two conditions and focus on the difference in brain activity
between conditions. To do this, we compute a difference wave, which is simply the difference in voltage between the two
conditions at each time point. Figure 2.1.C shows the unrelated-minus-related difference wave for our N400 experiment. It allows
us to see the brain’s differential processing of unrelated versus related words. Because the difference deviates from zero at
approximately 200 ms, we can conclude that the brain has determined whether the target is related or unrelated to the prime by this
time.
This page titled 2.2: Design of the N400 Experiment is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
2.2.1 https://socialsci.libretexts.org/@go/page/87933

<!-- source_pdf=Full.pdf pdf_page=38 source_page_label="2.3.1" source_url="https://socialsci.libretexts.org/@go/page/87934" -->

## PDF page 38

- Source page label: 2.3.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87934

2.3: Exercise - Looking at the EEG and the Event Codes
In our first exercise in this chapter, we’ll take a look at the EEG and the event codes for one participant (Participant #6). You should
always scan through a participant’s EEG and event codes before starting to process the data. Many things can go wrong during an
EEG recording, and you want to make sure that there aren’t any problems that you need to address before you go further. I provide
a detailed example of how to visually inspect a participant's EEG in the chapter on artifact rejection (Chapter 7).
Remember, event codes are stored in the EEG file during data collection and indicate what event happened (e.g., which particular
stimulus or response) and the time of occurrence (see Figure A1.1 in Appendix 1). In the system we used for collecting the ERP
CORE data, event codes were integers between 1 and 255 (see the box below for more information about event codes). Table 1 lists
the event codes for the N400 experiment. An event code was produced for each prime word and each target word, and different
codes were used depending on whether the target was semantically related or unrelated to the prime on that trial. Note that we used
two different lists of words (for counterbalancing purposes), and that was also indicated by the event codes. Each subject saw a
total of 120 trials, 60 on which the target word was related to the prime word and 60 in which they were unrelated. Thus, there were
30 occurrences of each stimulus event code (30 related and 30 unrelated for each of the two lists).
Table 2.1. Event codes for the ERP CORE N400 experiment.
Word Type Relatedness Word List Event Code Occurrences
Stimuli Prime Related List 1 111 30
Prime Related List 2 112 30
Prime Unrelated List 1 121 30
Prime Unrelated List 2 122 30
Target Related List 1 211 30
Target Related List 2 212 30
Target Unrelated List 1 221 30
Target Unrelated List 2 222 30
Responses Correct 201 Variable
Incorrect 202 Variable
Event Codes
In most EEG systems, one computer is used for presenting stimuli, and a different computer is used for recording the EEG. In
addition, the experimenter often uses general-purpose stimulus presentation software that is not made by the manufacturer of
the EEG recording system. To ensure compatibility, the method typically used to pass event codes from the stimulus
presentation computer to the EEG recording computer is based on a communications protocol that has been around since 1970
(the Centronics-style parallel port). The protocol requires that the event codes be whole numbers between 1 and 255. That’s
plenty for some experiments, but it’s woefully inadequate for others. In our N400 experiment, for example, it would have been
nice for each event code to indicate the actual word that was presented. The ERP CORE online resource therefore provides text
files (in CSV format) with the actual words used for each participant.
Some EEG systems come with stimulus presentation software, and they use custom protocols to allow for richer event codes
(which might be text instead of 8-bit integers). However, this is not a very general solution.
There is now a movement to use a newer standardized protocol called Lab Streaming Layer. This will make it possible to use
an Ethernet cable instead of a parallel port and send much richer event codes, while still providing a standardized protocol that
2.3.1 https://socialsci.libretexts.org/@go/page/87934

<!-- source_pdf=Full.pdf pdf_page=39 source_page_label="2.3.2" source_url="https://socialsci.libretexts.org/@go/page/87934" -->

## PDF page 39

- Source page label: 2.3.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87934

any software package can implement. I’m looking forward to the day when both my EEG recording system and our various
stimulus presentation programs can use this newer protocol.
In the exercises for this chapter, we’re going to look at the data from Subject 6, who has particularly nice data.
If Matlab isn’t already running, launch it now and start EEGLAB (by typing eeglab in the Matlab command window). In Matlab,
set the current folder to be the Chapter_2 folder. On the left side of the Matlab window, you should see the contents of this folder,
including a file named 6_N400_preprocessed.set. That file contains the EEG from Subject 6. A few minor preprocessing steps
have already been conducted to make the exercises in this chapter a little easier.
In the EEGLAB GUI, select File > Load existing dataset and select the file 6_N400_preprocessed.set (be careful that you don’t
accidentally select Load existing study instead). Then select Plot > Channel data (scroll). You should see a plot that looks like
Screenshot 2. 1. You can see the EEG waveforms for only a few of the channels. This is because the voltages are out of the range of
the plotting display for most of the channels, which is a result a DC voltage offset that arises mainly from the skin (see Chapter 5 in
Luck, 2014). That is, the voltage recorded in our EEG electrodes is the sum of the EEG plus any voltage offset, and the voltage
offsets are often so large that they make the signal go beyond the range of values shown in the plot. You didn’t experience this
when you did the exercises in Chapter 1 because the low frequencies had already been filtered out in the data in used in those
exercises, which minimizes the DC offset.
Screenshot 1.1
To see all of the channels, you can tell the plotting window to subtract the DC offset (i.e., to subtract the mean voltage across time
points from the voltage at each time point, separately for each channel). In the EEG plotting window, select Display > Remove DC
offset, and then you’ll see all the channels, as shown in Screenshot 2.2.
2.3.2 https://socialsci.libretexts.org/@go/page/87934

<!-- source_pdf=Full.pdf pdf_page=40 source_page_label="2.3.3" source_url="https://socialsci.libretexts.org/@go/page/87934" -->

## PDF page 40

- Source page label: 2.3.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87934

Screenshot 2.2
Someday, when you’re loading your own EEG data into EEGLAB, you might see a completely blank screen when you try to plot
the EEG. I’m hoping that you’ll remember that this means you need to remove the DC offset.
Now let’s look at the event codes in the EEG plot. Do you see the two vertical lines with a label of 202 at the top of each line?
Those are event codes. If you look at Table 2.1, you’ll see that event code 202 corresponds to an incorrect behavioral response. In
this task, there are some instruction screens at the beginning, and the participants are required to press a response button to go to
the next screen. Those responses generated an event code 202.
Pro tip: Starting the recording several seconds before the first trial
You might expect that the EEG recording would begin only moments before the first trial. Why waste disk space with all that
extra EEG? However, there is a technical reason why you should start the recording several seconds before the first trial.
Specifically, this can help you avoid artifacts that filters can produce at the beginning and end of the waveform. If you have
some “extra” EEG at the beginning and end of the recording, the filter artifacts occur during these time periods that you don’t
care about rather than distorting the data during the first and last trials of the recording. See Chapter 7 in Luck (2014) for a
more detailed explanation.
Click the >> button near the bottom of the plotting window to scroll forward 5 seconds in time. You should now see an event code
121 at approximately 6.6 seconds, an event code 221 at approximately 7.7 seconds, and event code 201 at approximately 8.3
seconds (see Screenshot 2.3). Look up these event codes in Table 2.1. What happened at these three time points?
Event code 121 was a prime word that began approximately 6.6 after the start of the recording. Event code 221 was a target word
that was unrelated to the prime word, and it began approximately 1.1 seconds after the prime word. Event code 201 was a correct
response, and it occurred approximately 0.6 seconds after the target word. So, this was the first trial in the experiment, and the
subject correctly determined that the target was unrelated to the prime with a response time of approximately 600 ms. You can get
approximate timing information like this by hovering the mouse over the plotting window. The time corresponding to the location
of the mouse pointer is shown at the bottom of the plotting window. Later, we’ll discuss how you can determine these times more
precisely.
2.3.3 https://socialsci.libretexts.org/@go/page/87934

<!-- source_pdf=Full.pdf pdf_page=41 source_page_label="2.3.4" source_url="https://socialsci.libretexts.org/@go/page/87934" -->

## PDF page 41

- Source page label: 2.3.4
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87934

Screenshot 2.3
If you look near the right edge of the plotting window, you’ll see the event code for the prime word on the second trial. You can
click the > button 4 times to scroll over 4 seconds, and then you’ll be able to see the event codes for the prime, the target, and the
response on this second trial. Here are some questions you should try to answer:
Given the experimental design shown in Figure 2.1, what is the shortest amount of time you should ever see between the prime
word and the target word? What is the longest time?
Similarly, what are the longest and shortest times between the target word on one trial and the prime word on the next trial?
What was the response time for the second trial (approximately)?
If possible, keep the EEG plotting window open for the next exercise.
This page titled 2.3: Exercise - Looking at the EEG and the Event Codes is shared under a CC BY 4.0 license and was authored, remixed, and/or
curated by Steven J Luck directly on the LibreTexts platform.
2.3.4 https://socialsci.libretexts.org/@go/page/87934

<!-- source_pdf=Full.pdf pdf_page=42 source_page_label="2.4.1" source_url="https://socialsci.libretexts.org/@go/page/87935" -->

## PDF page 42

- Source page label: 2.4.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87935

2.4: Exercise- Filtering Out Low-Frequency Drifts from the EEG
The skin is an electrical organ, and it produces slow drifts in voltage that are picked up by our EEG electrodes. These skin
potentials can cause the voltage to gradually change by hundreds of microvolts over a period of a few minutes. To get a better look
at the skin potentials, go to the EEG plotting window that you opened in the previous exercise (or open the window again), and
change the settings as follows:
Go to time zero by putting a zero in the text box between the < and > buttons in the plot window.
Set the vertical gain to 100 (using the little text box near the bottom of the plot window).
Set the time range to 400 seconds using Settings > Time range to display in the plot window.
Stretch the window as wide as you can so that it looks something like the top window in Screenshot 2.4.
Screenshot 2.4
Looks pretty weird, doesn’t it? The first thing you should look at is the event codes (the vertical lines). The N400 experiment lasted
about 6 minutes, and you’re looking at the entire recording, so there are lots of event codes. Notice that there are 6 clusters of event
codes, separated by gaps of approximately 7 seconds. The 120 trials in this experiment were divided into 6 blocks of 20 trials each,
with a short rest break after each block. I find that participants can maintain their attention better if we use a large number of short
blocks, each followed by a brief break, so this experiment was broken up into short blocks that lasted only about a minute each.
Now take a look at the EEG waveforms. You can now see that the voltage is gradually drifting over time. It drifts upward in some
channels and downward in others. Most of the channels change by well over 100 µV over the course of this 400-second period.
These drifts are mainly caused by electrical potentials in the skin that are picked up by the EEG electrodes (see Chapter 5 in Luck,
2014 for more details).
These drifts can make it difficult to obtain reliable ERP differences across conditions, and it’s usually a good idea to filter them out.
To accomplish this, we apply a high-pass filter, which filters out low frequencies and passes high frequencies. Here, we’ll use the
filter settings that I recommend for most studies of cognitive and affective processes, which has a half-amplitude cutoff at 0.1 Hz
and a slope of 12 dB/octave. If you don’t know what these parameters mean, don’t worry – we’ll cover them in Chapter 4. You can
2.4.1 https://socialsci.libretexts.org/@go/page/87935

<!-- source_pdf=Full.pdf pdf_page=43 source_page_label="2.4.2" source_url="https://socialsci.libretexts.org/@go/page/87935" -->

## PDF page 43

- Source page label: 2.4.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87935

also find a broad conceptual overview of filters in Chapter 7 of Luck (2014) and a more detailed mathematical treatment in Chapter
12 of Luck (2014).
Now let’s get rid of these drifts with a high-pass filter. Leave the current plotting window open, and go to EEGLAB > ERPLAB >
Filter & Frequency Tools > Filters for EEG data. You’ll see ERPLAB’s filtering GUI, which is big and complicated (because
filters have a lot of different options). We’ll explain these options in a later chapter, but for this exercise you should just make sure
that everything is set to match Screenshot 2.5. Most importantly, make sure the High-Pass button is selected with a half-amplitude
cutoff of 0.1 Hz, and the Low-Pass button is not selected (these button are a slightly darker gray when selected).
 Getting an Error Message?
Did you get an error message when you launched the filtering tool? If so, the message probably said that you're missing the
Signal Processing Toolbox. This toolbox comes from the makers of Matlab and is required for certain ERPLAB processes,
such as filtering. Depending on your institution's Matlab license, it may be free or it may require an extra fee.
You can see what toolboxes are installed by typing ver on the Matlab command line. If you don't have the Signal Processing
Toolbox and you don't know how to get it and/or install it, contact your institution's IT support department for assistance.
Screenshot 2.5
Saving the New Dataset
Once all the parameters are set, click the APPLY button. You’ll then see the window shown in Screenshot 2.6, which asks What
do you want to do with the new dataset? In EEGLAB and ERPLAB, most operations that modify a dataset will actually create a
new dataset. That way, if you make a mistake or change your mind, you can easily go back to the previous dataset. These datasets
are stored in memory, where they’re listed in the Datasets menu, and you can also save them to your hard drive if you want. The
top text box in Screenshot 2.6 allows you to specify the name of the dataset (which will be the name shown in the Datasets menu).
2.4.2 https://socialsci.libretexts.org/@go/page/87935

<!-- source_pdf=Full.pdf pdf_page=44 source_page_label="2.4.3" source_url="https://socialsci.libretexts.org/@go/page/87935" -->

## PDF page 44

- Source page label: 2.4.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87935

You can use any name you like, but ERPLAB will give you a suggestion (which is the name of the original dataset with a suffix
that indicates the nature of the processing step, such as _filt for filtering).
If you want to save the dataset as a file on your hard drive, check the box next to Save it as a file and type in the name that will be
used for this file. The name of the dataset in memory doesn’t have to be the same as the filename, but it can be confusing if the
name in memory is different from the filename. I usually just select the name of the dataset from the top text box, copy it into the
clipboard, and the paste it into the second text box. Note that if you don’t save the dataset as a file now, you can save it later with
EEGLAB > File > Save current dataset as. You’ll need the new filtered dataset for the next exercise, so you should save it as a
file if you’re not going to do the next exercise right away.
Once you have everything set in this window, click OK. You’ve now created a new dataset with the filtered data. The previous
dataset was named 6_N400_preprocessed, and the new one should be named 6_N400_preprocessed_filt. If you look in the
Datasets menu in the main EEGLAB GUI, you should see both of these datasets listed, with the new one checked.
Screenshot 2.6
Looking at the Filtered Data
Now that you’ve saved the dataset, plot the filtered data with EEGLAB > Plot > channel data (scroll). Set it up like the plotting
window that shows the unfiltered data (remove the DC offset, set the vertical gain to 100, set the time range to 400 second, and
stretch the window to the same width). It should look something like the bottom window in Screenshot 2.4. The slow drifts are now
gone, and the data look much more orderly. We’ve now gotten rid of a major source of artifactual activity from the EEG, which
improve our ability to obtain robust, reliable ERP effects.
Now change the time period to display to be 10 seconds instead of 400 seconds for both the unfiltered and filtered data. Because
you’re still removing the DC offset and the drifts are slow, the filtered and unfiltered data don’t look as radically different with this
10-second time scale as they did with the 400-second time scale. But if you look carefully (especially at the PO3 channel), you’ll
see that there is some drift in the unfiltered data that is absent in the filtered data. You can also see that all the faster deflections in
the data are present in both the filtered and unfiltered waveforms. So, the high-pass filter has largely eliminated the slow drifts but
has had minimal effect on the other features of the EEG. We’ll take a closer look at filters in Chapter 4.
You’ll need the filtered dataset for the next exercise. If you’re going to do the next exercise right away, just leave EEGLAB open
(but you can close the two plotting windows). If you’re not going to do it right away, you can save the filtered dataset as a file on
your hard drive by selecting EEGLAB > File > Save current dataset as.
This page titled 2.4: Exercise- Filtering Out Low-Frequency Drifts from the EEG is shared under a CC BY 4.0 license and was authored, remixed,
and/or curated by Steven J Luck directly on the LibreTexts platform.
2.4.3 https://socialsci.libretexts.org/@go/page/87935

<!-- source_pdf=Full.pdf pdf_page=45 source_page_label="2.5.1" source_url="https://socialsci.libretexts.org/@go/page/87936" -->

## PDF page 45

- Source page label: 2.5.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87936

2.5: Exercise- Creating an EventList
Our next step is to add something called an EventList to the EEG dataset. An EventList is a simple, easy-to-access list of all the
event codes in a dataset. EEGLAB stores event codes in a Matlab data structure that’s a little bit difficult for beginners to access, so
we added the EventList structure when we created ERPLAB. After all, event is in the name of the ERP technique, so we wanted to
make it easy to see and manipulate the event codes.
If you don’t still have the filtered dataset from the previous exercise loaded in EEGLAB, go ahead and load it now
(6_N400_preprocessed_filt).
In the EEGLAB GUI, select ERPLAB > EventList > Create EEG EVENTLIST. In the GUI that appears, check the box labeled
Export EventList to text file and enter events in the text box to indicate the filename. When the EventList is created, it’s attached
to the EEG dataset, and the Export EventList to text file option also saves it as a text file so that you can easily see the event
codes.
Make sure that the rest of the GUI matches the settings shown in Screenshot 2.7 and then click the CREATE button.
Screenshot 2.7
You’ll then see a new window that asks What do you want to do with the new dataset? Just accept the default settings by
clicking OK. You’ve now created a new copy of the dataset that has the EventList attached. The starting dataset was named
6_N400_preprocessed_filt, and the new one should be named 6_N400_preprocessed_filt_elist. You can see the loaded datasets in
the Datasets menu. You will need the new dataset for the next exercise, so make sure you keep EEGLAB open or save the dataset
to your hard drive (using EEGLAB > File > Save current dataset as).
It’s a little tricky to look at the EventList directly, but we can look at the copy you saved as a text file, which should be named
events.txt. You should be able to see this file listed in the Current folder section of the main Matlab GUI (see the lower left corner
of Screenshot 2.8).
2.5.1 https://socialsci.libretexts.org/@go/page/87936

<!-- source_pdf=Full.pdf pdf_page=46 source_page_label="2.5.2" source_url="https://socialsci.libretexts.org/@go/page/87936" -->

## PDF page 46

- Source page label: 2.5.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87936

Screenshot 2.8
You can look at this file in virtually any text editor, but the easiest thing to do is to use Matlab’s built-in text editor. You can just
double-click the filename in the Current folder box to open the file. It should look something like Screenshot 2.9.
Screenshot 2.9
At the top of the file, you’ll see a bunch of general information about the EEG recording, such as the number of channels and the
sampling rate. Then you’ll see a list of the event codes, with one per line. Each line contains several columns, many of which we
will discuss later. For now, the key columns are item (which indicates the ordering of the event codes), ecode (which is the actual
event code), onset (which is the time of the event code relative to the beginning of the recording), and diff (which is the amount of
time between the current event code and the previous event code, in milliseconds rather than seconds). In principle, event codes can
have a duration (listed in the dura column), but this feature is not used by ERPLAB and event codes are typically considered to be
instantaneous (i.e., a duration of 0).
2.5.2 https://socialsci.libretexts.org/@go/page/87936

<!-- source_pdf=Full.pdf pdf_page=47 source_page_label="2.5.3" source_url="https://socialsci.libretexts.org/@go/page/87936" -->

## PDF page 47

- Source page label: 2.5.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87936

If you look at the diff column, you can now see exactly how much time elapsed between the onset of each target word and the
preceding prime word, and you can see the response times. For example, the behavioral response on the first trial (item #5, event
code 201) was 563.48 ms after the preceding target word.
You can actually modify the text file and import it back into EEGLAB/ERPLAB to modify the event codes in an EEG dataset
(using ERPLAB > EventList > Import EEG EVENTLIST from text file). For example, imagine that the subject was confused
about the task between event codes 120 and 160. You could set the enable column to 0 for these events, which would cause them to
be ignored by all ERPLAB processes. Similarly, if you used an eye tracker during the experiment, you could add event codes
corresponding to fixations. If you know how to program in Matlab, you can directly modify the EVENTLIST structure rather than
modifying the text file and importing it.
Our last step will be to verify that we have the current number of occurrences of each event code. As shown in Table 2.1, there
should have been 30 occurrences of each of stimulus event codes. The number of occurrences of each response event code varies
across subjects depending on the number of errors. However, there were 120 trials, so there should be 120 total response event
codes (plus the two at the beginning during the instruction phase).
To see the number of occurrences, select EEGLAB > ERPLAB > EventList > Summarize current EEG event codes. It will plot
a table in the Matlab command window. Do we have the correct number of occurrences of each event code type? On what
proportion of trials did this participant make a correct response?
Pro tip: Checking the number of event codes for every participant
In my experience, the most common error in ERP experiments is that there is some kind of problem with the event codes. If
you are designing and running your own experiments, perhaps the single most important thing you can do to avoid trouble later
is to make sure that your event codes are correct. A given experiment might have 1000+ event codes, so it is difficult to check
every single one. However, if you set up your experiment properly, you can at least make sure that you have the right number
of occurrences of each event code (for the stimuli).
The first step is to know exactly how many occurrences there should be for each code. And I do mean “exactly” rather than
“approximately.” You can have major problems with your event codes and end up with approximately the right number. Then
you can simply run your stimulus presentation program while recording the EEG but without a participant. You will then
import your data into EEGLAB, add the EventList, and check the number of occurrences of each event code using EEGLAB >
ERPLAB > EventList > Summarize current EEG event codes. You should also “spot check” a few dozen randomly
selected event codes to make sure that they are correct with respect to the stimulus that was actually presented.
You should also check the number of occurrences of each event code for every participant you run (immediately after the
recording session). Lots of things can go wrong with event codes, and this will allow you to catch a problem before you’ve
wasted weeks of time collecting data that turn out to be useless. Checking the number of each event code is easy, and you
absolutely must do it to avoid problems.
This page titled 2.5: Exercise- Creating an EventList is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
2.5.3 https://socialsci.libretexts.org/@go/page/87936

<!-- source_pdf=Full.pdf pdf_page=48 source_page_label="2.6.1" source_url="https://socialsci.libretexts.org/@go/page/87937" -->

## PDF page 48

- Source page label: 2.6.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87937

2.6: Exercise- Assigning Events to Bins with BINLISTER
What is a Bin?
When we create averaged ERPs, we often want to combine trials with different event codes into the same average. For example, the
N400 experiment used separate event codes to indicate which of the two word lists was used for a given trial, but we don’t really
need to make this distinction in our data analysis, so we’ll just average together the trials with the different word lists. Also, we
won’t be making averages for the response event codes, but we want to use those codes so that we exclude trials with incorrect
responses from our averages. Thus, we need a sophisticated way of indicating which events should be combined together when we
make our averages.
We call this process assigning events to bins, and ERPLAB accomplishes this with a routine called BINLISTER. A bin is a set of
averaged ERP waveforms—one for each electrode site—that were created by averaging together a specific set of trials. In our
N400 experiment, for example, we will create four bins:
1. Primes followed by a related target
2. Primes followed by an unrelated target
3. Targets preceded by a related prime and followed by a correct response
4. Targets preceded by an unrelated prime and followed by a correct response
We recorded from 30 channels, so each bin will have 30 averaged ERP waveforms, one for each channel. For all 30 channels in a
given bin, we averaged together the same set of trials. Together with some header information, the bins for a given participant are
stored together in an ERPset. Figure 2.2 shows how the ERPset will be structured for the average we will be creating in this
chapter.
Figure 2.2. Structure of the ERPset that we will create in these exercises.
Running BINLISTER
Now that you see how everything fits together, let’s actually use BINLISTER to assign the event codes to bins for our example
subject. We’ll start with the dataset that you created in the previous exercise that has the EventList attached
(6_N400_preprocessed_filt_elist). If you still have it loaded, make sure that it is active (checked) in the Datasets menu (Dataset
1:6_N400_preprocessed_elist). If you don’t still have it loaded but you saved it as a file, open the file (using EEGLAB > File >
Load existing dataset).
2.6.1 https://socialsci.libretexts.org/@go/page/87937

<!-- source_pdf=Full.pdf pdf_page=49 source_page_label="2.6.2" source_url="https://socialsci.libretexts.org/@go/page/87937" -->

## PDF page 49

- Source page label: 2.6.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87937

Go to EEGLAB > ERPLAB > Assign bins (BINLISTER), which will pop up a GUI window. In the text box at the top (under
Load Bin Descriptor File from), you will enter BDF_N400.txt, which is a text file that tells BINLISTER how to assign events to
bins for this particular experiment. We’ll take a look at this file later.
BINLISTER adds new information to the EventList, and we want to save a copy of the updated EventList as a text file for this
exercise so that we can easily look at it. To accomplish this, check the box next to Text File in the section of the GUI labeled Write
resulting EVENTLIST to (not in the section labeled Read EVENTLIST from). Then type events2.txt in the text box to the right
(see Screenshot 2.10). This will be the name of the text file that will be used to store a copy of the updated EventList. Make sure
that everything else is set up like the screenshot and then click RUN.
Screenshot 2.10
As in the previous exercises, you’ll see a new window that asks What do you want to do with the new dataset? Just accept the
default settings by clicking OK. You’ve now created a new copy of the dataset with the updated EventList attached. The new
dataset should be named 6_N400_preprocessed_filt_elist_bins. You will need the new dataset for the next exercise, so save the
dataset to your hard drive if you’re not going to do the next exercise right away.
Looking at the Bin Assignments in the EventList
Now open the text file that contains a copy of the updated EventList, which should be named events2.txt. You can just double-click
it in the Current Folder panel of the main Matlab GUI to open it in the Matlab text editor. It should look something like Screenshot
2.11.
2.6.2 https://socialsci.libretexts.org/@go/page/87937

<!-- source_pdf=Full.pdf pdf_page=50 source_page_label="2.6.3" source_url="https://socialsci.libretexts.org/@go/page/87937" -->

## PDF page 50

- Source page label: 2.6.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87937

Screenshot 2.11
If you compare it with the original version of the EventList (in events.txt), you’ll see two main differences. First, the new version
has a list of the four bins that we’ve created, which includes the number of trials and the label for each bin. For example, you can
see that there were 60 instances of Bin 1, which was labeled “Prime word, related to subsequent target word”. The second change is
that there are now numbers in the bin column for the individual events (at the far right of the window). These numbers indicate
which bin (if any) a given event code has been assigned to. When an event is assigned to a bin, this means that the event is the
time-locking event for that trial. In other words, the time of the event code will be time zero in our averaged ERP waveforms.
Consider, for example, item #3 on line 33. It has an event code of 121, which means that it is a prime word that will be followed by
an unrelated target word, with the word taken from the first word list (see Table 2.1). It was assigned to Bin 2 (see the far right
column in events2.txt). When we make an averaged ERP waveform for Bin 2, we’ll use this event code as time zero in the
waveform. Now look at item #4 on the next line. It has an event code of 221, and it’s the target word that followed the prime word
from item #3. It was assigned to Bin 4. The response event codes (e.g., items 1, 2, and 5) were not assigned to a bin because we are
not making any averaged ERP waveforms in which the response is at time zero in this experiment.
How BINLISTER Works
How did BINLISTER know what bins we wanted and which event codes should be assigned to each bin? To accomplish this,
BINLISTER used a set of abstract bin descriptions that are stored in the BDF_N400.txt file that you entered at the top of the
BINLISTER GUI (see Screenshot 2.10). The BDF in the filename stands for bin descriptor file, because it contains abstract
descriptors for each bin. Here’s what is in that file:
Bin 1
Prime word, related to subsequent target word
.{111;112}
Bin 2
Prime word, unrelated to subsequent target word
.{121;122}
2.6.3 https://socialsci.libretexts.org/@go/page/87937

<!-- source_pdf=Full.pdf pdf_page=51 source_page_label="2.6.4" source_url="https://socialsci.libretexts.org/@go/page/87937" -->

## PDF page 51

- Source page label: 2.6.4
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87937

Bin 3
Target word, related to previous prime, followed by correct response
.{211;212}{t<200-1500>201}
Bin 4
Target word, unrelated to previous prime, followed by correct response
.{221;222}{t<200-1500>201}
The details of the bin descriptor file syntax will be described in a later section, but some aspects of the syntax are fairly obvious
here. Each bin is described with three lines. The first line just gives the bin number. The second number is a text string that
describes the contents of the bin (and can be whatever you want). The third line is the actual bin descriptor. Each bin descriptor
contains one or more event codes inside some curly brackets. For example, Bin 2 contains 121;122 inside the curly brackets,
indicating that event codes 121 or 122 should be used as the time-locking event for this bin. Bins 3 and 4 contain a second set of
curly brackets that indicate what must follow the time-locking event code. The text t<200-1500>201 means that the time-locking
event code must be followed by an event code 201 with a delay of 200-1500 ms. For example, an event code of 221 will be
assigned to Bin 4 if and only if it is followed by a correct response (event code 201) within 200 to 1500 ms. Responses that are
faster than 200 ms are probably bogus (because no one can respond that quickly), and responses that are later than 1500 ms
probably indicate that the subject was zoning out.
BINLISTER reads in the bin descriptor file and then goes through all of the event codes in the EventList. When it finds an event
code that matches the bin descriptor for a given bin, it puts that bin number into the bin column for that event code. Note that a
given event code can be assigned to more than one bin. For example, we could have one bin for target words that are followed by a
correct response and a separate bin for target words irrespective of whether the response was correct.
Now that we’ve discussed how the four bins were defined in this experiment, you should go through several events in the
events2.txt file and make sure that you understand why each event was assigned to a given bin. In particular, you should find the
target words that were followed by incorrect responses (event code 202) and verify that they were not assigned to a bin.
This page titled 2.6: Exercise- Assigning Events to Bins with BINLISTER is shared under a CC BY 4.0 license and was authored, remixed, and/or
curated by Steven J Luck directly on the LibreTexts platform.
2.6.4 https://socialsci.libretexts.org/@go/page/87937

<!-- source_pdf=Full.pdf pdf_page=52 source_page_label="2.7.1" source_url="https://socialsci.libretexts.org/@go/page/108224" -->

## PDF page 52

- Source page label: 2.7.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108224

2.7: Exercise- Epoching and Baseline Correction
The next step in processing Subject 6’s data is quite simple, and it involves two operations that are done together in a single step.
One of these operations is extracting a fixed-length epoch for each event that has been assigned to a bin. If you’re not quite sure
what this means, see Figure A1.3 in Appendix 1). As shown in Figure 2.1, we will be looking at the data from 200 ms prior to
stimulus onset through 800 ms after stimulus onset. Consequently, for each trial we need to extract an epoch that starts 200 ms
before the time-locking event code and extends until 800 ms after the event code.
The second operation will be baseline correction, which is a way of dealing with the DC voltage offsets. As shown in Figure 2.3,
we use the average voltage during the prestimulus period as an estimate of the offset, and we shift the whole waveform upward or
downward by this amount. Ordinarily, this is done on epoched EEG data, but ERPLAB also allows you to perform correction on
averaged ERP waveforms as well.
Figure 2.3. Baseline correction procedure. The mean voltage during the prestimulus period (from -200 to 0 ms in this example) is
used as an estimate of the voltage offset. This value is simply subtracted from each point in the waveform to create the corrected
waveform.
To perform these steps on our example data, make sure that the dataset created during the previous exercise
(6_N400_preprocessed_filt_elist_bins) is loaded in EEGLAB. Then select EEGLAB > ERPLAB > Extract bin-based epochs.
In the window that pops up, enter -200 800 as the time range and select Pre for baseline correction (as in Screenshot 2.12). The
time window values tell the routine that you want the epochs to start 200 ms before stimulus onset and extend for 800 ms after
stimulus onset, for a total epoch length of 1000 ms. The baseline correction parameter tells the routine that you want to use the
entire prestimulus interval (-200 to 0 ms) as the baseline period. Once you’ve set these parameters, click RUN. As usual, accept the
default settings when asked What do you want to do with the new dataset? The new dataset should be named
6_N400_preprocessed_filt_elist_bins_be. Save it to your hard drive if you’re not going to do the next exercise right away.
Screenshot 2.12
Looking at the Epoched Dataset
Now let’s see what happened when you ran this routine by selecting EEGLAB > Plot > Channel data (scroll). You should set the
vertical scale to 100 in the plotting window, but you don’t need to remove the DC offset (because it was removed by the baseline
correction procedure). The result should look like the plot in Figure 2.4. By default, the EEG plotting window shows 5 individual
2.7.1 https://socialsci.libretexts.org/@go/page/108224

<!-- source_pdf=Full.pdf pdf_page=53 source_page_label="2.7.2" source_url="https://socialsci.libretexts.org/@go/page/108224" -->

## PDF page 53

- Source page label: 2.7.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108224

epochs, but it looks a lot like one continuous EEG waveform for each channel until you look closely. There is a dashed vertical line
between each epochs, 200 ms before the event codes that were used for time locking (because we specified a 200-ms prestimulus
period when we epoched the data).
Figure 2.4. Plot of epoched EEG data. It looks like continuous data, but the dashed horizontal lines indicate boundaries between
epochs.
For example, look at the event code labeled B4(221), which corresponds to item #4 in the EventList (line 34) shown in
Screenshot.2.10. This event code corresponds to a target word, and it was assigned to Bin 4 when you ran BINLISTER. The event
code label now contains both the bin number (B4) and the original event code (221). If you look at the labels on the X axis, you’ll
see that this event is at time zero, because it’s the time-locking event for this epoch. When we create our averaged ERPs, all the
epochs labeled B1 will be averaged together to form Bin 1 (whether the actual event code was 111 or 112), all the epochs labeled
B2 will be averaged together to form Bin 2 (whether the actual event code was 121 or 122), etc.
The next event code is labeled 201. This was the response to the target word. We’re not using it as the time-locking point for any
bins, so it does not have a bin number. However, the information about the event is still present, so you can see the event code in
the EEG plotting window.
Scroll through the epochs using the >> button at the bottom of the plotting window. Notice that there is usually a response event
code following the target words (Bins 3 and 4) but not following the prime words (Bins 1 and 2). Sometimes the response event
code is missing; this happens when the response was later than 800 ms and therefore fell outside of the time window of the epochs.
You might find it useful to open the events2.txt file and compare the contents of that file to what you’re seeing in the epoched EEG
data.
You’ll see a large voltage deflection in many of the epochs, which is large and positive in the Fp1 and Fp2 channels and negative in
the VEOG channel. These voltage deflections were produced by eyeblinks—this participant blinked a lot! Most of the blinks
2.7.2 https://socialsci.libretexts.org/@go/page/108224

<!-- source_pdf=Full.pdf pdf_page=54 source_page_label="2.7.3" source_url="https://socialsci.libretexts.org/@go/page/108224" -->

## PDF page 54

- Source page label: 2.7.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108224

occurred in the epochs for the prime words, not the target words. This is fortunate, because we mainly care about the ERPs elicited
by the target words in this experiment.
Don’t make this mistake!
EEGLAB also has a routine for extracting epochs from the continuous EEG (EEGLAB > Tools > Extract epochs), but do not
use it!!! The EEGLAB routine knows nothing about bins, so the epochs won’t contain the bin information that you’ll need for
the rest of the ERPLAB steps.
But what if you already have a dataset that has been epoched using the EEGLAB routine, followed by many other processing
steps that you don’t want to repeat? Or what if you’ve imported epoched data from another analysis system into EEGLAB and
you’d like to process it in ERPLAB?
Fortunately, there is a trick for solving this problem. You can convert the epoched data back into continuous data using
EEGLAB > ERPLAB > Utilities > Convert an epoched dataset into a continuous one.
This page titled 2.7: Exercise- Epoching and Baseline Correction is shared under a CC BY 4.0 license and was authored, remixed, and/or curated
by Steven J Luck directly on the LibreTexts platform.
2.7.3 https://socialsci.libretexts.org/@go/page/108224

<!-- source_pdf=Full.pdf pdf_page=55 source_page_label="2.8.1" source_url="https://socialsci.libretexts.org/@go/page/108225" -->

## PDF page 55

- Source page label: 2.8.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108225

2.8: Exercise- Artifact Detection
The eyeblink artifacts you saw in the previous exercise are huge relative to the EEG, and these artifacts can be a real problem. They
can make it difficult to see the actual brain activity, and we need a way to deal with them. In the published version of the ERP
CORE experiments, we used a method called Independent Component Analysis (ICA) to estimate and remove the artifactual
voltages, leaving behind the uncontaminated EEG. ICA is both slow and complicated, so we won’t use it in this chapter (but we’ll
cover it in detail in Chapter 9). Instead, we’ll use a cruder approach called artifact rejection. In this approach, we use a simple
algorithm to identify which epochs are contaminated by eyeblinks. We’ll then mark these epochs by setting a flag in the EventList.
Later, when we make the averaged ERPs, we’ll simply leave out the epochs in which this flag has been set.
There is a lot to know about artifacts and artifact rejection, and this topic will be covered in detail in Chapter 8. For now, we’ll take
a very simple approach in which we’ll check every epoch to see if the voltage exceeds ±100 µV in any channel. If the voltage
exceeds this range in a given epoch, we’ll flag that epoch for rejection. We call this stage of the process artifact detection rather
than artifact rejection, because we’re simply marking the epochs with artifacts so that they will be excluded when we get to the
averaging step.
For this exercise, make sure that the dataset created during the previous exercise (6_N400_preprocessed_filt_elist_bins_be) is
loaded in EEGLAB. Then select EEGLAB > ERPLAB > Artifact detection in epoched data > Simple voltage threshold. In the
window that pops up, enter -100 100 as the voltage limits, make sure that only the Flag 1 button is selected (slightly darker gray),
and make sure that the other parameters match those shown in Screenshot 2.13).
Screenshot 2.13
When you click the ACCEPT button, ERPLAB will test every epoch for artifacts, and then two windows will pop up. One is the
usual window asking what you would like to do with the new dataset. The other is the usual EEG plotting window, but now any
epoch with an artifact is highlighted with a yellow background (see Screenshot 2.14). The idea is that you’ll first use the EEG
plotting window to make sure that ERPLAB did an adequate job of detecting artifacts. Then, if everything looks fine, you’ll click
OK in the “save” window to keep the new dataset. Often, however, your visual inspection of the EEG will indicate that some
adjustments need to be made to the artifact detection parameters. For example, you might see that some blinks were missed because
they were too small. You might then reduce the voltage limits (e.g., setting them to ±90 instead of ±100 in the window shown in
Screenshot 2.13) and run the artifact detection procedure again. Chapter 8 describes this process in detail.
2.8.1 https://socialsci.libretexts.org/@go/page/108225

<!-- source_pdf=Full.pdf pdf_page=56 source_page_label="2.8.2" source_url="https://socialsci.libretexts.org/@go/page/108225" -->

## PDF page 56

- Source page label: 2.8.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108225

Screenshot 2.14
Verifying that the Epochs with Artifacts Have Been Flagged
Go ahead and take a look at the EEG in the plotting window, using a vertical scale of 100 µV as shown in Screenshot 2.14. In the
first screen of data, you can see that the second, third, and fifth epochs are marked as containing artifacts. The individual channels
that exceeded our ±100 µV limits are drawn in red, and the epochs containing an artifact in one or more channels have a yellow
background. We will exclude an entire epoch from our averages even if it contains an artifact in only one channel. The reason is
that the artifact may not be easily visible in all channels in the raw EEG, but it might still be large enough to distort our data. Also,
it would be a little weird if our averaged ERPs were based on different trials for different channels.
Now scroll through all of the data in the EEG plotting window and check to see if there are any epochs 1) that contain large
artifacts that are not marked for rejection or 2) that do not contain large artifacts and are nonetheless marked for rejection.
When I go through the data, it looks pretty good, but I did find a few epochs that contain smallish eyeblink artifacts but were not
marked for rejection (e.g., epochs 9, 154, and 201). They all contain voltage deflections in the VEOG channel that have the same
basic shape as the eyeblinks that were flagged for rejection, along with an opposite-polarity deflect in the Fp1 and Fp2 electrodes.
As will be discussed in Chapter 8, this pattern is characteristic of eyeblinks. So, the very simple approach that we’ve used to detect
eyeblinks in this exercise is pretty good but not perfect. We’ll talk about better approaches in Chapter 8.
This participant blinked a lot, more than is typical, so a lot of trials will be excluded from our averaged ERPs. This will in turn
reduce the signal-to-noise ratio of the averaged ERPs, making it more difficult to precisely quantify the N400 amplitude. To see
exactly how many trials were marked for rejection, go to the main Matlab GUI and look in the command window. You’ll see that
the artifact detection routine produced a table showing the number and percentage of accepted and rejected trials for each bin, as
well as the total across bins. (Don’t worry about the columns labeled F2, F3, etc., which will be discussed in Chapter 8). You’ll see
that 38.5% of trials were rejected across bins. Ordinarily, my lab “throws out” any participant for whom more than 25% of trials
2.8.2 https://socialsci.libretexts.org/@go/page/108225

<!-- source_pdf=Full.pdf pdf_page=57 source_page_label="2.8.3" source_url="https://socialsci.libretexts.org/@go/page/108225" -->

## PDF page 57

- Source page label: 2.8.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108225

were rejected (see Chapter 6 in Luck, 2014). However, this experiment was designed to be analyzed using artifact correction
instead of artifact rejection (see Chapter 9), so we didn’t actually need to exclude this participant. By the way, you can print this
table of values at a later time if you’d like by selecting EEGLAB > ERPLAB > Summarize artifact detection.
Now that you’ve looked through the epochs and the number of trials with artifacts, you can go to the window that asks What do
you want to do with the new dataset? and click OK to save this dataset as 6_N400_preprocessed_filt_elist_bins_be_ar. Save
the dataset to your hard drive if you’re not going to do the next exercise right away.
This page titled 2.8: Exercise- Artifact Detection is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck
directly on the LibreTexts platform.
2.8.3 https://socialsci.libretexts.org/@go/page/108225

<!-- source_pdf=Full.pdf pdf_page=58 source_page_label="2.9.1" source_url="https://socialsci.libretexts.org/@go/page/108226" -->

## PDF page 58

- Source page label: 2.9.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108226

2.9: Exercise- Averaged ERPs
We’re now finally ready to create the averaged ERPs for this participant. First make sure that the dataset from the previous exercise
is loaded (6_N400_preprocessed_filt_elist_bins_be_ar). Then select EEGLAB > ERPLAB > Compute averaged ERPs. A
window will pop up that allows you to specify a variety of options for the averaging process, which is shown in Screenshot 2.15.
Averaging Options
The first and most essential value is an index for the dataset that contains the epoched EEG to be averaged. You can see the list of
datasets that are currently loaded into EEGLAB in the Datasets menu (see the upper left portion of Screenshot 2.15). The currently
active dataset is indicated with a check mark (and is ordinarily the most recently loaded or created dataset), and by default this is
the dataset that will be used for averaging.
Screenshot 2.15
The datasets that are loaded depend on what you’ve done since launching EEGLAB. And your Datasets menu will look different
from mine, because mine has a bunch of datasets that were created as I was trying out different things while creating the exercises
in this chapter. We want to average the epoched dataset in which the epochs with artifacts have been marked
(6_N400_preprocessed_filt_elist_bins_be_ar). For me, this is Dataset 6 in the Datasets menu, but it is probably a different
dataset in your Datasets menu. In the GUI for the averaging routine, make sure that the right dataset number is listed in the text
field at the top (EEG Dataset(s) Index).
2.9.1 https://socialsci.libretexts.org/@go/page/108226

<!-- source_pdf=Full.pdf pdf_page=59 source_page_label="2.9.2" source_url="https://socialsci.libretexts.org/@go/page/108226" -->

## PDF page 59

- Source page label: 2.9.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108226

 Dealing with multiple datasets for a given participant
Imagine that you are running an EEG recording session and a fire alarm starts ringing halfway through the session. You would
need to stop recording, disconnect the participant, and head to safety. But after 5 minutes, the alarm stops and you’re allowed
back into the lab. You reconnect the participant and resume the recording, but with the data in a new file. How do you average
together the trials from the two files?
Another possibility is that you run an experiment with 10 different trial blocks, and you create a different EEG recording file
for each block. Again, you need to be able to average the data across multiple blocks.
One way to accomplish this is to combine the datasets into a single dataset with EEGLAB > Edit > Append datasets. But if
you want to keep the datasets separate (e.g., so you don’t overload your computer’s memory with huge datasets), you can
actually specify more than one dataset in the text box at the top of the averaging GUI. The datasets that you specify will be
treated like a single large dataset during the averaging process.
The next section of the averaging GUI controls how artifacts are treated during the averaging process. The default option, which
you should make sure is selected, is Exclude epochs marked during artifact detection. We also provide options for including all
of the epochs (whether or not they are marked for artifacts) or for including only the marked epochs; these options are used only
rarely.
You should also make sure that there is a check mark in the box labeled Exclude epochs that contain either “boundary” or
invalid events. A boundary is a special event code that indicates a discontinuity in the EEG. For example, imagine that the data
collection was temporarily paused 300 ms after the onset of an event because the participant asked for a short break, and then it was
restarted again a minute later. A boundary code would be inserted into the data at the time of the pause. We wouldn't want to
include that trial, and so we exclude trials with boundary events. Another possibility is that the enable flag in the EventList was set
to zero for the time-locking event (e.g., because you realized that the participant had fallen asleep during the last part of the
experiment and you therefore disabled the events during that period after the session was over). These trials should also be
excluded.
ERPLAB can calculate some measures of data quality during the averaging process, and the Data Quality section of the averaging
GUI allows you to control this process. Just leave it set to On – default parameters. ERPLAB can also compute power spectra
during the averaging process, but you should leave the Power Spectra options off for the present exercise.
Creating and Saving an ERPset
Once you have everything set properly in the averaging GUI, you can click RUN to create the averaged ERPs. You’ll then see a
window that allows you to save the averaged ERPs, which are stored in an ERPset (as illustrated earlier in Figure 2.2). You should
name the ERPset 6_ERP (because this is the ERP data from Participant 6). That’s the name that will show up in the ERPsets menu.
You can also save the ERPset on your hard drive as a file. To do this, activate the Save ERP as button. The name of the ERPset in
memory does not need to be the same as the name of the file, but it’s usually a good idea to use the same name for both. You can
accomplish this by clicking the same as erpname button, which will put 6_ERP into the text box for the filename. Once you have
everything set, you can click the OK button. If you look in the ERPsets menu in the main EEGLAB GUI, you’ll see that the new
ERPset is now listed as ERPset 1: 6_ERP.
If you look in the Matlab command window, you’ll see that the averaging routine printed a bunch of information when it finished.
Here’s the last part of what it printed:
TOTAL:
The dataset 6_N400_preprocessed_filt_elist_bins_be_ar has a 38.5 % of discarded
trialsSummary per bin:
Bin 1 was created with a 41.7 % of rejected trials
Bin 1 was created with a 0.0 % of invalid trials
Bin 2 was created with a 55.0 % of rejected trials
Bin 2 was created with a 0.0 % of invalid trials
Bin 3 was created with a 29.6 % of rejected trials
2.9.2 https://socialsci.libretexts.org/@go/page/108226

<!-- source_pdf=Full.pdf pdf_page=60 source_page_label="2.9.3" source_url="https://socialsci.libretexts.org/@go/page/108226" -->

## PDF page 60

- Source page label: 2.9.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108226

Bin 3 was created with a 0.0 % of invalid trials
Bin 4 was created with a 26.3 % of rejected trials
Bin 4 was created with a 0.0 % of invalid trials
---------------------------------------------------
Data Quality measure of aSME
Median value of 1.0008 at elec FP2, and time-window 0:100ms, on bin 1, Prime word,
related to subsequent target word
Min value of 0.16593 at elec Oz, and time-window -200:100ms, on bin 1, Prime word,
related to subsequent target word
Max value of 3.5935 at elec F4, and time-window 600:700ms, on bin 3, Target word,
related to previous prime, followed by correct response
You should always look at this information in the command window. First, it allows you to verify that the expected number of trials
were rejected because of artifacts. Second, it allows you to see if there were any invalid trials (e.g., trials on which the enable flag
in the EventList was set so zero). Third, it provides a summary of some data quality metrics (which will be described in a later
section).
Viewing the Averaged ERP Waveforms
Now let’s plot the averaged ERP waveforms. Select EEGLAB > ERPLAB > Plot ERP > Plot ERP waveforms, and a big
complicated window will pop up with lots of options for controlling the plotting. Click the RESET button near the bottom to reset
it to the default parameters. To keep things simple, we’ll start by looking at the ERPs to the prime words, which are stored in Bin 3
(for targets that were related to the preceding prime) and Bin 4 (for targets that were unrelated to the preceding prime). To specify
that we want to plot just Bins 3 and 4, uncheck the button in the top left of the GUI labeled all bins and type 3 4 into the text box
underneath (as in Screenshot 2.16). You could instead click the Browse button to see a list of the bins.
Screenshot 2.16
2.9.3 https://socialsci.libretexts.org/@go/page/108226

<!-- source_pdf=Full.pdf pdf_page=61 source_page_label="2.9.4" source_url="https://socialsci.libretexts.org/@go/page/108226" -->

## PDF page 61

- Source page label: 2.9.4
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108226

Now click PLOT to see the waveforms. It should look something like Screenshot 2.17. If you’re not used to looking at ERP
waveforms, the plot may look like a chimpanzee threw a plate of spaghetti on the wall, but once you gain some expertise it will be
easy for you to comprehend what you’re seeing. I always recommend starting by looking at the prestimulus baseline period. Note
that it’s relatively flat compared to the poststimulus period. In theory, the prestimulus period should contain only random noise in
the single-trial EEG epochs, and if we average together enough epochs, the noise will “average out” to zero. It never actually
reaches a perfectly flat line with a finite number of trials. (This would be a good time to remind yourself of how many trials were in
each bin.) Also, there may be a tilt in the waveform during the prestimulus period as a result of overlapping ERP activity from the
previous stimulus or anticipatory activity.
Screenshot 2.17
In this particular example, the prestimulus baseline period looks quite good. The residual noise after averaging is relatively small
compared to the ERPs in the poststimulus period, and there is no obvious tilt. I wish they always looked this good. I chose
Participant 6 for this chapter because the data were very nice. In later exercises, you’ll see participants with much noisier data.
Now take a look at the poststimulus period. Start by looking at the CPz channel, which is the channel where the N400 is typically
largest and is the channel shown in the grand average in Figure 2.1. (If you want a zoomed-in view, you can single-click the
channel label to get a new window that shows only this channel.) You can see that there is a large broad positive voltage for the
targets that were related to the preceding prime word, extending from approximately 200 ms until the end of the epoch at 800 ms.
For the targets that were unrelated to the preceding prime, the voltage is more negative (less positive) during much of this period.
The existing evidence indicates that both the related and unrelated target words produce essentially the same activity, including the
broad positive voltage, but that the unrelated words also produce an additional negative voltage (the N400) that is added onto the
broad positive voltage. So, even though the voltage remains above zero for the unrelated targets, the difference between the related
and unrelated targets appears to be largely the result of the addition of an N400 component for the unrelated targets. This N400
activity appears to reflect the additional work the brain must do to process a word that is not related to the concepts that were
already active when the word was presented (for a review of the N400 and other language-related ERP components, see Swaab et
al., 2012).
2.9.4 https://socialsci.libretexts.org/@go/page/108226

<!-- source_pdf=Full.pdf pdf_page=62 source_page_label="2.9.5" source_url="https://socialsci.libretexts.org/@go/page/108226" -->

## PDF page 62

- Source page label: 2.9.5
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108226

Now take a look at the other channels. You’ll see that waveforms in channels near CPz (e.g., Cz, C3, C4, Pz, P3, C4, P4) look quite
similar to the CPz waveforms, but the waveforms in more distant channels (e.g., Fp1, Fp2, Oz) look quite different. This is because
the resistance of the skull is high (especially relative to the underlying cortex and overlying scalp), which causes the voltages to
spread widely before they reach the electrodes.
If this is the first time you’ve ever created averaged ERPs, I hope you have a real sense of accomplishment and awe. You are
looking at voltages created by neurons in the brain of a living human being who looked at pairs of words and decided whether the
second word in each pair (the target) was related or unrelated to the first word (the prime). A tremendous amount of brain power
and knowledge was needed for this participant to take the light emitted by the pixels on the computer screen, organize this light
into letters and words, recognize the words, access their meanings, and compare them. And you are looking at the actual voltages
created by the neurons as the brain carried out these processes. That is, the ERPs are the extracellular voltages produced by cortical
pyramidal neurons as a result of neurotransmission, which (amazingly!) are able to pass through the brain, meninges, skull, and
scalp to our recording electrodes. I’ve been recording and analyzing ERPs for almost 40 years, and this still gives me chills!!!
Viewing the Prime Words
Now let’s look at the averaged ERP waveforms for the prime words. Select EEGLAB > ERPLAB > Plot ERP > Plot ERP
waveforms, and set it up just as you did to look at the target words except specify 1 2 in the Bins to plot section. Bin 1 is the ERP
for prime words that are followed by a related target word, and Bin 2 is the ERP for prime words that are followed by an unrelated
target word. Unless the participant had ESP, these ERPs should be equivalent except for random noise. How could the brain
response to a given word vary according to the nature of a word that presented later in time?
Click the PLOT button to see the waveforms for Bins 1 and 2. If you look at the CPz channel, where the N400 effect was largest
for the target words, you’ll see that the waveforms for the two prime bins are pretty similar until about 400 ms poststimulus (see
Screenshot 2.18). Then, the waveform becomes slightly more negative for primes followed by related words than for primes
followed by unrelated words. Logically, this small difference must just be random noise in the data.
Screenshot 2.18
2.9.5 https://socialsci.libretexts.org/@go/page/108226

<!-- source_pdf=Full.pdf pdf_page=63 source_page_label="2.9.6" source_url="https://socialsci.libretexts.org/@go/page/108226" -->

## PDF page 63

- Source page label: 2.9.6
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108226

Now look at the F4 channel. You should see a large difference between Bins 1 and 2, beginning right around the onset of the prime
word (0 ms). This absolutely must be noise, because it takes at least 50 ms for visual information to reach the cortex and generate
an ERP. A similar but somewhat smaller early effect can be seen at the Pz electrode site.
Noise is an inevitable fact of life in ERP studies. After all, we’re trying to measure voltages produced by tiny neurons in the
cerebral cortex with electrodes placed on the skin, and there is a big thick skull between the neurons and the skin. Also, the brain
signals are only a few millionths of a volt once they reach the scalp, where they’re mixed with other signals such as skin potentials,
muscle activity, and induced voltages from computers and other electrical devices in the recording environment. When you read
journal articles, you don’t usually get to see the single-participant data. Instead, you see grand averages, which have much less
noise. Even without noise, the ERP waveforms from different people often look quite different from each other (probably due to
individual differences in how the cortex is folded up in the brain). So, don’t be surprised when the single-participant data you see in
this book or in your own studies look quite different from the grand average waveforms in published papers.
This page titled 2.9: Exercise- Averaged ERPs is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck
directly on the LibreTexts platform.
2.9.6 https://socialsci.libretexts.org/@go/page/108226

<!-- source_pdf=Full.pdf pdf_page=64 source_page_label="2.10.1" source_url="https://socialsci.libretexts.org/@go/page/108227" -->

## PDF page 64

- Source page label: 2.10.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108227

2.10: Exercise- Data Quality
Now that you’ve seen how noise can distort averaged ERP waveforms, let’s look at how we can quantify the noise level (or, to put
it in more positive terms, the data quality). When you averaged the data, recall that there was a Data Quality Quantification
section in the averaging GUI, and you left it set to On - default parameters (see Screenshot 2.15). Here, we’ll look at the data
quality metrics that were created by default.
Recall that the averaging routine printed some text to the command window, ending with the following:
Data Quality measure of aSME
Median value of 1.0008 at elec FP2, and time-window 0:100ms, on bin 1, Prime word,
related to subsequent target word
Min value of 0.16593 at elec Oz, and time-window -200:100ms, on bin 1, Prime word,
related to subsequent target word
Max value of 3.5935 at elec F4, and time-window 600:700ms, on bin 3, Target word,
related to previous prime, followed by correct response
This is a summary of a large set of data quality measures that are computed by default when you average, using a metric of data
quality called the standardized measurement error (SME; the specific version of SME used here is the analytic SME or aSME).
You can read a full description of the SME metric in Luck et al. (2021), and you watch a short video overview here along with a
corresponding infographic here. Briefly, the SME values provided by default give you the standard error of measurement for the
mean voltage within a set of time ranges (e.g., 0-100 ms, 100-200 ms, etc.). The larger the SME value, the less precisely the voltage
in that part of the waveform is likely to reflect the true voltage for that participant (i.e., the voltage that would be obtained if there
were no noise or we could average over an infinite number of epochs). The averaging routine computes a separate aSME value for
each combination of bin, channel, and time period.
The summary printed in the command window shows the best (minimum), worst (maximum), and median aSME values. You can
see that the best aSME value was 0.16593 µV at the Oz electrode site in Bin 1 during the first portion of the baseline period (-200
to -100 ms). The worst aSME value was 3.5935 µV at the F4 electrode site in Bin 3 near the end of the epoch (from 600 to 700
ms). The median was 1.0008 µV, so the worst value was more than three times as large as the “typical” value.
Do you remember that we saw big differences between primes that were followed by related versus unrelated words starting at time
zero in the F4 channel, which logically must have been noise? It’s no accident that the aSME value was largest for the same
channel.
Let’s take a look at all the aSME values that were computed when the averaged ERPs were created. Make sure that the ERPset
from the previous exercise is still loaded (by checking the ERPsets menu). Now select EEGLAB > ERPLAB > Data Quality
options > Show Data Quality measures in a table. You’ll see a table of aSME values like that shown in Screenshot 2.19. Each
row is a different channel and each column is a different 100-ms time range. You can select which bin is shown with a popup menu
near the top of the window. We’re currently looking at Bin 1.
2.10.1 https://socialsci.libretexts.org/@go/page/108227

<!-- source_pdf=Full.pdf pdf_page=65 source_page_label="2.10.2" source_url="https://socialsci.libretexts.org/@go/page/108227" -->

## PDF page 65

- Source page label: 2.10.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108227

Screenshot 2.19
A huge amount of information is shown in this table. To help you find the cases with the worst data quality (the largest values),
select the Color heatmap option. Now the cells of the table are colored according to the magnitude of the aSME values.
Notice that the values tend to get larger during later time windows. This is because the baseline correction procedure brings all the
single-trial EEG epochs toward 0 µV during the prestimulus period, and noise will cause the voltage to drift away from this
baseline over time. The more random variation there is over trials, the harder it is to precisely measure the amplitude, so this drift
causes larger aSME values.
You should also notice that the values tend to be largest in the F4 channel and second largest in the Pz channel. These are the same
channels where we saw the greatest noise-related differences between Bins 1 and 2 in the averaged ERP waveforms (Screenshot
2.18). Look at the other 3 bins as well (using the Selected BIN popup menu). These channels are also noisy in those bins,
indicating that these channels were just generally noisy. If you go back and look at the EEG epochs, it’s not obvious that these
channels are noisier than the others. That’s the value of having an quantitative metric of data quality: It’s possible to objectively
determine which channels (or which participants) have unusually noisy data. In later chapters, we’ll discuss what to do when a
channel or participant is particularly noisy.
The data quality metrics are computed by default when you create averaged ERPs. Often, however, you want to assess the data
quality prior to averaging (e.g., to determine whether a specific artifact rejection procedure will increase or decrease your data
quality). To accomplish this, you select the appropriate EEG dataset (which must be epoched) and then select EEGLAB >
ERPLAB > Compute data quality metrics (without averaging).
2.10.2 https://socialsci.libretexts.org/@go/page/108227

<!-- source_pdf=Full.pdf pdf_page=66 source_page_label="2.10.3" source_url="https://socialsci.libretexts.org/@go/page/108227" -->

## PDF page 66

- Source page label: 2.10.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108227

This page titled 2.10: Exercise- Data Quality is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck
directly on the LibreTexts platform.
2.10.3 https://socialsci.libretexts.org/@go/page/108227

<!-- source_pdf=Full.pdf pdf_page=67 source_page_label="2.11.1" source_url="https://socialsci.libretexts.org/@go/page/108228" -->

## PDF page 67

- Source page label: 2.11.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108228

2.11: Review of Processing Steps
You did a lot of exercises in this chapter, and they’re probably beginning to blur together in your mind. So let’s review the steps:
Load the EEG dataset
EEGLAB > File > Load existing dataset
Look at the dataset to verify that the EEG and event codes looked okay
EEGLAB > Plot > Channel data (scroll)
Filter out the low-frequency drift in the EEG
EEGLAB > ERPLAB > Filter & Frequency Tools > Filters for EEG data
Add an EventList to the dataset
EEGLAB > ERPLAB > EventList > Create EEG EVENTLIST
Verify that we had the correct number of occurrences of each event code
EEGLAB > ERPLAB > EventList > Summarize current EEG event codes
Use BINLISTER to assign events to bins
EEGLAB > ERPLAB > Assign bins (BINLISTER)
Extract fixed-length epochs from the continuous EEG and perform baseline correction
EEGLAB > ERPLAB > Extract bin-based epochs
Test each epoch for artifacts using a simple voltage threshold, verify that the appropriate epochs were marked, and see how
many artifacts were detected
EEGLAB > ERPLAB > Artifact detection in epoched data > Simple voltage threshold
Average together the epochs without artifacts, separately for each bin
EEGLAB > ERPLAB > Compute averaged ERPs
Plot the averaged ERP waveforms
EEGLAB > ERPLAB > Plot ERP > Plot ERP waveforms
Examine the data quality of the averaged ERPs
EEGLAB > ERPLAB > Data Quality options > Show Data Quality measures in a table
Although this may seem like a lot, it’s the minimal set of steps for going from raw EEG to an averaged ERP in ERPLAB for most
studies. There are many additional steps that are often included in what we call the EEG preprocessing pipeline, and there are also
many steps after averaging. Indeed, several preprocessing steps had already been applied to the EEG data used in this chapter’s
exercises. That’s why I decided to write a whole book! I hope this chapter has given you a clear overview of the basics of EEG
preprocessing. The next chapter will show the basic steps that follow the creation of the averaged ERP waveforms.
This page titled 2.11: Review of Processing Steps is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
2.11.1 https://socialsci.libretexts.org/@go/page/108228

<!-- source_pdf=Full.pdf pdf_page=68 source_page_label="2.12.1" source_url="https://socialsci.libretexts.org/@go/page/108229" -->

## PDF page 68

- Source page label: 2.12.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108229

2.12: A Simple Matlab Script
How long did it take you to run all of the steps in this chapter? Quite a while, I suspect. Now imagine that there are twice as many
steps (as will typically be the case), and that one of them takes 20 minutes to run (which is typical for the artifact correction process
that we typically use). And imagine that you’ve collected data from 40 participants and need to repeat the sequence of steps for
each of them. Now imagine that a reviewer insists that you change one of the steps, so now you need to run them all again. Does
this sound like fun? I didn’t think so. Also, when you do each step “by hand” using the EEGLAB/ERPLAB GUI, you’re likely to
make occasional errors.
To make your life easier and to reduce errors, you can automate the EEGLAB and ERPLAB processing steps using a Matlab script.
A script is basically a set of commands that you could type in the Matlab command window but that you inside save as a text file
with a .m extension (sometimes called a .m file). To make things more efficient, a script can include more sophisticated
programming elements like loops, if/then statements, and variables. If you already know how to program in a typical programming
language, you’ll find these aspects of Matlab scripting to be pretty straightforward. If you don’t already have much programming
background, this book will teach you the basics.
Fortunately, EEGLAB and ERPLAB have a history feature that makes scripting a lot easier. Every time you do something in the
EEGLAB/ERPLAB GUI, the equivalent script command is saved in the history. For example, when you ran the artifact detection
step, the following was saved in EEGLAB’s history:
pop_artextval( EEG , 'Channel',1:30, 'Flag',1, 'Threshold', [ -100 100], 'Twindow', [
-200 795] );
This makes it really easy to see how to create a line of script that corresponds to a step you carried out in the GUI. In fact, when I
write EEGLAB/ERPLAB scripts, I often do the steps first in the GUI, look at the history, and then copy the relevant commands
from the history into my .m file. In a later chapter, we’ll discuss how to access the history and build your own scripts. For now, let’s
run an example script just so that you can see the basic idea.
In the folder for this chapter, there is a file named preprocess_EEG.m. You should be able to see it in the Current Folder pane of
the Matlab GUI. Double-click the filename to open it in the Matlab text editor. This text editor recognizes certain aspects of the
Matlab scripting syntax and uses different coloring for different parts of the file (even though the actual file is just plain text
without any colors specified, as you can verify by opening it in some other text editor). Lines that begin with a percent symbol are
comments, and by default they’re colored in green. I added some comments at the top of the script that explain how to run it, and I
also put a comment above each line of code to explain what that line does. For example, near the bottom you will see the
pop_artextval command for doing artifact detection, and there is a comment above that line that explains what it does.
This script does all the basic EEG preprocessing steps that we covered in this chapter. Read through the comments in the script file
to see the steps. The last step prior to averaging was artifact detection, and the dataset created by this step is saved to a file. The
filename has _from_script appended to it.
To run the script, first quit EEGLAB to make sure that we don’t have any conflicts. Then, run the script. There are several ways to
do this, including a Run button in the tool bar at the top of the Matlab text editor window for the preprocess_EEG.m file. With
some luck, you’ll see a bunch of text appear in the Matlab command window, with information about each step that is running.
When everything is done, you’ll see a prompt in the command window.
If you see an error message or have some other kind of problem, then you’re about to learn some something useful! Start by
reading the error message and trying to figure out how to solve the problem. If that doesn’t work, see if there is someone around
who has experience running Matlab scripts and can give you some help. And if you can’t find someone to help, it’s time to consult
the troubleshooting tips in Appendix A2. You might also want to read the first half of Chapter 11 to learn some of the basic
concepts of EEGLAB/ERPLAB scripting.
Once you’ve gotten the script to run, you should see that it has created a new dataset file named
6_N400_preprocessed_filt_elist_bins_be_ar_from_script in the same folder with all the other files from this chapter. Launch
EEGLAB and open this file using EEGLAB > File > Load existing dataset. Take a look at the EEG using EEGLAB > Plot >
2.12.1 https://socialsci.libretexts.org/@go/page/108229

<!-- source_pdf=Full.pdf pdf_page=69 source_page_label="2.12.2" source_url="https://socialsci.libretexts.org/@go/page/108229" -->

## PDF page 69

- Source page label: 2.12.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108229

Channel data (scroll). It should look just like the EEG data that you saw after going through all the preprocessing steps with the
GUI.
I hope you can now see how much faster it is to process a participant’s data with a script than by doing it with the GUI. However,
this doesn’t mean that you won’t need the GUI once you’ve learned EEGLAB/ERPLAB scripting. You should use the GUI the first
time you go through a participant’s data so that you can check for problems and errors. You’ll also need to use the GUI to
determine the appropriate artifact detection parameters (and artifact correction parameters once you learn about that). But once
you’ve processed the participant’s data manually and determined the right parameters, you can run a script using those parameters
to reprocess the participant’s data. That way you can avoid any errors you might make when you process the data manually. And
when Reviewer 2 asks you to change your preprocessing pipeline, you’ll be able to reprocess all the data quite easily and won’t be
as grumpy about making the change.
This page titled 2.12: A Simple Matlab Script is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck
directly on the LibreTexts platform.
2.12.2 https://socialsci.libretexts.org/@go/page/108229

<!-- source_pdf=Full.pdf pdf_page=70 source_page_label="2.13.1" source_url="https://socialsci.libretexts.org/@go/page/108230" -->

## PDF page 70

- Source page label: 2.13.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108230

2.13: Key Takeaways and References
Key Takeaways
Several EEG preprocessing steps are necessary prior to creating the averaged ERPs for a given participant (and this chapter did
not even cover all of them).
After some of these preprocessing steps, it is important to look at the EventList information and the EEG waveforms to verify
that there are no problems or errors.
You should also look at the data quality metrics that are computed during the averaging process to determine if there are
problematic bins or channels (or a more general problem with the data quality for a given participant).
In this experiment, the data analyses focus on the target words to see if the response to the target depends on whether the target
word was related or unrelated to the preceding prime word. However, owing to noise, there were some differences in the ERP
elicited by the prime words that were followed by either related or unrelated targets. Does this make it difficult to interpret the
ERPs elicited by the target words? How does baseline correction help us avoid problems of this sort?
References
Kappenman, E. S., Farrens, J. L., Zhang, W., Stewart, A. X., & Luck, S. J. (2021). ERP CORE: An Open Resource for Human
Event-Related Potential Research. NeuroImage, 225, 117465. https://doi.org/10.1016/j.neuroimage.2020.117465
Kutas, M. (1997). Views on how the electrical activity that the brain generates reflects the functions of different language
structures. Psychophysiology, 34, 383–398.
Luck, S. J. (2014). An Introduction to the Event-Related Potential Technique, Second Edition. MIT Press.
Luck, S. J., Stewart, A. X., Simmons, A. M., & Rhemtulla, M. (2021). Standardized Measurement Error: A Universal Measure of
Data Quality for Averaged Event-Related Potentials. Psychophysiology. https://doi.org/10.1111/psyp.13793
Swaab, T. Y., Ledoux, K., Camblin, C. C., & Boudewyn, M. (2012). Language-related ERP components. In S. J. Luck & E. S.
Kappenman (Eds.), The Oxford Handbook of Event-Related Potential Components (pp. 397–439). Oxford University Press.
This page titled 2.13: Key Takeaways and References is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
2.13.1 https://socialsci.libretexts.org/@go/page/108230
