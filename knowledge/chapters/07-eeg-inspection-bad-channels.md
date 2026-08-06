# 7: Inspecting the EEG and Interpolating Bad Channels

> Source: *Applied Event-Related Potential Data Analysis* (Steven J. Luck), `Full.pdf`, PDF pages 185-195. Text is a mechanical page-by-page extraction, not a summary. Consult the PDF for figures and layout.

<!-- source_pdf=Full.pdf pdf_page=185 source_page_label="1" source_url="" -->

## PDF page 185

- Source page label: 1
- LibreTexts source: not printed on page

CHAPTER OVERVIEW
7: Inspecting the EEG and Interpolating Bad Channels
 Learning Objectives
In this chapter, you will learn to:
Inspect the raw data to determine what problems exist that might require intervention
Determine whether an EEG channel is “bad” and replace the bad channel with interpolated values
Identify “by eye” the most common types of artifacts, including blinks, saccadic eye movements, and muscle noise
I often say that it’s a miracle meaningful brain activity can be recorded from electrodes on the skin overlying the skull. Although
the EEG is miraculous, it's also an imperfect measure of brain activity. There are many types of artifacts that can contaminate the
data, and some of the electrodes may have poor electrical connections to the scalp, creating bad channels.
Several preprocessing steps are necessary prior to averaging so that artifacts and bad channels don’t lead you to draw incorrect
conclusions from the ERPs. In particular, we can replace the data from bad channels by interpolation from the good channels, and
we can apply artifact rejection and correction to minimize the impact of artifacts.
Prior to performing these steps, it is extremely important that you first perform a visual inspection of a given participant’s EEG so
that you understand what kinds of problems are present in that dataset. You also need to spend a lot of time looking at raw EEG
data when you are learning to perform preprocessing so that you learn how to identify the most common types of problems.
The goal of this chapter is to teach you how visually inspect EEG data and how to identify bad channels and common artifacts.
You’ll also learn how to replace bad channels with interpolated data. The subsequent chapters will cover artifact rejection and
artifact correction. We’ll look at data from one participant in the mismatch negativity (MMN) experiment from the ERP CORE
(Kappenman et al., 2021).
7.1: Data for This Chapter
7.2: Design of the Mismatch Negativity (MMN) Experiment
7.3: Video Demonstration- Performing an Initial Inspection of a Participant’s EEG
7.4: The Fundamental Goal of EEG Preprocessing
7.5: Background- Interpolating Bad Channels
7.6: Exercise - Interpolating Bad Channels
7.7: Matlab Script For This Chapter
7.8: Key Takeaways and References
This page titled 7: Inspecting the EEG and Interpolating Bad Channels is shared under a CC BY 4.0 license and was authored, remixed, and/or
curated by Steven J Luck directly on the LibreTexts platform.
1

<!-- source_pdf=Full.pdf pdf_page=186 source_page_label="7.1.1" source_url="https://socialsci.libretexts.org/@go/page/87967" -->

## PDF page 186

- Source page label: 7.1.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87967

7.1: Data for This Chapter
The data we’ll be using for the exercises in this chapter can be found in the Chapter_7 folder in the master folder:
https://doi.org/10.18115/D50056.
This page titled 7.1: Data for This Chapter is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck
directly on the LibreTexts platform.
7.1.1 https://socialsci.libretexts.org/@go/page/87967

<!-- source_pdf=Full.pdf pdf_page=187 source_page_label="7.2.1" source_url="https://socialsci.libretexts.org/@go/page/87968" -->

## PDF page 187

- Source page label: 7.2.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87968

