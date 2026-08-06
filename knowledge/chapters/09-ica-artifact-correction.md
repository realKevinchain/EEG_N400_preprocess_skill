# 9: Artifact Correction with Independent Component Analysis

> Source: *Applied Event-Related Potential Data Analysis* (Steven J. Luck), `Full.pdf`, PDF pages 241-271. Text is a mechanical page-by-page extraction, not a summary. Consult the PDF for figures and layout.

<!-- source_pdf=Full.pdf pdf_page=241 source_page_label="1" source_url="" -->

## PDF page 241

- Source page label: 1
- LibreTexts source: not printed on page

CHAPTER OVERVIEW
9: Artifact Correction with Independent Component Analysis
 Learning Objectives
In this chapter, you will learn to:
Conceptualize artifact correction in terms of the overarching goal of your research and the specific problems that artifacts
pose when you try to reach that goal
Decompose the EEG into a set of independent components (ICs), identify ICs that represent artifacts, and reconstruct the
EEG without the artifactual ICs
Apply special preprocessing steps to obtain optimal ICs
Evaluate the effectiveness of the artifact correction procedure in terms of both data quality and confounds
Intelligently choose which ICs should be removed from your data
This chapter explains how to use independent component analysis (ICA) to correct certain kinds of artifacts (especially blinks and
eye movements). ICA-based artifact correction is a real godsend for experiments in which artifact rejection would throw out too
many trials. And it can improve the data quality for other experiments by allowing you to include most or all of the trials in your
averaged ERPs.
However, ICA-based artifact correction massively changes your data. Every single data point is impacted. And if done improperly,
ICA can make your data worse and lead to incorrect conclusions. It’s a bit like using backburn to deal with a wildfire (i.e., starting
a controlled fire to eliminate the fuel for the wildfire). If you’re not careful, it can get out of control and damage what you were
trying to save. You really need to know what you’re doing with ICA to get the best results and avoid getting burned.
Before I wrote this chapter, I did a lot of reading to make sure I was up to date and that the strategies described in this chapter
would reflect the current state of the art. I also spent a lot of time applying ICA to the ERP CORE data and carefully assessing the
results. The Makeig group at UCSD are still the world’s experts at ICA-based artifact correction, so much of what I write in this
chapter is based on their recommendations. EEGLAB’s ICA documentation is an excellent resource, especially the videos created
by Arnaud Delorme. The page of informal advice from Makoto Miyakoshi (called Makoto’s Preprocessing Pipeline) is also
extremely useful. I recommend that you read these sources after reading the present chapter. I also recommend reading the general
overview of artifact correction near the end of Chapter 6 of Luck (2014), along with the online supplement to that chapter.
As you read this chapter, keep in mind that the ultimate goal of artifact correction is the same as the ultimate goal of artifact
detection, which is to accurately answer the scientific question that the experiment was designed to address. In addition, you should
keep in mind the three main problems that we need to address in artifact rejection and correction: reduced statistical power as a
result of increased noise, systematic confounds, and sensory input problems.
9.1: Data for this Chapter
9.2: Exercise- A First Pass at ICA-Based Blink Correction
9.3: Exercise- Evaluating the Impact of Artifact Correction
9.4: Background- A Quick Conceptual Overview of ICA
9.5: Exercise- Making ICA Work Better
9.6: Exercise- Transferring the Weights and Assessing the ICs
9.7: Exercise- Deciding Which ICs to Exclude
9.8: Exercise- Deleting C.R.A.P. Prior to ICA
9.9: General Recommendations
9.10: Matlab Scripts For This Chapter
9.11: Key Takeaways and References
1

<!-- source_pdf=Full.pdf pdf_page=242 source_page_label="2" source_url="" -->

## PDF page 242

- Source page label: 2
- LibreTexts source: not printed on page

This page titled 9: Artifact Correction with Independent Component Analysis is shared under a CC BY 4.0 license and was authored, remixed,
and/or curated by Steven J Luck directly on the LibreTexts platform.
2

<!-- source_pdf=Full.pdf pdf_page=243 source_page_label="9.1.1" source_url="https://socialsci.libretexts.org/@go/page/87974" -->

## PDF page 243

- Source page label: 9.1.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87974

9.1: Data for this Chapter
The data we’ll be using for the exercises in this chapter can be found in the Chapter_9 folder in the master folder:
https://doi.org/10.18115/D50056.
This page titled 9.1: Data for this Chapter is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck
directly on the LibreTexts platform.
9.1.1 https://socialsci.libretexts.org/@go/page/87974

<!-- source_pdf=Full.pdf pdf_page=244 source_page_label="9.2.1" source_url="https://socialsci.libretexts.org/@go/page/87975" -->

## PDF page 244

- Source page label: 9.2.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87975

9.2: Exercise- A First Pass at ICA-Based Blink Correction
I find that it’s easiest to understand ICA by starting with an example and then explaining how it works after you’ve seen it in
action. We’re going to start with the data Subject 10 from the ERP CORE MMN experiment, which we looked at in the previous
chapter in the section on eye movement detection.
Launch EEGLAB (or quit and restart it if was already running). Set Chapter_9 to be Matlab’s current folder, and load the dataset
named 10_MMN_preprocessed.set. Make sure you’re getting the data from the Chapter_9 folder rather than the Chapter_8
folder, because the data are preprocessed a little differently but the filenames are the same.
The dataset you loaded has been high-pass filtered at 0.1 Hz and referenced to the average of P9 and P10 (except for the VEOG-
bipolar and HEOG-bipolar channels). Take a look at the data to remind yourself what it looks like. You’ll see lots of blinks and eye
movements prior to the start of the stimuli at ~25 seconds.
When we looked at this participant’s data in the previous chapter, the EEG had been low-pass filtered. Without the low-pass
filtering, you can now more easily see the spike potential at the beginning of each eye movement, which is a result of the muscle
activity that sets the eyes in motion. This is illustrated in Figure 9.1, which shows the first 5 seconds of data from Subject 10. You
can see a brief spike in several channels at the moment when the HEOG voltage starts to change from one level to another (which
indicates a change in gaze location from one location to another). You may want to adjust the vertical scale and number of channels
being displayed so that you can see these voltage changes more clearly.
Figure 9.1 Examples of spike potentials and HEOG voltage associated with saccadic eye movements.
Once you’re done scanning through the EEG to see what the whole session looks like, select EEGLAB > Tools > Decompose data
by ICA and set the parameters as shown in Screenshot 9.1 Everything is probably already set correctly, except for the channels,
which you should set to 1:31. With this channel list, we’re including all the channels that have the same reference, and we’re
excluding VEOG-bipolar and HEOG-bipolar. ICA assumes that the channels are linearly independent of each other, and the
VEOG-bipolar and HEOG-bipolar were created by recombining other channels, so they would violate this assumption. However,
they are useful channels to have so that we can tell when blinks and eye movements occurred even after we’ve corrected the EEG
data.
9.2.1 https://socialsci.libretexts.org/@go/page/87975

<!-- source_pdf=Full.pdf pdf_page=245 source_page_label="9.2.2" source_url="https://socialsci.libretexts.org/@go/page/87975" -->

## PDF page 245

- Source page label: 9.2.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87975

Screenshot 9.1
Click OK to start the process of computing the ICA weights. You’ll see some text appear in the Matlab command window,
followed by a long series of lines that look like this:
step 1 - lrate 0.001000, wchange 16.88431280, angledelta 0.0 deg
step 2 - lrate 0.001000, wchange 0.90426626, angledelta 0.0 deg
ICA works by training a machine learning algorithm (much like a neural network), and it can take the algorithm a very long time to
converge on a solution. The amount of time depends on the number of channels, the noise level of the data, and the speed of your
computer. It took over 5 minutes to reach a solution for this dataset on my laptop. If you don’t want to wait for it to finish, you can
kill the process by clicking the Interrupt button that should be visible while ICA is running. If that doesn’t work, you can usually
kill a Matlab process by typing Ctrl-C.
If you waited for it to finish, you should change the name of your dataset to indicate that ICA weights have been added to it. You
can do this with EEGLAB > Edit > Dataset info. You can just add _rawICAweights to the name of the dataset and click OK. If
you didn’t wait for the process to finish, you can just load the dataset named 10_MMN_preprocessed_rawICAweights.set, which
has the ICA weights that I got when I ran the decomposition.
An easy way to see that the ICA weights have been added is to type EEG in the Matlab command window. It will show you the
contents of the current EEG structure, and you can see that the fields beginning with ica are now filled:
icaact: [31×157184 single]
icawinv: [31×31 double]
icasphere: [31×31 double]
icaweights: [31×31 double]
icachansind: [1×31 double]
ICA decomposes the EEG data into a set of independent components or ICs. These are statistically defined components, not
necessarily ERP components, and they may not be biologically meaningful. I will refer to them as ICs rather than as components to
maintain this important distinction.
Each IC is a spatial filter. When we apply an IC to the distribution of voltages over the scalp at a given moment in time, the output
is the magnitude of that IC at that moment in time. Conveniently, ICA creates scalp maps of the ICs showing how each channel is
weighted by the IC. Take a look at the scalp maps now by selecting EEGLAB > Tools > Inspect/label components by map. (You
can also view the maps with EEGLAB > Plot > Component Maps). You should see something like Screenshot 9.2.
9.2.2 https://socialsci.libretexts.org/@go/page/87975

<!-- source_pdf=Full.pdf pdf_page=246 source_page_label="9.2.3" source_url="https://socialsci.libretexts.org/@go/page/87975" -->

## PDF page 246

- Source page label: 9.2.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87975

