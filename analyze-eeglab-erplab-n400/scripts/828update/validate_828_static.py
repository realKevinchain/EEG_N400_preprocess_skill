#!/usr/bin/env python3
"""Static acceptance checks for the independent 828update MATLAB pipeline."""

from pathlib import Path
import re


ROOT = Path(__file__).resolve().parent
MATLAB = sorted(ROOT.glob("*.m"))
EXPECTED = {
    "config_828_subject_template.m",
    "config_828_01A.m",
    "config_828_01B.m",
    "refresh_828_config.m",
    "validate_828_config.m",
    "init_828_runtime.m",
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
    "plot_828_erp_qc.m",
}


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


names = {path.name for path in MATLAB}
require(EXPECTED <= names, f"Missing files: {sorted(EXPECTED - names)}")
all_text = "\n".join(path.read_text(encoding="utf-8") for path in MATLAB)
lower = all_text.lower()

require("scripts/systematic" not in lower, "Calls old systematic scripts")
require("scripts/no-ica" not in lower, "Calls old no-ICA scripts")
require("cfg.deriv_dir" not in all_text, "Uses the old derivative directory")
require("cfg.noica_root" not in all_text, "Uses the no-ICA output root")
require("nobase" not in lower, "Contains a no-baseline field or output")
require("no-baseline" not in lower, "Contains a no-baseline branch")
require("result_update" in (ROOT / "refresh_828_config.m").read_text(),
        "Missing result_update root")

phase2 = (ROOT / "phase02_reference.m").read_text()
phase3 = (ROOT / "phase03_filter.m").read_text()
phase4 = (ROOT / "phase04_ica.m").read_text()
phase5 = (ROOT / "phase05_epoch_artifact.m").read_text()
phase6 = (ROOT / "phase06_average_erp.m").read_text()
phase_s1 = (ROOT / "phaseS1_sentence_epoch.m").read_text()
phase_s2 = (ROOT / "phaseS2_sentence_word_aligned_erp.m").read_text()

require("cfg.imported_set" in phase2 and "pop_reref" in phase2,
        "Phase 2 does not rereference imported data")
require("cfg.referenced_set" in phase3 and "cfg.preica_set" in phase3,
        "Phase 3 dependency is not referenced -> pre-ICA")
require("cfg.preica_set" in phase4 and "cfg.icaclean_set" in phase4,
        "Phase 4 dependency is not pre-ICA -> ICA-clean")
require("numericalRank = rank" in phase4 and "'pca',numericalRank" in phase4,
        "Phase 4 lacks explicit numerical-rank/PCA control")
require("cfg.icaclean_set" in phase5 and "cfg.flagged_set" in phase5,
        "Phase 5 dependency is not ICA-clean -> flagged epochs")
require(phase5.count("pop_epochbin") == 1,
        "Phase 5 must create exactly one formal epoch dataset")
require("cfg.baseline_ms" in phase5 and "'none'" not in phase5,
        "Phase 5 does not enforce the locked baseline")
require("cfg.flagged_set" in phase6 and "cfg.primary_erp" in phase6
        and "cfg.allclean_erp" in phase6,
        "Phase 6 dependencies or two ERP outputs are missing")
require("cfg.interpolated_set" in phase_s1 and "pop_rmbase" in phase_s1,
        "Supplement S1 must reuse interpolated continuous data and baseline once")
require("startItems(i+1)-1" in phase_s1 and "isscalar(targetItems)" in phase_s1,
        "Supplement S1 does not constrain target matching to one sentence trial")
require("isequal(snr,behavior.snr)" in phase_s1,
        "Supplement S1 does not verify behavior SNR order")
require("WORD_ALIGNED_DISPLAY_MS = [-2300 800]" in phase_s2,
        "Supplement S2 fixed display window changed")
require("cfg.ledger_csv" in phase_s2 and "PrimaryCorrectClean" in phase_s2,
        "Supplement S2 must reuse the official Phase 6 ledger")
require("pop_rmbase" not in phase_s2,
        "Supplement S2 must not apply a second baseline")
require('plotBase+".png"' in phase_s2 and 'plotBase+".fig"' in phase_s2,
        "Supplement S2 overwrite checks must cover both PNG and FIG outputs")

for stage in range(1, 7):
    text = (ROOT / f"phase0{stage}_{['import_audit','reference','filter','ica','epoch_artifact','average_erp'][stage-1]}.m").read_text()
    require("exist(" in text and ("Partial" in text or "already complete" in text),
            f"Phase {stage} lacks overwrite protection")

for forbidden in ("pop_eegfiltnew", "pop_subcomp(EEG,cfg.removed_ics"):
    # pop_subcomp is permitted only through the validated local `removed` list.
    require(forbidden not in all_text, f"Forbidden unchecked call: {forbidden}")

config = (ROOT / "config_828_subject_template.m").read_text()
for directory in ("continuous", "ica", "epochs", "eventlists", "tables",
                  "erp", "qc", "logs"):
    require(re.search(rf"cfg\.{directory}_dir", config + (ROOT / "refresh_828_config.m").read_text()),
            f"Missing {directory} directory interface")

print(f"PASS: {len(MATLAB)} MATLAB files validated in {ROOT}")
print("PASS: independent result_update paths, six-stage dependencies, baseline-only epoching")
print("PASS: reference-before-filter, rank-controlled ICA, bit-1/bit-2 ERP workflow")
print("PASS: supplemental sentence epoch and word-aligned display contracts")
