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