7.2: Design of the Mismatch Negativity (MMN) Experiment
The exercises in this chapter and the chapters on artifact rejection and correction will use data from the ERP CORE MMN
experiment, and this section will provide a brief overview of the experimental design and main results.
As illustrated in Figure 7.1.A, the experiment involved a sequence of frequently occurring standard tones (1000 Hz, 80 dB, p = .8)
and rare deviant tones that were slightly softer (1000 Hz, 70 dB, p = .2). Each tone was presented for 100 ms, and successive tones
were separated by a silent interstimulus interval of 450-550 ms. The MMN does not require active attention, so the tones were task-
irrelevant. Instead, the participants were instructed to simply watch a small silent movie of a sand drawing in the middle of the
computer monitor (Figure 7.1.B). This kept the participants awake and alert, minimizing alpha-band EEG oscillations. The movie
was quite small to avoid large eye movements. Additional methodological details can be found in Kappenman et al. (2021).
The grand average ERPs for the standards and the deviants are shown in Figure 7.1.C. The waveforms are shown for the FCz
channel, where the MMN is typically largest. The MMN can be seen as a more negative voltage for the deviants than for the
standards from approximately 125–225 ms. The MMN is typically isolated from the other overlapping ERP components by means
of a deviant-minus-standard difference wave, which is shown in Figure 7.1.D.
Figure 7.1. Experimental paradigm and results from the ERP CORE Mismatch Negativity experiment. (A) Example sequence of
standard tones (p=.8) and deviant tones (p=.2). The tones were task-irrelevant. (B) One frame of the silent movie that participants
watched while the tones were playing. (C) Grand average ERP waveforms elicited by the standard and deviant tones, averaged over
all 40 participants. (D) Grand average difference wave, which was created by subtracting the averaged ERP waveform for the
deviant trials from the averaged ERP waveform for the standard trials.
This page titled 7.2: Design of the Mismatch Negativity (MMN) Experiment is shared under a CC BY 4.0 license and was authored, remixed,
and/or curated by Steven J Luck directly on the LibreTexts platform.
7.2.1 https://socialsci.libretexts.org/@go/page/87968

<!-- source_pdf=Full.pdf pdf_page=188 source_page_label="7.3.1" source_url="https://socialsci.libretexts.org/@go/page/87969" -->

## PDF page 188

- Source page label: 7.3.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87969

7.3: Video Demonstration- Performing an Initial Inspection of a Participant’s EEG
As I mentioned at the beginning of the chapter, it’s important to scan through each participant’s EEG to see what kinds of artifacts
are in the data. The best way to learn to do this is to go through the data from several participants with an expert who can show you
what to look for. I’ve tried to simulate that experience by creating a video where I go through the data from Subject #1 in the ERP
CORE MMN experiment.
Every participant is different, but Subject #1 is a good example because the recording contains many of the problems you’ll
encounter. In other words, Subject #1 is worse than usual for a basic science experiment in my lab, which is a good thing for seeing
examples of problems in EEG data.
When I first started going through Subject #1’s data, the EEG seemed super clean (and therefore not a good example). But as you’ll
see in the video, things go downhill pretty rapidly after the first couple minutes of the recording.
You should follow along on your own computer while you watch the video. To do this, quit and relaunch EEGLAB, set Chapter_7
to be Matlab’s current folder, and the load the dataset named 1_MMN_preprocessed.set. Then select EEGLAB > Plot > Channel
data (scroll).
Go ahead and watch the video now. You can access it at https://doi.org/10.18115/D5V638. It’s about 10 minutes long, and you’ll
definitely need to watch it before you read the rest of this chapter and the chapters on artifact rejection and correction.
This page titled 7.3: Video Demonstration- Performing an Initial Inspection of a Participant’s EEG is shared under a CC BY 4.0 license and was
authored, remixed, and/or curated by Steven J Luck directly on the LibreTexts platform.
7.3.1 https://socialsci.libretexts.org/@go/page/87969

<!-- source_pdf=Full.pdf pdf_page=189 source_page_label="7.4.1" source_url="https://socialsci.libretexts.org/@go/page/87970" -->

## PDF page 189

- Source page label: 7.4.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87970

7.4: The Fundamental Goal of EEG Preprocessing
This chapter and the following two chapters describe EEG preprocessing steps that are used to deal with problem in the data, such
as bad channels and artifacts. First, we need to think about what our goal is for these steps. I find that most people haven’t thought
clearly about what they are trying to achieve in their preprocessing pipeline, and this leads to pipelines that are less than ideal.
So, what is the goal of EEG preprocessing? It’s simple: our fundamental goal is to accurately answer the scientific question
that the experiment was designed to address. If we include bad channels or large artifacts, this will likely move us away from
this goal. However, if throw out a lot of trials or participants, this will also tend to move us away from our goal by reducing our
statistical power. Most preprocessing steps—such as interpolating bad channels or rejecting trials with artifacts—have both costs
and benefits, and we need to ask whether the benefits of a given processing step outweigh the costs in terms of answering the
scientific question that the experiment was designed to address. We will discuss how to assess these costs and benefits as we go
through this chapter and the next two chapters.
This page titled 7.4: The Fundamental Goal of EEG Preprocessing is shared under a CC BY 4.0 license and was authored, remixed, and/or curated
by Steven J Luck directly on the LibreTexts platform.
7.4.1 https://socialsci.libretexts.org/@go/page/87970

