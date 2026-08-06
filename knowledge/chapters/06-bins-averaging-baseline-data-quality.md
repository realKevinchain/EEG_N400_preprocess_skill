# 6: Bins, Averaging, Baseline Correction, and Data Quality

> Source: *Applied Event-Related Potential Data Analysis* (Steven J. Luck), `Full.pdf`, PDF pages 154-184. Text is a mechanical page-by-page extraction, not a summary. Consult the PDF for figures and layout.

<!-- source_pdf=Full.pdf pdf_page=154 source_page_label="1" source_url="" -->

## PDF page 154

- Source page label: 1
- LibreTexts source: not printed on page

CHAPTER OVERVIEW
6: Assigning Events to Bins, Averaging, Baseline Correction, and Assessing Data
Quality
 Learning Objectives
In this chapter, you will learn to:
Design experiments that avoid subtle sensory confounds by following the Hillyard Principle
Create bin descriptor files for assigning events to bins
Predict how the signal-to-noise ratio will change as you change the number of trials being averaged together
Assess how the number of trials and the baseline period impact the data quality as quantified with the standardized
measurement error (SME)
Create response-locked as well as stimulus-locked averages
Compare the ERPs for correct trials and error trials
Conduct sequential analyses
Evaluate the impact of overlapping activity from the previous trial
Implement a sequential analysis using a script
This chapter takes a close look at how events are assigned to bins. This is not something that gets discussed a lot in the ERP
literature, even in methodology papers, but it’s absolutely fundamental. After all, “event” is the first word in “event-related
potential.” Also, ERPLAB’s tool for assigning events to bins (BINLISTER) is fairly powerful but also not very user-friendly, so
we’ll want to make sure you have a good grasp on how it works.
ERPLAB’s online documentation contains a detailed manual page on BINLISTER, and you should read it if you want to learn all
the details of how this important routine works. I won’t repeat all those details here. In fact, I even wondered if it was worthwhile
writing a chapter on bin assignment for this book. But I decided that the best way to learn about something like this is to actually
use it. And once I started creating the exercises, I realized that they brought up some concepts about ERP data analysis that are
important even if you end up using a different software package for analyzing your data.
This chapter will focus on the visual oddball P3b experiment from the ERP CORE, including an analysis of sequential effects and
an analysis of the error-related negativity produced on error trials. The oddball paradigm has probably been used more than any
other ERP paradigm over the years, so it’s good to have a thorough understanding of it. The particular version of this paradigm that
we implemented for the ERP CORE contains some subtleties that are useful for learning about the design of ERP experiments. And
the oddball paradigm is particularly well suited for exploring some of the issues that come up in assigning events to bins. We’ll
start by taking a close look at the details of the experimental paradigm. Then we’ll perform several different analyses of one
participant’s data so you can see some of the different ways that events can be assigned to bins and the issues that arise in this
fundamental step.
Along the way, we’ll see some important issues that arise in averaging, including overlap from previous trials. We’ll also take a
closer look at the baseline correction procedure, which seems simple but can end up creating problems in some situations. We’ll
also look carefully at how data quality varies according to the number of trials being averaged together and according to the
specific time period being used for baseline correction.
6.1: Data for This Chapter
6.2: Design of the ERP CORE Visual Oddball P3b Experiment
6.3: The Event Code Scheme
6.4: Overview of Bin Descriptor Files
6.5: Exercise - A Basic Assignment of Events to Bins
6.6: Exercise - Looking at the Averaged ERPs
1

<!-- source_pdf=Full.pdf pdf_page=155 source_page_label="2" source_url="" -->

## PDF page 155

- Source page label: 2
- LibreTexts source: not printed on page

6.7: Exercise - The Signal-to-Noise Ratio
6.8: Exercise - Response-Locked Averaging
6.9: Exercise - Comparing Correct and Error Trials
6.10: Exercise - Sequential Analysis of the P3b
6.11: Exercise - Combining Bins
6.12: Exercise - Overlap
6.13: Matlab Script For This Chapter
6.14: Key Takeaways and References
This page titled 6: Assigning Events to Bins, Averaging, Baseline Correction, and Assessing Data Quality is shared under a CC BY 4.0 license and
was authored, remixed, and/or curated by Steven J Luck directly on the LibreTexts platform.
2

<!-- source_pdf=Full.pdf pdf_page=156 source_page_label="6.1.1" source_url="https://socialsci.libretexts.org/@go/page/87960" -->

## PDF page 156

- Source page label: 6.1.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87960

6.1: Data for This Chapter
The data we’ll be using for the exercises in this chapter can be found in the Chapter_6 folder in the master folder:
https://doi.org/10.18115/D50056.
We’ll focus on the data from one participant (Subject 12), but the data from all participants who were included in the final analysis
are also provided in a folder named Data. To keep things simple, some preprocessing steps have already been applied to these data
(as will be described later).
Also, whereas the data in the previous chapters were downsampled from the original sampling rate of 1024 Hz to 200 Hz, the data
for this chapter were downsampled to 256 Hz, as in the published data. This creates some slight complications, but those
complications will be informative.
This page titled 6.1: Data for This Chapter is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck
directly on the LibreTexts platform.
6.1.1 https://socialsci.libretexts.org/@go/page/87960

<!-- source_pdf=Full.pdf pdf_page=157 source_page_label="6.2.1" source_url="https://socialsci.libretexts.org/@go/page/87961" -->

## PDF page 157

- Source page label: 6.2.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87961

6.2: Design of the ERP CORE Visual Oddball P3b Experiment
In a typical oddball experiment, there are two categories of stimuli, one of which is rare (called the oddballs or targets) and one of
which is frequent (called the standards or nontargets). For example, you might present a sequence of Xs and Os in the middle of a
video monitor, with 10% Xs and 90% Os. The Rare category will elicit a much larger P3b component than the Frequent category,
but only if participants are actively discriminating between the two categories. For example, if participants are asked to judge the
colors of the Xs and Os, you won’t see a larger P3 to the Rare Xs than to the Frequent Os. However, if participants are instructed to
press one button for Xs and another button for Os, this requires making an active categorization of each stimulus as an X or an O,
and you’ll see a much larger P3b for the Xs than for the Os. However, it’s not the motor response per se that leads to the P3b. The
Xs will also produce a larger P3b than the Os if the task is to press a button for the Os and make no response for the Xs.
Researchers have known since the 1960s that the amplitude of the P3b is inversely related to the probability of the eliciting
stimulus. That is, the P3b will be larger if the oddballs are 20% probable than if they are 30% probable, and the P3b will be even
larger if the oddballs are 10% probable (Duncan-Johnson & Donchin, 1977). A fundamentally important but not widely appreciated
fact is that it is not the probability of the physical stimulus that determines P3b amplitude, but instead the probability of what I call
the task-defined category. For example, my lab once ran an oddball experiment in which 15% of the stimuli were the letter E and
the other 85% were randomly selected from all the non-E letters (Vogel et al., 1998). The task was to press one button for the letter
E and another button for non-E letters. The letter E was more common than any other individual letter, but the task required
participants to categorize each stimulus as E or non-E, and the E category was less frequent than the non-E category. As a result,
the E stimuli elicited a much larger P3b than the non-E stimuli. You can learn more about the P3b component in Chapter 3 of Luck
(2014) or in John Polich’s chapter on the P3 family of components in the Oxford Handbook of ERP Components (Polich, 2012).
Many oddball experiments contain an obvious confound: If 10% of the stimuli are Xs and 90% are Os, then the Xs and Os differ
both in the shape of the letter and the probability of occurrence. This probably doesn’t have much impact on the P3b component,
but confounds like this are easy to avoid, so I’m always surprised that so many experiments have this confound. An easy way to
solve this is to counterbalance the probabilities: Use 10% Xs and 90% Os for half the trial blocks and 90% Xs and 10% Os for the
other half. This makes it possible to compare the ERP elicited by an X when it is Rare to the ERP elicited by an X when it is
Frequent. And we can do the same for the Os. In other words, we can hold the stimuli constant and vary only the probability. To
make things simpler, we can average the X-Rare and O-Rare ERPs together and compare the result to the average of the X-
Frequent and O-Frequent ERPs. Many experiments use this approach (but not as many as I would like!).
However, as illustrated in Figure 6.1, a subtle adaptation confound still remains when this counterbalancing is used. Imagine that X
is Rare and O is Frequent in the first trial block, and participants press one button for the Xs and another for the Os. Neurons in
visual cortex that are sensitive to the O shape will tend to become adapted by the frequent occurrence of the O stimuli, but neurons
that are sensitive to the X shape will not become adapted given the infrequent occurrence of this shape. As a result, the sensory
response will be smaller for the O stimuli than for the X stimuli. In the second trial block, O is Rare and X is Frequent. Now the X-
sensitive neurons become more adapted than the O-sensitive neurons, and the sensory response will be smaller for the Xs than for
the Os. So, even though we have counterbalanced which stimulus is Rare and which is Frequent, we still get a larger sensory
response for the Rare category than for the Frequent category.
6.2.1 https://socialsci.libretexts.org/@go/page/87961

