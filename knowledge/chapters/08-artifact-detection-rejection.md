# 8: Artifact Detection and Rejection

> Source: *Applied Event-Related Potential Data Analysis* (Steven J. Luck), `Full.pdf`, PDF pages 196-240. Text is a mechanical page-by-page extraction, not a summary. Consult the PDF for figures and layout.

<!-- source_pdf=Full.pdf pdf_page=196 source_page_label="1" source_url="" -->

## PDF page 196

- Source page label: 1
- LibreTexts source: not printed on page

CHAPTER OVERVIEW
8: Artifact Detection and Rejection
 Learning Objectives
In this chapter, you will learn to:
Conceptualize artifact rejection in terms of the overarching goal of accurately answering the scientific question that your
experiment was designed to address
Implement algorithms that work particularly well for detecting blinks, saccadic eye movements, and a broad class of
artifacts termed commonly rejected artifactual potentials
Select optimal parameters for the artifact detection parameters
Evaluate the effectiveness of your artifact rejection procedures on the averaged ERP waveforms, including both data quality
and confounds
Implement a two-stage artifact rejection procedure for ensuring that experiments with lateralized stimuli or lateralized
responses are not contaminated by small but consistent eye movements
EEG recordings are often filled with large artifacts. In most areas of research, blinks are the most problematic. They’re large (often
200 µV), occur frequently (on over 50% of trials in many participants), and may differ systematically across groups or conditions,
creating a significant confound if they aren’t properly addressed. In research with infants, small children, or people who are
required to move around during the task, movement-related artifacts are also a major issue. In my own area of research, eye
movements toward lateralized targets are the most significant artifact.
However, in most of the ERP papers I read that use artifact rejection, it doesn’t seem that much thought went into the strategy for
dealing with artifacts. These papers typically use a very primitive algorithm for detecting trials with artifacts, and they use the same
rejection threshold for all participants (even though artifacts differ quite a bit across individuals). This chapter is designed to help
you conceptualize and implement artifact rejection in a more sophisticated manner, allowing you to minimize artifact-related
confounds and maximize your data quality.
8.1: Data for This Chapter
8.2: Overview
8.3: Background- Why Do We Reject Artifacts?
8.4: Background- The General Approach
8.5: Exercise- Simple Blink Detection
8.6: Exercise- Adjusting the Threshold
8.7: An Iterative Approach to Setting Parameters
8.8: Exercise- Data Quality and Confounds
8.9: Exercise- Better Blink Detection
8.10: Exercise- Detecting Eye Movements
8.11: Exercise- Deciding on a Threshold for Eye Movements
8.12: Exercise- Commonly Recorded Artifactual Potentials (C.R.A.P.)
8.13: Using Artifact Detection to Avoid Changes to Visual Inputs
8.14: The ERP CORE N2pc Experiment
8.15: Exercise- Visualizing the Eye Movements
8.16: Exercise- Using the Averaged HEOG to Visualize Consistent Eye Movements
8.17: Exercise- A Two-Stage Strategy for Eliminating Small But Consistent Eye Movements
8.18: Matlab Script For This Chapter
1

<!-- source_pdf=Full.pdf pdf_page=197 source_page_label="2" source_url="" -->

## PDF page 197

- Source page label: 2
- LibreTexts source: not printed on page

8.19: Key Takeaways and References
This page titled 8: Artifact Detection and Rejection is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
2

<!-- source_pdf=Full.pdf pdf_page=198 source_page_label="8.1.1" source_url="https://socialsci.libretexts.org/@go/page/137755" -->

## PDF page 198

- Source page label: 8.1.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137755

8.1: Data for This Chapter
The data we’ll be using for the exercises in this chapter can be found in the Chapter_8 folder in the master folder:
https://doi.org/10.18115/D50056.
This page titled 8.1: Data for This Chapter is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck
directly on the LibreTexts platform.
8.1.1 https://socialsci.libretexts.org/@go/page/137755

<!-- source_pdf=Full.pdf pdf_page=199 source_page_label="8.2.1" source_url="https://socialsci.libretexts.org/@go/page/137756" -->

## PDF page 199

- Source page label: 8.2.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137756

8.2: Overview
When Javier Lopez-Calderon and I designed the artifact rejection process in ERPLAB, Javier suggested that we should refer to the
process of flagging epochs as artifact detection, because those epochs aren’t actually deleted from the EEG dataset. The rejection
(or exclusion) of the flagged epochs actually occurs during the averaging process. I thought that was a great idea. So, I will use the
phrase artifact detection to refer to the process of determining which epochs should be flagged and the phrase artifact rejection to
refer to the process excluding flagged epochs from the averaged ERPs.
EEGLAB and ERPLAB also contain a separate set of routines that actually delete problematic segments of data from the
continuous EEG. These routines are primarily used as a preprocessing step in the artifact correction process, as will be described in
the next chapter. In the present chapter, the term artifact rejection will be used in the context of epoched EEG data.
Chapter 6 in Luck (2014) provides important theoretical background about a broad range of artifacts and about the nature of the
artifact detection/rejection process. It will be helpful (but not absolutely necessary) for you to read that chapter before proceeding.
The goal of the present chapter is to make this theoretical background more concrete and demonstrate the practical issues that arise
in real data.
We’ll focus on data from a few example participants who I selected not because they had “good” data but because they were quite
challenging. The data will come from two of the ERP CORE experiments (Kappenman et al., 2021), one looking at the mismatch
negativity (MMN) and one looking at the N2pc component. The MMN paradigm was described in the previous chapter, and the
N2pc paradigm will be described later in the present chapter. We’ll mainly consider blinks and eye movements, because they’re the
most common large artifacts, but the exercises will also teach you general principles that you can use for other kinds of artifacts
and other types of experiments.
Artifact correction has many advantages over artifact rejection, and it will be covered in the next chapter. In almost all cases,
however, I recommend combining rejection and correction. Also, the problems created by artifacts are the same whether you’re
using rejection or correction, so you’ll need to read at least the first part of this chapter even if you’re mainly planning to use
correction instead of rejection.
Organization of the Chapter
Artifact detection is conceptually simple, but it requires a lot of decisions, and you need to know how to make the best decisions to
achieve the best possible data. As a result, this chapter is pretty long. Here’s the overall structure:
The first part of the chapter describes three main problems that are typically addressed by artifact rejection and provides an
overview of the detection+rejection process.
The second part of the chapter takes you through a series of exercises in which you’ll see how to detect and reject blinks, eye
movements, and other miscellaneous artifacts in the context of the MMN experiment.
The last part of the chapter takes you through exercises that teach you how to detect and reject small but consistent eye
movements, which are especially problematic in experiments with lateralized target stimuli (especially N2pc and CDA
experiments) or lateralized responses (mainly LRP experiments). If you don’t conduct experiments of this sort, you can skip this
part of the chapter.
The exercises focus on data from only two participants in each experiment. I strongly recommend looking at the data from
additional participants and repeating the artifact detection procedures with those participants. You can find the data from additional
participants in the MMN_Data N2pc_Data folders inside the Chapter_8 folder.
Keep in mind that we did nothing to try to minimize blinking when designing and running these experiments because we knew we
would use artifact correction rather than artifact rejection to deal with blinks. As a result, many participants blinked on a large
proportion of trials. We would have needed to exclude many of these participants if we had rejected rather than corrected blinks.
This page titled 8.2: Overview is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck directly on the
LibreTexts platform.
8.2.1 https://socialsci.libretexts.org/@go/page/137756

<!-- source_pdf=Full.pdf pdf_page=200 source_page_label="8.3.1" source_url="https://socialsci.libretexts.org/@go/page/137768" -->

## PDF page 200

- Source page label: 8.3.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137768

8.3: Background- Why Do We Reject Artifacts?
Let’s start by asking why we reject epochs containing artifacts. You might think this is a dumb question. Obviously, we don’t want
any artifacts in the epochs that we will be using to make our averaged ERPs! However, every single time point in every scalp EEG
recording in human history contains artifactual activity. That is, the scalp EEG signal is always a mixture of brain activity, non-
neural biological signals (e.g., skin potentials, EMG), and non-biological signals (e.g., line noise from nearby electrical devices). If
we rejected every epoch containing an artifact, we wouldn’t have any data left.
We therefore reject epochs that problematic artifacts, defined as artifacts that interfere with the fundamental goal described in the
previous chapter: accurately answering the scientific question that the experiment was designed to address. There are three
common ways in which artifacts can be problematic from this perspective:
1. Reduced Statistical Power. Artifacts add noise to the data, reducing the signal-to-noise ratio (SNR) of our averaged ERPs.
This makes our amplitude and latency measurements less precise, which in turn decreases our statistical power. However, when
we reject epochs containing artifacts, we have fewer epochs in our averages, and that also makes the averages noisier and
decreases our power. As a result, we need to balance the need to eliminate epochs with large artifacts with the need to include as
many epochs as possible.
2. Systematic Confounds. Artifacts can produce systematic confounds in our studies. For example, if participants blink more in
response to deviant stimuli than in response to the standards, we will see a difference between deviants and standards in the
averaged ERPs that is due to EOG activity rather than to brain activity. As we will see in one of the exercises in this chapter,
this is not just a theoretical possibility.
3. Sensory Input Problems. In visual experiments, EOG artifacts can indicate a problem with the sensory input. For example, if a
blink occurs just before or during the stimulus presentation, this means that the stimulus wasn’t actually seen by the participant.
Similarly, a deflection in the horizontal EOG can mean that the eyes weren’t pointed at the center of the display. The first
exercises in this chapter will use data from an auditory experiment so that we won’t need to deal with this issue initially.
However, we’ll switch to a visual experiment in the last part of the chapter to examine how ocular artifacts might alter the
sensory input.
Artifact correction can be much better than artifact rejection for addressing the problem of reduced statistical power, because we
get to keep all of our epochs. Correction can also help with systematic confounds, but only to the extent that the correction fully
removes the artifacts and doesn’t produce any new artifacts. For example, if correction reduces the blinks by 99%, the remaining
blink activity would still be 1-2 µV in the frontal channels (because uncorrected blinks are typically 100-200 µV in these channels).
That might be enough to produce a significant confound. Artifact correction doesn’t help at all with sensory input problems. For
example, if participants are looking leftward in one condition and rightward in another condition, correcting for the EOG voltage
produced by the eye movements doesn’t eliminate the confound of a different sensory input in the two conditions.
For these reasons, I recommend combining artifact correction and artifact rejection for most experiments. You can use correction to
minimize the noise produced by blinks (and certain other artifacts, as discussed in Chapter 6 in Luck, 2014). And then you can use
rejection to eliminate epochs with blinks or eye movements near the time of the stimulus (for visual experiments) and to eliminate
epochs that contain large artifacts that are not easily corrected (e.g., occasional EMG bursts).
When we’re using rejection to deal with reduced statistical power, we would ideally have an algorithm that determines which
epochs should be removed to best balance the benefits of eliminating noisy epochs with the cost of reducing the number of epochs
that are included in our averages. There are several methods that take this approach (e.g., Jas et al., 2017; Nolan et al., 2010;
Talsma, 2008). However, they try to optimize the signal-to-noise ratio in a generic sense, which may not actually maximize
statistical power for the specific amplitude or latency measurement that you will be using to answer your scientific question.
The standardized measurement error (SME) was specifically designed to quantify the data quality for your specific amplitude or
latency measure and is directly related to statistical power (Luck et al., 2021). The SME can therefore be used to determine the
artifact detection parameters that will lead to the best power. At this moment, ERPLAB doesn’t include an automated approach for
determining which trials should be rejected to minimize the SME, but you can manually check the SME to compare different
artifact detection parameters. We’ll use this approach in several of the exercises later in this chapter.
8.3.1 https://socialsci.libretexts.org/@go/page/137768

<!-- source_pdf=Full.pdf pdf_page=201 source_page_label="8.3.2" source_url="https://socialsci.libretexts.org/@go/page/137768" -->

## PDF page 201

- Source page label: 8.3.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137768

Keep in mind, however, that low noise isn’t the only consideration. For example, imagine that a participant blinked on every trial.
This would be very consistent, which would lead to a low SME (because the SME reflects the amount of trial-to-trial variability in
the data). However, the resulting averaged waveforms would mainly contain blink activity instead of ERPs, which could lead to
completely incorrect conclusions. So, you need to consider potential confounds as well as the data quality when selecting artifact
detection parameters.
You should also keep in mind that the SME quantifies the data quality of the averaged ERPs (which is, of course, influenced by the
noise in the EEG). As a result, the SME depends on the number of trials being averaged. That’s a good thing, because the number
of trials can have a big impact on your statistical power (Baker et al., 2020).
This page titled 8.3: Background- Why Do We Reject Artifacts? is shared under a CC BY 4.0 license and was authored, remixed, and/or curated
by Steven J Luck directly on the LibreTexts platform.
8.3.2 https://socialsci.libretexts.org/@go/page/137768

<!-- source_pdf=Full.pdf pdf_page=202 source_page_label="8.4.1" source_url="https://socialsci.libretexts.org/@go/page/137770" -->

## PDF page 202

- Source page label: 8.4.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137770

8.4: Background- The General Approach
The general artifact detection/rejection procedure is pretty straightforward. For each participant, you apply an artifact detection
algorithm to the epoched EEG data. That algorithm determines which epochs contain artifacts, and those epochs are “marked” or
“flagged”. When you compute averaged ERPs, those epochs are simply excluded from the averages.
There are two main classes of approaches to determining which epochs should be flagged. The approach I prefer involves knowing
as much as possible about the nature of the artifacts (e.g., the typical waveshape and scalp distribution of a blink) and designing
algorithms that are tailored to those artifacts. The other approach involves asking which epochs are extreme or unusual in a
statistical sense. I don’t like this statistical approach as much because it’s not clear that “weird” epochs are necessarily problematic.
How many movies have you seen about high school students in which the “popular” students rejected kids who seemed “weird” but
were actually quite delightful? I just don’t like the idea of rejecting trials that seem “weird” but might actually be delightful.
I suspect that the two approaches actually end up mostly flagging the same epochs for rejection, so it may not matter which
approach you use in the end. And the most important factor when deciding what approach to take is to have a clear understanding
of the ultimate goal of artifact rejection. As described in the previous chapter, the ultimate goal is to accurately answer the
scientific question that the experiment was designed to address. So, go ahead and use statistical approaches to flagging epochs
for rejection if that leads you to this goal. Also, every area of research is different, so you should feel free to ignore any of my
specific pieces of advice if you have a better way of accurately answering your scientific questions.
As described in detail in Chapter 6 of Luck (2014), I advocate setting the artifact detection parameters individually for each
participant. In the present chapter, I will show you how to select appropriate parameters manually. There are also completely
automated approaches to selecting the parameters (e.g., Jas et al., 2017; Nolan et al., 2010). I haven’t used those approaches
myself, but they seem fairly reasonable. However, many people who use these approaches on a regular basis recommend verifying
that the parameters are working well and not just accepting them blindly. So, these approaches end up not being fully automatic. An
ERP Boot Camp participant, Charisse Pickron, suggested another excellent use for the automated algorithms: When you’re first
learning to set artifact detection parameters, you can check your parameters against the automated parameters so that you have
more confidence in the parameters that you’ve set.
Some participants have so many artifacts that an insufficient number of trials remains to create clean averaged ERP waveforms.
The standard procedure is to exclude those participants from the final analyses. However, you must have an objective, a priori
criterion for exclusion. Otherwise, you will likely bias your results (as explained in the text box below). In my lab’s basic science
research, we always exclude participants if more than 25% of trials are rejected because of artifacts (aggregated across conditions).
In our research on schizophrenia, where the data are noisier and the participants are much more difficult and expensive to recruit,
we exclude participants if more than 50% of trials are rejected. We apply these criteria rigidly in every study, without fail. A
different criterion might make sense in your research. Just make sure that the criterion is objective and determined before you see
the data.
Although this chapter focuses on detecting and rejecting artifacts, I would like to encourage you to start thinking about artifacts
before you record the EEG. This advice follows from something I call Hansen’s Axiom: “There is no substitute for clean data” (see
Luck, 2014). It’s much better to minimize artifacts during the recording instead of trying to reject or correct them afterward.
Strategies for minimizing artifacts are described in Chapter 6 of Luck (2014).
 Excluding Participants is Dangerous!
