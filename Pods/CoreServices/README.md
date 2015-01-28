CoreServices-iOS
==========

A library project containing common (non-UI) categories and subclasses

##Configure project to use library

- In "Building Settings" search for "Other Linker Flags"
- Add "-ObjC" and "-all_load" as values 

## Branches
<b>master</b> - Represents the current of this library
- You should NEVER develop on this branch.
- ONLY <b>f/[feature-name]</b> can be branched out (only for bug fixes).
 
<b>f/[feature_name]</b> - Feature branch.
- You should develop on this branch.
- <b>f/[feature-name-smaller-task]</b> (when you need to split into smaller tasks).
- *Pull Request* from this branch will be reviewed and merged by someone else.
- After *Pull Request* from this branch is merged, it will be deleted.

This model is very similar to this: http://nvie.com/posts/a-successful-git-branching-model/

## Issues & Pull Requests
- New *Issue* is created.
- Issue is assigned to a *Milestone*.
- Someone is assigned to that *Issue*.
- That person resolves the issue by making *Pull Requests* or in any other way.
- When *Issue* is resolved, person who is assigned to the *Issue* adds label <b>test</b> on the *Issue* to mark it ready for testing or if it was labeled with <b>task</b> closes the *Issue*.
