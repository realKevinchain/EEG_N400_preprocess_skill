# 3: Processing Multiple Participants in the ERP CORE N400 Experiment

> Source: *Applied Event-Related Potential Data Analysis* (Steven J. Luck), `Full.pdf`, PDF pages 71-97. Text is a mechanical page-by-page extraction, not a summary. Consult the PDF for figures and layout.

<!-- source_pdf=Full.pdf pdf_page=71 source_page_label="1" source_url="" -->

## PDF page 71

- Source page label: 1
- LibreTexts source: not printed on page

CHAPTER OVERVIEW
3: Processing Multiple Participants in the ERP CORE N400 Experiment
 Learning Objectives
In this chapter, you will learn to:
Run a script for making averaged ERPs for multiple participants
Create a grand average (an average of the single-participant averages)
Visualize the grand average waveforms and noise metrics
Apply low-pass filters to the grand average to minimize high-frequency noise
Quantify N400 amplitude from single-participant averaged ERP waveforms
Conduct a simple statistical analysis on the N400 amplitudes
Conduct a more complex statistical analysis
Run a script that automates the steps in this chapter
In the previous chapter, we processed the data from a single participant in the ERP CORE N400 experiment, up to the stage of
creating and viewing the averaged ERP waveforms. In this chapter, we’ll process nine more participants and do the steps necessary
to get to the stage of quantifying N400 amplitude and conducting a simple statistical analysis.
Between the previous chapter and the current chapter, you’ll be able to see most of the major steps required to go from raw data to
a final conclusion. The details will be spelled out in subsequent chapters, and our goal here is for you to see the big picture. Also, to
make things go quickly, we’ll be looking at only 10 of the 40 participants in the actual study. If you’re already experienced with
ERPLAB, you can just skim this chapter.
Don’t forget to consult the troubleshooting tips in Appendix 2 if you run into error messages or other problems.
3.1: Data for This Chapter
3.2: Exercise- Preprocessing and Averaging the Data from 10 Participants
3.3: Exercise- Examining the Single-Participant ERPsets
3.4: Exercise- “Bad” Data
3.5: Exercise- Making a Grand Average
3.6: Exercise- Low-Pass Filtering
3.7: Exercise - Scoring N400 Amplitude
3.8: Exercise- Simple Statistical Analysis of N400 Data
3.9: Exercise- A More Complex Analysis
3.10: Exercise- ERP Channel Operations
3.11: Exercise- ERP Bin Operations
3.12: Review of Processing Steps
3.13: Matlab Scripts For This Chapter
3.14: Key Takeaways and References
This page titled 3: Processing Multiple Participants in the ERP CORE N400 Experiment is shared under a CC BY 4.0 license and was authored,
remixed, and/or curated by Steven J Luck directly on the LibreTexts platform.
1

<!-- source_pdf=Full.pdf pdf_page=72 source_page_label="3.1.1" source_url="https://socialsci.libretexts.org/@go/page/87939" -->

## PDF page 72

- Source page label: 3.1.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87939

3.1: Data for This Chapter
The N400 data we’ll be using for the exercises in this chapter can be found in the Chapter_3 folder in the master folder:
https://doi.org/10.18115/D50056. In this chapter, we’ll be looking at the data from only 10 of the 40 participants (Subjects 1, 6, 7,
12, 15, 16, 21, 22, 34, 38).
This page titled 3.1: Data for This Chapter is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck
directly on the LibreTexts platform.
3.1.1 https://socialsci.libretexts.org/@go/page/87939

<!-- source_pdf=Full.pdf pdf_page=73 source_page_label="3.2.1" source_url="https://socialsci.libretexts.org/@go/page/87940" -->

## PDF page 73

- Source page label: 3.2.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87940

3.2: Exercise- Preprocessing and Averaging the Data from 10 Participants
Before you start this exercise, quit from EEGLAB if it’s already running and then restart it so that you’re starting fresh. You might
even want to restart Matlab. Set Chapter_3 (the folder with the data you downloaded for this chapter) to be Matlab’s current
folder.
For this chapter, you’ll need averaged ERPs from 10 participants. You have three options for obtaining these ERPsets:
You can go through all the steps from Chapter 2 for each participant using the EEGLAB/ERPLAB GUI. The Chapter_3 folder
contains a folder for each participant containing the raw EEG data, just like the data you processed in Chapter 2. This will take
quite a bit of time, but you’ll really learn the preprocessing steps well by repeating them for each participant.
You can run the script named preprocess_and_average.m (which is in the Chapter_3 folder). It will run all the processing
steps automatically and create the ERPset for each participant. The script file contains instructions for running it. The advantage
of this approach is that you’ll get more comfortable running Matlab scripts (which will become increasingly useful as you
progress through the book). If you’d like, you can process some or all of the participants manually first and then run this script.
When you’re processing your own data, this is the right approach: You first process the data manually to make sure everything
is OK, and then you run a script to reprocess the data to avoid any errors in the manual processing.
There is a subfolder named Pre-made_ERPsets inside the Chapter_3 folder that contains—you guessed it!—a pre-made
ERPset for each participant. You can just move those ERPsets into the single-participant folders inside the Chapter_3 folder.
This is the quick-and-easy approach, but you won’t learn as much.
No matter which way you do it, make sure that you end up with an ERPset file named N_N400.erp inside folder N for each
participant (where N is the participant number). Then, load all 10 of these ERPsets into EEGLAB/ERPLAB (either with the script
or using EEGLAB > ERPLAB > Load existing ERPset). The ERPsets menu should now look like Screenshot 3.1.
Screenshot 3.1
This page titled 3.2: Exercise- Preprocessing and Averaging the Data from 10 Participants is shared under a CC BY 4.0 license and was authored,
remixed, and/or curated by Steven J Luck directly on the LibreTexts platform.
3.2.1 https://socialsci.libretexts.org/@go/page/87940

<!-- source_pdf=Full.pdf pdf_page=74 source_page_label="3.3.1" source_url="https://socialsci.libretexts.org/@go/page/87941" -->

## PDF page 74

- Source page label: 3.3.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87941