Imagine that you run an experiment, and your key statistical analysis yields a p value of .06 (the most hated number in
science!). You spent two years running the study, and the effect is going in the predicted direction, but you know you can’t
publish it if the effect isn’t statistically significant. Given the millions of steps involved in an ERP experiment, you might go
back through your data to make sure there wasn’t an error in the analysis. And imagine you find that 80% of the trials were
rejected for one of the participants, leading to incredibly noisy data. You would (very reasonably) conclude that this participant
should not have been included in the final analyses. So, you repeat the analyses without this participant, and now the p value is
.03. Hallelujah! You can now publish this important study.
8.4.1 https://socialsci.libretexts.org/@go/page/137770

<!-- source_pdf=Full.pdf pdf_page=203 source_page_label="8.4.2" source_url="https://socialsci.libretexts.org/@go/page/137770" -->

## PDF page 203

- Source page label: 8.4.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137770

Now imagine that the p value was originally .03, so you have no reason to go back through all the data. And imagine that your
final sample included a participant with 80% of trials rejected and very noisy data. And further imagine that excluding this
participant would lead to a p value of .06. But because the effect was significant in the initial analysis, you had no reason to go
back through the data, so you wouldn’t notice that this participant should have been excluded. And even if you did, would you
really have the intestinal fortitude to exclude the participant, even though this means that your p value is now .06?
This example shows why you need an a priori criterion for excluding participants. If you decide whom to exclude after you’ve
seen the results of the experiment, you’re more likely to notice and exclude participants when it makes your p value better
(because it was >.05 before you excluded participants) than when it makes your p value worse (because you don’t notice
participants who should be excluded when p < .05). As a result, this creates a bias to find p < .05 even when there is no true
effect. So, you should develop an a priori criterion for excluding participants before you see the results.
This page titled 8.4: Background- The General Approach is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
8.4.2 https://socialsci.libretexts.org/@go/page/137770

<!-- source_pdf=Full.pdf pdf_page=204 source_page_label="8.5.1" source_url="https://socialsci.libretexts.org/@go/page/137772" -->

## PDF page 204

- Source page label: 8.5.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137772

8.5: Exercise- Simple Blink Detection
It’s now time to see how artifact detection works in actual data. We’ll start by detecting blinks, which are big and easy to detect.
We’ll begin with the most common blink detection algorithm, which simply asks whether the voltage falls outside a specified range
at any point in the epoch for a given channel. This is a pretty primitive algorithm, and the next exercise will show you a much
better approach.
Start by loading the data from Subject #1 in the MMN experiment, which is in the file named 1_MMN_preprocessed_interp. This
is the same dataset that we examined in the previous chapter, after the C5 channel was interpolated. Artifact detection operates on
epoched data, so select EEGLAB > ERPLAB > Extract bin-based epochs, using an epoch of -200 to 800 ms and Pre as the
baseline. Name the resulting dataset 1_MMN_preprocessed_interp_be. Now select EEGLAB > ERPLAB > Artifact detection
in epoched data > Simple voltage thresholds and set the parameters as shown in Screenshot 8.1. In particular, specify 33 as the
Channel (this is the VEOG-bipolar channel) and voltage limits of -100 100. These voltage limits indicate that an epoch should be
flagged for rejection if the voltage is more negative than -100 µV or more positive than +100 µV at any time in this channel. Blinks
will be largest in the VEOG-bipolar channel, so there’s no point in looking for blinks in other channels. We’ll worry about other
types of artifacts later.
You might wonder why the default Test period is set to -199.2 796.9 rather than -200 800 (which is what you specified for the
epoch). The answer is that the data were originally sampled at 1024 Hz and were then downsampled to 256 Hz for the analyses
provided in the ERP CORE paper. As a result, we have a sample every 3.90625 ms, and we don’t have samples at exactly -200 and
+800 ms. In the previous chapters, I downsampled to 200 Hz instead, yielding a sample every 5 ms. But I thought it was time for
you to see what happens when the sampling period isn’t a nice round number.
Don’t worry about the flags; I’ll discuss them later. Click ACCEPT to apply the algorithm to the selected dataset.
Screenshot 8.1
Once the algorithm has finished, you will see two windows. One is the standard window for saving the updated dataset. The other
is the standard window for plotting EEG waveforms. The idea is that you’ll use the plotting window to make verify that the artifact
8.5.1 https://socialsci.libretexts.org/@go/page/137772

<!-- source_pdf=Full.pdf pdf_page=205 source_page_label="8.5.2" source_url="https://socialsci.libretexts.org/@go/page/137772" -->

## PDF page 205

- Source page label: 8.5.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137772

detection worked as desired. If so, you’ll use the other window to save the dataset. If you’re not satisfied with which epochs were
flagged, you’ll click Cancel and try again with new artifact detection parameters.
However, before you start scrolling through the plotting window, it’s important to see how many artifacts were detected. This
information is shown in the Matlab command window. You can see the number and percentage of epochs in which artifacts were
detected in each bin and the total across bins. In most cases, I mainly worry about the total (because the percentage is much more
meaningful when based on a large number of trials). You can see that 17.8% of epochs were rejected. That’s reasonable. As noted
above, my lab always throws out any participants for whom more than 25% of epochs were rejected, so this participant would be
retained.
Now let’s scroll through the EEG data and see how well the algorithm performed at flagging epochs with blinks and not flagging
epochs without blinks. I recommend setting the vertical scale to 100. Keep in mind that we’re now looking at epochs rather than
continuous data, and the plotting window shows 5 epochs per screen by default. (If you have a large screen, I recommend going to
Settings > Time range to display in the plotting window and telling it to show 10 or even 15 epochs per screen.) Epochs that have
been flagged for artifacts are highlighted in yellow. Recall that Subject #1 had beautiful EEG in the beginning of the session, so
you won’t see any flagged epochs at first. But you still need to make sure that there aren’t any blinks that weren’t detected, so scroll
through the epochs and look at the VEOG and Fp1/Fp2 channels to make sure that everything looks okay.
Epoch 103 should be the first marked epoch (see Screenshot 8.2). The waveform for the offending channel is drawn in red. You can
see a classic blink shape and scalp distribution. Success!
But this is immediately followed by a failure in Epoch 104. Because we have a stimulus every 500 ms, but each epoch lasts for
1000 ms, the initial part of one epoch is the same as the latter part of the previous epoch. So, the blink that peaked just before 500
ms in Epoch 103 appears just before time zero in Epoch 104. Because the blink is during the baseline in Epoch 104, the baseline
correction procedure reduced the maximum voltage during the epoch, and the blink is not detected.
Screenshot 8.2
Keep scrolling. You’ll notice a large muscle burst in Epoch 107 that isn’t flagged. But that’s OK—we’re looking for blinks right
now, and we’ll test for other artifacts later. You’ll also see a blink that appears in the poststimulus period of Epoch 121 and in the
prestimulus period of Epoch 122. This blink was larger than the one in Epochs 103 and 104, and the blink was successfully
detected in both Epochs 121 and 122. The blink appearing in Epochs 162 and 163 was also successfully detected. However, the
blink that appears in Epochs 169 and 170 was missed in Epoch 170.
If you keep scrolling, you’ll also see that high-frequency noise (almost certainly EMG) caused Epoch 463 to be flagged. You can
tell that there was no blink in this epoch because there was no positive-going voltage in Fp1 and Fp2, just a small negative-going
voltage in VEOG-lower combined with some high-frequency noise. There is no reason to reject this epoch: The voltages in VEOG-
8.5.2 https://socialsci.libretexts.org/@go/page/137772

<!-- source_pdf=Full.pdf pdf_page=206 source_page_label="8.5.3" source_url="https://socialsci.libretexts.org/@go/page/137772" -->

## PDF page 206

- Source page label: 8.5.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137772

lower are very localized and unlikely to impact our scalp EEG recordings. Epochs 525 and 526 are also unnecessarily flagged for
rejection. In these epochs, a combination of a slow, non-blink-like voltage deflection and high-frequency noise in Fp2 (but without
an opposite-polarity deflection in VEOG-lower) produced a large enough voltage in VEOG-bipolar for the voltage to exceed our
±100 µV threshold.
You can now close the plotting window and save the dataset that was created, naming it
1_MMN_preprocessed_interp_be_ar100. We’ll need it for a later exercise.
This page titled 8.5: Exercise- Simple Blink Detection is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
8.5.3 https://socialsci.libretexts.org/@go/page/137772

<!-- source_pdf=Full.pdf pdf_page=207 source_page_label="8.6.1" source_url="https://socialsci.libretexts.org/@go/page/137774" -->

## PDF page 207

- Source page label: 8.6.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137774

8.6: Exercise- Adjusting the Threshold
In this exercise, we’ll see how adjusting the threshold changes which epochs are flagged for rejection. Let’s start by seeing if we
can detect some of the blinks that were missed with our ±100 µV threshold. Make 1_MMN_preprocessed_interp_be the active
dataset, and then select EEGLAB > ERPLAB > Artifact detection in epoched data > Simple voltage thresholds. Change the
voltage limits to -50 50 to indicate that an epoch should be flagged for rejection if the voltage is more negative than -50 µV or more
positive than +50 µV at any time in the VEOG-bipolar channel. Click ACCEPT to run the artifact detection routine.
The first thing you should look at is the proportion of rejected trials, which is shown in the Matlab command window. Whereas
17.8% of epochs were flagged when our threshold was ±100 µV, now 42.9% have been flagged. If we were to use this ±50 µV
threshold, this participant would need to be excluded from the final analyses (because my lab excludes participants if more than
25% of trials were rejected). Obviously, you don’t want to exclude participants if you don’t have to, so let’s see if we really want to
use this threshold.
If you scroll through the epochs in the plotting window that appeared, you’ll see that the blinks in Epochs 104 and 170 have been
detected with this threshold. That’s the good news. But if you keep scrolling, you’ll see the bad news: Many epochs without a clear
blink are now flagged for rejection (e.g., Epochs 408, 424, 432, and 435-437). In general, decreasing the threshold for rejection
increases our hit rate (the proportion of blinks that were detected) but also increases our false alarm rate (the proportion of non-
blink epochs that are flagged for rejection).
Now let’s try increasing our threshold to avoid flagging epochs 463, 525, and 526, which were unnecessarily flagged for rejection
with our original threshold of ±100 µV. Close the plotting window and the window for saving the dataset, make sure that
1_MMN_preprocessed_interp is still the active dataset, and run the artifact detection routine using voltage limits to -150 150.
The percentage of flagged trials has now dropped to 11.3%. That’s good insofar as increasing the number of accepted trials will
increase our signal-to-noise ratio. But it might be bad if a lot of blinks have escaped detection.
If you scroll through the data, you’ll see that Epochs 463, 525, and 526 are no longer flagged for rejection, which is good.
However, several clear blinks have been missed (e.g., Epochs 103, 191, 201). In general, increasing the threshold for rejection
decreases the hit rate but also decreases the false alarm rate.
The take-home message of this exercise is that adjusting the threshold impacts both the hit rate and the false alarm rate, making one
better and the other worse. You’ll need to choose a threshold that balances the hit rate and false alarm rate in a way that best helps
you achieve the fundamental goal, which is to accurately answer the scientific question that the experiment is designed to address.
Is that goal best met by ensuring that all epochs with blinks are rejected, even if this means rejecting some perfectly fine epochs?
Or is the goal best met by optimizing the number of included epochs, even if a few blinks escape rejection?
The answer will depend on the nature of your scientific question, the details of your experimental design, and the nature of the
artifacts in your data. In particular, if blinks differ systematically across bins (especially in the time range of the ERP components
of interest), then you will usually need to make sure that the vast majority are rejected to avoid confounds. And if you have a
reasonably large number of trials, throwing out a few trials without blinks won’t really change your signal-to-noise ratio very much
(see the text box below). So, in most cases, I recommend erring on the side of throwing out too many trials rather than allowing
some large artifacts to remain in the data.
Also, as you’ll see in some of the later exercises, you can both increase your hit rate and decrease your false alarm rate by choosing
a better algorithm for determining which epochs contain artifacts. The simple voltage threshold we’ve used in this example is a
poor way of detecting blinks, and I’m always amazed that many software packages don’t provide better algorithms.
 Don’t Stress About Rejecting a Few Trials
It’s easy to get stressed out about excluding 20% or 50% of trials because of artifacts. Is this going to cause a 20% or 50%
reduction in your data quality? It turns out that excluding trials has a smaller impact on data quality than you might expect.
This is because the signal-to-noise ratio (SNR) increases as a function of the square root of the number of trials. This square
root rule is really annoying when you’re designing your experiment, because doubling the number of trials only increases your
8.6.1 https://socialsci.libretexts.org/@go/page/137774

<!-- source_pdf=Full.pdf pdf_page=208 source_page_label="8.6.2" source_url="https://socialsci.libretexts.org/@go/page/137774" -->

## PDF page 208

- Source page label: 8.6.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137774

