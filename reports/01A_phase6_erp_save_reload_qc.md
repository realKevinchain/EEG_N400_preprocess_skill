# 01A Phase 6 ERP save/reload QC

Date: 2026-07-28  
Status: pass

Saved outputs:

- `/Users/kevinchain/Desktop/N400_project/derivatives/erp/01A/01A_m1ref_erp_primary_correct_clean.erp`
- `/Users/kevinchain/Desktop/N400_project/derivatives/erp/01A/01A_m1ref_erp_sensitivity_all_clean.erp`

Independent reload results:

| Check | Primary | Sensitivity/all-clean |
|---|---:|---:|
| Dimensions (channels × points × bins) | 67 × 250 × 10 | 67 × 250 × 10 |
| Accepted trials by bin | 8, 10, 21, 18, 28, 4, 4, 16, 23, 22 | 29, 30, 30, 29, 29, 29, 30, 30, 30, 29 |
| Maximum bindata difference | 0 uV | 0 uV |
| Maximum SEM difference | 0 uV | 0 uV |
| Times and channel labels retained | yes | yes |
| Trial-count structure retained | yes | yes |
| Data-quality structure retained | yes | yes |
| EVENTLIST retained | yes | yes |
| Inclusion rule retained in history | yes | yes |

File sizes:

- Primary: 2,079,983 bytes
- Sensitivity/all-clean: 2,103,995 bytes

The primary ERP includes behaviorally correct and EEG-clean trials. The
sensitivity ERP includes all EEG-clean trials regardless of behavioral
correctness.
