module parse.node;
import std.conv;

/**
* Represents a node of the AST.
*/
class Node
{
	
}

class BlockNode : Node
{
	Node[] stmts;

	this(Node[] stmts)
	{
		this.stmts = stmts;
	}
}

class IfNode : Node
{
	Node cond;
	Node stmt;

	this(Node cond, Node stmt)
	{
		this.cond = cond;
		this.stmt = stmt;
	}
}

class WhileNode : Node
{
	Node cond;
	Node stmt;

	this(Node cond, Node stmt)
	{
		this.cond = cond;
		this.stmt = stmt;
	}
}

class BinaryNode : Node
{
	Node left;
	Node right;

	this(Node left, Node right)
	{
		this.left = left;
		this.right = right;
	}	
}

class AndNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}	
}

class OrNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}	
}

class XorNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}	
}

class EqualsNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}	
}

class GtNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}	
}

class LtNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}	
}

class GteNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}	
}

class LteNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}	
}

class AddNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}	
}

class SubNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}	
}

class MulNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}	
}

class DivNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}	
}

class ModNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}	
}

class AssignNode : BinaryNode
{
	this(Node left, Node right)
	{
		super(left, right);
	}	
}

class IdentNode : Node
{
	string ident;
	this(string ident)
	{
		this.ident = ident;
	}	
}

class NumNode : Node
{
	double num;
	this(string num)
	{
		this.num = to!double(num); 
	}	
}

class StringNode : Node
{
	string str;
	this(string str)
	{
		this.str = str;
	}	
}

class NotNode : Node
{
	Node right;
	this(Node right)
	{
		this.right = right;
	}	
}