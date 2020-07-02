op
==
Generic, exception-free return values.

OP stands for "Operation Result".

This module contains a generic type that can be used as a return type
for operations that could fail. It adds additional messages to the result.
This module improves upon the `options module<https://nim-lang.org/docs/options.html>`_
in that additional messages can be passed along with the presence or absence of a value.

Basic Usage
-----------
.. code-block:: nim
 proc divide(a, b: int): OP[float] =
   ## This could fail
   if b == 0:
     return fail "Cannot divide by zero!"
   else:
     return ok a / b   # Wrap the result
 let r = divide(42, 0)
 assert r.isOk == false
 assert r.error == "Cannot divide by zero!"