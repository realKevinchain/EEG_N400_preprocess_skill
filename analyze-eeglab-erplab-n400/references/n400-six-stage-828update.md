# N400 六阶段统一预处理指南_828update

> 技能包路径说明：仓库开发目录中的 `scripts_updata/` 在可安装技能内封装为
> `scripts/828update/`。从技能目录直接运行时，将本文命令中的
> `scripts_updata/` 替换为该技能根目录下的 `scripts/828update/`。

版本：902 / 2026-09-02（由完整01B pilot验证后锁定）

适用范围：采用 ICA 的 N400 正式预处理流程

脚本目录：`scripts_updata/`
输出根目录：`N400_project/result_update/<ID>/`

本指南是原《N400 六阶段统一预处理指南》的顺序更新版。锁定的正式处理顺序为：

```text
阶段1  导入与行为—EEG对齐
  ↓
阶段2  M1/M2审核与最终重参考
  ↓
阶段3  250 Hz；0.1 Hz高通 → 50 Hz PMnotch → 30 Hz低通
  ↓
阶段4  ICA训练、复核与去成分
  ↓
阶段5  坏道插值、EventList、分bin、分段、基线与伪迹标记
  ↓
阶段6  行为正确性、ERP平均与重载QC
```

相对原指南，本版锁定以下必要调整：

1. 最终重参考提前到正式滤波和 ICA 之前；
2. 正式滤波成为阶段3，ICA成为阶段4；
3. 坏道插值、EventList、BINLISTER和分段合并到阶段5；
4. 重参考会降低数据秩，因此 ICA 增加数值秩检查和显式 PCA 维度；
5. 取消所有 no-baseline 数据和分支，正式 epoch 必须使用 −200 至 0 ms 基线；
6. 阶段3显式加入50 Hz ERPLAB PMnotch，且必须指定 `Design='notch'`；
7. Gate D固定为阈值候选筛查、条件盲人工增删标记、`UPDATE MARKS`、单独保存复核副本，不物理删除epoch；
8. 正式ERP图统一为±20 µV、负向朝上，并在每个HC/LC图中显示两组N；
9. 阶段6之后执行独立的sentence-onset/word-aligned补充分析，但不得改写六阶段结果。

旧 `scripts/systematic/`、`scripts/no-ica/`、`derivatives/` 和 `no-ica/` 结果不属于本流程，不得作为本流程的阶段输入。

---

## 0. 总体原则

### 0.1 每位被试只编辑一个配置文件

复制：

```text
scripts_updata/config_828_subject_template.m
```

为：

```text
scripts_updata/config_828_<ID>.m
```

至少修改：

```matlab
cfg.subject = '02A';
cfg.behavior_subject = 12;  % 记录行为系统编号
```

当前行为读取器按被试 EEG 编号读取：

```text
N400_project/behavior/<ID>.csv
```

`behavior_subject`作为被试记录保留，不改变CSV文件名。

修改 `subject`、`reference_mode` 或其他配置后，配置文件末尾必须重新运行：

```matlab
run(fullfile(fileparts(mfilename('fullpath')),'refresh_828_config.m'));
```

仅在审计已完成的01B pilot时运行：

```matlab
run('scripts_updata/config_828_01B.m')
```

新被试必须从 `config_828_subject_template.m` 建立配置并重新完成Gate A–D；不得复制01B的T7/T8、IC或坏epoch编号。

### 0.2 每次运行阶段脚本前重新加载配置

标准形式：

```matlab
clear; close all; clc
run('scripts_updata/config_828_02A.m')
run('scripts_updata/phase01_import_audit.m')
```

配置中的人工决定发生变化后，必须重新运行配置，确保参考标签、ICA通道和文件名同步刷新。

### 0.3 禁止覆盖和静默删除

- 所有正式输出写入 `result_update/<ID>/`；
- 不向旧 `derivatives/` 或 `no-ica/` 写入结果；
- SET和FDT均进行防覆盖检查；
- 发现既有最终输出时，脚本报告已经完成并停止；
- 发现不完整的部分输出时，脚本停止，不能自动覆盖或删除；
- 配套复核工具保持只读；Gate D也允许用户在ERPLAB界面对单独复核副本更新标记，但不得点击 `REJECT` 或物理删除epoch；
- 阶段5只标记坏epoch，不物理删除trial。

如果某阶段因MATLAB退出或磁盘问题只留下部分输出，应先记录错误、核对已生成文件，再把不完整结果整体移到带日期的归档目录。不得直接覆盖旧文件。