SNR by 41% (because sqrt(2) = 1.41). But the same rule means that you don’t lose very much SNR when you have to exclude
some trials.
As an example, imagine that your single-trial SNR is 1:2 or 0.5 (i.e., your signal is half as big as your noise in the raw EEG
epochs). If you average together 100 trials, the resulting SNR is 0.5 x sqrt(100) = 5. Now imagine that you have to exclude 20
trials because of artifacts. Now your SNR is 0.5 x sqrt(80) = 4.47. That is, you’ve decreased the number of trials by 20%, but
your SNR has dropped by only about 10%.
Now imagine that you have to exclude 50 trials. The resulting SNR is 0.5 x sqrt(50) = 3.54. Even though you’ve decreased the
number of trials by 50%, your SNR has dropped by only about 30%.
As mentioned earlier, you should have an a priori threshold for excluding participants on the basis of the percentage of rejected
trials, and the square root rule will help you decide on what percentage to use as your threshold. How much is your statistical
power reduced by excluding a participant versus including participants with a reduced SNR? Usually, your power is reduced
more by excluding the participant unless so many trials were rejected that the SNR is truly awful.
However, this assumes that the artifacts are random, and the only difference between participants with lots of artifacts and
participants with few artifacts is the number of trials available for averaging. In my experience, this assumption is false.
Participants with a large number of artifacts tend to be less compliant with instructions, may be more sleep-deprived, and often
have poorer EEG signals even on the trials without artifacts. Our threshold for excluding participants (25% in basic science
studies, 50% in schizophrenia studies) is lower than would be necessary if we solely considered the square root rule.
In the future, we may switch to a rule that is based on the SME—a direct measure of data quality—rather than the percentage
of rejected trials. This might make it possible to avoid excluding participants whose averaged ERPs are quite clean even
though they had a lot of rejected trials and to exclude participants who didn’t have a lot of rejected trials but had noisy
averages nonetheless. This approach could be particularly valuable in research participants for whom it is difficult to obtain a
large number of trials (e.g., infants and small children).
This page titled 8.6: Exercise- Adjusting the Threshold is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven
J Luck directly on the LibreTexts platform.
8.6.2 https://socialsci.libretexts.org/@go/page/137774

<!-- source_pdf=Full.pdf pdf_page=209 source_page_label="8.7.1" source_url="https://socialsci.libretexts.org/@go/page/137776" -->

## PDF page 209

- Source page label: 8.7.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137776

8.7: An Iterative Approach to Setting Parameters
Many researchers use a preset artifact detection threshold for all participants, but this is not optimal. A threshold that works well for
one participant might fail to flag all the blinks for another participants and might lead many non-blink epochs to be flagged in a yet
another participant. I therefore recommend the interactive and iterative approach shown in Figure 8.1. It involves starting with an
initial set of best-guess parameters, seeing whether these parameters adequately flag the epochs that should be rejected, and then
adjusting the parameters as necessary until you are satisfied. As will be described in the next section, it also involves using the
standardized measurement error (SME) to help you determine which parameters lead to the best balance of eliminating noisy trials
while still having enough trials to obtain a good averaged ERP waveform.
Make sure you keep a record of the parameters you choose for each participant. I recommend using a spreadsheet for this. The
example script at the end of the chapter shows you how a script can read the artifact detection parameters from a spreadsheet and
then perform the artifact detection with these parameters. That will keep you from having a meltdown when you need to reprocess
your data the seventh time. In fact, it’s a good idea to set the parameters manually and then immediately reprocess the data using a
script with those parameters. It’s easy to make a mistake when you’re processing data by pointing and clicking in a GUI, and this
approach of manually selecting the parameters and then implementing them in a script gives you the customized parameters that
you want while avoiding point-and-click errors.
I find this iterative approach to be reasonably quick (5-10 minutes for most participants once you’ve become well practiced). And it
does an excellent job of addressing the three types of problems that were described at the beginning of the chapter. However, other
approaches may be better in certain cases.
If you have a small number of trials per participant (as in many infant studies) or a small number of highly valuable participants (as
in some studies of lesion patients), you may want to manually mark epochs for rejection during the visual inspection process. That
is, you can mark an epoch for rejection by simply clicking on it (select EEGLAB > Tools > Reject data epochs > Reject by
inspection; see the ERPLAB documentation for information about how to integrate these marks with ERPLAB). However, this
approach is slow and awkward when you have more than ~20 trials per participant or more than ~20 participants.
Another alternative is to use one of the algorithms that automatically set the parameters for each participant (e.g., Jas et al., 2017;
Nolan et al., 2010; Talsma, 2008). This approach is best suited for very large datasets (e.g., >100 participants), and it should be
followed by manual verification for each participant. Note that most current algorithms assess the overall noise level of the data
rather than assessing the data quality for the specific amplitude or latency measure that you will be using as the main dependent
variable to test your scientific hypotheses (which is what the SME does). As a result, these algorithms may not actually select
optimal parameters in terms of statistical power.
8.7.1 https://socialsci.libretexts.org/@go/page/137776

<!-- source_pdf=Full.pdf pdf_page=210 source_page_label="8.7.2" source_url="https://socialsci.libretexts.org/@go/page/137776" -->

## PDF page 210

- Source page label: 8.7.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137776

Figure 8.1. Iterative procedure for setting artifact detection parameters. If no satisfactory parameters can be found without
exceeding the maximal allowable percentage of trials with artifacts, then the participant must be excluded from the final analyses.
This page titled 8.7: An Iterative Approach to Setting Parameters is shared under a CC BY 4.0 license and was authored, remixed, and/or curated
by Steven J Luck directly on the LibreTexts platform.
8.7.2 https://socialsci.libretexts.org/@go/page/137776

<!-- source_pdf=Full.pdf pdf_page=211 source_page_label="8.8.1" source_url="https://socialsci.libretexts.org/@go/page/137778" -->

## PDF page 211

- Source page label: 8.8.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137778

8.8: Exercise- Data Quality and Confounds
When deciding on artifact rejection parameters, a key question is whether the data quality will be increased or decreased by making
the rejection threshold more liberal (rejecting fewer trials) or more conservative (rejecting more trials). We can answer that
question quantitatively by looking at the SME values that result from different rejection parameters. However, we also need to
determine whether the artifacts are creating confounds, which involves inspecting the averaged ERP waveforms in several ways. In
this exercise, we’ll go through the steps needed to check both the data quality and the waveforms.
Let’s start by looking at the SME values and waveforms that we get without any rejection. Select the dataset with the ±100 µV
threshold (1_MMN_preprocessed_interp_be_ar100) and then select EEGLAB > ERPLAB > Compute averaged ERPs. Near
the top of the averaging GUI, select Include ALL epochs (ignore artifact detections). This will allow us to see what we would get
without any artifact rejection. As described in the preceding chapter, select On – custom parameters in the Data Quality
Quantification section and add a time window of 125 to 225 ms (the time window we will ultimately use to measure MMN
amplitude). Click RUN, and name the resulting ERPset 1_ar_off.
If you look at the data quality table, you’ll see that the aSME at FCz during the custom time period of 125-225 ms is 0.5524 for the
deviant stimuli (Bin 1) and 0.3641 for the standards (Bin 2). (Leave the data quality window open for comparison with later steps.)
Now plot the ERP waveforms. You can see some relatively large, slow deviations in the Fp2, VEOG-lower, and VEOG-bipolar
channels. The key channels are shown in Figure 8.2.A, but I’ve applied a 20 Hz low-pass filter to more easily see the blink-related
activity. If you look closely at the FCz channel, which will be the primary channel for our MMN analyses, you can see some of this
same blink-related activity (i.e., the “tilt” in the prestimulus period).
Figure 8.2. Averaged ERPs from Subject #1 in the MMN experiment, with no rejection or correction (A), including only epochs
flagged for blinks (B), after rejection of epochs with blinks using an absolute voltage threshold of ±100 µV (C), and after ICA-
based correction of blinks (D). To improve visualization of the data, the averaged waveforms were low-pass filtered with a half-
amplitude cutoff at 20 Hz and a slope of 12 dB/octave. Note the different scale in (B).
Are the large, slow voltage deviations in Figure 8.2.A a result of blinks that are confounding the ERPs, or are they brain activity?
One way to answer this question is to look for a polarity reversal under versus over the eyes. The activity prior to ~200 ms is more
negative for deviants than for standards both under the eyes (VEOG-lower) and above the eyes (Fp2), so this experimental effect is
probably not blink-related. However, the later voltage is more negative for deviants than for standards under the eyes but more
positive for deviants than for standards above the eyes. This polarity inversion is suggestive of a blink confound (although it is
possible for brain-generated activity to invert in polarity above versus below the eyes).
8.8.1 https://socialsci.libretexts.org/@go/page/137778

<!-- source_pdf=Full.pdf pdf_page=212 source_page_label="8.8.2" source_url="https://socialsci.libretexts.org/@go/page/137778" -->

## PDF page 212

- Source page label: 8.8.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137778

Another way to address this question is to reverse the usual artifact rejection procedure and include only the flagged trials in our
averages, leaving out the unflagged trials. Any blink-related confounds should be much bigger in these averages, whereas brain
activity should not. To do this, run the averaging tool again, but this time select Include ONLY epochs marked with artifact
rejection. If you look at the resulting waveforms, you’ll see that the differences between deviants and standards prior to ~200 ms
are about the same as before, but the differences after 200 ms are now much larger (see Figure 8.2.B). This provides additional
evidence that the participant was more likely to blink following deviant stimuli than following rare stimuli (even though the
auditory stimuli were task-irrelevant). Thus, blinking is not just a source of noise in this experiment; it's a confound that could
create artifactual differences between conditions during the latter part of the epoch.
Now let’s look at the data quality and waveforms when we reject trials that were flagged for blinks. You can just repeat the
averaging process, but select Exclude epochs marked during artifact detection so that the flagged epochs are excluded. If you
keep the previous table of data quality values open, and open a new table for the current ERPset, you’ll see that the aSME at FCz
from 125-225 ms has dropped from 0.5524 to 0.5436 for the deviant stimuli and from 0.3641 to 0.3377 for the standards. We have
fewer trials as a result of artifact rejection, but the data quality has improved. The improvement isn’t very large, because we now
have fewer trials and because the blinks that we’ve removed are not huge at the FCz site. But it’s still good to see that we get better
data quality even though we have fewer trials in the averages. (There is a much larger improvement in data quality at Fp1 and Fp2,
where the blinks were a large source of trial-to-trial variation.)
Even though rejecting epochs with blinks hasn’t improved our data quality much, at least it hasn’t hurt our data quality. And
rejecting blinks helps us avoid blink-related confounds: if you plot the waveforms, you’ll see that we’ve reduced the slow voltage
deviations in the VEOG, Fp2, and FCz channels. You can see this quite clearly in Figure 8.2.C, where the voltage deviations are
now reduced relative to the no-rejection data shown in Figure 8.2.A. You can see substantial differences between the standards and
the deviants in the VEOG-bipolar channel in the absence of artifact rejection, which suggests that the blinks were not random and
differed systematically between trial types. These difference are largely eliminated by artifact rejection.
As described at the beginning of the chapter, artifact rejection is designed to deal with three specific problems: reduced statistical
power, systematic confounds, and sensory input problems. The artifact rejection procedure that you’ve performed has achieved the
first two of these goals: you’ve slightly reduced the noise (as evidenced by the lower aSME values) and thereby increased the
statistical power, and you’ve minimized a confound (differential blink activity between standards and deviants).
Figure 8.2.D shows the results with ICA-based correction of blink artifacts (which will be covered in the next chapter). You can
see that this approach eliminated blink-related activity better if you look at the VEOG-bipolar channel, which largely isolates blink-
related activity. This channel is nearly flat in the corrected data but not in the rejected data. However, the corrected and rejected
waveforms look nearly identical at the FCz site—which is what we really care about—except that the rejected waveforms are
noisier because we’ve lost some trials in the rejection process. This shows that rejection is working reasonably well: We’re
eliminating confounding activity from the blinks without a huge reduction in data quality. However, the waveforms appear to be
cleaner for the corrected data (because we’ve retained all the epochs), and I confirmed this by computing SME values (which were
0.4992 for the deviants and 0.2815 for the standards). Because of this better data quality, I usually prefer ICA-based artifact
correction instead of rejection for blinks. However, we still reject trials with blinks that occur near the time of the stimulus in visual
experiments, because we want to exclude trials on which the participant could not see the stimulus.
An important take-home message of this exercise is that artifact rejection is designed to address three specific problems, and you
want to choose the parameters that best solve these problems. You can assess data quality and statistical power by examining the
SME values. You can assess confounds by looking for polarity inversions above versus below the eyes in the averaged ERP
waveforms. It also helps to view the waveforms for averages of all epochs, averages of just the epochs with artifacts, and averages
that exclude epochs with artifacts. Blinks and eye movements don’t create obvious problems with the sensory input in most
auditory paradigms, but we will see how they impact a visual paradigm near the end of the chapter.
This page titled 8.8: Exercise- Data Quality and Confounds is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
8.8.2 https://socialsci.libretexts.org/@go/page/137778

<!-- source_pdf=Full.pdf pdf_page=213 source_page_label="8.9.1" source_url="https://socialsci.libretexts.org/@go/page/137780" -->

## PDF page 213

- Source page label: 8.9.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137780

8.9: Exercise- Better Blink Detection
In a previous exercise, we saw that changing the threshold for rejection affects both the hit rate (the proportion of artifacts detected)
and the false alarm rate (the proportion of non-artifact trials that are flagged for rejection). If you change the threshold to make one
better, this inevitably makes the other one worse. However, there is something you can change that can improve both the hit rate
and the false alarm rate. Specifically, you can use an artifact detection algorithm that is better designed to isolate blinks from other
kinds of voltage deflections.
The simple voltage threshold algorithm that we have used so far in this chapter is an overly simplistic way of detecting blinks. It
treats any large voltage as a blink, not taking into account the shape of the blink waveforms. As a result, it ends up flagging trials
that don’t contain blinks and misses some of the true blinks. We can improve blink detection by taking into account the fact that
blinks are relatively short-term changes in voltage that typically last ~200 ms. In this exercise, we’ll look at two artifact detection
algorithms that take this into account and work much better for blink detection.
The first is called the moving window peak-to-peak algorithm, and it’s illustrated in Figure 8.3. With its default parameters and our
epochs of -200 to 800 ms, this algorithm will start by finding the difference in amplitude between the most positive and most
negative points (the peak-to-peak voltage) between -200 and 0 ms (a 200-ms window). Then, the window will move 100 ms to the
right, and the algorithm will find the peak-to-peak voltage between -100 and 100 ms. The window will keep moving by 100 ms,
finding the peak-to-peak amplitude from 0 to 200 ms, 100 to 300 ms, etc. It then finds the largest of these peak-to-peak amplitudes
for a given epoch and compares that value to the rejection threshold.
Figure 8.3.A illustrates the application of this algorithm to a trial with a blink. You get a large peak-to-peak amplitude during the
period of the blink because of the relatively sudden change in voltage. However, the algorithm isn’t “fooled” by the slow drift
shown in Figure 8.3.B.
Figure 8.3. Moving window peak-to-peak algorithm. The peak-to-peak amplitude is determined in each window, and then the
maximum of these values for a given epoch is compared with the rejection threshold.
Let’s try it. Go back to 1_MMN_preprocessed_interp_be as the active dataset and select EEGLAB > ERPLAB > Artifact
detection in epoched data > Moving window peak-to-peak threshold. Set the window width to 200 ms and the window step to
100 ms (so that we get a 200-ms window every 100 ms). Set the threshold to 100 and the channel to 33 (VEOG-bipolar). Click
ACCEPT to run the routine.
The first thing to note is that 28.2% of trials have been flagged for rejection. That’s a lot more than we had with the absolute
voltage threshold; we’ll discuss the reasons for that in a moment.
If you scroll through the data, you’ll see that every clear blink has now been flagged (including Epochs 104 and 170, which were
missed by the absolute threshold algorithm). However, more trials with muscle noise have now been flagged for rejection. Here’s
why: Imagine that the muscle noise causes the voltage to vary from -55 to +55 µV between 200 and 400 ms. This doesn’t exceed
the absolute threshold of ±100 µV, but it creates a peak-to-peak amplitude of 110 µV, exceeding our threshold for the peak-to-peak
amplitude. One way to solve this would be to increase the threshold to something like 120 µV. However, this would cause us to
start missing real blinks.
Another approach would be to apply a low-pass filter prior to artifact detection. Let’s give that a try. Go back to
1_MMN_preprocessed_interp_be as the active dataset and select EEGLAB > ERPLAB > Artifact detection in epoched data >
Moving window peak-to-peak threshold. Keep the parameters the same, but check the box labeled Low-pass prefiltering… and
set the Half-amplitude cutoff to 30. This option creates a hidden copy of the dataset, applies the filter to it, and applies the artifact
8.9.1 https://socialsci.libretexts.org/@go/page/137780

