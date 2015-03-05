package com.epolyakov.linkreportanalyzer.ui.controls.filters
{
	import com.epolyakov.linkreportanalyzer.data.Definition;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author epolyakov
	 */
	public class DependencyFilter extends EventDispatcher implements ITextFilter
	{
		private var _showExternals:Boolean = false;
		private var _textFilter:String = "";

		private static const event:Event = new Event(Event.CHANGE);

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

		public function testDefinition(definition:Definition, root:Definition):Boolean
		{
			if (definition.id)
			{
				if (root.isPackage && definition.id.indexOf(root.id + ":") == 0)
				{
					return false;
				}
				if (_textFilter && definition.id.indexOf(_textFilter) < 0)
				{
					return false;
				}
				if (definition.isExternal)
				{
					return _showExternals;
				}
				return true;
			}
			return false;
		}
	}
}