// -*- mode: C; c-file-style: "cc-mode" -*-
//*************************************************************************
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of either the GNU Lesser General Public License Version 3
// or the Perl Artistic License Version 2.0.
// SPDX-FileCopyrightText: 2026 Wilson Snyder
// SPDX-License-Identifier: LGPL-3.0-only OR Artistic-2.0
//
//*************************************************************************

// Valid C, but not C++, which does not convert void* implicitly
int dpic_sum(int n) {
    int values[8];
    void* voidp = values;
    int* valuesp = voidp;
    int sum = 0;
    for (int i = 0; i < n; ++i) {
        valuesp[i] = i;
        sum += valuesp[i];
    }
    return sum;
}