<!-- source_pdf=Full.pdf pdf_page=158 source_page_label="6.2.2" source_url="https://socialsci.libretexts.org/@go/page/87961" -->

## PDF page 158

- Source page label: 6.2.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87961

Figure 6.1. Example of the sensory adaptation confound that is present in nearly all oddball experiments. The height of each bar
represents the magnitude of the sensory response to a given stimulus.
This exemplifies what I call the Hillyard Principle of experimental design: Keep the stimuli constant and vary only the
psychological conditions. To follow this principle, you must keep the entire sequence constant across conditions, which we are not
doing in the counterbalanced design shown in Figure 6.1. That is, we are using different sequences of stimuli to create our Rare and
Frequent categories, and any differences in the ERPs for these categories could be a result of physical stimulus differences rather
than the psychological categories of Rare and Frequent.
The Hillyard Principle
The Hillyard Principle is named after my PhD advisor, Steve Hillyard. When I was a grad student, we were constantly
reminded to keep the stimuli constant and vary the psychological conditions (usually by varying the instructions). Steve was a
master of experimental design, and he had a huge impact on the field by developing extremely rigorous designs (and instilling
this ethos into his many graduate students and postdocs).
The sensory ERP components are very sensitive to small differences in stimuli, and the Hillyard Principle is especially
important when you see differences between conditions at relatively short latencies (e.g., <200 ms after stimulus onset). If an
experiment does not follow the Hillyard Principle, it’s usually impossible to interpret any early effects (unless, of course, the
goal of the experiment was to examine the effects of stimulus manipulations on sensory activity). However, it’s a good idea to
follow the Hillyard Principle even when you’re looking at later effects, because it’s difficult to be 100% certain that a late
effect isn’t a consequence of an early sensory confound.
Some experimental questions are difficult to answer while following the Hillyard principle. For example, imagine that you
wanted to compare the ERPs elicited by nouns and verbs (presented as auditory speech signals). You don’t have any control
over what nouns and verbs sound like, and it would be difficult to create instructions that make a participant treat the word
“chair” as a noun in some trial blocks and a verb in other blocks. But if you were really motivated, you could actually achieve
this kind of control by using two groups of participants who spoke different languages. For example, if you compared
monolingual English speakers and monolingual Mandarin speakers, you could ask whether nouns and verbs that are known by
an individual produce a difference that is not present for nouns and verbs that are unknown by that individual.
In the ERP CORE, we designed the P3b experiment to follow the Hillyard principle. As illustrated in Figure 6.2, the stimuli were
the letters A, B, C, D, and E, presented in random order in the center of the video display. Each of these letters was 20% probable.
Each participant received 5 trial blocks, each containing 40 trials, and a different letter was designated the target in each block.
They were instructed to press one button for the target letter and another button for any of the four nontarget letters. For example,
when D was designated the target, they would press one button for D and a different button for A, B, C, or E. As a result, D was in
the Rare category when it was designated the target and was in the Frequent category when one of the other four letters was
6.2.2 https://socialsci.libretexts.org/@go/page/87961

<!-- source_pdf=Full.pdf pdf_page=159 source_page_label="6.2.3" source_url="https://socialsci.libretexts.org/@go/page/87961" -->

## PDF page 159

- Source page label: 6.2.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87961

designated the target. Thus, we followed the Hillyard Principle: we kept the sequence of stimuli constant and varied only the task
instruction.
 What it Means to Keep the Sequence Constant
If we had used the same exact sequence of letters in each trial block, it is possible that participants would have learned the
sequence. We therefore created a new randomized sequence for each block, but these sequences were created using the same
rules and differed only randomly. That rules out any systematic differences in the physical stimuli between trial blocks.
Figure 6.2 also shows the grand average ERP waveforms for the Rare and Frequent stimulus categories (from the Pz channel, with
the average of P9 and P10 as the reference). The Rare waveform contains equal numbers of trials for which A, B, C, D, and E were
designated the target. The Frequent waveform also contains equal numbers of trials for which A, B, C, D, and E were designated
the target. Thus, the larger P3b observed for the Rare category than for the Frequent category must reflect the Rareness of the task-
defined category, not the rareness of the physical stimuli. It took a lot of thought and effort to design the experiment this way, but I
really enjoy the process of designing experiments, especially when I need to come up with some kind of creative “trick” to rule out
all possible confounds.
Figure 6.2. Experimental paradigm and grand average ERP waveforms from the ERP CORE visual oddball P3b experiment.
This page titled 6.2: Design of the ERP CORE Visual Oddball P3b Experiment is shared under a CC BY 4.0 license and was authored, remixed,
and/or curated by Steven J Luck directly on the LibreTexts platform.
6.2.3 https://socialsci.libretexts.org/@go/page/87961

<!-- source_pdf=Full.pdf pdf_page=160 source_page_label="6.3.1" source_url="https://socialsci.libretexts.org/@go/page/87962" -->

## PDF page 160

- Source page label: 6.3.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87962

6.3: The Event Code Scheme
In a study like the ERP CORE P3b experiment, there are many different combinations of stimuli (5 letters) and task instructions
(which of the 5 letters was the target). Some care is therefore needed to come up with a scheme for representing each possible
stimulus/task combination as a separate event code using integers between 1 and 255. Table 6.1 shows our scheme. We used the
tens place in the event code to indicate which letter was the target and the ones place to indicate what the current letter was. For
example, event code 23 indicates that B was the target letter in the current block (because 23 has a 2 in the tens place) and that the
letter C was presented on the current trial (because 23 has a 3 in the ones place). In this scheme, the Rare category is coded as event
codes 11, 22, 33, 44, and 55, and the Frequent category is coded as the other combinations. We also used 201 and 202 as the event
codes that were generated when the participant pressed a response button, with 201 for a correct response and 202 as an incorrect
response.
Table 6.1. Event code scheme for the ERP CORE visual oddball P3b experiment.
6.3.1 https://socialsci.libretexts.org/@go/page/87962

<!-- source_pdf=Full.pdf pdf_page=161 source_page_label="6.3.2" source_url="https://socialsci.libretexts.org/@go/page/87962" -->

## PDF page 161

- Source page label: 6.3.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87962

Target Letter for Current
Event Code Tens place Current Stimulus Ones place
Block
11 A 1 A 1
21 B 2 A 1
31 C 3 A 1
41 D 4 A 1
51 E 5 A 1
12 A 1 B 2
22 B 2 B 2
32 C 3 B 2
42 D 4 B 2
52 E 5 B 2
13 A 1 C 3
23 B 2 C 3
33 C 3 C 3
43 D 4 C 3
53 E 5 C 3
14 A 1 D 4
24 B 2 D 4
34 C 3 D 4
44 D 4 D 4
54 E 5 D 4
15 A 1 E 5
25 B 2 E 5
35 C 3 E 5
45 D 4 E 5
55 E 5 E 5
This page titled 6.3: The Event Code Scheme is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck
directly on the LibreTexts platform.
6.3.2 https://socialsci.libretexts.org/@go/page/87962

<!-- source_pdf=Full.pdf pdf_page=162 source_page_label="6.4.1" source_url="https://socialsci.libretexts.org/@go/page/87963" -->

## PDF page 162

- Source page label: 6.4.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87963