<!-- source_pdf=Full.pdf pdf_page=190 source_page_label="7.5.1" source_url="https://socialsci.libretexts.org/@go/page/87971" -->

## PDF page 190

- Source page label: 7.5.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87971

7.5: Background- Interpolating Bad Channels
In the video demonstration, the C5 channel seemed quite problematic, and I mentioned that we might want interpolate that channel.
Also, the F8 channel had a lot of high-frequency noise, so we should consider interpolating that channel as well. In this exercise,
we’ll discuss how to decide whether a channel should be interpolated and then look at the actual interpolation process.
Interpolation is performed separately at each time point, using the voltage values from the other channels at that time point. There
are several algorithms that can be used to estimate a reasonable value for one channel on the basis of the other channels, and they
all work reasonably well. I like to use the spherical algorithm provided by EEGLAB. It treats the electrodes as if they’re located on
a spherical head, and it fits a polynomial function to the distribution of voltages, leaving out the to-be-interpolated channel. Then,
the value of the polynomial function at the to-be-interpolated location is used as the estimated voltage at that location. This process
is repeated independently at each time sample. You get a pretty reasonable waveform at the interpolated location, but keep in mind
that it’s just an imperfect estimate of the true waveform.
The decision about whether to interpolate a given channel ultimately comes down to our fundamental goal of accurately answering
the scientific question that the experiment was designed to address. I’ll provide some general guidance, but ultimately you need to
think about whether interpolation serves that goal. Does it get you closer to the truth or farther from the truth? Imagine that you’ve
submitted a manuscript to a journal, and one of the reviewers visits your lab to see how you actually processed your data (which
would never happen in reality, of course). Would you be happy to explain to this reviewer how you decided whether to interpolate?
Or would you feel a little embarrassed?
Let’s start with an extreme case. Imagine that an electrode was broken and the signal from that electrode was pure noise. And
imagine that the broken electrode wasn’t being used in any of the key analyses. For example, we measured MMN amplitude at FCz
for the main analyses in the ERP CORE paper (Kappenman et al., 2021), so the C5 and F8 electrodes didn’t play a major role our
analyses (although they did make a minor contribution when we plotted scalp maps). One way to deal with the broken electrode
would be to completely discard this participant’s data. This would reduce the sample size in our analyses, which tends to decrease
our ability to draw accurate conclusions about the population, so that’s not a great option. The other main option would be to
interpolate the data from the broken electrode. Given that the broken electrode doesn’t contribute to the main analyses, being able
to include the participant by interpolating and thereby increasing your sample size seems like it serves the truth much more than
excluding the participant from all analyses.
Now let’s consider an extreme case in the opposite direction. Imagine that you’re analyzing data collected in another lab with really
poor recording methods (or a really challenging participant), and the data from FCz and the 8 closest electrodes look terrible. Not
only is the key channel for the analysis bad, but so are the surrounding channels, which will make it difficult to interpolate
accurately. In this case, including the participant in the final analyses seems like it will not add real information and will do more
harm than good.
I posted a message on Twitter asking how researchers decide whether any channels should be interpolated. Some people indicated
that they do it informally by visual inspection. Bad channels are relatively rare in my lab, so we also use visual inspection. Other
researchers indicated that they used an automated method, such as the Clean Rawdata plugin in EEGLAB or the PREP
pipeline (Bigdely-Shamlo et al., 2015). Many researchers who said that they use an automated method indicated that the algorithm
fails often enough that they visually confirm the results. I’ve never tried the automated methods, but the algorithms seem
reasonable (especially the PREP pipeline), and I would expect them to work well when verified by visual inspection. However,
they mainly rely on statistical criteria, such as how well a given channel correlates with other channels (with a low correlation
suggesting a problem given that true brain signals spread broadly across the scalp and therefore produce high correlations between
nearby electrode sites).
This will certainly work for detecting things like loose electrodes. However, if an electrode is properly connected but the signal
contains biological noise (e.g., muscle activity), the question is whether the noise decreases your ability to precisely quantify the
amplitude or latency value that will be the dependent variable in your statistical analyses (because this is how we reach our
fundamental goal or accurately answering the scientific question that the experiment is designed to address). The Standardized
Measurement Error (SME) is ideally suited for this purpose because it quantifies the extent to which the noise in the data produces
7.5.1 https://socialsci.libretexts.org/@go/page/87971