### 0.4 输出目录

第一次运行阶段脚本时自动创建：

```text
N400_project/result_update/<ID>/
├── continuous/     阶段2、3、5连续数据
├── ica/            ICA训练副本、解、权重和ICA-clean数据
├── epochs/         唯一一套基线校正epoch及flagged数据
├── eventlists/     raw和binned EventList
├── tables/         trial ledger、bin汇总和人工决定表
├── erp/            primary/all-clean ERP、PNG和FIG
├── qc/             通道、参考、滤波、ICA和epoch审核表
├── logs/           各阶段不可覆盖的PASS日志
└── sentence_epochs/ 阶段6后独立的sentence补充分析，不是六阶段输入
```

所有正式派生文件统一包含：

```text
<ID>_828update_<reference-tag>
```

参考标签为：

| 参考模式 | 标签 |
|---|---|
| 平均M1/M2 | `mastref` |
| 仅M1 | `m1ref` |
| 仅M2 | `m2ref` |

### 0.5 四个人工门

| 人工门 | 所在阶段 | 决定内容 |
|---|---:|---|
| Gate A | 2 | M1/M2质量、坏头皮通道和参考模式 |
| Gate B | 4 | ±100 µV排除训练片段是否合理 |
| Gate C | 4 | 最终删除的IC编号，可确认删除零个 |
| Gate D | 5 | 条件盲的统一坏epoch列表 |

阶段1还要求导入GUI检查，阶段3要求滤波前后检查，阶段6要求ERP人工QC，但这三处不通过配置状态解锁数据处理。

---

## 1. 六阶段总览

| 阶段 | 主脚本 | 必须的人工操作 | 主要输出 |
|---|---|---|---|
| 1 导入与审计 | `phase01_import_audit.m` | 原始导入、通道位置和连续波形检查 | 通道QC、异常时间窗QC、PASS日志 |
| 2 最终重参考 | `phase02_reference.m` | Gate A：M1/M2、坏道和参考模式 | 未滤波、已重参考连续SET |
| 3 正式滤波 | `phase03_filter.m` | 比较滤波前后波形与频谱 | 0.1 HP、50 PMnotch、30 LP、250 Hz pre-ICA SET |
| 4 ICA | `phase04_ica.m` | Gate B训练片段；Gate C人工IC复核 | 训练、ICA解、权重和ICA-clean SET |
| 5 分段与伪迹 | `phase05_epoch_artifact.m` | Gate D：条件盲epoch复核 | binned连续数据、基线epoch和bit-1数据 |
| 6 行为与ERP | `phase06_average_erp.m` | ERP波形、试次数和数据质量检查 | ledger、bin表、两套ERP和ROI图 |

---

## 2. 阶段1：导入与行为—EEG对齐

### 2.1 输入

```text
N400_project/input_set/<ID>_imported.set/.fdt
N400_project/behavior/<ID>.csv
```

原始SET和行为CSV只读使用，不复制到 `result_update/`。

### 2.2 导入GUI要求

1. 使用与01A相同的方法导入原始EEG；
2. 保留67个通道：
   - 1–64：EEG，包含M1/M2；
   - 65：VEOG；
   - 66：HEOG；
   - 67：TRIGGER；
3. 导入已核准通道位置；
4. 确认67个标签唯一，64个EEG通道均有有限XYZ坐标；
5. 查看连续波形、触发、50 Hz峰、平线、饱和、突跳和明显坏道；
6. 保存为 `input_set/<ID>_imported.set/.fdt`。

### 2.3 命令

```matlab
clear; close all; clc
run('scripts_updata/config_828_<ID>.m')
run('scripts_updata/phase01_import_audit.m')
```

### 2.4 自动审计

脚本验证：

- 67通道及锁定标签位置；
- 64个EEG通道的坐标；
- 所有EEG数值有限；
- 目标码111–115、121–125共300个；
- 行为HC/LC × SNR与EEG目标码逐试次完全一致；
- 通道SD、范围、中心化最大绝对值、平线比例和稳健SD异常；
- 可用时计算50 Hz线噪比；
- 按1秒窗口生成极端振幅、P2P和平线时段候选。

这些指标只生成审核候选，不自动决定坏道或删除时间段。

### 2.5 输出

```text
qc/<ID>_828update_<ref>_phase01_channel_qc.csv
qc/<ID>_828update_<ref>_phase01_segment_qc.csv
logs/<ID>_828update_<ref>_phase01_pass.txt
```

