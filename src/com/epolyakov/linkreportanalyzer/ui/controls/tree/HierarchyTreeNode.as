/**
 Copyright 2014 Evgeniy Polyakov

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */
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