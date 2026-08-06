#!/usr/bin/env python3
"""Static checks for the MATLAB templates when MATLAB is unavailable."""

from pathlib import Path


ROOT = Path(__file__).resolve().parent


def main() -> None:
    required = {
        "config_template.m": ["cfg.stage", "cfg.subjects", "cfg.paths.bdf", "cfg.n400.window_ms"],
        "validate_config.m": ["function validate_config", "TODO_", "pop_epochbin"],
        "run_pipeline.m": ["function results = run_pipeline", "run_preica", "run_ica_training", "run_postica_erp", "score_n400"],
    }
    for name, tokens in required.items():
        text = (ROOT / name).read_text(encoding="utf-8")
        missing = [token for token in tokens if token not in text]
        if missing:
            raise SystemExit(f"{name}: missing {missing}")
        if text.count("function ") < 1:
            raise SystemExit(f"{name}: no MATLAB function declaration")
    config = (ROOT / "config_template.m").read_text(encoding="utf-8")
    if "TODO_" not in config:
        raise SystemExit("config_template.m must retain hard-stop placeholders")
    print("Static template checks passed. MATLAB/EEGLAB runtime validation is still required.")


if __name__ == "__main__":
    main()

