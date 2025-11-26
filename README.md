# aur-mommy 🔺
arch linux build files for [mommy](https://github.com/fwdekker/mommy), synchronised with the [arch user repository](https://aur.archlinux.org/packages/mommy) (aur)~

see [mommy](https://github.com/fwdekker/mommy) for installation instructions~


## ⚗️ development
### 🚨 warnings
* **never force push**
* **commits pushed to `master` are irreversibly synced with [aur](https://aur.archlinux.org/packages/mommy)**
* **`dev` must never be behind `master`**
* **be careful when editing `.aurignore`**  
  changes to this file should never affect commits that are already in the aur.
  careless changes may cause deployment failures

### 🫒 branch management
#### 🤔 what do the branches contain?
* `aur-mommy#master` contains the released build script for building the [latest release of `mommy`](https://github.com/fwdekker/mommy/releases/latest), and is mirrored to the [aur repository](https://aur.archlinux.org/packages/mommy)
* `aur-mommy#dev` contains the unreleased build script for building the latest commit to `mommy#main`, and is not mirrored to the aur repository

if you **locally** want to point the build script to a different commit, run `./update.sh <commit>` to make it build `mommy#<commit>`~

#### 🔍 where should i push my changes?
> ⚠️ below, we will be comparing branches across different repos!
>
> `mommy#dev` is not `aur-mommy#dev`!

note that pushing to `aur-mommy#master` will also [immediately sync](#-release) to the aur. 
therefore, most changes should instead go to `aur-mommy#dev`.
these changes will be merged into `aur-mommy#master` automatically when a new [mommy](https://github.com/fwdekker/mommy) release is created~

if all changes in a commit are to files listed in [`.aurignore`](https://github.com/fwdekker/aur-mommy/blob/master/.aurignore) (of that branch), no changes are pushed to the aur, so those commits are really quite safe.
but keep in mind, **`aur-mommy#dev` must never be behind `aur-mommy#master`**~

for all other cases, consider whether you want to push only to `aur-mommy#dev`, or to both `aur-mommy#dev` _and_ `aur-mommy#master`.
this choice should be based on compatibility of the change with [the version that branch points to](#-what-do-the-branches-contain)~

### 📯 release
the release process is fully automatic.
no human intervention required.
below is a brief summary of how it works~

when a new [mommy](https://github.com/fwdekker/mommy) release is created,
[its cd action](https://github.com/fwdekker/mommy/blob/main/.github/workflows/cd.yml)
1. merges `aur-mommy#dev` into `aur-mommy#master`
2. runs [`update.sh`](https://github.com/fwdekker/aur-mommy/blob/master/update.sh) on `aur-mommy#master` to bump version info,
3. and commits and pushes these changes to `aur-mommy#master`~

this then invokes [`aur-mommy`'s cd action](https://github.com/fwdekker/aur-mommy/blob/dev/.github/workflows/cd.yml), which
1. removes files listed in `.aurignore` the history using [git filter-repo](https://github.com/newren/git-filter-repo/), so aur doesn't complain about nested directories and unwanted files, and
2. pushes the filtered repo to [aur](https://aur.archlinux.org/packages/mommy)~
