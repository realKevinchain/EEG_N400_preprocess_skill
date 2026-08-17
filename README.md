# EEG N400 Preprocess Pipeline

## 📌 项目简介

本项目是一套用于**语言理解与语义加工研究中 N400 事件相关电位（ERP）数据**的标准预处理工作流。通过结合 **MATLAB 自动化脚本** 与 **EEGLAB/ERPLAB GUI 标准化人工审查**，本项目旨在建立一套高可复现性、高透明度且具备严格质量控制的 6 阶段 EEG 预处理体系。

本项目适用于实验室内部 01A 试运行阶段之后的所有被试标准化批量处理。


## 💻 环境与依赖要求

* **主程序**：MATLAB R2020b 或更新版本
* **必备工具箱/插件**：
  * EEGLAB (最新稳定版)
  * ERPLAB Plugin
  * ICLabel Plugin (用于 ICA 辅助判定)
 
# N400 六阶段统一预处理指南

版本：2026-08-16
用途：01A 之后所有被试的标准化处理  
原则：阶段化派生、禁止覆盖、脚本负责可重复操作、GUI 只负责必须的人为判断。

## 0. 每位被试只改一个配置文件

复制：

`scripts/systematic/config_subject_template.m`

为：

`scripts/systematic/config_02A.m`

至少修改：

```matlab
cfg.subject = '02A';
cfg.behavior_subject = 12;   % 按行为文件实际编号
```

随后按顺序运行：

```matlab
clear; close all; clc
run('scripts/systematic/config_02A.m')
run('scripts/systematic/phase01_import_audit.m')
```

进入下一阶段前都重新载入同一个配置。任何脚本提示输出已经存在时，先核对文件，不要覆盖或删除旧派生文件。

## 六阶段总览

| 阶段 | 命令行脚本 | 必须的 GUI 操作 | 阶段输出 |
|---|---|---|---|
| 1 导入与审计 | `phase01_import_audit.m` | 原始数据导入、通道位置和连续波形检查 | `<ID>_imported.set/.fdt` |
| 2 pre-ICA | `phase02_preica.m` | 滤波前后波形、频谱、坏道检查 | `<ID>_preica.set/.fdt` |
| 3 ICA | `phase03_ica.m`，分三次运行 | ±100 训练片段复核；ICLabel 辅助的人工 IC 复核 | ICA 训练、权重和 `<ID>_preica_icaclean.set/.fdt` |
| 4 参考与事件 | `phase04_reference_events.m` | M1/M2 质量、EventList/BINLISTER 序列与计数检查 | 最终参考连续数据、binned 连续数据和 `events/eventlists/<ID>/` |
| 5 分段与伪迹 | `phase05_epoch_artifact.m`，分两次运行 | 条件盲的 epoch 人工复核 | 基线/无基线 epoch；bit-1 伪迹标记数据 |
| 6 行为与 ERP | `phase06_average_erp.m` | ERP 波形、试次数和数据质量检查 | `derivatives/tables/<ID>/` ledger 和 `derivatives/erp/<ID>/` ERP |

## 阶段 1：导入与行为—EEG 对齐

### GUI

1. 用与 01A 相同的导入方法读取原始 EEG。
2. 保留 67 个通道：1–64 EEG（含 M1/M2）、65 VEOG、66 HEOG、67 TRIGGER。
3. 导入已核准的通道位置；确认 67 个标签唯一，64 个 EEG 通道有坐标。
4. 检查连续波形、触发脉冲、50 Hz 峰、平线、饱和和明显坏道。
5. 保存为 `input_set/<ID>_imported.set/.fdt`。

### 命令行

```matlab
run('scripts/systematic/config_02A.m')
run('scripts/systematic/phase01_import_audit.m')
```

通过标准：67 通道；300 个目标事件；行为的 HC/LC × SNR 顺序与 EEG 目标码逐试次完全一致。失败时停止，不能靠重新排序“修好”。

## 阶段 2：正式分析滤波与 pre-ICA 数据

### 命令行

```matlab
run('scripts/systematic/config_02A.m')
run('scripts/systematic/phase02_preica.m')
```

锁定参数：

- 重采样至 250 Hz；
- EEG+EOG 使用 0.1 Hz 高通、有效阶数 2；
- EEG+EOG 使用 30 Hz 低通、有效阶数 8；
- 双向非因果 Butterworth；
- TRIGGER 不滤波；
- 暂不做最终参考。

### GUI