3.3: Exercise- Examining the Single-Participant ERPsets
Now let’s take a look at the averaged ERP data from each participant. Select ERPset 1 from the ERPsets menu so that we can
examine the data from Subject 1. Go to the Matlab command window and type ERP (followed by Return or Enter). You should see
something like the information shown in Screenshot 3.2.
Screenshot 3.2
ERP is the name of a Matlab variable that stores the current ERPset (the one you selected in the ERPsets menu). When you typed
the name of it in the command window, Matlab printed out the contents of the variable. It’s a complicated variable with many
different fields, including the erpname field (the name of the ERPset), the nchan field (which stores the number of channels), the
chanlocs field (which stores the names and 3-D locations of the electrodes), and the bindata field (which stores the actual ERP
data, in binary format). There is also an EEG variable that stores the current EEG dataset (if one is loaded).
The available variables can be seen in the Workspace pane of the Matlab GUI. You can also see the contents of a variable like ERP
or EEG by double-clicking the name of the variable in the Workspace pane. This causes the variable to be shown in a separate
window. You can then double-click on the fields of the ERP variable to see those fields in more detail. For example, try double-
clicking the chanlocs field to see what information it holds.
Now type ERP.ntrials in the command window. Matlab will print out information about the number of accepted trials, the number
of rejected trials, and the number of invalid trials for each bin. You should see that there were 47 accepted trials and 13 rejected
trials for Bin 1. You can also get a slightly nicer table with the same information by selecting EEGLAB > ERPLAB > Summarize
artifact detection > Summarize ERP artifacts in a table. You’ll want to know this information before looking at the ERP
waveforms for a given participant. For example, you’ll want to know if there were any bins without a reasonable number of
accepted trials.
Now plot the ERP waveforms with EEGLAB > ERPLAB > Plot ERP > Plot ERP waveforms. You can use the default settings,
except just plot Bins 3 and 4 (the related and unrelated targets). Just as in the grand averages shown in Figure 2.1 in the previous
chapter, you should see that the unrelated targets elicited a more negative voltage around 400 ms than the related targets. However,
this participant’s waveforms are a bit noisier than those of those of the participant we looked at in Chapter 2 (Subject 6). If you
don’t remember what Subject 6’s waveforms looked like, you can select that participant’s ERPset in the ERPsets menu and plot the
waveforms.
3.3.1 https://socialsci.libretexts.org/@go/page/87941

<!-- source_pdf=Full.pdf pdf_page=75 source_page_label="3.3.2" source_url="https://socialsci.libretexts.org/@go/page/87941" -->

## PDF page 75

- Source page label: 3.3.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87941

To look at the data quality (the analytic standardized measurement error or aSME), select EEGLAB > ERPLAB > Data Quality
options > Show Data Quality measures in a table.
Now repeat this sequence of steps to look at the data from all 10 participants. Here are some questions you should answer:
Do you see the N400 effect (more negative for unrelated than related targets) in each participant’s waveforms?
Are there any participants who have an unusually small or large numbers of trials rejected?
Are there any participants with appreciably worse aSME values?
These 10 participants were chosen because they all have pretty good data. They all have an N400 effect, and they all have pretty
similar levels of data quality. If we looked at all 40 participants in the full study, we’d see a wider range of effects, numbers of
rejected trials, and data quality.
This page titled 3.3: Exercise- Examining the Single-Participant ERPsets is shared under a CC BY 4.0 license and was authored, remixed, and/or
curated by Steven J Luck directly on the LibreTexts platform.
3.3.2 https://socialsci.libretexts.org/@go/page/87941

<!-- source_pdf=Full.pdf pdf_page=76 source_page_label="3.4.1" source_url="https://socialsci.libretexts.org/@go/page/87942" -->

## PDF page 76

- Source page label: 3.4.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87942

