module parse.nodes.node;
public import std.conv;
public import std.stdio;
public import lex.token;


/**
* Represents a node of the AST.
*/
class Node
{
	///The position of the node
	TokenLocation location;

	/**
	* Prints out a representation of a node.
	* Used in debugging to make sure that precedence was matched correctly.
	*/
	void print()
	{

	}
}