6.4: Overview of Bin Descriptor Files
Now let’s see how event codes are assigned to bins with BINLISTER, using the very simple analysis shown in Figure 6.2 in which
we have one bin for the Rare category and another for the Frequent category. We’ll exclude trials in which the buttonpress response
was incorrect.
As you’ll recall from Chapter 2, a bin descriptor file is used to tell BINLISTER how event codes should be assigned to bins. In the
Chapter_6 folder, you’ll find a bin descriptor file named BDF_P3.txt, which we’ll use for this exercise. Make sure that the
Chapter_6 folder is the current folder in Matlab, and double-click the BDF_P3.txt file from the Current Folder pane in Matlab to
open it. Here’s what you should see:
bin 1
Rare, Correct
.{11;22;33;44;55}{t<200-1000>201}
bin 2
Frequent, Correct
.{12;13;14;15;21;23;24;25;31;32;34;35;41;42;43;45;51;52;53;54}{t<200-1000>201}
Each bin is described by a set of three lines. The first is the bin number (which must be in consecutive order, beginning with 1).
The second line is the label for the bin (which can be anything you like). The third line is the actual bin descriptor. A bin descriptor
indicates the sequence of event codes that define the bin. Each set of curly brackets ("{}") defines an event list that contains one or
more event codes. For each bin descriptor, one event list must be preceded by a period symbol. This event list defines the time-
locking event for the epoch (i.e., time zero). In the example shown above, event codes 11, 22, 33, 44, and 55 will serve as the time-
locking event for Bin 1. This bin therefore includes trials with an A stimulus when A is the target, B when B is the target, C when C
is the target, D when D is the target, and E when E is the target. We could have instead created a separate bin for each of these five
target letters and then combined the five bins after averaging using ERP Bin Operations. However, it was simpler to combine
them at the BINLISTER stage. The event list for Bin 2 contains all the event codes for the nontarget letters. You can verify this by
comparing the event descriptors with the list of event codes in Table 6.1.
The time-locking event list may be preceded or followed by other event lists, indicating that those events must be present for an
epoch of EEG to be assigned to a given bin. For example, imagine that Bin 1 was defined as:
{202}.{11;22;33;44;55}{201}
201 is the event code for a correct response and 202 is the event code for an incorrect response, so this bin descriptor would find
targets (event codes 11, 22, 33, 44, and 55) that are immediately preceded by an incorrect response and immediately followed by a
correct response.
In the actual bin descriptor for Bin 1, we don’t require any particular event code prior to the time-locking event, but we do require
that the time-locking event (the stimulus) is followed by the event code for a correct response. However, we want to make sure that
the response time (RT) wasn’t an outlier, indicating either a fast guess (an RT of <200 ms) or poor attention (an RT of >1000 ms).
To do this, we use a time-conditioned event list in which the list of event codes is preceded by t<start–end> (e.g., t<200–
1000>201 to indicate that event code 201 must be 200-1000 ms after the time-locking event).
Note that if we didn’t use a time-conditioned event list and instead used .{11;22;33;44;55}{201} as the event descriptor, the
response event code (201) would need to directly follow the stimulus event code, with no other event codes between. However, by
using a time-conditioned event list to specify that the 201 must be between 200 and 1000 ms after the stimulus event code, other
event codes may occur between the stimulus and the response.
Also, if a time-conditioned event list appears prior to the time-locking event, time flows backward from the time-locking event. For
example, if you specify {t<200-800>15}.{100}, BINLISTER will search for an event code of 100 preceded by an event code of 15
that occurred 200-800 ms prior to the 100. Additional details can be found in the BINLISTER documentation.
6.4.1 https://socialsci.libretexts.org/@go/page/87963

<!-- source_pdf=Full.pdf pdf_page=163 source_page_label="6.4.2" source_url="https://socialsci.libretexts.org/@go/page/87963" -->

## PDF page 163

- Source page label: 6.4.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87963

Should you exclude trials with incorrect behavioral responses?
In this experiment, we excluded trials with incorrect behavioral responses. In other studies, however, we don’t exclude the
error trials. Here’s the general principle: If the errors in a given task are likely the result of lapses of attention, then exclude the
error trials; if the errors in a given task mainly occur because the task is very difficult, then don’t exclude the error trials.
For example, errors in most oddball paradigms are typically a result of lapses of attention, so we exclude the error trials.
Indeed, the ERPs are quite different on error and correct trials in the oddball paradigm (Falkenstein et al., 1990). By contrast,
in tasks using the change detection paradigm to study visual working memory, most errors occur because of limits in storage
capacity (Luck & Vogel, 2013). As a result, brain activity is similar on correct and error trials (Luria et al., 2016), so we don’t
exclude the errors (which would reduce the number of trials per bin quite a lot, decreasing the signal-to-noise ratio).
This page titled 6.4: Overview of Bin Descriptor Files is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
6.4.2 https://socialsci.libretexts.org/@go/page/87963

<!-- source_pdf=Full.pdf pdf_page=164 source_page_label="6.5.1" source_url="https://socialsci.libretexts.org/@go/page/87964" -->

## PDF page 164

- Source page label: 6.5.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87964

6.5: Exercise - A Basic Assignment of Events to Bins
Enough theory—let’s make some bins! If EEGLAB is already running, I recommend quitting it and restarting it to make sure
everything is fresh. Set Chapter_6 to be Matlab’s current folder. Load the dataset named 12_P3_corrected_elist.set (using
EEGLAB > File > Load existing dataset). Scroll through the EEG (using EEGLAB > Plot > Channel data (scroll)) and
familiarize yourself with it. For example, take a look at the sequence of event codes and match them with the codes in Table 6.1.
When I load a dataset or ERPset, I don’t do anything until I’ve looked at the waveforms. Many times, this visual inspection has
made me realize that I have the wrong data or that there is something about the data that is incompatible with what I was planning
to do next.
Do you see any eyeblinks in the VEOG-lower or FP1 channels? Did you need to remove the DC offset to see all the channels? The
answer is “no” for both questions. This gives you some clues about the preprocessing steps that have already been applied to this
dataset. What operations do you think have already been applied?
To keep the exercises in this chapter simple, the waveforms have had an artifact correction procedure applied. Instead of excluding
epochs that contain blinks and eye movements, the voltages for the blinks and eye movements have been estimated and subtracted
from the waveforms. That way, we won’t need to throw out any trials in the exercises in this chapter. This is why the filename for
the dataset has _corrected in it. A high-pass filter (half amplitude cutoff at 0.1 Hz) has also been applied to remove slow drifts, and
the EventList was added.
We’re finally read to assign the events to bins. Select EEGLAB > ERPLAB > Assign bins (BINLISTER), and set it up like
Screenshot 6.1. Specifically, use the Browse button near the top to select the bin descriptor file (BDF_P3.txt). We want to read the
EventList from the current dataset, and we want to write the updated version with the bin information to the current dataset. We
also want to write it to a text file, so check the Text file box and put elist_bins.txt in the corresponding text box. Click RUN, and
then name the new dataset 12_P3_corrected_elist_bins.
6.5.1 https://socialsci.libretexts.org/@go/page/87964

<!-- source_pdf=Full.pdf pdf_page=165 source_page_label="6.5.2" source_url="https://socialsci.libretexts.org/@go/page/87964" -->

## PDF page 165

- Source page label: 6.5.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87964

Screenshot 6.1
You should see the text file with the EventList in it (elist_bins.txt) in Matlab’s Current Folder pane. Double-click on it to open it
the text editor. Near the top, just under the head information, you should see this:
bin 1, # 30, Rare, Correct
bin 2, # 153, Frequent, Correct
This tells you that 30 events were found that match the bin descriptor for Bin 1, and 153 were found that match the bin descriptor
for Bin 2. How many should we have had? This is an extremely important question to answer, because errors in event codes and in
assigning events to bins are quite common, and many of these errors will lead to the wrong number of trials per bin. In the task
description in the beginning of the chapter, you learned that there were 5 equiprobable letters, 5 blocks of trials (one with each
letter as the target), and 40 trials per block. This gives us 200 total trials. Given that 1 of the 5 letters was the target in each block,
target probability was 20%. This means that we should have had 40 targets and 160 nontargets over the course of a session. Why,
then, do we only have 30 instances of Bin 1 and 153 instances of Bin 2?
The answer is that Bins 1 and 2 are limited to trials with correct responses and an RT of 200-1000 ms. So, we can’t use these
numbers to verify that we have the correct number of event codes. As described in Chapter 2, another way that we can verify the
number of event codes is to use EEGLAB > ERPLAB > EventList > Summarize current EEG event codes. Give that a try.
The resulting list should print in the Matlab Command Window, but it still isn’t very informative. First, we have a ton of different
event codes. Second, when we created the randomized sequences of events in our stimulus presentation script, we specified a
certain probability of each letter but not a certain number. That is, we guaranteed that there were 8 instances of the letter A when A
was the target, but the other 32 stimuli in this block were sampled completely at random from the other 4 letters. So, you can verify
that we had eight targets in each block, but it’s not immediately obvious that we had the right number of nontargets.
6.5.2 https://socialsci.libretexts.org/@go/page/87964

<!-- source_pdf=Full.pdf pdf_page=166 source_page_label="6.5.3" source_url="https://socialsci.libretexts.org/@go/page/87964" -->

## PDF page 166

- Source page label: 6.5.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87964

To verify that we had the right number of Rare and Frequent stimuli, make a copy of BDF_P3.txt, and edit this copy so that the
event descriptors don’t require a correct response. Then run BINLISTER again (on 12_P3_corrected_elist) but choose a new
filename for the text file that will contain the new EventList. When you look at this new EventList, you should see 40 trials in Bin
1 and 160 trials in Bin 2.
Now go back to the text file with the first EventList (elist_bins.txt). Every event code is listed, with the bin assignment in the bin
column at the far right. Note that the bin field is empty for the response event codes, because these event codes are not used as
time-locking events in this analysis. For the stimulus event codes, you should find a 1 or 2 in this field, indicating whether the
stimulus was the target letter or one of the nontarget letters. However, the bin field is empty for some of the stimulus event codes.
These are error trials. We’ll take a closer look at the errors in a later exercise.
This page titled 6.5: Exercise - A Basic Assignment of Events to Bins is shared under a CC BY 4.0 license and was authored, remixed, and/or
curated by Steven J Luck directly on the LibreTexts platform.
6.5.3 https://socialsci.libretexts.org/@go/page/87964

<!-- source_pdf=Full.pdf pdf_page=167 source_page_label="6.6.1" source_url="https://socialsci.libretexts.org/@go/page/87965" -->

## PDF page 167

- Source page label: 6.6.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87965

