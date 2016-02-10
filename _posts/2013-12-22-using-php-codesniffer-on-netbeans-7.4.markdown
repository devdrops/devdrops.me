---
layout: post
title:  "Using PHP_CodeSniffer on NetBeans 7.4"
date:   2013-12-22
categories:
---

In this first post, I'll share my basic experience in how to use an important tool to assure and verify your code quality.

Special thanks to *Tomas Mysik* and *Adam McAuley* for their efforts on [Bugzilla](https://netbeans.org/bugzilla/) and the NetBeans PHP Mailing List, which helped me a lot on how to use these combined tools, and then create this tutorial.

## Requirements

* PHP >= 5.3
* [NetBeans 7.4](https://netbeans.org/downloads/)
* [PEAR](http://pear.php.net/)


**Note:** I'm assuming you already have an HTTP Server (like Apache) installed and ready for action.

#### 1) PHP_CodeSniffer
It's a powerfull tool to verify if your code attends to a specific set of rules, contained on a *standard*. It can also be used thought prompt or command line.

To install, open your command window (DOS on Windows) and run these two lines, in the sequence as above:

<div class="livecodeserver">
<pre><code>pear config-set auto_discover 1
pear install --alldeps PHP_CodeSniffer</code></pre>
</div>

> Tip: the directive <code>--alldeps</code> makes PEAR install not only the required dependencies, but all dependencies of the given package.

To check if everything is ok, list all PEAR installed packages by executing <code>pear list</code>. You should see PHP_CodeSniffer in the list of installed packages, as above:

{<1>}![pear list](https://31.media.tumblr.com/1804a084e4183b422495d69cada914bb/tumblr_n0djl16pjE1qjtycto1_1280.png)

To finally check, run <code>phpcs -i</code>, where the directive <code>-i</code> asks for PHP_CodeSniffer to show alll the standards installed on your machine. You should see this message as a confirmation:

{<2>}![phpcs -i](https://31.media.tumblr.com/e376326fa522ab635ee8f593dabbab4b/tumblr_n0djl16pjE1qjtycto2_1280.png)


#### 2) Setting things up on NetBeans

Once you've installed PHP CodeSniffer successfully, you'll need to inform the path of your phpcs file (in Windows, *phpcs.bat*) to allow NetBeans to use  PHP CodeSniffer.

Go to *Tools > Options > PHP > Code Sniffer*. Look for the *Code Sniffer* field, and then click on the *Search...* button at the right of the field. This will make NetBeans find a list of installed versions of phpcs file on your computer.
Select the phpcs file (located at your PEAR root's installation folder), and then CodeSniffer is configured and ready for action.

> Tip: As soon the phpcs file is correctly configured on NetBeans, you'll see a command line in an output window on NetBeans performing `phpcs -i`, listing all the standards, as mentioned above.
	![netbeans-detail](https://24.media.tumblr.com/78e9657b66147781caad3f156e22b2c8/tumblr_n0djl16pjE1qjtycto4_1280.png)

#### 3) How to use it on NetBeans

Simple and easy. On the top menu, go for *Source > Inspect...*. The following window show you the basic settings before perform the inspection:

{<3>}![netbeans-inspect](https://24.media.tumblr.com/9becce15622529fb73f2e054e6c12662/tumblr_n0djl16pjE1qjtycto3_1280.png)

* **Scope** suggests *where* you'd like to perform the inspection: in a project, all your projects, or even in a single file.

* **Configuration > All Analyzers** allow you to select which tool you would like to use in  the inspection: CodeSniffer, Mess Detector, both, or a customized profile.

Once you have selected all your preferences, click on the *Inspect* button to start the inspection. It may take some time, so I suggest you to open a window and have some fresh air ;-)

> Tip: if you want to change the scope before adjust the settings, select a file or a project in the *Projects* window before you go to *Source > Inspect...* . 

NetBeans will then output a list of matchings according to which standards you've used to perform the inspection, as the image above (a dog icons indicates a CodeSniffer match, and a garbage can points to a MessDetector match). Then, apply all your methods to fix these matchings to assure that your code is 100% according to the standards, as you wish.

{<4>}![netbeans-result](https://24.media.tumblr.com/460aea5ca78e43223d53a7406214438e/tumblr_n0djl16pjE1qjtycto5_1280.png)
