umlbox-dash
===========

Gregor Richards' UMLBox (https://bitbucket.org/GregorR/umlbox) with enhanced features and Git version control.

This repository is Based on hg commit `73e7326`.

Introduction
============

umlbox is a UML-based (UserMode Linux-based) solution for sandboxing applications.

You can use any UML kernel which supports the initrd.gz and hostfs filesystems to run UMLBox. On Debian, the user-mode-linux package includes such a kernel. Alternatively, you may extract Linux 3.7 to umlbox/linux-3.7 (substitute for another version in Makefile if you prefer), and a suitable kernel will be built for you. Other versions of Linux should work as well, add the flag LINUX=<dir> to your `make` line to use another version.

UMLBox is released under the ISC license, which is equivalent to the MIT and simplified BSD licenses. UML itself is of course released under the GPLv2.

Comparison
==========

UMLBox is a simple UML-based sandboxing solution. It runs a command sandboxed in a User-mode Linux (UML) kernel instance. The guest program cannot access any part of the filesystem which it has not been given explicit access to, cannot send signals to host processes, cannot access the network, and cannot perform interprocess communication. Furthermore, it has a strict memory limit, and may also have a time limit.

UMLBox is spiritually a replacement for [Plash](http://plash.beasts.org/). Plash relies on a glibc patch, and is, as such, difficult to maintain and out of date. UMLBox relies only on UML (Usermode Linux), a component of the Linux kernel, and requires no patches to UML. Furthermore, UMLBox requires no special privileges to install or use.

## UMLBox vs Plash

Benefits of UMLBox over Plash:

    Neither installing nor using UMLBox requires root privileges (Plash requires root to install)
    If a user accomplishes a root escalation from within a UMLBox jail, they escalate only to the privileges of the user who ran umlbox, not true root.
    Because UMLBox is effectively a virtual machine, control over timing and memory is very direct.
    UMLBox protects the networking and IPC infrastructures. 

Benefits of Plash over UMLBox:

    UMLBox includes a full kernel, and so is considerably more heavyweight.
    Plash does not protect networking, and so allows guest programs to access the network.
    Plash supports X11 programs. UMLBox does not, as sockets do not translate host-to-guest with UML.

Installation
============

`umlbox` requires `user-mode-linux` package (in Ubuntu) to compile and run correctly.

To compile the binary,

* Use `make` or `make all` to build umlbox and an included kernel. 
* Use `make nokernel` to build only the non-kernel components, to use another UML kernel. 

To install the sandbox to the system,

* Run `sudo make install` installs umlbox (ignore error output if you're not installing the kernel)
* Use `make install PREFIX=<some prefix>` to install to a custom prefix.

Usage
=====

`umlbox` requires no special hardware requirement (run on both x86 and x64) or system privileges, and sandboxes all accesses, including filesystem and networking. It presents a user-selectable limited subset of the directory structure to the guest process, and prevents networking and IPC to host processes.

```
umlbox [options] <command>

Options:
        -B: Use base set of mount points.
        -f[w] <dir>: Share the given directory, optionally writable.
        -t[w] <guest dir> <host dir>: Share the given directory with a different name, optionally writable.
        --cwd <dir>: Set cwd in guest to <dir>.
        --no-cwd: Set cwd in guest to /.
        --copy-cwd: Copy the host cwd (the default).
        -L<hport>:<gport>: Forward local port hport into the UMLBox on
                           port gport.
        -R<gport>:<host>:<hport>: Forward port gport out of the UMLBox to
                                  the given host on port hport.
        -X: Enable X11 forwarding.
        -n: Detach from stdin (< /dev/null will not work!).
        -T <timeout>: Set a timeout.
        -m <memory>: Set the memory limit (default 256M).
        --uml <kernel>: Use the given UML kernel.
        --mudem <mudem>: Use the given mutexer/demutexer.
        -v: Verbose mode.
        --debug: Keep UML and UMLBox's init's debug output intact.
```

Useful arguments: 

 * `-f` will bind a host directory so that the guest can see it. E.g. `umlbox -f /usr` makes `/usr` accessible from within the guest, but not writable. -fw is equivalent to -f, but also makes the shared directory writable.
 * `-t` and `-tw` are similar to `-f` and `-fw`, but allow the path seen in the guest to be different from the host path. E.g. `umlbox -t /hostusr /usr` shares the host's /usr as /hostusr within the guest.
 * `-B` is equivalent to `-f /usr -f /bin -f /lib -f /lib32 -f /lib64 -f /etc/alternatives -f /dev`
 * `-X` is very limited as yet. It can only forward DISPLAY=:0.0, it forwards it to DISPLAY=127.0.0.1:0.0, and it doesn't set any of the required environment variables (of which at least DISPLAY and XAUTHORITY are necessities). It will be fixed in time :)
 * `-L` and -R work similarly to their ssh counterparts.

Notes:
 
 * When using `-m` to limit the memory for the UML environment, the value should be larger than the minimum memory required for the Linux kernel.
	 * When there is not enough memory to instantiate User-mode linux, `umlbox` crashes.
 * Take the startup time of the sandbox into considerations when setting time limit. Empirically it takes less than 1 second.
	 * Beware that system utils like `gcc`, when run inside umlbox, is substiantially slow.
 * To set more limits, combine with system utils like `nice` and `ulimit`.
 	 * See `example` directory for more details.