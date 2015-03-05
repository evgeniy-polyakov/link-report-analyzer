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
package com.epolyakov.linkreportanalyzer.ui.controls.grid
{
	import com.epolyakov.linkreportanalyzer.ui.controls.filters.ITextFilter;

	import flash.text.engine.TextLine;

	[Style(name="filterSelectionColor", type="uint", format="Color")]

	/**
	 * @author epolyakov
	 */
	public class FilteredGridItemRenderer extends StringGridItemRenderer
	{
		public var filter:ITextFilter;

		override public function validateNow():void
		{
			super.validateNow();

			if (!parent)
			{
				return;
			}

			graphics.clear();

			if (data && filter && numChildren > 0)
			{
				const subString:String = filter.textFilter;
				const textLine:TextLine = getChildAt(0) as TextLine;
				if (subString && textLine)
				{
					const index:int = label.indexOf(subString);
					if (index >= 0)
					{
						const startAtomIndex:int = textLine.getAtomIndexAtCharIndex(index);
						const endAtomIndex:int = textLine.getAtomIndexAtCharIndex(index + subString.length - 1);
						if (startAtomIndex >= 0 && endAtomIndex >= 0)
						{
							const offset:int = 2;
							const left:Number = textLine.getAtomBounds(startAtomIndex).left + offset;
							const right:Number = textLine.getAtomBounds(endAtomIndex).right + offset;

							graphics.beginFill(getStyle("filterSelectionColor"));
							graphics.drawRect(left, 0, right - left, height);
							graphics.endFill();
						}
					}
				}
			}
		}
	}
}