Screenshot 9.2
If you didn’t let the component decomposition process finish but instead loaded the file that already had the weights in it, the scalp
maps you see should look exactly like those in the screenshot. However, if you ran the component decomposition process yourself,
the maps might look a little different. This is because the ICA machine learning algorithm contains some randomization and
therefore doesn’t yield exactly the same results every time. If things are working well, then the results should be similar if you
repeat the decomposition process multiple times. If you get very different results, then something is wrong (usually either very
noisy data, not enough data, or a linear dependency among your channels).
There are some things that may differ across repetitions that don’t indicate a problem. First, the ordering of the ICs might change a
little. For example, the scalp maps for ICs 13 and 14 might be swapped in your data. Second, there might be small changes in the
weights for a given scalp map. Third, the polarity of the scalp maps might be inverted (which we will discuss in more detail later).
These are normal and no cause for concern. However, if you see radically different maps, then something is wrong.
Notice that there are 31 ICs. This is because we gave the algorithm data from 31 channels. Ordinarily, the number of ICs is equal to
the number of channels. This is necessary to make the math work. But it indicates an important way in which ICA is an imperfect
method for identifying the true components underlying your data. The number of channels that you record from determines the
number of ICs, but putting more or fewer electrodes on the scalp doesn’t change the number of sources of brain activity!
When the decomposition algorithm finishes, it reorders the components in terms of the amount of variance in the data they account
for, with IC 1 accounting for the greatest variance. If the participant blinked frequently, the IC corresponding to the blinks is
usually in the top five ICs (and often IC 1). In our current example, IC 1 has the kind of far frontal scalp distribution that you’d
expect for a blink. But is this really a blink IC, or is it some other kind of artifact, or maybe even frontally distributed brain
activity?
There are a few things we can check to determine whether IC 1 reflects blinks. If you click the number above IC 1, a new window
will pop up showing you more details about this IC. In the upper right of the window, you’ll see a heat map showing how the
magnitude of this IC varies over time. The X axis is time within a “trial” (which are arbitrary time periods when continuous data
are used). The Y axis is time over the course of the recording. It’s labeled Trials but actually corresponds to time in continuous
data. You can see many small red blobs. Each of those is a brief time period in which the magnitude of IC 1 was large. This is
exactly what we’d expect for blinks: many brief blips of voltage. The window also shows the frequency spectrum. The spectrum
9.2.3 https://socialsci.libretexts.org/@go/page/87975

<!-- source_pdf=Full.pdf pdf_page=247 source_page_label="9.2.4" source_url="https://socialsci.libretexts.org/@go/page/87975" -->

## PDF page 247

- Source page label: 9.2.4
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87975

for IC 1 shows a gradual decline as the frequency increases, which is also characteristic of blinks (but is also seen for many types
of non-blink activity).
Screenshot 9.3
The next thing you can do (which I find the most informative) is to directly compare the time course of IC 1 with the time course of
the EEG and EOG signals. Start by selecting EEGLAB > Plot > Channel data (scroll) to show the time course of the EEG and
EOG signals. While that window is still open, select EEGLAB > Plot > Component activations (scroll). Then arrange the
windows above and below each other as shown in Screenshot 9.4 (which is set to show 10 seconds per screen). Now you can look
at how IC 1 activation varies over time and compare it to the EOG and EEG signals at the corresponding time points. Try scrolling
through both windows to see whether IC 1 corresponds to the VEOG-bipolar signal. You may want to display only ~6 channels in
each plotting window so that you can see these signals better.
9.2.4 https://socialsci.libretexts.org/@go/page/87975

<!-- source_pdf=Full.pdf pdf_page=248 source_page_label="9.2.5" source_url="https://socialsci.libretexts.org/@go/page/87975" -->

## PDF page 248

- Source page label: 9.2.5
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87975

Screenshot 9.4
The first thing to notice is that each blink that you can see in the VEOG-bipolar channel is accompanied by a deflection with the
same shape in IC 1 (e.g., at 2.2 and 4.4 seconds). You should also notice that there are occasional step-like deflections in both
VEOG-bipolar and IC 1. These are vertical eye movements. Often, but not always, blinks and vertical eye movements will be
captured by the same IC. Given the scalp distribution of IC 1 and its close correspondence in time with the blinks and eye
movements in the VEOG-bipolar channel, we can be quite sure that this IC reflects vertical EOG activity.
Now let’s remove IC 1 from the EEG/EOG data to eliminate the blinks and vertical eye movements. Ordinarily, we would also
remove other artifact-related ICs at this point (e.g., horizontal eye movements), but we’ll just focus on blinks and vertical eye
movements for now. To do this, select EEGLAB > Tools > Remove components from data, put 1 in the window labeled List of
component(s) to remove from data so that we remove activity corresponding to IC 1, and click OK. You’ll then see a
confirmation window. Click the button in this window for plotting single trials. You should see something like Screenshot 9.5 (but
I’ve told it to display the top 10 channels and show a 10-second time period). The blue waveform shows the original data and the
red waveform shows what the data will look like after removing IC 1.
9.2.5 https://socialsci.libretexts.org/@go/page/87975

<!-- source_pdf=Full.pdf pdf_page=249 source_page_label="9.2.6" source_url="https://socialsci.libretexts.org/@go/page/87975" -->

## PDF page 249

- Source page label: 9.2.6
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87975

Screenshot 9.5
You can see that the algorithm has done a good job of eliminating the blinks and vertical eye movements. For example, the blinks
at 2.2 and 4.4 seconds are now gone, and there is no longer a sudden step in voltage at 5.7 seconds. There are also some slower
differences between the corrected and uncorrected data, which probably represent sustained changes in the vertical EOG
corresponding to changes in eye or eyelid position.
Now click the ACCEPT button in the confirmation window, and use 10_MMN_preprocessed_rawICAweight_pruned as the
dataset name. Next, plot the new dataset with EEGLAB > Plot > Channel data (scroll). You’ll see that the blinks are now gone
from all channels, except for the VEOG-bipolar and HEOG-bipolar channels. We excluded those channels from ICA, and now we
can use them to see when the blinks were in the original data. You can still see blinks at 2.2 and 4.4 seconds in the VEOG-bipolar
channel, but the blink activity has been removed from the other channels.
If you think about it, this is something of a miracle. We’ve mathematically eliminated the contribution of blinks and vertical eye
movements to the EEG at every single time point. But did this help us address the three types of problems caused by artifacts that
were discussed in Chapter 8? The next exercise shows how to answer this question.
This page titled 9.2: Exercise- A First Pass at ICA-Based Blink Correction is shared under a CC BY 4.0 license and was authored, remixed, and/or
curated by Steven J Luck directly on the LibreTexts platform.
9.2.6 https://socialsci.libretexts.org/@go/page/87975

<!-- source_pdf=Full.pdf pdf_page=250 source_page_label="9.3.1" source_url="https://socialsci.libretexts.org/@go/page/87976" -->

## PDF page 250

- Source page label: 9.3.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87976

9.3: Exercise- Evaluating the Impact of Artifact Correction
One of our goals for artifact rejection and correction is to reduce noise that would otherwise decrease the data quality in our
averaged ERPs. Another goal is to minimize the confounds that happen when the artifacts differ across groups or conditions. To
evaluate these issues, we need to calculate the SME values and the averaged ERP waveforms for the corrected data, compare them
with the original data, and compare them with the data after applying artifact rejection. I’ve done all this and provided the ERPsets
in the Chapter_9 folder. Go ahead and load these three ERPsets (10_MMN_uncorrected, 10_MMN_rawblinkcorrection, and
10_MMN_blinkrejection).
 Creating the ERPsets
If you want to create these ERPsets yourself, you’ll need to add an EventList to the dataset, run BINLISTER (using
BDF_MMN.txt), and epoch the data. You’ll need to do this once for the original data (prior to correction) and once for the new
dataset in which IC 1 was removed. And for the original uncorrected data, you’ll want to have two versions, one with artifact
detection (step-like artifacts, threshold = 50) and one without artifact detection. This will allow you to make three ERPsets, one
without correction or rejection, once with correction only, and one with rejection only. Make sure to customize the data quality
parameters to add a window of 125-225 ms.
Now plot the ERP waveforms for each ERPset. To make them comparable, uncheck the auto y-scale box and put -12 12 in the Y
range text box before plotting. The results for several key channels are summarized in Figure 9.2.
Figure 9.2. Averaged ERP waveforms from Subject 10 in the ERP CORE MMN experiment without any correction or rejection
(A), after correcting for blinks by removing IC 1 (B), and after rejecting trials containing blinks (C). Note that the VEOG-bipolar
channel was excluded from artifact correction in (B) and was therefore identical to (A).
Large differences between standards and deviants can be seen in the Fp2 and VEOG channels when nothing was done to deal with
the blinks (Figure 9.2.A). You can see a polarity reversal of the deviance effect between the Fp2 and VEOG-lower channels,
consistent with blink activity. That was also true for Subject 1 in the previous chapter (see Figure 7.2.A), although the specific
pattern was different. The finding of different blink-related activity for standards and deviants indicates that blinks are a confound
that we need to eliminate.
The blink-related voltage deflections were eliminated by both artifact correction rejection. Note, however, that the VEOG-bipolar
channel was excluded from correction, so the large deflections remain in this channel. Following both correction and rejection, the
voltage is more negative for deviants than for standards in FCz in the 125-225 ms time range, which is our primary measure of the
MMN. This effect was larger when no rejection or correction was performed, so part of this effect may have been coming from the
blink activity that we can see during this time range in the Fp2 and VEOG electrodes. This provides even more evidence that we
need to deal with the blinks to avoid confounding our measure of brain activity with blink activity (or vertical eye movements).
9.3.1 https://socialsci.libretexts.org/@go/page/87976

<!-- source_pdf=Full.pdf pdf_page=251 source_page_label="9.3.2" source_url="https://socialsci.libretexts.org/@go/page/87976" -->

