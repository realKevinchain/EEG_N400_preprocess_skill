# 10: Scoring and Statistical Analysis of ERP Amplitudes and Latencies

> Source: *Applied Event-Related Potential Data Analysis* (Steven J. Luck), `Full.pdf`, PDF pages 272-300. Text is a mechanical page-by-page extraction, not a summary. Consult the PDF for figures and layout.

<!-- source_pdf=Full.pdf pdf_page=272 source_page_label="1" source_url="" -->

## PDF page 272

- Source page label: 1
- LibreTexts source: not printed on page

CHAPTER OVERVIEW
10: Scoring and Statistical Analysis of ERP Amplitudes and Latencies
 Learning Objectives
In this chapter, you will learn to:
Score the magnitude of an ERP component using the peak amplitude and the mean amplitude.
Score the timing of an ERP component using the peak latency, fractional area latency, and fractional peak latency.
Evaluate these different scoring methods in terms of measurement error, effect sizes, and bias.
Conduct statistical analyses that minimize the likelihood of bogus-bug-significant results.
Correlate ERP measures with behavioral measures.
This chapter focuses on the final steps of data analysis, in which you quantify the amplitudes and/or latencies of your ERPs and
conduct a statistical analysis. It doesn’t cover every possible way of scoring amplitudes and latencies, and it barely scratches the
surface of the statistical analysis of ERP data. However, it covers the scoring procedures that are used most often (or that should be
used most often), along with some very simple statistical analyses. Additional details about scoring can be found in Chapter 9 of
Luck (2014), and a much more in-depth treatment of statistical analysis can be found in Chapter 10 of that book. In particular, I
encourage you to read about the jackknife and mass univariate statistical approaches (which are too advanced for the present book).
One reason that I don’t go too deeply into statistical analyses in this chapter is that ERPLAB doesn’t include statistical functions,
and I don’t want to have to explain how to use some other statistical package. I’m assuming that you already know how to conduct
basic statistical analyses (t tests and within-subjects ANOVAs) and have a statistical package that you can use to perform these
analyses. If you don’t, I recommend JASP (Love et al., 2019), which is free and easy to use. It’s what I used for the analyses in this
chapter.
The exercises in this chapter will examine the lateralized readiness potential (LRP), which reflects motor preparation. The data are
from the ERP CORE flankers experiment. However, the lessons you will learn can be applied to almost any ERP component in
almost any paradigm. And the LRP provides excellent opportunities to ask interesting questions about both amplitudes and
latencies.
Quantifying amplitudes and latencies is often called the measurement process, and in ERPLAB it’s done with the Measurement
Tool. Recently, however, I’ve started using the term scoring instead of measurement. When we put electrodes on the scalp and
record the EEG, that feels like we’re actually measuring something (the voltages on the scalp). But applying an algorithm to an
ERP waveform and hoping that it accurately captures the magnitude or timing of some underlying brain signal doesn’t seem like
taking a measurement. I now prefer the term scoring as more neutral term that is used in many other research areas. For example,
you might score the amplitude or latency of a given ERP component.
10.1: Data for This Chapter
10.2: Design of the Flankers Experiment
10.3: Exercise- Examining the Grand Averages
10.4: Exercise- A First Pass at Scoring and Statistical Analysis
10.5: Exercise- Simplifying the Statistical Analysis
10.6: Exercise- Peak Amplitude
10.7: Exercise- Peak Latency
10.8: Exercise- Fractional Area Latency
10.9: Exercise- Quantifying Onset Latency
10.10: Exercise- Collapsing Across Channels and Correlating Latencies with Response Times
10.11: Matlab Scripts For This Chapter
1

<!-- source_pdf=Full.pdf pdf_page=273 source_page_label="2" source_url="" -->

## PDF page 273

- Source page label: 2
- LibreTexts source: not printed on page

10.12: Key Takeaways and References
This page titled 10: Scoring and Statistical Analysis of ERP Amplitudes and Latencies is shared under a CC BY 4.0 license and was authored,
remixed, and/or curated by Steven J Luck directly on the LibreTexts platform.
2

<!-- source_pdf=Full.pdf pdf_page=274 source_page_label="10.1.1" source_url="https://socialsci.libretexts.org/@go/page/87981" -->

## PDF page 274

- Source page label: 10.1.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87981

10.1: Data for This Chapter
The data we’ll be using for the exercises in this chapter can be found in the Chapter_10 folder in the master folder:
https://doi.org/10.18115/D50056.
This page titled 10.1: Data for This Chapter is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck
directly on the LibreTexts platform.
10.1.1 https://socialsci.libretexts.org/@go/page/87981

<!-- source_pdf=Full.pdf pdf_page=275 source_page_label="10.2.1" source_url="https://socialsci.libretexts.org/@go/page/87982" -->

## PDF page 275

- Source page label: 10.2.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87982

10.2: Design of the Flankers Experiment
This section will provide a brief overview of the experimental design and main results from the ERP CORE flankers experiment.
This experiment was designed to isolate two different ERP components, the lateralized readiness potential (LRP) and the error-
related negativity (ERN).
The LRP is a negative voltage over the hemisphere contralateral to a hand that is being prepared for a response. For example if I
were to tell you “raise your left pinkie,” a negative voltage would be present over the motor cortex of the right hemisphere,
preceding the actual pinkie response by 100-200 ms. The LRP is related to the preparation rather than the execution of the
response. For example, if I were to tell you “raise your right pinkie when I say GO,” the negative voltage over the right hemisphere
would appear right away, even before I said “GO.” Like the N2pc component, the LRP is isolated with a contralateral-minus-
ipsilateral difference wave (relative to the side of the response hand). For an excellent review of the LRP, see Smulders and Miller
(2012).
The ERN is a negative voltage with a maximum amplitude near FCz that occurs on error trials (usually in tasks where the error is
obvious to the participant). It usually begins shortly before the actual buttonpress response and peaks 50-100 ms after the response.
To get a good ERN, you need participants to make enough errors that you have a decent number of trials for averaging, but not so
many errors that they’re not really putting any effort into doing the task correctly. For an excellent review of the ERN, see Gehring
et al. (2012).
In the ERP CORE, we used a version of the Eriksen flankers task (Eriksen, 1995) to elicit these components. In the present chapter,
we’ll focus on the LRP. As illustrated in Figure 10.1.A, each stimulus array contained a central target arrow that pointed leftward or
rightward with equal probability, surrounded by two flanking arrows on each side. Participants were instructed to make a rapid
buttonpress response for each array, pressing with the left index finger if the central arrow pointed leftward and with the right index
finger if the central arrow pointed rightward. They were instructed to ignore the flankers, which pointed in the same direction as the
central target arrow on 50% of trials (called Compatible trials) and pointed in the opposite direction on the other 50% (called
Incompatible trials). Each array was presented for 200 ms, and successive arrays were separated by an interstimulus interval of
1200–1400 ms. To make sure we had a good number of error trials, participants were told to speed up if they were making errors on
fewer than 10% of trials and to slow down if they were making errors on more than 20% of trials.
In the ERP CORE paper (Kappenman et al., 2021), we focused our LRP and ERN analyses on ERPs that were time-locked to the
response (i.e., the response rather than the stimulus was used as time zero when the data were epoched and averaged). The LRP was
isolated by examining trials with left-hand versus right-hand responses. Figure 10.1.B shows the grand average ERPs, with one
waveform for the ipsilateral hemisphere (C3 for left-hand response trials averaged with C4 for right-hand response trials) and
another waveform for the contralateral hemisphere (C4 for left-hand response trials averaged with C3 for right-hand response
trials). The LRP is a negative voltage over the contralateral hemisphere that is superimposed on the other brain activity. To isolate
the LRP, we construct a contralateral-minus-ipsilateral difference wave (Figure 10.1.C). You can see that the LRP in this difference
wave starts to head in a negative direction approximately 120 ms prior to the response, and it peaks shortly before the response.
(The slight positive voltage in the difference wave prior to -150 ms is likely an artifact of the 0.1 Hz high-pass filter that was
applied to the continuous EEG at an early step in the analysis.)
The ERN is examined by comparing trials with correct trials and trials with incorrect trials (Figure 10.1.D). A sharp negative wave
is superimposed on the positive voltage that would otherwise occur, peaking shortly after the response. This is then followed by a
more positive voltage on the error trials than on the correct trials (called the error positivity or P ). The ERN and P are often
E E
isolated from the other brain activity by making an error-minus-correct difference wave (Figure 10.1.E).
10.2.1 https://socialsci.libretexts.org/@go/page/87982