<!-- source_pdf=Full.pdf pdf_page=214 source_page_label="8.9.2" source_url="https://socialsci.libretexts.org/@go/page/137780" -->

## PDF page 214

- Source page label: 8.9.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137780

detection algorithm to this hidden copy. The artifact detection flags are then copied to the original dataset. That way, you get the
benefits of prefiltering the data in terms of flagging appropriate trials, but you end up with your original unfiltered data.
Click Accept to run the artifact detection routine. You’ll see that only 13.0% of trials are flagged for rejection (compared to 28.2%
without prefiltering). If you scroll through the data, you’ll see that all the clear blinks are flagged, but the trials with EMG noise are
not. If you check the data quality measures using EEGLAB > ERPLAB > Compute data quality metrics (without averaging),
you’ll see that the aSME for FCz has improved slightly relative to the rejection based on the absolute voltage threshold. And if you
plot the ERP waveforms, you’ll see that they’re quite similar to what we found with the absolute voltage threshold.
So, the moving window peak-to-peak algorithm is definitely superior to the absolute voltage threshold algorithm. It doesn’t make a
huge difference with this participant, but it makes a big difference for some participants and some experimental paradigms.
However, in many cases, you’ll want to use the low-pass prefilter option.
Now let’s look at another algorithm that works quite well but doesn’t require any low-pass filtering. I call this algorithm the step
function, because I developed it to detect the step-shaped voltage deflections produced by saccadic eye movements in N2pc
paradigms. I eventually discovered that it also works great for detecting blinks.
The step function also involves a moving window, with 200 ms as a reasonable default value for most studies. Within a 200-ms
window, this algorithm calculates the difference between the mean voltage in the first half of the window and the mean voltage in
the second half of the window. It then finds the largest of these differences for all the windows in a given epoch, and it compares
the absolute value of this difference to the rejection threshold. For example, the window indicated by the red lines in Figure 8.3.A
has an amplitude of approximately 20 µV during the first half and approximately 70 µV during the second half, so this would be a
difference of approximately 50 µV. That wouldn’t exceed a threshold of 100 µV, but you can use a lower threshold with the step
function than with the other algorithms. Also, you will get the largest voltage from a blink if the center of the window is just
slightly before the start of the blink, and a smaller step size (e.g., 10 ms) tends to be better.
Let’s try it. Go back to 1_MMN_preprocessed_interp_be as the active dataset and select EEGLAB > ERPLAB > Artifact
detection in epoched data > Step-like artifacts. Set the parameters as shown in Screenshot 8.3. Specifically, set the window
width to 200 ms and the window step to 10 ms (so that we get a 200-ms window every 10 ms). Set the threshold to 50 µV and the
channel to 33. Click ACCEPT to run the routine.
8.9.2 https://socialsci.libretexts.org/@go/page/137780

<!-- source_pdf=Full.pdf pdf_page=215 source_page_label="8.9.3" source_url="https://socialsci.libretexts.org/@go/page/137780" -->

## PDF page 215

- Source page label: 8.9.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137780

Screenshot 8.3
You should first note that 13.1% of trials have been flagged for rejection, which is nearly identical to what we obtained when we
used the moving window peak-to-peak algorithm with the prefiltering option. But note that no filtering is required with the step
function: when the step function algorithm averages across each half of the 200-ms window, high-frequency activity is virtually
eliminated.
If you scroll through the EEG, you’ll see that the algorithm has successfully flagged all of the clear blinks without flagging many
non-blink trials. In my experience, the step function works slightly better than the moving average peak-to-peak algorithm
(especially when there is a lot of EMG noise) and significantly better than absolute voltage thresholds. It’s what I recommend for
detecting blinks in most cases.
This page titled 8.9: Exercise- Better Blink Detection is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
8.9.3 https://socialsci.libretexts.org/@go/page/137780

<!-- source_pdf=Full.pdf pdf_page=216 source_page_label="8.10.1" source_url="https://socialsci.libretexts.org/@go/page/137782" -->

## PDF page 216

- Source page label: 8.10.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137782

8.10: Exercise- Detecting Eye Movements
By this point, I hope you have a good idea of how to detect and reject blinks. In this exercise, we’ll look at another common
artifact, saccadic eye movements. Depending on the nature of the experiment, saccadic eye movements can be an enormous
problem or largely irrelevant. How can you tell? The answer, as always, is to think about the three problems that artifact rejection is
designed to solve. Because the MMN experiment uses auditory stimuli, changes in eye position won’t directly impact the sensory
input. And because participants were watching a silent movie at fixation during the experiment, there is no reason to suspect that
the eyes will move in different directions for deviant versus standard trials (although this is something that we should verify rather
than assume). If the eye movements have a random direction, then they will cancel out (because the polarity reverses for opposite
directions) and are unlikely to be a confound. So, the main question is whether the eye movements add significant noise and
decrease our statistical power. We can use the SME values to determine whether rejecting trials with eye movements helps us
(because it reduces a source of noise) or hurts us (because it reduces the number of trials).
Subject #1 in the MMN experiment made no obvious eye movements while doing the task, so we’re going to look at Subject #10
for this exercise. At this point, I’d recommend quitting and restarting EEGLAB. You can then load the dataset named
10_MMN_preprocessed.set. Take a quick look to familiarize yourself with this participant’s EEG. Ordinarily, you’d look carefully
and think about whether to interpolate any channels, but here we’ll just focus on the eye movements.
To make the eye movements easier to visualize, we’re going to start by applying a low-pass filter to minimize high-frequency
noise. Selected EEGLAB > ERPLAB > Filter & Frequency Tools > Filters for EEG data and apply a low-pass filter with a 30
Hz half-amplitude cutoff and a slope of 12 dB/octave. Save the resulting dataset as 10_MMN_preprocessed_filt. Then epoch the
data with EEGLAB > ERPLAB > Extract bin-based epochs, using a time range of -200 800 ms and Pre as the baseline. Save the
resulting dataset as 10_MMN_preprocessed_filt_be. Now we’re ready to look at the eye movements.
 Why We’re Filtering Now
Earlier, I said that filtering out high-frequency noise isn’t necessary for the step function. So, why am I asking you to filter the
data here? The answer is simple: At this point, I want you to learn what eye movements look like, and the filtering will help
with that. The filtering will have virtually no impact on the operation of the step function algorithm.
Unless the participant is tracking moving objects or is walking around, most of the eye movements you’ll see will be saccades
(sudden shifts in gaze position). Saccades produce a sudden change from one voltage level to another in the EOG electrodes. Plot
the EEG data and go to Epoch 7. It should look something like Screenshot 8.4. To see the eye movements more clearly, I’ve
selected Settings > Number of channels to display in the plotting window and entered 6 as the number of channels, and I’ve told
it to display only one epoch at a time with Settings > Time range to display.
8.10.1 https://socialsci.libretexts.org/@go/page/137782

<!-- source_pdf=Full.pdf pdf_page=217 source_page_label="8.10.2" source_url="https://socialsci.libretexts.org/@go/page/137782" -->

## PDF page 217

- Source page label: 8.10.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137782

Screenshot 8.4
You can see a classic saccadic eye movement pattern at 400 ms in Epoch 7. The voltage is fairly flat for a few hundred
milliseconds, and then there is a sudden shift in the EOG channels, followed by a relatively flat signal at a different voltage level
until a blink occurs near the end of the epoch. This is because in a saccadic eye movement, gaze is fixed at one location for a period
of time, then moves rapidly, and then remains fixed at a new location for a period of time. At ~400 ms, the voltage goes more
positive at HEOG-right and more negative at HEOG-left, indicating a rightward eye movement. But the voltage simultaneously
shifts in the positive direction at VEOG-lower, meaning that the eye movement is actually angled downward as well.
This participant has a fairly large number of blinks, and we should deal with those before we assess the effects of the eye
movements. To flag the blinks, select EEGLAB > ERPLAB > Artifact detection in epoched data > Step-like artifacts and set
the window width to 200 ms, the window step to 10 ms, the threshold to 50 µV, and the channel to 33. Also, click the 2 button in
the Mark Flag section (this will be explained a little later). Click ACCEPT to run the routine. If you scroll through the data, you’ll
see that the algorithm did a good job of flagging epochs with clear blinks. Save the dataset, naming it
10_MMN_preprocessed_filt_be_noblinks.
Now we’re going to flag trials with horizontal eye movements. In some tasks, the stimuli are presented to the left or right of
fixation, so most of the eye movements are horizontal. In the MMN task, participants watched a silent movie, so the eye
movements might be in any direction. Consequently, we would ordinarily want to detect both horizontal and vertical eye
movements in this task. However, it will be easier to understand what’s going on in this exercise if we just look for horizontal eye
movements.
To flag the horizontal eye movements, start with the dataset you just created (10_MMN_preprocessed_filt_be_noblinks) and
select EEGLAB > ERPLAB > Artifact detection in epoched data > Step-like artifacts. Keep the window width at 200 ms and
the window step at 10 ms, but change the channel to 32 (HEOG-bipolar). You should also lower the threshold to 32 µV. I like to use
multiples of 16 µV for horizontal eye movements because, for the average participant, each degree of eye rotation increases the
8.10.2 https://socialsci.libretexts.org/@go/page/137782

<!-- source_pdf=Full.pdf pdf_page=218 source_page_label="8.10.3" source_url="https://socialsci.libretexts.org/@go/page/137782" -->

## PDF page 218

- Source page label: 8.10.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137782

HEOG voltage by 16 µV (Lins et al., 1993). A threshold of 32 should therefore detect eye movements of approximately 2° or
larger.
You should also click the 3 button in the Mark Flag section. These flags are used to keep track of different types of artifacts. Flag
1 is always set for any artifact, but you can add other flags. When you detected blinks, you told it to set Flag 2. Here we’re going to
set Flag 3 for horizontal eye movements. This will allow us to get a separate count of the number of blinks and the number of
horizontal eye movements.
Click ACCEPT to run the routine. Before you scroll through the EEG, take a look at the summary of artifacts in the Matlab
command window, which should look something like this:
Bin #(%) accepted #(%) rejected # F2 # F3 # F4 # F5 # F6 # F7
# F8
1 118( 59.0) 82( 41.0) 64 66 0 0 0
0 0
2 341( 58.4) 243( 41.6) 185 211 0 0 0
0 0
_______________________________________________________________________________________
____
Total 459( 58.5) 325( 41.5) 249 277 0 0 0
0 0
When we previously detected trials with blinks, 31.8% of epochs were flagged for rejection (collapsed across bins). That has now
increased to 41.5% (270 epochs). The column labeled #F2 shows the number of epochs with Flag 2 set (blinks), and the column
labeled #F3 shows the number of epochs with Flag 3 set (horizontal eye movements). In Bin 1, for example, 82 epochs were
flagged for rejection overall, with 64 epochs with Flag 2 and 66 epochs with Flag 3. Of course, 64 + 66 is not equal to 82, because
some trials were flagged for both blinks and eye movements. There were 18 trials flagged for eye movements that weren’t flagged
for blinks (because 82 total rejected epochs – 64 epochs flagged for blinks = 18 epochs flagged only for eye movements).
 Too Many Blinks?
As described earlier, my lab excludes any participants with >25% rejected trials in our basic science experiments, so you might
expect that this participant would have been excluded. However, we used artifact correction to deal with blinks in the analyses
reported in the ERP CORE paper (Kappenman et al., 2021), so we did not need to exclude this participant.
Now take a look at the EEG and EOG data. (I recommend telling the plotting tool to display only 6 channels so that you can focus
on the EOG data.) You’ll see that the very first epoch was flagged for both blinks and eye movements (because both the VEOG-
bipolar and HEOG-bipolar waveforms are drawn in red in Epoch 1). The HEOG signal is clearly not an eye movement—it doesn’t
show the sudden step from one voltage level to another voltage level that is produced by a saccadic eye movement. Instead, the
blink that you can see in the VOEG-bipolar channel has “leaked” into the HEOG-bipolar channel (see the region marked with the
red oval in Screenshot 8.5). In an ideal world, a blink would produce equal activity to the sides of the two eyes, and the HEOG-left
minus HEOG-right subtraction would therefore eliminate the blink in the HEOG-bipolar channel. However, if one HEOG electrode
was placed a little higher or lower than the other, the blink activity won’t be identical at the left and right sites, and the subtraction
won’t completely eliminate the blink activity. This is one reason why a large number of epochs were flagged for both blinks and
eye movements.
8.10.3 https://socialsci.libretexts.org/@go/page/137782

<!-- source_pdf=Full.pdf pdf_page=219 source_page_label="8.10.4" source_url="https://socialsci.libretexts.org/@go/page/137782" -->

## PDF page 219

- Source page label: 8.10.4
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137782