## PDF page 251

- Source page label: 9.3.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87976

When artifact correction was performed, the difference between standards and deviants at Fp2 and VEOG-lower was largely
eliminated. However, some difference remained in these channels when artifact rejection was performed. Which of these reflects
the true pattern of brain activity? It’s difficult to be certain on the basis of these waveforms. However, given that the MMN appears
to be generated primarily in the supratemporal plane (Näätänen & Kreegipuu, 2012), it should be substantially larger at FCz than at
Fp2, and it should not invert in polarity between Fp2 and VEOG-lower (when referenced to P9/P10). I therefore suspect that some
ocular activity escaped rejection (most likely vertical eye movements, which may fail to reach the 50 µV threshold for rejection
that I used for detecting blinks). As a result, it seems likely that correction brought us “closer to the truth” than rejection in this
particular case. And that’s our ultimate goal!
It's also important to assess the impact of correction and rejection on data quality. For each of the three ERPsets, you should display
the data quality measures in a table. Let’s focus on the aSME values for FCz from 125-225 ms. For both the deviants (Bin 1) and
the standards (Bin 2), the aSME was worst (highest) for the data without correction or rejection (Bin 1 = 0.9774, Bin 2 = 0.5688),
and was improved (reduced) by rejection (0.8338, 0.5360), and was improved even more by correction (0.7802, 0.4523). This
pattern makes sense because both rejection and correction minimize the uncontrolled variation produced by the blinks, but rejection
reduces the number of trials whereas correction does not.
From these results, correction seems to be the better method for this particular participant in terms of both minimizing ocular
confounds and maximizing data quality. That fits with my experience: When implemented correctly, ICA-based artifact correction
tends to be better than rejection for dealing with blinks. And sometimes the difference is quite large, especially when a large
number of trials would need to be rejected.
However, we didn’t really implement correction very well in this example. When ICA is working properly, the scalp maps of most
of the ICs should look like nice gradual gradients with a unipolar pattern (a single positive or negative focus, like IC 1 in
Screenshot 9.2) or a dipolar pattern (opposing positive and negative focus, like IC 7 in Screenshot 9.2). Scalp distributions that
cover the entire head (like IC 2) or are complex and irregular (like ICs 19, 26, and 30) are a problem. They don’t resemble the
topography we’d expect for brain activity or common artifacts, and they’re a sign that multiple sources are being mixed together
rather than being separated. A few such maps are okay, especially in the latter ICs that don’t account for much variance. But you
really don’t want to see a map like IC 2 in the top half of the ICs. In a later exercise, we’ll see how to improve the ICA
decomposition (and make it faster as well). First, however, we need to discuss how ICA works.
This page titled 9.3: Exercise- Evaluating the Impact of Artifact Correction is shared under a CC BY 4.0 license and was authored, remixed,
and/or curated by Steven J Luck directly on the LibreTexts platform.
9.3.2 https://socialsci.libretexts.org/@go/page/87976

<!-- source_pdf=Full.pdf pdf_page=252 source_page_label="9.4.1" source_url="https://socialsci.libretexts.org/@go/page/87977" -->

## PDF page 252

- Source page label: 9.4.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87977

9.4: Background- A Quick Conceptual Overview of ICA
The online supplement to Chapter 6 in Luck (2014) provides a conceptual overview of how ICA works in general and how it is
applied to artifact correction. Here I’ll provide a quick summary. Several different algorithms are available for performing the ICA
decomposition. For the vast majority of cases in which ICA is used for artifact correction, there aren’t big differences among the
algorithms, so here I’ll focus on EEGLAB’s default ICA algorithm (Infomax, implemented with the runica routine).
The first thing you should know is that ICA is purely a statistical technique, and it was not developed for neural data per se. It
knows nothing about brains or electricity. It doesn’t know that the data are coming from electrodes or where the electrodes are
located. Most ICA algorithms don’t even know or care about the order of time points. They just see each time point as a set of N
abstract variables, one for each of the N channels. Infomax uses a machine learning algorithm (much like a neural network) that
learns a set of N ICs that are maximally independent when applied to the data.
By maximally independent, I mean that the activation level of one IC provides no information about the activation levels of the
other ICs at that time point. For example, if the blink-related voltage level at each time point does not predict other sources of
activity at the same time point, blinks will likely be extracted as a separate IC. However, it’s not a problem if blink activity at one
time point predicts activity from other sources at earlier or later time points.
ICA learns an unmixing matrix, which converts the EEG data at a given time point to the activation level of each IC. The inverse of
the unmixing matrix is the mixing matrix, which is just the scalp distribution of each IC. You can also think of the scalp distribution
of an IC as a set of weights. The voltage produced by an IC in a given channel at a given time point is the activation level of the IC
at that time point multiplied by the weight for that channel. Some randomness is applied to the learning algorithm, so you won’t
end up with exactly the same set of ICs if you repeat the decomposition multiple times.
An important practical consideration is that the machine learning routine needs a lot of data to adequately learn the ICs. The
EEGLAB team has provide an informal rule for this, which is that the number of time points in the dataset must be at least 20 x (#
channels)2. It’s probably the number of minutes of data that matters rather than the number of time points, but the key thing to note
is that the number of channels is squared. This means that doubling the number of channels requires four times as much data. For
example, you would need four times as many minutes of data for a 64-channel recording as for a 32-channel recording (and sixteen
times as much data for a 128-channel recording as for a 32-channel recording).
ICA is somewhat like principal component analysis (PCA). However, whereas PCA tries to lump as much variance as possible into
the smallest number of components, ICA tries to make the components maximally independent. ICA is also like PCA insofar as it
just takes the dataset and represents it along a different set of axes. You can go from the original data to the ICA decomposition
with the unmixing matrix, and then you can apply the mixing matrix to the ICA decomposition and perfectly recover the original
data.
This decomposition-and-recovery sequence is how ICA corrects for artifacts. After running the ICA decomposition to get the ICs,
you simply set one or more of the ICs to have an activation of zero at each time point and then use the mixing matrix to recover the
original data (but without the artifactual ICs). This means that ICA influences your data at every single time point. When you
remove a blink IC, ICA doesn’t just find time periods with blinks and correct the data during those time periods. It reconstructs
your EEG data at every time point, but with the artifactual ICs set to zero. There will be some nonzero activity in the blink IC at
each time point, so zeroing this IC at each time point means that the data will be changed at least slightly at every time point. This
is actually good, because there may be quite a lot of EOG activity between blinks as a result of small changes in eye rotation or
eyelid position, and ICA will remove this non-neural activity when you remove the IC corresponding to blinks.
ICA makes several important assumptions (see Luck, 2014), but two are particularly important to know about. The first is that the
scalp distribution of a given source of activity must remain constant over the entire session. For example, we can assume that the
locations of the eyes relative to the electrode sites will not change over the course of a session (unless there is some kind of
catastrophe), so blinks and eye movements meet this criterion. Similarly, the location of the heart relative to the electrodes doesn’t
change over time, so the EKG artifact also meets this criterion. However, the scalp distribution produced by skin potentials will
depend on which sweat pores are activated, which may change over time, so skin potentials do not meet this assumption. By the
way, this assumption means that you must perform ICA separately for each participant (because the scalp distributions will differ at
least slightly across participants).
9.4.1 https://socialsci.libretexts.org/@go/page/87977

<!-- source_pdf=Full.pdf pdf_page=253 source_page_label="9.4.2" source_url="https://socialsci.libretexts.org/@go/page/87977" -->

## PDF page 253

- Source page label: 9.4.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87977

There is dispute in the literature about whether ICA works well with EMG. The argument against using ICA with EMG is that
different muscle fibers may contract at different time points, changing the scalp distribution. The argument for using ICA is that the
scalp distribution does not actually change very much over time. To be on the safe side, my lab doesn’t use ICA for EMG. We
minimize EMG by having participants relax during the EEG recording, and we can filter out the remaining EMG so that it has
minimal impact on our results. However, if you cannot avoid having a lot of EMG in your data, and you can’t filter it out without
creating other problems (e.g., because you’re looking at high-frequency ERP activity), you can read the literature and decide for
yourself whether the benefits of using ICA for EMG outweigh the costs.
A second key assumption of ICA is that the number of true sources of activity is equal to the number of channels. This is related to
the fact that the number of ICs must be equal to the number of channels in order for the math to work.
 Exceptions Make the Rule
There are occasional exceptions to the rule that the number of ICs is equal to the number of channels, particularly when you
are using the average of all sites as the reference. See Makoto’s Preprocessing Pipeline or EEGLAB’s ICA documentation for
details.
As I mentioned earlier, the fact that the number of ICs must equal the number of channels means that ICA is an imperfect method.
You don’t change the number of sources of activity when you add or subtract electrodes! Also, there will always be more sources of
activity in the EEG signal than there are channels (because each synapse in the brain is a potential source of activity). As a result,
ICA will lump multiple true components into the same IC. In addition, a single true source may also be split among multiple ICs.
So, you will definitely have lumping of true components, and you will likely have some splitting as well.
Given the failure of EEG data to meet this second assumption, you may wonder whether it is valid to use ICA for artifact
correction. As famously noted by the statistician George Box, all statistical models are wrong, and the question is not whether they
are correct but whether they are useful (Box, 1976). In practice, ICA is useful for correcting some kinds of artifacts despite the
invalid assumptions. The saving grace of ICA is that the lumping and splitting problems are minimal for components that account
for a lot of variance (e.g., components that are both large and frequently occurring). Most participants blink a lot, and blinks are
very large, so ICA typically works very well for blinks. Depending on the experiment and the participant, eye movements can be
large or small and they can be frequent or rare. In my experience, ICA works only modestly well for eye movements, and it can’t
correct for the change in sensory input produced by the change in gaze position, so we only use ICA to correct for eye movements
when necessary. However, I recently came across a nice paper by Dimigen (2020) showing that ICA can work quite well for large
and frequent eye movements when the right preprocessing steps are applied prior to the ICA decomposition (as I’ll discuss in more
detail later). Drisdelle et al. (2017) also provide evidence that ICA can work well for eye movements in certain types of paradigms.
ICA can be applied either to continuous or epoched EEG. When my lab first started using ICA many years ago, I emailed Scott
Makeig and Arnaud Delorme to get their advice, and they recommended applying it to the continuous EEG. They still give this
advice today in the EEGLAB documentation. You can apply ICA to epoched data if necessary, but the epochs must be at least 3
seconds long (e.g., -1000 to +2000 ms). Adjacent epochs cannot contain the same data points, so this means that you must have
relatively long trials for this approach to work. If you get your pipeline set up properly (see Chapter 11 and Appendix 3), there isn’t
any reason why you’d need to apply ICA to epoched data, so my view is that the safest thing to do is to apply it to the continuous
data. As described in the text box below, there may also be a practical advantage.
 A Practical Advantage
