Algorithm-LossyCount
===

Lossy-Counting is an approximate frequency counting algorithm proposed by Manku and Motwani in 2002. This module is a Perl implementation of it.

You can count items in data stream which the size is unknown or very large, with small errors and relatively low memory footprint.

Example
---

```perl
#!/usr/bin/env perl

use strict;
use warnings;
use Algorithm::LossyCount;

my @samples = qw/a b a c d f a a d b b c a a .../;

my $counter = Algorithm::LossyCount->new(max_error_ratio => 0.005);
$counter->add_sample($_) for @samples;

my $frequencies = $counter->frequencies;
say $frequencies->{a};  # Approximate freq. of 'a'.
say $frequencies->{b};  # Approximate freq. of 'b'.
...
```

Reference
---

Manku, Gurmeet Singh, and Rajeev Motwani. "Approximate frequency counts over data streams." Proceedings of the 28th international conference on Very Large Data Bases. VLDB Endowment, 2002.

License
---

The MIT License (MIT)

Copyright (c) 2014 Koichi SATOH, all rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
