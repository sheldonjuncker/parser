module parser.nodes.node;
import lexer.token;
import semantic.info;
public import semantic.environment;
public import semantic.exception;
public import semantic.type;
public import semantic.value;
import std.stdio;

/**
* Represents a node of the AST.
*/
class Node
{
	///The location of the node
	TokenLocation location;

	///Semantic info about the node
	SemanticInfo semInfo;

	/**
	* Constructs the node.
	*/
	this()
	{
		semInfo = new SemanticInfo;
	}

	/**
	* Writes anything with the correct number of tabs
	*/
	void writeTabs(T)(T arg, int tabs = 0)
	{
		while(tabs--)
		{
			write("\t");
		}
		write(arg);
	}
	
	/**
	* Prints out a representation of a node.
	* Used in debugging to make sure that precedence was matched correctly.
	*/
	void print(int tabs=0)
	{
		
	}

	/**
	* Calls a function on each node in the AST.
	*/
	void each(void function(ref Node) action)
	{

	}

	/**
	* Determines if a node is a Null node.
	*/
	bool isNull()
	{
		return false;
	}

	/*
	*	The following method deal with semantic stuff:
	*	void analyzeVariables() -- does semantic analysis on variables
	*	bool isLvalue() -- determines if a node is an lvalue
	*	void addUse() -- increments the times the variable is used
	*/

	/**
	*	Analyzes variables for semantic correctness.
	*	See semantic analyzer for more details.
	*/
	void analyzeVariables(Environment e)
	{

	}

	/**
	* Determines if a node is an lvalue.
	*/
	bool isLvalue()
	{
		return false;
	}

	/**
	* Increments the number of times a node is used.
	* Used for local variables.
	*/
	void addUse(Environment e)
	{

	}


	/*
	*	The following methods deal with optimizing stuff
	*	isStatic() -- determines if a node's value can be known
	*	at compile time
	*	hasEffect() -- determines whether a node has any effect
	*/

	/**
	* Determines if a node's value can be computed at compile time.
	*/
	bool isStatic()
	{
		return false;
	}

	/**
	* Computes the value of a node if known at compile time.
	* Returns a node that can be used to replace the node being analyzed.
	* Example: AddNode(NumNode, NumNode) --> SemanticValue.value.num
	*/
	SemanticValue computeStaticValue()
	{
		return null;
	}

	/**
	* Determines if a node will have any effect.
	* For example, these statements have no effect:
	* 	5 + 5 * 5 / 5;
	*	if(0) { writeln("Hello, world!"); }
	*/
	bool hasEffect()
	{
		return true;
	}
}