比较导入数据和 pre-ICA 数据的相同时间段：

- CZ、CPZ、PZ、M1、M2、VEOG、HEOG 波形连续；
- 无明显滤波振铃、边缘异常或新平线；
- 查看频谱和坏道，但坏道处理必须逐被试记录，不能静默删除。

## 阶段 3：ICA 训练、复核与去成分

ICA 训练规则从 02A 起锁定加入 **simple voltage threshold = −100 至 +100 µV**。01A 已完成的 ICA 不追溯重跑。

### 第一次运行：制作训练副本

配置保持：

```matlab
cfg.run_ica = false;
cfg.removed_ics = [];
```

运行：

```matlab
run('scripts/systematic/config_02A.m')
run('scripts/systematic/phase03_ica.m')
```

训练副本参数：

- 从锁定的 0.1–30 Hz pre-ICA 数据派生；
- 另加 1 Hz 高通（有效阶数 8），重采样至 100 Hz；
- 仅保留每试次开始至目标词后 1 s；
- ICA 只使用通道 1–64；VEOG、HEOG、TRIGGER 不进入 ICA；
- 对每个完整保留任务片段的 64 个 ICA 通道应用 ±100 µV；
- 任何一个样本越界，该完整任务片段只从 ICA 训练副本排除；
- 正式 250 Hz 分析数据不被删除、不被阈值改写。

### GUI 停止点 A：阈值复核

脚本会打印排除片段编号、数量和保留样本数。运行 ICA 前必须：

```matlab
run('scripts/systematic/config_02A.m')
run('scripts/systematic/review_phase03_threshold_gate.m')
```

复核脚本只读重建相同的 1 Hz、100 Hz 训练片段，打开全部排除片段和
12 个均匀抽取的保留片段；不得在复核窗口标记或删除数据。

1. 查看所有被 ±100 µV 排除的片段；
2. 抽查保留片段；
3. 确认没有事件配对错误、大片正常数据被误排或训练数据不足；
4. 在被试记录中保存排除数量和编号。

确认后修改：

```matlab
cfg.run_ica = true;
```

再次运行 Phase 3。脚本使用固定随机种子运行 extended Infomax，并把权重转移回完整的 250 Hz pre-ICA 数据。

### GUI 停止点 B：IC 人工复核

载入 `<ID>_preica_icaweights.set`：

1. 运行 ICLabel，但只作为决策辅助；
2. 同时看头皮图、频谱、成分激活、连续数据及 VEOG/HEOG 对应关系；
3. 只删除有多重证据支持的眼动、肌电、心电或明显非脑成分；
4. 不得直接复制其他被试的 IC 编号。

把最终编号写入配置：

```matlab
cfg.removed_ics = [1 3 8];   % 示例，不得照抄
```

第三次运行 Phase 3，生成 ICA-clean 派生。GUI 对照删除前后波形，确认神经信号未被过度削弱。

## 阶段 4：最终参考、EventList 与 BINLISTER

```matlab
run('scripts/systematic/config_02A.m')
run('scripts/systematic/phase04_reference_events.m')
```

项目统一采用“平均乳突优先、单侧仅作例外”的规则：

- 配置中记录的全程坏头皮通道先在 ICA-clean 的正式 250 Hz 数据上进行球面插值；
- 插值发生在 ICA 清理之后、最终参考之前；乳突和辅助通道不得使用头皮通道插值；
- M1、M2 均合格时，EEG 通道参考至 M1/M2 平均值；
- 只有一侧乳突明确异常时，才允许使用正常侧单独参考；
- 单侧例外必须在被试配置的 `reference_exception_reason` 中记录原因；
- VEOG、HEOG、TRIGGER 不改变；
- 平均乳突模式下，重参考后 M1/M2 的逐点平均应为 0；单侧模式下，所选参考通道应为 0；
- 删除 ICA 矩阵但保留 ICA 剔除元数据；
- 建立 10 个目标词 bin：HC/LC × −4、−2、+4、+6、quiet；
- 每 bin 预期 30 个事件，98/99 不进入目标 bin。

新被试配置默认写为：

```matlab
cfg.reference_mode = 'average_mastoid';
cfg.reference_exception_reason = '';
```

若 M2 异常而改用 M1，必须写为：

```matlab
cfg.reference_mode = 'm1';
cfg.reference_exception_reason = 'M2: documented participant-specific abnormality';
```