<!-- source_pdf=Full.pdf pdf_page=276 source_page_label="10.2.2" source_url="https://socialsci.libretexts.org/@go/page/87982" -->

## PDF page 276

- Source page label: 10.2.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87982

Figure 10.1. Experimental paradigm and results from the ERP CORE flankers experiment. (A) Example sequence of stimuli.
Participants were instructed to press a left- or right-hand button depending on whether the central arrow pointed leftward or
rightward, respectively. They were instructed to ignore the flanking arrows, which could be either compatible or incompatible with
the direction of the central arrow. (B) Grand average ERP waveforms contralateral or ipsilateral to the response hand, time-locked
to the response on correct trials, and averaged over compatible and incompatible trials and all 40 participants. (C) Grand average
LRP difference wave, which was created by subtracting the ipsilateral ERP waveform from the contralateral ERP waveform. (D)
Grand average ERP waveforms on correct trials and error trials, time-locked to the response, and averaged over compatible and
incompatible trials and all 40 participants. (E) Grand average ERN difference wave, which was created by subtracting the ERP
waveform for the correct trials from the ERP waveform for the error trials.
In the main LRP analyses in the ERP CORE paper (Kappenman et al., 2021), we collapsed across compatible and incompatible
trials for the sake of simplicity. In the present chapter, we’re going to look at the LRP separately for these trial types, focusing on
stimulus-locked instead of response-locked averages. We’ll consider only the correct trials. Many prior experiments have found
that response times (RTs) are slowed on incompatible trials relative to compatible trials, and this is mainly because information
about the flankers “leaks through” to response selection mechanisms. On compatible trials, this helps to activate the correct
response. On incompatible trials, however, the incorrect response may be activated, which slows down the response (and often
leads to errors). This can sometimes be observed in the LRP waveform, which may be contralateral to the incorrect hand briefly
before becoming contralateral to the correct hand on incompatible trials (Gratton et al., 1988). In addition, the onset latency of the
LRP is delayed on incompatible trials relative to compatible trials.
We didn’t do any of these analyses for the ERP CORE paper, but I thought they would be interesting to do in the present chapter.
For one thing, they’ll give us an opportunity to look at several different measures of amplitude and latency. For another, we won’t
know the results until we do the analyses, so there will be some drama!
This page titled 10.2: Design of the Flankers Experiment is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
10.2.2 https://socialsci.libretexts.org/@go/page/87982

<!-- source_pdf=Full.pdf pdf_page=277 source_page_label="10.3.1" source_url="https://socialsci.libretexts.org/@go/page/87984" -->

## PDF page 277

- Source page label: 10.3.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87984

10.3: Exercise- Examining the Grand Averages
Ordinarily, you would decide exactly how to quantify and analyze the ERP amplitudes and latencies prior to seeing the data. If you
first look at the grand average ERP waveforms, the analysis parameters you select will likely be influenced by noise in the data,
and you’ll have a high likelihood of finding significant effects that reflect noise rather than true effects and are completely bogus.
This is a super important point! I’m not going to dwell on it here, because I’ve written about it extensively elsewhere (see
especially Luck & Gaspelin, 2017). However, keep this point in mind throughout the chapter (especially in this first exercise, where
we are going to look at the data before we develop our analysis plan—exactly what you shouldn’t do!).
I’ve already created the averaged ERP waveforms for looking at the LRP. If you go to the Chapter_10 folder, you’ll see a
subfolder named Data, and inside that subfolder you’ll see another subfolder named ERPsets that contains an ERPset for each of
the 40 participants. To create these ERPsets, I referenced the data to the average of P9 and P10, high-pass filtered at 0.1 Hz (12
dB/octave), and then applied ICA-based artifact correction for blinks and horizontal eye movements (using the optimized approach
described in the chapter on artifact correction). The next step was to add an EventList and then run BINLISTER to create 4 bins:
Bin 1: Left-Pointing Target with Compatible Flankers, Followed by Left Response
Bin 2: Right-Pointing Target with Compatible Flankers, Followed by Right Response
Bin 3: Left-Pointing Target with Incompatible Flankers, Followed by Left Response
Bin 4: Right-Pointing Target with Incompatible Flankers, Followed by Right Response
Note that only correct responses were included in these bins because we’re going to focus on the LRP rather than the ERN.
Next, I epoched the data from -200 to 800 ms relative to stimulus onset. I then performed artifact detection to mark trials with
C.R.A.P., and finally I averaged the data, excluding the marked trials.
Let’s load the data and make a grand average. Quit and restart EEGLAB, and set Chapter_10 to be Matlab’s current folder. Select
EEGLAB > ERPLAB > Load existing ERPset, navigate to the Chapter_10 > Data > ERPsets folder, select all 40 ERPset files
at once, and click Open. You should then be able to see all 40 ERPsets in the ERPsets menu. To make a grand average, select
EEGLAB > ERPLAB > Average across ERPsets (Grand Average), and indicate that the routine should average across ERPsets
1:40 in the ERPsets menu. All the other options should be kept at their default values. Click RUN and name the resulting ERPset
grand. Save it as a file named grand.erp, because you’ll need it for a later exercise. Now plot the ERPs (EEGLAB > ERPLAB >
Plot ERP > Plot ERP waveforms), making one plot for Bins 1 and 2 (compatible trials) and another plot for Bins 3 and 4
(incompatible trials). Find the C3 and C4 channels (where the LRP is typically largest) and look for the contralateral negativity
from ~200-400 ms.
The key waveforms are summarized in Figure 10.2.A. For the compatible trials, the voltage at C3 from ~200-400 ms is more
negative on trials with a right-hand response than on trials with a left-hand response, and the voltage at C4 during this period is
more negative on trials with a left-hand response than on trials with a right-hand response. The overall voltage is positive in this
time range (because of the P3b component), and the LRP sums with the positive voltages to make the voltage more negative (less
positive) over the contralateral hemisphere than over the ipsilateral hemisphere.
The pattern is a little more complicated for the incompatible trials. At approximately 200 ms, you can see an opposite-polarity
effect, with a more negative voltage for left-hand than for right-hand responses at C3 and a more negative voltage for right-hand
than for left-hand responses at C4. This then reverses beginning at approximately 250 ms.
10.3.1 https://socialsci.libretexts.org/@go/page/87984

<!-- source_pdf=Full.pdf pdf_page=278 source_page_label="10.3.2" source_url="https://socialsci.libretexts.org/@go/page/87984" -->

## PDF page 278

- Source page label: 10.3.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87984

Figure 10.2. Grand averages from the new analysis of the ERP CORE flankers experiment, time-locked to stimulus onset. (A)
Original parent waveforms. (B) Waveforms after collapsing into contralateral and ipsilateral hemispheres (relative to response
hand). (C) Contralateral-minus-ipsilateral difference waves.
It’s a little challenging to piece together everything that’s happening with the waveforms shown in Figure 10.2.A. There are just a
lot of waveforms to look at. We can simplify things by using ERP Bin Operations to collapse the data into contralateral waveforms
(left-hemisphere waveforms on right-response trials averaged with right-hemisphere waveforms on left-response trials) and
ipsilateral waveforms (left-hemisphere waveforms on left-response trials averaged with right-hemisphere waveforms on right-
response trials).
Making these collapsed ERPsets is a little tricky (and is explained in the ERP Bin Operations section of the ERPLAB Manual). To
save some of your time, I’ve already made these collapsed ERPsets for you. To open them, first clear out any existing ERPsets
from ERPLAB using EEGLAB > ERPLAB > Clear ERPset(s). You should have 41 ERPsets (which you can verify in the
ERPsets menu), so enter 1:41 when asked which ERPsets to clear. Next, load the 40 ERPsets in the Chapter_10 > Data >
ERPsets_CI folder. You can now make a grand average of these ERPsets and plot the results (with one plot for Bins 1 and 2, and a
separate plot for Bins 3 and 4).
Figure 10.2.B shows the results from the C3 and C4 electrode sites (which are now combined, as indicated by the C3/C4 label).
Now we have only two pairs of waveforms rather than four pairs of waveforms, which makes it easier to see the contralateral
negativity.
To make things even easier, and to isolate the LRP from other overlapping voltages, we can use ERP Bin Operations make a
contralateral-minus-ipsilateral difference wave (Bin 1 minus Bin 2 for the compatible trials, and Bin 3 minus Bin 4 for the
ipsilateral trials). I’ve already done this for you. Clear out the ERPsets and load these difference wave files from the Chapter_10 >
Data > ERPsets_CI_Diff folder. Make a grand average, and plot the results (in a single plot with Bins 1 and 2).
Figure 10.2.C. shows the results at C3/C4. Now we have only one pair of waveforms, making it much easier to compare the LRP
for the compatible and incompatible trials. On the compatible trials, you can see a nice clear negativity from ~200-500 ms. On the
incompatible trials, you can see an initial contralateral positivity (which is really a negativity relative to the incorrect response),
followed by a delayed contralateral negativity.
This is pretty cool! Our main goal in including both compatible and incompatible trials in this experiment was to generate a
sufficient number of errors for the ERN analysis (because errors are a lot more common on incompatible trials). We didn’t intend to
do any comparisons of compatible and incompatible trials, so this is the first time anyone has looked at these effects. It’s gratifying
to see that we found the same pattern as in prior studies (e.g., Gratton et al., 1988), with a delayed LRP on incompatible trials that
is preceded by an opposite-polarity deflection.
This page titled 10.3: Exercise- Examining the Grand Averages is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
10.3.2 https://socialsci.libretexts.org/@go/page/87984