Screenshot 8.5
In Epoch 6, you’ll see a clear eye movement (a step-like voltage change) in the HEOG-bipolar channel, which was correctly
flagged. The eye movement must have been diagonal, because it also created a step-like deflection at the same time in the VEOG-
bipolar channel. Only the HEOG-bipolar channel is drawn in red, however, because we applied the threshold of 32 µV only to the
HEOG-bipolar channel, and the deflection in the VEOG-bipolar channel was not big enough to be detected when we looked for
blinks with a threshold of 50 µV.
If you scroll through the whole dataset, you’ll see that many horizontal eye movements were successfully flagged, but others were
missed (e.g., Epochs 3, 67, 190, 389). Let’s reduce the threshold and see whether we can detect those artifacts. First, save the
current dataset, naming it 10_MMN_preprocessed_filt_be_noblinks_HEOG32. You’ll need it for the next exercise.
Now repeat the artifact detection process, keeping 10_MMN_preprocessed_filt_be_noblinks_HEOG32 as the active dataset so
that we can add to the previous detections. When you launch Artifact detection in epoched data > Step-like artifacts, reduce the
threshold to 16 and select the 4 button instead of the 3 button in the Mark Flag section. Click ACCEPT to run the routine, and
then take a look at the summary of artifacts in the Matlab command window, which should look something like this:
Bin #(%) accepted #(%) rejected # F2 # F3 # F4 # F5 # F6 # F7
# F8
1 71( 35.5) 129( 64.5) 64 66 128 0 0
0 0
2 183( 31.3) 401( 68.7) 185 211 394 0 0
0 0
_______________________________________________________________________________________
____
Total 254( 32.4) 530( 67.6) 249 277 522 0 0
0 0
8.10.4 https://socialsci.libretexts.org/@go/page/137782

<!-- source_pdf=Full.pdf pdf_page=220 source_page_label="8.10.5" source_url="https://socialsci.libretexts.org/@go/page/137782" -->

## PDF page 220

- Source page label: 8.10.5
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137782

You can see that we’ve now rejected a lot more trials than before (67.6% of the total). The #F3 column shows how many trials
were flagged with the previous threshold of 32 µV, and the #F4 column shows how many trials were flagged with the new
threshold of 16 µV. If you scroll through the data, you’ll see that almost all trials with a clear horizontal eye movement are now
flagged for rejection.
But do we really want to use this threshold, even though it means that we’d be rejecting over 2/3 of the trials? We’ll consider how
to answer that question in the next exercise. But first, save this dataset as 10_MMN_preprocessed_filt_be_noblinks_HEOG16.
This page titled 8.10: Exercise- Detecting Eye Movements is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
8.10.5 https://socialsci.libretexts.org/@go/page/137782

<!-- source_pdf=Full.pdf pdf_page=221 source_page_label="8.11.1" source_url="https://socialsci.libretexts.org/@go/page/137783" -->

## PDF page 221

- Source page label: 8.11.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137783

8.11: Exercise- Deciding on a Threshold for Eye Movements
To decide on the threshold for rejecting trials with eye movements, we need to return to our goals for artifact rejection. What
threshold maximizes our data quality while avoiding confounds in our data?
Let’s first consider whether horizontal eye movements are a confound in this experiment. Specifically, might horizontal eye
movements cause different voltages at our FCz electrode site on deviant trials relative to standard trials? This is unlikely for two
reasons. First, because FCz is on the midline, it should be near the line of zero voltage between the positive and negative sides of
the voltage field produced by horizontal eye movements. Second, there is no reason to suspect that the frequency of leftward versus
rightward eye movements would differ between deviants and standards. However, this is just an assumption, and we should check
to make sure.
We can assess this assumption by looking at the ERP waveforms without any artifact rejection. To do this, select the dataset for
Subject 10 that was created prior to any artifact detection (10_MMN_preprocessed_filt_be) and then select EEGLAB >
ERPLAB > Compute averaged ERPs. If you plot the resulting ERP waveforms, you’ll see a large voltage deflection for the
deviants in the VEOG-bipolar channel (indicated by the green box in Screenshot 8.6). You can also see that this voltage is opposite
in polarity below the eyes (VEOG-lower) versus above the eyes (Fp1 and Fp2; see the blue boxes in Screenshot 8.6). This indicates
that this participant blinked more following the deviants than following the standards, just as we saw for Subject 1 (see Figure
8.2.A). However, unlike Subject 1, Subject 10 showed this pattern even during the MMN time window, so blinks could confound
the MMN effects for this participant.
Screenshot 8.6
Now look at the HEOG-bipolar channel (indicated by the magenta box in Screenshot 8.6). The differences between deviants and
standards in that channel are not any larger than the noise deflections in the prestimulus baseline period. This tells us that we don’t
have to worry about differences between deviants and standards in the frequency of leftward versus rightward eye movements,
confirming our assumption. This means that we mainly need to be concerned about whether the eye movements are a source of
noise, not a confound.
To assess noise, we can ask how the artifact rejection impacted the SME values. Specifically, we’ll look at the SME values after
rejecting only trials containing blinks, rejecting trials with blinks and eye movements using a 32 µV eye movement threshold, and
8.11.1 https://socialsci.libretexts.org/@go/page/137783

<!-- source_pdf=Full.pdf pdf_page=222 source_page_label="8.11.2" source_url="https://socialsci.libretexts.org/@go/page/137783" -->

## PDF page 222

- Source page label: 8.11.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137783

rejecting trials with blinks and eye movements using a 16 µV eye movement threshold.
To start, let’s get the SME values after rejecting trials with blinks but before rejecting trials with eye movements. Make the dataset
named 10_MMN_preprocessed_filt_be_noblinks active, and EEGLAB > ERPLAB > Compute data quality metrics (without
averaging). In the Data Quality section of the GUI, select Custom parameters, click the Set DQ options… button, and create a
custom time range of 125-225 ms. Make sure that the main GUI is set to exclude epochs marked during artifact detection, and then
click RUN. In the data quality table that appears, look at the aSME values for Bin 1 and Bin 2 from the FCz channel in the 125-225
ms time range. These values will be our reference points for asking whether rejecting trials with eye movements makes the data
quality better (because of less random variation in voltage) or worse (because of a reduction in the number of epochs being
averaged together). Keep the data quality window open so that you can refer to it later.
Now repeat this process with the datasets in which eye movements were flagged for rejection using a threshold of 32 µV
(10_MMN_preprocessed_filt_be_noblinks_HEOG32) and 16 µV (10_MMN_preprocessed_filt_be_noblinks_HEOG16).
Compare the resulting data quality tables with the data quality table you obtained without rejection, focusing on the aSME values
for Bin 1 and Bin 2 from the FCz channel in the 125-225 ms time range.
These values are summarized in Table 8.1. You can see that the data quality was slightly reduced (i.e., the aSME was increased)
when large eye movements were rejected by means of the 32 µV threshold and substantially reduced when virtually all eye
movements were rejected by means of the 16 µV threshold. Given that the previous analyses indicated that horizontal eye
movements were not a confound, the 16 µV threshold appears to be taking us farther from the truth rather than closer to the truth
(because it impairs our ability to precisely measure MMN amplitude). The 32 µV threshold decreases the data quality only slightly
(probably because there is some benefit of reduced noise but some cost of a smaller number of trials). I would be inclined to go
with this 32 µV threshold (instead of not excluding trials with horizontal eye movements), even though it slightly reduces the data
quality, just in case there is some small confounding effect of large eye movements that wasn’t obvious.
Table 8.1. Effects of eye movement rejection on data quality and percentage of rejected trials.
Rejection aSME for Deviants aSME for Standards % Rejected
Blinks Only 0. 8264 0.5353 31.8%
Blinks + Eye Movements (32
0. 8335 0.5874 41.5%
µV)
Blinks + Eye Movements (16
0.9901 0.7437 67.6%
µV)
 Viewing a Summary of Artifacts
Table 1 shows the percentage of rejected trials. This information was printed to the Matlab Command Window when the data
quality metrics were computed (and are also printed when you average). If you want to see this information for a given dataset
at a later time, select the relevant dataset and then select EEGLAB > ERPLAB > Summarize artifact detection >
Summarize EEG artifacts in a table. You’ll then be asked where you want to save the summary. I usually choose Show at
Command Window.
As you have seen, there is some subjectivity involved with artifact rejection. In my experience, a well-trained researcher can
meaningfully increase the final data quality and avoid confounds by carefully setting the artifact detection parameters individually
for each participant in this manner. It takes some time, but you will get much faster as you gain experience. The two participants
we’ve examined so far in this chapter are particularly challenging cases that require some careful thought and analysis, but most of
the participants in this study were much more straightforward. I find that we can use a standard set of detection parameters in about
80% of participants in my lab’s basic science experiments, and it takes only 5 –10 minutes to verify that everything is working fine
in these participants.
Beyond the time investment, it’s also important to consider whether customizing the artifact rejection for each participant might
lead to some kind of bias in the results. Most basic science ERP studies involve within-subjects manipulations, in which the same
8.11.2 https://socialsci.libretexts.org/@go/page/137783

<!-- source_pdf=Full.pdf pdf_page=223 source_page_label="8.11.3" source_url="https://socialsci.libretexts.org/@go/page/137783" -->

## PDF page 223

- Source page label: 8.11.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137783

artifact detection parameters are used for all conditions for a given participant. Because the parameters are identical across
conditions, there is little opportunity for bias. In theory, the experimenter could try many different artifact detection parameters for
a given participant and then choose the parameters that produce the desired effect. But this is obviously cheating. If someone wants
to cheat, there are much easier ways to do it, so I don’t worry much about this possibility. To avoid unconscious bias, you should
avoid looking at the experimental effects in the averaged ERP waveforms when you’re setting the parameters (although you may
need to look at the averaged EOG waveforms to assess the presence of systematic differences in artifacts between conditions).
My advice is different for research that focuses on comparing different groups of participants (e.g., a patient group and a control
group). In these studies, the main comparisons are between participants, and now we may have different artifact detection
parameters for our different groups. This could lead to unintentional biases in the results. To minimize any biases, I recommend
that the person setting the artifact detection parameters for the individual participants should be blind to group membership. For
example, in my lab’s research on schizophrenia, the person setting the artifact detection parameters is blind to whether a given
participant is in the schizophrenia group or the control groups. That’s a bit of a pain, but it’s worth it to avoid biasing the results.
Note that some subjectivity also arises in artifact correction (e.g., choosing which ICA components to eliminate), so the person
doing the correction should also be blind to group membership.
 When to set artifact detection parameters (and how to avoid a catastrophe)
Imagine that you spend 9 months collecting data for an ERP study, and at the end you realized that there was a major problem
with the data that prevented you from answering the question that the study was designed to answer. Your heart would start
racing. Your face would become flushed. You would feel like vomiting. And you would want to crawl into a hole and never
come out.
Would you like to avoid that situation? If so, then here’s an important piece of advice: Do the initial processing of each
participant’s data within 48 hours of the recording session. This includes every step through averaging the data and examining
the averaged ERPs. Of course, this includes setting the artifact detection parameters. And it includes quantifying the behavioral
effects (which is the step that people most frequently forget).
If you don’t do this, there is a very good chance that there will be a problem with your event codes, or with artifacts, or with
something unique to your experiment that I can’t anticipate, and that this problem will make it impossible for you to analyze
your data at the end of the study. I have seen this happen many, many, many times. Many times!
You can catch a lot of these problems by doing a thorough analysis of the first participant’s data before you run any additional
participants. And in my lab, we have a firm rule that experimenters aren’t even allowed to schedule the second participant until
we’ve done a full analysis of the first participant’s data. I estimate that we catch a problem about 80% of the time when we
analyze the first participant’s data. So you absolutely must do this.
However, some problems don’t become apparent until the 5th or the 15th participant. And sometimes a new problem arises
midway through the study. For this reason, you really must analyze the data from each participant within a couple days.
There is another side benefit to this: You won’t be in the position of needing to set the parameters for 30 participants in a single
two-day marathon preprocessing session. Not only would these be two of the most dreariest days of your life, it would be
difficult for you to pay close attention and do a good job of setting the parameters. The task of setting the parameters is best
distributed over time.
This page titled 8.11: Exercise- Deciding on a Threshold for Eye Movements is shared under a CC BY 4.0 license and was authored, remixed,
and/or curated by Steven J Luck directly on the LibreTexts platform.
8.11.3 https://socialsci.libretexts.org/@go/page/137783

<!-- source_pdf=Full.pdf pdf_page=224 source_page_label="8.12.1" source_url="https://socialsci.libretexts.org/@go/page/137784" -->

## PDF page 224

- Source page label: 8.12.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137784

