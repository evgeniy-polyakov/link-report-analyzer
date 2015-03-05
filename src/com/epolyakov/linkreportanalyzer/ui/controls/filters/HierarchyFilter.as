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
package com.epolyakov.linkreportanalyzer.ui.controls.filters
{
	import com.epolyakov.linkreportanalyzer.data.Definition;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author epolyakov
	 */
	public class HierarchyFilter extends EventDispatcher implements ITextFilter
	{
		private var _isTree:Boolean = false;
		private var _showPackages:Boolean = true;
		private var _showDefinitions:Boolean = true;
		private var _showExternals:Boolean = false;
		private var _hierarchyLevel:int = int.MAX_VALUE;
		private var _textFilter:String = "";

		private static const event:Event = new Event(Event.CHANGE);

		[Bindable(event='change')]
		public function get isTree():Boolean
		{
			return _isTree;
		}

		public function set isTree(value:Boolean):void
		{
			if (_isTree != value)
			{
				_isTree = value;
				dispatchEvent(event);
			}
		}

		[Bindable(event='change')]
		public function get showPackages():Boolean
		{
			return _showPackages;
		}

		public function set showPackages(value:Boolean):void
		{
			if (_showPackages != value)
			{
				_showPackages = value;
				dispatchEvent(event);
			}
		}

		[Bindable(event='change')]
		public function get showDefinitions():Boolean
		{
			return _showDefinitions;
		}

		public function set showDefinitions(value:Boolean):void
		{
			if (_showDefinitions != value)
			{
				_showDefinitions = value;
				dispatchEvent(event);
			}
		}

		[Bindable(event='change')]
		public function get showExternals():Boolean
		{
			return _showExternals;
		}

		public function set showExternals(value:Boolean):void
		{
			if (_showExternals != value)
			{
				_showExternals = value;
				dispatchEvent(event);
			}
		}

		[Bindable(event='change')]
		public function get hierarchyLevel():int
		{
			return _hierarchyLevel;
		}

		public function set hierarchyLevel(value:int):void
		{
			if (_hierarchyLevel != value)
			{
				_hierarchyLevel = value;
				dispatchEvent(event);
			}
		}

		[Bindable(event='change')]
		public function get textFilter():String
		{
			return _textFilter;
		}

		public function set textFilter(value:String):void
		{
			if (_textFilter != value)
			{
				_textFilter = value;
				dispatchEvent(event);
			}
		}

		public function testDefinition(definition:Definition):Boolean
		{
			if (definition.id)
			{
				if (definition.level > _hierarchyLevel)
				{
					return false;
				}
				if (_textFilter && definition.id.indexOf(_textFilter) < 0)
				{
					return false;
				}
				if (definition.isExternal && definition.isPackage)
				{
					return _showExternals && _showPackages;
				}
				if (definition.isExternal && !definition.isPackage)
				{
					return _showExternals;
				}
				if (!definition.isExternal && definition.isPackage)
				{
					return _showPackages;
				}
				return _showDefinitions;
			}
			return false;
		}
	}
}