### 2.6 通过标准

- 67通道；
- 300个目标事件；
- 300行行为数据；
- 行为与EEG逐试次完全一致；
- 没有无法解释的事件错位或大段数据缺失。

失败时停止。不得通过重新排序行为或事件来“修复”不一致。

---

## 3. 阶段2：M1/M2审核与最终重参考

本版的最终参考发生在正式滤波和ICA之前。

### 3.1 输入

```text
input_set/<ID>_imported.set/.fdt
```

### 3.2 第一次运行：生成Gate A材料

```matlab
clear; close all; clc
run('scripts_updata/config_828_<ID>.m')
run('scripts_updata/phase02_reference.m')
```

首次运行生成参考审核表，然后正常暂停：

```text
qc/<ID>_828update_<ref>_phase02_reference_gate.csv
```

审核表固定包含M1、M2，并加入：

- 配置中的 `bad_channel_candidates`；
- 阶段1自动生成的坏道候选。

### 3.3 Gate A只读审核

```matlab
run('scripts_updata/config_828_<ID>.m')
run('scripts_updata/review_phase02_reference_gate.m')
```

工具显示M1、M2、全部候选通道以及FZ、CZ、CPZ、PZ正常对照。

如果控制台显示：

```text
Removing 59 channel(s)...
```

这只表示审核副本保留8个显示通道，不会删除或修改原始数据。

审核时重点查看：

- M1/M2是否平线、饱和、突跳或间歇污染；
- 两侧乳突是否全程稳定；
- 候选头皮通道是否确实为全程坏道；
- 候选通道与正常对照的差异是否持续存在；
- 不能只凭单个SD或Range数值决定坏道。

### 3.4 配置决定

M1、M2均合格时：

```matlab
cfg.bad_channels = [ ... ];
cfg.reference_mode = 'average_mastoid';
cfg.reference_exception_reason = '';
cfg.reference_review_complete = true;
```

M2异常、使用M1时：

```matlab
cfg.reference_mode = 'm1';
cfg.reference_exception_reason = 'M2: documented participant-specific abnormality';
cfg.reference_review_complete = true;
```

M1异常、使用M2时：

```matlab
cfg.reference_mode = 'm2';
cfg.reference_exception_reason = 'M1: documented participant-specific abnormality';
cfg.reference_review_complete = true;
```

规则：

- `bad_channels`只能填写坏头皮通道；
- M1、M2、VEOG、HEOG、TRIGGER不得填入 `bad_channels`；
- 此阶段只登记坏头皮通道，不插值；
- 平均乳突优先，单侧参考仅作为有理由的逐被试例外；
- 两侧乳突均异常时停止，不能自动选择参考。

### 3.5 第二次运行：应用重参考

保存配置后重新运行：

```matlab
clear; close all; clc
run('scripts_updata/config_828_<ID>.m')
run('scripts_updata/phase02_reference.m')
```

平均乳突模式：

\[
EEG' = EEG - \frac{M1+M2}{2}
\]

仅对1–64 EEG通道执行。VEOG、HEOG、TRIGGER逐点保持不变。

### 3.6 自动验证

- 通道数、通道标签和数据维度不变；
- 事件结构不变；
- EOG和TRIGGER逐点完全不变；
- 平均乳突模式下，重参考后M1/M2逐点平均小于 `1e-4 µV`；
- 单侧模式下，被选参考通道逐点值小于 `1e-4 µV`；
- 保存后重载的数据和事件完全一致。

### 3.7 输出

```text
continuous/<ID>_828update_<ref>_continuous_unfiltered.set/.fdt
logs/<ID>_828update_<ref>_phase02_pass.txt
```

---

## 4. 阶段3：250 Hz、0.1 Hz高通、50 Hz PMnotch、30 Hz低通

### 4.1 输入

```text
continuous/<ID>_828update_<ref>_continuous_unfiltered.set/.fdt
```

### 4.2 锁定参数

| 参数 | 设置 |
|---|---:|
| 正式采样率 | 250 Hz |
| 高通 | 0.1 Hz |
| 高通有效阶数 | 2 |
| 线噪notch | 50 Hz ERPLAB PMnotch |
| notch设计 | 必须为 `Design='notch'` |
| 低通 | 30 Hz |
| 低通有效阶数 | 8 |
| 设计 | 双向非因果Butterworth |
| 滤波通道 | EEG 1–64及EOG 65–66 |
| TRIGGER | 重采样，但不滤波 |

处理顺序固定为：

