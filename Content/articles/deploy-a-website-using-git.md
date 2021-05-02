---
date: 2018-09-20 00:00
---

# Deploy a website remotely using Git

This a step by step tutorial, teaching you how to leverage *Git* to deploy your website to your remote server. It will guide you through each and every step. Familiarity with *[Git](https://git-scm.com/)* and the [Linux Shell](http://linuxcommand.org/lc3_learning_the_shell.php) are a plus, but not mandatory.

## 1. Login to server

Open your terminal and login to your server using the following command:

```no-highlight
ssh your_user@server_ip_address
```

You should: 

- replace *your\_\user* with the actual username. \
By default, the username is the same as the host machine, unless you specify a different agent.
- replace *server\_\ip\_\address* with the actual [IP address](https://en.wikipedia.org/wiki/IP_address) of your server.

This command will prompt you to insert your password. Once you do, you are logged in.

## 2. Install git on server

To install *Git* on the server run the following commands

```no-highlight
#1
apt-get update

#2
apt-get install git
```

1. This updates the package lists for upgrades for packages that need upgrading, as well as new packages that have just come to the repositories. \
More information about `apt-get` can be found [here](https://linux.die.net/man/8/apt-get).

2. This will install *Git*.

If you run into permission problems, good old *sudo + password* should solve the problem.

## 3. Create a folder for the code <a id="create-a-folder-for-the-code"></a>

The source code to your website needs to be put somewhere. By convention, code goes inside the */var/www* directory.

```no-highlight
#1
cd /var/www

#2
mkdir website_name
```
1. Navigates to the correct folder.

2. Creates the folder where the code will go. Replace *website\_\name* with the name of your website.

Now, the full path to where you will put your source code is */var/www/website\_\folder/* \
This path will come in handy when setting up the *Git* repository.

## 4. Initialise a Git repository on your server

```no-highlight
#1
mkdir -p /var/repo/website_name.git

#2
cd /var/repo/website_name.git

#3
git init --bare
```

1. Creates a folder called *website\_\name.git* inside of */var/repo*. Inside of that we will host our *Git* repo.

2. Navigate to that created folder using.

3. Creates a new [bare](http://www.saintsjd.com/2011/01/what-is-a-bare-git-repository/) *Git* repository. 

## 5. Create a hook

> *A* [Hook](https://git-scm.com/docs/githooks) *is a program you can place in a hooks directory to trigger actions at certain points in git’s execution.*

There are several types of *hooks*. Each is invoked at a different stage. \
We are interested in the *post-receive* hook which is invoked after the repository receives new code.

From the *website\_name.git* folder run the following commands:

```no-highlight
#1
cd hooks

#2
touch post-receive

#3
nano post-receive
```

1. Navigates to the *hooks* folder.
2. Creates a *post-receive* hook.
3. Opens the recently created *post-receive* hook with the *nano* editor. 

Inside of the editor, copy the following code:

```no-highlight
#1
#!/bin/sh

#2
git --work-tree=path_to_website_folder --git-dir=path_to_git_directory checkout -f name_of_branch
```
1. A *shebang*, and tells the parent shell which interpreter should be used to execute the script.
2. Runs `git checkout -f name_of_branch` where the *[worktree](https://git-scm.com/docs/git-worktree)* value is the path to the folder we created in [point 3](#create-a-folder-for-the-code), and the *--git-dir* value is the path the *bare* git directory we created.\
    The *name\_of\_branch* value is optional and when not explicitly mentioned, defaults to *master*.

Saving the modifications, and quit the editor.

**NB**: We can add other commands, like restarting the server.

## 6. Make the bash executable

One last step is needed, and that is to make the *post-receive* script we just created executable.\ 
To do so run the following command: `chmod +x post-receive`

You can now logout from the server by running `logout`.

## 7. Push local code to the server

Navigate to the folder where your code lives on your local machine, and make sure it is a git repository.\
If it's not already, just run `git init`.

To push the code to the remote server, run:

```no-highlight
git remote add name_of_repository ssh://your_user@server_ip_address/path_to_git_directory
```
- *name\_of\_repository* can be anything you want.
- *path\_to\_git\_directory* is the path to where we created our *.git* folder on our server. In this case it's */var/repo/website\_name.git*

Finally, push the code to the remote repository using:  `git push name_of_repository name_of_branch`
