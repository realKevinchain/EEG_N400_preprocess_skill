# N400 六阶段统一预处理指南

版本：2026-07-28

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
| --- | --- | --- | --- |
| 1 导入与审计 | `phase01_import_audit.m` | 原始数据导入、通道位置和连续波形检查 | `<ID>_imported.set/.fdt` |
| 2 pre-ICA | `phase02_preica.m` | 滤波前后波形、频谱、坏道检查 | `<ID>_preica.set/.fdt` |
| 3 ICA | `phase03_ica.m`，分三次运行 | ±100 训练片段复核；ICLabel 辅助的人工 IC 复核 | ICA 训练、权重和 `<ID>_preica_icaclean.set/.fdt` |
| 4 参考与事件 | `phase04_reference_events.m` | 参考质量、EventList/BINLISTER 序列与计数检查 | M1 参考连续数据和 binned 连续数据 |
| 5 分段与伪迹 | `phase05_epoch_artifact.m`，分两次运行 | 条件盲的 epoch 人工复核 | 基线/无基线 epoch；bit-1 伪迹标记数据 |
| 6 行为与 ERP | `phase06_average_erp.m` | ERP 波形、试次数和数据质量检查 | trial ledger、primary ERP、all-clean sensitivity ERP |

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

当前统一脚本沿用 01A 的 M1 参考分支：

- EEG 通道参考至 M1；
- VEOG、HEOG、TRIGGER 不改变；
- M1 保留并应为 0；
- 删除 ICA 矩阵但保留 ICA 剔除元数据；
- 建立 10 个目标词 bin：HC/LC × −4、−2、+4、+6、quiet；
- 每 bin 预期 30 个事件，98/99 不进入目标 bin。

GUI 检查 M1、M2 和头皮通道。若后续被试显示 M1 本身质量不合格，不得临时改用另一参考继续处理；应暂停并形成项目级参考决策。

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
3. 另在原始参考质量层面检查最终参考通道；
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
- 逐项验证 bindata、SEM、时间、标签、每 bin 试次数和数据质量结构。

### GUI

1. 查看每 bin 接受试次数；过少时不解释单被试条件差异；
2. 同时查看 CZ 与 FZ/FCZ/CZ/CPZ ROI；
3. primary 是正式结果，all-clean 只是对行为筛选敏感性的检查；
4. 统一负向朝上绘图；
5. 检查 0 ms 前基线、300–500 ms 左右形态、晚期漂移及单条件异常。

正式 N400 数值窗口、最终 ROI 和统计模型仍须在组水平分析前锁定；不得根据单个被试的波形临时挑选窗口。

## 每位被试完成后的最小交付清单

- 被试配置文件；
- 六阶段 MATLAB 控制台 PASS/QC 输出；
- ICA ±100 µV 排除片段清单；
- IC 人工剔除编号及证据截图；
- 条件盲伪迹 epoch 清单；
- trial ledger；
- primary 与 sensitivity ERP；
- ERP 重载 QC；
- 最终 ERP 形态图。