<!-- source_pdf=Full.pdf pdf_page=191 source_page_label="7.5.2" source_url="https://socialsci.libretexts.org/@go/page/87971" -->

## PDF page 191

- Source page label: 7.5.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87971

error in the specific amplitude or latency value you will be obtaining from the averaged ERPs. With this in mind, let’s consider the
actual cases of the C5 and F8 electrodes from Subject #1 in the ERP CORE MMN experiment.
This page titled 7.5: Background- Interpolating Bad Channels is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
7.5.2 https://socialsci.libretexts.org/@go/page/87971

<!-- source_pdf=Full.pdf pdf_page=192 source_page_label="7.6.1" source_url="https://socialsci.libretexts.org/@go/page/87972" -->

## PDF page 192

- Source page label: 7.6.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87972

7.6: Exercise - Interpolating Bad Channels
If you don’t already have the 1_MMN_preprocessed.set dataset loaded, you should load it now. This dataset has already been
preprocessed, including referencing to the average of P9 and P10 and high-pass filtering with a half-amplitude cutoff at 0.1 Hz. An
EventList has been added, and BINLISTER has been run to assign events to bins. We have only two bins: Deviant Preceded by
Standard (Bin 1, 200 epochs)) and Standard Preceded by Standard (Bin 2, 585 epochs).
We’ve already looked carefully at the EEG (as shown in the video), and now we need to make a decision about whether C5 and/or
F8 should be interpolated. To help make this decision, let’s calculate the SME. First, we need to epoch the continuous EEG, so
select EEGLAB > ERPLAB > Extract bin-based epochs. Specify an epoch of -200 to 800 ms and Pre as the baseline.
Now we’re ready to compute the SME. The SME is automatically computed when we create averaged ERPs, but we don’t need to
look at averages right now, so you should instead get the SME values by selecting EEGLAB > ERPLAB > Compute data quality
metrics (without averaging).
We’re quantifying MMN amplitude as the mean voltage from 125 to 225 ms, so we want to get the SME values for this time range.
To do this, select Custom parameters in the averaging GUI and click the Set DQ options… button. A new window will appear.
Click Add a row to add a new time window. You’ll need to scroll down to see the new row. Change to the name of this row to
aSME at 125 to 225 and change the time window start and end fields to 125 and 225. Then click Save to get back to the main
averaging GUI, and then click RUN. A table with the data quality values will then appear. If you look at the aSME values for Bin
1, the rightmost column will show the values for the 125-225 ms time range.
You’ll see that the aSME values for Fp1, Fp2, and VEOG-bipolar are all quite high relative to the other channels. That’s because of
blinking, so you can ignore those channels. (You could perform artifact correction prior to examining the aSME to avoid this issue,
especially if you were concerned that one of these channels should be interpolated.) Of the remaining channels, C5 really stands
out, with a value that is much higher than the other channels.
The data quality table GUI includes two tools that can help you find problematic values. First, the Color heatmap option colors
each cell according to the value relative to the other cells. Try that, and you’ll see that the C5 channel pops out. The EOG, Fp1, and
Fp2 sites also pop out, but that’s because we haven’t gotten rid of the blinks.
The second way of identifying problematic channels is to click the Outliers button. Turn off the Color heatmap option and then
turn on the Outliers option. It will highlight any cells that are more than N standard deviations (SDs) away from the mean aSME
value for that time period. The default setting of N is 2, which means that it will highlight cases that are more than 2 SDs above the
mean. But when computing the SD, it would make sense to leave out the EOG, Fp1, and Fp2 channels, because they are a poor
comparison for the other channels as a result of the blinking. The Outliers feature therefore allows you to specify a subset of the
channels for computing the SD. Enter 3:28 in this text box. You’ll now see that the C5 channel is highlighted in most or all time
periods. When combined with the fact that C5 was clearly problematic in our visual inspection of the data, these aSME results
provide good reason to interpolate this channel.
What about F8, which also looked pretty bad in our visual inspection? The aSME for F8 is well within the range of the other frontal
electrode sites. This indicates that the high-frequency noise in F8 isn’t really impacting our ability to quantify the amplitude of the
MMN using the mean voltage between 125 and 225 ms. That noise could be problematic for other measures (e.g., the peak
amplitude), but it’s not problematic for the planned analyses of the present study (especially given that the main analysis will be
limited to FCz). So, there would be little value in interpolating this channel given the way the data will be analyzed.
In the analyses provided in the ERP CORE paper (Kappenman et al., 2021), F8 was interpolated because we did not yet have the
SME metric and it “looked” noisy. Now I would make a different decision. I guess you can teach an old dog new tricks!
Now that we’ve decide to interpolate C5 but not F8, it’s time to implement the interpolation. Close the Data Quality viewer
window, and select the original continuous dataset (1_MMN_preprocessed) in the Datasets menu. Then select EEGLAB >
ERPLAB > Preprocess EEG > Selective Electrode Interpolation. Put 11 in the Interpolate Electrodes box (because C5 is
Channel 11). We don’t want our bipolar EOG electrodes to be used for the interpolation, because they don’t have the same
reference as C5 and would mess up the interpolation, so put 32 33 in the Ignore Electrodes box. Select Spherical as the
7.6.1 https://socialsci.libretexts.org/@go/page/87972

