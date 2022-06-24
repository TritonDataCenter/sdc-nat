<!--
    This Source Code Form is subject to the terms of the Mozilla Public
    License, v. 2.0. If a copy of the MPL was not distributed with this
    file, You can obtain one at http://mozilla.org/MPL/2.0/.
-->

<!--
    Copyright (c) 2015, Joyent, Inc.
    Copyright 2022 MNX Cloud, Inc.
-->

# sdc-nat

This repository is part of the Triton Data Center project.  For
contribution guidelines, issues, and general documentation, visit the main
[Triton](http://github.com/TritonDataCenter/triton) project page.

A per-user NAT zone to support egress from internal "fabric" networks.

## Current State

This is still very much alpha. Use at your own risk!

## Overview

The basic idea is that an instance with only fabric interfaces should
still be able to reach out to the internet. We'll have a (lazily provisioned)
"nat" zone for each user that will be the default gateway on that user's
VLAN (see VXLAN). This nat zone should be an implementation detail from
the user's point of view.

VMs that have a public interface won't require this gateway, so the code path
that does the lazy provision can skip these cases.

These zones will be removed automatically when the instance count on the
fabric network drops to 0. This is handled by a workflow job.