<!-- source_pdf=Full.pdf pdf_page=279 source_page_label="10.4.1" source_url="https://socialsci.libretexts.org/@go/page/87983" -->

## PDF page 279

- Source page label: 10.4.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87983

10.4: Exercise- A First Pass at Scoring and Statistical Analysis
Now let’s quantify these effects and then see if they’re statistically significant. In this exercise, we’ll take the approach that many
studies (including my own) used many years ago but has become less common as people figured out an approach that is both
simpler and better. We’ll start with the outdated approach because that will allow you to better see (a) why the newer approach is
better, and (b) how the newer approach provides equivalent information about the key questions.
Let’s start by scoring the LRP amplitude from each participant’s ERP waveforms. There are many different ways to score the
amplitude or latency of an ERP component, as described in detail in Chapter 9 of Luck (2014). In most cases, mean amplitude is
the best way to quantify ERP amplitudes. In the present exercise, we’ll measure the mean amplitude from 200-250 ms. This just
means that the scoring routine will sum together the voltage values for each time point in this latency range and then divide by the
number of time points. It’s that simple! The simplicity of mean amplitude means that it’s very easy to understand and even make
mathematical proofs about, and it has some very nice properties that we’ll see as we go through the next few exercises.
One of the most important issues involved in scoring ERPs is the choice of the time window. I chose 200-250 ms for this exercise
because this is the approximate time range in which the opposite-polarity effect for incompatible trials is typically seen.
Quit and restart EEGLAB, make sure that Chapter_10 is Matlab’s current folder, and then load all 40 ERPsets from the
Chapter_10 > Data > ERPsets folder. Then select EEGLAB > ERPLAB > ERP Measurement Tool and enter the parameters
shown in Screenshot 10.1. The left side of the GUI is used to indicate which ERPsets should be scored. We’re going to measure
from all 40 ERPsets that you just loaded. The right side of the GUI controls the scoring algorithm. You’ll specify that the basic
algorithm is Mean amplitude between two fixed latencies, and you’ll indicate that the starting and stopping latencies are 200 250.
This is the measurement window. We’re going to measure from the C3 and C4 channels (12 14) in all four bins (1:4). We’re going
to save the scores in a text file named mean_amplitude.txt.
Screenshot 10.1
10.4.1 https://socialsci.libretexts.org/@go/page/87983

<!-- source_pdf=Full.pdf pdf_page=280 source_page_label="10.4.2" source_url="https://socialsci.libretexts.org/@go/page/87983" -->

## PDF page 280

- Source page label: 10.4.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87983

It’s really tempting to hit the RUN button and get the scores, but you should always check the measurements against the ERP
waveforms first. You can do this by clicking the Viewer button. The Viewer tool will open, and you’ll see the ERP waveform from
the first bin and first channel in the first ERPset. The measurement window is indicated by the yellow region, and the value
produced by the scoring algorithm (5.628 µV) is shown in the window at the bottom.
You can then step through the different bins, channels, and ERPsets to verify that the algorithm is working sensibly. You may find it
convenient to look at multiple waveforms per screen. In the two cases shown in Screenshot 10.2, for example, I clicked the all box
for Bin and Channel to overlay the two bins and the two channels.
Not much can go wrong with the algorithm for measuring mean amplitude, but you may find surprising and problematic scores for
some participants when you use other algorithms (e.g., peak amplitude or peak latency). Even with mean amplitude, it’s humbling
and informative to see how much the ERP waveforms vary across participants. For example, the participant on the right in
Screenshot 10.2 has waveforms that are similar to those in the grand average (Figure 10.2)—with distinct P2, N2, and P3 peaks—
and the measurement window runs right through the N2 peak. By contrast, the participant on the left doesn’t have very distinct
peaks, and the measurement window is at the time of a positive peak.
Screenshot 10.2
This brings up an important point about ERPs (and most other methods used in the mind and brain sciences): Averages are a
convenient fiction. The ERP waveforms we get by averaging together multiple single-trial epochs may not be a good representation
of what happened on the single trials, and a grand average waveform across participants may not be a good representation of the
individual participants. However, it is difficult to avoid averaging (or methods that are generalizations of the same underlying idea,
such as regression). Chapters 2 and 8 in Luck (2014) discuss this issue in more detail.
Once you’ve finished scanning through all the ERP waveforms using the Viewer, click the Measurement Tool button to go back to
the Measurement Tool, and then click RUN to get the scores. Assuming that Chapter_10 is still the current folder in Matlab, a file
named mean_amplitude.txt should now be present in the Chapter_10 folder. Double-click on this file in Matlab’s Current Folder
pane to open it in the Matlab text editor. You’ll see that it consists of a set of tab-separated columns. Matlab’s text editor doesn’t
handle the tabs very well, so the column headings may not line up properly. I recommend opening it instead in a spreadsheet
program like Excel. Here’s what the first few lines should look like:
bin1_C3 bin1_C4 bin2_C3 bin2_C4 bin3_C3 bin3_C4 bin4_C3 bin4_C4 ERPset
5.628 4.124 6.818 5.741 6.623 5.66 7.247 6.607 1_LRP
6.902 7.534 4.72 8.7 3.629 6.546 6.178 5.47 2_LRP
3.149 5.122 1.19 1.962 4.361 4.309 4.441 4.638 3_LRP
10.4.2 https://socialsci.libretexts.org/@go/page/87983

<!-- source_pdf=Full.pdf pdf_page=281 source_page_label="10.4.3" source_url="https://socialsci.libretexts.org/@go/page/87983" -->

## PDF page 281

- Source page label: 10.4.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87983

Each row contains the data from one participant, and each column holds the score (mean amplitude value) for a bin/channel
combination for that participant. The Measurement Tool can also output the measurements in a “long” format in which each score
is on a separate line. This long format is particularly good for using pivot tables to summarize the data in Excel, and it works well
with some statistical packages. The “wide” format shown in the table above is ideal for statistical packages in which all the data for
a given participant are expected to be in a single row (e.g., SPSS, JASP).
Now that we have the scores, let’s do a statistical analysis using a traditional ANOVA. You can use any statistical package you like.
As I mentioned earlier, I recommend JASP if you don’t already have a package that can do basic t tests and within-subjects
ANOVAs.
The ANOVA should have three within-subjects factors, each with two levels: Electrode Hemisphere (left or right), Response Hand
(left or right), and Compatibility (Compatible or Incompatible). When you load the data into your statistical software and specify
the variables, it’s really easy to get the columns in the wrong order. Your first step in the statistical analysis should therefore be to
examine the table or plot of the descriptive statistics provided by your statistical software so that you can make sure that the data
were organized correctly. Figure 10.3 shows what I obtained in JASP.
Figure 10.3. Means from each cell of the design, obtained with JASP. Error bars show the standard error of the mean in each cell.
But how do you know what the correct values should be? It turns out that with mean amplitude scores (but not most other scores),
you get the same result by averaging the single-subject scores and by obtaining the scores from the grand average waveforms (see
the Appendix in Luck, 2014 for details). Load the grand average you created earlier (grand.erp) and run the Measurement Tool
again, but specifying that it should measure only from this ERPset and save the results in a file named
mean_amplitude_grand.txt. You can then compare those numbers to the values in the table or figure of descriptive statistics. Here
are the values I obtained:
bin1_C3 bin1_C4 bin2_C3 bin2_C4 bin3_C3 bin3_C4 bin4_C3 bin4_C4 ERPset
2.143 1.04 1.348 2.396 1.379 1.649 2.002 1.159 grand
These values exactly match the means shown in Figure 10.3. Success! Note that if you use some other scoring algorithm (e.g., peak
amplitude) in your own studies, the values won’t match exactly. However, you can at least make sure that the pattern is the same.
This verification process is very very very important! I estimate that you will find an error at least 10% of the time if you have
three or more factors in your design.
Before we look at the inferential statistics, let’s think about what main effects and interactions we would expect to see. First
consider the Compatible condition, in which the voltage should be more negative for the contralateral hemisphere than for the
ipsilateral hemisphere. This gives us a more negative voltage for left-hand responses than for right-hand responses over the right
hemisphere, and the reverse pattern over the left hemisphere. In other words, the presence of the LRP is captured in the ANOVA as
an interaction between Hemisphere and Hand. During this 200-250 ms time period, we expect to see an opposite effect for the
10.4.3 https://socialsci.libretexts.org/@go/page/87983