6.6: Exercise - Looking at the Averaged ERPs
Let’s make averaged ERPs for the bins we created. We still have continuous EEG data, so we first need to divide the data into
epochs, with the time-locking event code as time zero. Make sure that the correct dataset is active (12_P3_corrected_elist_bins)
and select EEGLAB > ERPLAB > Extract bin-based epochs. Use the default epoch of -200 to 800 ms and the prestimulus
interval as the baseline correction period. Click RUN and keep the default name of 12_P3_corrected_elist_bins_be for the new
dataset. Take a look at the epoched data (using EEGLAB > Plot > Channel data (scroll)) to make sure everything looks okay. As
you may recall from Chapter 2, EEGLAB plots 5 epochs on a screen by default, making the epoched data look a lot like continuous
data—you need to look closely to see the boundaries between the epochs.
Once you’ve looked at the EEG epochs, select EEGLAB > ERPLAB > Compute averaged ERPs. You should be able to use the
default settings and just click RUN. Name the resulting ERPset 12_P3, and save the ERPset as a file named 12_P3.erp. Now plot
the ERPs (using EEGLAB > ERPLAB > Plot ERP > Plot ERP waveforms). It’s a good idea to click the RESET button in the
plotting GUI to get rid of any custom settings from the last time you plotted ERPs. We only have two bins, so you can keep it set to
plot all bins. You should see something like Screenshot 6.2.
Screenshot 6.2
Compare the waveforms at Pz with the grand average waveforms shown in Figure 6.2. Pretty similar! But that’s only because I
intentionally chose a participant whose ERPs looked like the grand average for the exercises in this chapter. There are tremendous
individual differences in ERP waveforms (largely due to nonfunctional differences in biophysical factors like skull thickness), and
the ERPs for most of the participants in this study don’t look this much like the grand average. Averaging (whether across trials or
across participants) is often necessary, but the result is something of a fiction. As I like to say, “averaging hides a multitude of
sins.”
Although published papers often focus on just a few electrode sites, you should always look at the whole set of channels to verify
that the scalp distribution is sensible. With a reference at or near the mastoids, the P3b effect (defined as the difference between
Rare and Frequent) should be biggest along the midline near Cz and Pz. This participant’s P3b is a little more frontal than is typical
for a visual paradigm, and I would ordinarily expect a smaller effect at Fz and a larger effect at Oz. But given the large range of
individual differences in ERPs, this participant’s data look pretty normal.
You can also see quite a bit of high-frequency noise in the lateral frontal and central channels over the right hemisphere (especially
F8). The noise in F8 and surrounding channels is probably EMG from the temporalis muscle (the muscle near the temples that is
used to contract the jaws). If you scroll through the original EEG data, you can also see the high-frequency noise in the single trials.
My guess is that this participant was clenching their jaw just a little bit, mainly on the right side.
6.6.1 https://socialsci.libretexts.org/@go/page/87965

<!-- source_pdf=Full.pdf pdf_page=168 source_page_label="6.6.2" source_url="https://socialsci.libretexts.org/@go/page/87965" -->

## PDF page 168

- Source page label: 6.6.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87965

This page titled 6.6: Exercise - Looking at the Averaged ERPs is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
6.6.2 https://socialsci.libretexts.org/@go/page/87965

<!-- source_pdf=Full.pdf pdf_page=169 source_page_label="6.7.1" source_url="https://socialsci.libretexts.org/@go/page/108207" -->

## PDF page 169

- Source page label: 6.7.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108207

6.7: Exercise - The Signal-to-Noise Ratio
In this exercise, we’re going to quantify the impact of the high-frequency noise in F8 on our data quality and also see how the data
quality depends on the number of trials being averaged together.
Take a look at the analytic standardized measurement error (aSME) values for the ERPset you just created (EEGLAB > ERPLAB
> Data Quality options > Show Data Quality measures in a table). There’s a ton of information in the table, and I find that it
helps to select the Color heatmap option. Interestingly, the aSME values from the F8 electrode are not particularly high. The
worst values are at PO4.
This disconnect between the aSME values and the high-frequency noise you can see in the waveforms occurs because these aSME
values tell you about the precision of the measurements of the mean voltage over 100-ms periods. High-frequency noise has very
little impact on the mean voltage over a 100-ms period, because the upward and downward noise deflections cancel out. However,
low-frequency noise has a big impact on the mean voltage over a given time period. If you look closely at the EEG for this
participant, you’ll see that the voltage tends to drift around a bit more at PO4 than at the other sites. That’s why PO4 has the worst
(largest) aSME value. If we were to quantify P3b amplitude as the mean voltage between 300 and 500 ms (as recommended by
Kappenman et al., 2021), the noise in PO4 would mean that our P3b amplitude score could be quite far from the participant’s true
score (i.e., the score we would obtain with an infinite number of trials). By contrast, the high-frequency noise in F8 wouldn’t have
much impact.
If we instead quantified P3b amplitude as the peak voltage between 300 and 500 ms, the high-frequency noise would be a bigger
problem. Computing the standardized measurement error for peak amplitude is more complicated, so we’re not going to look at it
now, but if we did I’m sure that the high-frequency noise in F8 would produce a large SME value. The take-home message is that
the effect of noise on your ability to precisely measure the amplitude or latency of a given ERP component depends on both the
nature of the noise (e.g., high-frequency versus low-frequency) and the nature of the method used to quantify the amplitude or
latency (e.g., mean amplitude versus peak amplitude).
Now let’s look at how the data quality differs between the Rare and Frequent averages. A standard idea in the ERP literature is that
the signal-to-noise ratio of an averaged ERP increases according to the square root of the number of trials (all else being equal). I
have to admit that I didn’t understand exactly what was meant by “noise” in the signal-to-noise ratio until a few years ago, when
we started developing the SME metric of data quality. The “signal” part of the signal-to-noise ratio is the “true” amplitude of the
averaged ERP waveform at a given moment in time (i.e., the amplitude we would obtain with an infinite number of trials). But how
do we define the noise?
It turns out that the noise is quantified as the standard error of the voltage at this time point in the averaged ERP waveform. The
voltage at a given time point in an averaged ERP waveform is simply the mean across the epochs being averaged together, and the
standard error of this mean can be estimated using the standard analytic formula for the standard error of the mean: SD ÷ sqrt(N).
That is, we take the standard deviation (SD) of the single-trial voltages at this time point and divide by the square root of the
number of trials. Because the denominator is sqrt(N), this standard error gets smaller according to sqrt(N). So, the denominator of
the signal-to-noise ratio decreases according to the square root of the number of trials, so the overall signal-to-noise ratio must
increase according to the square root of the number of trials.
In our P3b oddball experiment, 20% of the trials were oddballs, so there were 4 times as many Frequent trials as Rare trials. This
means that sqrt(N) was twice as great for the Frequent condition as for the Rare condition (because sqrt(4) = 2). And this implies
that the standard error should be half as large for the Frequent condition as for the Rare condition. The SME value is a generalized
metric of the standard error; it gives you the standard error for any amplitude or latency measure that is obtained from an averaged
ERP waveform (see the box below for more details).
Take a look at the aSME values for the Rare and Frequent conditions. You should see that the values are approximately half as large
for the Frequent condition (Bin 2) as for the Rare condition (Bin 1). That is, the noise (quantified as the SME) is about half as big
in the condition with four times as many trials. This is exactly what we would expect from the idea that the signal-to-noise ratio
varies according to the square root of the number of trials.
The SME is just an estimate, so we wouldn’t expect it to be perfectly predicted by the number of trials in a finite data set. To get a
more robust estimate, I made an average across all the time ranges and channels, and I found a mean of 0.617 for the Frequent
6.7.1 https://socialsci.libretexts.org/@go/page/108207

<!-- source_pdf=Full.pdf pdf_page=170 source_page_label="6.7.2" source_url="https://socialsci.libretexts.org/@go/page/108207" -->

## PDF page 170

- Source page label: 6.7.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108207

