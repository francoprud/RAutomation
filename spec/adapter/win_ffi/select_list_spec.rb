require 'spec_helper'

describe "WinFfi::SelectList", :if => SpecHelper.adapter == :win_ffi do
  before :each do
    window = RAutomation::Window.new(:title => "MainFormWindow")
    RAutomation::WaitHelper.wait_until {window.present?}
  end

  it "select list exists" do
    RAutomation::Window.new(:title => "MainFormWindow").select_list(:class => /COMBOBOX/i).should exist
  end

  it "gets number of items" do
    select_list = RAutomation::Window.new(:title => "MainFormWindow").select_list(:class => /COMBOBOX/i)
    select_list.item_count.should == 5
  end

  it "retrieves options" do
    select_list = RAutomation::Window.new(:title => "MainFormWindow").select_list(:class => /COMBOBOX/i)
    expected_options = [ "Apple", "Caimito", "Coconut", "Orange", "Passion Fruit" ]

    select_list.options.size.should == 5

    select_list.options.each do |value|
        fail "#{value.text} is not part of the expected list" unless expected_options.include? value.text
    end
  end

  it "checks if option is selected" do
    select_list = RAutomation::Window.new(:title => "MainFormWindow").select_list(:class => /COMBOBOX/i)

    select_list.options(:text => "Apple")[0].should_not be_selected

    select_list.options(:text => "Apple")[0].select.should be_true

    select_list.options(:text => "Apple")[0].should be_selected
  end

  it "#value" do
    select_list = RAutomation::Window.new(:title => "MainFormWindow").select_list(:class => /COMBOBOX/i)

    #default empty state
    select_list.value.should == ""

    select_list.options(:text => "Apple")[0].select
    select_list.value.should == "Apple"

    select_list.options(:text => "Caimito")[0].select
    select_list.value.should == "Caimito"
    select_list.value.should_not == "Apple"

    select_list.options(:text => "Orange")[0].select
    select_list.value.should == "Orange"
    select_list.value.should_not == "Caimito"
    select_list.value.should_not == "Apple"
  end

end