<!-- source_pdf=Full.pdf pdf_page=282 source_page_label="10.4.4" source_url="https://socialsci.libretexts.org/@go/page/87983" -->

## PDF page 282

- Source page label: 10.4.4
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87983

Incompatible trials (because the voltage is more negative over the hemisphere contralateral to the incorrect response, which makes
it more positive contralateral to the correct response). Consequently, the difference between the Compatible and Incompatible trials
should lead to a three-way interaction between Compatibility, Hemisphere, and Hand.
Table 10.1 shows the inferential statistics I obtained from JASP. You can see that the main effects of Hand and Hemisphere are not
significant, consistent with the fact that Figure 10.3 shows little or no overall difference between left-hand and right-hand responses
or between the left and right hemispheres. The main effect of Compatibility is also not significant, consistent with the fact that the
average voltage across cells for the Compatible condition was about the same as the average voltage across cells for the
Incompatible condition.
By contrast, the interaction between Hemisphere and Hand was significant. This interaction is equivalent to asking about the
contralaterality of the voltage if we averaged across Compatible and Incompatible trials. These two conditions yielded opposite-
direction effects that partially cancel each other out. However, the contralateral negativity for the Compatible trials was larger than
the contralateral positivity for the Incompatible trials, and this gives us an overall significant interaction. But this interaction is
meaningless at best and misleading at worst, because the patterns were opposite for the Compatible and Incompatible trials, as
indicated by the significant three-way interaction between Hemisphere, Hand, and Compatibility. This kind of complication is one
of the reasons why many researchers have stopped using this approach and have shifted to the simpler approach described in the
next exercise.
Table 10.1. Inferential statistics from JASP.
The next step in our statistical analysis would be to perform specific contrasts so that we can see, for example, if the Hemisphere
x Hand interaction is significant when the Compatible and Incompatible trials are analyzed separately. However, we’re not going to
take that next step, because this way of analyzing the data is less than ideal. First, the size of the LRP is captured by the
Hemisphere x Hand interaction rather than a main effect, which makes things difficult to understand. Second, this approach
generates a lot of p values, which means that the probability that we obtain one or more bogus-but-significant effects is quite high.
If you run a three-way ANOVA, you get 7 p values (as shown in Table 10.1), and you’ll have about a 30% chance of getting at least
one bogus-but-significant effect (if the null hypothesis is actually true for all 7 effects). So, it’s important to minimize the number
of factors in your analyses (see Luck & Gaspelin, 2017 for a detailed discussion of this issue). The next exercise will show you a
better approach.
10.4.4 https://socialsci.libretexts.org/@go/page/87983

<!-- source_pdf=Full.pdf pdf_page=283 source_page_label="10.4.5" source_url="https://socialsci.libretexts.org/@go/page/87983" -->

## PDF page 283

- Source page label: 10.4.5
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87983

 Bogus Effects
When an effect in the data is just a result of random variation and does not reflect a true effect in the population, I like to refer
to that effect as bogus. And if the effect is statistically significant, I refer to it as a bogus-but-significant effect. The technical
term for this is a Type I error. But that’s a dry, abstract, and hard-to-remember way of describing an incorrect conclusion that
might be permanently etched into the scientific literature.
This page titled 10.4: Exercise- A First Pass at Scoring and Statistical Analysis is shared under a CC BY 4.0 license and was authored, remixed,
and/or curated by Steven J Luck directly on the LibreTexts platform.
10.4.5 https://socialsci.libretexts.org/@go/page/87983

<!-- source_pdf=Full.pdf pdf_page=284 source_page_label="10.5.1" source_url="https://socialsci.libretexts.org/@go/page/87985" -->

## PDF page 284

- Source page label: 10.5.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87985

10.5: Exercise- Simplifying the Statistical Analysis
Most recent studies of the LRP (and other lateralized components, such as N2pc and CDA) obtain amplitude and latency scores
from contralateral-minus-ipsilateral difference waves (like those shown in Figure 10.2.C). This has two advantages. First, it
isolates the component of interest from all of the overlapping ERP components. Second, it reduces the number of factors in the
statistical analysis.
Let’s see how it works. Clear out all the ERPsets from ERPLAB, and load the 40 ERPsets in the Chapter_10 > Data >
ERPsets_CI_Diff folder. Then launch the Measurement Tool. Set it to measure from the 40 files in the ERPsets menu, using Bins
1 and 2 (Compatible and Incompatible) and Channel 5 (C3/C4). Specify mean_amplitude_CI_Diff.txt as the name of the output
file. Click Viewer and make sure that the measurements look reasonable given the waveforms. Click Measurement Tool to go
back to the Measurement Tool, and then click RUN to obtain the scores. You’ll see that we now have only two scores per
participant, one for the Compatible condition and one for the Incompatible condition.
Now let’s do a statistical analysis on these scores. Start by doing a paired t test comparing the Compatible and Incompatible
conditions. You should get a statistically significant t value of -5.885 (or +5.885, depending on which condition came first). And
here’s something very important: This t test is exactly equivalent to the three-way interaction between Hemisphere, Hand, and
Compatibility in the three-way ANOVA from the previous exercise. That is, it tests exactly the same null hypothesis, and it yields
exactly the same p value (except for possible rounding error). The t value for this paired t test corresponds exactly to the F value
from the three-way interaction once you realize that F is the same as t2. If we square 5.885, we get 34.63, which is the same (except
for rounding error) as the F value for the three-way interaction in Table 10.1. So, a t test on difference scores can be a simpler and
more convenient way of testing for an interaction, and it doesn’t cause a proliferation of p values.
 Fixing a Problem
When I tried to load the data into JASP, all the scores ended up in a single column. After spending a few minutes trying to
figure out what was causing this, I realized that the problem was that the column labels in the first row had commas in them,
which confused JASP. When I replaced the commas with underscores, everything worked fine.
Now let’s ask whether we have a statistically significant negativity for the Compatible condition and a statistically significant
positivity for the Incompatible condition. This just involves performing separate one-sample t tests for each of these conditions
(comparing the means to zero). When I did that, I obtained a significant negativity for the Compatible condition (t(39) = -6.107, p <
.001) and a significant positivity for the Incompatible condition (t(39) = 3.605, p < .001).
Isn’t this approach a lot simpler and more direct than a three-way ANOVA followed by a bunch of contrasts? We really have three
primary hypotheses, and with this approach we have one simple test for each of them.
This page titled 10.5: Exercise- Simplifying the Statistical Analysis is shared under a CC BY 4.0 license and was authored, remixed, and/or
curated by Steven J Luck directly on the LibreTexts platform.
10.5.1 https://socialsci.libretexts.org/@go/page/87985

<!-- source_pdf=Full.pdf pdf_page=285 source_page_label="10.6.1" source_url="https://socialsci.libretexts.org/@go/page/87986" -->

## PDF page 285

- Source page label: 10.6.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87986

