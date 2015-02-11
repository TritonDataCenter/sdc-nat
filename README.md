<!--
    This Source Code Form is subject to the terms of the Mozilla Public
    License, v. 2.0. If a copy of the MPL was not distributed with this
    file, You can obtain one at http://mozilla.org/MPL/2.0/.
-->

<!--
    Copyright (c) 2015, Joyent, Inc.
-->

# sdc-nat

This repository is part of the Joyent SmartDataCenter project (SDC).  For
contribution guidelines, issues, and general documentation, visit the main
[SDC](http://github.com/joyent/sdc) project page.

A per-user NAT zone to support egress from otherwise internal zones.
While not necessarily Docker-specific, the only starting user of this
will be sdc-docker.

# Current State

This is still very much alpha. Use at your own risk!

# Overview

The basic idea is that a Docker container that exposes no ports should
still be able to reach out to the internet (e.g. a `docker build` that
does a `apt-get install ...`). We'll have a (lazily provisioned) "nat"
zone for each user that will be the default gateway on that user's
VLAN (see VXLAN). This nat zone should be an implementation detail from
the user's point of view.

VMs that have a public interface won't require this gateway, so the code path
that does the lazy provision can skip these cases.

A plan for when to *remove* these zones is TBD. It should have some
hysteresis so that a repeated cycle of 1 VM, 0 VMs, 1 VM for a given
customer doesn't result in deletion and re-creation of their 'nat' zone.