Over the years, we’ve found a significant practical advantage to doing ICA at the earliest possible stage of EEG preprocessing
(which means applying to continuous EEG, because epoching is a relatively late stage). Specifically, ICA is a time-consuming
process that you don’t want to repeat if you can possibly avoid it. If you need to change some of your processing steps after
you’ve already analyzed your data once, putting ICA at the earliest possible stage minimizes the likelihood that this change
will require repeating the ICA.
The ICA decomposition process typically takes somewhere between 2 minutes and 2 hours depending on the nature of your
data and your computer. If you need to process data from 30 participants, this is now between 60 minutes and 60 hours. That
can be done overnight while you’re asleep, but another 2-20 minutes of human effort are required for each participant to make
9.4.2 https://socialsci.libretexts.org/@go/page/87977

<!-- source_pdf=Full.pdf pdf_page=254 source_page_label="9.4.3" source_url="https://socialsci.libretexts.org/@go/page/87977" -->

## PDF page 254

- Source page label: 9.4.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87977

sure that the decomposition has worked properly and to determine which ICs should be removed. That’s 60 to 600 minutes of
your precious time.
What’s the likelihood that you will need to re-process your data? In my experience, the likelihood is close to 100%! Reviewers
always seem to want some change (or some secondary analysis). And when you’re new to ERP analysis, you’re likely to do
something that is less than optimal and will require a re-analysis. But if you’ve done the artifact correction at the earliest
possible point in your processing pipeline, chances are good that you won’t need to repeat this time-consuming part of your
pipeline.
A key step in ICA-based artifact correction is to determine which ICs correspond to artifacts and should be removed. There are
automated algorithms for this, but I recommend doing it manually for the vast majority of studies. As you will see, you need to
carefully determine whether a given IC should be removed, which requires taking into account the three underlying goals of artifact
rejection and correction, and this often goes beyond what an algorithm can do.
ICA-based artifact correction massively changes your data, and we know we are violating at least one of its assumptions, so I
recommend being conservative in using it. We almost always use it for blinks, and we sometimes use it for eye movements, but we
don’t ordinarily use it for other kinds of artifacts. If we frequently encountered large EKG artifacts, we’d probably use ICA for
those as well. Some labs use ICA for anything that looks “weird”, but I personally don’t like that approach. There are other ways of
dealing with these other types of artifacts, and I just don’t trust an algorithm to solve every problem in my data.
Finally, don’t forget Hansen’s Axiom: There’s no substitute for good data. Do everything you can to minimize artifacts during the
recording, and then you won’t end up getting an ulcer from worrying about how to deal with a ton of artifacts during the analysis.
This page titled 9.4: Background- A Quick Conceptual Overview of ICA is shared under a CC BY 4.0 license and was authored, remixed, and/or
curated by Steven J Luck directly on the LibreTexts platform.
9.4.3 https://socialsci.libretexts.org/@go/page/87977

<!-- source_pdf=Full.pdf pdf_page=255 source_page_label="9.5.1" source_url="https://socialsci.libretexts.org/@go/page/87978" -->

## PDF page 255

- Source page label: 9.5.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87978

9.5: Exercise- Making ICA Work Better
Our first attempt at ICA-based blink correction was quite simplistic, and as a result the decomposition was not very good (as
evidenced by the irregularly shaped scalp maps for some of the ICs in Screenshot 9.2). The main reason for this is that our dataset
(like most EEG datasets) contains some really large activity that is difficult for ICA to handle because it is either infrequent or lacks
a consistent scalp distribution (e.g., skin potentials). In this exercise, we’ll look at an approach that will minimize the effects of
those large noise sources and also make the decomposition run faster. It’s a win-win!
There are several steps for making the ICA decomposition work better. Some of them are based on a trick, which is to create a new
dataset in which we’ve removed signals that will be problematic for ICA, do the decomposition on this new dataset, and then
transfer the ICA weights back to the original dataset. This approach was controversial when I wrote my other book, so I didn’t
recommend it in Chapter 6 of Luck (2014). However, the field has largely converged on the idea that this approach is both
theoretically justified and practically useful.
The first thing we’re going to do is heavily filter the data, using filter settings that I would never ordinarily use for ERP
experiments. However, the filtered data will be used only to do the ICA decomposition, and then we’ll transfer those ICA weights
to the original data.
 Why Heavy Filtering is OK for the ICA Decomposition
Filters change the time course of an underlying IC, but not the scalp distribution, Heavy filtering is therefore fine for the data
used for the ICA decomposition, because we only care about scalp distributions at this stage, not the timing. Once we have the
IC weights, we’ll transfer them back to the original data without the temporal distortion caused by the filtering.
To get started, quit and restart EEGLAB and then load the original dataset for Subject 10 (10_MMN_preprocessed). Select
EEGLAB > ERPLAB > Filter & Frequency Tools > Filters for EEG data, specifying a high-pass cutoff of 1 Hz and a low-pass
cutoff of 30 Hz, with a slope of 48 dB/octave. Run the routine and save the resulting dataset as 10_MMN_preprocessed_filt.
We’ve now eliminated most of the skin potentials and EMG, both of which may violate the assumptions of ICA and interfere with
the decomposition.
Our next step is to downsample the data to 100 Hz. This just makes the ICA decomposition run faster (as does the reduction of
noise produced by the filtering). To do this, select EEGLAB > Tools > Change sampling rate, enter 100 as the new sampling rate,
and then name the resulting dataset 10_MMN_preprocessed_filt_100Hz.
The next thing we’re going to do to improve ICA is remove the segments of data during breaks, when the participants may be
moving, scratching their heads, chewing, etc. The voltages produced by these actions are typically large but don’t have a consistent
scalp distribution. EEGLAB allows you to manually select and delete these time periods from a continuous dataset. ERPLAB adds
an automated procedure for this. It just finds periods of time without any event codes and deletes them. Let’s give it a try.
Select EEGLAB > ERPLAB > Preprocess EEG > Delete Time Segments (continuous EEG). In the window that appears,
specify 1500 as the Time Threshold. This tells the routine to delete segments in which there are no event codes for at least 1500
ms. The event codes in the MMN experiment occur every ~500 ms, so periods of 1500 ms without an event code must be breaks.
Of course, you’d need to use a longer value for experiments with a slower rate of stimuli. Also specify 500 as the amount of time
prior to the first event code in a block of trials. This will make sure that we have at least 500 ms for the prestimulus baseline period
for the first event in a trial block. Similarly, specify 1500 ms as the time period after the last event code in a block so that we have a
good period of data following this event code.
Enter 1 in the field for Eventcode exceptions. This tells the routine to ignore this event code. Our stimulus presentation program
sent some event codes with a value of 1 during the breaks, and we want those to be ignored when looking for break periods.
Similarly, check the box for ignoring boundary events. Boundary events occur whenever there is a temporal discontinuity in the
data. Most commonly, this happens when you have a separate data file for each block and then concatenate them together into a
single file. When you do this, a boundary event is inserted at the time point of the transition between one block and the next.
Boundary events often occur during breaks, so we want them to be ignored when we’re looking for long periods between event
codes. Make sure the Display EEG button is checked and click RUN.
9.5.1 https://socialsci.libretexts.org/@go/page/87978

<!-- source_pdf=Full.pdf pdf_page=256 source_page_label="9.5.2" source_url="https://socialsci.libretexts.org/@go/page/87978" -->

## PDF page 256

- Source page label: 9.5.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87978