10.6: Exercise- Peak Amplitude
For the first couple decades of ERP research, the primary way of scoring ERP amplitudes was to find the peak voltage during the
measurement window (either the most positive voltage for a positive peak or the most negative voltage for a negative peak). This
approach was used initially because ERPs were processed using primitive computers that created a printout of the waveform, and
researchers could easily determine the peak amplitude from the printout using a ruler (see Donchin & Heffley, 1978). This tradition
persisted long after more sophisticated computers and software were available, but in many ways the peak voltage is a terrible way
of scoring the amplitude of an ERP component. Mean amplitude is almost always superior. I provide a long list of the shortcomings
of peak amplitude and the benefits of mean amplitude in Chapter 9 of Luck (2014). More generally, peaks are highly overrated in
ERP research. Why should we care when the voltage reaches a maximum? Chapter 2 of Luck (2014) explains why peaks can be
very misleading, even when they’re measured well. Mean amplitude is now much more common than peak amplitude in most ERP
research areas, but there are some areas where peak amplitude is still common.
In this exercise, we’ll repeat the analyses from the previous exercise except that we’ll measure peak amplitude instead of mean
amplitude. And then you’ll see for yourself some of the shortcomings of peak amplitude.
Make sure that the 40 ERPsets from the previous exercise (from the Chapter_10 > Data > ERPsets_CI_Diff folder) are loaded.
Launch the Measurement Tool, and set it up as shown in Screenshot 10.3. As in the previous exercise, we want to see if there is a
contralateral negativity for the Compatible condition and a contralateral positivity for the Incompatible condition. We therefore
need to look for a negative peak for Bin 1 and a positive peak for Bin 2. This will take two steps. Screenshot 10.3 is set up for
finding the negative peak in Bin 1. (Technically, we’ll find the local peak, defined in this example as the most negative point that is
also more negative than the 3 points on either side; for details, see in Chapter 9 in Luck, 2014).
Screenshot 10.3
10.6.1 https://socialsci.libretexts.org/@go/page/87986

<!-- source_pdf=Full.pdf pdf_page=286 source_page_label="10.6.2" source_url="https://socialsci.libretexts.org/@go/page/87986" -->

## PDF page 286

- Source page label: 10.6.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87986

Once you have all the parameters set, click the Viewer button to verify that everything is working as intended. You should
immediately see a problem: As shown in Screenshot 10.4, the peak of the LRP falls outside the measurement window for the first
participant. And this isn’t an isolated incident; you’ll see the same problem for the 2nd and 3rd participants (and many others as
well). This makes sense if you look at the grand average waveforms in Figure 10.2.C. In general, you need a wider window to find
peaks than you need for mean amplitude.
Screenshot 10.4
To fix this, click the Measurement Tool button in the Viewer tool, and then change the Measurement Window to 150 400. Then
click the Viewer button to see the waveforms again. You should see that the algorithm is now correctly finding the peak for every
participant who has a clear peak. Go back to the Measurement Tool and click RUN to save the scores to a file named
negative_peak_bin1.txt.
Now repeat the measurement for the positive peak in Bin 2. Leave the window at 150 400, but change Negative to Positive, change
the bin from 1 to 2, and change the filename to positive_peak_bin2.txt. Make sure everything looks okay in the Viewer and then
click RUN to save the scores.
Now perform the same t tests as you did in the previous exercise on these peak amplitude values (which may first require
combining the scores into a single spreadsheet). You should see that the mean across participants is -3.23 µV for the Compatible
condition and +1.46 µV for the Incompatible condition and that the difference between conditions is significant (t(39) = -16.34, p <
.001). Also, the mean across participants is significantly less than zero for the Compatible condition (t(39) = -18.61, p < .001) and
significantly greater than zero for the Incompatible condition (t(39) = 8.71, p < .001).
10.6.2 https://socialsci.libretexts.org/@go/page/87986

<!-- source_pdf=Full.pdf pdf_page=287 source_page_label="10.6.3" source_url="https://socialsci.libretexts.org/@go/page/87986" -->

## PDF page 287

- Source page label: 10.6.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87986

But this is a completely invalid way of analyzing these data! First, the positive peak for the Incompatible trials is much earlier than
the negative peak for the Compatible trials, and it doesn’t usually make sense to compare voltages at different time points. Second,
peak amplitude is a biased measure that will tend to be greater than zero for positive peaks and less than zero for negative peaks
even if there is only noise in the data.
To see this bias, let’s repeat the analyses, but with a measurement window of -100 0 (i.e., the last 100 ms of the prestimulus
baseline period). There shouldn’t be any real differences prior to the onset of the stimuli, and any differences we see must be a
result of noise. To see this, find the negative peak between -100 and 0 ms for Bin 1 and the positive peak between -200 and 0 ms
for Bin 2. Then repeat the t tests with these scores.
You should see that the mean across participants is -0.89 µV for the Compatible condition and +1.04 µV for the Incompatible
condition. You should also see that the difference between conditions is significant (t(39) = -13.27, p < .001). Also, the mean across
participants is significantly less than zero for the Compatible condition (t(39) = -12.50, p < .001) and significantly greater than zero
for the Incompatible condition (t(39) = 11.30, p < .001). Thus, we get large and significant differences in peak amplitude between
conditions during the baseline period, and each condition is significantly different from zero, even though there is only noise during
this period. These are bogus-but-significant effects that a result of the fact that peak amplitude is a biased measure.
I hope it is clear why this happened. If you look at the baseline period of the single-participant waveforms with the Viewer, you’ll
see that the noise in the baseline is typically positive at some time points and negative at others. That’s what you’d expect for
random variations in voltage. If we take the most positive point in the period from -100 to 0 ms, it will almost always be greater
than zero. If we take the most negative point in this period, it will almost always be less than zero. So, noise alone will tend to give
us a difference in amplitude between the positive peak and the negative peak, and it will tend to make the positive peak greater than
zero and the negative peak less than zero.
It should be clear that it is not ordinarily legitimate to compare a positive peak with a negative peak (because noise alone will cause
a difference). And it should also be clear that it is not ordinarily legitimate to test whether an effect is present by comparing a peak
voltage to zero (because noise will cause a non-zero voltage).
A related point (which is not shown directly by this example) is that the peaks will tend to be larger when the noise level is higher.
This means that it is not ordinarily legitimate to compare peak amplitudes for two conditions that differ in noise level (e.g.,
standards and deviants in an oddball paradigm), because the averaged ERP waveforms will be noisier for the deviants owing to a
smaller number of trials. This can be solved by equating the number of trials in the averaged ERPs for each condition, but that
requires throwing away a large number of trials from the more frequent condition. Also, there may be other systematic sources of
noise. For example, some electrode sites are noisier than others (because they are closer to EMG sources), and some groups of
participants are noisier than others (e.g., patient waveforms are often noisier than control waveforms).
The bottom line is that the peak voltage is not usually the best way to quantify the amplitude of an ERP component. Mean
amplitude is much better in the vast majority of cases.
This page titled 10.6: Exercise- Peak Amplitude is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck
directly on the LibreTexts platform.
10.6.3 https://socialsci.libretexts.org/@go/page/87986

<!-- source_pdf=Full.pdf pdf_page=288 source_page_label="10.7.1" source_url="https://socialsci.libretexts.org/@go/page/137660" -->

## PDF page 288

- Source page label: 10.7.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137660

10.7: Exercise- Peak Latency
Now we’re going to switch from scoring amplitudes to scoring latencies. The traditional method for scoring latencies is to find the
peak voltage in the measurement window (positive or negative) and record the latency at which this peak occurred. Like peak
amplitude, peak latency is not usually the best scoring algorithm (see Chapter 9 in Luck, 2014). We’ll look at some better
alternatives in the following exercises.
In the present exercise, we’re going to ask whether the peak latency of the LRP in the contralateral-minus-ipsilateral difference
wave is later on incompatible trials than on compatible trials. Make sure that the 40 ERPsets from the previous exercise (from the
Chapter_10 > Data > ERPsets_CI_Diff folder) are loaded. Launch the Measurement Tool and set it up as shown in Screenshot
10.5. The measurement Type is Peak latency, and we’re looking for a negative peak. We’re measuring from Bins 1 and 2
(Compatible and Incompatible) in the C3/C4 channel, and we’re saving the scores in a file named peak_latency.txt.
A key question in scoring ERP amplitudes and latencies is how to determine the time window. This is a complicated question, and
you can read about several strategies in Chapter 9 of Luck (2014) and in Luck and Gaspelin (2017). As mentioned earlier, the most
important thing is to avoid being biased by the data, which is best achieved by deciding on the measurement windows before you
start the study. Of course, it’s too late for that now with the ERP CORE experiments. However, if I were to choose a time window
in advance for the LRP in a flankers paradigm, I’d assume that the LRP begins after 100 ms and ends by 700 ms. For this reason,
we’ll use a measurement window of 100 to 700 ms in this exercise.
Screenshot 10.5
As always, the next step is to click the Viewer button to see how well the algorithm is working. You’ll see that it has mixed
success. It works reasonably well for waveforms that are clean and contain a large peak (e.g., File 2), but the scores are distorted by
high-frequency noise (e.g., Files 1 and 12), and the values are largely random for waveforms without a distinct peak (e.g., Files 9
and 10).
10.7.1 https://socialsci.libretexts.org/@go/page/137660