```text
重采样至250 Hz
→ EEG/EOG 0.1 Hz高通
→ EEG/EOG 50 Hz PMnotch（Design='notch'）
→ EEG/EOG 30 Hz低通
```

50 Hz notch在最终0.1–30 Hz数据中科学上是冗余的，但902按用户要求显式保留。01B定点诊断在50.00 Hz测得56.7 dB衰减。若遗漏 `Design='notch'`，ERPLAB PMnotch可能只给出非致命警告并原样传递数据，因此脚本和静态检查均锁定该参数。

此阶段不再次参考、不插值、不分段。

### 4.3 命令

```matlab
clear; close all; clc
run('scripts_updata/config_828_<ID>.m')
run('scripts_updata/phase03_filter.m')
```

### 4.4 自动验证

- 输出采样率为250 Hz；
- 300个目标事件仍然存在；
- 通道标签不变；
- 事件延迟在滤波步骤中不改变；
- TRIGGER与“重采样后、滤波前”的副本逐点完全一致；
- 参考残差保持在容许范围；
- 不产生NaN或Inf；新平线由随后人工QC确认；
- 保存后重载数据完全一致。

### 4.5 人工QC

对照阶段2和阶段3的相同时间段，检查：

- CZ、CPZ、PZ；
- M1、M2；
- VEOG、HEOG；
- 滤波前后频谱；
- 数据开头、结尾和大振幅异常附近；
- 是否出现振铃、边缘异常或新的平线。

### 4.6 输出

```text
continuous/<ID>_828update_<ref>_preica_01_30_250.set/.fdt
qc/<ID>_828update_<ref>_phase03_filter_qc.csv
logs/<ID>_828update_<ref>_phase03_pass.txt
```

---

## 5. 阶段4：ICA训练、复核与去成分

阶段4需要多次运行，并在Gate B和Gate C主动停止。

### 5.1 输入

```text
continuous/<ID>_828update_<ref>_preica_01_30_250.set/.fdt
```

### 5.2 ICA通道规则

ICA候选通道从1–64 EEG开始：

```text
1–64 EEG
− 阶段2确认的坏头皮通道
− 单侧参考模式下被置零的参考通道
```

- VEOG、HEOG、TRIGGER不进入ICA；
- 坏头皮通道不进入ICA，但仍保留在正式数据中，阶段5统一插值；
- 平均乳突模式保留M1和M2，并通过秩控制处理二者的线性约束；
- 单侧参考模式自动排除被置零的乳突通道。

### 5.3 第一次运行：训练副本

配置保持：

```matlab
cfg.run_ica = false;
cfg.ica_review_complete = false;
cfg.removed_ics = [];
```

运行：

```matlab
clear; close all; clc
run('scripts_updata/config_828_<ID>.m')
run('scripts_updata/phase04_ica.m')
```

训练副本参数：

- 从已重参考的0.1–30 Hz、250 Hz正式数据派生；
- 对ICA通道另加1 Hz高通，有效阶数8；
- 重采样至100 Hz；
- 只保留每试次开始至对应目标词后1秒；
- 对每个完整任务片段应用−100至+100 µV规则；
- 任一ICA通道越界时，整个任务片段只从训练副本排除；
- 正式250 Hz数据不删除trial、不改写阈值标记。

### 5.4 重参考后的秩控制

脚本在阈值筛选后的训练数据上计算数值秩。

平均M1/M2参考时，M1和M2满足线性约束，预期ICA秩为：

```text
ICA通道数 − 1
```

单侧参考时，置零参考通道已从ICA通道排除，预期秩为剩余ICA通道数。

如果实际秩低于预期，脚本停止，要求检查：

- 平线通道；
- 重复通道；
- 错误的坏道清单；
- 错误的参考方式；
- 其他未记录的秩损失。

当实际秩小于ICA通道数时，extended Infomax使用显式：

```matlab
'pca', numericalRank
```

这样避免重参考后产生不稳定或无意义的额外IC。

### 5.5 Gate B：±100 µV训练片段复核

首次运行生成：

```text
ica/<ID>_828update_<ref>_icatrain_1_30_100.set/.fdt
qc/<ID>_828update_<ref>_phase04_threshold_qc.csv
```

运行只读审核工具：

```matlab
run('scripts_updata/config_828_<ID>.m')
run('scripts_updata/review_phase04_threshold_gate.m')
```

工具：

- 重新计算并核对全部阈值决定；
- 打开全部被排除片段；
- 打开最多12个均匀抽取的保留片段；
- 打印排除trial、保留抽样和数值秩；
- 不标记、不删除、不保存审核数据。