You’ll then see two new windows, one for displaying the EEG dataset and one for saving the new dataset. If you scroll through the
data, you’ll see a red background for the first ~25 seconds and the last ~3 seconds, which are the break periods at the beginning and
end of the trial block (we have only one trial block in this experiment). These are the time periods that will be deleted. You should
always verify that it worked correctly, and then you can save the new dataset as 10_MMN_preprocessed_filt_100Hz_del.
Finally, we’re going to deal with bad channels. F7 and PO4 both show some crazy behavior in this dataset. If we leave them in the
data, we’ll end up with an IC that just represents F7 and another that just represents PO4. In fact, you can see this in our original
ICA decomposition in Screenshot 9.2, where IC 3 just represents the F7 channel and IC 17 just represents the PO4 channel. We’re
going to interpolate these channels eventually, so why include them in the ICA decomposition? We could interpolate them prior to
the ICA decomposition, but that might create a linear dependency among the channels that would mess up the decomposition.
Instead, we’ll just exclude them from the ICA decomposition process, and then we can interpolate them after artifact correction is
complete.
Now let’s apply the ICA decomposition to this dataset by selecting EEGLAB > Tools > Decompose data by ICA. We’re going to
exclude Channels 3 and 24 (the channels for F7 and PO4, respectively), and we’re also going to exclude Channels 32 and 33 (the
bipolar EOG channels). To do this, type 1 2 4:23 25:31 into the Channel type(s) or indices field. As before, make sure to use
runica as the ICA algorithm and that 'extended', 1 is specified in the field for options (see the EEGLAB ICA documentation for an
explanation of this option). Then run the routine. If you don’t want to wait for it to finish, you can just load the dataset I created
after running the decomposition, named 10_MMN_preprocessed_filt_100Hz_del_ICAweights.
Once you have the weights, you can view the results with EEGLAB > Tools > Inspect/label components by map. The result I
obtained in shown in Screenshot 9.6 (your results may differ slightly, especially the ordering and polarity of the ICs). These maps
are much nicer than our original maps (Screenshot 9.2). Almost all have either a single focus with a largely monotonic decline (e.g.,
IC 1 and IC 2) or a bipolar configuration (e.g., IC 13 and IC 15). IC 20 has two foci that are approximately mirror-symmetric
across the left and right hemispheres, which is also a perfectly normal pattern (and arises when the two hemispheres operate
synchronously). The only irregular map is for IC 29. Because the maps are ordered according to the amount of variance they
explain, you shouldn’t worry if the last couple of maps aren’t perfect.
Screenshot 9.6
9.5.2 https://socialsci.libretexts.org/@go/page/87978

<!-- source_pdf=Full.pdf pdf_page=257 source_page_label="9.5.3" source_url="https://socialsci.libretexts.org/@go/page/87978" -->

## PDF page 257

- Source page label: 9.5.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87978

This page titled 9.5: Exercise- Making ICA Work Better is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven
J Luck directly on the LibreTexts platform.
9.5.3 https://socialsci.libretexts.org/@go/page/87978

<!-- source_pdf=Full.pdf pdf_page=258 source_page_label="9.6.1" source_url="https://socialsci.libretexts.org/@go/page/87979" -->

## PDF page 258

- Source page label: 9.6.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87979

9.6: Exercise- Transferring the Weights and Assessing the ICs
Our goal in heavily filtering the data was to improve the ICA decomposition, but as was described in the chapter on filtering, this
kind of filtering is usually a bad idea for ERP analyses. So, we’re going to take our optimized ICA decomposition and transfer the
weights to the original dataset, which has not been distorted by filtering. To do this, first look at the Datasets menu in EEGLAB
and note the dataset number for the dataset containing the ICA weights (10_MMN_preprocessed_filt_100Hz_del_ICAweights).
It’s probably #4, but it might be something else if you’ve done some other processing. Now select the original dataset
(10_MMN_preprocessed) in the Datasets menu and then select EEGLAB > Edit > Dataset info. In the new window that
appears, click the From other dataset button for the ICA weights array, and enter the number for the dataset with the ICA
weights (probably 4). Also change the Dataset name to 10_MMN_preprocessed_transferredICAweights, and then click OK.
That’s it! You’ve now transferred the weights. You might want to save this dataset to your disk with EEGLAB > Files > Save
current dataset as.
You can verify that the weights have been transferred by selecting EEGLAB > Tools > Inspect/label components by map (but
first close the window you created with this routine in the previous exercise, if it’s still open). You should see the same maps as in
the previous exercise (Screenshot 9.6), because you transferred those weights to the current dataset.
Now let’s compare the time course of the ICs (EEGLAB > Plot > Component activations (scroll)) with the time course of the
EEG and EOG data (EEGLAB > Plot > Channel data (scroll)). You can see that the time course of IC 1 closely matches the time
course of the blinks and vertical eye movements in VEOG-bipolar. To the naked eye, there isn’t any obvious difference between IC
1 from this decomposition and IC 1 from our original decomposition (Screenshots 9.2-9.4). However, given that the decomposition
as a whole improved, IC 1 from our new decomposition is less likely to be contaminated by activity from other sources (less
lumping).
Now let’s see if we can figure out what’s going on with the other ICs and see if any of them should be removed along with IC 1.
Let’s start by looking for an IC related to horizontal eye movements. Go back to the plot of the scalp maps (Screenshot 9.6) and see
if any of the maps have the distribution you’d expect for horizontal eye movements (i.e., opposite-polarity foci just to the sides of
the two eyes). IC 13 looks promising, so click on the 13 above the scalp map for IC 13 (or the IC that has the right scalp
distribution if your maps don’t exactly match Screenshot 9.6). A new window will pop up to show the details of this IC. The time
course heatmap has a lot of activity at the beginning and end of the dataset, which is what we would expect if large eye movements
were most common during the break periods at the beginning and end of the session. (Note that we deleted the break periods in the
dataset used for the ICA decomposition, but we’ve now transferred the weights to the original dataset, which still has data during
the break periods. The same set of weights is used for every time point, so it’s not a problem to transfer weights to time points that
weren’t used in the ICA decomposition.)
Now go back to the scrolling time course plots for the ICs and EEG data and see if the time course of IC 13 matches the time
course of the horizontal eye movements in HEOG-bipolar. You might want to display only 6 channels and ICs at a time so that you
can see the eye movements better. Screenshot 9.7 shows the EOG data (top) and a few of the ICs (bottom) for the first 10 seconds
of the dataset. You can see a beautiful correspondence between IC 14 and HEOG-bipolar. And if you look closely at the other ICs,
none of them show the same pattern. ICA has clearly done a good job of isolating the horizontal eye movements with IC 13. We
should definitely consider removing IC 13 from the data.
9.6.1 https://socialsci.libretexts.org/@go/page/87979

<!-- source_pdf=Full.pdf pdf_page=259 source_page_label="9.6.2" source_url="https://socialsci.libretexts.org/@go/page/87979" -->

## PDF page 259

- Source page label: 9.6.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87979

Screenshot 9.7
Although none of the other ICs show the same pattern as the HEOG-bipolar channel, IC 3 has a sharp voltage spike at the onset
time of each shift in eye position. This is the spike potential shown in Figure 9.1, which is the muscle contraction that causes the
eyes to move. Given that the spike potential and the change in HEOG voltage are closely linked, you might wonder why they end
up in different ICs. The answer is that ICA tries to find ICs that are maximally independent at a given time point. The HEOG signal
is sustained, and the spike potential occurs only at the very beginning of the eye movement, so you often have a large HEOG
voltage with no spike potential. And the spike potential slightly precedes the HEOG change, so you can have a large spike potential
with HEOG. Consequently, they end up as different ICs. Note that the magnitude of the spike potential in the EEG/EOG recordings
varies considerably across participants, so you don’t always see a separate IC for it.
IC 4 has a midline centro-parietal focus and a broad scalp distribution, much like the P3b wave. However, the participants weren’t
doing a task in the MMN experiment, so we wouldn’t expect to see the P3b. If you scroll through the component activations and
EEG data, it’s hard to see any obvious correspondence between IC 4 and the EEG signals. Moreover, the power spectrum doesn’t
reveal a clear peak, so it doesn’t seem to be an oscillation. I really don’t know what IC 4 is.
IC 5, on the other hand, shows a clear peak at 10 Hz (which you can see by clicking on the 5 above the scalp map for IC 5). Also,
the scalp map has a strong focus at the occipital pole. Both of those are consistent with the classic alpha-band oscillation first
described by Hans Berger in his original EEG study (Berger, 1929). You can see some beautiful alpha bursts in both IC 5 and the
posterior EEG electrodes between 57 and 60 seconds.
IC 2 also has a clear peak in its power spectrum, but at approximately 7 Hz instead of 10 Hz. Its scalp map has a focus around Fz.
Given this power spectrum and scalp topography, this is probably the commonly-observed midfrontal theta oscillation. You can see
bursts of oscillatory activity in this IC at a variety of time points (e.g., 127-128 s, 219 s, 297-302 s, 401-403 s), and you can see
corresponding bursts of oscillations in the far frontal channels. However, the oscillation bursts sometimes occur simultaneously in
other ICs (e.g., at 127 s), and IC 2 also shows some transient (non-oscillating) activity, so I wouldn’t try to use this IC to isolate
midfrontal theta and then use it as a dependent variable.
Check out the rest of the ICs and see if you can figure out what they represent. You’ll see that some contain alpha-band activity,
like IC 5, but with somewhat different scalp topographies. This isn’t surprising given that alpha can be observed over different
cortical areas at different times. Many ICs have no obvious interpretation. IC 16 has a scalp distribution that is much like IC 1.
Blinks often appear in two or even three ICs, so you should take a close look at any IC that has a blink-like scalp map.
If you scroll through the component activations and EEG/EOG data, you’ll see that IC 16 exhibits a high-frequency burst at the
beginning of each blink, superimposed on a negative dip. This could be the EMG activity from the muscles that produce the blink.
However, the slower negative dip doesn’t seem like EMG, so IC 16 may be mixing EMG and EOG signals. It’s still blink-related,
so we’ll consider whether to exclude it in the next exercise.
9.6.2 https://socialsci.libretexts.org/@go/page/87979

<!-- source_pdf=Full.pdf pdf_page=260 source_page_label="9.6.3" source_url="https://socialsci.libretexts.org/@go/page/87979" -->

## PDF page 260

- Source page label: 9.6.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87979

Blink-related EOG activity is primarily a result of the eyelids sliding across the eyeballs, but there may also be a slight vertical
rotation of the eyeballs that produces a voltage. These two effects have similar but slightly different scalp distributions, so they may
appear as separate ICs (especially when you have 60 or more channels and therefore 60 or more ICs). In theory, the two eyelids
could start and stop moving at slightly different times, which might also produce separate ICs.
This page titled 9.6: Exercise- Transferring the Weights and Assessing the ICs is shared under a CC BY 4.0 license and was authored, remixed,
and/or curated by Steven J Luck directly on the LibreTexts platform.
9.6.3 https://socialsci.libretexts.org/@go/page/87979

