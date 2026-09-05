#!/usr/bin/env python3
"""Static contract checks for the locked 905 CAR MATLAB workflow."""

from pathlib import Path
import re


ROOT = Path(__file__).resolve().parent
MATLAB = sorted(ROOT.glob("*.m"))
EXPECTED = {
    "config_905_subject_template.m",
    "refresh_905_config.m",
    "validate_905_config.m",
    "init_905_runtime.m",
    "n400u_channel_indices.m",
    "phase01_import_audit.m",
    "phase02_reference.m",
    "phase03_filter.m",
    "phase04_ica.m",
    "phase05_epoch_artifact.m",
    "phase06_average_erp.m",
    "phaseS1_sentence_epoch.m",
    "phaseS2_sentence_word_aligned_erp.m",
    "review_phase02_reference_gate.m",
    "review_phase04_threshold_gate.m",
    "review_phase05_artifact_gate.m",
    "plot_905_erp_qc.m",
}


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


names = {path.name for path in MATLAB}
require(EXPECTED <= names, f"Missing files: {sorted(EXPECTED - names)}")
all_text = "\n".join(path.read_text(encoding="utf-8") for path in MATLAB)
lower = all_text.lower()

for forbidden in (
    "average_mastoid",
    "cfg.m1_channel",
    "cfg.m2_channel",
    "cfg.eeg_channels",
    "cfg.eog_channels",
    "cfg.trigger_channel",
    "cfg.bad_channels",
    "cfg.ica_channels",
    "cfg.interpolated_set",
    "828update",
):
    require(forbidden not in lower, f"Legacy contract remains: {forbidden}")
require("scripts/systematic" not in lower, "Calls old systematic scripts")
require("nobase" not in lower and "no-baseline" not in lower,
        "Contains an unbaselined formal branch")

config = (ROOT / "config_905_subject_template.m").read_text()
refresh = (ROOT / "refresh_905_config.m").read_text()
phase2 = (ROOT / "phase02_reference.m").read_text()
phase3 = (ROOT / "phase03_filter.m").read_text()
phase4 = (ROOT / "phase04_ica.m").read_text()
review4 = (ROOT / "review_phase04_threshold_gate.m").read_text()
phase5 = (ROOT / "phase05_epoch_artifact.m").read_text()
phase6 = (ROOT / "phase06_average_erp.m").read_text()
sentence1 = (ROOT / "phaseS1_sentence_epoch.m").read_text()
sentence2 = (ROOT / "phaseS2_sentence_word_aligned_erp.m").read_text()
plot_qc = (ROOT / "plot_905_erp_qc.m").read_text()

require("{'M1','M2','CB1','CB2'}" in config,
        "Template lacks the four fixed exclusions")
require("cfg.eog_labels = {'VEOG','HEOG'}" in config
        and "cfg.trigger_label = 'TRIGGER'" in config,
        "Auxiliary labels are not locked")
require("cfg.reference_mode = 'common_average'" in config
        and "cfg.final_car_for_all = true" in config,
        "CAR contract is not locked")
require("bad_channel_labels" in config and "bad_channel_candidate_labels" in config,
        "Bad channels are not label-based")
require("result_update" in refresh and "905_car" in refresh,
        "905 output root is not isolated")
require("cfg.reference_tag = referenceTag" in refresh
        and "referenceTag = 'car'" in refresh,
        "CAR filename tag is missing")
require("cfg.final_car_set" in refresh,
        "Final-CAR continuous checkpoint is missing")

require("pop_select(EEG,'nochannel',fixedChannels)" in phase2,
        "Phase 2 does not permanently remove the four fixed channels")
require("pop_reref(EEG,[],'exclude',[auxChannels badChannels]" in phase2,
        "Phase 2 does not use good-scalp initial CAR")
require(phase2.index("pop_select(EEG,'nochannel',fixedChannels)")
        < phase2.index("pop_reref(EEG,[]"),
        "Fixed channels must be removed before initial CAR")
require("n400u_channel_indices" in phase2,
        "Phase 2 does not resolve channels by labels")

require("'Filter','PMnotch','Design','notch'" in phase3
        and "cfg.line_notch_hz" in phase3,
        "Phase 3 lacks the locked PMnotch step")
require("triggerAfterResample" in phase3
        and "cfg.trigger_label" in phase3,
        "Phase 3 does not protect the label-resolved trigger")
require("numericalRank = rank" in phase4
        and "expectedRank = numel(icaChannels)-1" in phase4
        and "'pca',numericalRank" in phase4,
        "Phase 4 lacks CAR-rank/PCA control")
require("bad_channel_labels" in phase4 and "icaChannels" in phase4,
        "Phase 4 does not exclude ordinary bad scalp channels")
