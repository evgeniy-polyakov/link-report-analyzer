package com.epolyakov.linkreportanalyzer.ui.controls.tree
{
	/**
	 * @author epolyakov
	 */
	public class HierarchyTreeNode
	{
		public var id:String;
		/**
		 * Unique identifier in the tree
		 * @see UIDUtil
		 */
		public var uid:String;
		public var name:String;
		public var icon:Class;
		public var external:Boolean;

		public static var filtered:Object = {};

		internal var _children:Array;
		private var _filteredChildren:Array;

		public function get children():Array
		{
			if (_children)
			{
				return _children.filter(filter);
			}
			return null;
		}

		private static function filter(node:HierarchyTreeNode, ...args):Boolean
		{
			return filtered[node.id];
		}
	}
}