<!-- source_pdf=Full.pdf pdf_page=289 source_page_label="10.7.2" source_url="https://socialsci.libretexts.org/@go/page/137660" -->

## PDF page 289

- Source page label: 10.7.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137660

Now go back to the Measurement Tool and click RUN to save the scores. Load the data into your statistics package and perform a
paired t test to compare the Compatible and Incompatible conditions. Verify that the means provided by the statistics package are
reasonable. You should see a mean of 318 ms for Compatible and 375 ms for Incompatible. Unfortunately, the trick we used with
mean amplitude—comparing the means from the statistical package with the values measured from the grand average—doesn’t
work with peak latency. If you measure the peak latency directly from the grand average ERP waveforms, you’ll see a value of 285
ms for Compatible and 355 ms for Incompatible. The values from the grand average aren’t the same as the mean of the single-
subject values, but at least they show the same ordering (Compatible < Incompatible).
Now look at the actual t test results. You should see that the peak latency was significantly shorter for Compatible trials than for
Incompatible trials (t(39) = -3.647, p < .001). Given the huge differences between Compatible and Incompatible trials in the grand
average waveforms (Figure 10.2.C), it’s not surprising that the difference in peak latency was significant, even if peak latency isn’t
an ideal scoring algorithm. You should also look at the effect size, measured as Cohen’s d , which indicates how far apart the means
z
are relative to the pooled standard deviation. You should see an effect size of -0.577 (or +0.577, depending on the order of
conditions in your analysis), which is a medium effect size.
If you’re familiar with effect sizes in ERP studies, you might be surprised that this effect size isn’t bigger. After all, the peaks in the
grand averages are very far apart in time. It therefore seems reasonable to suppose that we had a lot of measurement error when we
computed the peak latency, which increased the standard deviation of the scores and therefore reduced the effect size. Given that
peak latency scores are distorted by high-frequency noise, we should be able to reduce the measurement error and increase the
effect size by applying a low-pass filter to the averaged ERPs prior to obtaining the peak latency scores.
Let’s try it. It would take quite a while for you to filter all 40 of the ERPsets using the GUI, so I’ve provided the ERPsets for you in
Chapter_10 > Data > ERPsets_CI_Diff_filt. They’ve been low-pass filtered with a half-amplitude cutoff of 20 Hz and a slope of
12 dB/octave. Clear out the existing ERPsets from ERPLAB, load the filtered ERPsets, and repeat the measurement and analysis
procedure (but changing the name of the measurement file to peak_latency_filt.txt). You’ll see that the effect size is now a little
larger (d = -0.630). So, filtering helped, but only a little. Sometimes it helps a lot, especially when there is a lot of high-frequency
noise in the data (which is not true for most of the waveforms in this experiment).
This page titled 10.7: Exercise- Peak Latency is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck
directly on the LibreTexts platform.
10.7.2 https://socialsci.libretexts.org/@go/page/137660

<!-- source_pdf=Full.pdf pdf_page=290 source_page_label="10.8.1" source_url="https://socialsci.libretexts.org/@go/page/137662" -->

## PDF page 290

- Source page label: 10.8.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137662

10.8: Exercise- Fractional Area Latency
In this exercise, we’re going to look at a different latency scoring algorithm called fractional area latency, which is often superior
to peak latency (especially when measured from difference waves). For a negative component like the LRP, this algorithm
calculates the area of the waveform below the zero line and then finds the time point that divides the area into two areas at a
particular percentage. If you want to estimate the midpoint of the waveform, you will look for the 50% point (the time that divides
the area into two equal halves). This is then called the 50% area latency (see Chapter 9 in Luck, 2014, for more details). Screenshot
10.6 shows what it looks like when I apply this algorithm to Bin 2 (Incompatible) from the grand average, using a measurement
window of 100 to 700 ms. The area under the curve in this measurement window is shaded in red, and the point that divides this
area into two equal halves is indicated by the red vertical line. This region includes some little areas near the beginning and end of
the measurement window, but that’s just how it goes. It’s difficult to perfectly quantify ERP amplitudes and latencies, and we have
to live with some error.
Screenshot 10.6
 Don’t Worry About High-Frequency Noise in Area-Based Measures
Area-based measures like fractional area latency are relatively insensitive to high-frequency noise, so we will apply this
method to the unfiltered data. It's also usually unnecessary to filter out high-frequency noise when measuring mean amplitude.
Let’s apply this scoring algorithm to the single-participant waveforms. If the filtered ERPsets from the previous exercise are still
loaded in ERPLAB, clear them (or quit and restart EEGLAB). Then load the 40 unfiltered difference waves (from the Chapter_10
> Data > ERPsets_CI_Diff folder). Launch the Measurement Tool, and set it up as shown in Screenshot 10.7. The measurement
Type is Fractional area latency, and we’re looking for the 50% point in the Area for negative waveforms. We’re again
measuring from Bins 1 and 2 (Compatible and Incompatible) in the C3/C4 channel, and we’re saving the scores in a file named
negative_area_latency.txt.
10.8.1 https://socialsci.libretexts.org/@go/page/137662

<!-- source_pdf=Full.pdf pdf_page=291 source_page_label="10.8.2" source_url="https://socialsci.libretexts.org/@go/page/137662" -->

## PDF page 291

- Source page label: 10.8.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137662

Screenshot 10.7
Using the Viewer, make sure that the scoring algorithm is working properly. Then go back to the Measurement Tool and click RUN
to save the measurements. Load the data into your statistics package and do a paired t test, as in the previous exercise. You’ll see
that the mean latency is ~45 ms shorter for the Compatible condition than for the Incompatible condition, which is actually a
somewhat smaller difference than we saw for peak latency (a 57 ms difference). However, the Cohen’s d has increased
substantially, from -0.577 for peak latency to -0.823 for the 50% area latency measure. And if you look at the descriptive statistics,
you’ll see that the standard deviations are now quite a bit lower. So, we now have a large effect size instead of a medium effect
size, due to reduced variability (presumably owing to reduced measurement error).
The increased effect size we’re seeing for 50% area latency relative to peak latency is consistent with what I’ve seen in many
previous experiments. This is one of the reasons I recommend using 50% area latency, especially when the measurements are being
obtained from difference waves.
 When to Use Fractional Area Latency
The fractional area latency algorithm works well only if the waveform is dominated by a single component. This is usually true
of difference waves, which are designed to isolate a single component. The 50% area latency measure also works well on
parent waves when the component of interest is so large that it dominates everything else (e.g., the N400 for semantically
deviant words or the P3b for rare targets).
A more direct way to compare measurement error for these two different scoring algorithms would be to look at the standardized
measurement error (SME). Unfortunately, it’s complicated to compute the SME for anything other than mean amplitudes. When
some other scoring algorithm is used, or when the measurements are obtained from difference waves, a method called
bootstrapping is necessary for calculating the SME. Currently, this can’t be done from the ERPLAB GUI and instead requires
10.8.2 https://socialsci.libretexts.org/@go/page/137662

<!-- source_pdf=Full.pdf pdf_page=292 source_page_label="10.8.3" source_url="https://socialsci.libretexts.org/@go/page/137662" -->

## PDF page 292

- Source page label: 10.8.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137662

scripting. I’ve provided a script for this at the end of the chapter. The script demonstrates that the SME was in fact much better
(lower) for the 50% area latency measure than for the peak latency measure in this experiment.
This page titled 10.8: Exercise- Fractional Area Latency is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
10.8.3 https://socialsci.libretexts.org/@go/page/137662

<!-- source_pdf=Full.pdf pdf_page=293 source_page_label="10.9.1" source_url="https://socialsci.libretexts.org/@go/page/137664" -->

## PDF page 293

- Source page label: 10.9.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137664

