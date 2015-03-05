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