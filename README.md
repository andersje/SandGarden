SandGarden
==========

SandGarden is a series of shellscripts written to control Xen-based VMs, which are accessible to endusers only via SSH.  Developed under a grant from the state of Minnesota, these scripts were used to managed Xen-based VMs used in introductory, intermediate and advanced linux administration courses.  At this point, it's been nearly six years since I worked with this much, but perhaps this code will prove useful to someone else.  It shouldn't be too hard to adjust this to use virsh and kvm, and if anyone is interested in that, I could give you a hand with it.

original readme follows:

All files in this directory are, where applicable, copyrighted 2007 by Jeremy Anderson, under the terms of the Gnu Public License.  You can get the GPL v3 from http://www.fsf.org/

Enjoy!
Welcome to Jeremy Anderson's Xen setup.
This was developed by the aforementioned author under an Award of Excellence granted by the Minnesota State College and University system (MNSCU).

As one of the clauses of this award, this software is to be released under the Gnu Public License.

Currently, it is released under the GPLv2 (included in this directory).

When GPLv3 is released, it will likely be upgraded to that.  

Questions and comments can be sent to Jeremy Anderson:
jeremy@angelar.com

see:  gpl.txt for actual licensing terms.


There are a bunch of pieces to this, and it could certainly be more polished than it currently is.

In a nutshell, here's what you do:

examine the scripts, make sure you know what they're doing.
DO NOT SKIP THIS STEP!

Then, copy them into place, echoing the directory structure you've found in this tarball.

Set up a logical volume group for your xen images.  I named mine VGXen.  Create partitions of the appropriate size on it.  Then, create a single Xen image, probably using the fedora graphical tools.  Once it's made and configured, shutdown that system.

Create a master image with:

dd if=/location/of/first/image of=/save/my/master/image/here

simple, eh?

Create your users.  Make each one a member of the xen_usr group.  Doesn't matter what the GID of that group is.

create the file /etc/xen/student_machines.  Format is documented inside the example file.

Make sure that image_single.bash is properly configured to know where your master image file is located.

Run /usr/local/sbin/add_student_machines.bash

Smile.  Relax.  Let the users login and play.

I didn't have much luck getting machines to run in < 256MB of RAM, and I disabled Xwindows on those machines since that was outside the scope of my classes.

good luck, and I'd love to hear how it's going with your setup!

Jeremy


DIRECTORY STRUCTURE:

arrange the scripts in this directory thusly:

/usr/local/bin:  killer.bash, attach_xen.bash, start_xen.bash, loginmenu.bash
/usr/local/sbin:  add_student_machines.bash, create_machine_def.bash, image_single.bash

create an /etc/xen directory.  touch the files lastip, last_uuid.  populate the student_machines file (sample in configs/ dir).
create the .motd and .help files in /etc/xen.

be sure to add %xen_usr ALL = NOPASSWD: XEN  into /etc/sudoers
be sure all your xen users are in the xen_usr group.
