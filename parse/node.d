module parse.node;

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