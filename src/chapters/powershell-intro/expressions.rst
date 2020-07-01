=====================
Expression Evaluation
=====================

Expressions are the general term for syntactical instructions that must be **evaluated** to a **value**. Expressions can be anything from a simple variable assignment to a more complex command like executing a cmdlet.

Programming languages are made up of rules for how different types of expressions are evaluated. In general, expressions are evaluated from left to right. But depending on the *operations used in an expression* there may be more specific rules that cause it to be evaluated differently.

In the following sections we will explore two **operators** (symbols with special meaning) that are integral to working with PowerShell.

Grouping Expression Operator
============================

Understanding how grouping expressions works is best discovered through an example. Let's consider the following *arithmetic (math) expression*. 

These types of expressions are evaluated from left to right unless some math operators (like ``+`` and ``*``) are used. Arithmetic expressions are evaluated following the mathematical rules defined in the `PEMDAS order of operations <https://www.purplemath.com/modules/orderops.htm>`_.

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > 5 + 5
   10

On its own this is an expression (a set of instructions), not a value. It must first be evaluated (interpreted and computed) to its value of ``10``. 

In the following example we want to add ``5 + 5`` and multiply *the resulting value* by ``2`` to make ``20``. The overall expression contains two expressions that need to be evaluated -- addition and multiplication.

Would this expression evaluate to our goal of ``20``?:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > 5 + 5 * 2
   15

Expressions are evaluated with rules that depend on their context. For arithmetic expressions the PEMDAS rules cause ``5 * 2`` to be evaluated first with the resulting value of ``10`` then being added to ``5``. 

However, we can control the **order of evaluation** by **grouping expressions** that we want to be evaluated first. In PowerShell the **Grouping Expression Operator** is a pair of parenthesis that wrap around any PowerShell expression. Just like in math, grouped expressions are evaluated from **the innermost group** to the **outermost (overall) expression**. 

If we were to group the addition expression it would be evaluated first *then* its resulting value would be multiplied by ``2``:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > (5 + 5) * 2
   20

We can see that ``(5 + 5)`` was evaluated first, **then the group was replaced with the resulting value** of ``10`` before continuing evaluating the overall expression.

Consider a more complex example with *nested* groups (a grouped expression inside another):

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > ((10 + 10) * 2) + 5

The outermost (overall) expression would be evaluated in the following steps. From the inside out:

#. innermost grouping: ``(10 + 10)``, a resulting value of ``20``
#. moving outwards to the next grouping: the resulting value ``(20)`` is substituted and evaluated to ``((20) * 2)) = 40``
#. outermost level: once again the grouping's value ``(40)`` is substituted for the final evaluation ``(40) + 5 = 45`` 

The same principle applies to any PowerShell expression within the grouping operators. But PowerShell expressions go well beyond basic arithmetic! Instead of evaluating to just *numeric values* what is substituted for each grouped expression can be a *result object* of any type.

Consider a simple scenario with string objects rather than numbers. Our goal is to combine (concatenate) two strings together and determine the length of the new string that is formed. *Without grouping* this would be our result:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > "hello" + "world".length
   hello5

The string ``"hello"`` is concatenated with the result of ``"world".length`` into the unexpected string ``"hello5"``. PowerShell tries to evaluate from left to right but can't combine a string (``"hello"``) with an *expression* (``"world".length``). It first evaluates the length to a value of ``5`` *and then* evaluates ``"hello" + 5"``.

We can use grouping to enforce ``"hello" + "world"`` being evaluated first *and then* checking the ``length`` property of the resulting ``string`` object:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > ("hello" + "world").length
   10

In other words the evaluation and substitution looked like this:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > (string object).length

Grouping expressions allows you to evaluate the group and then treat the group, on its closing ``)``, as an object. The object can then be used to access properties and methods directly from the group using dot notation. The group is first evaluated to its resulting object *then* dot notation access is evaluated.

Subexpression Operator
======================

Recall that in Bash we used the command substitution syntax ``$(command)`` to execute in-line commands. In PowerShell the same syntax is used but is referred to as a **subexpression operator**. At first glance the subexpression operator looks similar to the grouping operator we just learned about.

Let's compare the purposes of each of these operators:

- **grouping operator**: lets you control the **order of evaluation in an expression**
- **subexpression operator**: lets you control **the execution of an expression within another**

Let's see the difference in action by trying to print the length of the combined strings **inside another string expression**. 

First using a grouping operator:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   # the Bash 'echo' command can be used as an alias for Write-Output
   > Write-Output "The length of the concatenated strings is: (("hello" + "world").length)"

   The length of the concatenated strings is: ((
   hello + world).length)

Notice that it printed the literal text inside the grouped expression rather than executing it. The quotes were in turn interpreted as literal quote characters leading to some unexpected line breaks. In other words, **the grouped expression did not get evaluated**.

Why wasn't it evaluated? Because **evaluation only takes place during execution**. From PowerShell's perspective there was a single expression to be executed -- the string expression.

In order for us to execute the length calculating expression **within** the string expression we can use a subexpression instead:

Let's try using a subexpression instead:

.. sourcecode:: powershell
   :caption: Windows/PowerShell

   > Write-Output "The length of the concatenated strings is: $(("hello" + "world").length)"
   The length of the concatenated strings is: 10

This time the subexpression ``("hello" + "world").length`` is **executed**, evaluated to ``10`` and its resulting value is substituted into the string expression. The string expression is then itself evaluated to become the final string printed by ``Write-Output``.

We will see more examples of subexpressions and grouped expressions later in this course. They are valuable tools to understand for writing "one-liner" commands in the REPL. But they are even more useful when employed in pipelines and scripts.

.. admonition:: tip

   Use **grouping expressions** when you want to **control the order of evaluation** (from the inside out).

   Use **subexpressions** when you need to **execute an expression** inside of another. In addition, only subexpressions allow you to:

   - execute **multiple commands** as a single unit
   - use **keywords** like ``for`` (for loops) and ``if`` (for conditional logic) 

   For more information about the available operators you can visit the `PowerShell operators documentation <https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7#subexpression-operator-->`_.