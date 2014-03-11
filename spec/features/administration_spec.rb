require 'spec_helper'

describe 'Administration' do
  context "Report" do 
    let(:resource_class) { Report }
    let(:all_resources)  { ActiveAdmin.application.namespaces[:admin].resources }
    let(:resource)       { all_resources[resource_class] }

    it "should has resource name Report" do
      resource.resource_name.should == "Report"
    end

    it "it should be included in menu" do
      resource.should be_include_in_menu
    end

    it "should have actions" do
      resource.defined_actions.should =~ [:create, :new, :update, :edit, :index, :show, :destroy]
    end
  end
end