8.12: Exercise- Commonly Recorded Artifactual Potentials (C.R.A.P.)
By this point, I hope you have a good idea of how to detect and reject blinks and eye movements. Now we’ll shift to a class of
miscellaneous artifacts that I like to call Commonly Recorded Artifactual Potentials (C.R.A.P.). Whereas virtually all participants in
all experiments exhibit blinks and eye movements, which have a predictable waveshape and scalp distribution, C.R.A.P. artifacts
tend to be idiosyncratic in their waveshape and scalp distribution. This category includes EMG bursts, movement artifacts, skin
potentials, and sudden voltage changes of unknown origin.
In the ERP CORE experiments, our approach to C.R.A.P. was to apply both a simple voltage threshold and the moving window
peak-to-peak algorithm to all EEG channels. The simple voltage threshold is particularly good for detecting large drifts in voltage,
and a threshold of ±200 µV works well for most participants. The moving window peak-to-peak algorithm is good for detecting
muscle bursts and idiosyncratic artifacts that involve sudden voltage changes. The threshold for this routine needs to be adjusted for
each participant to ensure that large artifacts are detected without throwing out too many epochs. In most participants, we used a
threshold between 100 and 150 µV.
Let’s try the absolute voltage threshold of ±200 µV with Subject 10 from the MMN experiment. Make the dataset named
10_MMN_preprocessed_filt_be_noblinks active, and select EEGLAB > ERPLAB > Artifact detection in epoched data >
Simple voltage thresholds. Set the channels to 3:28, the voltage limits to -200 200, and the Flag 5 button. We’re leaving out Fp1,
Fp2, and the EOG channels so that we don’t end up flagging blinks. (I would ordinarily include Fp1 and Fp2, but it will be easier to
see how the artifact detection is working in this exercise without them.) Click ACCEPT to run the routine.
Now look at the artifact table in the Matlab command window. You’ll see that only 17 epochs were flagged by this new artifact test
(see the #F5 column in the table). We often catch a relatively small number of artifacts with this test, but that’s okay. Our goal here
is to get rid of rare but large artifacts.
Now scroll through the EEG. All of the epochs that were previously flagged for blinks are still flagged, but you’ll also see
occasional epochs that are flagged from our new absolute threshold test. The blinks are indicated by a red waveform for the VEOG-
bipolar channel, and the new artifacts are indicated by a red waveform for any of the channels between 3 and 28. For example,
Epoch 44 was flagged because of large voltage changes in the F7 and F8 channels. Epochs 43, 63, and 64 were also flagged
because of the F7 channel. If you keep scrolling, you’ll see a lot of large, sudden voltage changes in F7 (and to a lesser extent F8).
But not all of these sudden voltage changes were large enough to be flagged. There are also some fairly large artifacts of this nature
in PO4 that were too small to be flagged (but are still quite large). Our threshold of ±200 µV is designed to flag only very large
artifacts.
I don’t know what caused these artifacts in F7, F8, and PO4. They’re not biological in origin: With the exception of saccadic eye
movements, I don’t know of any biological signals that look like this, changing suddenly from one voltage level to another.
However, they’re about 100 times larger than the MMN, so they seem like a significant source of noise that will degrade our data
quality (i.e., increase the SME).
To verify this, go ahead and check the aSME values, using a custom window of 125-225 ms as before. As shown in Table 8.2, the
aSME values for the F7 channel were improved by removing the C.R.A.P. artifacts. Only 17 trials were rejected, but the artifacts
were quite large on those trials, so the rejection produced a noticeable improvement in the aSME values. Our main concern,
however, is the FCz channel, which will be used to quantify the MMN in our main analyses. Because the artifacts detected by the
absolute threshold test were not present in FCz, rejecting those 17 trials reduced the data quality in this channel, but only slightly.
Now let’s add a moving window peak-to-peak amplitude test to get rid of more C.R.A.P. epochs. Save the dataset created with the
absolute threshold test as 10_MMN_preprocessed_filt_be_noblinks_CRAP200. We’re going to add onto the flags in this dataset,
so make sure it’s the active dataset. Select EEGLAB > ERPLAB > Artifact detection in epoched data > Moving window peak-
to-peak threshold, set the threshold to 125, set the channels to 3:28, set the window length to 200, set the window step to 100, and
select the Flag 6 button. Note that the choice of 125 µV as the threshold was somewhat arbitrary. It’s just a reasonable starting point
that works well for the basic science studies in my lab.
If you look at the artifact table in the Matlab command window, you’ll see that 77 epochs were flagged by this test. However, many
of those epochs had previously been flagged for blinks and/or C.R.A.P., and the total number of flagged epochs has increased from
259 to 291. So, we’ve flagged an additional 32 epochs.
8.12.1 https://socialsci.libretexts.org/@go/page/137784

<!-- source_pdf=Full.pdf pdf_page=225 source_page_label="8.12.2" source_url="https://socialsci.libretexts.org/@go/page/137784" -->

## PDF page 225

- Source page label: 8.12.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137784

If you look at the EEG, you’ll see that we’ve now flagged many trials with sudden voltage shifts that were missed before, including
several in the PO4 channel. All of the epochs that were flagged certainly seemed to have pretty large artifacts in them. We’re not
flagging trials with “ordinary” EEG noise. If you check the data quality, you’ll see that the aSME for the F7 channel has improved
considerably, and we’ve produced only a small reduction of data quality at FCz (see Table 8.2).
I also looked at the effects of reducing the threshold from 125 µV to 100 µV. When I inspected the EEG, more trials with clear
artifacts were flagged. The data quality for F7 also improved a bit, with only a small reduction in data quality at FCz (see Table
8.2). I tried decreasing the threshold to 75 and even 50 µV, and this resulted in slight improvements at F7 but further worsening at
FCz.
Table 8.2. Effects of C.R.A.P. rejection on data quality.
aSME at F7 for aSME at F7 for aSME at FCz for aSME at FCz for
Rejection
Deviants Standards Deviants Standards
Blinks Only 1.9480 0.9115 0. 8264 0.5353
Blinks + Voltage Threshold
1.6381 0.9038 0.8345 0.5410
(±200)
Blinks + Voltage Threshold
(±200) + Moving Window 1.1711 0.7890 0.8443 0.5493
(125)
Blinks + Voltage Threshold
(±200) + Moving Window 1.1158 0.7368 0.8504 0.5449
(100)
So, what threshold is best? Compared to rejection only of blinks, rejecting C.R.A.P. with an absolute threshold of ±200 caused a
fairly substantial drop in aSME for F7, and adding the moving window peak-to-peak test with a threshold of 125 caused another
large drop in aSME at F7 (and other channels, as well). This rejection of C.R.A.P. caused the aSME at FCz to rise only slightly.
Dropping the threshold further caused only minor decreases at F7, along with small increases at FCz. Given that FCz will be the
main channel used for measuring the MMN, with the other channels only being used to quantify the scalp topography, the threshold
of 125 µV seems like a good compromise for this particular experiment.
The optimal threshold, and even the optimal set of test to apply, will vary across participants and across experimental paradigms.
The key is to ask what set of parameters will be most likely to bring you to a true conclusion about your primary scientific
hypothesis. In almost all experiments, this means rejecting artifacts to the extent that they degrade your data quality at the key
electrode sites (which you can assess with aSME values) and ensuring that any remaining artifacts are not producing differences
between conditions.
A third issue—which does not typically arise in auditory experiments like our MMN experiment—is whether blinks and eye
movements produced changes in the sensory input. We will turn to that issue in a later set of exercises.
This page titled 8.12: Exercise- Commonly Recorded Artifactual Potentials (C.R.A.P.) is shared under a CC BY 4.0 license and was authored,
remixed, and/or curated by Steven J Luck directly on the LibreTexts platform.
8.12.2 https://socialsci.libretexts.org/@go/page/137784

<!-- source_pdf=Full.pdf pdf_page=226 source_page_label="8.13.1" source_url="https://socialsci.libretexts.org/@go/page/137785" -->

## PDF page 226

- Source page label: 8.13.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137785

8.13: Using Artifact Detection to Avoid Changes to Visual Inputs
Up to this point, we’ve focused on the first two of the three problems associated with artifacts, namely noise and systematic
differences in voltage across conditions. The remainder of the chapter will focus on the third problem, namely that blinks and eye
movements can change the sensory input when visual stimuli are used.
For most researchers, this is not a big issue. Once you’ve dealt with the noise produced by blinks and eye movements (either by
rejection or correction), problematic changes in sensory input are relatively rare. If you’re using artifact correction for blinks, you
should still reject any trials with a blink that occurs at the time of the stimulus, because these trials are obviously not valid (see the
chapter on artifact correction for details). And if the stimuli are presented in the middle of the display, participants won’t make a lot
of eye movements, and if they do, they probably won’t differ systematically across conditions. This is what we saw in the MMN
experiment. Some participants made eye movements as they watched the silent movie in the middle of the display, but these eye
movements didn’t vary across conditions, and they couldn’t impact the sensory processing of the main stimuli (the auditory tones).
They were a source of noise, but not a confound.
However, eye movements can be a significant systematic confound in some types of studies, mainly those using peripheral visual
stimuli. For example, consider the spatial cuing paradigm shown in Figure 8.4, in which an arrow is used to indicate the likely
location of a subsequent target. Many studies have used this paradigm to determine whether covert shifts of visual attention to the
cued location cause the P1 and N1 waves to be larger when the stimulus is presented at the cued location compared to the uncued
location (e.g., Eimer, 1994; Luck et al., 1994; Mangun & Hillyard, 1991). However, participants are likely to shift their gaze
toward the cued location in these studies. If that happens, the target will appear in the center of gaze when it is presented at the
cued location, whereas it will appear in the periphery when it is presented at an uncued location. We know that foveal stimuli
produce larger sensory responses than peripheral stimuli, so this difference in the retinal location of the stimuli is a major confound
that must be avoided in these studies. To avoid this confound, we can reject trials with eye movements. However, this is more
difficult than it seems, even if you’re using a high-quality eye tracker. The next exercise will explain how to do this effectively.
Figure 8.4. Prototypical spatial cuing paradigm. The cue indicates the likely location of the target. After a short delay, the target
appears at the cued location (80% of trials) or one of the uncued locations (20% of trials). Participants press one of two buttons, as
quickly as possible, to indicate whether the target is an X or an O. Participants are also instructed to maintain fixation on the central
point and focus their “covert” attention onto the cued location. The goal is to determine whether sensory processing is enhanced at
the cued location relative to the uncued location.
Small eye movements are also a problem in studies that look at lateralized visual ERP components, such as the N2pc component
and contralateral delay activity (CDA). Both of these components are negative voltages contralateral to the location of a to-be-
perceived or to-be-remembered object or set of objects. There are two specific problems that arise in these experiments. First, if the
eyes move to the relevant location, then this location is now foveal, and that may impact the lateralization that would otherwise be
observed. This problem is especially acute if the stimulus is presented for more than 200 ms, which is the approximate amount of
time required to make a controlled eye movement in these paradigms. With long stimulus durations, you may have one period of
time in which the relevant stimuli are lateralized (prior to the eye movement) and then another period in which they are foveal
(after the eye movement). Even with brief stimulus durations, however, changes in eye position could potentially change the
lateralization of processing after the stimulus has disappeared (because the brain may remap the prior location of the internal neural
representation onto its new retinal location).
8.13.1 https://socialsci.libretexts.org/@go/page/137785

<!-- source_pdf=Full.pdf pdf_page=227 source_page_label="8.13.2" source_url="https://socialsci.libretexts.org/@go/page/137785" -->

## PDF page 227

- Source page label: 8.13.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137785

The second problem is not due to the change in the sensory per se but is instead a confound in the EOG voltage. If participants tend
to look leftward when the relevant stimuli are on the left side and rightward when the relevant stimuli are on the right side, then the
EOG will be negative on the right side of the head when the relevant stimuli are on the left side and negative on the left side of the
head when the relevant stimuli are on the right side. In other words, the EOG will appear as a negative voltage over the hemisphere
contralateral to the relevant information, just like the N2pc and CDA. Moreover, the EOG is so large that even a small eye
movement in the direction of the relevant information can produce a contralateral negativity that is as large or larger than the N2pc
and CDA. The next exercise describes how to address both of these problems.
In theory, eye movements can also be a confound in studies of lateralized motor responses, such as the lateralized readiness
potential (LRP; a negative voltage over the hemisphere contralateral to the response hand). This is because participants may make a
small, unconscious eye movement toward the hand that responds. Such eye movements would produce a negative voltage over the
right hemisphere for a left-hand response and a negative voltage over the left hemisphere for a right-hand response. That’s the same
pattern as the LRP. The strategy described in the following sections for eliminating these small eye movements for the N2pc and
CDA can also be used for the LRP.
If you don’t use lateralized visual stimuli or look at the LRP, then you can probably skip the rest of the chapter. However,
you might want to read it and do the exercises anyway, because they provide good examples of the general principles of artifact
rejection.
This page titled 8.13: Using Artifact Detection to Avoid Changes to Visual Inputs is shared under a CC BY 4.0 license and was authored, remixed,
and/or curated by Steven J Luck directly on the LibreTexts platform.
8.13.2 https://socialsci.libretexts.org/@go/page/137785

<!-- source_pdf=Full.pdf pdf_page=228 source_page_label="8.14.1" source_url="https://socialsci.libretexts.org/@go/page/137786" -->

## PDF page 228

- Source page label: 8.14.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137786

8.14: The ERP CORE N2pc Experiment
The following exercise will focus on data from the ERP CORE N2pc experiment. This section will describe the experimental
design and event code scheme (see Kappenman et al., 2021 for a detailed description). Example stimuli are shown in Figure 8.5.A.
N2pc experiments are typically designed to study how people focus their covert attention onto peripheral stimuli without looking at
the stimuli, so participants in this experiment were instructed to maintain gaze on the central fixation point at all times.
The experiment was divided into 8 blocks of 40 trials, and participants were instructed to attend to pink in half the blocks and blue
in the other half. The task was to find the square of the attended color (using peripheral vision) and press one of two buttons to
indicate whether this square had a gap on the top or on the bottom. Each stimulus array had 1 pink square and 11 black squares on
one side, along with 1 blue square and 11 black squares on the other side. Except for these constraints, the stimulus locations varied
randomly from trial to trial. Most importantly, pink and blue were always on opposite sides, but we randomized which side
contained pink and which side contained blue on each trial. Consequently, participants could not know where to shift attention until
a given display appeared.
The N2pc component reflects the focusing of attention onto a visual object and is largest when this object is surrounded by nearby
distractors (see review by Luck, 2012). It’s a negative voltage in the N2 latency range (typically from 200-300 ms) at posterior
electrode sites, and its distinguishing characteristic is that the negative voltage is larger over the hemisphere contralateral to the
attended object. For example, the voltage for left-hemisphere electrodes will typically be more negative when the target is in the
right visual field than when it is in the left visual field, whereas the voltage for right-hemisphere electrodes will typically be more
negative when the target is in the left visual field than when it is in the right visual field.
To make the N2pc easier to visualize, we typically collapse the data into a contralateral waveform (left hemisphere when the target
is on the right averaged with right hemisphere when the target is on the left) and an ipsilateral waveform (left hemisphere when the
target is on the left averaged with right hemisphere when the target is on the right). These collapsed waveforms are shown in Figure
8.5.B. You can see that the voltage is more negative (less positive) from ~200-300 ms in the contralateral waveform than in the
ipsilateral waveform. This voltage is summed with the other ERP components that are active at the same time, which are mainly
positive. Thus, the overall voltage is typically positive in both the contralateral and ipsilateral waveforms, but more negative for
contralateral than for ipsilateral. To isolate the N2pc from these other components, we make a contralateral-minus-ipsilateral
difference wave, as shown in Figure 8.5.C. This difference wave subtracts away all the nonlateralized components, making it easier
to see and quantify the time course of the N2pc component.
Figure 8.5. ERP CORE N2pc task (A), grand average ERP waveforms (B), and grand average contralateral-minus-ipsilateral
difference wave.
The event code scheme is summarized in Table 8.3. You can see that the event code for each stimulus indicates which color was
relevant for the current trial block (in the 100s place), which side contained the target square on the current trial (10s place), and
whether the gap on the target square was on the top or bottom of the square (1s place). There were also event codes for correct and
incorrect responses.
8.14.1 https://socialsci.libretexts.org/@go/page/137786

<!-- source_pdf=Full.pdf pdf_page=229 source_page_label="8.14.2" source_url="https://socialsci.libretexts.org/@go/page/137786" -->

## PDF page 229

- Source page label: 8.14.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137786

Table 8.3. Event codes for the ERP CORE N2pc experiment.
Relevant Color for Current Block Target Side Target Gap Location Event Code
Stimuli Blue Left Top 111
Blue Left Bottom 112
Blue Right Top 121
Blue Right Bottom 122
Pink Left Top 211
Pink Left Bottom 212
Pink Right Top 221
Pink Right Bottom 222
Accuracy Event Code
Responses correct 201
incorrect 202
The bin descriptor file is located in the Chapter_8 folder (named BDF_N2pc.txt), and the bin descriptors are shown below. You can
see that there are separate bins for left and right targets, irrespective of which color was relevant in the current block and whether
the target gap was on the top or the bottom. However, we require a correct response between 200 and 1000 ms after the stimuli.
bin 1
Left Target
.{111;112;211;212}{t<200-1000>201}
bin 2
Right Target
.{121;122;221;222}{t<200-1000>201}
This page titled 8.14: The ERP CORE N2pc Experiment is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
8.14.2 https://socialsci.libretexts.org/@go/page/137786

<!-- source_pdf=Full.pdf pdf_page=230 source_page_label="8.15.1" source_url="https://socialsci.libretexts.org/@go/page/137787" -->

## PDF page 230

- Source page label: 8.15.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137787

8.15: Exercise- Visualizing the Eye Movements
Now that you know about the ERP CORE N2pc paradigm, let’s take a look at the eye movements. As you can imagine, it’s difficult
to maintain gaze on the central fixation point and not look toward the target. But as described above, it’s important to make sure
that the N2pc results aren’t impacted by eye movements, which will change the location of the target relative to the center of gaze
and also create a negative voltage over the contralateral hemisphere.
In this exercise, we’ll focus on the data from Subject 15. If you look in the Chapter_8 folder, you’ll see two datasets from this
participant, one containing the continuous data (15_N2pc_ICA_preprocessed.set) and one containing the epoched data
(15_N2pc_ICA_preprocessed_epoched.set). To make this exercise simpler, ICA-based artifact correction was already applied to
these datasets to eliminate blinks. However, the datasets include a VEOG-uncorrected channel that contains the original
uncorrected VEOG-bipolar signal. We like to keep this uncorrected channel so that we can reject any trials on which the participant
blinked during the time period of the stimulus and therefore could not see the stimulus. This particular participant never blinked
during that time period, however, so we don’t need to worry about rejecting those epochs in this exercise. I also applied several
other preprocessing operations, including filtering (bandpass 0.1–30 Hz, 12 dB/octave). The EEG channels and the HEOG-left and
HEOG-right channels have all been referenced to the average of P9 and P10, and there is also an HEOG-bipolar channel (HEOG-
left minus HEOG-right).
Before we get started on the exercise, quit and restart EEGLAB, load the continuous dataset (15_N2pc_ICA_preprocessed.set),
and scroll through the data. You should always scroll through the continuous data as the first step so that you know what’s in the
file (as we did in the video demonstration in the previous chapter). Subject 15 has some weird stuff in the F7 channel near the end
of the session, but we won’t worry about that for this exercise.
Now load the epoched dataset (15_N2pc_ICA_preprocessed_epoched.set) and scroll through the data. On my widescreen desktop
monitor, I like to show 15 epochs per screen. And to focus on the eye movements, I like to display only 6 channels, with a vertical
scale of 100 or 150. This participant did a good job of following the fixation instructions initially, but you’ll start to see a fair
number of eye movements beginning at Epoch 70.
If you look at the event codes and the polarity of the HEOG deflections, you’ll see that most of the clear eye movements are toward
the side containing the target. Remember that the HEOG-bipolar channel was calculated as HEOG-left minus HEOG-right, and the
dipole is positive at the front of the eyes, so a leftward eye movement produces a positive deflection and a rightward eye movement
produces a negative deflection. For example, Epoch 70 has a negative deflection, indicating a rightward eye movement. You can
see that the time-locking event code for this epoch is labeled “B2(121)”, indicating that the event code was 121 (attend-blue, target
on the right, gap on the top) and was assigned to Bin 2 (right-side targets). This is important because it indicates that we had a
rightward eye movement on a trial with a right-side target.
When participants are trying to maintain central fixation, the eyes will typically move away from the fixation point rapidly, stay in
a new location for a few hundred milliseconds, and then “snap back” to the fixation point. This leads to a “boxcar” shape in the
HEOG signal (a flat signal at one voltage level corresponding to the location of the fixation point, a sudden change to a different
voltage level for 100–500 milliseconds, and then a return back to the original voltage level corresponding to the fixation point).
You can see this pattern in Epoch 70. The voltage level changes suddenly at approximately 285 ms after the time-locking event and
then back to the original level approximately 180 ms later. (You can see the latencies by hovering the mouse pointer over the
relevant part of the waveform and looking at the Time value near the bottom of the plotting window.)
If you look at epoch 73, you’ll see a voltage deviation in the HEOG-bipolar channel, but it isn’t a saccadic eye movement. It
doesn’t have the classic boxcar shape. Instead, it’s a little bit of blink voltage that has leaked through to the HEOG electrodes.
There’s a small leftward (positive) eye movement at approximately 570 ms after the time-locking event in Epoch 78, which had a
left-side target. Epoch 81, with a right-side target, has a somewhat complicated pattern that looks like a brief leftward movement
followed by a clearer rightward movement. Epoch 82, also with a right-side target, has a clear rightward eye movement.
There’s also a brief spike in voltage at the onset of the eye movement in Epoch 82. That’s probably an EMG burst coming from the
muscles that produce the eye movement. Ordinarily, the muscle contraction that produces an eye movement occurs briefly at the
start of the eye movement (to overcome the inertia in eye position) but then becomes too small to see as the eyes maintain their new
location (which requires very little muscle activity). The present data have been low-pass filtered, so this spike potential isn’t very
8.15.1 https://socialsci.libretexts.org/@go/page/137787

<!-- source_pdf=Full.pdf pdf_page=231 source_page_label="8.15.2" source_url="https://socialsci.libretexts.org/@go/page/137787" -->

## PDF page 231

- Source page label: 8.15.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137787

clear. Without the filtering, the spike potential is quite large in some participants. It’s fairly localized to frontal electrode sites, and
it’s easy to filter out, so I don’t usually worry about it as an artifact. However, if you perform time-frequency analyses, it’s easy to
mistake this EMG burst for gamma-band EEG activity (Yuval-Greenberg et al., 2008), so be cautious when someone says they’re
seeing gamma-band EEG oscillations at frontal electrode sites.
If you keep scrolling through the data, you’ll see quite a few eye movements (mainly in the direction of the target, and mainly
starting around 200 ms after stimulus onset). We clearly have a lot of work to do to make sure that these eye movements don’t
confound our N2pc data!
This page titled 8.15: Exercise- Visualizing the Eye Movements is shared under a CC BY 4.0 license and was authored, remixed, and/or curated
by Steven J Luck directly on the LibreTexts platform.
8.15.2 https://socialsci.libretexts.org/@go/page/137787

<!-- source_pdf=Full.pdf pdf_page=232 source_page_label="8.16.1" source_url="https://socialsci.libretexts.org/@go/page/137788" -->

## PDF page 232

- Source page label: 8.16.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137788

8.16: Exercise- Using the Averaged HEOG to Visualize Consistent Eye Movements
In an N2pc (or CDA or LRP) experiment, we’re mainly concerned about systematic eye movements in the direction of the target,
not random eye movements. A good way to assess these systematic eye movements is to make one averaged HEOG waveform for
all the left-target trials and another averaged waveform for all the right-target trials. That’s what we’ll do in this exercise, before we
work on rejecting trials with artifacts.
To begin the exercise, make sure that 15_N2pc_ICA_preprocessed is still loaded and active. Select EEGLAB > ERPLAB >
Compute averaged ERPs, and run it with the default settings. You can name the resulting ERPset 15_N2pc_no_rejection. Select
EEGLAB > ERPLAB > Plot ERPs > Plot ERP waveforms to plot the data, but telling the routine to plot only Channel 32
(HEOG-bipolar). It should look something like Screenshot 8.7.A.
Screenshot 8.7
Starting just after 200 ms, you can see a positive voltage deviation (leftward eye movement) for the left-target trials and a negative
voltage deviation (rightward eye movement) for the right-target trials. (There are also small differences between left- and right-
target trials at earlier latencies, but they must be random noise because it takes at least 150 ms for the visual system to find a color-
defined target in a visual search array and execute a saccade to it.)
The negative voltage in the right-target average is larger than the positive voltage for the left-target average. This is a fairly
common pattern, and it may be related to the widely observed right hemifield bias for spatial attention. The main issue, however, is
the overall difference in HEOG activity between left-target trials and right-target trials. To visualize this, we can make a left-target-
8.16.1 https://socialsci.libretexts.org/@go/page/137788

<!-- source_pdf=Full.pdf pdf_page=233 source_page_label="8.16.2" source_url="https://socialsci.libretexts.org/@go/page/137788" -->

## PDF page 233

- Source page label: 8.16.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137788

minus-right-target difference wave. Select EEGLAB > ERPLAB > ERP Operations > ERP Bin Operations, and create an equation
that reads bin3 = bin1 - bin2 label Left Target Minus Right Target. Make sure that the Mode is set to Modify existing ERPset,
and then click RUN.
If you plot the resulting difference wave, you’ll see that the difference between the left- and right-target averages is approximately
8 µV between approximately 250 and 450 ms (see Screenshot 8.7B). However, keep in mind that this reflects a mixture of some
trials with a large eye movement and some trials without.
Is this a large enough difference to be problematic? To answer this question, we need to think about why horizontal eye movements
are problematic for interpreting an N2pc experiment (or a CDA experiment, LRP experiment, etc.). First, we need to ask whether
our N2pc effect might actually be HEOG voltage that has propagated from the eyes to the posterior electrodes where the N2pc is
ordinarily observed. Fortunately, a great paper by Lins et al. (1993) provides propagation factors for blinks, vertical eye
movements, and horizontal eye movements. They don’t provide values for the PO7 and PO8 electrodes, but they do provide values
for the O1 and O2 electrodes and the P5 and P6 electrodes. The PO7 and PO8 electrodes that we used to measure N2pc amplitude
in the ERP CORE paper are halfway between O1/P5 and O2/P6. Lins et al. reported a propagation of 1% from HEOG-bipolar to
O1 and O2 and a propagation of 3% from HEOG-bipolar to P5 and P6. If we split the difference and assume a 2% propagation to
PO7 and PO8, the 8 µV voltage deflection we observed at the HEOG channel in this participant would be expected to lead to a
voltage of 0.16 µV at P5 and P6. That’s quite a bit smaller than the N2pc, which is typically 1-2 µV, but still as big as some
between-condition differences in N2pc amplitude. And in many participants, the HEOG-bipolar voltage would be quite a bit larger.
We also need to consider whether the eye movements caused the target to shift toward the center of the retina, reducing the
lateralization that is necessary for seeing an N2pc (because it is defined by the difference between contralateral and ipsilateral
channels). Again, the paper by Lins et al. (1993) provides useful information. Specifically, they found that the HEOG-bipolar signal
increases by 16 µV for every degree of lateral eye rotation (which my lab has confirmed several times). Because the difference
between left-target and right-target trials in the average HEOG-bipolar signal was approximately 8 µV, we can conclude that there
was a 0.5° difference in eye rotation between left-target and right-target trials, on average. However, this is just an average. It’s
quite plausible that the target was fully foveated by ~250 ms on a substantial proportion of trials, with little or no eye movement on
other trials. On the subset of trials with large eye movements, we can’t be certain that a target on the left side of the video display
was actually in the left visual field and that a target on the right side of the video display was actually in the right visual field.
If we want to be careful, we need to both decrease the artifactual EOG voltage produced by the eye movements and eliminate trials
with large deviations in eye position. Artifact correction can be used to reduce the artifactual EOG voltage (as described in the next
chapter), but we need to reject trials with large eye movements to deal with large deviations in eye position.
This page titled 8.16: Exercise- Using the Averaged HEOG to Visualize Consistent Eye Movements is shared under a CC BY 4.0 license and was
authored, remixed, and/or curated by Steven J Luck directly on the LibreTexts platform.
8.16.2 https://socialsci.libretexts.org/@go/page/137788

<!-- source_pdf=Full.pdf pdf_page=234 source_page_label="8.17.1" source_url="https://socialsci.libretexts.org/@go/page/137789" -->

## PDF page 234

- Source page label: 8.17.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137789

8.17: Exercise- A Two-Stage Strategy for Eliminating Small But Consistent Eye
Movements
If eye movements were either large or absent, rejection of trials with eye movements would be easy. However, people may make
small but consistent eye movements toward the target. Small eye movements produce small HEOG deflections, and in practice it is
difficult to detect eye movements smaller than approximately 1° (16 µV) on single trials in most participants. In this exercise, we’ll
see how to use a two-stage procedure (originally described by Woodman & Luck, 2003) to ensure that the data are not
contaminated by small but consistent eye movements toward the target. In Stage 1, we throw out single trials with eye movements
of greater than ~1°. In Stage 2, we look at the averaged HEOG-bipolar waveforms for left- and right-target trials to assess the
effects of any small eye movements that remain after Stage 1.
Let’s start with Stage 1. If we’re not thoughtful about the artifact rejection parameters used at this stage, we’ll end up rejecting so
many trials that we’ll need to exclude the participant. One way to minimize the number of rejected trials is to look for eye
movements only until the end of the N2pc measurement window. The N2pc measurement window in the ERP CORE N2pc
experiment was 200-275 ms, but to keep things simple we’ll assume a measurement window of 200-300 ms here. If the eyes move
toward the target after 300 ms, this won’t impact our N2pc amplitude measurements, so we won’t reject trials with those late eye
movements. This will give us more trials in our averages.
To get started on Stage 1, make sure that 15_N2pc_ICA_preprocessed_epoched is loaded and active. Select EEGLAB >
ERPLAB > Artifact detection in epoched data > Step-like artifacts, and set the parameters as shown in Screenshot 8.8. We’re
specifying a moving window of 200 ms, and the step function gives us the absolute value of the difference in mean voltage
between the first and second halves of this window (the first 100 ms and the last 100 ms). We’re specifying a Window Step of 10,
which means that we’re shifting this window in 10-ms increments. We’re specifying a test period of -200 400 rather than the entire
epoch so that we don’t have to throw out trials with eye movements after the N2pc measurement window (200–300 ms).
 Timing Details
The last moving window being tested will be from 200–400 ms, so an eye movement that starts at 300 ms will be detected. If
we ended the test period at 300 ms, the last moving window would be from 100–300 ms, which corresponds to the difference
in mean voltage between the 100–200 and 200–300 ms periods. An eye movement that began at, for example, 280 ms would
only influence the voltage during the very last part of this period and would probably be missed. But this eye movement would
be caught by a moving window from 180–380 ms. In general, if you are using a 200 ms moving window (which works well for
eye movements), the window should end 100 ms after the time period of interest.
8.17.1 https://socialsci.libretexts.org/@go/page/137789

<!-- source_pdf=Full.pdf pdf_page=235 source_page_label="8.17.2" source_url="https://socialsci.libretexts.org/@go/page/137789" -->

## PDF page 235

- Source page label: 8.17.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137789

Screenshot 8.8
We’ve specified a threshold of 16 µV, which means that we will detect eye movements that are ~1° or larger. I like this threshold,
because 1° is a nice round number, and this threshold works reasonably well with most adult participants (a higher threshold is
needed for participants with noisy HEOG-bipolar signals to avoid rejecting too many trials that don’t actually have eye
movements).
Go ahead and click ACCEPT to run the routine. As usual, the first thing to look at is the percentage of rejected trials. A total of
12% were rejected, which is very reasonable in terms of not reducing the signal-to-noise ratio very much. Now you should scroll
through the data. (As before, I recommend displaying only the bottom 6 channels, with a vertical scale of 100 or 150.) You’ll see
that the first clear eye movement, in Epoch 70, has been flagged for rejection. The blink that leaked through to the HEOG-bipolar
channel in Epoch 73 was outside our window of -200 to 400 ms and was therefore not flagged, which is good. The eye movement
in Epoch 78 was also outside our window and was not flagged. That’s also good, because the eye movement is too late to impact
our N2pc measurement, so we want to keep this trial.
If you keep scrolling, you’ll see that the eye movements in Epochs 81, 86, and 88 were flagged. There’s a leftward (positive) eye
movement in Epoch 84 that wasn’t flagged, but it was after our rejection window, so that’s good. If you go through the whole
session, you’ll see that the step function did an excellent job of flagging clear eye movements that occurred during or prior to the
200–300 ms time period that we plan to use to measure N2pc amplitude.
Now let’s see what rejecting these epochs will do to the data quality. Get the table of data quality values for the data prior to
flagging the artifacts and after flagging the artifacts. If you look at the aSME values for the PO7 channel in Bin 1 for the 200-300
ms time period, you’ll see that the aSME increased only slightly from the original data (0.4504) to the data excluding the marked
epochs (0.4693). So, we’ve eliminated eye movements that exceeded ~1° of eye rotation without much decline in data quality.
That’s good!
Now we need to implement Stage 2 of our two-stage process. Stage 2 is designed to deal with the fact that we probably failed to
reject a substantial number of smaller eye movements that were directed toward the target side. These small eye movements would
create a negative voltage over the contralateral hemisphere that might impact our N2pc measurements. They might also change the
lateralization of the target for trials on which the target was very close to the fixation point. To assess the possibility of small but
8.17.2 https://socialsci.libretexts.org/@go/page/137789

<!-- source_pdf=Full.pdf pdf_page=236 source_page_label="8.17.3" source_url="https://socialsci.libretexts.org/@go/page/137789" -->

## PDF page 236

- Source page label: 8.17.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137789

consistent eye movements remaining in the data, we need to look at the averaged HEOG-bipolar waveforms for the left-target and
right-target trials.
To do this, run the averaging routine, making sure that it’s set to exclude epochs marked for rejection. Then make a left-target-
minus-right-target difference wave using ERP Bin Operations. Now plot the ERPs at Channel 32 (HEOG-bipolar) for all three
bins. It should look something like Screenshot 8.7C. Note that the EOG deflection is much smaller now than it was before we
rejected trials with eye movements (Screenshots 8.5.A and 8.5.B), especially during the N2pc measurement window (200-300 ms).
But there is still some consistent eye movement activity in the direction of the target during this time window (i.e., the voltage is
more negative on right-target trials than on left-target trials). We could try to eliminate this residual eye movement activity by
decreasing our rejection threshold. However, in my experience, you can never complete remove this activity in most participants
without rejecting a huge proportion of trials. For example, I tried reducing the threshold to 8 µV with the present participant, but
the residual HEOG signal was quite large even though 55.4% of trials were rejected. Not surprisingly, this also increased the aSME
value quite a bit. So, unless you are using a high-resolution eye tracker, you’ll always have some residual HEOG activity after
artifact rejection in most participants in experiments with lateralized targets.
The question then becomes, how much residual HEOG activity can we tolerate? If we think of this question in terms of the goals
described at the beginning of the chapter, we can break it into two sub-questions: 1) Is enough of the residual HEOG activity being
propagated to the N2pc measurement electrodes to create a significant confound? 2) Is the amount of eye rotation implied by the
residual HEOG activity large enough to create a significant change in the sensory input?
For my lab’s basic science experiments, we can afford to be extremely conservative in our answers to these questions. Our
threshold for “good enough” in these experiments is a difference between left-target and right-target trials of <3.2 µV during the
N2pc measurement window. In terms of eye rotation, this is an average difference in eye rotation of <0.2° between the left-target
and right-target trials (which I like to think of as approximately a difference of ±0.1°). That’s a pretty tiny deviation (although we
need to keep in mind that this is an average, and the deviation on single trials might be up to 1° with our 16 µV threshold). So, this
seems “good enough” in terms of the change to the sensory input.
We ordinarily measure the N2pc at all of the parietal and occipital electrode sites, and the propagation factor is 3% or less from the
HEOG-bipolar sites to each of these sites (according to Lins et al., 1993). Thus, a voltage difference of <3.2 µV at HEOG-bipolar
corresponds to a voltage difference of <0.1 µV at the sites where we are measuring the N2pc component. That seems “good
enough” in terms of any confounding voltage in our N2pc measurements.
Have we succeeded in meeting this 3.2 µV criterion in the present participant? It’s difficult to be sure in the current plot. A
convenient way to see if we’ve met the criterion is to plot the difference wave using a Y range of -3.2 to +3.2 µV and a time range
of -200 to +300 ms. Go ahead and do this. The result should look something like Screenshot 8.7D. If the voltage ever exceeded 3.2
µV, the waveform would be “clipped off” in the plot. Although the waveform did get near the top of this voltage range near the end
of the 200-300 ms N2pc measurement window, it never exceeded this threshold. In other words, the small amount of residual eye
movement activity for this participant meets our criterion for “good enough.”
What should you do if the residual eye movement activity for a given participant is >3.2 µV? The first step is to try changing the
rejection parameters. Most obviously, you can try reducing the rejection threshold. Sometimes changing the rejection time window
can also help. Your goal is to see if you can reduce the residual HEOG activity to <3.2 µV in the N2pc measurement window (or
the measurement window for whatever component you’re studying) without rejecting too many trials.
As mentioned earlier in this chapter, my lab automatically excludes participants in our basic science experiments if more than 25%
of trials are rejected (which includes trials rejected for other reasons, such as blinks). If we can’t get the residual HEOG under 3.2
µV without rejecting more than 25% of trials, we exclude the participant from the final analyses. We’ve used this approach for
about 30 years, and it has worked very well. We end up excluding approximately 20% of participants, which is tolerable. In our
schizophrenia studies, we find that both the patient and control groups make more eye movements than the college-age participants
in our basic science studies, so we double our thresholds. That is, we require that the residual HEOG activity is <6.4 µV, and we
exclude participants for whom more than 50% of trials were rejected.
What thresholds should you use in your own analyses? I can’t answer that question, because it depends on the nature of your
research. As always, your choice should be made on the basis of the fundamental goal of increasing your ability to accurately
8.17.3 https://socialsci.libretexts.org/@go/page/137789