使用 M2 单侧参考时同理写为 `m2` 并记录 M1 异常原因。01A 保留既有 M1 参考结果，作为已记录的历史例外，不追溯重做。

## 阶段 5：目标词分段、基线与伪迹标记

### 第一次运行

```matlab
run('scripts/systematic/config_02A.m')
run('scripts/systematic/phase05_epoch_artifact.m')
```

生成两份 300-trial 数据：

- primary：目标词 −200 至 796 ms，−200 至 0 ms 基线；
- no-baseline：相同时窗，不做基线，仅供连续语音的目标前诊断。

### GUI 停止点：条件盲复核

1. 隐藏条件标签，合并查看全部 300 个 epoch；
2. 排除 M1、M2、VEOG、HEOG、TRIGGER 后检查头皮幅度、移动窗 P2P 和持续漂移；
3. 另在原始参考质量层面检查 M1、M2；单侧例外还须核对并记录异常侧；
4. EOG 振幅本身不是自动删试次标准；判断校正后是否仍有头皮残余；
5. 记录坏 epoch 编号，不物理删除 trial。

写回配置：

```matlab
cfg.artifact_bad_epochs = [ ... ];
cfg.artifact_review_complete = true;
```

再次运行 Phase 5。脚本用 bit 1 同步标记 `EEG.reject`、`EEG.epoch`、`EEG.event` 和 `EVENTLIST`，并保存 primary/no-baseline 两份派生。

## 阶段 6：行为正确性、平均 ERP 与重载 QC

```matlab
run('scripts/systematic/config_02A.m')
run('scripts/systematic/phase06_average_erp.m')
```

脚本逐试次连接行为 CSV 与 EEG：

- bit 1：EEG 伪迹；
- bit 2：行为错误；
- primary ERP：行为正确且 EEG clean；
- sensitivity/all-clean ERP：只要求 EEG clean，不论行为正确性；
- 输出 trial ledger；
- 保存两份 `.erp`，立即重载；
- 逐项验证 bindata、SEM、时间、标签、每 bin 试次数和数据质量结构；
- 上述 QC 全部通过后，自动用 sensitivity/all-clean ERP 生成最终形态图。

目录规则：原始行为 CSV 始终保留在 `behavior/`；EventList 文本放在
`events/eventlists/<ID>/`；派生 trial ledger 放在
`derivatives/tables/<ID>/`；最终 ERP 放在
`derivatives/erp/<ID>/`。

### GUI

1. 查看每 bin 接受试次数；过少时不解释单被试条件差异；
2. 同时查看 CZ 与 FZ/FCZ/CZ/CPZ ROI；
3. primary correct-clean ERP 仍保留为行为正确性筛选结果，all-clean 仍用于检查行为筛选敏感性；
4. 最终交付的 ERP 形态图按老师建议使用 all-clean，不使用 correct-only；
5. 统一负向朝上绘图；
6. 检查 0 ms 前基线、300–500 ms 左右形态、晚期漂移及单条件异常。

正式 N400 数值窗口、最终 ROI 和统计模型仍须在组水平分析前锁定；不得根据单个被试的波形临时挑选窗口。

当 Phase 6 的 ERP 保存与重载 QC 全部通过后，脚本会自动生成统一的
all-clean CZ/中线 ROI 十面板图。如只需重新生成图而不重做 ERP，可单独运行：

```matlab
run('scripts/systematic/config_02A.m')
run('scripts/systematic/plot_phase06_allclean_cz_roi.m')
```

图中上排为 CZ，下排为 FZ/FCZ/CZ/CPZ ROI；HC 蓝、LC 红、HC−LC 黑，负向朝上。
每个面板的接受试次数来自 all-clean ERP。PNG 与可编辑 FIG 自动保存至该被试的
`derivatives/erp/<ID>/`，文件名为 `<ID>_<reference>_erp_all_clean_cz_midline_roi.png/.fig`。

## 每位被试完成后的最小交付清单

- 被试配置文件；
- 六阶段 MATLAB 控制台 PASS/QC 输出；
- ICA ±100 µV 排除片段清单；
- IC 人工剔除编号及证据截图；
- 条件盲伪迹 epoch 清单；
- trial ledger；
- primary 与 sensitivity ERP；
- ERP 重载 QC；
- 基于 sensitivity/all-clean ERP 的最终形态图（PNG 与 FIG）。

- 条件盲伪迹 epoch 清单；
- trial ledger；
- primary 与 sensitivity ERP；
- ERP 重载 QC；
- 最终 ERP 形态图。
