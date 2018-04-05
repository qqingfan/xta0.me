---
title: Programming Language - 1
layout: post
---

<em>文章均为作者原创，转载请著名出处</em>

> Programming Language课程笔记

### Course Content

- Essential concepts relevant in any programming language
- Use ML,Racket,Ruby
- Big Focus on Functional Programming 
- **3 parts (100-200 hours),11 weeks**
	- Part A
		- Syntax vs. semantics vs. idioms vs. libraries vs. tools
		- ML basics (bindings, conditionals, records, functions)
		- Recursive functions and recursive types
		- Benefits of no mutation
		- Algebraic datatypes, pattern matching
		- Tail recursion
		- Higher-order functions; closures
		- Lexical scope
		- Currying
		- Syntactic sugar
		- Equivalence and effects
		- Parametric polymorphism and container types
		- Type inference
		- Abstract types and modules
	- Part B
		- Racket basics
		- Dynamic vs. static typing
		- Laziness, streams, and memoization
		- Implementing languages, especially higher-order functions
		- Macros
		- Eval
	- Part C
		- Ruby basics
		- Object-oriented programming is dynamic dispatch
		- Pure object-orientation
		- Implementing dynamic dispatch
		- Multiple inheritance, interfaces, and mixins
		- OOP vs. functional decomposition and extensibility
		- Subtyping for records, functions, and objects
		- Class-based subtyping
		- Subtyping
		- Subtyping vs. parametric polymorphism; bounded polymorphism



### Environment Setup