require("nextStartItem = startItems(trial+1)" in phase4
        and "assert(isscalar(targetItems)" in phase4,
        "Phase 4 target matching is not constrained to the current trial")
require("nextStartItem = startItems(trial+1)" in review4
        and "assert(isscalar(targetItems)" in review4,
        "Gate B review target matching is not constrained to the current trial")
require("ICA and formal-data channel labels/order do not match" in phase4,
        "Phase 4 does not verify channel labels/order during weight transfer")

require("pop_interp(EEG,badChannels,'spherical')" in phase5,
        "Phase 5 lacks post-ICA bad-channel interpolation")
require("pop_reref(EEG,[],'exclude',auxChannels" in phase5,
        "Phase 5 lacks mandatory final CAR")
require(phase5.index("pop_interp(EEG,badChannels,'spherical')")
        < phase5.index("pop_reref(EEG,[],'exclude',auxChannels"),
        "Final CAR must follow interpolation")
require("applied_to_every_participant',true" in phase5,
        "Final CAR is not documented as universal")
require("cfg.final_car_set" in phase5 and phase5.count("pop_epochbin") == 1,
        "Phase 5 final-CAR-to-epoch dependency is invalid")
require("cfg.baseline_ms" in phase5 and "new.set" in phase5
        and "UPDATE MARKS" in phase5 and "never REJECT" in phase5,
        "Gate D contract is incomplete")

require("cfg.flagged_set" in phase6 and "cfg.primary_erp" in phase6
        and "cfg.allclean_erp" in phase6,
        "Phase 6 two-ERP dependencies are missing")
require("EEG artifact rejection rate" in phase6,
        "Phase 6 does not report rejection rate")
require("for halfScaleUV = [20 10]" in plot_qc
        and "yLimitsUV = [-halfScaleUV halfScaleUV]" in plot_qc
        and "'YDir','reverse'" in plot_qc,
        "Single-word plots lack fixed +/-20 and +/-10 scales")
require("HC N=%d, LC N=%d" in plot_qc,
        "Every single-word panel must display both trial counts")

require("cfg.final_car_set" in sentence1,
        "Sentence analysis does not start from final-CAR continuous data")
require("sentenceEpochMs = [-200 4000]" in sentence1
        and "sentenceBaselineMs = [-200 0]" in sentence1,
        "Sentence onset epoch/baseline contract is missing")
require("nextStartItem = startItems(i+1)" in sentence1
        and "assert(isscalar(targetItems)" in sentence1,
        "Sentence target matching is not constrained to the current trial")
require("isequal(snr,behavior.snr)" in sentence1,
        "Sentence SNR order is not checked against behavior")
require("WORD_ALIGNED_DISPLAY_MS = [-2300 800]" in sentence2,
        "Sentence word-aligned display window is missing")
require("PLOT_Y_LIMITS_UV = [-20 20]" in sentence2
        and "'YDir','reverse'" in sentence2 and "N=%d" in sentence2,
        "Sentence figures lack fixed scale, negative-up, or N")
require("mean(wordAligned(:,:,allCleanMask),3,'omitnan')" in sentence2,
        "Sentence edge averaging must use omitnan")
require("isequal(LATENCY.Condition,LEDGER.Condition)" in sentence2
        and "isequal(LATENCY.SNR,LEDGER.SNR)" in sentence2,
        "Sentence metadata is not checked against the Stage-6 ledger")

for stage, suffix in enumerate(
    ("import_audit", "reference", "filter", "ica", "epoch_artifact", "average_erp"),
    start=1,
):
    text = (ROOT / f"phase0{stage}_{suffix}.m").read_text()
    require("exist(" in text and ("Partial" in text or "already complete" in text),
            f"Phase {stage} lacks overwrite protection")

require("pop_eegfiltnew" not in all_text, "Unapproved filter implementation")
require("pop_subcomp(EEG,cfg.removed_ics" not in all_text,
        "ICA removal bypasses the validated local list")
for directory in ("continuous", "ica", "epochs", "eventlists", "tables",
                  "erp", "qc", "logs"):
    require(re.search(rf"cfg\.{directory}_dir", config + refresh),
            f"Missing {directory} directory interface")

print(f"PASS: {len(MATLAB)} MATLAB files validated in {ROOT}")
print("PASS: label-resolved fixed exclusions and initial good-scalp CAR")
print("PASS: rank-controlled ICA, post-ICA interpolation, universal final CAR")
print("PASS: bit-1/bit-2 ledger, rejection rates, fixed +/-20 and +/-10 plots")
print("PASS: sentence branch starts from final-CAR continuous data")