确认：

- 开始事件与目标事件正确配对；
- 没有大批正常片段被误排；
- 所有明显越界片段都被识别；
- 剩余训练样本量合理；
- 数值秩符合参考方式的预期。

通过后设置：

```matlab
cfg.run_ica = true;
```

### 5.6 第二次运行：训练ICA并转移权重

```matlab
clear; close all; clc
run('scripts_updata/config_828_<ID>.m')
run('scripts_updata/phase04_ica.m')
```

脚本：

1. 使用固定随机种子运行extended Infomax；
2. 必要时使用显式PCA秩；
3. 保存训练副本上的ICA解；
4. 将权重转移回同一参考方式的完整0.1–30 Hz、250 Hz正式数据；
5. 停在Gate C。

权重不得转移到参考方式不同、通道集合不同或正式滤波参数不同的数据。

### 5.7 Gate C：IC人工复核

载入：

```text
ica/<ID>_828update_<ref>_preica_icaweights.set/.fdt
```

人工复核：

1. 运行ICLabel，但只作为决策辅助；
2. 同时查看头皮图、频谱、成分激活、连续数据和VEOG/HEOG关系；
3. 只删除有多重证据支持的眼动、肌电、心电或明显非脑成分；
4. 不得直接复制其他被试的IC编号；
5. 记录最终IC编号及证据截图。

配置示例：

```matlab
cfg.removed_ics = [1 3 8];  % 示例，不得照抄
cfg.ica_review_complete = true;
```

如果人工确认不需要删除任何IC，也必须明确写：

```matlab
cfg.removed_ics = [];
cfg.ica_review_complete = true;
```

### 5.8 第三次运行：生成ICA-clean数据

```matlab
clear; close all; clc
run('scripts_updata/config_828_<ID>.m')
run('scripts_updata/phase04_ica.m')
```

### 5.9 输出

```text
ica/<ID>_828update_<ref>_icatrain_1_30_100.set/.fdt
ica/<ID>_828update_<ref>_icatrain_ica.set/.fdt
ica/<ID>_828update_<ref>_preica_icaweights.set/.fdt
ica/<ID>_828update_<ref>_preica_icaclean.set/.fdt
qc/<ID>_828update_<ref>_phase04_threshold_qc.csv
logs/<ID>_828update_<ref>_phase04_pass.txt
```

第三次运行后应对照删除前后波形，确认没有过度削弱神经信号。

---

## 6. 阶段5：坏道插值、EventList、分bin、分段与伪迹

### 6.1 输入

```text
ica/<ID>_828update_<ref>_preica_icaclean.set/.fdt
events/BDF_target_HC_LC_SNR_alltrials.txt
```

### 6.2 第一次运行：建立唯一正式epoch

配置保持：

```matlab
cfg.artifact_review_complete = false;
cfg.artifact_bad_epochs = [];
```

运行：

```matlab
clear; close all; clc
run('scripts_updata/config_828_<ID>.m')
run('scripts_updata/phase05_epoch_artifact.m')
```

脚本依次执行：

```text
坏头皮通道球面插值
→ 清除已失效ICA矩阵并保留ICA审核元数据
→ 建立EventList
→ BINLISTER建立10个目标bin
→ 提取目标词epoch
→ −200至0 ms基线校正
→ 输出epoch审核QC
→ Gate D暂停
```

### 6.3 坏道插值规则

- 只插值阶段2已确认的 `bad_channels`；
- 使用球面插值；
- 不插值M1、M2、VEOG、HEOG或TRIGGER；
- 不在此阶段重新决定坏道；
- 插值发生在ICA清理之后；
- 插值后不再次重参考；
- 插值后ICA矩阵失效，因此清空ICA矩阵，但保留训练秩、训练参数、删除IC编号和人工审核状态。

### 6.4 EventList与bin

建立10个目标词bin：

```text
HC：−4、−2、+4、+6、quiet
LC：−4、−2、+4、+6、quiet
```

锁定要求：

- 每bin30个目标事件；
- 共300个目标事件；
- 98/99不得进入任何目标bin；
- 一个目标trial只能属于一个正式bin。

### 6.5 epoch和基线

名义epoch窗口：

```text
−200至800 ms
```

250 Hz下实际存储采样点通常为：

```text
−200至796 ms
```

正式基线固定为：

```text
−200至0 ms
```

脚本验证所有EEG通道基线均值接近0。

