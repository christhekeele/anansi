Anansi
======

> ***Command the terminal from a high-level with ANSI control codes.***

Synopsis
--------

[ANSI escape codes](https://en.wikipedia.org/wiki/ANSI_escape_code) are special sequences of characters that terminals interpret as instructions to control things like text color, cursor position, and pager scrolling.

Anansi is an attempt to expand on existing Elixir ANSI tooling and offer higher-level strategies to compose these terminal instructions.

- It supports less-common escape codes that `IO.ANSI` lacks.
- It defines a categorized, expressive API for generating escape code instructions intuitively.
- It offers strategies for composing complicated series of instructions tersely.
<!-- - It provides unwind-able contexts to run and reverse instructions in. -->
<!-- - It comes with drawing tools to power GUI terminal applications. -->