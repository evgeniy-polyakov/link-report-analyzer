package com.epolyakov.linkreportanalyzer.ui.event
{
	import com.epolyakov.linkreportanalyzer.data.Definition;

	import flash.events.Event;

	/**
	 * @author epolyakov
	 */
	public class DefinitionEvent extends Event
	{
		private var _definition:Definition;


		public function DefinitionEvent(type:String, definition:Definition, bubbles:Boolean = false,
										cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			_definition = definition;
		}

		public function get definition():Definition
		{
			return _definition;
		}

		override public function clone():Event
		{
			return new DefinitionEvent(type, definition, bubbles, cancelable);
		}
	}
}