本流程只生成这一套基线校正epoch。不得创建、补充或引用任何未做基线校正的正式epoch。

### 6.6 Gate D：条件盲epoch复核

第一次运行后执行：

```matlab
run('scripts_updata/config_828_<ID>.m')
run('scripts_updata/review_phase05_artifact_gate.m')
```

正式的基线epoch文件保持不变。配套审核工具：

- 合并显示全部300个epoch；
- 隐藏条件事件标签；
- 只显示头皮通道，排除M1、M2和辅助通道；
- 不修改或保存数据。

如使用ERPLAB GUI，固定流程为：

1. `Simple Voltage Threshold`只生成候选，不是最终拒绝决定；
2. 合并条件后逐个检查全部epoch，人工增加或取消标记；
3. 点击 `UPDATE MARKS`，不得点击 `REJECT`；
4. 另存为 `<ID>_gateD_manual_review.set`，不得覆盖正式epoch；
5. 审计 `EEG.reject.rejmanual`、`rejmanualE`、`rejthresh`、其他reject字段和event flag；
6. 字段不一致时与用户核对，不能自动求并集；最终只把确认后的统一epoch编号写入配置。

人工检查：

- 异常头皮幅度；
- 移动窗口P2P；
- 突发跳变；
- 平线；
- 持续漂移；
- ICA后仍残留在头皮上的眼动、肌电或其他伪迹；
- 必要时返回连续数据核对异常来源。

EOG振幅本身不是自动删除trial的唯一依据，应判断ICA后是否仍有头皮残余。

把最终统一坏epoch列表写回：

```matlab
cfg.artifact_bad_epochs = [ ... ];
cfg.artifact_review_complete = true;
```

### 6.7 第二次运行：写入bit 1

```matlab
clear; close all; clc
run('scripts_updata/config_828_<ID>.m')
run('scripts_updata/phase05_epoch_artifact.m')
```

bit 1同步写入：

- `EEG.reject.rejmanual`；
- `EEG.reject.rejmanualE`；
- `EEG.epoch.eventflag`；
- `EEG.event.flag`；
- `EVENTLIST.eventinfo.flag`。

所有300个trial物理保留。bit 1只表示人工确认的EEG伪迹。

### 6.8 自动验证

- 67通道；
- 300个epoch；
- 10个bin，每bin30个；
- epoch窗口和−200至0 ms基线正确；
- bit 1在reject、epoch、event和EVENTLIST中一致；
- 保存后重载trial数和flag一致；
- 插值通道数据有限；
- 没有删除trial。

### 6.9 输出

```text
continuous/<ID>_828update_<ref>_postica_interpolated.set/.fdt
continuous/<ID>_828update_<ref>_postica_bins_continuous.set/.fdt
eventlists/<ID>_828update_<ref>_eventlist_raw.txt
eventlists/<ID>_828update_<ref>_eventlist_binned.txt
epochs/<ID>_828update_<ref>_target_epochs_baseline_pre200.set/.fdt
epochs/<ID>_828update_<ref>_target_epochs_baseline_artifactflagged.set/.fdt
qc/<ID>_828update_<ref>_phase05_epoch_qc.csv
tables/<ID>_828update_<ref>_artifact_decisions.csv
logs/<ID>_828update_<ref>_phase05_pass.txt
```

---

## 7. 阶段6：行为正确性、ERP平均与重载QC

### 7.1 输入

```text
epochs/<ID>_828update_<ref>_target_epochs_baseline_artifactflagged.set/.fdt
behavior/<ID>.csv
```

### 7.2 命令

```matlab
clear; close all; clc
run('scripts_updata/config_828_<ID>.m')
run('scripts_updata/phase06_average_erp.m')
```

### 7.3 行为连接和flag规则

脚本按原始trial编号逐试次连接行为和EEG，并再次验证目标码与bin。

| Bit | 含义 |
|---:|---|
| 1 | 人工确认的EEG伪迹 |
| 2 | 行为错误 |

bit 2在阶段6内存副本中写入，不反向修改阶段5的正式SET。

### 7.4 两套ERP

Primary ERP：

```text
EEG clean AND 行为正确
```

All-clean ERP：

```text
EEG clean
```

all-clean不要求行为正确，用于检查行为正确性筛选对波形的影响，并继续作为统一最终形态图的数据来源。

### 7.5 trial ledger与bin汇总

trial ledger至少包含：

