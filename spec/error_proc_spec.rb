# coding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe 'Rails field_error_proc' do
  
  include FormtasticSpecHelper
  
  before do
    @output_buffer = ''
    mock_everything
  end
  
  it "should not be overridden globally for all form builders" do
    
    # need to set this to a known proc before we start in case another spec has left
    # this in a dirty state
    current_field_error_proc = ::ActionView::Base.field_error_proc = proc {}
    
    semantic_form_for(@new_post) do |builder|
      ::ActionView::Base.field_error_proc.should_not == current_field_error_proc
    end
    
    ::ActionView::Base.field_error_proc.should == current_field_error_proc
    
    form_for(@new_post) do |builder|
      ::ActionView::Base.field_error_proc.should == current_field_error_proc
    end
  end
  
end