3.4: Exercise- “Bad” Data
So far, we’ve been looking at really clean data. However, the reality of ERP research (and most areas of human neuroscience) is
that you often get some participants with really noisy data. And in some areas, noisy data is the norm (and large numbers of
participants are needed to make up for it. For example, imagine trying to record the EEG from wiggly 2-year-olds. You’d get all
kinds of movement artifacts, and they won’t sit through an hour of data collection the way a paid adult will. But you’ll also see
some noisy in studies of calm, compliant adults. So, no matter what kind of ERP research you’re interested in, you’ll probably need
to learn to deal with noisy data.
In this exercise, we’ll look at one of the 40 participants in the full N400 study whose data were problematic (Subject 30). This
participant wasn’t horrible—all of our participants were college students who were pretty compliant with our instructions, and we
know a lot of tricks for optimizing the data quality in EEG recordings (see Farrens et al., 2019 for a detailed description of our EEG
recording protocol). However, the data from this participant were problematic in a way that we often see in our college student
population.
You can find this participant’s data in the folder named Bad_Subject inside the Chapter_3 folder. I’ve already preprocessed the
EEG and made the averaged ERPs, so you don’t need to go through those steps. The folder contains the original EEG dataset file,
the EEG dataset file after all preprocessing steps (including artifact detection), and the averaged ERPset file.
Start by loading the averaged ERP data from this participant (EEGLAB > ERPLAB > Load existing ERPset) and plotting Bins 3
and 4 (EEGLAB > ERPLAB > Plot ERP > Plot ERP waveforms). You should see a very noisy waveform for the related target
words, but the waveform for the unrelated target words is missing. If you look at the aSME data quality metric (EEGLAB >
ERPLAB > Data Quality options > Show Data Quality measures in a table), you’ll find an aSME value of 0 for every channel
at every time point for Bin 3 (related targets), and a value of NaN for Bin 4 (unrelated targets). NaN is an abbreviation for not a
number, and it’s what Matlab uses when something can’t be computed (e.g., when it requires dividing by zero).
Now plot the ERP waveforms for the prime words (Bins 1 and 2) and look at the aSME values for these words. The waveforms are
noisy, and the aSME values are higher than those for the 10 participants you processed in the previous exercises. But at least it
looks like there is valid data for these bins.
Your job now is to figure out what has gone wrong with Bins 3 and 4 for this participant. In Chapter 2, I made a point of describing
several checks that you should perform while processing a participant’s data (see summary of steps in Section 2.12). Section 3.4 of
the present chapter describes some additional checks. Go through these checks to figure out what went wrong with this participant.
Once you’ve done it, you can read the text box below to make sure your answer was correct (but no peaking until you’ve figured it
out for yourself!).
I hope you’ve now figured out the problem with Subject 30. I included this example to drive home a point that I made in Chapter 2,
namely that you really need to pay close attention when you’re initially processing each participant’s data. Don’t just run a script
and hope for the best. Look at the number of event codes, the number of accepted and rejected trials, the continuous EEG, and the
epochs that were marked by the artifact detection process. If you don’t, your data will be filled with C.R.A.P. (which is an acronym
for Commonly Recorded Artifactual Potentials, but also refers to a variety of other problems, such as incorrect event codes). And as
they say: garbage in, garbage out. So, if you want your experiments to yield robust, statistically significant, and accurate results,
pay close attention to the data!
What’s wrong with Subject 30?
If you load the ERPset for Subject 30 and look at ERP.ntrials, you’ll see that there was only one accepted trial in Bin 3 and
there were zero accepted trials in Bin 4. And if you load one of the EEG dataset files and look at the EEG, you’ll see that this
participant blinked a lot. In particular, the participant blinked right around the time of the buttonpress response (event code
201) on almost every trial. As a result, the ERP waveform for Bin 3 was based on an “average” of only one trial, and the aSME
value was zero. Bin 4 had no trials, so no ERP waveform could be plotted for that bin, and the aSME value was not a number
(NaN). Well over half the trials were also rejected in Bins 1 and 2, and the data were just generally noisy for this participant.
That’s why the aSME values were bad even for Bins 1 and 2.
3.4.1 https://socialsci.libretexts.org/@go/page/87942

<!-- source_pdf=Full.pdf pdf_page=77 source_page_label="3.4.2" source_url="https://socialsci.libretexts.org/@go/page/87942" -->

## PDF page 77

- Source page label: 3.4.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87942

When you loaded the ERPset for Subject 30 into ERPLAB, the fact that there were no trials in Bin 4 led to a warning message
that was printed in red text in the command window (WARNING: bin #4 has flatlined ERPs). You can probably still see it if
you scroll up. You probably didn’t notice it when it first happened, because it probably scrolled off the screen before you could
see it. When you run into a problem (like a bin that doesn’t appear to plot properly), you should look at the command window
(scrolling up if necessary) to see if any warning or error messages were printed. That can help you find problems like this.
So, what can we do about this subject? In the published version of the N400 ERP CORE experiment, we used artifact
correction instead of artifact rejection to deal with blinks. That is, we used a procedure called independent component analysis
to estimate and remove the part of the signal that was caused by blinking. We rejected trials with blinks only if the blinks
happened near time zero, indicating that the eyes were closed when the word was presented (which was rare). Consequently,
we were able to include almost all the trials from every participant in our averaged ERP waveforms.
This page titled 3.4: Exercise- “Bad” Data is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck
directly on the LibreTexts platform.
3.4.2 https://socialsci.libretexts.org/@go/page/87942

<!-- source_pdf=Full.pdf pdf_page=78 source_page_label="3.5.1" source_url="https://socialsci.libretexts.org/@go/page/87943" -->

## PDF page 78

- Source page label: 3.5.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87943

3.5: Exercise- Making a Grand Average
Although it’s important to look at the single-participant ERP waveforms, it will be easier to see subtle effects by averaging the
waveforms across participants to create grand average waveforms for each bin. To do this, make sure that the ERPsets from all 10
participants are loaded (which you can verify by looking at the ERPsets menu), and then select EEGLAB > ERPLAB > Average
across ERPsets (Grand Average). A new window will open that look something like Screenshot 3.3.
Screenshot 3.3
You need to specify which ERPsets will be averaged together. You can do this either by specifying a set of ERPsets that have
already been loaded (using the ERPset numbers in the ERPsets menu) or by specifying the filenames for ERPsets that have been
stored in files. In this exercise, we’ll specify the ERPsets that have already been loaded. If you have only the 10 ERPsets from our
10 example participants in your ERPsets menu, you can specify 1:10 (as in Screenshot 3.3). In Matlab, you can indicate a list of
consecutive numbers by providing the first and last numbers, separated by a colon. So, 1:10 is equal to 1 2 3 4 5 6 7 8 9 10. If these
aren’t the right ERPsets (because you have others also loaded into ERPLAB), just provide a list of the ten numbers for the ERPsets
you want to average together.
You can leave the other options set to their default values (making sure that they match Screenshot 3.3). Then click RUN. You’ll
then see the usual window for saving the new ERPset that you’ve created. Name it Grand_N400 (and save it as a file so that you
have it for the subsequent exercises). You should now see Grand_N400 in the ERPsets menu.
3.5.1 https://socialsci.libretexts.org/@go/page/87943

<!-- source_pdf=Full.pdf pdf_page=79 source_page_label="3.5.2" source_url="https://socialsci.libretexts.org/@go/page/87943" -->

## PDF page 79

- Source page label: 3.5.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87943

Now, plot the ERPs from Bins 3 and 4 (using EEGLAB > ERPLAB > Plot ERPs > Plot ERP waveforms). But let’s add
something new: Tick the box labeled show standard error (and make sure that the transparency level is set to 0.7). You should see
something like Screenshot 3.4, with a more negative voltage for the unrelated targets than for the related targets at CPz and
surrounding electrode sites. The light shading around the waveforms is the standard error of the mean at each time point (see the
box below for more information).
Screenshot 3.4
Now plot Bins 1 and 2. The waveforms for these bins should be lying right on top of each other, with any differences being small
relative to the SEM. Remember, these are the bins for primes that are followed by related versus unrelated targets, and unless the
participants have ESP, they can’t differ as a function of something that happens later. As a result, any differences between them are
simply a result of noise.
Finally, take a look at the aSME data quality values for the grand average (EEGLAB > ERPLAB > Data Quality options > Show
Data Quality measures in a table). When you made the grand average, the default settings caused the aSME values from the
individual participants to be combined together using something called the root mean square (RMS). This is like taking the average
of the single-participant aSME, except that the RMS value is more directly related to the impact of each participant’s data quality to
the effect size (see Luck et al., 2021). These aSME values are like a standard error, but they’re the standard error of the mean
voltage over a 100-ms time window rather than the SEM at a single time point (see the box below). If you look at the table of
aSME values, you’ll see that the values in the N400 time range are around 1.5 µV. That’s reasonably small relative to the large
difference in mean voltage between the unrelated and related targets. In other words, the data quality is quite good for our goal of
detecting differences between these two types of targets.
Plotting the Standard Error
Plotting the standard error of the mean (SEM) at each time point in an ERP waveform, as in Screenshot 3.4, can be helpful in
assessing whether the differences between conditions are reasonably large relative to the variability among participants. These
standard error values are just like the error bars that you might see in a bar graph. At each time point, the grand average ERP
waveform is simply the mean of the voltage values across participants at that time point. The SEM is just the standard
deviation (SD) of the single-participant values divided by the square root of the number of participants (which is exactly how
the SEM is usually calculated in other contexts).
3.5.2 https://socialsci.libretexts.org/@go/page/87943

<!-- source_pdf=Full.pdf pdf_page=80 source_page_label="3.5.3" source_url="https://socialsci.libretexts.org/@go/page/87943" -->

## PDF page 80

- Source page label: 3.5.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87943

You can also see the SEM when you plot a single participant’s averaged ERP waveforms. In this case, the waveform shows the
mean across trials rather than the mean across participants, and the SEM reflects the variability across trials rather than the
variability across time points.
Although the SEM can be useful, it has some downsides. First, imagine that the voltage at 400 ms is exactly 3µV more
negative for unrelated targets than for related targets in every participant (i.e., the experimental effect is extremely consistent
across participants). But imagine that the overall voltage at 400 ms is much more positive in some participants than others,
leading to quite a bit of variability in the voltage for each condition. Because of this variability, the SEM for each waveform
would be quite large at 400 ms. This would make it look like the difference in means between conditions was small relative to
the SEM, even though the difference for each participant was extremely consistent. In behavioral research, this problem is
addressed by using the within-subjects SEM (Cousineau, 2005; Morey, 2008). ERPLAB doesn’t have this version of the SEM
built in, but you can achieve the same result by making a difference wave between the conditions (e.g., unrelated targets minus
related targets) and getting the SEM of the difference wave. This is exactly what was done in the grand averages from the full
study (see Figure 2.1C in Chapter 2).
Another downside of the SEM is that it can be very large if there is a lot of high-frequency noise in the data, even though this
noise has minimal impact when we quantify the N400 as the mean voltage between 300 and 500 ms (as we will do later in this
chapter). The aSME value provided in our Data Quality measures does not have this downside, because it provides the
standard error of the mean voltage over a time period rather than the standard error of the values at individual time points. See
Luck et al. (2021) for a more detailed discussion.
This page titled 3.5: Exercise- Making a Grand Average is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven
J Luck directly on the LibreTexts platform.
3.5.3 https://socialsci.libretexts.org/@go/page/87943

<!-- source_pdf=Full.pdf pdf_page=81 source_page_label="3.6.1" source_url="https://socialsci.libretexts.org/@go/page/87944" -->

## PDF page 81

- Source page label: 3.6.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87944

3.6: Exercise- Low-Pass Filtering
We’ve already filtered out the low-frequency voltage drifts in the continuous EEG data for each participant’s data, but there is also
some high-frequency noise (small but rapid deflections in the waveforms). In our lab, we take great pains to reduce the major
sources of high-frequency noise (induced voltages from electrical devices in the environment and muscle activity). As a result,
there isn’t a lot of high-frequency noise in the grand averages shown in Screenshot 3.4. But there’s a little, and you’ll see a lot more
in most experiments (especially in the single-participant waveforms). So, this exercise will show you how to filter out high-
frequency noise using a low-pass filter. We’ll apply it to the grand average ERP waveform, but you could instead apply to the
single-subject ERPs, the epoched EEG data, or even the continuous EEG data (see Chapter 7 in Luck, 2014 for information about
when different filters should be applied).
Make sure that the Grand_N400 ERPset is still loaded in ERPLAB, and then select EEGLAB > ERPLAB > Filter & Frequency
Tools > Filters for ERP data. You’ll see a window that looks nearly identical to the filtering GUI you used to filter out low-
frequency drifts in the continuous EEG data. Set it up as shown in Screenshot 3.5, which should mainly involve setting the low-
pass cutoff to 20 Hz. Then click APPLY to run the filtering routine. You can name the new ERPset Grand_N400_filt.
Now plot the new ERPset. In the plotting GUI, notice that the option for plotting the standard error is grayed out. When you filter
the data, the original standard error values are no longer valid—they’re the standard error of the unfiltered mean voltage at each
time point, not the standard error of the filtered values. If you want to see the standard error of the filtered data, you’d need to filter
the single-participant ERPs prior to making the grand average.
Screenshot 3.5
3.6.1 https://socialsci.libretexts.org/@go/page/87944

<!-- source_pdf=Full.pdf pdf_page=82 source_page_label="3.6.2" source_url="https://socialsci.libretexts.org/@go/page/87944" -->

## PDF page 82

- Source page label: 3.6.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87944

Now compare the filtered waveforms to the original unfiltered waveforms. (If you don’t still have the plot of the unfiltered
waveforms, select Grand_N400 from the ERPsets menu and run the plotting routine). You should see that the filtered waveforms
look smoother than the unfiltered waveforms. In a later chapter, we’ll take a closer look at filtering and see how filters can reduce
noise but can also distort the data, and you’ll learn how to select filters that make your data cleaner without producing significant
distortions.
This page titled 3.6: Exercise- Low-Pass Filtering is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
3.6.2 https://socialsci.libretexts.org/@go/page/87944

<!-- source_pdf=Full.pdf pdf_page=83 source_page_label="3.7.1" source_url="https://socialsci.libretexts.org/@go/page/108183" -->

## PDF page 83

- Source page label: 3.7.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108183

3.7: Exercise - Scoring N400 Amplitude
Our next step is to quantify the amplitude of the N400 component for the unrelated and related target words so that we can perform
statistical analyses (which we will do in the next exercise). We need N400 amplitude values from each individual participant, so
make sure that you still have the single-participant ERPsets loaded in ERPLAB (you can check this in the ERPsets menu).
We’ll quantify the amplitude of the N400 as the mean voltage between 300 and 500 ms. Let’s be concrete about what this means.
These data are sampled at 200 Hz, which means that there is one voltage value every 5 ms. This gives us 21 values between 300
and 500 ms (not 20, because we include the value at 300 ms and the value at 500 ms, plus the values between them). We calculate
the mean voltage by summing together these 21 values and dividing by 21. It’s that simple. If you want to know why we quantify
the amplitude of an ERP component this way, see Chapter 9 in Luck (2014). We’ll apply this procedure to the averaged ERP
waveforms from each participant, once for the unrelated targets and once for the related targets. Initially, we’ll just do this for the
CPz electrode site.
Scoring Versus Measuring the Amplitude or Latency of an ERP Component
When researchers apply an algorithm to an ERP waveform to quantify the amplitude or latency of an ERP component, we
often say that we’re measuring the amplitude or latency. But I don’t really like this terminology. An ERP component is a
hypothetical entity in the brain, and we’re obtaining a value from a scalp signal that typically consists of a mixture of many
components. As a result, it’s not really a measurement of the component. Also, it seems weird to use the term “measuring”
when we’re taking values that were already measured (the EEG voltages) and recombining them in a new way. So, it seems
perfectly natural to say that we’re “measuring the EEG,” but it seems odd to say that we’re “measuring the amplitude of the
N400 component.”
I prefer to use the term score. That is, we’re “scoring the amplitude of the N400 component,” and we obtain “N400 amplitude
scores.” I started using this terminology just a couple years ago, so you’ll see the term measurement rather than score in many
of my writings and in ERPLAB Toolbox.
To score the N400 amplitude as the mean voltage between 300 and 500 ms, select EEGLAB > ERPLAB > ERP Measurement
Tool. You’ll see the big complicated window shown in Screenshot 3.6. The left side of the window is used to indicate which
ERPsets should be measured. Our ERPsets are loaded into ERPLAB already, so select From ERPset Menu and indicate the
ERPset numbers for the 10 single-participant ERPsets. In the example shown in Screenshot 3.6, these are ERPsets 1-10, so we
specify it as 1:10 (or, equivalently, 1 2 3 4 5 6 7 8 9 10). If we didn’t want to load the ERPsets into ERPLAB, we could instead
provide a list of the filenames using From ERPset files.
The right side of the window is used to specify how we want to score the data. The measurement type should be set to Mean
amplitude between two fixed latencies. In a later chapter, we’ll go over the other scoring methods (including peak amplitude and
peak latency, which are widely used but often inferior to the other options provided by ERPLAB). We want to obtain the scores
from Bins 3 and 4 and from Channel 14 (CPz), so make sure those are specified in the Bin(s) & Channel(s) section. The
Measurement window field should be 300 500 (with a space between the two numbers) to indicate the starting and ending
latencies of the time window for computing the mean amplitude score.
The Baseline period should be set to pre, which indicates that the entire prestimulus period should be used as the baseline. You
already baseline-corrected the data during the epoching process, but it doesn’t hurt to re-baseline the data just to be sure.
3.7.1 https://socialsci.libretexts.org/@go/page/108183

<!-- source_pdf=Full.pdf pdf_page=84 source_page_label="3.7.2" source_url="https://socialsci.libretexts.org/@go/page/108183" -->

## PDF page 84

- Source page label: 3.7.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108183

Screenshot 3.6
In the Save output file as section, you should use mean_amplitude.txt as the name of the file used to store the scores. Select One
ERPset per line (wide format), which will produce a format that works well with statistical packages that expect each line to be
one participant and each column to be a different score from that participant.
Most people would just click RUN at this point to obtain the amplitude scores. But there is another very important step, which is to
click the Viewer button. This will allow you to see the scores for each ERP waveform, which is very important for making sure that
the scoring procedure is working in a sensible manner. For example, a measurement window that seems appropriate when you’re
looking at grand average waveforms may not actually work well on the single-participant waveforms.
The Viewer is shown in Screenshot 3.7. I’ve set it to show all the bins. You can scroll through the different files (participants) to see
how the scoring is working for all the waveforms. From my perspective, everything looks like it’s working fine. Once you’re done,
click the Measurement Tool button to go back to the Measurement Tool. Then you can click RUN to obtain the amplitude scores
and save them in the text file.
3.7.2 https://socialsci.libretexts.org/@go/page/108183

<!-- source_pdf=Full.pdf pdf_page=85 source_page_label="3.7.3" source_url="https://socialsci.libretexts.org/@go/page/108183" -->

## PDF page 85

- Source page label: 3.7.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108183

Screenshot 3.7
If you look in the Current Folder section of the Matlab GUI, you’ll see that a file named mean_amplitude.txt has been created.
Double-click on it to open it in the Matlab text editor. It should look something like this:
The first column has the amplitude scores from Bin 3 (related targets) and the second column has the scores from Bin 4 (unrelated
targets). The third column is the name of the ERPset, which tells you which subject was measured on that line. You can see that
every single participant has a more negative (less positive) voltage for the unrelated trials than for the related trials.
This page titled 3.7: Exercise - Scoring N400 Amplitude is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
3.7.3 https://socialsci.libretexts.org/@go/page/108183

<!-- source_pdf=Full.pdf pdf_page=86 source_page_label="3.8.1" source_url="https://socialsci.libretexts.org/@go/page/108184" -->

## PDF page 86

- Source page label: 3.8.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108184

3.8: Exercise- Simple Statistical Analysis of N400 Data
Now we’re going to perform a simple statistical analysis of the N400 amplitude scores that you obtained in the previous exercise.
We have two amplitude scores for each participant, one for related targets and one for unrelated targets, and we want to know if the
scores are significantly different for these two experimental conditions. The simplest way to do this is with a paired t test.
I used the free JASP statistical package to run the t test, but you can use whatever package you find comfortable. Make sure you
specify a paired t test rather than an independent-samples t test. The results are shown in Screenshot 3.8. Before you look at the t
and p values, you should always look at the descriptive statistics. Once we get to more complex analyses, it will be really easy to
make mistakes in the statistical analysis. The most common mistake is to incorrectly specify which variable is in which column of
the data file. For example, you might think that the unrelated and related targets are stored in the first and second columns,
respectively, reversing the actual order. This kind of error becomes both more likely and more likely to lead to incorrect
conclusions when your design has several factors and each row of the data file has a dozen or more columns. By comparing the
group means from the statistical analysis to the grand average waveforms, you can often detect these errors.
Screenshot 3.8
If you look at the group means in Screenshot 3.8, you’ll see a mean of 9.657 µV for the related targets (Bin 3) and 1.583 µV for the
unrelated targets (Bin 4). Those values at least approximately match what you can see for the CPz channel from 300-500 ms in the
grand average waveforms shown in Screenshot 3.4.
Now that we’ve verified that the descriptive statistics look correct, we can look at the t and p values. The effect was significant at
the p < .001 level, and the effect size (Cohen’s d) was huge. The effect size of 3.145 indicates that the difference between the group
means for related and unrelated targets was 3.145 times as large as the standard deviation of the scores. You won’t find effects this
large in most experiments, but the N400 ERP CORE experiment was carefully designed to maximize the experimental effects, and
3.8.1 https://socialsci.libretexts.org/@go/page/108184

<!-- source_pdf=Full.pdf pdf_page=87 source_page_label="3.8.2" source_url="https://socialsci.libretexts.org/@go/page/108184" -->

## PDF page 87

- Source page label: 3.8.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108184

we chose a paradigm that was known to produce large effects. Also, I chose 10 participants with really clear effects for the
exercises in this chapter; the effect size was “only” 2.33 in the full sample of 40 participants (but this was still a huge effect size).
Limits on Comparing Descriptive Statistics with Grand Average Waveforms
When we score the amplitude of an ERP component as the mean voltage in a fixed time window, we can directly compare the
group mean values from the statistical analysis with the grand average ERP waveforms. This is because this scoring method is
a linear operation (for a definition and more information, see the Appendix in Luck, 2014). The order of operations does not
matter for linear operations. This means that we can obtain our mean amplitude score from the single-subject waveforms and
then compute the mean of these scores, and we will get exactly the same value that we would obtain by scoring the mean
amplitude from the grand average waveform.
Unfortunately, most other scoring methods are not linear. For example, the peak amplitude in a given time window is not
linear. If we obtain the peak amplitude from the single-subject waveforms and then compute the mean of these scores, the
result will not be the same as the peak amplitude of the grand average waveform. However, you should still compare the group
means from your statistical analysis with the grand average waveforms. If there is a large mismatch, then you may have made
an error in specifying the order of variables in your statistical analysis, or your grand average waveform may not adequately
represent what is happening at the single-subject level. In either case, you want to know!
This page titled 3.8: Exercise- Simple Statistical Analysis of N400 Data is shared under a CC BY 4.0 license and was authored, remixed, and/or
curated by Steven J Luck directly on the LibreTexts platform.
3.8.2 https://socialsci.libretexts.org/@go/page/108184

<!-- source_pdf=Full.pdf pdf_page=88 source_page_label="3.9.1" source_url="https://socialsci.libretexts.org/@go/page/108185" -->

## PDF page 88

- Source page label: 3.9.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108185

3.9: Exercise- A More Complex Analysis
In this exercise, we’re going to repeat the N400 analysis from the previous exercises, but we’re going to make it more complex by
measuring and analyzing the N400 at multiple electrode sites. We’ll set this up with two electrode factors: laterality (left
hemisphere, midline, and right hemisphere) and anterior-posterior (frontal, central, and parietal). That is, we’ll obtain scores from
F3, Fz, F4, C3, Cz, C4, P3, Pz, and P4. When we combine this with the relatedness factor, this will give us a factorial design with
three total factors. We won’t include CPz in these analyses because we don’t have electrodes at CP3 and CP4 and we don’t want an
unbalanced design.
Launch the Measurement Tool again and set it up exactly as before (Screenshot 3.7) except for the list of channels. If you click the
Browse button next to the text box for the channels, you’ll be able to select the nine electrode sites that we want. After you’ve
selected them, click OK to go back to the Measurement Tool. You should now see 2 5 7 13 16 17 21 22 24 in the text box. These
are the channels we want. You should also change the name of the output file to be mean_amplitude_multiple_channels.txt. Use
the Viewer to make sure that everything looks OK, and then click RUN in the Measurement Tool.
Now open the mean_amplitude_multiple_channels.txt file in the Matlab text editor. The text editor doesn’t deal with the tabs
very well, so you might want to import the file into Excel instead. Now we have 19 columns: 9 channels x 2 bins plus the ERPset
column. Unfortunately, the channels are in the order that they appear in the ERPsets, which is not very convenient. If you’re not
sure whether the amplitude scores are correct, you can launch the Measurement Tool again and use the Viewer to see the single-
subject scores.
Once you’ve verified that the scores are correct, you can enter the data into a statistical analysis. You should use a 3-way repeated-
measures ANOVA with factors of relatedness, laterality, and anterior-posterior. I ran this ANOVA in JASP, and the results are
shown in Screenshot 3.9.
3.9.1 https://socialsci.libretexts.org/@go/page/108185

<!-- source_pdf=Full.pdf pdf_page=89 source_page_label="3.9.2" source_url="https://socialsci.libretexts.org/@go/page/108185" -->

## PDF page 89

- Source page label: 3.9.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108185

Screenshot 3.9
Again, start by looking at the descriptive statistic and make sure they match the grand average waveforms in Screenshot 3.4. For
example, in both cases the amplitude for the related trials increases from the frontal to the central and parietal channels, and it tends
to be larger for the midline and right-hemisphere channels than for the left-hemisphere channels. You can also see the basic N400
effect in both the grand average waveforms and the group means: the voltage is more negative (less positive) for the unrelated
targets than for the related targets.
If you look at the F and p values, you’ll see that the main effect of relatedness (related vs. unrelated) was significant at the p < .001
level. The laterality and anterior-posterior main effects were also significant, and these factors both interacted significantly with
relatedness. That is, the difference between related and unrelated words was largest at the sites where the voltage was largest. This
pattern of interactions is exactly what would be expected given the multiplicative relationship between the magnitude of an internal
ERP generator and the observed scalp distribution (see Chapter 10 in Luck, 2014).
3.9.2 https://socialsci.libretexts.org/@go/page/108185

<!-- source_pdf=Full.pdf pdf_page=90 source_page_label="3.9.3" source_url="https://socialsci.libretexts.org/@go/page/108185" -->

## PDF page 90

- Source page label: 3.9.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108185

You’ve now completed a fairly sophisticated analysis of the N400 experiment. Congratulations! That was a lot of steps, and it took
us two chapters to get to this point.
However, I should note that I don’t generally recommend scoring a component from multiple sites and including electrode site
factors in the statistical analysis. The reasoning is described in the text box below. Sometimes it is justifiable, such as when your
scientific hypothesis leads to a prediction of different effects over the left and right hemispheres. But unless you have a real reason
to compare the effects across electrode sites, it’s usually better to limit your analysis to a single site or create a waveform that
averages across multiple sites. We’ll explore the latter option in the next exercise.
Minimizing the Number of Factors in an Analysis
The problem with including one or more electrode site factors is that it leads to a large number of statistical tests, increasing
the likelihood that you’ll get one or more significant effects that are a result of random noise in the data. Look at the table of
statistics at the top of Screenshot 3.9—how many p values do you see? Seven!
Ordinarily, you would expect a 5% probability that an effect will be significant (p < .05) when the null hypothesis is true.
However, if the null hypothesis were true for all seven of these tests, the chance that one or more would be significant (p < .05)
would be greater than 30%!
As we increase the number of factors in an ANOVA, the number of main effects and interactions skyrockets, and the odds that
one or more will be significant by chance becomes extremely high (Cramer et al., 2015; Frane, 2021). For example, in a 5-way
ANOVA, you are more likely than not to obtain a significant-but-bogus-effect. As a result, it is difficult to trust the results of
such analyses. My general advice is therefore to minimize the number of factors (see Luck & Gaspelin, 2017 for a detailed
discussion).
This page titled 3.9: Exercise- A More Complex Analysis is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
3.9.3 https://socialsci.libretexts.org/@go/page/108185

<!-- source_pdf=Full.pdf pdf_page=91 source_page_label="3.10.1" source_url="https://socialsci.libretexts.org/@go/page/108186" -->

## PDF page 91

- Source page label: 3.10.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108186

3.10: Exercise- ERP Channel Operations
In this exercise, we will take a look at two kinds of processing operations that are commonly applied to ERPs in which either the
bins or the channels are mathematically recombined. For example, we could average together two bins or two channels. These
kinds of operations are carried out with ERP Bin Operations and ERP Channel Operations, respectively.
Let’s start by looking at ERP channel operations. In the previous exercise, I noted that it is often better to average across channels
rather than to include channels as a factor in the statistical analysis. In the present exercise, we’ll average across the nine channels
that we used in the previous exercise (F3, Fz, F4, C3, Cz, C4, P3, Pz, and P4). Ordinarily, you would perform this averaging
process on the single-subject waveforms, then obtain the N400 amplitude scores, and then conduct the statistical analysis on these
scores. To make this exercise quick, however, we will instead average across channels in the grand average ERP waveform. This
will allow us to visualize the results of averaging but not perform a statistical analysis on the averaged data.
Before we look at how the averaging process is implemented in ERPLAB, let’s think for a minute about how you would compute
the average of these nine channels by hand. The average of nine values is just the sum of those nine values divided by nine. So, to
compute the average, you would use this equation:
This is how you perform channel operations in ERPLAB. That is, you specify an equation that describes exactly what you want to
compute, and ERPLAB computes it for you. The only difference is that you need to use the channel numbers rather than the
channel names.
Let’s give it a try. If necessary, load the grand average you made earlier (Grand_N400) into ERPLAB and make it the active
ERPset. Now select EEGLAB > ERPLAB > ERP Operations > ERP Channel operations.
You’ll see a window like the one shown in Screenshot 3.10. The panel on the right side gives you a list of the available channels
and the channel numbers. The panel on the left is a text window that allows you to write one or more equations. You can see that
we currently have 30 channels, so the new channel we will create will be channel 31. We’ll call this new channel Cluster. To make
this happen, we use the equation:
ch31 = (ch2 + ch16 + ch17 + ch5 + ch21 + ch22 + ch7 + ch13 + ch24) / 9 label Cluster
It’s just like the previous equation, except that we use channel numbers instead of channel names, and we add label Cluster to the
end of the equation to indicate the name of the new channel. Type this equation into the text box. Make sure that all the other parts
of the window match Screenshot 3.10, especially Modify existing ERPset, and then click RUN.
Because we’re modifying an existing ERPset rather than creating a new ERPset, you won’t see a window for saving the ERPset.
However, if you look at the ERPsets menu, you’ll see that the name of the current ERPset has been changed from Grand_N400 to
Grand_N400_chop to indicate that Channel Operations (abbreviated as “chop”) has been performed. If you want to save the
changed ERPset, you can select EEGLAB > ERPLAB > Save Current ERPset as.
3.10.1 https://socialsci.libretexts.org/@go/page/108186

<!-- source_pdf=Full.pdf pdf_page=92 source_page_label="3.10.2" source_url="https://socialsci.libretexts.org/@go/page/108186" -->

## PDF page 92

- Source page label: 3.10.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108186

Screenshot 3.10
Now let’s take a look at the result of this operation. Select EEGLAB > ERPLAB > Plot ERP > Plot ERP waveforms and plot
Bins 3 and 4. At the bottom of the plot, you’ll see the new channel, labeled Cluster. And you’ll see that it looks like what you’d
expect for the average of the 9 individual channels. If you performed this operation on the single-subject data, you could use the
ERP Measurement Tool to score the N400 amplitude from this new channel. Note that there is also an EEG Channel Operations
routine in ERPLAB that works in the same way except that it operates on EEG data (continuous or epoched) rather than on
averaged ERP data.
This page titled 3.10: Exercise- ERP Channel Operations is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
3.10.2 https://socialsci.libretexts.org/@go/page/108186

<!-- source_pdf=Full.pdf pdf_page=93 source_page_label="3.11.1" source_url="https://socialsci.libretexts.org/@go/page/108187" -->

## PDF page 93

- Source page label: 3.11.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108187

3.11: Exercise- ERP Bin Operations
Now that we’ve seen how to recombine channels with ERP Channel Operations, let’s see how to recombine bins using ERP Bin
Operations. One of the most common reasons to recombine bins is to make a difference wave, in which we subtract one bin from
another. In an N400 experiment, for example, we can isolate the brain activity that differs between related and unrelated target
words by constructing an unrelated-minus-related difference wave.
Our grand average ERP waveform currently has 4 bins, with Bin 3 being related targets and Bin 4 being unrelated targets. To create
an unrelated-minus-related difference wave as Bin 5, we use the following equation:
Bin5 = Bin4 - Bin3 label Unrelated Minus Related Target
Make sure that the grand average from the previous exercise (Grand_N400) is still loaded and is the active ERPset. Now select
EEGLAB > ERPLAB > ERP Operations > ERP Bin operations. You’ll see a new window like the one shown in Screenshot
3.11. The available bins are listed in the panel along the right side of the window, and there is a text box for writing equations. Type
the above equation into that box. Note that there is no space between “Bin” and the bin number. And make sure you use a minus
sign rather than a dash. Make sure the rest of the window is set up as shown in the screenshot, and click RUN.
Screenshot 3.11
Because we’re modifying an existing ERPset rather than creating a new ERPset, you won’t see a window for saving the ERPset.
However, if you look in the Matlab Command Window, you’ll see something like this:
%Equivalent command:
ERP = pop_binoperator( ERP, { 'Bin5 = Bin4 - Bin3 label Unrelated Minus Related
Target'});
This is the command that you would include in a script to achieve the same result. You’ll learn more about scripting later, but I
thought it would be good for you to see that the equivalent Matlab command is printed in the Command Window every time you
perform an operation in the ERPLAB GUI.
Now let’s see what the difference wave looks like. Select EEGLAB > ERPLAB > Plot ERP > Plot ERP waveforms and plot
Bins 3, 4, and 5. Screenshot 3.12 shows the waveforms from the CPz site. You can see that the voltage in Bin 5 at a given time
point is the difference between the voltages for Bins 3 and 4 at that time point. Note that the difference wave subtracts away any
3.11.1 https://socialsci.libretexts.org/@go/page/108187

<!-- source_pdf=Full.pdf pdf_page=94 source_page_label="3.11.2" source_url="https://socialsci.libretexts.org/@go/page/108187" -->

## PDF page 94

- Source page label: 3.11.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108187

brain activity that is identical for the related and unrelated targets, such as the negativity at ~100 ms and the positivity at ~180 ms.
All that remains is the brain activity that differentiates between the related and unrelated targets. This is an excellent way of
isolating the brain activity of interest from the ERP waveforms. If you read my general book on ERPs (Luck, 2014), you’ll see that
I’m a big fan of using difference waves to isolate specific brain responses.
Screenshot 3.12
Lost Information as a Result of Bin and Channel Operations
The original EEG data files that we used when we began processing this experiment contained information about the 3-
dimensional locations of the individual electrode sites. When you use Channel Operations to create a new channel, ERPLAB
has no way of knowing the 3-dimensional location that should be used for this channel. And if you modify a channel, ERPLAB
isn’t smart enough to know whether the original channel location is still valid. To avoid making assumptions that might turn
out to be incorrect, ERPLAB discards the channel information for any new or changed channels when you perform Channel
Operations. (If you check the Try to preserve location information box in the GUI, ERPLAB will make a guess about the
locations for changed locations, which usually works pretty well.)
The data quality information (including the SEM at each time point) is also lost when you perform Channel Operations.
ERPLAB is not smart enough to know how the data quality should be updated for new or modified channels. Similarly,
ERPLAB isn’t smart enough to estimate the data quality when you perform Bin Operations.
The bottom line is that if information about channel locations or data quality is missing, it is likely a result of Bin Operations
or Channel Operations.
This page titled 3.11: Exercise- ERP Bin Operations is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
3.11.2 https://socialsci.libretexts.org/@go/page/108187

<!-- source_pdf=Full.pdf pdf_page=95 source_page_label="3.12.1" source_url="https://socialsci.libretexts.org/@go/page/137548" -->

## PDF page 95

- Source page label: 3.12.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137548

3.12: Review of Processing Steps
To review, here are the steps we carried out in this chapter:
Processed the single-participant to get an ERPset for each of our 10 participants
I provided 3 different ways of doing this
Examined the number of accepted and rejected trials, ERP waveforms, and data quality measures for each participant to check
for problems
EEGLAB > ERPLAB > Summarize artifact detection > Summarize ERP artifacts in a table (or type ERP.ntrials in the
Matlab command window)
EEGLAB > ERPLAB > Plot ERP > Plot ERP waveforms
EEGLAB > ERPLAB > Data Quality options > Show Data Quality measures in a table
Made a grand average from our 10 participants
EEGLAB > ERPLAB > Average across ERPsets (Grand Average)
Applied a low-pass filter to the grand average to attenuate the high-frequency noise
EEGLAB > ERPLAB > Filter & Frequency Tools > Filters for ERP data
Obtained N400 amplitude “scores” (mean voltage from 300-500 ms) for the related and unrelated targets in each participant’s
averaged ERP waveforms
EEGLAB > ERPLAB > ERP Measurement Tool
Used the Viewer to see the measurements for each waveform
Performed a simple statistical analysis with the data from a single channel and a more complex analysis with the data from
multiple channels
The N400 amplitude scores were exported into a text file and then imported into a statistical package
ERPLAB does not perform statistical analyses—we did not want to “reinvent the wheel,” and it is difficult to anticipate
every possible statistical analysis someone would want to perform
We also compared the table of means from the statistical analyses with our grand average ERP waveforms to make sure that
the analysis was performed correctly
Created a new “cluster” channel that was an average of 9 of the original channels
EEGLAB > ERPLAB > ERP Operations > ERP Channel operations
Created a difference wave by subtracting one bin from another
EEGLAB > ERPLAB > ERP Operations > ERP Bin operations
This page titled 3.12: Review of Processing Steps is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
3.12.1 https://socialsci.libretexts.org/@go/page/137548

<!-- source_pdf=Full.pdf pdf_page=96 source_page_label="3.13.1" source_url="https://socialsci.libretexts.org/@go/page/137549" -->

## PDF page 96

- Source page label: 3.13.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137549

3.13: Matlab Scripts For This Chapter
I’ve provide two scripts in the data folder for this chapter. One is called preprocess_and_average.m, and it does the preprocessing
and averaging for all 10 participants. The other is called postprocessing.m, and it carries out all the remaining steps in this chapter.
These scripts are reasonably simple, and I’ve put lots of explanatory comments in them, so they’re a good way to start learning
scripting. Give them a try!
This page titled 3.13: Matlab Scripts For This Chapter is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
3.13.1 https://socialsci.libretexts.org/@go/page/137549

<!-- source_pdf=Full.pdf pdf_page=97 source_page_label="3.14.1" source_url="https://socialsci.libretexts.org/@go/page/108188" -->

## PDF page 97

- Source page label: 3.14.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108188

3.14: Key Takeaways and References
Key Takeaways
There are many steps between putting electrodes on the participant’s head prior to the recording session and seeing the p value
from the statistical analysis after the whole study is complete. As a result, there are many opportunity for some kind of problem
or error that can lead you to draw the wrong conclusion from the study. As a result, it’s crucially important that you constantly
check for problems and errors.
Some problems can be detected during preprocessing and averaging. For example, the response button may have been broken,
leading to no event codes for responses. Or the participant’s blinks may have been smaller than typical, causing many blinks to
escape the artifact detection procedure. You can often catch these errors by checking the number of rejected and accepted trials
and by examining the continuous and epoched EEG data.
The process of scoring the amplitude or latency of an ERP component can also go awry for some participants, so you should
use the Viewer tool to examine the scores alongside the waveforms for each participant.
Once you’ve entered the scores into a statistical analysis, you should compare the descriptive statistics from your statistical
package with the grand average waveforms to make sure that the analysis was performed correctly. It’s really easy to
accidentally put the scores in the wrong order.
References
Cousineau, D. (2005). Confidence intervals in within-subjects designs: A simpler solution to Loftus and Masson’s method.
Tutorials in Quantitative Methods for Psychology, 1, 42–45.
Cramer, A. O. J., van Ravenzwaaij, D., Matzke, D., Steingroever, H., Wetzels, R., Grasman, R. P. P. P., Waldorp, L. J., &
Wagenmakers, E.-J. (2015). Hidden multiplicity in exploratory multiway ANOVA: Prevalence and remedies. Psychonomic Bulletin
& Review, 23, 640–647.
Farrens, J. L., Simmons, A. M., Luck, S. J., & Kappenman, E. S. (2019). Electroencephalogram (EEG) Recording Protocol for
Cognitive and Affective Human Neuroscience Research. Protocol Exchange. https://doi.org/10.21203/rs.2.18328/v3
Frane, A. V. (2021). Experiment-Wise Type I Error Control: A Focus on 2 × 2 Designs. Advances in Methods and Practices in
Psychological Science, 4(1), 2515245920985137. https://doi.org/10.1177/2515245920985137
Luck, S. J. (2014). An Introduction to the Event-Related Potential Technique, Second Edition. MIT Press.
Luck, S. J., & Gaspelin, N. (2017). How to get statistically significant effects in any ERP experiment (and why you shouldn’t).
Psychophysiology, 54, 146–157.
Luck, S. J., Stewart, A. X., Simmons, A. M., & Rhemtulla, M. (2021). Standardized Measurement Error: A Universal Measure of
Data Quality for Averaged Event-Related Potentials. Psychophysiology.
Morey, R. D. (2008). Confidence intervals from normalized data: A correction to Cousineau (2005). Tutorials in Quantitative
Methods for Psychology, 4, 61–64.
This page titled 3.14: Key Takeaways and References is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
3.14.1 https://socialsci.libretexts.org/@go/page/108188