<!-- source_pdf=Full.pdf pdf_page=193 source_page_label="7.6.2" source_url="https://socialsci.libretexts.org/@go/page/87972" -->

## PDF page 193

- Source page label: 7.6.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87972

Interpolation Method and click the Interpolate button. Name the resulting dataset 1_MMN_preprocessed_interp (and you may
want to save it to your disk because we’ll use it in the following exercises).
Now look through the EEG data using EEGLAB > Plot > Channel data (scroll). The C5 channel should now look beautiful, even
later in the session when the original C5 channel looked terrible. Success! However, keep in mind that the C5 channel now contains
estimated voltages, not measured voltages. But that’s good enough for our present purposes, especially given that the main analyses
will be performed on a different channel.
One last note about interpolation: If you are using the average across sites as the reference, the data from any bad channels will
contaminate all the channels. You might therefore want to use a single electrode (or a pair of electrodes such as P9 and P10) as the
reference prior to interpolation. You can then re-reference to the average of all sites after interpolation. A more complex but more
robust approach is implemented by the PREP pipeline (Bigdely-Shamlo et al., 2015).
This page titled 7.6: Exercise - Interpolating Bad Channels is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck.
7.6.2 https://socialsci.libretexts.org/@go/page/87972

<!-- source_pdf=Full.pdf pdf_page=194 source_page_label="7.7.1" source_url="https://socialsci.libretexts.org/@go/page/137608" -->

## PDF page 194

- Source page label: 7.7.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137608

7.7: Matlab Script For This Chapter
There is no script for this chapter. The script for the next chapter shows how to implement interpolation along with artifact
rejection.
This page titled 7.7: Matlab Script For This Chapter is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
7.7.1 https://socialsci.libretexts.org/@go/page/137608

<!-- source_pdf=Full.pdf pdf_page=195 source_page_label="7.8.1" source_url="https://socialsci.libretexts.org/@go/page/137609" -->

## PDF page 195

- Source page label: 7.8.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137609

7.8: Key Takeaways and References
Key Takeaways
The overarching goal for your EEG preprocessing is to maximize the likelihood that you will obtain an accurate answer to the
scientific question your study is designed to answer. You can ignore any of my specific suggestions for your preprocessing
pipeline if you have a better way of reaching that goal.
You can more easily obtain an accurate answer to your scientific question if you look carefully at each participant’s data prior to
doing the preprocessing. By examining the data, you’ll be able to adjust the preprocessing to reflect the unique problems of
each individual participant’s data.
The standardized measurement error (SME) provides a useful metric for knowing whether a “bad channel” is really problematic
with respect to the analyses you will be performing with your data.
Interpolation is a low-risk procedure when the channel being interpolated will not be used for your main analyses. But if the
channel will be used in your main analyses, you need to think carefully about whether to interpolate the channel or exclude the
participants from analysis.
References
Bigdely-Shamlo, N., Mullen, T., Kothe, C., Su, K.-M., & Robbins, K. A. (2015). The PREP pipeline: Standardized preprocessing
for large-scale EEG analysis. Frontiers in Neuroinformatics, 9. https://doi.org/10.3389/fninf.2015.00016
Kappenman, E. S., Farrens, J. L., Zhang, W., Stewart, A. X., & Luck, S. J. (2021). ERP CORE: An open resource for human event-
related potential research. NeuroImage, 225, 117465. https://doi.org/10.1016/j.neuroimage.2020.117465
This page titled 7.8: Key Takeaways and References is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
7.8.1 https://socialsci.libretexts.org/@go/page/137609
