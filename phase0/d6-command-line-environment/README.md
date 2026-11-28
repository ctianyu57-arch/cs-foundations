# D6：命令行环境与持久配置

## 1. 三种“让任务继续”的方式

| 方式 | 实际行为 | 能否重新接回界面 |
|---|---|---|
| `命令 &` | 启动时直接放到后台运行 | 不能接回原来的前台界面 |
| `Ctrl-Z`，再输入 `bg` | 先暂停前台任务，再让它在后台继续 | 可用 `fg` 拉回前台 |
| tmux 中 detach | 离开 tmux 界面，但会话和其中任务继续存在 | 可用 `tmux attach` 接回 |

`Ctrl-Z` 是暂停，不是终止。普通后台任务不等于可重连会话；tmux 也不能让任务在电脑或 WSL 关闭后继续运行。

## 2. 作业控制的真实验收

暂停 `sleep 300` 后，`jobs` 显示：

```text
[1]+  Stopped                 sleep 300
```
执行 `bg` 时任务已自然结束，因此显示：
```text
[1]+  Done                    sleep 300
```
之后 `jobs` 无输出，表示没有遗留任务；`Done` 不是失败。

## 3. tmux 的真实验收
- 用 `tmux new -s d6lab` 创建会话。
- 关闭原终端后，`tmux ls` 仍显示 `d6lab`。
- 用 `tmux attach -t d6lab` 成功接回。
- detach：先按 `Ctrl-b`，松开，再单独按 `d`。
- 测试后用 `tmux kill-session -t d6lab` 定向清理，最后显示 `no server running`。

## 4. 持久别名验收
- `ll='ls -alF'`：详细文件列表。
- `cscf='cd "$HOME/cs-foundations"'`：跳回课程仓库。
- `gs='git status --short --branch'`：分支与工作区简况。
- `.bashrc` 只追加一行 `source`，加载本目录的 `aliases.sh`。
- `exec bash` 后三个别名仍生效；`cscf` 跳转成功。
- 修正 `--branchs` 为 `--branch` 后，`gs` 正常显示分支和未跟踪目录。

## 5. 为什么不提交完整 `.bashrc`
`.bashrc` 是个人本机配置，可能包含本机路径或不适合公开的环境设置。
本课只提交可审查的 `aliases.sh`；备份 `~/.bashrc.before-d6` 也不入库。