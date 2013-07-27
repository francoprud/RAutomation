﻿using System.Collections.Generic;
using System.Linq;
using System.Windows.Automation;

namespace RAutomation.UIA
{
    public class TabControl
    {
        private readonly AutomationElement _element;

        public TabControl(AutomationElement element)
        {
            _element = element;
        }

        public string[] TabNames
        {
            get { return TabItems.Select(x => x.Current.Name).ToArray(); }
        }

        public string Selection
        {
            get { return TabItems.First(x => x.AsSelectionItem().Current.IsSelected).Current.Name; }
            set { TabItems.First(x => x.Current.Name == value).AsSelectionItem().Select(); }
        }

        public int SelectedIndex
        {
            get { return SelectionItems.IndexOf(x => x.Current.IsSelected); }
            set { SelectionItems.ElementAt(value).Select(); }
        }

        private IEnumerable<AutomationElement> TabItems
        {
            get { return _element.Find(IsTabItem); }
        }

        private IEnumerable<SelectionItemPattern> SelectionItems
        {
            get { return TabItems.AsSelectionItems(); }
        }

        private static Condition IsTabItem
        {
            get { return new PropertyCondition(AutomationElement.ControlTypeProperty, ControlType.TabItem); }
        }
    }
}