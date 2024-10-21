<div align="center"><a href="https://github.com/ChinaGodMan" target="_blank">
    <img height="128px" width="128px" src="https://avatars.githubusercontent.com/u/96548841?v=4" alt="UserScripts"></a>
</div>
<img height=6px width="100%" src="https://media.chatgptautorefresh.com/images/separators/gradient-aqua.png?latest">

# Git-便捷 PowerShell 脚本

> :octocat: 备份自己在 VScode 常用的操作 git 的 PowerShell 脚本
>
> :octocat: 适用于 Windows 系统
> 搭配与`Vscode`更为方便

> [!TIP]
>
> 单独在 PowerShell 运行需要先进入目录
> 可以将脚本目录放在环境变量中，直接运行

添加到系统级变量之后就可以方便使用了:

```powershell
CreategitHubRepo
```

```powershell
$currentPath = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)
$newPath = "$currentPath;C:\git-pwsh"
[Environment]::SetEnvironmentVariable('Path', $newPath, [System.EnvironmentVariableTarget]::Machine)
```

<img height=6px width="100%" src="https://media.chatgptautorefresh.com/images/separators/gradient-aqua.png?latest">

## CreateGitHubRepo.ps1

创建 GitHub 仓库并创建本地仓库设置关联

- `name`:仓库名称
- `private`:公开或私有
- `description`:仓库描述

```powershell
.\CreategitHubRepo.ps1 -name "666666666666"  -private $true -description "666666666666"
```

<img height=6px width="100%" src="https://media.chatgptautorefresh.com/images/separators/gradient-aqua.png?latest">

## DeleteBranch.ps1

删除本地和远程分支

- 提示输入需要删除的分支名称
- 回车后删除本地和远程分支

```powershell
.\DeleteBranch.ps1
```

<img height=6px width="100%" src="https://media.chatgptautorefresh.com/images/separators/gradient-aqua.png?latest">

## ForcePull.ps1

强制从远程拉取,并覆盖本地

```powershell
.\ForcePull.ps1
```

## Login.ps1

```powershell
.\Login.ps1
```

<img height=6px width="100%" src="https://media.chatgptautorefresh.com/images/separators/gradient-aqua.png?latest">

## PushAllRepos.ps1

批量更新本地仓库到远程仓库

- 需要在脚本内配置本地`Vscode`工作区路径

```powershell
.\PushAllRepos.ps1
```

<img height=6px width="100%" src="https://media.chatgptautorefresh.com/images/separators/gradient-aqua.png?latest">

## SyncBranches.ps1

同步本地分支和远程分支,并删除失效的本地分支

```powershell
.\SyncBranches.ps1
```

<img height=6px width="100%" src="https://media.chatgptautorefresh.com/images/separators/gradient-aqua.png?latest">

## AutoPush.ps1

在仓库运行自动更新本地仓库到远程仓库

> [!WARNING]
>
> 为`force` 推送

- `git add .`
- `git commit`
- `git push`

```powershell
.\AutoPush.ps1
```

<img height=6px width="100%" src="https://media.chatgptautorefresh.com/images/separators/gradient-aqua.png?latest">

## BranchReset.ps1

重置分支到指定 `commit`,运行后提示输入`hash`

- `0`: 保留更改并回退到指定提交
- `1`:丢弃更改并回退到指定提交
- `2`:回退到上一个提交

```powershell
.\BranchReset.ps1
```

<img height=6px width="100%" src="https://media.chatgptautorefresh.com/images/separators/gradient-aqua.png?latest">

## CreateBranch.ps1

创建一个分支并推送到远程仓库

```powershell
.\CreateBranch.ps1
```
