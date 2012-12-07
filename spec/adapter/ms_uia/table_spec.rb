require 'spec_helper'

describe "MsUia::Table", :if => SpecHelper.adapter == :ms_uia do
  before :each do
    window = RAutomation::Window.new(:title => "MainFormWindow")
    window.button(:value => "Data Entry Form").click { RAutomation::Window.new(:title => "DataEntryForm").exists? }
  end

  it "#table" do
    table = RAutomation::Window.new(:title => "DataEntryForm").table(:id => "personListView")
    table.should exist
    
    RAutomation::Window.wait_timeout = 0.1
    expect {RAutomation::Window.new(:title => "non-existent-window").
            table(:class => /SysListView32/i)}.
            to raise_exception(RAutomation::UnknownWindowException)
  end

  it "check for table class" do
    RAutomation::Window.new(:title => "DataEntryForm").table(:id => "deleteItemButton").should_not exist
    RAutomation::Window.new(:title => "DataEntryForm").table(:id => "personListView").should exist
  end

  it "#strings" do
    table = RAutomation::Window.new(:title => "MainFormWindow").table(:id => "FruitListBox")

    table.strings.should == ["Apple", "Orange", "Mango"]
  end

  it "#strings with nested elements" do
    table = RAutomation::Window.new(:title => "DataEntryForm").table(:id => "personListView")

    table.strings.should == [
        ["Name", "Date of birth", "State"],
        ["John Doe", "12/15/1967", "FL"],
        ["Anna Doe", "3/4/1975", ""]
    ]
  end

  it "#select" do
    table = RAutomation::Window.new(:title => "DataEntryForm").table(:id => "personListView")

    table.select(1)
    table.should_not be_selected(2)

    table.select(2)
    table.should be_selected(2)
  end

  it "#row_count" do
    table = RAutomation::Window.new(:title => "DataEntryForm").table(:id => "personListView")
    table.row_count.should eq(2)
  end

  context "#rows", :focus => true do
    let(:table) { RAutomation::Window.new(:title => "DataEntryForm").table(:id => "personListView") }

    it "has rows" do
      table.rows.size.should eq 2
    end

    it "have values" do
      table.rows.map(&:value).should eq ["John Doe", "Anna Doe"]
    end

    it "values are also text" do
      table.rows.map(&:text).should eq ["John Doe", "Anna Doe"]
    end
  end

end