<!-- source_pdf=Full.pdf pdf_page=237 source_page_label="8.17.4" source_url="https://socialsci.libretexts.org/@go/page/137789" -->

## PDF page 237

- Source page label: 8.17.4
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137789

answer the scientific question that your studies are designed to address. And you might use aSME values rather than the percentage
of trials rejected to decide whether too many trials have been rejected for a given participant. Whatever criteria you choose,
however, it is extremely important that those criteria are set prior to analyzing the data.
I hope that these N2pc exercises have provided you with a clear procedure for minimizing eye movement artifacts in experiments
with lateralized targets or responses. But even more, I hope these exercises serve as a good example of how to conceptualize the
goals of artifact rejection and how to achieve those goals.
This page titled 8.17: Exercise- A Two-Stage Strategy for Eliminating Small But Consistent Eye Movements is shared under a CC BY 4.0 license
and was authored, remixed, and/or curated by Steven J Luck directly on the LibreTexts platform.
8.17.4 https://socialsci.libretexts.org/@go/page/137789

<!-- source_pdf=Full.pdf pdf_page=238 source_page_label="8.18.1" source_url="https://socialsci.libretexts.org/@go/page/137761" -->

## PDF page 238

- Source page label: 8.18.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137761

8.18: Matlab Script For This Chapter
I’ve created a script named MMN_artifact_rejection_example.m that shows how to implement the interpolation and artifact
detection processes described in this chapter. You can find it in the Chapter_8 folder. It runs on the data from Subjects 1-10 in the
ERP CORE MMN experiment. The datasets for these participants are in a subfolder named MMN_Data.
The script demonstrates how you can put subject-specific information in an Excel spreadsheet, such as which channels to
interpolate and what artifact detection parameters to use, and then have the script read this information and use it to control the
interpolation and artifact detection processes. This is a super useful trick!
I didn’t spend much time customizing the parameters. You can probably do a better job given what you’ve learned in this chapter.
Most of these participants have a lot of blinks and would need to be excluded from the final analyses because they exceed our
criterion of 25% rejected trials. As I noted before, this is because we planned to use artifact correction rather than rejection for
blinks, and we did nothing to minimize blinking. I should also note that Subject 7 has a ton of low-frequency drift (probably
coming from the reference electrodes, because it’s present in all the EEG channels) and was excluded from the final analyses in the
ERP CORE paper.
This page titled 8.18: Matlab Script For This Chapter is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
8.18.1 https://socialsci.libretexts.org/@go/page/137761

