<#
ForceDeleteCommits

You will use the commands in the following order
Given that you already have existing branches where you want to remove something from you will use git switch and then your branch name as shown below to ensure that you are on the right branch
Followed by get reset command as stated with a number in this case 2 where two is the commits being removed
Finally we push these changes to the branch in question 

Now if you do have a branch policy active maybe this will be prevented you will then likely have to create PR to resolve your issues previously committed
And if this is the case you could then contact the support of the given platforms to remove those PR in the end to ensure it does not show up in history or history tracking

#>
git switch mybranch
git reset --hard HEAD~2
git push --force