10.9: Exercise- Quantifying Onset Latency
As described in Chapter 2 of Luck (2014), the onset time of a difference between two conditions can be extremely informative. For
example, the brain can’t have a more negative response over the contralateral hemisphere than over the ipsilateral hemisphere until
it has determined which hand should respond, so the onset latency of the LRP can be used as a marker of the time at which the
brain has decided on a response (see Chapters 2 and 3 in Luck, 2014, for a more detailed and nuanced discussion).
How can we quantify the onset time of a difference wave? Consider, for example, the Compatible waveform in Figure 10.2.C. The
negativity of the LRP first falls below the zero line a little before 200 ms. However, the negativity before 200 ms is no larger than
the noise level (as assessed, e.g., by the variations in voltage during the prestimulus period). Early research attempted to solve this
problem by using a statistical criterion such as the first of N consecutive points that are at least 2 standard deviations greater than
the noise level (where the standard deviation is measured from the variation in voltage during the prestimulus period). However,
this approach suffers from low power, and single-participant scores will vary according to the noise level as well as the true onset
time. A terrific study by Kiesel et al. (2008) rigorously compared this technique with peak latency and two other measures that
were not very widely used at the time—fractional area latency and fractional peak latency—and found that the two less widely used
scoring methods were actually the best. These two methods are now more commonly used, and we’ll focus on them here.
We already looked at fractional area latency in the previous exercise, but we used it to estimate the midpoint latency (the 50% area
latency) rather than the onset latency. To estimate the onset latency, we simply need to use a lower percentage. In the present
exercise, we’ll calculate the time at which the area reaches the 15% point. To get started, make sure that the 40 ERPsets from the
Chapter_10 > Data > ERPsets_CI_Diff folder are loaded. Launch the Measurement Tool, and set it up as in the previous exercise
(Screenshot 10.7), except change the percentage from 50 to 15, and change the name of the output file to something like
FAL15_latency.txt. Take a look at the scores for the individual waveforms using the Viewer, and then run the measurement routine
to save the scores.
As before, load the resulting scores into your statistical package and compute the paired t test to compare the Compatible and
Incompatible conditions. You should see that difference in means across conditions is ~50 ms and that the effect is statistically
significant (t(39) = -6.06, p < .001) with a very large effect size (d = -1.044).
Now let’s try the other scoring algorithm, fractional peak latency, which is illustrated in Figure 10.4. This method finds the peak
and then moves backward in time until the voltage reaches some fraction of the peak voltage (usually the 50% point). The latency
of this point is then used as the estimate of onset latency. You might wonder why we usually choose the 50% point. Isn’t the 15%
point, for example, closer to the true onset? There are two reasons to choose the 50% point. First, it’s less influenced by noise and
therefore more reliable than lower percentages. Second, it actually does a better job of capturing the average onset time given that
there is almost always significant trial-to-trial variation in onset times. As discussed in Chapter 2 of Luck (2014), the first moment
that an averaged waveform deviates from zero is driven by the trials with the earliest onset times. And as discussed in Chapter 9 of
that book, the 50% peak latency point accurately captures the average of the single-trial onset times under some conditions.
Figure 10.4. Example of the fractional peak latency method. In this example, we obtained the 50% peak latency (the latency at
which the voltage reached 50% of the peak voltage).
Let’s give it a try. First, clear the existing ERPsets out of ERPLAB (or quit and restart EEGLAB) and load the filtered ERPsets in
the Chapter_10 > Data > ERPsets_CI_Diff_filt folder. This scoring method is, unfortunately, very sensitive to high-frequency
10.9.1 https://socialsci.libretexts.org/@go/page/137664

<!-- source_pdf=Full.pdf pdf_page=294 source_page_label="10.9.2" source_url="https://socialsci.libretexts.org/@go/page/137664" -->

## PDF page 294

- Source page label: 10.9.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137664

noise, so we ordinarily apply fairly aggressive low-pass filtering (which, fortunately, has relatively little impact on the 50% peak
latency). Launch the Measurement Tool, and set it up as shown in Screenshot 10.8. Once you have the parameters set, use the
Viewer to make sure that the scores look appropriate for the single-participant waveforms. Then run the routine to save the scores
to a file named fractional_peak_latency_filt.txt.
Screenshot 10.8
Load the resulting scores into your statistical package and compute the paired t test. You should see that difference in means across
conditions is ~50 ms, just as for the 15% area latency measure from the previous exercise. The effect is statistically significant
(t(39) = -4.39, p < .001), but the effect size is smaller than observed in the previous exercise (d =-0.695 for 50% peak latency
versus d = -1.044 for 15% area latency).
So, which of these two scoring methods is best? The effect size was larger for 15% area latency than for 50% peak latency in the
analysis you just did. Also, Kiesel et al (2008) found that 50% area latency yielded less variability than 50% peak latency.
Unfortunately, they didn’t examine 15% area latency, and they didn’t apply an aggressive low-pass filter prior to obtaining the 50%
peak latency scores. We also found lower standard deviations for 50% area latency than for 50% peak latency for all of the basic
difference waves in the six ERP CORE paradigms (see Table 3 in Kappenman et al., 2021). However, the 50% area latency
captures the midpoint of the difference wave, not the onset, which is less sensitive to noise, so this really isn’t a fair comparison. I
think it’s fair to say that this issue is unresolved at this point.
However, there is an important conceptual difference between these two scoring methods. Specifically, fractional area latency is
impacted by voltages throughout the entire measurement window. For example, the negative voltage late in the waveform for the
Incompatible trials (see Figure 10.2.C) will have an impact on the 15% fractional area latency score. By contrast, fractional peak
latency is not influenced by anything that happens after the peak. This is particularly clear in the example shown in Figure 10.4,
where there is a long “tail” to the difference wave that will have a large impact on the fractional area latency score but will have no
impact on the fractional peak latency score. For this reason, I usually use the fractional peak latency score.
10.9.2 https://socialsci.libretexts.org/@go/page/137664

<!-- source_pdf=Full.pdf pdf_page=295 source_page_label="10.9.3" source_url="https://socialsci.libretexts.org/@go/page/137664" -->

## PDF page 295

- Source page label: 10.9.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137664

This exemplifies a broader issue: Although minimizing measurement error is important, it’s also important to make sure that your
scoring method is valid (i.e., measures what you are trying to measure with minimal influence from other factors).
This page titled 10.9: Exercise- Quantifying Onset Latency is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
10.9.3 https://socialsci.libretexts.org/@go/page/137664

<!-- source_pdf=Full.pdf pdf_page=296 source_page_label="10.10.1" source_url="https://socialsci.libretexts.org/@go/page/137666" -->

## PDF page 296

- Source page label: 10.10.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137666

10.10: Exercise- Collapsing Across Channels and Correlating Latencies with
Response Times
So far, we’ve been measuring and analyzing the data only from the C3 and C4 channels, where the LRP is largest. However, it’s
often valuable to include the data from multiple channels. One way to do that is to measure from multiple different channels and
include channel as a factor in the statistical analysis. However, that adds another factor to the analysis, which increases the number
of p values and therefore increases the probability of getting bogus-but-significant effects. Also, interactions between an
experimental manipulation and electrode site are difficult to interpret (Urbach & Kutas, 2002, 2006). In most cases, I therefore
recommend averaging the waveforms across the channels where the component is large, creating a cluster, and then obtaining the
amplitude or latency scores from the cluster waveform. Averaging across channels in this manner tends to produce a cleaner
waveform, which decreases the measurement error (as long as we don’t include channels where the ERP effect is substantially
smaller). Also, it avoids the temptation to “cherry-pick” the channel with the largest effect.
In the ERP CORE flankers experiment, the LRP effect was only slightly smaller in the F3/F4 and C5/C6 channels than in the
C3/C4 channel, so we should be able to decrease our measurement error and increase our effect sizes by creating a cluster of these
three sets of channels.
I’ve already created this cluster in the difference waves in the Chapter_10 folder. They’re in Channel 12, which is labeled cluster.
Let’s try measuring the peak latency from this channel in the filtered data (which should already be loaded). You can just repeat the
measurement and analysis procedures from the earlier exercise where we measured the peak latency from the filtered data, but
changing the Channel from 5 to 12. You should see that the effect size has increased a bit (-0.683 for the cluster analysis relative to
-0.630 when we measured from the C3/C4 channel). Collapsing across channels doesn’t always increase the effect size, but it
doesn’t usually hurt, and it avoids the need to include channel as a factor in the analysis or the need to determine which one
channel to use. My lab now measures from a cluster in virtually all of our studies.
Our last step will be to ask whether the peak latency values are correlated with response times (RTs). That is, do participants with
later LRP peaks also have slower RTs? Unfortunately, it takes some significant work to extract RTs using ERPLAB. In your own
experiments, you might want to do this using the output of your stimulus presentation system instead of using ERPLAB. For the
present exercise, I wrote an ERPLAB script to obtain the mean RTs for Compatible and Incompatible trials for each participant. I
saved the values to an Excel spreadsheet named RT.xlsx, which you can find in the Chapter_10 folder. An advantage of using an
ERPLAB script to get the RTs is that you can exclude the trials that were rejected because of artifacts from the mean RTs so that the
ERP data and the behavioral data are based on exactly the same set of trials. A disadvantage is that it takes a bit of work. I’ve
provided the script I wrote for this purpose (named get_LRP_RTs.m in the Chapter_10 folder), which you can use as a model for
your own studies.
Let’s look at the correlations. You’ll need to combine the RT values from the spreadsheet with the peak latency values that you just
created from the waveforms that were collapsed across the three pairs of electrode sites. And then you’ll need to read them into
your statistical package or into a spreadsheet program (see peak_latency_filt_collapsed.xlsx in the Chapter_10 folder). You’ll
then want to look at the correlation between peak latency and RT separately for the Compatible condition and the Incompatible
condition.
Figure 10.5 shows the results I obtained in Excel. The peak latency scores were correlated fairly well with the RTs, especially for
the incompatible trials. Some outliers in the LRP peak latency scores for the Compatible trials clearly reduced the correlation in the
that condition. Nonetheless, these correlations show that the timing of the brain activity is related to the timing of the behavioral
response.
10.10.1 https://socialsci.libretexts.org/@go/page/137666