<!-- source_pdf=Full.pdf pdf_page=261 source_page_label="9.7.1" source_url="https://socialsci.libretexts.org/@go/page/137623" -->

## PDF page 261

- Source page label: 9.7.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137623

9.7: Exercise- Deciding Which ICs to Exclude
IC 1 is clearly capturing most of the blink activity, and we established in the previous chapter that blinks are both a major source of
noise and a confound in the MMN experiment. It’s therefore clear that we should exclude this IC when we reconstruct the EEG
data from the ICs. But what about the other ICs?
To answer this question, we need to go back to the three issues described at the beginning of the previous chapter. First, does the
artifactual activity create substantial noise that degrades our data quality? Second, does the artifactual activity vary across groups or
conditions, creating a confound? Third, does the artifactual activity indicate a problematic change in the sensory input (e.g.,
because the direction of gaze has changed)? The third issue is mainly relevant for visual experiments, so we won’t worry about it
for the MMN.
In the chapter on artifact rejection, we addressed the issue of noise by looking at whether the SME was improved by rejection. We
addressed the issue of noise by looking at the averaged ERPs, especially when we inverted the artifact rejection process and
included only the trials that were marked for rejection. We can use the same two approaches with artifact correction.
We already assessed the effects of blink rejection and correction on the SME for our first pass at the ICA decomposition earlier in
this chapter, and we found that correction improved the SME. Now let’s assess the effects of correcting for horizontal eye
movements by excluding IC 13. Specifically, we'll compare excluding only blinks with excluding both blinks and horizontal eye
movements. First, make two copies of the dataset with our improved ICA decomposition
(10_MMN_preprocessed_transferredICAweights). Then apply EEGLAB > Tools > Remove components from data as in the
earlier exercise to remove the blink IC from one dataset and to remove both the blink and horizontal eye movement ICs from the
other dataset. You should then create averaged ERPs for these two datasets (which will require adding an EventList, running
BINLISTER, and epoching the data). Make sure to specify a custom data quality window of 125-225 ms. Before averaging, use
EEGLAB > ERPLAB > Preprocess EEG > Selective Electrode Interpolation to interpolate F7 and PO4 (Channels 3 and 24),
excluding the bipolar EOG channels (32 and 33).
If you look at the SME values for FCz in the 125-225 ms time range, you’ll see that eliminating the horizontal eye movement IC
had virtually no impact on the data quality. This is consistent with what we saw with artifact rejection in the previous chapter.
Horizontal eye movements just don’t have much impact on midline electrode sites, and most of the eye movements occurred during
the break periods.
We also need to consider whether the horizontal eye movements were a confound. With artifact rejection, we did this by making
averages from only the trials marked with artifacts. Here, we’ll conduct an analogous procedure, in which we reconstruct the data
only from the eye movement component (IC 13) and then make averaged ERPs. To do this, select the dataset with the transferred
weights (10_MMN_preprocessed_transferredICAweights), select EEGLAB > Tools > Remove components from data, leave
the List of component(s) to remove from data field blank, and enter 13 into the field labeled Or list of components to retain.
Name the resulting dataset 10_MMN_preprocessed_IC13only. If you scroll through this dataset, you’ll see how the eye
movement potentials spread to the other scalp sites (see, e.g., the highlighted time period in Screenshot 9.8.). These potentials are
largest at the lateral frontal electrodes but can also be seen at posterior scalp sites (e.g., P7 and P8). However, the positive and
negative sides of the dipole largely cancel out at the midline sites (e.g., Fz, FCz, Cz).
9.7.1 https://socialsci.libretexts.org/@go/page/137623

<!-- source_pdf=Full.pdf pdf_page=262 source_page_label="9.7.2" source_url="https://socialsci.libretexts.org/@go/page/137623" -->

## PDF page 262

- Source page label: 9.7.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137623

Screenshot 9.8
Now go through the steps needed to create averaged ERPs from this dataset, and then plot the resulting ERPs. You should see that
the EEG channels are essentially flat lines. (There is some activity in the bipolar channels, but these are the original waveforms, not
reconstructed from IC 13.) From these flat ERP waveforms, which should solely reflect the horizontal eye movements, we can
conclude that the horizontal eye movements were not a meaningful confound. In other words, the fact that the averaged ERPs were
largely flat in the EEG channels indicates that any horizontal eye movements were approximately equally likely to be leftward and
rightward, resulting in opposite-polarity EOG signals that canceled out in the averages. And the fact that there was no difference
between standards and deviants, especially at the key FCz site, indicates that there were no meaningful differences in horizontal
eye movements between standards and deviants that could confound our MMN results.
So, should we correct for the horizontal eye movements by excluding IC 13 when we reconstruct the EEG data? Probably not.
There is little to be gained, and given that ICA is imperfect and IC 13 may contain brain activity mixed with the horizontal eye
movements, we have more to lose than to gain. However, IC 13 didn’t produce much activity in the ERPs when we looked only at
this IC, so removing it will also have little impact. Before making a final decision about this, I would want to see how horizontal
eye movements impact the data in the other participants. If they’re generally not a problem, I would not correct for them. But if
they seem problematic (in terms of data quality and/or confounding activity) in several of the participants, I would probably correct
for them in all participants (for the sake of consistency).
We also need to consider whether to exclude IC 16, which has a blink-like scalp distribution and shows small deflections for each
blink. Repeat the series of steps you conducted for IC 13 but use IC 16 instead. That is, assess the SME values after excluding both
IC 16 and IC 1 with the SME values after excluding only IC 1, and then look at the averaged ERPs after reconstructing the data
9.7.2 https://socialsci.libretexts.org/@go/page/137623

<!-- source_pdf=Full.pdf pdf_page=263 source_page_label="9.7.3" source_url="https://socialsci.libretexts.org/@go/page/137623" -->

## PDF page 263

- Source page label: 9.7.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137623

from only IC 16. When I did this, I found that excluding both IC 16 and IC 1 led to a tiny improvement in SME compared to
excluding only IC 1, and I found a small but concerning difference between deviants and standards in FCz when the data were
reconstructed from IC 16. Given the small confound in the averaged waveforms, and the fact that we’ve already established that
blinks differ between deviants and standards, I would exclude IC 16 along with IC 1 in the final analyses.
You can also try this set of procedures with the component that represents the spike potential (IC 3).
Does this sound like a lot of work? It is! But if your goal is to publish a paper in a scientific journal, making a permanent
contribution to the scientific literature that others can build on, it’s worthwhile to take the time to deal with artifacts in a careful and
thoughtful manner. Also, the scripts provided at the end of the chapter show you how to make the process more efficient by
automating some parts of it.
This page titled 9.7: Exercise- Deciding Which ICs to Exclude is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
9.7.3 https://socialsci.libretexts.org/@go/page/137623

<!-- source_pdf=Full.pdf pdf_page=264 source_page_label="9.8.1" source_url="https://socialsci.libretexts.org/@go/page/137624" -->

## PDF page 264

- Source page label: 9.8.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137624

9.8: Exercise- Deleting C.R.A.P. Prior to ICA
In this exercise, we’re going to look at another type of large, idiosyncratic voltage deflection that should be eliminated prior to the
ICA decomposition, namely huge C.R.A.P. In particular, we want to get rid of voltage deflections that are sufficiently large to
impact the quality of the ICA decomposition but are sufficiently infrequent or irregular in their scalp distribution that they can’t be
well captured by a single IC.
The participant we’ve been working with so far, Subject 10, doesn’t really have any huge C.R.A.P., so we’re going to look at
Subject 6 for this exercise. Quit and restart EEGLAB, and the open the 6_MMN_preprocessed_filt_100Hz_del dataset. This
dataset has already been preprocessed to improve the ICA decomposition, including filtering from 1-30 Hz, resampling at 100 Hz,
and deletion of the break periods.
As usual, you should start by scrolling through the data to see what kinds of artifacts are present. In addition to the usual blinks and
eye movements, you’ll see some odd-looking voltage deflections at several time points, including 70, 72, 96, 254, 403, and 413
seconds. These deflections are somewhat like blinks, but much larger and with a different and variable scalp distribution. For
example, the deflection at ~70 seconds is present in Fp2 but not Fp1, and the deflection at ~72 seconds is huge in VEOG-lower and
smaller at Fp1 and Fp2, with no polarity inversion. I have no idea what caused these deflections, but they’re large, rare, and have an
inconsistent scalp distribution, so they’re likely to mess up the ICA decomposition.
To see this, let’s take a look at the ICA decomposition, which I did just as in the previous exercises (excluding the bipolar EOG
signals in Channels 32 and 33). Load the dataset I created with the decomposition
(6_MMN_preprocessed_filt_100Hz_del_ICAweights) and then look at the ICs using EEGLAB > Tools > Inspect/label
components by map. The IC maps are shown in Screenshot 9.9. (You can do the decomposition yourself if you’d like, but your
maps might look a little different.)
Screenshot 9.9
The first thing you should notice is that many of the maps are irregular, even in the top half of the ICs (e.g., ICs 6, 7, and 14).
That’s a strong hint that the decomposition did not work well. The next thing you should note is that IC 1 (which must account for a
lot of variance, because it’s the first IC) doesn’t have a scalp map that corresponds to a typical artifact or brain signal, with a
9.8.1 https://socialsci.libretexts.org/@go/page/137624

<!-- source_pdf=Full.pdf pdf_page=265 source_page_label="9.8.2" source_url="https://socialsci.libretexts.org/@go/page/137624" -->

## PDF page 265

- Source page label: 9.8.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137624