- 被试；
- EEG epoch编号；
- 条件和SNR；
- 行为正确性；
- 预期和实际目标码；
- bin；
- bit 1伪迹；
- bit 2行为错误；
- all-clean接受状态；
- primary接受状态。

bin汇总包含：

- 每bin原始trial数；
- EEG伪迹数；
- 行为错误数；
- all-clean接受数；
- primary接受数。

条件或bin试次数过少时，不得据此解释单被试条件差异。

### 7.6 ERP平均与保存后重载

两套ERP均使用：

- `Criterion = good`；
- 排除boundary；
- 计算SEM；
- 保存ERPLAB dataquality结构。

保存后立即重新载入并验证：

- `bindata`；
- `binerror`；
- `dataquality`；
- 时间轴；
- 通道和bin结构；
- 每bin接受试次数；
- 接受总数与ledger完全一致。

任何重载差异都必须停止，不能输出PASS日志。

### 7.7 ERP图

自动生成primary和all-clean两套CZ/中央顶区ROI图：

- 上排：CZ；
- 下排：CZ/CP1/CPZ/CP2/P3/PZ/P4平均ROI；
- HC：蓝色；
- LC：红色；
- LC−HC：黑色；
- 差异方向永久锁定为LC−HC；
- 负向朝上；
- 每个panel固定使用 `[-20 20]` µV，不得按panel自动缩放；
- 每个HC/LC panel都显示 `HC N=...` 与 `LC N=...`；
- 五列依次为−4、−2、+4、+6和quiet。

在LC−HC规则下，负值表示LC比HC更负。

只有用户明确要求时才可另做 `[-10 10]` µV对比图；必须使用独立后缀，不能覆盖±20 µV正式图。若任何波形超界，则明确标为探索性展示而非正式图。01B的primary −4 dB图在±10 µV下发生裁剪，因此正式标准保持±20 µV。

### 7.8 人工ERP QC

检查：

1. 每bin接受试次数；
2. 0 ms前基线；
3. 300–500 ms附近N400形态；
4. 晚期漂移；
5. 单条件异常；
6. primary与all-clean差异；
7. CZ和中央顶区ROI的一致性。

正式N400数值窗口和统计模型必须在组水平分析前锁定，不能依据单个被试波形临时选择。

### 7.9 输出

```text
tables/<ID>_828update_<ref>_trial_ledger.csv
tables/<ID>_828update_<ref>_bin_summary.csv
erp/<ID>_828update_<ref>_erp_primary_correct_clean.erp
erp/<ID>_828update_<ref>_erp_all_clean.erp
erp/<ID>_828update_<ref>_erp_primary_correct_clean_cz_roi.png/.fig
erp/<ID>_828update_<ref>_erp_all_clean_cz_roi.png/.fig
logs/<ID>_828update_<ref>_phase06_pass.txt
```

### 7.10 阶段6后的sentence补充分析

依次运行：

```matlab
run('scripts_updata/phaseS1_sentence_epoch.m')
run('scripts_updata/phaseS2_sentence_word_aligned_erp.m')
```

该分支是902在本研究中的默认后续交付，但始终独立于六阶段正式结果：

- S1以sentence onset建立 `[-200 4000]` ms epoch，并相对sentence onset做 `[-200 0]` ms基线；
- S2只平移显示时间轴至target word，不重新基线；
- 固定显示 `[-2300 800]` ms，边缘用 `omitnan` 处理不同target latency造成的覆盖差异；
- 精确复用阶段6 trial ledger的artifact/behavior决定；
- 输出2种模式 × 2个site × 5个SNR，即20 PNG和20 FIG；
- 所有图固定±20 µV、负向朝上，并显示HC与LC的N；
- 全部文件写入 `sentence_epochs/`，不得修改phase01–06输出。

完整说明见 `sentence-onset-word-aligned-supplemental.md`。

---

## 8. GUI门与配置状态速查

### Gate A：参考

```matlab
cfg.bad_channels = [ ... ];
cfg.reference_mode = 'average_mastoid';
cfg.reference_exception_reason = '';
cfg.reference_review_complete = true;
```

### Gate B：ICA训练片段

```matlab
cfg.run_ica = true;
```

### Gate C：IC复核

```matlab
cfg.removed_ics = [ ... ];
cfg.ica_review_complete = true;
```

### Gate D：epoch伪迹

```matlab
cfg.artifact_bad_epochs = [ ... ];
cfg.artifact_review_complete = true;
```

人工门状态只能在完成对应复核后设置为 `true`。

---

## 9. 失败处理

### 9.1 EEGLAB插件联网提示

