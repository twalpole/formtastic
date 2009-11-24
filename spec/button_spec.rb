# coding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe 'SemanticFormBuilder#button' do
  
  include FormtasticSpecHelper
  
  before do
    @output_buffer = ''
    mock_everything
  end
  
  describe "unknown :as option" do
    it "should raise error" do
      [:commit, :cancel, :submit].each do |kind|
        @output_buffer = ''
        lambda {
          semantic_form_for(@new_post) do |builder|
            concat(builder.button(kind, :as => :not_allowed))
          end
        }.should raise_error(ArgumentError)
      end
    end
  end
  
  describe "unknown kind" do
    it "should raise error" do
      @output_buffer = ''
      lambda {
        semantic_form_for(@new_post) do |builder|
          concat(builder.button(:not_commit_cancel_or_reset))
        end
      }.should raise_error(ArgumentError)
    end
  end
  
  describe ":commit" do
    
    describe "without :as option" do
      
      it "should render as :pretty by default" do
        @output_buffer = ''
        semantic_form_for(@new_post) do |builder|
          builder.should_receive(:pretty_button)
          concat(builder.button(:commit))
        end
      end
      
    end
        
    describe ":as => :pretty" do
      before do
        @output_buffer = ''
        semantic_form_for(@new_post) do |builder|
          builder.buttons do
            concat(builder.button(:commit, :as => :pretty))
          end
        end
      end
      
      it "should render an li.commit.pretty" do
        output_buffer.should have_tag('li.commit.pretty')
      end
  
      it "should render a button[type=submit]" do
        output_buffer.should have_tag('li button[@type="submit"]')
      end
  
      it "should render a button with text" do
        output_buffer.should have_tag('li button', /Create/)
      end
      
      it "should render an img" do
        output_buffer.should have_tag('li button img')
      end
      
      it "should use the default commit accesskey" do
        with_config :default_commit_button_accesskey, 'z' do
          semantic_form_for(@new_post) do |builder|
            builder.buttons do
              concat(builder.button(:commit, :as => :pretty))
            end
          end
          output_buffer.should have_tag('button[@accesskey="z"]')
        end
      end
      
      describe "with :wrapper_html" do
        before do
          semantic_form_for(@new_post) do |builder|
            builder.buttons do
              concat(builder.button(:commit, :as => :pretty, :wrapper_html => { :id => "foo", :class => "bah" }))
            end
          end
        end
        
        it "should use the custom wrapper id" do
          output_buffer.should have_tag("li#foo")
        end
        
        it "should add the custom class to existing classes" do
          output_buffer.should have_tag("li.bah")
          output_buffer.should have_tag("li.commit.pretty.bah")
        end
      end
      
      describe "with :button_html" do
        before do
          semantic_form_for(@new_post) do |builder|
            builder.buttons do
              concat(builder.button(:commit, :as => :pretty, :button_html => { :id => "foo", :class => "bah", :accesskey => "s" }))
            end
          end
        end
        
        it "should use the custom wrapper id" do
          output_buffer.should have_tag("li button#foo")
        end
        
        it "should use the custom class" do
          output_buffer.should have_tag("li button.bah")
        end
  
        it "should use the custom accesskey" do
          output_buffer.should have_tag('li button[@accesskey="s"]')
        end
        
      end
      
      describe "with :url" do 
        it "should raise an error" do
          lambda {
            semantic_form_for(@new_post) do |builder|
              builder.buttons do
                concat(builder.button(:commit, :as => :pretty, :url => "hello"))
              end
            end
          }.should raise_error(ArgumentError)
        end
      end
      
      describe "with :label string" do
        before do
          semantic_form_for(@new_post) do |builder|
            builder.buttons do
              concat(builder.button(:commit, :as => :pretty, :label => "Hello"))
            end
          end
        end
        
        it "should render the text" do
          output_buffer.should have_tag("button", /Hello$/)
        end
      end
      
      describe "with :label symbol and custom translation" do
        
        it "should use the key to translate" do
          ::I18n.backend.store_translations :en, :formtastic => {:create => 'hello {{model}}'}
          semantic_form_for(@new_post) do |builder|
            concat(builder.button(:commit))
          end
          output_buffer.should have_tag('li button', /hello/)
          ::I18n.backend.store_translations :en, :formtastic => nil 
        end
        
      end
      
      describe "with no :image option and image config true" do
        it "should render an image" do
          @output_buffer = ''
          with_config :pretty_buttons_with_images, true do
            semantic_form_for(@new_post) do |builder|
              concat(builder.button(:commit))
            end
            output_buffer.should have_tag("button img")
          end
        end
      end
      
      describe "with no :image option and image config false" do
        it "should render an image" do
          @output_buffer = ''
          with_config :pretty_buttons_with_images, false do
            semantic_form_for(@new_post) do |builder|
              concat(builder.button(:commit))
            end
            output_buffer.should_not have_tag("button img")
          end
        end
      end
      
      describe "with :image string" do
        before do
          @output_buffer = ''
          semantic_form_for(@new_post) do |builder|
            builder.buttons do
              concat(builder.button(:commit, :as => :pretty, :image => "hello.png"))
            end
          end
        end
        
        it "should render the text" do
          output_buffer.should have_tag('button img[@src="/images/hello.png"]')
        end
      end
      
      describe "with :image => false" do
        before do
          @output_buffer = ''
          semantic_form_for(@new_post) do |builder|
            builder.buttons do
              concat(builder.button(:commit, :as => :pretty, :image => false))
            end
          end
        end
        
        it "should not have an image tag" do
          output_buffer.should_not have_tag("button img")
        end
      end
      
    end
    
    describe ":as => :submit" do
  
      before do
        @output_buffer = ''
        semantic_form_for(@new_post) do |builder|
          builder.buttons do
            concat(builder.button(:commit, :as => :submit))
          end
        end
      end
      
      it "should render an li.submit.submit" do
        output_buffer.should have_tag('li.commit.submit')
      end
  
      it "should render a input[type=submit]" do
        output_buffer.should have_tag('li input[@type="submit"]')
      end
  
      it "should render a input with text" do
        output_buffer.should have_tag('li input[@value~="Create"]')
      end
      
      it "should not render an img" do
        output_buffer.should_not have_tag('li input img')
      end
      
      it "should use the default commit accesskey" do
        with_config :default_commit_button_accesskey, "z" do
          semantic_form_for(@new_post) do |builder|
            builder.buttons do
              concat(builder.button(:commit, :as => :submit))
            end
          end
          output_buffer.should have_tag('input[@accesskey="z"]')
        end
      end
      
      describe "with :wrapper_html" do
        before do
          semantic_form_for(@new_post) do |builder|
            builder.buttons do
              concat(builder.button(:commit, :as => :submit, :wrapper_html => { :id => "foo", :class => "bah" }))
            end
          end
        end
        
        it "should use the custom wrapper id" do
          output_buffer.should have_tag("li#foo")
        end
        
        it "should add the custom class to existing classes" do
          output_buffer.should have_tag("li.bah")
          output_buffer.should have_tag("li.commit.submit.bah")
        end
      end
      
      describe "with :button_html" do
        before do
          semantic_form_for(@new_post) do |builder|
            builder.buttons do
              concat(builder.button(:commit, :as => :submit, :button_html => { :id => "foo", :class => "bah", :accesskey => "s" }))
            end
          end
        end
        
        it "should use the custom wrapper id" do
          output_buffer.should have_tag("li input#foo")
        end
        
        it "should use the custom class" do
          output_buffer.should have_tag("li input.bah")
        end
  
        it "should use the custom accesskey" do
          output_buffer.should have_tag('li input[@accesskey="s"]')
        end
        
      end
      
      describe "with :url" do 
        it "should raise an error" do
          lambda {
            semantic_form_for(@new_post) do |builder|
              builder.buttons do
                concat(builder.button(:commit, :as => :submit, :url => "hello"))
              end
            end
          }.should raise_error(ArgumentError)
        end
      end
      
      describe "with :label string" do
        before do
          semantic_form_for(@new_post) do |builder|
            builder.buttons do
              concat(builder.button(:commit, :as => :submit, :label => "Hello"))
            end
          end
        end
        
        it "should render the text" do
          output_buffer.should have_tag('input[@value="Hello"]')
        end
      end
      
      describe "with :label symbol and custom translation" do
        
        it "should use the key to translate" do
          ::I18n.backend.store_translations :en, :formtastic => {:create => 'hello {{model}}'}
          semantic_form_for(@new_post) do |builder|
            concat(builder.button(:commit, :as => :submit))
          end
          output_buffer.should have_tag('li input[@value~="hello"]')
          ::I18n.backend.store_translations :en, :formtastic => nil
        end
        
      end
      
      describe "with :image string" do
        it "should raise ArgumentError" do
          lambda {
            semantic_form_for(@new_post) do |builder|
              builder.buttons do
                concat(builder.button(:commit, :as => :submit, :image => "hello.png"))
              end
            end
          }.should raise_error(ArgumentError)
        end
      end
      
      describe "with :image => false" do
        it "should raise ArgumentError" do
          lambda {
            semantic_form_for(@new_post) do |builder|
              builder.buttons do
                concat(builder.button(:commit, :as => :submit, :image => false))
              end
            end
          }.should raise_error(ArgumentError)
        end
      end
      
    end
    
    describe ":as => :link (not allowed)" do
      
      it "should raise ArgumentError" do
        lambda {
          semantic_form_for(@new_post) do |builder|
            concat(builder.button(:commit, :as => :link))
          end
        }.should raise_error(ArgumentError)
      end
      
    end
    
  end
  
  describe ":cancel" do
    
    before do
      # mock the controller/env because :cancel needs link_to(:back), etc
      @controller = mock()
      @controller.stub!(:request).and_return(mock())
      @controller.request.stub(:env).and_return({})
      
      @controller.stub!(:url_for).and_return("/posts/12")
    end
    
    describe "without :as option" do
      it "should render as :pretty by default" do
        @output_buffer = ''
        semantic_form_for(@new_post) do |builder|
          builder.should_receive(:pretty_button)
          concat(builder.button(:cancel))
        end
      end
    end
    
    describe ":as => :pretty" do
      
      before do
        semantic_form_for(@new_post) do |builder|
          builder.buttons do
            concat(builder.button(:cancel, :as => :pretty))
          end
        end
      end
      
      it "should render an li.cancel.pretty" do
        output_buffer.should have_tag('li.cancel.pretty')
      end
      
      it "should render an anchor" do
        output_buffer.should have_tag('li a')
      end
      
      it "should render an anchor with text" do
        output_buffer.should have_tag('li a', /Cancel/)
      end
      
      it "should render an img" do
        output_buffer.should have_tag('li a img')
      end
      
      it "should use the default commit accesskey" do
        with_config :default_cancel_button_accesskey, "z" do
          semantic_form_for(@new_post) do |builder|
            builder.buttons do
              concat(builder.button(:cancel, :as => :pretty))
            end
          end
          output_buffer.should have_tag('a[@accesskey="z"]')
        end
      end
      
      describe "with :wrapper_html" do
        before do
          semantic_form_for(@new_post) do |builder|
            builder.buttons do
              concat(builder.button(:cancel, :as => :pretty, :wrapper_html => { :id => "foo", :class => "bah" }))
            end
          end
        end
        
        it "should use the custom wrapper id" do
          output_buffer.should have_tag("li#foo")
        end
        
        it "should add the custom class to existing classes" do
          output_buffer.should have_tag("li.bah")
          output_buffer.should have_tag("li.cancel.pretty.bah")
        end
      end
      
      describe "with :button_html" do
        before do
          semantic_form_for(@new_post) do |builder|
            builder.buttons do
              concat(builder.button(:cancel, :as => :pretty, :button_html => { :id => "foo", :class => "bah", :accesskey => "s" }))
            end
          end
        end
        
        it "should use the custom wrapper id" do
          output_buffer.should have_tag("li a#foo")
        end
        
        it "should use the custom class" do
          output_buffer.should have_tag("li a.bah")
        end
      
        it "should use the custom accesskey" do
          output_buffer.should have_tag('li a[@accesskey="s"]')
        end
        
      end
      
      describe "with :url String" do 
        it "should use the url for the link" do
          @output_buffer = ''
          semantic_form_for(@new_post) do |builder|
            builder.buttons do
              concat(builder.button(:cancel, :as => :pretty, :url => "hello"))
            end
          end
          output_buffer.should have_tag('li a[@href="hello"]')
        end
      end
      
      describe "with :url Hash" do 
        it "should use the url for the link" do
          @output_buffer = ''
          
          semantic_form_for(@new_post) do |builder|
            builder.buttons do
              concat(builder.button(:cancel, :as => :pretty, :url => { :controller => "posts", :action => "show", :id => "12"}))
            end
          end
          output_buffer.should have_tag('li a[@href="/posts/12"]')
        end
      end
      
      describe "with :label string" do
        before do
          semantic_form_for(@new_post) do |builder|
            builder.buttons do
              concat(builder.button(:cancel, :as => :pretty, :label => "Hello"))
            end
          end
        end
        
        it "should render the text" do
          output_buffer.should have_tag("a", /Hello$/)
        end
      end
      
      describe "with :label symbol and custom translation" do
        
        it "should use the key to translate" do
          @output_buffer = ''
          ::I18n.backend.store_translations :en, :formtastic => {:cancel => 'hello {{model}}'}
          semantic_form_for(@new_post) do |builder|
            concat(builder.button(:cancel, :as => :pretty))
          end
          output_buffer.should have_tag('li a', /hello/)
          ::I18n.backend.store_translations :en, :formtastic => nil
        end
        
      end
      
      describe "with no :image option and image config true" do
        it "should render an image" do
          @output_buffer = ''
          with_config :pretty_buttons_with_images, true do
            semantic_form_for(@new_post) do |builder|
              concat(builder.button(:cancel, :as => :pretty))
            end
            output_buffer.should have_tag("a img")
          end
        end
      end
      
      describe "with no :image option and image config false" do
        it "should render an image" do
          @output_buffer = ''
          with_config :pretty_buttons_with_images, false do
            semantic_form_for(@new_post) do |builder|
              concat(builder.button(:cancel, :as => :pretty))
            end
            output_buffer.should_not have_tag("a img")
          end
        end
      end
      
      describe "with :image string" do
        before do
          @output_buffer = ''
          semantic_form_for(@new_post) do |builder|
            builder.buttons do
              concat(builder.button(:cancel, :as => :pretty, :image => "hello.png"))
            end
          end
        end
      
        it "should render the text" do
          output_buffer.should have_tag("a img[@src='/images/hello.png']")
        end
      end
      
      describe "with :image => false" do
        before do
          @output_buffer = ''
          semantic_form_for(@new_post) do |builder|
            builder.buttons do
              concat(builder.button(:cancel, :as => :pretty, :image => false))
            end
          end
        end
        
        it "should not have an image tag" do
          output_buffer.should_not have_tag("button img")
        end
      end
    
    end
    
    describe ":as => :link" do
      
      before do
        semantic_form_for(@new_post) do |builder|
          builder.buttons do
            concat(builder.button(:cancel, :as => :link))
          end
        end
      end
      
      it "should render an li.cancel.link" do
        output_buffer.should have_tag('li.cancel.link')
      end
      
      it "should render an anchor" do
        output_buffer.should have_tag('li a')
      end
      
      it "should render an anchor with text" do
        output_buffer.should have_tag('li a', /Cancel/)
      end
      
      it "should render an img" do
        output_buffer.should_not have_tag('li a img')
      end
      
      it "should use the default commit accesskey" do
        with_config :default_cancel_button_accesskey, "z" do
          semantic_form_for(@new_post) do |builder|
            builder.buttons do
              concat(builder.button(:cancel, :as => :link))
            end
          end
          output_buffer.should have_tag('a[@accesskey="z"]')
        end
      end
      
      describe "with :wrapper_html" do
        before do
          semantic_form_for(@new_post) do |builder|
            builder.buttons do
              concat(builder.button(:cancel, :as => :link, :wrapper_html => { :id => "foo", :class => "bah" }))
            end
          end
        end
        
        it "should use the custom wrapper id" do
          output_buffer.should have_tag("li#foo")
        end
        
        it "should add the custom class to existing classes" do
          output_buffer.should have_tag("li.bah")
          output_buffer.should have_tag("li.cancel.link.bah")
        end
      end
      
      describe "with :button_html" do
        before do
          semantic_form_for(@new_post) do |builder|
            builder.buttons do
              concat(builder.button(:cancel, :as => :pretty, :button_html => { :id => "foo", :class => "bah", :accesskey => "s" }))
            end
          end
        end
        
        it "should use the custom wrapper id" do
          output_buffer.should have_tag("li a#foo")
        end
        
        it "should use the custom class" do
          output_buffer.should have_tag("li a.bah")
        end
      
        it "should use the custom accesskey" do
          output_buffer.should have_tag('li a[@accesskey="s"]')
        end
        
      end
      
      describe "with :url" do 
        it "should use the url for the link" do
          semantic_form_for(@new_post) do |builder|
            builder.buttons do
              concat(builder.button(:cancel, :as => :link, :url => "hello"))
            end
          end
          output_buffer.should have_tag('li a[@href="hello"]')
        end
      end
      
      describe "with :label string" do
        before do
          semantic_form_for(@new_post) do |builder|
            builder.buttons do
              concat(builder.button(:cancel, :as => :link, :label => "Hello"))
            end
          end
        end
        
        it "should render the text" do
          output_buffer.should have_tag("a", /Hello$/)
        end
      end
      
      describe "with :label symbol and custom translation" do
        
        it "should use the key to translate" do
          ::I18n.backend.store_translations :en, :formtastic => {:cancel => 'hello {{model}}'}
          semantic_form_for(@new_post) do |builder|
            concat(builder.button(:cancel, :as => :link))
          end
          output_buffer.should have_tag('li a', /hello/)
          ::I18n.backend.store_translations :en, :formtastic => nil
        end
        
      end
      
      describe "with :image string (not allowed)" do
        it "should raise error" do
          lambda {
            semantic_form_for(@new_post) do |builder|
              builder.buttons do
                concat(builder.button(:cancel, :as => :link, :image => "hello.png"))
              end
            end
          }.should raise_error(ArgumentError)
        end
      end
      
    end
    
    describe ":as => :submit (not allowed)" do
      
      it "should raise ArgumentError" do
        lambda {
          semantic_form_for(@new_post) do |builder|
            concat(builder.button(:cancel, :as => :submit))
          end
        }.should raise_error(ArgumentError)
      end
      
    end
    
  end
  
  describe ":reset" do
    
    describe "without :as option" do
      it "should render as :pretty by default" do
        @output_buffer = ''
        semantic_form_for(@new_post) do |builder|
          builder.should_receive(:pretty_button)
          concat(builder.button(:reset))
        end
      end
    end
    
    describe ":as => :pretty" do
      
      before do
        semantic_form_for(@new_post) do |builder|
          builder.buttons do
            concat(builder.button(:reset, :as => :pretty))
          end
        end
      end
      
      it "should render an li.commit.pretty" do
        output_buffer.should have_tag('li.reset.pretty')
      end
  
      it "should render a button[type=submit]" do
        output_buffer.should have_tag('li button[@type="reset"]')
      end
  
      it "should render a button with text" do
        output_buffer.should have_tag('li button', /Reset/)
      end
      
    end
    
    describe ":as => :link (not allowed)" do
      
      it "should raise ArgumentError" do
        lambda {
          semantic_form_for(@new_post) do |builder|
            concat(builder.button(:reset, :as => :link))
          end
        }.should raise_error(ArgumentError)
      end
      
    end
    
    describe ":as => :submit (not allowed)" do
      
      it "should raise ArgumentError" do
        lambda {
          semantic_form_for(@new_post) do |builder|
            concat(builder.button(:reset, :as => :submit))
          end
        }.should raise_error(ArgumentError)
      end
      
    end
    
    
  end
  
end