narrow focus at Fp2. Click on the 1 above the map for IC 1 to see its properties. The time course shows that it is strongly active
during a few brief time periods and not at other times. Again, that’s unusual.
Now look at IC 2 (and click on the 2 above the map to see its properties). It has the kind of scalp map we’d expect for blinks, and
the time course contains the kind of distributed bursts that we’d expect for blinks. But note that the weights in the scalp map are
negative, whereas we saw positive weights at the frontal sites for blink-related ICs in our previous exercises. This is because the
polarity of the IC maps is arbitrary, and a given IC may have either positive weights or negative weights. Just for fun, I repeated the
decomposition a second time, and I found that IC 2 had positive weights in this repetition of the decomposition. The polarity of the
weights in the maps is completely arbitrary, and the polarity of the activation values will also be reversed to come up with the right
voltage polarity when we reconstruct the data. So, reversals of map polarity are not a problem.
To see this, scroll through the IC activations using EEGLAB > Plot > Component activations (scroll). You’ll see that IC 2 has
negative deflections at the times of blinks, whereas we saw positive deflections for the blink IC in our previous examples (e.g.,
Screenshot 9.4). If we multiply the negative activation values by the negative weights for the frontal sites, we’ll get a positive
voltage. So, it doesn’t matter if we have positive weights along with positive activations or negative weights along with negative
activations. In either case, blinks will be reconstructed as a positive voltage at the frontal sites (but a negative voltage at VEOG-
lower).
Another thing you should notice in the IC maps is that there isn’t an IC with the scalp topography we’d expect for horizontal eye
movements. There were many clear horizontal eye movements in the HEOG-bipolar channel when we scrolled through the data,
but we haven’t captured these eye movements as a distinct IC in this decomposition. That also indicates that it didn’t work well.
Some participants don’t have many horizontal eye movements, and the lack of an IC for horizontal eye movements would not be a
problem for those participants.)
Now let’s try to improve the decomposition by deleting the time periods with the huge C.R.A.P. artifacts. Make
6_MMN_preprocessed_filt_100Hz_del the active dataset and select EEGLAB > ERPLAB > Preprocess EEG > Artifact
rejection (continuous EEG). This routine is like the moving window peak-to-peak amplitude routine for artifact detection that we
used in the previous chapter, but with two differences. First, it operates on continuous EEG rather than epoched EEG. Second, it
eventually deletes sections of the data with artifacts rather than simply marking them.
In the window that appears for this routine, enter 500 as the threshold. We’re not trying to reject blinks or other ordinary artifacts,
so we need a much higher threshold for this routine than we would use for normal artifact detection. 500 is a good starting
threshold, but you may need to adjust it for some participants. Enter 1000 for the moving window width and 500 as the step size.
This will cause it to look for 1000-ms time periods in which the peak-to-peak voltage exceeds the threshold, shifting the window in
500-ms increments. Finally, enter 1:31 for the channels. We’re going to exclude Channels 32 and 33 (the bipolar EOG channels)
when we do the ICA decomposition, so we don’t care about huge C.R.A.P. in these channels. (You might also want to exclude Fp1
and Fp2 if you have such large blinks in these channels that blinks end up exceeding the threshold for rejection.) Leave all the
check boxes unchecked, and click ACCEPT to run the routine.
When it finishes, you should see in the Matlab command window that the routine has found 15 segments of data to reject. At this
point, these segments have just been marked, but they will be deleted when we save the dataset. You should also see a window for
scrolling through the marked dataset. If you scroll through the data, you’ll see segments of data that are marked in yellow at ~70
and ~72 seconds (as well as at 96, 254, 403, and 413 seconds). These are the time periods where we saw the huge C.R.A.P., so the
artifact rejection routine is working well.
There’s one thing that’s a little odd, though, namely that we’ll delete the data from ~70-71 seconds and from ~71.5-73 seconds,
leaving just a 500 ms of unrejected data in the middle. The rejection routine has a feature for avoiding this kind of oddity. Let’s
give it a try. First, close the scrolling plot window and cancel the window for saving the dataset. Now select EEGLAB > ERPLAB
> Preprocess EEG > Artifact rejection (continuous EEG) again. Keep the parameters the same, but check the box labeled Join
artifactual segments separated by less than and put 1000 in the corresponding text box. This will cause any segments of <1000
ms between deleted segments to be deleted. Click ACCEPT to run the routine. Now you should see that a single continuous
segment from ~70-73 ms now has been marked for deletion instead of two separate but nearby segments.
To actually delete the marked segments, go to the window that appeared for saving the new dataset and save it with the default
name. Now go to EEGLAB > Plot > Channel data (scroll) and look at the result of the artifact rejection you just performed. If
9.8.2 https://socialsci.libretexts.org/@go/page/137624

<!-- source_pdf=Full.pdf pdf_page=266 source_page_label="9.8.3" source_url="https://socialsci.libretexts.org/@go/page/137624" -->

## PDF page 266

- Source page label: 9.8.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137624

you look at the 5-second period starting at 68 seconds, you’ll see that the artifactual activity at ~70 seconds is gone and has been
replaced with a boundary event, which has been inserted to mark the discontinuity in the data that was produced by deleting the
segment from ~70-73 seconds.
Note that you can also manually reject sections with huge C.R.A.P. using EEGLAB > Tools > Inspect/reject data by eye.
ERPLAB’s Artifact rejection (continuous EEG) routine is faster and more easily scriptable than the manual rejection routine, but
sometimes it’s useful to do it manually instead (or in addition). Just remember that your goal is to delete segments that will cause
problems for ICA, not to delete segments with ordinary artifacts. That is, you want to delete segments with voltage deflections that
are large and infrequent, especially if they have an inconsistent scalp distribution.
Now let’s see how deleting the huge C.R.A.P. has impacted the ICA decomposition. You can see the resulting decomposition by
loading the dataset named 6_MMN_preprocessed_filt_100Hz_del_car_ICAweights and then selecting using EEGLAB > Tools
> Inspect/label components by map. The scalp maps are shown in Screenshot 9.10.
Screenshot 9.10
The first thing to notice is that the scalp maps are more regular than those we obtained without deleting the huge C.R.A.P. (see
Screenshot 9.9). There are still some irregular maps, but mainly in the bottom half, which don’t account for much variance (e.g.,
ICs 20 and 23). The second thing to notice is that IC 1 is now a blink component. And the third thing to notice is that we now have
an IC with the usual scalp map for horizontal eye movements (IC 14). So, by deleting segments with huge C.R.A.P., we obtained a
much better ICA decomposition, even though we only deleted ~10 seconds worth of data.
The next step is to transfer the ICA weights to the original dataset (which are in a file named 6_MMN_preprocessed). Then you
should scroll through the data and component activations (simultaneously) to begin the process of determining which ICs to
exclude from the reconstructed data.
Go ahead and remove IC 1 (EEGLAB > Tools > Remove components from data), and then scroll through the resulting dataset.
Note that this dataset has the break periods at the beginning and end, so the huge C.R.A.P. artifacts are now about 10 seconds later
than before.
You should see that the blink correction has done a good job of eliminating the voltages produced by ordinary blinks. However, the
periods with huge C.R.A.P. artifacts are still present and still have large artifacts. You would therefore want to perform artifact
9.8.3 https://socialsci.libretexts.org/@go/page/137624

<!-- source_pdf=Full.pdf pdf_page=267 source_page_label="9.8.4" source_url="https://socialsci.libretexts.org/@go/page/137624" -->

## PDF page 267

- Source page label: 9.8.4
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137624

detection on the epoched data to mark these epochs and then reject them in the averaging process.
This page titled 9.8: Exercise- Deleting C.R.A.P. Prior to ICA is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
9.8.4 https://socialsci.libretexts.org/@go/page/137624

<!-- source_pdf=Full.pdf pdf_page=268 source_page_label="9.9.1" source_url="https://socialsci.libretexts.org/@go/page/137626" -->

## PDF page 268

- Source page label: 9.9.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137626