condition and 1.372 for the Rare condition. This isn’t quite a 1:2 ratio. But there’s a good explanation for this: although there were
4 times as many Frequent trials as Rare trials in the experiment, we ended up excluding more Rare trials from the averages because
of incorrect responses. Take a look at the actual number of trials in Bins 1 and 2—does the difference between the average aSME
values for the Rare and Frequent trials make sense given the actual sqrt(N) for the Rare and Frequent trials?
Some details about the SME
With ERPLAB’s default settings, the SME values indicate the standard error of the amplitude scores that you’d get by
quantifying the amplitude as the mean value in a set of consecutive 100-ms time periods. You can easily change the parameters
(in the averaging step) to select other time intervals. Ordinarily, we would measure the P3b as the mean amplitude between 300
and 500 ms. If you’re interested, you can have ERPLAB estimate the SME values for this time range by re-averaging the data
and selecting custom parameters in the Data Quality Quantification section of the averaging routine.
ERPLAB’s default SME values are estimated using the analytic formula for the standard error of the mean [SD ÷ sqrt(N)], so
we call these analytic SME (aSME) values. This formula can’t be used to estimate the SME for other amplitude or latency
scores (e.g., peak amplitude or peak latency), and something called bootstrapping is used instead. This is more complicated
and currently requires scripting. This is described in our original paper on the SME (Luck et al., 2021), and we have provided
example scripts for computing bootstrapped SME values (https://doi.org/10.18115/D58G91).
This page titled 6.7: Exercise - The Signal-to-Noise Ratio is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
6.7.2 https://socialsci.libretexts.org/@go/page/108207

<!-- source_pdf=Full.pdf pdf_page=171 source_page_label="6.8.1" source_url="https://socialsci.libretexts.org/@go/page/108208" -->

## PDF page 171

- Source page label: 6.8.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108208

6.8: Exercise - Response-Locked Averaging
In this exercise, we’re going to create response-locked averages rather than stimulus-locked averages. That is, when we create our
EEG epochs, the event code for the response will be time zero.
An important feature of BINLISTER is that it does not make a distinction between stimulus events and response events. An event
code is an event code, no matter whether it represents a stimulus, a response, an eye movement, a heartbeat, or a sudden change in
the FTSE stock index. Any event code can be the time-locking event (time zero). And a bin can be defined by any sequence of
event codes.
Open the bin descriptor file named BDF_P3_Response_Locked.txt in the Matlab text editor (by double-clicking it in the Current
Folder pane). Here’s what you should see:
bin 1
Rare, Correct
{t<200-1000>11;22;33;44;55}.{201}
bin 2
Frequent, Correct
{t<200-1000>12;13;14;15;21;23;24;25;31;32;34;35;41;42;43;45;51;52;53;54}.{201}
It’s a lot like the original bin descriptor file (BDF_P3.txt). The most important change is that the period symbol in each bin
descriptor is to the left of the response event list rather than being to the left of the stimulus event list. The period goes to the left of
the time-locking event, so this is how we indicate that the response event code (201) will be the time-locking event. The t<200-
1000> part has also been moved from the response event list to the stimulus event list. The timing is always given relative to the
time-locking event, which is now the response, so we need to specify that the stimuli must be 200-1000 ms prior to the response
rather that the response being 200-1000 ms after the stimulus.
If EEGLAB is running, quit it and restart it so that everything is fresh, and then load the original dataset again
(12_P3_corrected_elist.set). Then run BINLISTER, using BDF_P3_Response_Locked.txt instead of BDF_P3.txt as the bin
descriptor file. You can use whatever dataset names are convenient, but make sure to save the EventList as a new text file when you
run BINLISTER so that you can compare it to the original version.
Take a look at the new EventList text file. If you look at the bin column on the far right, you’ll now see bin numbers on the lines
for the response event codes (the 201 codes), with a 1 if the response is preceded by a target event code (11, 22, 33, 44, or 55) and a
2 if the response is preceded by a nontarget event code. This shows us that the responses will be used as time zero when we epoch
and then average the data.
To see this, go ahead and epoch the data (EEGLAB > ERPLAB > Extract bin-based epochs) with the settings shown in
Screenshot 6.3. Rather than using the default epoch of -200 to 800 ms, we’re now using an epoch of -600 to 400 ms. This is
because much of the activity occurs before rather than after time zero in a response-locked average. Also, rather than using Pre as
the baseline correction interval (which would use the period from -600 to 0 ms), select Custom and put -600 -400 into the text box
as the start and stop times. This period should be prior to stimulus onset on most trials because most of the RTs are <400 ms.
(There is a way to “trick” ERPLAB into using the actual prestimulus interval as the baseline in a response-locked average, but it’s
too complicated for this exercise.)
6.8.1 https://socialsci.libretexts.org/@go/page/108208

<!-- source_pdf=Full.pdf pdf_page=172 source_page_label="6.8.2" source_url="https://socialsci.libretexts.org/@go/page/108208" -->

## PDF page 172

- Source page label: 6.8.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108208

Screenshot 6.3
Take a look at the epoched data (using EEGLAB > Plot > Channel data (scroll)). If you look at the first epoch, you’ll see an
event code labeled B2(201) at time zero. This means that the event code was 201, and it’s now the time-locking event for Bin 2.
You’ll also see that the epoch begins 600 ms before this event and ends 400 ms after the event. You can’t see the stimulus event
code prior to this response, because it was more than 600 ms prior to the response and therefore falls outside the epoch. (You can
verify this by looking at the diff column in the EventList text file.) However, you can see the stimulus event code prior to the
response in the second epoch. The stimulus event code isn’t at time zero and it doesn’t begin with B2 because it wasn’t the time-
locking event. Scroll through several pages of epochs to make sure you understand what’s in this file.
Now average the data, just as you did for the stimulus-locked data, but use 12_P3_Response_Locked when you are prompted for
the name of the ERPset. Next, plot the ERPs (using EEGLAB > ERPLAB > Plot ERP > Plot ERP waveforms). In the region of
the plotting GUI labeled Baseline Correction, select None. Otherwise the plotting routine will re-baseline the data using the
interval from -600 to 0 as the baseline. Click PLOT to see the data.
Screenshot 6.4 shows a closeup of the waveforms from the Pz channel. You can see that the brain activity now begins
approximately 200 ms before the time-locking event (the response), because the stimulus is now before time zero. In addition, the
P3 peaks shortly after time zero. Compare this with the stimulus-locked waveforms from the Pz site in Screenshot 6.2, where the
P3 peaked around 350 ms. Given the combination of the stimulus-locked and response-locked waveforms, can you guess the
approximate mean RT for this participant?
The P3b component is usually tightly time-locked to the participant’s decision about whether the current stimulus belongs to the
Rare category or the Frequent category, so P3b latency usually (but not always) varies from trial to trial according to the response
time As a result, it can be informative to look at the P3b waveform in both stimulus- and response-locked averages. For an example
from the basic science literature, see Luck & Hillyard (1990) or the condensed description of this experiment in Luck (2014;
especially Figure 8.8 and the surrounding text). For an example with a clinical population, see Luck et al. (2009).
Screenshot 6.4
6.8.2 https://socialsci.libretexts.org/@go/page/108208

<!-- source_pdf=Full.pdf pdf_page=173 source_page_label="6.8.3" source_url="https://socialsci.libretexts.org/@go/page/108208" -->

## PDF page 173

- Source page label: 6.8.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108208

This page titled 6.8: Exercise - Response-Locked Averaging is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
6.8.3 https://socialsci.libretexts.org/@go/page/108208

<!-- source_pdf=Full.pdf pdf_page=174 source_page_label="6.9.1" source_url="https://socialsci.libretexts.org/@go/page/108209" -->

## PDF page 174

- Source page label: 6.9.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108209

6.9: Exercise - Comparing Correct and Error Trials
In this exercise, we’re going to create bins for the error trials as well as for the correct trials. This will allow us to look at the error-
related negativity (ERN, also called Ne), a negative-going ERP response over frontocentral electrode sites that is produced when
the participant makes an obvious error (see the excellent review by Gehring et al., 2012). Errors are pretty common on the Rare
trials in the oddball paradigm because the response for the Frequent category becomes highly primed. When you’re doing the task,
you find yourself pressing the Frequent button even though you realize (a moment too late) that you should be pressing the Rare
button.
Although the first published report of the ERN used an oddball task (Falkenstein et al., 1990), this task is less than ideal for looking
at errors because error trials are a small subset of an already-rare stimulus category, leading to very few error trials. In the ERP
CORE, we instead used a flankers task to look at the ERN, and we didn’t even analyze the error trials in the oddball task. In this
exercise, we’re going to analyze the error trials in the oddball task and look for the ERN. Do you think we’ll see an ERN? I wasn’t
sure we’d see it until I analyzed the error trials for the first time yesterday!
My first step was to create a new bin descriptor file that includes bins for the error trials. The file is named BDF_P3_Accuracy.txt
—go ahead and open it in the Matlab text editor (by double-clicking it in the Current Folder pane). You’ll see that I just added bins
for the Rare and Frequent stimuli followed by an error response (event code 202) instead of being followed by a correct response
(event code 201).
If EEGLAB is running, quit it and restart it so that everything is fresh, and then load the original dataset again
(12_P3_corrected_elist.set). Then run BINLISTER, using BDF_P3_ Accuracy.txt as the bin descriptor file. You can use whatever
dataset names are convenient, but make sure to save the EventList as a new text file.
Take a look at the new EventList text file. Near the top, under the header information, you’ll see the number of trials in each bin.
As before, there were 30 Rare trials followed by a correct response and 153 Frequent trials followed by a correct response in Bins 1
and 2. However, there were only 9 Rare trials followed by an incorrect response and a measly 3 Frequent trials followed by an
incorrect response. And this is actually more error trials than was typical (probably because this participant’s response times were
faster than those of most participants in this experiment). In the ERP CORE flankers experiment, which was designed to look at the
ERN, we controlled the number of errors by telling participants to speed up if they made errors on fewer than 10% of trials and
telling them to slow down if they made errors on more than 20% of trials. But the oddball experiment was not designed to look at
the ERN, so we didn’t try to control the number of errors. Some participants made a lot, and some made hardly any.
As usual, the next step is to epoch the data (EEGLAB > ERPLAB > Extract bin-based epochs). The epoching routine may still
have the settings from the response-locked averaging we did in the previous exercise, but now we’re going to make stimulus-
locked averages, so make sure that the epoch time range is set to -200 800 and the baseline correction period is set to Pre. Click
RUN and name the resulting dataset whatever you want. Now average the data. You should name the resulting ERPset
12_P3_Accuracy and save it as a file named 12_P3_Accuracy.erp. You’ll need it for a later exercise.
The averaging routine prints the best, worst, and median aSME values to the command window. You should always look at these
values to make sure there isn’t a problem with the data quality. You’ll see that the maximum value is much larger than the median,
which tells you there might be a problematic bin or channel. Of course, we might expect low data quality for the error trials given
how few trials were present. Consistent with this, the maximum value was for the bin with Frequent stimuli followed by an
incorrect response, which had only 3 trials.
Take a look at all the aSME values using EEGLAB > ERPLAB > Data Quality options > Show Data Quality measures in a
table. For the correct trials (Bins 1 and 2), the values look pretty reasonable. The SME quantifies the standard error of
measurement, and a standard error of between 1 and 3 µV is reasonably small relative to the >15 µV amplitude of the P3b. Now
look at the values for Rare stimuli followed by an incorrect response (Bin 3). Most of the values are still less than 5 µV, which
seems reasonable given the small number of trials. If you look at the values for Bin 4, however, you’ll see a lot of values that quite
a bit larger. This makes sense given that we had only 3 trials in this bin.
How many trials do you need? Some researchers have tried to provide a simple answer to this question, but there is no simple
answer because it depends on the number of participants (Baker et al., 2020) and the magnitude of the effect being studied (see
Boudewyn et al., 2018).
6.9.1 https://socialsci.libretexts.org/@go/page/108209

<!-- source_pdf=Full.pdf pdf_page=175 source_page_label="6.9.2" source_url="https://socialsci.libretexts.org/@go/page/108209" -->

## PDF page 175

- Source page label: 6.9.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108209

Now let’s plot the ERPs (using EEGLAB > ERPLAB > Plot ERP > Plot ERP waveforms; you may need to click the RESET
button to clear out the plotting parameters we used in the previous exercise). We’ll start by plotting the correct and incorrect Rare
trials, so specify Bins 1 and 3. Now we can finally answer the question of whether errors produce an ERN in this experiment (at
least for this one participant). The left side of Screenshot 6.5 shows what you should see in the FCz channel, where the ERN is
usually largest. You can see that the voltage is more negative from ~200-400 ms on the error trials than on the correct trials. This is
the ERN! Replication is a cornerstone of science, and it sure is nice to see that this effect can be replicated.
You can see that voltage is more positive for error trials than for correct trials from ~400-600 ms. This effect has also been seen in
many prior studies, and it’s called the error positivity or Pe.
Screenshot 6.5
As always, you’ll want to look at all the channels to see the scalp distribution of the effect. You can see that the difference between
error trials and correct trials (both in the ERN and Pe time windows) is biggest at frontal and central midline electrode sites. This is
what is typically observed when the mastoids or nearby sites are used as the reference. If you’re interested, you can try re-
referencing to the average of all sites and see how this changes the scalp distribution.
You should also try plotting the correct and incorrect Frequent waveforms (Bins 2 and 4). However, it’s hard to see much because
there were only 3 incorrect Frequent trials, so the waveforms are extremely noisy.
The ERN usually occurs right around the time of the response. When RTs vary greatly from trial to trial, the ERN in the stimulus-
locked averages occurs at different times on different trials, and this makes the ERN look “smeared out” in stimulus-locked
averages. The waveforms also look as if the P3b is just shifted to the right on the error trials. In fact, when Bill Gehring first saw
the ERN, he was looking at stimulus-locked averages, and he wasn’t sure it was a real component. However, when he made
response-locked averages, the ERN was a big, beautiful deflection at time zero. You can read the story of how he discovered the
ERN in Chapter 3 of Luck (2014).
The participant we’ve been looking at in this chapter didn’t have a lot of RT variability, so the ERN is easily visible in the stimulus-
locked averages. But let’s make response-locked averages to see if this makes the ERN even clearer. To do this, follow the
instructions in the previous exercise for making a response-locked average (especially using an epoch of -600 to 400 ms), but use
BDF_P3_Accuracy_Response_Locked.txt as the bin descriptor file.
For the FCz channel, the response-locked waveforms should look like those on the right side of Screenshot 6.5. Now the ERN
appears as a relatively sharp negative deflection, peaking shortly after time zero (the time of the buttonpress). You can see that it’s a
distinct deflection rather than simply being a rightward shift in the P3b.
This page titled 6.9: Exercise - Comparing Correct and Error Trials is shared under a CC BY 4.0 license and was authored, remixed, and/or
curated by Steven J Luck directly on the LibreTexts platform.
6.9.2 https://socialsci.libretexts.org/@go/page/108209

<!-- source_pdf=Full.pdf pdf_page=176 source_page_label="6.10.1" source_url="https://socialsci.libretexts.org/@go/page/108210" -->

## PDF page 176

- Source page label: 6.10.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108210

6.10: Exercise - Sequential Analysis of the P3b
A classic finding in the ERP literature is that the P3b component elicited by an oddball is smaller if the previous trial was also an
oddball than if the previous trial was a standard (Squires et al., 1976). In this exercise, we will perform a sequential analysis to see
this effect using the ERP CORE P3b paradigm. This will bring up some important general issues about ERPs as well as showing
you more about the process of assigning events to bins.
I’ve provided a bin descriptor file for this analysis named BDF_P3_Sequential.txt—go ahead and open it in the Matlab text editor
(by double-clicking it in the Current Folder pane). You’ll see that we have 4 bins: Bin 1, Rare preceded by Rare; Bin 2, Rare
preceded by Frequent; Bin 3, Frequent preceded by Rare; Bin 4, Frequent preceded by Frequent. The bin descriptors were modified
to require that the time-locking stimulus was preceded by either the Rare or Frequent stimulus and a correct response. For example,
Bin 1 is defined as:
{11;22;33;44;55}{201}.{11;22;33;44;55}{t<200-1000>201}
Okay, let’s make some ERPs with these bins. Quit and restart EEGLAB so that everything is fresh, and then load the original
dataset again (12_P3_corrected.set). Now run BINLISTER, using BDF_P3_ Sequential.txt as the bin descriptor file. We’ll need
the resulting dataset for a later exercise, so name it 12_P3_corrected_elist_bins_seq, and save it as a file named
12_P3_corrected_elist_bins_seq.set.
Take a look at the new EventList text file to see how many trials we have in each bin. There were only 6 Rare trials that were
preceded by Rare trials (with correct responses on both trials). That’s not a lot! This was a pretty short experiment (about 10
minutes), and we would ordinarily use a longer session with a lot more trials to do a sequential analysis. In fact, when I was
developing this exercise, the first subject I tried didn’t have a clear sequential effect; there was a hint of an effect, but the data were
so noisy that it wasn’t very clear. I then wrote a script to do the analysis for all the participants (which is provided in the Chapter_6
folder). Fortunately, when I looked at the grand average, I saw the nice effect shown on the left of Screenshot 6.6, in which the P3b
for the Rare stimulus was clearly larger when the preceding trial was the Frequent stimulus than when it was the Rare stimulus. I
then looked for a participant who exhibited this effect clearly, and I used this participant (Subject 12) for all the exercises in this
chapter.
Screenshot 6.6
The next step is to epoch the data (EEGLAB > ERPLAB > Extract bin-based epochs). Make sure that the epoch time range is set
to -200 800 and the baseline correction period is set to Pre. Click RUN and name the resulting dataset whatever you want. Now
average the data. You should name the resulting ERPset 12_P3_Sequential and save it as a file named 12_P3_Sequential.erp.
Now plot the data for the Rare stimuli (Bins 1 and 2). If you look at the Pz channel, you should see something like the waveforms
shown on the right of Screenshot 6.6. Once again, we’ve successfully replicated a finding from prior research!
However, we need to worry about the data quality given the small number of trials. Take a look at the aSME values for Bins 1 and
2 (EEGLAB > ERPLAB > Data Quality options > Show Data Quality measures in a table). You’ll see that most of the values
are worse (higher) for Bin 1 than for Bin 2, which is not surprising given that we had 6 trials in Bin 1 and 22 trials in Bin 2.
However, if you look at the Pz channel from 300 to 800 ms, you’ll see that the aSME values are only slightly higher for Bin 1 than
6.10.1 https://socialsci.libretexts.org/@go/page/108210

<!-- source_pdf=Full.pdf pdf_page=177 source_page_label="6.10.2" source_url="https://socialsci.libretexts.org/@go/page/108210" -->

## PDF page 177

- Source page label: 6.10.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108210

for Bin 2. I think this was just good luck: by chance, this channel didn’t show a lot of trial-to-trial variability in P3b amplitude in
Bin 1, so the standard error was pretty good despite the small number of trials. This makes the data from the Rare-preceded-by-
Rare condition somewhat believable. However, the nice big effect in the grand average is what really makes it believable.
 Sequence or Time?
Although many P3b effects have traditionally been interpreted in terms of the sequence of stimuli and sequential probability,
many of these effects appear to be primarily a result of the amount of time between stimuli of the same category (Polich,
2012).
This page titled 6.10: Exercise - Sequential Analysis of the P3b is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
6.10.2 https://socialsci.libretexts.org/@go/page/108210

<!-- source_pdf=Full.pdf pdf_page=178 source_page_label="6.11.1" source_url="https://socialsci.libretexts.org/@go/page/108211" -->

## PDF page 178

- Source page label: 6.11.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108211

6.11: Exercise - Combining Bins
In the previous exercise, we took our original Rare and Frequent epochs and subdivided them according to whether the previous
trial was Rare or Frequent, yielding four bins instead of two. We should be able to reconstruct our original two bins from the four
new bins. However, there is a little trick that you need to know about.
Let’s start by thinking about how to reconstruct the original Rare bin, in which the preceding trial could be either Rare or Frequent.
We could simply take Bin 1 (Rare preceded by Rare) and average it with Bin 2 (Rare preceded by Frequent). In ERP Bin
Operations, we could implement this with the following equation:
bin5 = (bin1 + bin2) / 2 Label Rare preceded by Rare or Frequent
However, this would not give us the same waveforms that we obtained in our original analysis that disregarded whether the
previous trial was Rare or Frequent. Can you figure out why?
The reason is that this equation gives Bins 1 and 2 equal weight in the new bin, but there were 6 trials with Bin 1 and 22 trials with
Bin 2 (which you can see by typing ERP.ntrials in the Matlab Command Window). The equation above assumes that there were
equal numbers of trials in each bin. To give each trial equal weight (which is what happened when the identity of the previous trial
was disregarded by BINLISTER), we would need the following equation in ERP Bin Operations:
bin5 = (6*bin1 + 22*bin2) / 28 Label Rare preceded by Rare or Frequent
However, the exact equation would depend on how many trials were in Bins 1 and 2, which might vary across participants. To
make this easier, ERP Bin Operations contains a function called wavgbin for performing weighted averaging, in which each bin is
automatically weighted by the number of trials.
Let’s see how these different methods of averaging work. Make sure that the dataset from the previous exercise is loaded
(12_P3_Sequential). Select EEGLAB > ERPLAB > ERP Operations, ERP Bin Operations. In the equations panel, clear out
any previous equations and enter the three following equations:
bin5 = (bin1 + bin2) / 2 Label Rare preceded by Rare or Frequent, equal weight
bin6 = (6*bin1 + 22*bin2) / 28 Label Rare preceded by Rare or Frequent, manually
weighted
bin7 = wavgbin(bin1, bin2) Label Rare preceded by Rare or Frequent, automatically
weighted
Make sure that the Mode is set to Modify existing ERPset, because we’re going to add these three bins to the four existing bins.
Then click RUN.
Now plot Bins 5, 6, and 7. You can’t actually see the waveforms for Bin 6, because it’s identical to Bin 7, and the Bin 7 waveform
exactly covers up the Bin 6 waveform. This shows that the wavgbin function is working properly. However, the P3b is slightly
larger for these bins than for Bin 5. Why is that? You should be able to figure it out given what you know about the amplitude of
the P3b in Bins 1 and 2 and the nature of the equations used for Bins 5, 6, and 7.
An obvious question is whether you should use unweighted averaging (as in Bin 5) or weighted averaging (as in Bins 6 and 7)
when combining bins together. There isn’t a single answer to this question. If you’re trying to create something equivalent to what
you would have gotten if you hadn’t subdivided the trials to begin with, then you’ll want to use weighted averaging. But beyond
that, the answer will depend on the logic of your experimental design and your scientific questions.
This page titled 6.11: Exercise - Combining Bins is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
6.11.1 https://socialsci.libretexts.org/@go/page/108211

<!-- source_pdf=Full.pdf pdf_page=179 source_page_label="6.12.1" source_url="https://socialsci.libretexts.org/@go/page/108212" -->

## PDF page 179

- Source page label: 6.12.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108212

6.12: Exercise - Overlap
A concern often arises in a sequential analysis like the one we performed in this chapter, namely that the results are distorted by
overlapping activity from the previous trial. A simple example of overlap is shown in Figure 6.3, which simulates an experiment in
which a stimulus is presented every 700 ms. The falling edge of the P3b from one trial is present during the prestimulus baseline
period of the next trial, which impacts the baseline correction procedure. That is, baseline correction involves taking the mean
voltage during the baseline period and subtracting it from each point in the waveform. The positive voltage from the overlap in the
baseline causes us to overestimate the true baseline voltage, and the entire waveform is shifted downward as a result. You might
think that we should just skip the baseline correction step, but it’s essential in 99.9% of experiments because there are huge sources
of low-frequency noise that would contaminate the waveform if we did not subtract the baseline.
Figure 6.3. Example of the impact of overlap on an ERP waveform before and after baseline correction. In this example, we are
assuming that a stimulus is presented every 700 ms, so the falling edge of the P3b from one trial is present during the prestimulus
period of the next trial. When this positive voltage is subtracted out by the baseline correction process, it shifts the poststimulus
waveform downward.
Some amount of overlap is present in most experiments, but it’s not usually a problem unless it differs across conditions. For
example, if the P3b on the previous trial was larger in Condition A than in Condition B, this would produce a larger positive voltage
in the baseline of Condition A. The baseline correction procedure would then push the rest of the waveform farther downward in
Condition A than in Condition B. As a result, the differences in overlap between Conditions A and B during the prestimulus period
end up creating a difference between the waveforms for these conditions in the poststimulus period. This is a fundamentally
important issue, and I recommend reading Marty Woldorff’s foundational paper on overlapping ERP activity (Woldorff, 1993). In
fact, it’s on my list of papers that every new ERP researcher should read.
I hope you can now see why I’m a little worried about comparing the Rare-preceded-by-Rare waveform with the Rare-preceded-
by-Frequent waveform. The overlapping voltage in the baseline might be larger when the previous trial was Rare (yielding a large
P3b) than when it was Frequent. The baseline correction procedure would then push the waveform farther downward on Rare-
preceded-by-Rare trials than on Rare-preceded-by-Frequent trials, artificially creating the appearance of a smaller (less positive)
P3b in the Rare-preceded-by-Rare waveform than in the Rare-preceded-by-Frequent waveform.
However, if the time between trials is long enough, the P3b from the previous trial will have faded prior to the baseline period of
the current trial. In the ERP CORE visual oddball P3b experiment, the time from one stimulus onset to the next (the stimulus onset
asynchrony or SOA) was 1400-1600 ms. The 200-ms prestimulus interval that we’ve used for the current trial therefore began at
least 1200 ms after the onset of the stimulus from the previous trial. That seems like it ought to be enough time for the P3b from the
previous trial to end, but it’s difficult to be certain without additional analyses.
In this exercise, we’re going to repeat the sequential analysis from the previous exercise, but taking a closer look at the overlapping
activity from the previous trial. In particular, we’re going to dramatically increase the length of the prestimulus portion of the epoch
so that we can see the previous-trial ERP as well as the current-trial ERP. And we’re going to see what happens when we use
different parts of the prestimulus period for baseline correction.
We’re simply going to change the epoch length, so we can start with the EEG dataset you created using BINLISTER in the
previous exercise, named 12_P3_corrected_elist_bins_seq. Make it the active dataset (which may require loading it from the file
you saved in the previous exercise). Now epoch the data (EEGLAB > ERPLAB > Extract bin-based epochs) using an epoch
time range of -1800 800 and a baseline correction period of -1800 -1600. If you look at Figure 6.2, you’ll see that the maximum
6.12.1 https://socialsci.libretexts.org/@go/page/108212

<!-- source_pdf=Full.pdf pdf_page=180 source_page_label="6.12.2" source_url="https://socialsci.libretexts.org/@go/page/108212" -->

## PDF page 180

- Source page label: 6.12.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108212

SOA is 1600 ms, so the period from -1800 to -1600 ms is always prior to the previous trial. By using this as our baseline, we can be
certain that the baseline correction won’t be influenced by whether the previous trial was the Rare or Frequent category.
Now average the data, naming the ERPset 12_Sequential_LongBaseline and saving it as a file named
12_Sequential_LongBaseline.erp. Plot the ERPs from Bins 1 and 2, but specify None in the Baseline Correction area of the
plotting GUI so that it doesn’t re-baseline the data. (Alternatively, you could specify Custom with a time range of -1800 -1600).
Screenshot 6.7A shows what it should look like in the Pz channel. You can still see that the current-trial P3b is larger for Rare-
preceded-by-Frequent than for Rare-preceded-by-Rare. That suggests that the sequential effect was saw before was not a result of
the combination of overlap and baseline correction. However, the data are pretty noisy, so I ran this analysis on all the participants.
The grand average in Screenshot 6.7B confirms that the sequential effect remains when the data are baselined relative to the
prestimulus period from the previous trial.
The grand average waveforms also make it clear that differential overlap is a real concern. That is, the persisting voltages from the
previous trial were somewhat different according to whether that trial was Rare or Frequent, potentially contaminating the baseline
period from the current trial. However, the overlapping activity seems to go in the opposite direction of the sequential effect, being
more negative (near time zero) when the previous trial was Frequent than when it was Rare, whereas the current-trial P3b was more
positive.
Screenshot 6.7
Although the grand averages looked fine when we used the prestimulus period from the prior trial as the baseline interval, this
approach can decrease the precision and reliability of the ERP waveforms. As illustrated in Figure 6.4, this decline in precision
occurs because the single-trial EEG voltage tends to drift gradually over time in a random direction, and the trial-to-trial variability
increases as you get farther away from the baseline period. This increased variability increases the error in measuring the “true”
amplitude, increasing variability across participants and thereby decreasing statistical power. Indeed, the waveforms in some of the
channels look pretty crazy with this distant baseline.
6.12.2 https://socialsci.libretexts.org/@go/page/108212

<!-- source_pdf=Full.pdf pdf_page=181 source_page_label="6.12.3" source_url="https://socialsci.libretexts.org/@go/page/108212" -->

## PDF page 181

- Source page label: 6.12.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108212

Figure 6.4. Illustration of the combined effects of low-frequency drift and baseline correction. The EEG is superimposed on low-
frequency signals (mainly arising from the skin) that drift slowly over time in a random direction. When the data are baseline-
corrected, this forces the voltages to be similar during the baseline period, but the voltage tends to drift farther away from the
baseline value, causing a gradual increase in trial-to-trial variability over time.
You can use the Standardized Measurement Error to quantify this increase in measurement error. Take a look at the aSME values
for the Pz channel in Bin 1 (EEGLAB > ERPLAB > Data Quality options > Show Data Quality measures in a table). We’ll
want to compare these values to the corresponding values from the original sequential analysis in which the baseline correction
period was -200 to 0 ms. (To save the current aSME values, you can either copy them from the table and paste them in a word
processor or save the values in a spreadsheet by clicking the button for Export these values, writing to: Excel.) Load the ERPset
you saved previously as 12_P3_Sequential.erp and look at the aSME values in that dataset, which was baselined from -200 to 0.
How do the aSME values differ between the data with the two different baseline periods? You should see that they are substantially
worse (larger) when the -1800 to -1600 period was used as the baseline. That’s exactly what we’d expect from Figure 6.4. So,
although using a distant time period for baseline correction can sometimes be valuable for assessing overlap, it comes at the cost of
increased measurement error. As a result, I find that analyses like these are mainly useful descriptively and not for statistical
analysis. In other words, it’s usually enough to look at the grand averages and see that the effects are largely the same with the two
different baseline periods without performing a statistical analysis on the data with the distant baseline period.
This page titled 6.12: Exercise - Overlap is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck
directly on the LibreTexts platform.
6.12.3 https://socialsci.libretexts.org/@go/page/108212

<!-- source_pdf=Full.pdf pdf_page=182 source_page_label="6.13.1" source_url="https://socialsci.libretexts.org/@go/page/108213" -->

## PDF page 182

- Source page label: 6.13.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108213

6.13: Matlab Script For This Chapter
I’ve provided a script called sequential_analysis.m in the Chapter_6 folder that implements the sequential analysis.
This page titled 6.13: Matlab Script For This Chapter is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
6.13.1 https://socialsci.libretexts.org/@go/page/108213

<!-- source_pdf=Full.pdf pdf_page=183 source_page_label="6.14.1" source_url="https://socialsci.libretexts.org/@go/page/137601" -->

## PDF page 183

- Source page label: 6.14.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137601

6.14: Key Takeaways and References
Key Takeaways
To ensure that ERP effects reflect psychological processes instead of low-level physical stimulus differences, it is important to
follow the Hillyard Principle: Keep the stimuli constant and vary only the psychological conditions.
The impact of noise on data quality depends on both the nature of the noise (e.g., low- versus high-frequency) and the method
of quantifying an ERP component (e.g., mean versus peak amplitude).
The standardized measurement error (SME) quantifies the standard error of an ERP amplitude or latency measurement. In
simple cases, the standard error decreases as the square root of the number of trials increases. As a result, the signal-to-noise
ratio increases as the square root of the number of trials increases (all else being equal).
Data quality typically declines when the activity being measured is distant in time from the baseline correction period.
It can be useful to look at the same data using both stimulus-locked and response-locked averages.
When averaging bins together, you need to think carefully about whether to weight the two bins equally or to weight by the
number of trials per bin.
Overlapping activity from previous trials can be a significant confound, especially when combined with baseline correction.
References
Baker, D. H., Vilidaite, G., Lygo, F. A., Smith, A. K., Flack, T. R., Gouws, A. D., & Andrews, T. J. (2020). Power contours:
Optimising sample size and precision in experimental psychology and human neuroscience. Psychological Methods.
http://dx.doi.org/10.1037/met0000337
Boudewyn, M. A., Luck, S. J., Farrens, J. L., & Kappenman, E. S. (2018). How Many Trials Does It Take to Get a Significant ERP
Effect? It Depends. Psychophysiology, 55, e13049. https://doi.org/10.1111/psyp.13049
Duncan-Johnson, C. C., & Donchin, E. (1977). On quantifying surprise: The variation of event-related potentials with subjective
probability. Psychophysiology, 14, 456–467.
Falkenstein, M., Hohnsbein, J., Joormann, J., & Blanke, L. (1990). Effects of errors in choice reaction tasks on the ERP under
focused and divided attention. In C. H. M. Brunia, A. W. K. Gaillard, & A. Kok (Eds.), Psychophysiological Brain Research (pp.
192–195). Elsevier.
Gehring, W. J., Liu, Y., Orr, J. M., & Carp, J. (2012). The error-related negativity (ERN/Ne). In S. J. Luck & E. S. Kappenman
(Eds.), The Oxford Handbook of Event-Related Potential Components (pp. 231–292). Oxford University Press.
Kappenman, E. S., Farrens, J. L., Zhang, W., Stewart, A. X., & Luck, S. J. (2021). ERP CORE: An Open Resource for Human
Event-Related Potential Research. NeuroImage, 225, 117465. https://doi.org/10.1016/j.neuroimage.2020.117465
Luck, S. J. (2014). An Introduction to the Event-Related Potential Technique, Second Edition. MIT Press.
Luck, S. J., & Hillyard, S. A. (1990). Electrophysiological evidence for parallel and serial processing during visual search.
Perception & Psychophysics, 48, 603–617.
Luck, S. J., Kappenman, E. S., Fuller, R. L., Robinson, B., Summerfelt, A., & Gold, J. M. (2009). Impaired response selection in
schizophrenia: Evidence from the P3 wave and the lateralized readiness potential. Psychophysiology, 46, 776–786.
Luck, S. J., Stewart, A. X., Simmons, A. M., & Rhemtulla, M. (2021). Standardized Measurement Error: A Universal Measure of
Data Quality for Averaged Event-Related Potentials. Psychophysiology. https://doi.org/10.1111/psyp.13793
Luck, S. J., & Vogel, E. K. (2013). Visual Working Memory Capacity: From Psychophysics and Neurobiology to Individual
Differences. Trends in Cognitive Sciences, 17, 391–400.
Luria, R., Balaban, H., Awh, E., & Vogel, E. K. (2016). The contralateral delay activity as a neural measure of visual working
memory. Neuroscience & Biobehavioral Reviews, 62, 100–108. https://doi.org/10.1016/j.neubiorev.2016.01.003
Polich, J. (2012). Neuropsychology of P300. In S. J. Luck & E. S. Kappenman (Eds.), The Oxford Handbook of Event-Related
Potential Components (pp. 159–188). Oxford University Press.
6.14.1 https://socialsci.libretexts.org/@go/page/137601

<!-- source_pdf=Full.pdf pdf_page=184 source_page_label="6.14.2" source_url="https://socialsci.libretexts.org/@go/page/137601" -->

## PDF page 184

- Source page label: 6.14.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137601

Squires, K., Wickens, C., Squires, N. K., & E. Donchin. (1976). The effect of stimulus sequence on the waveform of the cortical
event-related potential. Science, 193, 1142–1146. https://doi.org/10.1126/science.959831
Vogel, E. K., Luck, S. J., & Shapiro, K. L. (1998). Electrophysiological evidence for a postperceptual locus of suppression during
the attentional blink. Journal of Experimental Psychology: Human Perception and Performance, 24, 1656–1674.
Woldorff, M. (1993). Distortion of ERP averages due to overlap from temporally adjacent ERPs: Analysis and correction.
Psychophysiology, 30, 98–119.
This page titled 6.14: Key Takeaways and References is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
6.14.2 https://socialsci.libretexts.org/@go/page/137601
