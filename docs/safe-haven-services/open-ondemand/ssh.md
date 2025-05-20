# Open SSH sessions

---

## Introduction

Open OnDemand supports a number of ways by which you can open an SSH session to a back-end or the Open OnDemand host (if applicable).

In each case, a new browser tab will open with an SSH session for the selected host.

When prompted, enter your project username and password.

!!! Note

    If you see 'Open OnDemand host Shell Access' listed as an option anywhere, then you can log into the Open OnDemand host. This is supported for users who have access to back-ends where user home directories are not mounted across both the Open OnDemand host and those back-ends.

---

## 'Clusters' menu

The 'Clusters' menu lists every back-end to which you have access, and the Open OnDemand host (if applicable).

Select a host-specific menu option to open an SSH session with the selected host.

When prompted, enter your project username and password.

---

## All Apps page cluster apps

Select the 'Apps' menu, 'All Apps' option to go to the All Apps page.

The 'All apps' page lists every back-end to which you have access, and the Open OnDemand host (if applicable).

Click a host-specific 'Shell Access' link to open an SSH session with the selected host.

---

## File Manager 'Open in Terminal' button

Select the 'Files' menu, 'Home Directory' option to open the [File Manager](./files.md), then click ['Open in Terminal'](./files.md#open-in-terminal).

---

## My Interactive Sessions page job cards and hosts on which jobs are running

Click 'My Interactive Sessions' (overlaid squares icon) on the menu bar to open the My Interactive Sessions page which shows running apps and their job cards.

On a 'Running' job's job card, click the 'Host' link to open an SSH session with the host on which the job is running.

---

## 'Active Jobs' app and hosts on which jobs are running or ran

Open the [Active Jobs](apps/active-jobs.md) app.

Click the '>' button, by the job of interest, to open the job details.

Click 'Open in Terminal' to open an SSH session with the host on which the job is running. Your SSH session change your current directory to match the job context directory.