<!-- source_pdf=Full.pdf pdf_page=239 source_page_label="8.19.1" source_url="https://socialsci.libretexts.org/@go/page/137762" -->

## PDF page 239

- Source page label: 8.19.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137762

8.19: Key Takeaways and References
Key Takeaways
The overarching goal in designing an artifact rejection strategy is to maximize the likelihood that you will obtain an accurate
answer to the scientific question your study is designed to answer. You can ignore any of my specific suggestions for
implementing artifact rejection if you have a better way of reaching that goal.
Artifacts are typically problematic for one of three reasons: 1) they are a large source of noise and therefore reduce your
statistical power; 2) they differ systematically across groups or conditions, creating a confound; 3) they indicate a problem with
the sensory input (e.g., closed eyes during the presentation of a visual stimulus). In most cases, you are rejecting trials with
artifacts to address one or more of these issues.
Decreasing the threshold for rejection typically reduces the confounding effects of artifacts and the problems with the sensory
input, and it may also reduce the noise caused by the artifacts. However, when the threshold gets too low, the number of trials
remaining in the averaged ERP waveforms gets small enough that the data quality suffers. You can use the aSME values to help
find the optimal threshold for rejection.
You will typically want to implement several different artifact detection procedures for each participant so that you can
intelligently detect the different types of artifacts. This is often achieved with one procedure for detecting blinks, another for
detecting eye movements, and a third for detecting C.R.A.P.
Dealing with small but consistent eye movements is tricky, because small eye rotations are difficult to detect but can be a
significant confound in experiments with lateralized stimuli or lateralized responses. The two-stage procedure deals with this by
using the greater precision of averaged HEOG waveforms to determine whether the small eye movements that escape rejection
are large enough to have a substantial impact.
References
Baker, D. H., Vilidaite, G., Lygo, F. A., Smith, A. K., Flack, T. R., Gouws, A. D., & Andrews, T. J. (2020). Power contours:
Optimising sample size and precision in experimental psychology and human neuroscience. Psychological Methods.
http://dx.doi.org/10.1037/met0000337
Eimer, M. (1994). “Sensory gating” as a mechanism for visuospatial orienting: Electrophysiological evidence from trial-by-trial
cuing experiments. Perception & Psychophysics, 55, 667–675.
Jas, M., Engemann, D. A., Bekhti, Y., Raimondo, F., & Gramfort, A. (2017). Autoreject: Automated artifact rejection for MEG and
EEG data. NeuroImage, 159, 417–429. https://doi.org/10.1016/j.neuroimage.2017.06.030
Kappenman, E. S., Farrens, J. L., Zhang, W., Stewart, A. X., & Luck, S. J. (2021). ERP CORE: An open resource for human event-
related potential research. NeuroImage, 225, 117465. https://doi.org/10.1016/j.neuroimage.2020.117465
Lins, O. G., Picton, T. W., Berg, P., & Scherg, M. (1993). Ocular artifacts in EEG and event-related potentials I: Scalp topography.
Brain Topography, 6, 51–63.
Luck, S. J. (2012). Electrophysiological correlates of the focusing of attention within complex visual scenes: N2pc and related ERP
components. In S. J. Luck & E. S. Kappenman (Eds.), The Oxford Handbook of ERP Components (pp. 329–360). Oxford
University Press.
Luck, S. J. (2014). An Introduction to the Event-Related Potential Technique, Second Edition. MIT Press.
Luck, S. J., Hillyard, S. A., Mouloua, M., Woldorff, M. G., Clark, V. P., & Hawkins, H. L. (1994). Effects of spatial cuing on
luminance detectability: Psychophysical and electrophysiological evidence for early selection. Journal of Experimental
Psychology: Human Perception and Performance, 20, 887–904.
Luck, S. J., Stewart, A. X., Simmons, A. M., & Rhemtulla, M. (2021). Standardized measurement error: A universal metric of data
quality for averaged event-related potentials. Psychophysiology, 58, e13793. https://doi.org/10.1111/psyp.13793
Mangun, G. R., & Hillyard, S. A. (1991). Modulations of sensory-evoked brain potentials indicate changes in perceptual processing
during visual-spatial priming. Journal of Experimental Psychology: Human Perception and Performance, 17, 1057–1074.
8.19.1 https://socialsci.libretexts.org/@go/page/137762

<!-- source_pdf=Full.pdf pdf_page=240 source_page_label="8.19.2" source_url="https://socialsci.libretexts.org/@go/page/137762" -->

## PDF page 240

- Source page label: 8.19.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137762

Nolan, H., Whelan, R., & Reilly, R. B. (2010). FASTER: Fully Automated Statistical Thresholding for EEG artifact Rejection.
Journal of Neuroscience Methods, 192(1), 152–162. https://doi.org/10.1016/j.jneumeth.2010.07.015
Talsma, D. (2008). Auto-adaptive averaging: Detecting artifacts in event-related potential data using a fully automated procedure.
Psychophysiology, 45(2), 216–228. https://doi.org/10.1111/j.1469-8986.2007.00612.x
Woodman, G. F., & Luck, S. J. (2003). Serial deployment of attention during visual search. Journal of Experimental Psychology:
Human Perception and Performance, 29, 121–138.
Yuval-Greenberg, S., Tomer, O., Keren, A. S., Nelken, I., & Deouell, L. Y. (2008). Transient induced gamma-band response in EEG
as a manifestation of miniature saccades. Neuron, 58(3), 429–441. https://doi.org/10.1016/j.neuron.2008.03.027
This page titled 8.19: Key Takeaways and References is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
8.19.2 https://socialsci.libretexts.org/@go/page/137762