<!-- source_pdf=Full.pdf pdf_page=297 source_page_label="10.10.2" source_url="https://socialsci.libretexts.org/@go/page/137666" -->

## PDF page 297

- Source page label: 10.10.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137666

Figure 10.5. Scatterplots showing the relationship between LRP peak latency and response time for the Compatible and
Incompatible conditions.
This page titled 10.10: Exercise- Collapsing Across Channels and Correlating Latencies with Response Times is shared under a CC BY 4.0
license and was authored, remixed, and/or curated by Steven J Luck directly on the LibreTexts platform.
10.10.2 https://socialsci.libretexts.org/@go/page/137666

<!-- source_pdf=Full.pdf pdf_page=298 source_page_label="10.11.1" source_url="https://socialsci.libretexts.org/@go/page/137667" -->

## PDF page 298

- Source page label: 10.11.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137667

10.11: Matlab Scripts For This Chapter
I’ve created three scripts for this chapter. The first script is named LRP_RTs.m, and it shows you how to get the single-trial RTs
for the trials without artifacts flagged, compute the mean RT for each condition, and save the results to an Excel spreadsheet.
The second script, LRP_scoring.m, shows you how to obtain several of the amplitude and latency scores described in this chapter.
The third script, LRP_bSME.m, demonstrates how to get the SME values for several of the scores. For scores other than mean
amplitude, bootstrapping is required (Luck et al., 2021), and we call the result the bootstrapped SME or bSME. The script
demonstrates how to implement the bootstrapping procedure and compute the bSME values. Bootstrapping requires re-averaging
the data for a given participant many times, and it can be slow. The script is set to do only 100 iterations per participant so that it
runs reasonably quickly. There is a variable you can change to a larger value (e.g., 10,000) to get more robust SME estimates.
This page titled 10.11: Matlab Scripts For This Chapter is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven
J Luck directly on the LibreTexts platform.
10.11.1 https://socialsci.libretexts.org/@go/page/137667

<!-- source_pdf=Full.pdf pdf_page=299 source_page_label="10.12.1" source_url="https://socialsci.libretexts.org/@go/page/137668" -->

## PDF page 299

- Source page label: 10.12.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137668

10.12: Key Takeaways and References
Key Takeaways
Many methods exist to quantify the timing or magnitude of an ERP component or experimental effect. The traditional methods
—peak amplitude and peak latency—have many shortcomings, and better methods are available.
In many cases, it is advantageous to obtain scores from a difference wave that isolates the component or experimental effect of
interest.
You should always visually verify that the scores are being calculated appropriately for each individual ERP waveform.
Most scoring methods require specifying a measurement window, and this needs to be done in an unbiased manner. If you
decide on the measurement window after seeing the waveforms, you may consciously or unconsciously choose a window that
increases the probability of bogus-but-significant effects.
When you have many conditions and/or channels, it’s easy to accidentally put the cells of the design into the wrong order in the
statistical analysis. You should always check the table of means produced by your statistical package and make sure it matches
what you are seeing in the grand average ERP waveforms.
For mean amplitude, but not most other scoring methods, taking the score from the grand average waveforms gives you the
same result as measuring from the single-participant waveforms and then averaging. This makes it easy to compare the table
of means with the grand averages.
For other measures, you can still make sure that the table of means shows the same pattern as the grand averages, even if the
individual values are not identical.
To reduce the number of p values and the likelihood of bogus-but-significant effects, you should use the smallest possible
number of factors in your statistical analyses. This can often be achieved by collapsing across channels and obtaining scores
from difference waves.
References
Donchin, E., & Heffley, E. F. (1978). Multivariate analysis of event-related potential data: A tutorial review. In D. Otto (Ed.),
Multidisciplinary Perspectives in Event-Related Brain Potential Research (pp. 555–572). U.S. Government Printing Office.
Eriksen, C. W. (1995). The flankers task and response competition: A useful tool for investigating a variety of cognitive problems.
Visual Cognition, 2, 101–118.
Gehring, W. J., Liu, Y., Orr, J. M., & Carp, J. (2012). The error-related negativity (ERN/Ne). In S. J. Luck & E. S. Kappenman
(Eds.), The Oxford Handbook of Event-Related Potential Components (pp. 231–292). Oxford University Press.
Gratton, G., Coles, M. G. H., Sirevaag, E. J., Eriksen, C. W., & Donchin, E. (1988). Pre- and post-stimulus activation of response
channels: A psychophysiological analysis. Journal of Experimental Psychology: Human Perception and Performance, 14, 331–
344.
Kappenman, E. S., Farrens, J. L., Zhang, W., Stewart, A. X., & Luck, S. J. (2021). ERP CORE: An Open Resource for Human
Event-Related Potential Research. NeuroImage, 225, 117465. https://doi.org/10.1016/j.neuroimage.2020.117465
Kiesel, A., Miller, J., Jolicoeur, P., & Brisson, B. (2008). Measurement of ERP latency differences: A comparison of single-
participant and jackknife-based scoring methods. Psychophysiology, 45, 250–274. https://doi.org/10.1111/j.1469-
8986.2007.00618.x
Love, J., Selker, R., Marsman, M., Jamil, T., Dropmann, D., Verhagen, J., Ly, A., Gronau, Q. F., Šmíra, M., Epskamp, S., Matzke,
D., Wild, A., Knight, P., Rouder, J. N., Morey, R. D., & Wagenmakers, E.-J. (2019). JASP: Graphical Statistical Software for
Common Statistical Designs. Journal of Statistical Software, 88(1), 1–17. https://doi.org/10.18637/jss.v088.i02
Luck, S. J. (2014). An Introduction to the Event-Related Potential Technique, Second Edition. MIT Press.
Luck, S. J., & Gaspelin, N. (2017). How to get statistically significant effects in any ERP experiment (and why you shouldn’t).
Psychophysiology, 54, 146–157. https://doi.org/10.1111/psyp.12639
10.12.1 https://socialsci.libretexts.org/@go/page/137668

<!-- source_pdf=Full.pdf pdf_page=300 source_page_label="10.12.2" source_url="https://socialsci.libretexts.org/@go/page/137668" -->

## PDF page 300

- Source page label: 10.12.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137668

Luck, S. J., Stewart, A. X., Simmons, A. M., & Rhemtulla, M. (2021). Standardized measurement error: A universal metric of data
quality for averaged event-related potentials. Psychophysiology, 58, e13793. https://doi.org/10.1111/psyp.13793
Smulders, F. T. Y., & Miller, J. O. (2012). The Lateralized Readiness Potential. In S. J. Luck & E. S. Kappenman (Eds.), The
Oxford Handbook of Event-Related Potential Components (pp. 209–229). Oxford University Press.
Urbach, T. P., & Kutas, M. (2002). The intractability of scaling scalp distributions to infer neuroelectric sources. Psychophysiology,
39, 791–808. https://doi.org/10.1017/S0048577202010648
Urbach, T. P., & Kutas, M. (2006). Interpreting event-related brain potential (ERP) distributions: Implications of baseline potentials
and variability with application to amplitude normalization by vector scaling. Biological Psychology, 72(3), 333–343.
https://doi.org/10.1016/j.biopsycho.2005.11.012
This page titled 10.12: Key Takeaways and References is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven
J Luck directly on the LibreTexts platform.
10.12.2 https://socialsci.libretexts.org/@go/page/137668