- SML Interpreter
	- `brew install sml`
	- [Commandline reference](http://pages.cs.wisc.edu/~fischer/cs538.s08/sml/sml.html)
- Code Editor
	- [VSCode](https://code.visualstudio.com/)
	- [Standard ML extension](https://github.com/freebroccolo/vscode-sml) 
	
# Week 1

## Variable Bindings and Expressions

- "Let go" of all programming languages you already know"
- Treat "ML" as a "totally new thing"
	- Time later to compare / contrast to what you konw
- Start from a blank file 

```Haskell
(* This is a comment. This is our first program. *)

val x = 34; 

(* static enviroment: x : int *)
(* dynamic enviroment: x --> 34 *)

val y = 17;

(* static enviroment: x:int, y:int *)
(* dynamic enviroment: x --> 34, y --> 17 *)

val z = (x+y) + (y+2);

(* static enviroment: x:int, y:int, z:int *)
(* dynamic enviroment: x--> 34, y-->17, z --> 70 *)

val q = z+1

(* static enviroment: x:int, y:int, z:int, q:int *)
(* dynamic enviroment: x--> 34, y-->17, q --> 71 *)


val abs_of_z = if z<0 then 0-z else z;(* bool *)(* int *)

(* dynamic enviroment: ..., abs_of_z --> 70 *)

val abs_of_z_simpler = abs(z)

```

- Static environment: Dan这里讲的静态环境是指代码在运行时环境之前（执行前），ML会对变量做类型推断，签名检查，比如`x:int`。
- Dynamic environment: 程序的运行时环境，保存变量当前状态

### A Variable Binding


- 定义 ： ` val x = e ; `

- Syntax(语法):
	- **Syntax** is just how you write something
	- `val`, `=` , `;` 
	- variable `x`
	- Expression `e`


- Semantics(语义):
	- Syntax is just how you write something
	- **Semantics** is what that something means
		- **Type Checking** (before program runs)
		- **Evaluation** (as program runs)
	
	- For variable bindings:
		- Type-check expresson and extend **static environment**
		- Evaluate expression and extend **dynamic environment** 
		
> 在函数型语言里，没有赋值(assign)的概念，而是叫做binding。一个变量(符号)被bind一个value后，这个变量是不允许再去bind其它的value。
		
##Rules for Expressions

### Expressions

- We have seen many kinds of expressions:
	- `34 true false x e1+e2 e1>e2`
	- `if e1 then e2 else e3`
	
- **(重点)Every kind of expression has**: 
	- Syntax - 语法
	- Type-checking rules - 类型检查
		- Produces a type or fails(with a bad error message)
		- types so far: `int` `bool` `unit`
		
	- Evaluation rules(used only on things that type-check) - 求值规则
		- Produces a value(or exception or infinite-loop)

- 例1: `Variables`:
	- Syntax:
		- sequence of letters,digits,_,not starting with digit
	- Type-checking:
		- Look up type in current **static enviroment**. if not there, fail
	- Evaluation:
		- look up value in current **dynamic enviroment**
	
- 例2: `Addition`:
	- Syntax:
		`e1+e2` where `e1` and `e2` are expressions
	- Type-checking:
		- if `e1` and `e2` have type `int`,
		- then `e +e2` has type `int`
	
	- Evaluation:
		- if `e1` evaluates to `v1` and `e2` evaluates to `v2`,
		- then `e1+e2` evaluates to sum of `v1` and `v2`

- 例3: `if-else`
	- Syntax: 
		- if `e1` then `e2` else `e3`
		- where `if`,`then`,`else` are keywords and `e1`,`e2`,`e3` are subexpressions
	- Type-checking:
		- first `e1` must have type `bool`.
		- `e2` and `e3` can have any type `t`, but they must have the same type `t`.     
		- the type of the entire expression is also `t`
	- Evaluation rules:
		- first evaluate `e1` to a value call it `v1`, if the result is ture, then evaluate `e2` as the result of whole expression. else, evaluate `e3` and that result is the whole expression's result.


### Values

- All values are expressions
- Not all expressions are values
- Every value **"evaluates to itself"** in "zero steps"
- Examples:
	- `34`,`17`,`42` have type `int`
	- `true`, `false` have type `bool`
	- `()` has type `unit`
	

## The REPL and Erros

- 使用命令行解释执行单条语句要加`;`
	- `val x=1;` 
- 读文件`use "foo.sml";`

### Error

- syntax:
	- what you wrote means nothing or not the construct you intended.
- Type-checking:
	- What you wrote does not type-checked
- Evaluation: 
	- It runs but produces wrong answer, or an exception, or an infinite loop
- common error:
	- `if` - `then` - `else`
	- if takes a `bool` type value
	- `then` and `else` must return the same type of result
	- 负号用`~`表示：`~5`
	- 除号用`div`表示 `10 div 5`

## Shadowing

### Multiple binding of same variable

**shadowing**指的是add a variable to the environment，但是这个variable在environment中已经存在了。

> There is  no way in ML to **mutate** or change the fact that `a = 10` in previous enviroment all we get is a **subsequence enviroment**,`a` is shadowed, we have a different mapping for a in a different envrioment

ML中没有赋值的概念，同一块内存的值也不允许mutate。

Multiple varibale bindings of the same variable is often poor style

- Often counfusing
 
But it's an instructive exercise

- Help explain how the enviroment "works"
- Help explain how a variable binding "works" 

下面代码:

```haskell
val a = 10
(* a:int a -> 10 *)

val b = a*2
(* b -> 20 *)

val a = 5 (*  this is not an assignment statement *)
(*There is no way in ML to mutate or change the fact that a = 10 in previous enviroment all we get is a subsequence enviroment,a is shadowed, we have a different mapping for a in a different envrioment*)
(* a -> 5, b-> 20 *)
```

从这里开始，相当于创建了一个新的environment,后面的expression都是在这个enviroment当中了，因此原来的a被shadow掉了。

```haskell
val c = b
(* a -> 5, b -> 20 , c -> 20  *)
```

此时b不是前面的b了，而是新environment中的b

```haskell
val d = a
(* ...,in the current envrioment a -> 5, d->5 *)

val a = a + 1
(*create a new envrioment, a -> 6*)
```
和上面例子相同，在当前的envrionment中，a+1 = 6，此时需要增加一个variable，也叫a，此时就产生了shadowing。系统会再创建一个新的environment保存新的a。

```haskell
val a = <hidden-value> : int
val b = 20 : int
val a = <hidden-value> : int
val c = 20 : int
val d = 5 : int
val a = 6 : int
val it = () : unit
```

a之前的赋值被shadow掉，提示<hidden-value>

下面代码:

```haskell
val a = 1
val b = a (* b is bound to 1 *)
val a = 2

```

Two reasons to reason aout the code above:

- Expressions in variable bindings are evaluated "eagerly"
	- Before the variable binding "finishes"
	- Afterwards, the expression producing the value is irrelevant
	
- There is no way to "assign to" a variable in ML
	- Can only shadow it in a later enviroment 


## Functions(informally)

### Function definitions

- **Functions**: the most important build block in the whole course
	- Like Java methods,have arguments and result
	- But no classes,`self`,`this`,`return`

Example function binding:

```haskell
(*Note:correct only if y>=0 *)
fun pow(x:int, y:int) = 
	if y=0 
	then 1 
	else x*pow(x,y-1)
```
Note：The body includes recursive call

compile and run:

```haskell
(* 函数签名： *)
val pow = fn : int * int -> int (* fn的类型 *)
val cube = fn : int -> int

```

- The use of `"*"` in type syntax is not multiplication
	- Example: `int * int -> int` 表示有两个参数，类型都是`int`,返回值也是`int`
	- In expressions, `*` is multiplication: `x*pow(x,y-1)`

- Cannot refer to later function bindings
	- That's simply ML's rule
	- Helper functions must come before their uses
	- Need spection construct for mutual recursion(later)
	
> 上面例子可知ML中Function是first-class object, 函数的类型就是它的签名

### Recursion 

- “Makes sense” because calls to same function solve "simpler problems"
- Recursion more powerful than loops
	- We won't use a single loop in ML
	- Loops ofter(not always)obscure simple, elegant solutions
	
**Everything you can do in loop, you can do it in recursion**，使用递归可以取代循环，简化代码

> 由于`for`或`while`是一种过程性的表达式，它表达的是如何完成循环，还需要引入一些状态变量。在函数型语言中，这种做法不直观，不是一种declarative风格，没有输入和输出。


## Functions（formally)

###Function binding

- Syntax : `fun x0（x1:t1,...,xn:tn）= e`
	- `x0`是函数名
	- (will generalize in later lecture)
		
- Type-Checking: 
	- Adds binding `x0:(t1 *...* tn ) -> t `，首先将`x0`的类型绑定为`(t1 *...* tn)->t`
	- Can type-check body `e` to have type `t` in the static envrioment containing:
		 - "Enclosing" static envrioment (earlier bindings)
		- `x1:t1,...,xn:tn`(arguments with their types)
		- `x0 : (t1 *...*tn) -> t`(for recursion)

对函数的body`e`进行type-checking, 使用static environment中已有的信息，比如之前创建的binding（函数body中可能使用以前的binding），以及函数的参数类型check和函数自身的类型check（函数body中可能出现递归，因此对函数自身也要进行type-checking）

- Evaluation : 
	- **A function is a value!**(No evaluation yet)。`x0`和普通变量一样，只不过类型是funcion
	- Add `x0` to dynamic enviroment so later expression can call it. 运行时求值，对函数的body不进行提前Evaluation
	- Funcation call semantics will alse allow recursion		

### More on type-checking

`fun x0（x1:t1,...,xn:tn）= e`

- New kind of type : `(t1 *...* tn ) -> t`
	- Result type on right
	- The overall type-checking result is to give `x0` this type in rest of program(unlike Java, not for earlier bindings)。意思是在static environment中，只有函数对象`x0`的类型。ML函数也是在运行时求值的，因此函数体中使用的binding是在dynamic environment中寻找的
	- Arguments can be used only in `e`
	- Because evaluation of a call to `x0` will return result of evaluating `e`，The return type of` x0` is the type of `e`
	- The type-checker "magically" figures out `t` if such a `t` exists.Type-checker可以根据函数体`e`自行推断出函数`x0`的返回值类型`t`
	- Later lecture:Requires some cleverness due to recursion
	- More magic after hw1 : Later can omit argument types too
	
	
### Function Calls

A new kind of expression:

- Syntax : `e0 (e1,...,en)`
	- Parentheses optional if there is exactly one argument, 如果只有一个参数，则可以省略括号。ML中不支持可变参数
	- `pow(2,3)`
- Type-Checking:
	- if:
		- `e0` has some type `(t1 *...* tn ) -> t`
		- `e1` has type `t1`, ... , `en` has type `tn`
	- then:
		- `e0 (e1,...,en)` has type `t`
		- Example:`pow(x,y-1)` in previouse example has type `int`
	
- Evaluation:

	1. (Under current dynamic enviroment) evalute `e0` to a function :`(t1 *...* tn ) -> t`
		- Since call type-checked, result will be a function
	
	2. (Under current dynamic enviroment) evaluate the arguments to value `v1,...,vn`
		- 比如参数中有`2+2`，这种情况下需要对其进行求值后再继续evaluate function
	
	3. Result is evaluation of `e` in an enviroment extended to map `x1` to `v1`, ... `xn` to `vn`
	 	- ("An envrioment" is actually the enviroment where the function was defined, and includes `x0` for recursion)
	
	
## Tuples and Pairs

### Paris(2-tuples)

#### Defination:

- Syntax : `（e1,e2）`

- Evaluation:Evaluate `e1` to `v1` and `e2` to `v2`; result is `(v1,v2)`
	- A pair of values is a value
	
- Type-checking: if `e1` has type `ta` and `e2` has type `tb` then the expression has type `ta * tb`
	- A new kind of type
	
#### Access:

- Syntax： `#1 e` and `#2 e`

- Evaluation: Evaluate e to a pair of values and return first or section piece
	- Example: if `e` is a variable x then look up x in enviroment
	
- Type-checking:if `e` has type `ta * tb` then `#1 e` has type `ta` and `#2 e` has type `tb`

- example:

```
fun swap(pr : int*bool) = (#2 pr, #1 pr)

(* (int*int) * (int*int) -> int *) 
fun sum_two_pairs (pr1 : int * int, pr2 : int * int) = (#1 pr1)+(#2 pr1)+(#1 pr2)+ (#2 pr2)

(* int*int -> int *int *)
fun div_mod (x:int,y:int) = (x div y , x mod y)

fun sort_pair(pr:int*int) = 
    if (#1 pr) < (#2 pr)
    then pr 
    else (#2 pr, #1 pr)
    
```


### Tuples

Actually , you can have tuples with more than two parts.

- (e1,e2,...,en)
- ta * tb * ... * tn
- "#1 e, #2 e, #3 e ..."

### Nesting

Pairs and tuples can be nested however you want

```haskell
val x1 = (7,(true,9)) (* int * (bool*int) *)

val x2 = #1 (#2 x1) (* bool *)

```



## Lists

- Despite nested tuples, tye type of variable still "commits" to a particular "amount" of data 

In contrast, a list:

- Can have any number of elements
- But all list elements have the same type

### Building Lists

- The empty list is a value `[]`

- In general, a list of values is a value; elements separated by commas:`[v1,v2,...,vn]`

> 在SML中list中每个元素的类型是相同的

- if `e1` evaluates to `v` and `e2` evaluates to a list `[v1,...,vn]`,then `e1::e2` evaluates to `[v,..,vn]`

` e1::e2 (*pronounced "cons"*) `example:

```
- val list = 1::[1,2];
val list = [1,1,2] : int list

```

### Accessing Lists

Until we learn pattern-matching, we will use three standard-library functions

- `null e` evaluates to `true` if and only if `e` evaluates to []

```
- null list;
val it = false : bool

```


- if `e` evaluates to `[v1,v2,...,vn]` then `hd e` evaluates to `v1`
	- raise exception if e evaluates to []
	
- if `e` evaluates to `[v1,v2,...,vn]` then `tl e` evaluates to `[v2,...,vn]`
	- raise exception if e evaluates to []
	- Notice result is a list
	

### Type-checking list operations

Lots of new types： For any type `t`, the type `t list` describes lists where all elements have type `t`

数组的类型为`t list`，`t`为任意类型

```
- [1,2,3];
val it = [1,2,3] : int list

```

Examples:
	
`int list` `bool list` `int list list` `(int * int) list` `(int list*int) list`

- So [] can have type t list of any type
	- SML uses type `·a list` to indicate this("quote a" or "alpha")
	
- For `e1::e2` to type-check, we need a `t` such that `e1` has type `t` and `e2` has type `t list`. Then the result type is `t list`

- null : `.a list -> bool`

Takes a alpha list(any type of list)(·a list) and returns a boolean value


- hd : `.a list -> .a`

- tl : `.a list -> .a list`


## 1 - 9:List Function

Gain experience with lists and recursion by writing several functions that process and/or produce lists...

example:

```
fun sum_list (xs:int list) = 
	if null xs then 0
	else hd xs + sum_list(tl xs)
	
	
fun countdown(x:int) = 
	if x=0 then []
	else x::countdown(x-1)
	
fun append(xs : int list, ys : int list) =
	if null xs then ys
    else (hd xs) :: append((tl xs),ys)

```
Functions over lists are usually recursive

- Only way to "get to all the elements"

- what should the answer be for the empty list?

- what should the answer be for a non-empty list?

	- Typically in terms of the answer for the tail of the list !
	
	
Similarly, functions that produce lists of potentially any size will be recursive

- You create a list out of smaller list

> 基本上函数型语言关于数组的处理都是递归运算。


## Let Expression

###Review

Huge progress already on the core pieces of ML:

- Types: `int bool unit t1...tn t list t1...tn->t`

	- Types are "nest"(each t above can be itself a compound type)
	
- Variables, environments, and basic expressions

- Functions

	- Build: `fun x0(x1:t1,....,xn:tn) = e`
	
	- Use: e0(e1,e2...en)
	
- Tuples

	- Build: `(e1,...,en)`
	 
	- Use: `#1 e, #2 e, ....`
	
- Lists

	- Build: `[]`, `e1::e2`
	
	- Use: `null e`, `hd e`, `tl e`


###Now...

引入局部变量

The big thing we need: local bindings

- For style and convenience

This segment:

- Basic let-expressions

Next segments:

- A big but natural idea: nested function bindings

- For efficiency

The construct to introduce local bindings is ***just an expressions****,
so we can use it anywhere an expression can go.


###Let - expressions

3 questions:

- Syntax: `let b1 b2...bn in e end`

	- Each `bi` is any *binding* and **e** is any expression
	
- Type-checking: Type-check each `bi` and `e` in a static environment that includes the previous bindings.Type of whole let-expression is the type of `e`.

- Evaluation: Evaluate each `bi` and `e` in a dynamic environment that includes the previous binding.Result of whole let-expression is result of evaluating `e`.

example:

```
fun silly1(z:int) = 

	let 
		val x = if z>0 then z else 34
		val y = x + z + 9
	in
		if x>y then x*2 else y*y
	end
	
```

```
func silly2() = 

	let 
		val x = 1
	in 
		//这里的x是在新的environment里面，上面的x会被shadow掉
		(let val x = 2 in x+1 end) + 
		
		//这里的x值为1
		(let val y=x+2 in y+1 end)
	end
	
```

###What's new

上面`let in end`语法实际上是对***scope***的描述：

- What's new is scope: where a binding is in the enviroment

	- In later bindings and body of the let-expression
	
		- (Unless a later or nested binding shadows it)
		
	- Only in later bindings and body of the let-expression

- Nothing else is new:

	- Can put any binding we want, event function bindings
	
	- type-check and evaluate just like at "top-level"


## 1-11：Nested Functions

###Any binding

According to our rules for let-expressions, we can define functions inside any let-expression

```
let b1 b2 ... bn in e end

```
This is a natural idea, and often good style

example:

```

fun countup_from1(x:int) = 
    let
	fun count (from: int) = 
	    if from = x
	    then x::[]
	    else from :: count(from+1)
    in 
	count(1)
    end
    
    
```

由于函数是first class的，可以在函数中定义函数，并且在scope中生效。

- Functions can use bindings in the environment where they are defined:

	- Bindings from "outer" environments
	
		- Such as parameters to the outer function
		
	- Earlier bindings in the let-expression
	
- Unnecessary parameters are usually bad style

	- Like to in previous example
	
###Nested functions: style

- Good style to define helper functions inside the functions they help if they are:
	
	- Unlikely to be useful elsewhere
	- Likely to be misued if available elsewhere
	- Likely to be changed or removed later
	
	
- A fundamental trade-off in code design:reusing code saves effort and avoids bugs, but makes the reused code harder to change later.

## 1-12 Let Expressions to Avoid Repeated Comupatation

example:

```
fun bad_max(xs:int list) = 
    if null xs then 0
    else if null (tl xs) then (hd xs)
    else if hd xs > bad_max(tl xs) then hd xs
    else bad_max(tl xs)
    
let x = bad_max [50,49,...,1]
let y = bad_max [1,2,...,59]  

```
Consider this code and the recursive calls it makes

- Don't worry about calls to `null`,`hd` and `tl` because they do a small constant amount of work

上面代码的效率：

- 对于第一种情况[50,49,...,1]执行bad_max的次数为50。

- 对于第二种情况[1,2,...,50]每一次执行bad_max又会递归执行两次bad_max，执行次数为2^50方


一种解法是缓存bad_max的结果：

```
fun good_max(xs: int list) = 
    if null xs then 0
    else if null (tl xs) then hd xs
    else
	let val tl_ans = good_max(tl xs)
	in
	    if hd xs > tl_ans then hd xs
	    else tl_ans
    end
```

上面的代码只调用good_max一次。

### Math never lies

The key is not to do repeated work that might do repeated work that do ...

- Saving recursive results in local bindings is essential.
         
  
##Options

Motived：

```
fun get_ max(xs: int list) = 
    if null xs then 0
    else if null (tl xs) then hd xs
    else
	let val tl_ans = good_max(tl xs)
	in
	    if hd xs > tl_ans then hd xs
	    else tl_ans
    end
```

### Motivating Options

Having `max` return 0 for the empty list is really awful

- Could raise an exception

- Could return a zero-element or one-element list

	- That works but is poor style because the built-in support for options expresses this situation directly  

###Options

类似Swift中的optional

- `t option` is a type for any type t

	- (much like `t list`，but a different type, not a list)
	
- Building:

	- `NONE` has type `.a option` (much like[] has type `.a list`)
	
	- `SOME e` has type `t option` if `e` has type `t`(much like `e::[]`)
	
- Accessing:

	- `isSome`  has type `.a option -> bool`
	
	- `valOf` has type `.a option -> .a ` (exception if given NONE)
 
改写后的max方法

```
fun max1(xs:int list) = 
    if null xs then NONE
    else
	let val tl_ans = max1(tl xs)
	in if isSome tl_ans andalso valof tl_ans > hd xs
	   then tl_ans
	   else SOME(hd xs)
    end

```

 


## 1-13 More Boolean and Comparison Expressions


SOme "odds and ends" that haven't come up much yet:

- Combining Boolean expressions(and,or,not)
- Comparison operations

###Boolean operations
 
`e1 andalso e2` => "&&"

`e1 orelse e2` => "||"

`not e1` => "!"

###Comparisions

`= <> > < >= <=`


## 1.14 A Key Benefit of Immutable Data

### A valuable non-feature: no mutation

Have now covered all the features you need.

Now learn a very important *non-feature*:

- Huh??How could the lock of a feature be important?
	
- When it lets you know things other code will not do with your code and the results your code produces

A major aspect and contribution of functional programming:

Not being able to assign to (a.k.a. mutate) variables or parts of tuples and lists

***This is a Big Deal***	

意思是SML或者函数型语言在设计的时对数据的操作就是immutable的,这种看似的缺陷反而成了它的优点。

###Cannot tell if you copy

比较下面两个方法:

```
fun sort_pair (pr: int * int) = 

	if #1 pr < #2 pr then pr
	else (#2 pr, #1 pr)

```


```
fun sort_pair (pr: int * int) = 

	if #1 pr < #2 pr 
	then (#1 pr, #2 pr)
	else (#2 pr, #1 pr)

```

In ML, there two implementations of `sort_pair` are *indistinguishable*

- But only beacause tuples are immutable

- The first is better style: simpler and avoids making a new pair in the then-branch

- In langauges with mutable compound data, these are different!

从实现上看，这两种方法是有区别的，前者是直接返回了入参对象，后者则是新创建了一个`pr`的`copy`出来:

```
val p = (3,4)

val x = sort_pair p

val y = x


```

对于第一种情况，y是p的alias，对于第二种情况y是p的copy

但是对于使用者来说，在ML中这两种方法是没有区别的，因为ML中数据结构是immutable的，也就是说p无法改变自己的值。

因此无论是引用还是copy, 都不会影响y。

那么，如果ML是mutable的会怎么样呢?

假如：

```

//假如p中的value可以被修改，变为(5，4)
 #1 p = 5 
 
 val z = #1 y

```

那么 z的值是多少呢？

对于第一种情况，y是p的alias，那么z的值为5

对于第二种情况，y是p的copy，那么z的值仍为3

这样你就必须不停的去关注y是p的copy还是alias。

# chap2

## 2-1:Introduce to First-Class Function

### What is functional programming?

"*Functional Programming*" can mea a few different things:

- Avoid mutation in most cases

- Using functions as values

- ...

- Style encouraging recursion and recursive data structures

- Style closer to mathematical definitions

- Programming idioms using laziness

- Anything not OOP or C?(not a good definiation)

NOt sure a definiation of "functional language" exits beyond makes functional programming easy / default / required

- No clear yes/no for a particular language 


### First-class Functions

- First-Class functions: Can use them wherever we use values

- FUnctions are values too

- Arguments,results parts of tuples, bound to variable, carried by datatype constructors exceptions...

```
fun double x = 2*x

fun incr x = x+1

val a_tuple = (double,incr,double(incr 7))

val eighteen = (#1 a_tuple) 9

```

- Most common use is as an argument / result of another function

	- Other function is called a *higher-order-function*
	
	- Powerful way to factor out common functionality

### Function Closures

- Function closure: Functions can use bindings from outside the function defination(in scope where function is defined)

	- Makes first-class functions much more powerful
	
	- Will get to this feature in a bit, after simpler examples
	
- Distinction between terms first-class functions and function closure is not universally understood

	- Important conceptual distinction even if terms get muddled 


	
## 2-2 Functions As Arguments

- We can pass one function as an argument to another function 

	- Not a new feature,just never thought to do it before
	
	
	```
	fun f(g,...) = ...g(...)...
	fun h1 ... = ...
	fun h2 ... = ...
 	... f(h1,...) ... f(h2,...) ...
	
	```

- Elegant strategy for factoring out common code

	- REplace N similar functions with calls to 1 function where you pass in N different(short) functions as arguments. 


- 数学描述 : f(g(x))


## chap2-3 Polymorphic Types and Functions As Arguments

### The Key point

- HOF are often so "generic" and "reusable" that they have polymorphic types, i.e, types with type variables

- But there are HOF that are polymorphic

- ALways a good idea to understand the type of a a function, especially a HOF

### Types：

```


```
函数`n_times`的类型为:

- `val n_times = fn : ('a -> 'a) * int * 'a -> 'a`

	- 其中`'a`为泛型
	
	- fn的返回值类型要和n_times的返回值类型相同
	
	- 我们可以把`n_times`严格的限制成某一类型:`(int -> int) * int * int -> int`，但是这种限制没有意义
	
	- This *polymorphism* makes `n_times` more useful
	



## 2-4 Anonymous Functions


以这个函数为例：

```
fun n_times(f,n,x) = 
    if n=0 then x
    else f(n_times(f,n-1,x))
    
fun triple x = 3*x

fun triple_n_times(n,x) = n_times(triple,n,x)

val x3 = triple_n_times(2,3)

```

接下来的问题是如何将`triple`函数变为匿名函数代入到`n_times`中

- 使用`let-in-end`:

```
fun triple_n_times(n,x) = n_times(let triple x = x*3 in triple end ,n,x)


```

- 使用匿名函数:

```
fun triple_n_times(n,x) = n_times(（fn x => 3*x),n,x)

```
匿名函数只提供一个函数原型

- Like all expression forms, can appear anywhere

- Syntax:

	- `fn` not `fun`
	- `=>` not `=`
	- no function name,just argument pattern
	


### Using anonymous functions

- Most common use : Argument to a HOF

	- Don't need a name just to pass a function
	
- But : cannot use an anonymous function for a recursive function

	- Beacause there is no name for making recursive calls
	
	- If not for recursion, `fun`bindings would be syntactic sugar for `val` bindings and anonymous functions
	
	```
	fun triple x = 3 * x
	
	val triple = fn y => 3*y
	
	```
	第一个triple实际上是第二个triple的语法糖。
	
	同样，`triple_n_times`也可以写成这样，但是并不是一种好的表述方式
	```
	( * poor style * )
	fun triple_n_times(n,x) = fn(n,x) => n_times(（fn x => 3*x),n,x)

	
	```
	

	
## 2-5 Unnecessary Function Wrapping


看这个例子：

```ml

fun n_times(f,n,x) = 
    if n=0 then x
    else f(n_times(f,n-1,x))
    
fun nth_tail(n,xs) = n_times((fn y => tl y), n , xs)

```

根据上一节学到的，我们可以把`n_times`中的`f`用匿名函数代替:`fn y => tl y`

但是这种情况下使用匿名 函数是不正确的，正确的是:

```ml

fun nth_tail(n,xs) = n_times(tl, n , xs)

```

由于`fn y => tl y`表述的意思和`tl`一样，因此直接使用`tl`更有效率。

抽象来说当一个函数满足:

```ml

fn x => f x

```

不需要使用匿名函数，直接使用`f`，在看一个例子

```ml

fun rev xs = List.rev xs

val rev = fn xs => List.rev xs

val rev = List.rev

```

## 2-6 Map and Filter

###Map

```ml

fun map(f,xs) = 
    case xs of 
	 [] => []
      | x:xs' => (f,x)::map(f,xs') 


```
- map的类型为：

```ml

val map = fn : ('a -> 'b) * 'a list -> 'b list

```

- 使用map:

```ml

val result = map(fn x => x+1 , [1,2,3])

```

- Map is without doubt 是最有名的 HOF:
	
 - The name is standard 
	
 - You use it all the time once you know it: saves a little space,但是更找你更要的是，保持运算的连续性
	
 - Similar predefined function：`List.map`
 
 	- But it uses currying 


###Filter

```ml

fun filter(f,xs) = 
    case xs of 
	[] => []
     | x::xs' => if f x
                 then x::(filter(f,xs'))
		 else filter(f,xs')

```

- filter类型为：

```ml

val filter = fn : ('a -> bool) * 'a list -> 'a list

```

- 使用filter

```ml

val filter_result = filter(fn x => x>1,[1,2,3])

```

- Filter也是很有名的HOF


## 2-7 Generalizing Prior Topics

Our examples of first-class functions so far have all:

- Take one function as an argument to another function

- Processed a number or a list

But first-class functions are usefule anywhere for any kind of data

- Can pass serveral functions as arguments

- Can put functions in data structures

- Can return funtions as results

- Can wirte HOF that traverse your own data structures

Useful whenever you want to abstract over "What to compute with"

- No new language features


### Return function as result

```ml

fun double_or_triple f = 

	if f 7 
	then fn x => 2*x
	else fn x => 3*x

```

`double_or_triple`的签名为：`(* (int -> bool) -> (int -> int) * )`

使用：

```ml

val double = double_or_triple(fn x => x-3 = 4)

```

但是REPL输出的`double_or_triple`的签名为:`(* (int -> bool) -> int -> int * )`

Because it never prints uncessary parentheses and 

`t1->t2->t3->t4` 等价于 `t1 -> (t2 -> (t3 -> t4))`

## 2-8 Definition of Lexical Scope

- We know function bodies can use any bindings in scope

- But now that functions can be passed around: In scope where?

- This semantics is called `lexical scope`

- There are lots of good reasons for this semantics

	- Discussed after explaining what the semantics is 
	
	- Later in course: implementing it 
	
- Must "get this" for competent programming

将的是变量的作用域:

```ml

val x = 1

(* f maps to a function that adds 1 to its argument *)
fun f y = x + y

(* x maps to 2 , shadows 1 *)
val x = 2 

val y = 3

(* call the function defined on line2 with 5 *)
val z = f (x+y)

(* z maps to 6 *)

```
The semantics of functions has two parts:

- The `code` part

- The `environment` that was current when the function was defined

- This is a "pair" but unlike ML pairs, you cannot access the pieces

- All you do is call this "pair"

- This pair is called `function closure`

- A call evaluates the code part in the environment part


### coming up:

- demonstrate how the rule works with HOF

- why the other natural rule, dynamic scope is a bad idea

- powerful `idioms` with HOF use this rule

	- Passing functions to iterators like `filter`
	
	- Several more idims




## 2-9 Why lexical scope

- Lexical Scope : use environment where function is defined

- Dynamic Scope : use environment where function is called


Decades ago, both might have been considered reasonable, but now we know lexical scope makes much more sense


- Here are three reasions:

 - Function meaning does not depend on variable names used
 
 - Function can be type-checked and reasoned about where defined
 
 - Closures can easily store the data they need 
 
 
 ### Does dynamic scope exist?
 
 - Lexical scope for variables is definitely the right default
 
 	- Very common across languages
 	
 - Dynamic scope is occasionally convenient in some situations
 
 	- Some languages(e.g. Racket)have special ways to do it
 	
 	- BUt most do not bother
 	
 - if you squint some, exception handling is more like dynamic scope:
 
 	- `raise e` transfers control to the current innermost handler
 	
 	- Does not have to by syntactically inside a handl expression



## 2-10 Closure and Recomputation

### When things 

Things we know:

- A function body is not evaluated until the function is called

- A function body is evaluated every time the function is called

- A variable binding evaluates its expression when the binding is evaluated, not every time the variable is used.

With closures, this means we can avoid repeating computations that do not depend on function arguments

- Not so worried about performance but good example to emphasize the semantics of functions

这一节的Dan想表达的意思是: closure可以capture value，这个value可以只计算一次，这样就避免重复计算。

## 2-11 Fold and More Closure

### Another famous function: Fold

`fold`(and synonyms/close relatives reduce, inject,etc.) is another very famous iterator over recursive structures

Accumulates an answer by repeatedly applying `f` to answer so far

- `fold(f,acc,[x1,x2,x3,x4])` computes `f(f(f(f(acc,x1),x2),x3),x4)`

```ml

fun fold (f,acc,xs) = 
    case xs of [] => acc
	    | x::xs =>fold(f,f(acc,x),xs) 

```

- This version "folds left"; another version "folds right"
- Whether the direction matters depends on `f`(often not)

`fold`的签名为:

```ml

val fold = fn : ('a * 'b -> 'a) * 'a * 'b list -> 'a

```

### Why iterators again?

- These "iterator-like" functions are not build into the language
	
	- Just a programming pattern
	
	- Though many languages have built-in support, which often allows stopping early without resorting to exceptions

- This pattern separates recursive traversal from data processing

	- Can reuse same traversal for different data processing
	
	- Can reuse same data processing for different data structures
	
	- In both cases, using common vocabulary concisely communicates intent
	
这里Dan想表达的意思是：如果我们能抽象一个迭代器出来，那么对于复杂的数据结构，一个人可以复杂实现迭代器，另一个人可以实现复杂的计算，这两者均可复用。

- 数组求和：

```ml

fun f_sum xs = fold ((fn(x,y) => x+y), 0, xs)

val sum = f_sum [1,2,3]

```

### Iterators made better

- Function like `map,filter` and `fold` are much more powerful thanks to closures and lexical scope

- Function passed in can use any "private" data in its environment

- Iterator "doesn't event know the data is there" or what type it has

 
 
## 2-12 : Another Closure Idiom: Combining Functions

### More idioms

- We know the rule for lexical scope and function closures

	- Now what is it good for
	
A partial but wide-ranging list:

- Pass functions with private data to iterators: Done

- Combine functions(e.g., composition)

- Currying(multi-arg functions and partial application)

- Callbacks (e.g., in reactive programming)

- Implementing an ADT with a record of functions

### Combing Functions

Canonical example is function composition:

```
fun compose(f,g) = fn x => f(g x)

```

- Creates a closure that "remembers" what `f` and `g` are bound to

- 它的签名为:

```
val compose = fn : ('a -> 'b) * ('c -> 'a) -> 'c -> 'b

```

- 在ML中，这种function compose有特殊的符号表示:

```
f o g 表示 f (g x)

```

- 例子：

```
fun sqirt_of_abs i = Math.sqart (Real.fromInt (abs i ))

```
也可以写成:

```
fun sqrt_of_abs i = ( Math.sqrt o Real.fromInt o abs ) i

```

### Left-to-right or right-to-left

```
val sqrt_of_abs  =  Math.sqrt o Real.fromInt o abs 

```

As in math, function composition is "right to left"

- "take absolute value, convert to real, and take square root"

- "square root of the conversion to real of absolute value"

"Pipelines" of functions are common in functional programming and many programmers prefer left-to-right

 
## 2-13:Another Closure Idiom:Currying

###Currying

- Recall every ML function takes exactly one argument

- Previously encoded `n` arguments via one `n-tuple`

- Another Way: Take one argument and return a function that takes another argument and ...

	- Called "currying" after famous logican Haskell Curry
	
	
	
- 之前处理多个入参的方式使用tuple：
	
```
fun sorted3_tupled (x,y,z) = z >= y andalso y >= x

val t1 = sorted3_tupled(7,9,11)

```
- 引入currying:

```
val sorted3 = fn x => fn y => fn z => z >=y andalso y >= x

fun sorted x = fn y => fn z => z >= y andalso y>=x 

```

```
val t2 = (((sorted3 7) 9) 11)

```

- Calling (sorted3 7) returns a closure with:
	
	- Code `fn y => fn z => z >= y andalso y>= x`
	- Environment maps `x` to `7`
	
- Calling that closure with 9 returns a closure with

	- Code `fn z => z>=y andalso y >= x`
	- Environment maps `x` to `7`, `y` to `9`
	
- Calling that closure with `11` returns `true`


### Syntactic sugar, part1

```
val t2 = (((sorted3 7) 9) 11)

```

- In general , e1, e2, e3, e4, ... means (((e1, e2), e3), e4,)

- So instead of `(((sorted3 7) 9) 11)` can just write `sorted3 7 9 11`

- Callers can just think "multi-argument function with spaces instead of tuple expression"

	- Different than tupling; caller and callee must use same technique


- Wrong:

```
val wrong1 = sorted3_tupled 7 9 11
val wrong2 = sorted3 (7,9,11)

```

### Syntactic sugar, part2

```
val sorted3_old = fn x => fn y => fn z => z >=y andalso y >= x

fun sorted3_nicer x y z = z >= y andalso y >= x

val t4 = sorted3_nicer 7 9 11

val t5 = (((sorted3_nicer 7) 9 ) 11)

```

## 2-14: Partial Application

### Too Few Arguments

- Previously used currying to simulate multiple arguments
 
- But if caller provides "too few" arguments, we get back a closure "waiting for the remaining arguments"

	- Called partial application
	
	- Convenient and useful
	
	- Can be done with any curried function
	
- No new semantics here: a pleasant idiom

- 例子:

```

val sum_partial = fold (fn (x,y) => x+y) 0 

```

上面这个例子：`fold`应该有三个参数: 一个算数表达式，一个初始值，一个数组，显然上面的`sum`缺一个参数，这也成了一个好处，相当于`sum`只接受一个数组参数:

```
val sum_partial = fn : int list -> int

```

使用`sum_partial`更方便:

```
val sum_value = sum_partial [1,2,3]

```

另一个例子:

```

fun exist f xs = 
	case xs of 
		[] => false
		| x::xs => f x orelse exist f xs

```

```
val no = exist (fn x => x=7) [4,11,23]

val hasZero = exist (fn x => x=0 )

```


## 2-15 : Currying Wrapup

### More combining functions

- What if you want to curry a tupled function or vice-versa

- What if a function's arguments are in the wrong order for the partial application you want?

Naturally, it is easy to write higher order wrapper functions

- And their types are neat logical formulas


将的时对于一些参数不满足要求的函数，如何使用curry使其满足条件:

- 例子：

```
fun range (i,j) = if i>j then [] else i :: range(i+1,j)

```

如果这么调用:

```

val countup = range 1 

```
肯定是不满足条件的，入参不是tuple，这种情况我们可以使用curry function：

先定义个curry 函数:

```
fun curry f = fn x => fn y => f (x,y)

```

根据语法糖，展开为:

```
fun curry f x y  = f (x,y)

```

这时将`countup`函数改写为:

```
val countup = curry range 1 

val xs = countup 7 (* [1,2,3,4,5,6,7] * )

```

同样我们可以定义`uncurry`

```
fun uncurry f (x,y) = f x y

```

### Efficiency

So which is faster: tupling or currying multiple-arguments?

- They are both constant-time operations, so it doesn't matter in most of your code

- For the small part where efficiency matters:

	- It turns out SML/NJ compiles tuples more efficiently
	
	- But many other FP implementation do better with currying(OCaml, F#, Haskell)
	
		- So currying is the "normal thing" and programmers read `t1->t2->t3->t4` as a 3-argument function that also allows partial applications.



## 2-16 : Mutation

### ML has(separate) mutation

- Mutable data sturcture are okay in some situations

	- When "update to the state of world" is appropriate moel
	
	- But want most language constructs truly immutable
	
- ML does this with a separate construct: references


### References

- New types: `t ref` where `t` is a type

- New expressions:

	- `ref e` to create a reference with initial contents `e` 指针
	
	- `e1 := e2` to update contents 赋值
	
	- `!e` to retrieve contents 取值


### Reference example

```
val x = ref 42
val y = ref 42
val z = x
val _ = x := 43
val w = (!y) + (!z) （* 85 * ）

```

- x binds to 一个指向42的指针，因此，x+1会报错，因为x的类型是 `int ref`即int型指针

- x 自身的值是不可以改变的


## 2-17 : Callbacks

### Callbacks

A common idiom: Library takes functions to apply later, when an event occurs - examples：
	
- When a key is pressed, mouse moves, data arrives...
	
- When the program enters some state
	
A library may accept multiple callbacks

- Different callbacks may need different private data with different types

- Fortunately, a function's type does not include the types of bindings in its environment

- (In OOP,objects and private fields are used similiaryly, e.g, Java Swing's event-listeners) 

### Mutable State

We really do want the "callbacks registered" to change when a function to register a callback is called

### Example call-back library

Library maintains mutable state for "What callbacks are there" and provides a function for accpting new ones

- A real library would all support removing them,etc.

- In example, callbacks have type `int -> unit` 

So the entire public library interface would be the function for registering new callbacks:

```
val onKeyEvent : (int -> unit) -> unit

```

unit 是无用的返回值

Because callbacks are executed for side-effect, they may also need mutable state


### Library implementation

关于callback的实现


## 2-18 : Standard-Library Doc

ML, like many languages, has a standard library

- For things you could not implement on your own
	
	- Examples: Opening a file, setting a timer
	
- For things so common, a standard definition is appropriate

	- Examples: `List.map`, string concatentation
	
- Where to look: http://www.standardml.org/Basis/manpages.html
	

## 2-19 : Implementing ADT using closure

略

## 2-20 : Closure idioms without Closures

### Higher order programming

- HOF e.g: with `map` and `filter` , is great

- Without closures, we can still do it more manually

	- In OOP (e.g., Java) with one-method interfaces
	
	- In procedural(e.g., C)with explicit environment arguments
	
- Working through this:

	- Shows connections between languages and features
	
	- Can help you understand closures and objects

如何在Java/C中实现closure

### Outline

- This segment:

	- Just the code we will "port" to Java or C

	- Not using statndard library 

- Next segments:

	- The code in Java and C
	
	- What works well and what is painful



## 2-21 : Closure in Java

### Java

- Java 8 scheduled to have closures(like C#, Scala, Ruby)

	- Write like `xs.map((x) => x.age).filter((x) => x>21).length()`
	
	- Make parallelism and collections much easier
	
	- Encourage less mutation
	
- But how could we program in an ML style without help

	- Will not look like the code above
	
	- Was even more painful before Java had generics 
	
### One-method interfaces

```
interface Func<B,A> { B m(A x); }

interface Pred<A> { boolean m(A x); }

```

- An interface is a named type

- An object with one method can serve as a closure

	- Different instances can have different fields (possibly different types) like different closures can have different environments(possibly different types)
	
- So an interface with one method can serve as a function type


## 2-22 : Closure in C


略

# Chap3

## 3-0 Course Motivation

- Why learn the fundamental concepts that appear in all languages?

- Why use languages quite different from C, C++, Java, Python?

- Why focus on functional programming?

- Why use ML, Racket, and Ruby in particular?

### Caveats

Will give some of my reasons in terms of this course

- My reasons: more personal opinion than normal lectures

	- Other may have equally valid reasons
	
- Partial list: surely other good reasons

- In term of course: Keep discussion informal

	- Not rigorous proof that all reasons are correct
	
- Will not say one language is "better" than other

### Summary

- No such thing as a "best" PL

- Fundamental concepts easier to teach in some PLs

- A good PL is a relevant, elegant interface for writing software 

	- There is no substitute for precise understanding of PL semantics
	
- Functional languages have been on the leading edge for decades

	- Ideas have been absorbed by the mainstream, but very slowly
	
	- First-class functions and avoiding mutation increasingly essential
	
	- Meanwhile, use the ideas to be a better C/Java/PHP hacker
	
- Many great alternatives to ML, Racket, and Ruby, but each was chosen for a reason and for how they complement each other. 


## 3-1 Why Study General PL Concepts


- Semantics:

	- Correct reasoning about programs, interfaces, and compilers requires a precise knowledge of semantics
	
		- Not "I feel...."
		- Not "I like curly braces more than parenthses"
		- Much of software development is designing precise interfaces;
		
- Idioms make you a better programmer

	- Best to see in multiple settings, including where they shine
	
	- See Java in a clearer light even if I never show you Java


## 3-2 Are All PLs the Same?


- Yes
	
	- Any input-output behavior implementable in language X is implementable in language Y [Church-Turing thesis]
	
	- Java, ML, and a language with one loop and three infinitely-large integers are the same
	
- Yes:

	- Same fundamentals reappear: variables, abstraction, one-of types, recursive definitions...
	
- No:

	- The human condition vs. different cultures(trave to learn more)
	
	- The default in one language is awkward in another 
	
	- Beware "the Turing tarpit"
	

## Why FP?

Why spend 60%-80% of course using FP:

- mutation is dicouraged

- HOF are very convenient

- One of types via constructs like datatypes

Because:

- These features are invaluable for correct, elegant, efficient

- Functional languages have always been ahead of their time

- Functional languages well-suited to where computing is going



### Ahead of their time

All these were dismissid as "beautiful, worthless, slow things PL professors make you learn"

- Garbage collection(Java didn't exist in 1995, PL courses did)

- Generics(`List<T>` in Java, `C#`), much more like SML than C++

- XML for universal data representation(like Racket/Scheme/LISP/...)

- HOF(Ruby,Javascript,C#...)

- Type inference(C#,Scala...)

- Recursion(a big fight in 1960 about this - I'm told)

- ...


### The future may resemble the past

Somehow nobody notices we are right ... 20 years later

- "To conquer" vs. "to assimilate"

- Societal progress takes time and muddles "take credit"

- Maybe pattern-matching, currying, hygienic macros, etc. will be next


### Recent Surge part1

- Clojure

- Erlang

- F#

- Haskell

- OCaml

- Scala

In general , see http://cufp.org

### Recent Surge part2

Popular adoption of concepts:

- C#, LINQ (closures, type inference,...)

- Java 8 (closures)

- MapReduce / Hadoop

	- Avoiding side-effects essential for fault-tolerance here
	
- ..

### Why a surge?

My best guesses:

- Concise, elegant, productive programming

- Javascript, Python, Ruby helped break the Java/C/C++ hegemony

- Avoiding mutation is the easiset way to make concurrent and parallel programming easier

	- In general, to handle sharing in complex systems
	
- Sure, functional programming is still a small niche, but there is so much software in the world today even niches have room


## Why ML,Racket,Ruby?

### The languages together

SML, Racket, and Ruby are a useful combination for us

|  | dynamically typed | statically typed |
| ------------ | ------------- | ------------ |
| functional | Racket  | SML |
| object-oriented | Ruby | Java/C#/Scala|

- ML: polymorphic types, pattern-matching, abstract types & modules

- Racket : dynamic typing, "good" macros, minimalist syntax, eval

- Ruby: classes but not types, very OOP, mixins

- ...


Really wish we had more time:

- Haskell: laziness, purity, type classes, monads

- Prolog: unification and backtracking

- ...

### But why not...

Instead of SML, could use similar languages easy to learn after:

- OCaml: yes indeed but would have to port all my materials

	- And a few small things...
	
- F#: yes and very cool, but needs a .Net platform

	- And a few more small things...
	
- Haskell: more popular, cooler types, but lazy semantics and type classes from day 1

Admittedly, SML and its implementations are showing their age, but it still makes for a shine foundation in statically typed , eager functional programming


Instead of Racket, could use similar languages easy to learn after:

- Scheme, List, Clojure,...

Racket has a combination of 

- A modern feel and active evolution

- "Better" macros, modules, structs, constracts,...

- A large user base and community(not just for education)

- An IDE tailored to education

Could easily define our own language in the Racket system

- Would rather use a good and vetted design

Instead of Ruby, could use another language:

- Python,Perl, Javascript are also dynamically typed, but are not as "fully" OOP, which is what I want to focus on 

	- Python also does not have closures
	
	- Javascript also does not have classes but is OOP
	
- Smalltalk serves my OOP needs

	- But implementation merge language / environment
	
	- Less modern syntax, user base, etc


###Is this real programming?

- The way we use ML/Racket/Ruby can make them seem almost "silly" precisely because lecture and homework focus on insteresting langaguge constructs


- "Real" programming needs IO, string operations, floating-point, graphics, project managers, testing framework, threads, build systems...

	- Many elegant languages have all that and more
	
		- Including Racket and Ruby
		
	- If we used Java the same way, Java would seem "silly" too




# Chap4

## 4-0: Remaining ML Topics

### Remaining Topics:

- Type Inference

- Mutual Recursion

- Module System

- Equivalence

## 4-1: Type Inference

### Type-checking

- (Static)type-checking can reject a program before it runs to prevent the possibility of some errors

	- A feature of statically typed languages
	
- Dynamically typed languages do little such checking 

	- So might try to treat a number as a function at run-time
	
- Will study relative advantages after some Racket

	- Racket, Ruby (Python, Javascript...) dynamically typed
	
- ML(and Java,C#,Scala,C,C++)is statically typed

	- Every binding has one type, determined "at complie-time"


### Impicitly typed

- ML is statically typed

- ML is implicitly typed: rarely need to write down types

```
fun f x =  (* infer val f : int -> int *)
	
	if x > 3
	then 42
	else x * 2

```

- Statically typed: Much more like Java than Javascript


### Type infernce

- Type inference problem: Give every binding/expression a type such that type-checking succeeds

	- Fail if and only if no solution exists
	
- In principle, could be a pass before the type-checker

	- But often implemented together
	
- Type inference can be easy, difficult or impossible

	- Easy: Accept all programs
	
	- Easy: Reject all programs
	
	- Subtle, elegant, and not magic: ML



## 4-1 ML Type Inference











#Chap 5: Summary of SML




















































