module parser.nodes.node;
import lexer.token;
import semantic.info;
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
}