下列提示不影响本地处理：

```text
Cannot connect to the Internet to retrieve statistics for extensions
```

只要EEGLAB、ERPLAB及所需函数已成功加载即可继续。

### 9.2 `Removing ... channel(s)`

出现在只读审核工具中时，表示从临时显示副本中隐藏无关通道。原始SET和正式派生不受影响。

### 9.3 参考残差失败

停止并检查：

- M1/M2索引和标签；
- `reference_mode`；
- 单侧参考方向是否写反；
- 辅助通道是否错误参与参考；
- 输入是否已经被其他流程重参考。

### 9.4 ICA秩失败

停止并检查平线、重复通道、坏道清单、参考模式和训练通道。不得通过随意降低PCA维度绕过错误。

### 9.5 EventList或bin失败

停止并检查：

- BDF版本；
- 目标事件码；
- 98/99事件；
- 每bin是否为30；
- 行为与EEG的逐试次顺序。

不得手动重新排序trial或将错误事件强行放入bin。

### 9.6 部分输出冲突

脚本报告 `Partial ... output exists` 时：

1. 不覆盖、不删除；
2. 保存MATLAB报错和控制台输出；
3. 核对该阶段已经生成的SET、FDT、CSV和日志；
4. 确认属于失败运行后，将不完整结果整体移到带日期的归档目录；
5. 从该阶段第一个输入重新运行。

---

## 10. 静态验证

在终端运行：

```bash
python3 scripts_updata/validate_828_static.py
```

验证内容包括：

- 六阶段文件完整；
- 不调用旧 `scripts/systematic/` 或 `scripts/no-ica/`；
- 不使用旧输出目录；
- 阶段依赖顺序正确；
- 阶段2先参考、阶段3再滤波；
- 阶段3含显式50 Hz `PMnotch` 与 `Design='notch'`，且TRIGGER不滤波；
- ICA包含数值秩和PCA控制；
- 阶段5只调用一次 `pop_epochbin`；
- 强制使用 `baseline_ms = [-200 0]`；
- bit 1/bit 2及两套ERP接口存在；
- 正式ERP和sentence图固定±20 µV、负向朝上并显示N；
- sentence分支固定窗口、复用ledger并完整保护20 PNG + 20 FIG；
- 各阶段具有防覆盖逻辑。

静态验证通过不等于真实被试运行通过。真实PASS必须来自用户MATLAB会话中的阶段日志和人工门记录。

---

## 11. 01B pilot验证状态

截至2026-09-02，01B已完成阶段1–6、Gate A–D、ERP保存重载QC和sentence补充分析。阶段1–6均有真实运行PASS日志；sentence trial log与正式ledger逐试次一致；20 PNG + 20 FIG均通过固定窗口、固定±20 µV、负向朝上及双N标签检查。

01B个体决定包括坏道T7/T8 `[26 34]`、删除IC `[1 4 8 20 31 41 52 56 61]`、坏epoch `[49 52 66 70 98 118 194 203 246 253 292]`。这些编号只用于审计，绝不是下一位被试的默认值。完整运行事实见 `01B-validated-pilot-902.md`。

---

## 12. 每位被试最小交付清单

- 被试 `config_828_<ID>.m`；
- 阶段1通道QC、异常时间窗QC和PASS日志；
- Gate A参考决定、坏道清单和单侧例外理由（如有）；
- 阶段2重参考连续数据和PASS日志；
- 阶段3滤波QC、pre-ICA数据和PASS日志；
- Gate B阈值排除清单、保留抽样审核记录和ICA秩；
- Gate C删除IC编号及证据截图；
- 阶段4训练、权重、ICA-clean数据和PASS日志；
- raw/binned EventList和10×30 bin核对；
- 唯一一套−200至0 ms基线校正epoch；
- Gate D条件盲坏epoch清单；
- Gate D单独复核副本、reject字段审计和用户确认记录；
- bit-1 artifact-flagged SET和阶段5 PASS日志；
- trial ledger和bin summary；
- primary和all-clean ERP；
- ERP保存后重载QC；
- primary和all-clean CZ/中央顶区ROI PNG与FIG；
- 两套正式ERP图固定±20 µV、负向朝上并显示HC/LC N；
- 阶段6 PASS日志；
- 最终人工ERP QC记录。
- sentence S1/S2日志、trial inclusion记录、bin summary、20 PNG和20 FIG。

只有上述材料齐全，且所有人工门和自动验证均通过，才视为该被试完成828update六阶段预处理。