9.9: General Recommendations
In this section, I summarize my recommendations for ICA-based artifact correction. These recommendations reflect my assessment
of the current state of the art. It is difficult to determine the optimal approach to ICA analytically or with simulations, so these
recommendations are mainly based on a combination of informal experience (my own and others’) and empirical studies (which
are often unsatisfying because ground truth is not usually known). As a result, these recommendations may change as more
information accumulates, and other researchers may reasonably disagree with some of them.
Also, these recommendations are based largely on studies of compliant adult participants, and some changes may be necessary for
other populations. So, use them as a starting point for designing your own artifact correction approach, not as a recipe to be
followed blindly. And make sure that your approach is designed to achieve the fundamental goal of obtaining an accurate answer to
the scientific question your study is designed to answer (which typically involves reducing noise and avoiding confounds from
artifactual voltages and from changes in the sensory input).
Now that I’m done with the caveats, here are my recommendations:
The correction should ordinarily be carried out on continuous data. If you have very long intertrial intervals, you can use
epoched data, but the epochs must be at least 3 seconds long (e.g., -1000 to +2000 ms). No baseline correction should be
applied (Groppe et al., 2009). There should be no overlap between consecutive epochs. Also, the epoching should be performed
after the high-pass filtering step described later.
The data should be referenced, and all of the channels included in the ICA decomposition should share the same reference. Any
reasonable reference is fine, but extra steps are required if you use the average of all sites as the reference (see Makoto’s
Preprocessing Pipeline or EEGLAB’s ICA documentation). Create additional bipolar channels for blinks and eye movements
(but these will be left out of the decomposition).
If you have large amounts of line noise, use the cleanline plugin to eliminate it (see Bigdely-Shamlo et al., 2015 for important
details about implementing this tool). This is better than applying a low-pass filter (but a low-pass filter is sufficient for modest
amounts of line noise).
Scroll through the entire dataset to make sure you know what kinds of artifacts and other problems are present. Determine
which channels should be interpolated.
Once you have applied the above steps, make a separate copy of the dataset for use in the ICA decomposition. Apply the
following steps to that copy, but not to the original data.
High-pass filter at 1 Hz (I recommend 48 dB/octave). If you will not be analyzing high-frequency activity (e.g., gamma-
band oscillations), you should also apply a low-pass filter at 30 Hz (48 dB/octave).
Downsample the data to 100 Hz.
Delete time periods during breaks.
Delete segments of huge C.R.A.P.
Run the ICA decomposition with the runica algorithm, using the ‘extended’, 1 option. Leave out the bipolar channels and
any channels that you plan to interpolate.
Verify that the ICs are reasonable (e.g., not too many irregular scalp maps, especially for the top half of the ICs). If they’re
not, take another look at the data and see if there are problems you missed.
When you are first starting out (or switching to a different kind of experimental paradigm or participant population), it’s a
good idea to repeat the decomposition and make sure that you get similar results each time. If you don’t, then the
decomposition is not working well. The RELICA plugin can be used to provide a quantitative assessment of the reliability of
the decomposition.
If you can’t get a good decomposition, check to make sure that you have enough data. The informal rule is that the number
of time points in the dataset must be at least 20 x (# channels)2 (assuming that your original data were sampled at ~250 Hz).
If you don’t have enough data, one option is to apply PCA first to reduce the dimensionality of your data. However, this can
create significant problems (Artoni et al., 2018), and you shouldn’t use it unless you have more than 128 channels.
Transfer the ICA weights to the original version of the dataset (the version right before you made the copy).
Evaluate the ICs with the following steps:
9.9.1 https://socialsci.libretexts.org/@go/page/137626

<!-- source_pdf=Full.pdf pdf_page=269 source_page_label="9.9.2" source_url="https://socialsci.libretexts.org/@go/page/137626" -->

## PDF page 269

- Source page label: 9.9.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137626

Examine the ICs carefully to make sure everything looks OK and to identify the key ICs. This includes looking at the scalp
map, the frequency spectrum, and the time course heat map for each key IC, and then scrolling through the IC activations
and voltages simultaneously to see what voltage changes co-occur with the key ICs.
Compute SME values corresponding to your planned data analysis (e.g., mean amplitude from 125-225 for the MMN)
before versus after correcting for each IC to see if correction actually improves your data quality.
For each IC that you may want to remove, reconstruct your data using only that IC. Then average the data and see if that IC
varies systematically across conditions (or groups in a between-subjects design, but that requires making grand averages
across participants).
Remove the ICs that correspond to clear, well-understood artifacts, have been well isolated by ICA, and are actually
problematic (e.g., reduce your data quality or differ across conditions in the averaged ERPs).
Interpolate the bad channels that you previously identified.
After performing artifact correction, you should perform artifact detection on the epoched data. At a minimum, you want to
eliminate epochs with C.R.A.P., because these are not handled well by artifact correction. In visual experiments, you should
also mark and reject epochs with blinks and eye movements that might have interfered with the perception of the stimuli (e.g.,
between -200 and 400 ms). You can use the bipolar EOG channels for this because they were not corrected.
As a final check, you can apply artifact detection/rejection to your data instead of artifact correction and then compare the grand
averages from these two approaches. Ideally, the grand averages should be similar, but noisier for the rejection version than for
the correction version (because fewer trials are available). If you see large differences between the rejected and corrected
versions, this may indicate that the correction has reduced an important source of neural activity (because your artifact ICs
contained a mixture of brain activity and artifacts) or that it has failed to fully correct for the artifacts.
I’d like to say a few words about how interpolation interacts with artifact correction. You don’t want the “bad channels” to mess up
the ICA decomposition, so these channels need to be excluded from the decomposition stage. You’ll then perform the interpolation
after the decomposition has been performed and the data have been corrected. That way, the interpolated channels will reflect the
corrected data. My lab spent about 20 minutes one day talking through the different possible orders of steps for combining
interpolation and correction, and this approach was clearly the best.
This page titled 9.9: General Recommendations is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck
directly on the LibreTexts platform.
9.9.2 https://socialsci.libretexts.org/@go/page/137626

<!-- source_pdf=Full.pdf pdf_page=270 source_page_label="9.10.1" source_url="https://socialsci.libretexts.org/@go/page/137627" -->

## PDF page 270

- Source page label: 9.10.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137627

9.10: Matlab Scripts For This Chapter
I’ve created a set of three scripts that shows how to implement the artifact correction approach described in this chapter. There are
three scripts, which you can find in the Chapter_9 folder. The script names begin with MMN_artifact_correction_ and then end in
phase1, phase2, or phase3. They divide the process into—you guessed it!—three phases.
The first phase takes the original dataset and creates a copy that is optimized for the ICA decomposition by filtering from 1-30
Hz, downsampling to 100 Hz, deleting the break periods, and rejecting segments that contain huge C.R.A.P. artifacts.
The second phase performs the ICA decomposition on this optimized dataset. I put that in a separate script because it takes quite
a while to run.
The third phase transfers the ICA weights to the original dataset, removes the artifactual ICs, and then interpolates any bad
channels.
The script processes the data from Subjects 1–10. I spent an entire afternoon going through the data carefully, deciding which
channels should be interpolated, determining which ICs to remove, etc. But even after devoting that much time, I did only a
superficial job. You can probably do better if you spend more time.
While I was going through the data to determine the various parameters for a given participant, I put the parameters in a set of
spreadsheets. The scripts then read from these spreadsheets. For the first two phases, I didn’t actually run the scripts on all 10
participants at once. As noted in the comments inside the scripts, you can modify the scripts slightly to work on one participant at a
time. I went back and forth between the scripts and the GUI to set the various parameters. You won’t need to do that to run the
scripts, because all the parameters are in the spreadsheets (which are provided in the Chapter_9 folder). However, you’ll probably
want to adopt this one-participant-at-a-time approach when you’re analyzing your own data.
Note that the Excel spreadsheets contain a column for comments. These comments aren’t used by the scripts, but they’re very
useful in helping you to remember why you made various decisions. Your future self will thank you.
This page titled 9.10: Matlab Scripts For This Chapter is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
9.10.1 https://socialsci.libretexts.org/@go/page/137627

<!-- source_pdf=Full.pdf pdf_page=271 source_page_label="9.11.1" source_url="https://socialsci.libretexts.org/@go/page/137628" -->

## PDF page 271

- Source page label: 9.11.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137628

9.11: Key Takeaways and References
Key Takeaways
Just as with artifact rejection, the overarching goal in designing an artifact correction strategy is to maximize the likelihood that
you will obtain an accurate answer to the scientific question your study is designed to answer. This typically involves reducing
noise to maximize statistical power, avoiding artifactual voltages, and avoiding unwanted changes in the sensory input.
You can assess noise reduction by examining the SME before and after correction.
You can assess confounds by reconstructing the data only with the artifactual ICs and looking for differences between
conditions.
Artifact correction cannot be used to avoid artifactual changes in the sensory input, and you will typically want to employ
artifact detection and rejection for that purpose (in addition to artifact correction) in studies with visual stimuli.
Some of the assumptions of ICA are known to be incorrect, and it is therefore imperfect. In practice, ICA works best for large
and frequent artifacts, such as blinks. I therefore recommend a conservative correction strategy in which you remove only the
small set of ICs that correspond with well-understood artifacts and only after you have established that they are actually
problematic (i.e., reduce the data quality substantially and/or create confounds).
References
Artoni, F., Delorme, A., & Makeig, S. (2018). Applying dimension reduction to EEG data by Principal Component Analysis
reduces the quality of its subsequent Independent Component decomposition. NeuroImage, 175, 176–187.
https://doi.org/10.1016/j.neuroimage.2018.03.016
Berger, H. (1929). Ueber das Elektrenkephalogramm des Menschen. Archives Fur Psychiatrie Nervenkrankheiten, 87, 527–570.
Bigdely-Shamlo, N., Mullen, T., Kothe, C., Su, K.-M., & Robbins, K. A. (2015). The PREP pipeline: Standardized preprocessing
for large-scale EEG analysis. Frontiers in Neuroinformatics, 9. https://doi.org/10.3389/fninf.2015.00016
Box, G. E. P. (1976). Science and Statistics. Journal of the American Statistical Association, 71(356), 791–799.
https://doi.org/10.1080/01621459.1976.10480949
Dimigen, O. (2020). Optimizing the ICA-based removal of ocular EEG artifacts from free viewing experiments. NeuroImage, 207,
116117. https://doi.org/10.1016/j.neuroimage.2019.116117
Drisdelle, B. L., Aubin, S., & Jolicoeur, P. (2017). Dealing with ocular artifacts on lateralized ERPs in studies of visual-spatial
attention and memory: ICA correction versus epoch rejection. Psychophysiology, 54(1), 83–99. https://doi.org/10.1111/psyp.12675
Groppe, D. M., Makeig, S., & Kutas, M. (2009). Identifying reliable independent components via split-half comparisons.
Neuroimage, 45, 1199–1211. https://doi.org/10.1016/j.neuroimage.2008.12.038
Luck, S. J. (2014). An Introduction to the Event-Related Potential Technique, Second Edition. MIT Press.
Näätänen, R., & Kreegipuu, K. (2012). The mismatch negativity (MMN). In S. J. Luck & E. S. Kappenman (Eds.), The Oxford
Handbook of Event-Related Potential Components (pp. 143–157). Oxford University Press.
This page titled 9.11: Key Takeaways and References is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
9.11.1 https://socialsci.libretexts.org/@go/page/137628
